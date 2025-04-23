Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A3928A3E1;
	Wed, 23 Apr 2025 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422554; cv=none; b=rbyxRLF4JGNp8m0TjU6oVhDUteXcC+tZqy7YgXK74Uy6QmVoszq3g+vS57KhiQEo+FoQwnGlxSCYVx84yV8jP3/mnmMrKndlR1qkSx/Mtm2myEOOe+vODz7oggGm+xRYqVzktWP6S+stRDCEBiQ8ifsB4LeWqq2YKDJ5arOQv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422554; c=relaxed/simple;
	bh=f69ZN3Kv6plWewp0kVICOnCsvOFm9G4JcRBVxoDmrA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HG82PuYl5KNyd1X6nPv/wnhQ/FTQVJ5EUfTZMCqIfdyO84mjx9G7FNFYjgLQk32xV2/gF+JPEE6a/zO7511hE7PcVEdFon2LwcLz+a6jksEV+NJpMYjA9holRfTHE1mGWYp2amoVnnG0+PSScwmP/PPl8UbBRwrWPYjpE8+Oc78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/Hj0buR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/Hj0buR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396C1C4CEE3;
	Wed, 23 Apr 2025 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422553;
	bh=f69ZN3Kv6plWewp0kVICOnCsvOFm9G4JcRBVxoDmrA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/Hj0buReImMvu7whR/W8okMa8kC/Ht8DFXVvYJw1Qfa9VD2bxTMQEaXxXyBpTl55
	 ZO0cplKctGVrSC4yF6/IzPcCypkbHjgelKrj3kb+r5F+bULrgxyR6P8vc7vPmdEEST
	 pqfxnAdsggQ3/wNYwDSL4enAh09L6QVBfTnHSe4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Neal Gompa <neal@gompa.dev>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 386/393] sign-file,extract-cert: move common SSL helper functions to a header
Date: Wed, 23 Apr 2025 16:44:42 +0200
Message-ID: <20250423142659.263262510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

commit 300e6d4116f956b035281ec94297dc4dc8d4e1d3 upstream.

Couple error handling helpers are repeated in both tools, so
move them to a common header.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS          |    1 +
 certs/Makefile       |    2 +-
 certs/extract-cert.c |   37 ++-----------------------------------
 scripts/sign-file.c  |   37 ++-----------------------------------
 scripts/ssl-common.h |   39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 45 insertions(+), 71 deletions(-)
 create mode 100644 scripts/ssl-common.h

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4784,6 +4784,7 @@ S:	Maintained
 F:	Documentation/admin-guide/module-signing.rst
 F:	certs/
 F:	scripts/sign-file.c
+F:	scripts/ssl-common.h
 F:	tools/certs/
 
 CFAG12864B LCD DRIVER
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -84,5 +84,5 @@ targets += x509_revocation_list
 
 hostprogs := extract-cert
 
-HOSTCFLAGS_extract-cert.o = $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null)
+HOSTCFLAGS_extract-cert.o = $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null) -I$(srctree)/scripts
 HOSTLDLIBS_extract-cert = $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)
--- a/certs/extract-cert.c
+++ b/certs/extract-cert.c
@@ -23,6 +23,8 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+#include "ssl-common.h"
+
 /*
  * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
  *
@@ -40,41 +42,6 @@ void format(void)
 	exit(2);
 }
 
-static void display_openssl_errors(int l)
-{
-	const char *file;
-	char buf[120];
-	int e, line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	fprintf(stderr, "At main.c:%d:\n", l);
-
-	while ((e = ERR_get_error_line(&file, &line))) {
-		ERR_error_string(e, buf);
-		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
-	}
-}
-
-static void drain_openssl_errors(void)
-{
-	const char *file;
-	int line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	while (ERR_get_error_line(&file, &line)) {}
-}
-
-#define ERR(cond, fmt, ...)				\
-	do {						\
-		bool __cond = (cond);			\
-		display_openssl_errors(__LINE__);	\
-		if (__cond) {				\
-			err(1, fmt, ## __VA_ARGS__);	\
-		}					\
-	} while(0)
-
 static const char *key_pass;
 static BIO *wb;
 static char *cert_dst;
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -29,6 +29,8 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+#include "ssl-common.h"
+
 /*
  * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
  *
@@ -83,41 +85,6 @@ void format(void)
 	exit(2);
 }
 
-static void display_openssl_errors(int l)
-{
-	const char *file;
-	char buf[120];
-	int e, line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	fprintf(stderr, "At main.c:%d:\n", l);
-
-	while ((e = ERR_get_error_line(&file, &line))) {
-		ERR_error_string(e, buf);
-		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
-	}
-}
-
-static void drain_openssl_errors(void)
-{
-	const char *file;
-	int line;
-
-	if (ERR_peek_error() == 0)
-		return;
-	while (ERR_get_error_line(&file, &line)) {}
-}
-
-#define ERR(cond, fmt, ...)				\
-	do {						\
-		bool __cond = (cond);			\
-		display_openssl_errors(__LINE__);	\
-		if (__cond) {				\
-			errx(1, fmt, ## __VA_ARGS__);	\
-		}					\
-	} while(0)
-
 static const char *key_pass;
 
 static int pem_pw_cb(char *buf, int len, int w, void *v)
--- /dev/null
+++ b/scripts/ssl-common.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: LGPL-2.1+ */
+/*
+ * SSL helper functions shared by sign-file and extract-cert.
+ */
+
+static void display_openssl_errors(int l)
+{
+	const char *file;
+	char buf[120];
+	int e, line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	fprintf(stderr, "At main.c:%d:\n", l);
+
+	while ((e = ERR_get_error_line(&file, &line))) {
+		ERR_error_string(e, buf);
+		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
+	}
+}
+
+static void drain_openssl_errors(void)
+{
+	const char *file;
+	int line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	while (ERR_get_error_line(&file, &line)) {}
+}
+
+#define ERR(cond, fmt, ...)				\
+	do {						\
+		bool __cond = (cond);			\
+		display_openssl_errors(__LINE__);	\
+		if (__cond) {				\
+			errx(1, fmt, ## __VA_ARGS__);	\
+		}					\
+	} while (0)


