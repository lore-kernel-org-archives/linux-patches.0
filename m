Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E3228B4F4;
	Wed, 23 Apr 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422559; cv=none; b=Ppz341xsb4edIvyr6kc5B2b5rjoJrd9xexg8t/nNV39nL7A5T4npIFMj4+jbtYZR7ExudwMxed+SktNl/VzZ+SOBpUoKt2+qZWxM4fbbkBf21z/h66xZV+zbKAfOTleeA/JjIvuCEXbsqkod12ubVVk9vj2qI//0OxTkvqBkmFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422559; c=relaxed/simple;
	bh=50DalK0XPDk523mJa4R1DN0yhLHipOobd00H1NFZ+D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P50uvxEkQQLCn/YlR6F0q2h3AOp9ZhaFhUueZu6BlpqAyP5L4vNGjuVrlVGZRta/l3G2eUl3yaRCU98BQP2vs1W0neOunm+oG+CZn5k7rzV8YuVzvKKPU61X3JmqQXp17jlsryGsUpG6T0Rw61okLhpiZRvo8+9R3ezBkEylVFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9U5IiMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9U5IiMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCC3C4CEE3;
	Wed, 23 Apr 2025 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422559;
	bh=50DalK0XPDk523mJa4R1DN0yhLHipOobd00H1NFZ+D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9U5IiMGO9gvbcZGzGb5mk6WxOcEf3LIzh/nG+tOeogWmju44K7B8T9jVUImOorjg
	 KYeMKlWmEYgnIP/0miDjO9zk0+oyQIGf9fMrSIWKrj63TIB0hwxBvlHSfX0K5PAaBb
	 JJepS5dGyhBUxBPEeLXcU7+p0wUNkCK4eVC48w1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Neal Gompa <neal@gompa.dev>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 388/393] sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3
Date: Wed, 23 Apr 2025 16:44:44 +0200
Message-ID: <20250423142659.345588371@linuxfoundation.org>
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

commit 558bdc45dfb2669e1741384a0c80be9c82fa052c upstream.

ENGINE API has been deprecated since OpenSSL version 3.0 [1].
Distros have started dropping support from headers and in future
it will likely disappear also from library.

It has been superseded by the PROVIDER API, so use it instead
for OPENSSL MAJOR >= 3.

[1] https://github.com/openssl/openssl/blob/master/README-ENGINES.md

[jarkko: fixed up alignment issues reported by checkpatch.pl --strict]

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 certs/extract-cert.c |  103 ++++++++++++++++++++++++++++++++++++---------------
 scripts/sign-file.c  |   95 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 139 insertions(+), 59 deletions(-)

--- a/certs/extract-cert.c
+++ b/certs/extract-cert.c
@@ -21,17 +21,18 @@
 #include <openssl/bio.h>
 #include <openssl/pem.h>
 #include <openssl/err.h>
-#include <openssl/engine.h>
-
+#if OPENSSL_VERSION_MAJOR >= 3
+# define USE_PKCS11_PROVIDER
+# include <openssl/provider.h>
+# include <openssl/store.h>
+#else
+# if !defined(OPENSSL_NO_ENGINE) && !defined(OPENSSL_NO_DEPRECATED_3_0)
+#  define USE_PKCS11_ENGINE
+#  include <openssl/engine.h>
+# endif
+#endif
 #include "ssl-common.h"
 
-/*
- * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
- *
- * Remove this if/when that API is no longer used
- */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
@@ -61,6 +62,66 @@ static void write_cert(X509 *x509)
 		fprintf(stderr, "Extracted cert: %s\n", buf);
 }
 
+static X509 *load_cert_pkcs11(const char *cert_src)
+{
+	X509 *cert = NULL;
+#ifdef USE_PKCS11_PROVIDER
+	OSSL_STORE_CTX *store;
+
+	if (!OSSL_PROVIDER_try_load(NULL, "pkcs11", true))
+		ERR(1, "OSSL_PROVIDER_try_load(pkcs11)");
+	if (!OSSL_PROVIDER_try_load(NULL, "default", true))
+		ERR(1, "OSSL_PROVIDER_try_load(default)");
+
+	store = OSSL_STORE_open(cert_src, NULL, NULL, NULL, NULL);
+	ERR(!store, "OSSL_STORE_open");
+
+	while (!OSSL_STORE_eof(store)) {
+		OSSL_STORE_INFO *info = OSSL_STORE_load(store);
+
+		if (!info) {
+			drain_openssl_errors(__LINE__, 0);
+			continue;
+		}
+		if (OSSL_STORE_INFO_get_type(info) == OSSL_STORE_INFO_CERT) {
+			cert = OSSL_STORE_INFO_get1_CERT(info);
+			ERR(!cert, "OSSL_STORE_INFO_get1_CERT");
+		}
+		OSSL_STORE_INFO_free(info);
+		if (cert)
+			break;
+	}
+	OSSL_STORE_close(store);
+#elif defined(USE_PKCS11_ENGINE)
+		ENGINE *e;
+		struct {
+			const char *cert_id;
+			X509 *cert;
+		} parms;
+
+		parms.cert_id = cert_src;
+		parms.cert = NULL;
+
+		ENGINE_load_builtin_engines();
+		drain_openssl_errors(__LINE__, 1);
+		e = ENGINE_by_id("pkcs11");
+		ERR(!e, "Load PKCS#11 ENGINE");
+		if (ENGINE_init(e))
+			drain_openssl_errors(__LINE__, 1);
+		else
+			ERR(1, "ENGINE_init");
+		if (key_pass)
+			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
+		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
+		ERR(!parms.cert, "Get X.509 from PKCS#11");
+		cert = parms.cert;
+#else
+		fprintf(stderr, "no pkcs11 engine/provider available\n");
+		exit(1);
+#endif
+	return cert;
+}
+
 int main(int argc, char **argv)
 {
 	char *cert_src;
@@ -89,28 +150,10 @@ int main(int argc, char **argv)
 		fclose(f);
 		exit(0);
 	} else if (!strncmp(cert_src, "pkcs11:", 7)) {
-		ENGINE *e;
-		struct {
-			const char *cert_id;
-			X509 *cert;
-		} parms;
-
-		parms.cert_id = cert_src;
-		parms.cert = NULL;
+		X509 *cert = load_cert_pkcs11(cert_src);
 
-		ENGINE_load_builtin_engines();
-		drain_openssl_errors(__LINE__, 1);
-		e = ENGINE_by_id("pkcs11");
-		ERR(!e, "Load PKCS#11 ENGINE");
-		if (ENGINE_init(e))
-			drain_openssl_errors(__LINE__, 1);
-		else
-			ERR(1, "ENGINE_init");
-		if (key_pass)
-			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
-		ENGINE_ctrl_cmd(e, "LOAD_CERT_CTRL", 0, &parms, NULL, 1);
-		ERR(!parms.cert, "Get X.509 from PKCS#11");
-		write_cert(parms.cert);
+		ERR(!cert, "load_cert_pkcs11 failed");
+		write_cert(cert);
 	} else {
 		BIO *b;
 		X509 *x509;
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -27,18 +27,19 @@
 #include <openssl/evp.h>
 #include <openssl/pem.h>
 #include <openssl/err.h>
-#include <openssl/engine.h>
-
+#if OPENSSL_VERSION_MAJOR >= 3
+# define USE_PKCS11_PROVIDER
+# include <openssl/provider.h>
+# include <openssl/store.h>
+#else
+# if !defined(OPENSSL_NO_ENGINE) && !defined(OPENSSL_NO_DEPRECATED_3_0)
+#  define USE_PKCS11_ENGINE
+#  include <openssl/engine.h>
+# endif
+#endif
 #include "ssl-common.h"
 
 /*
- * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
- *
- * Remove this if/when that API is no longer used
- */
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-
-/*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
  * should use PKCS#7 instead.  Switching to the older PKCS#7 format restricts
@@ -106,28 +107,64 @@ static int pem_pw_cb(char *buf, int len,
 	return pwlen;
 }
 
-static EVP_PKEY *read_private_key(const char *private_key_name)
+static EVP_PKEY *read_private_key_pkcs11(const char *private_key_name)
 {
-	EVP_PKEY *private_key;
+	EVP_PKEY *private_key = NULL;
+#ifdef USE_PKCS11_PROVIDER
+	OSSL_STORE_CTX *store;
+
+	if (!OSSL_PROVIDER_try_load(NULL, "pkcs11", true))
+		ERR(1, "OSSL_PROVIDER_try_load(pkcs11)");
+	if (!OSSL_PROVIDER_try_load(NULL, "default", true))
+		ERR(1, "OSSL_PROVIDER_try_load(default)");
+
+	store = OSSL_STORE_open(private_key_name, NULL, NULL, NULL, NULL);
+	ERR(!store, "OSSL_STORE_open");
+
+	while (!OSSL_STORE_eof(store)) {
+		OSSL_STORE_INFO *info = OSSL_STORE_load(store);
+
+		if (!info) {
+			drain_openssl_errors(__LINE__, 0);
+			continue;
+		}
+		if (OSSL_STORE_INFO_get_type(info) == OSSL_STORE_INFO_PKEY) {
+			private_key = OSSL_STORE_INFO_get1_PKEY(info);
+			ERR(!private_key, "OSSL_STORE_INFO_get1_PKEY");
+		}
+		OSSL_STORE_INFO_free(info);
+		if (private_key)
+			break;
+	}
+	OSSL_STORE_close(store);
+#elif defined(USE_PKCS11_ENGINE)
+	ENGINE *e;
+
+	ENGINE_load_builtin_engines();
+	drain_openssl_errors(__LINE__, 1);
+	e = ENGINE_by_id("pkcs11");
+	ERR(!e, "Load PKCS#11 ENGINE");
+	if (ENGINE_init(e))
+		drain_openssl_errors(__LINE__, 1);
+	else
+		ERR(1, "ENGINE_init");
+	if (key_pass)
+		ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0), "Set PKCS#11 PIN");
+	private_key = ENGINE_load_private_key(e, private_key_name, NULL, NULL);
+	ERR(!private_key, "%s", private_key_name);
+#else
+	fprintf(stderr, "no pkcs11 engine/provider available\n");
+	exit(1);
+#endif
+	return private_key;
+}
 
+static EVP_PKEY *read_private_key(const char *private_key_name)
+{
 	if (!strncmp(private_key_name, "pkcs11:", 7)) {
-		ENGINE *e;
-
-		ENGINE_load_builtin_engines();
-		drain_openssl_errors(__LINE__, 1);
-		e = ENGINE_by_id("pkcs11");
-		ERR(!e, "Load PKCS#11 ENGINE");
-		if (ENGINE_init(e))
-			drain_openssl_errors(__LINE__, 1);
-		else
-			ERR(1, "ENGINE_init");
-		if (key_pass)
-			ERR(!ENGINE_ctrl_cmd_string(e, "PIN", key_pass, 0),
-			    "Set PKCS#11 PIN");
-		private_key = ENGINE_load_private_key(e, private_key_name,
-						      NULL, NULL);
-		ERR(!private_key, "%s", private_key_name);
+		return read_private_key_pkcs11(private_key_name);
 	} else {
+		EVP_PKEY *private_key;
 		BIO *b;
 
 		b = BIO_new_file(private_key_name, "rb");
@@ -136,9 +173,9 @@ static EVP_PKEY *read_private_key(const
 						      NULL);
 		ERR(!private_key, "%s", private_key_name);
 		BIO_free(b);
-	}
 
-	return private_key;
+		return private_key;
+	}
 }
 
 static X509 *read_x509(const char *x509_name)


