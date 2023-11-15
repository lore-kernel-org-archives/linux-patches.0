Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FDA3A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUYI2b6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD34C433C7;
	Wed, 15 Nov 2023 19:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077629;
	bh=5WX9PJpssMJHJNRLGctKNoPOkL+DnBP6pHZVn1+cFnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUYI2b6X051UcQFzSUmxKIQalEEwm+WFGbZwWW/0CtHnh+MN/D01cup091PoTsrru
	 kPDvHTeAwvCuzv7IZH4rXxcqEPJIPqzR14F4JRmDGFfwNARCzGTJI9mGcKoWjxspQa
	 hVo9lB20D7XxHIc1v8irdkbZSPm2ptcTfPy6sipE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 399/603] certs: Break circular dependency when selftest is modular
Date: Wed, 15 Nov 2023 14:15:44 -0500
Message-ID: <20231115191640.659547000@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 04a93202ed7c3b451bf22d3ff4bcd379df27f299 ]

The modular build fails because the self-test code depends on pkcs7
which in turn depends on x509 which contains the self-test.

Split the self-test out into its own module to break the cycle.

Fixes: 3cde3174eb91 ("certs: Add FIPS selftests")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/Kconfig           |  3 ++-
 crypto/asymmetric_keys/Makefile          |  3 ++-
 crypto/asymmetric_keys/selftest.c        | 13 ++++++++++---
 crypto/asymmetric_keys/x509_parser.h     |  9 ---------
 crypto/asymmetric_keys/x509_public_key.c |  8 +-------
 5 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 1ef3b46d6f6e5..59ec726b7c770 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -76,7 +76,7 @@ config SIGNED_PE_FILE_VERIFICATION
 	  signed PE binary.
 
 config FIPS_SIGNATURE_SELFTEST
-	bool "Run FIPS selftests on the X.509+PKCS7 signature verification"
+	tristate "Run FIPS selftests on the X.509+PKCS7 signature verification"
 	help
 	  This option causes some selftests to be run on the signature
 	  verification code, using some built in data.  This is required
@@ -84,5 +84,6 @@ config FIPS_SIGNATURE_SELFTEST
 	depends on KEYS
 	depends on ASYMMETRIC_KEY_TYPE
 	depends on PKCS7_MESSAGE_PARSER=X509_CERTIFICATE_PARSER
+	depends on X509_CERTIFICATE_PARSER
 
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 0d1fa1b692c6b..1a273d6df3ebf 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -22,7 +22,8 @@ x509_key_parser-y := \
 	x509_cert_parser.o \
 	x509_loader.o \
 	x509_public_key.o
-x509_key_parser-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += selftest.o
+obj-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += x509_selftest.o
+x509_selftest-y += selftest.o
 
 $(obj)/x509_cert_parser.o: \
 	$(obj)/x509.asn1.h \
diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index fa0bf7f242849..c50da7ef90ae9 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -4,10 +4,11 @@
  * Written by David Howells (dhowells@redhat.com)
  */
 
-#include <linux/kernel.h>
+#include <crypto/pkcs7.h>
 #include <linux/cred.h>
+#include <linux/kernel.h>
 #include <linux/key.h>
-#include <crypto/pkcs7.h>
+#include <linux/module.h>
 #include "x509_parser.h"
 
 struct certs_test {
@@ -175,7 +176,7 @@ static const struct certs_test certs_tests[] __initconst = {
 	TEST(certs_selftest_1_data, certs_selftest_1_pkcs7),
 };
 
-int __init fips_signature_selftest(void)
+static int __init fips_signature_selftest(void)
 {
 	struct key *keyring;
 	int ret, i;
@@ -222,3 +223,9 @@ int __init fips_signature_selftest(void)
 	key_put(keyring);
 	return 0;
 }
+
+late_initcall(fips_signature_selftest);
+
+MODULE_DESCRIPTION("X.509 self tests");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index a299c9c56f409..97a886cbe01c3 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -40,15 +40,6 @@ struct x509_certificate {
 	bool		blacklisted;
 };
 
-/*
- * selftest.c
- */
-#ifdef CONFIG_FIPS_SIGNATURE_SELFTEST
-extern int __init fips_signature_selftest(void);
-#else
-static inline int fips_signature_selftest(void) { return 0; }
-#endif
-
 /*
  * x509_cert_parser.c
  */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 7c71db3ac23d4..6a4f00be22fc1 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -262,15 +262,9 @@ static struct asymmetric_key_parser x509_key_parser = {
 /*
  * Module stuff
  */
-extern int __init certs_selftest(void);
 static int __init x509_key_init(void)
 {
-	int ret;
-
-	ret = register_asymmetric_key_parser(&x509_key_parser);
-	if (ret < 0)
-		return ret;
-	return fips_signature_selftest();
+	return register_asymmetric_key_parser(&x509_key_parser);
 }
 
 static void __exit x509_key_exit(void)
-- 
2.42.0



