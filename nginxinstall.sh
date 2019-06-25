#!/bin/bash
IPath=/opt
prceFile=/opt/pcre-8.35.tar.gz
nginxFile=/opt/nginx-1.15.7.tar.gz
echo "安装编译工具及库文件..."
yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel unzip
echo "首先要安装 PCRE 让 Nginx 支持 Rewrite 功能..."
if [ `pcre-config --version` == 8.32  ];then
echo "pcre已安装..."
elif [ -f "$prceFile" ];then
echo "开始解压安装包..."
tar -zxf $prceFile -C $IPath
cd $IPath/pcre-8.35
echo "开始安装配置prce..."
./configure --prefix=$IPath/prce
make && make install
pcre-config --version
else
echo "文件不存在..."
exit
fi
if [ -f "$nginxFile" ];then
tar -zxf $nginxFile -C $IPath
cd $IPath/nginx-1.15.7
rm -rf $IPath/nginx-1.15.7/nginx-goodies-nginx-sticky-module-ng-08a395c66e42.zip
rm -rf $IPath/nginx-1.15.7/nginx-goodies-nginx-sticky-module-ng-08a395c66e42
\cp -rf $IPath/nginx-goodies-nginx-sticky-module-ng-08a395c66e42.zip  $IPath/nginx-1.15.7
unzip $IPath/nginx-1.15.7/nginx-goodies-nginx-sticky-module-ng-08a395c66e42.zip
mv nginx-goodies-nginx-sticky-module-ng-08a395c66e42 sticky
./configure --prefix=/opt/nginx \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-pcre=$IPath/pcre-8.35 \
--add-module=$IPath/nginx-1.15.7/sticky
mkdir $IPath/nginx
make && make install
else 
echo "文件不存在..."
exit
fi
