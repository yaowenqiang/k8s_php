FROM  php:5.6.40-cli-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add  autoconf
RUN apk add  gcc
RUN apk add  g++
RUN apk add  make
RUN pecl install -o -f redis-2.2.7  &&  rm -rf /tmp/pear  &&  docker-php-ext-enable redis
RUN #pecl install -o -f pdo_mysql  &&  rm -rf /tmp/pear  &&  docker-php-ext-enable redis
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd \
      --with-gd \
          --with-freetype-dir=/usr/include/ \
              --with-png-dir=/usr/include/ \
                  --with-jpeg-dir=/usr/include/ && \
                    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
                      docker-php-ext-install -j${NPROC} gd && \
                        apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev
CMD ["php", "-m"]
