FROM ubuntu:trusty-20160503.1
MAINTAINER Suk Heo <tobby48@gmail.com>

# Add R list
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' | sudo tee -a /etc/apt/sources.list.d/r.list && \
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# packages
# Run update
RUN apt-get update
RUN apt-get -qq -y install software-properties-common python-software-properties

# Install external programs
RUN apt-get -qq -y install python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update

# it automate to accept the oracle license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

RUN apt-get update
RUN apt-get -qq -y install oracle-java8-installer

RUN apt-get update && apt-get install -yq --no-install-recommends --force-yes \
        wget \
	unzip \
        libjansi-java \
        libsvn1 \
        libcurl3 \
        libsasl2-modules && \
        rm -rf /var/lib/apt/lists/*

# Overall ENV vars
ENV SPARK_VERSION 2.1.0

# Spark ENV vars
ENV SPARK_VERSION_STRING spark-$SPARK_VERSION-bin-hadoop2.7
ENV SPARK_DOWNLOAD_URL http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION_STRING.tgz
ENV SPARK_HOME /apps/spark
ENV SPARK_LOG $SPARK_HOME/logs

# Download and unzip Spark
RUN wget $SPARK_DOWNLOAD_URL && \
    mkdir -p $SPARK_HOME && \
    tar xvf $SPARK_VERSION_STRING.tgz -C /tmp && \
    cp -rf /tmp/$SPARK_VERSION_STRING/* $SPARK_HOME && \
    chown -R root:root $SPARK_HOME && \
    rm -rf -- /tmp/$SPARK_VERSION_STRING && \
    rm $SPARK_VERSION_STRING.tgz

# Set Volume
VOLUME ["/apps/spark/logs"]

WORKDIR $SPARK_HOME
