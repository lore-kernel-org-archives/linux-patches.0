Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8641FE461;
	Tue,  3 Dec 2024 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240157; cv=none; b=CUDcKu5n2+k91NlIFvLLgDjtk4F+AYrOlsWT2+t/FLO53VPbF0onih7kA4C+gioqJ8q6G1OJnc5SwrKZ9UIH+rto5WLv6SfwUmqMxqE04d2QqysUx41y7r27jCFnN8lp6lrqLc3ULoMJ70L8r68JTHhvCF48vPifAzp6XXgcJ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240157; c=relaxed/simple;
	bh=FR8XUxI8qTsxXOupuj/KcUmgN2QiaWp+lw5FXmdEuJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGnUMmN7ZNpHIrgP+6/kvtwPqgY1//N4r7PbZhqBhECNagc/O7jkihRTmIiENJR6SWt9anyMgMHqp70IF9pG9/4t6lX3S8VFfH9j60FszriNMnGqWpC3ePLhOCkE3fkHKqnw1t4IDoB154BsAq9z5B3aau4pteoCUg7eUXNfmqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1o6BLm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1o6BLm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035F7C4CECF;
	Tue,  3 Dec 2024 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240157;
	bh=FR8XUxI8qTsxXOupuj/KcUmgN2QiaWp+lw5FXmdEuJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1o6BLm0Ok4t+ikhc3gOeZ9zSrwg1atk5SKcZxlB3QErNtL7gMQvCNbPjEdYWyTm9
	 8XsYHySINgolk1+P9MOE7vKIzGS5AOgN3Bkhpax1KmI4xsi/YYICHF9KZVU8vQ9W5Q
	 kllNl0UdHOZh3py26Abs/IfH9L+7k0X3qiyJ5kq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Tsen <dtsen@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/826] crypto: powerpc/p10-aes-gcm - Register modules as SIMD
Date: Tue,  3 Dec 2024 15:36:10 +0100
Message-ID: <20241203144745.143525056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Tsen <dtsen@linux.ibm.com>

[ Upstream commit c954b252dee956d33ee59f594710af28fb3037d9 ]

This patch is to fix an issue when simd is not usable that data mismatch
may occur. The fix is to register algs as SIMD modules so that the
algorithm is excecuted when SIMD instructions is usable.  Called
gcm_update() to generate the final digest if needed.

A new module rfc4106(gcm(aes)) is also added.

Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitched implementation")

Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 141 +++++++++++++++++++++----
 1 file changed, 118 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index f66ad56e765f0..4a029d2fe06ce 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -8,6 +8,7 @@
 #include <linux/unaligned.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
+#include <crypto/gcm.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/b128ops.h>
@@ -24,6 +25,7 @@
 
 #define	PPC_ALIGN		16
 #define GCM_IV_SIZE		12
+#define RFC4106_NONCE_SIZE	4
 
 MODULE_DESCRIPTION("PPC64le AES-GCM with Stitched implementation");
 MODULE_AUTHOR("Danny Tsen <dtsen@linux.ibm.com");
@@ -31,7 +33,7 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("aes");
 
 asmlinkage int aes_p10_set_encrypt_key(const u8 *userKey, const int bits,
-				      void *key);
+				       void *key);
 asmlinkage void aes_p10_encrypt(const u8 *in, u8 *out, const void *key);
 asmlinkage void aes_p10_gcm_encrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
@@ -39,7 +41,8 @@ asmlinkage void aes_p10_gcm_decrypt(u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
 asmlinkage void gcm_init_htable(unsigned char htable[], unsigned char Xi[]);
 asmlinkage void gcm_ghash_p10(unsigned char *Xi, unsigned char *Htable,
-		unsigned char *aad, unsigned int alen);
+			      unsigned char *aad, unsigned int alen);
+asmlinkage void gcm_update(u8 *iv, void *Xi);
 
 struct aes_key {
 	u8 key[AES_MAX_KEYLENGTH];
@@ -52,6 +55,7 @@ struct gcm_ctx {
 	u8 aad_hash[16];
 	u64 aadLen;
 	u64 Plen;	/* offset 56 - used in aes_p10_gcm_{en/de}crypt */
+	u8 pblock[16];
 };
 struct Hash_ctx {
 	u8 H[16];	/* subkey */
@@ -60,17 +64,20 @@ struct Hash_ctx {
 
 struct p10_aes_gcm_ctx {
 	struct aes_key enc_key;
+	u8 nonce[RFC4106_NONCE_SIZE];
 };
 
 static void vsx_begin(void)
 {
 	preempt_disable();
+	pagefault_disable();
 	enable_kernel_vsx();
 }
 
 static void vsx_end(void)
 {
 	disable_kernel_vsx();
+	pagefault_enable();
 	preempt_enable();
 }
 
@@ -185,7 +192,7 @@ static int set_authsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 
 static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
-			     unsigned int keylen)
+			      unsigned int keylen)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
 	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -198,7 +205,8 @@ static int p10_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	return ret ? -EINVAL : 0;
 }
 
-static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
+static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
+			     int assoclen, int enc)
 {
 	struct crypto_tfm *tfm = req->base.tfm;
 	struct p10_aes_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -210,7 +218,6 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
 	struct skcipher_walk walk;
 	u8 *assocmem = NULL;
 	u8 *assoc;
-	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	unsigned char ivbuf[AES_BLOCK_SIZE+PPC_ALIGN];
 	unsigned char *iv = PTR_ALIGN((void *)ivbuf, PPC_ALIGN);
@@ -218,11 +225,12 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
 	unsigned long auth_tag_len = crypto_aead_authsize(__crypto_aead_cast(tfm));
 	u8 otag[16];
 	int total_processed = 0;
+	int nbytes;
 
 	memset(databuf, 0, sizeof(databuf));
 	memset(hashbuf, 0, sizeof(hashbuf));
 	memset(ivbuf, 0, sizeof(ivbuf));
-	memcpy(iv, req->iv, GCM_IV_SIZE);
+	memcpy(iv, riv, GCM_IV_SIZE);
 
 	/* Linearize assoc, if not already linear */
 	if (req->src->length >= assoclen && req->src->length) {
@@ -257,19 +265,25 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
 	if (ret)
 		return ret;
 
-	while (walk.nbytes > 0 && ret == 0) {
+	while ((nbytes = walk.nbytes) > 0 && ret == 0) {
+		u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
+
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf, src, nbytes);
 
 		vsx_begin();
 		if (enc)
-			aes_p10_gcm_encrypt(walk.src.virt.addr,
-					    walk.dst.virt.addr,
-					    walk.nbytes,
+			aes_p10_gcm_encrypt(src, dst, nbytes,
 					    &ctx->enc_key, gctx->iv, hash->Htable);
 		else
-			aes_p10_gcm_decrypt(walk.src.virt.addr,
-					    walk.dst.virt.addr,
-					    walk.nbytes,
+			aes_p10_gcm_decrypt(src, dst, nbytes,
 					    &ctx->enc_key, gctx->iv, hash->Htable);
+
+		if (unlikely(nbytes > 0 && nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, buf, nbytes);
+
 		vsx_end();
 
 		total_processed += walk.nbytes;
@@ -281,6 +295,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
 
 	/* Finalize hash */
 	vsx_begin();
+	gcm_update(gctx->iv, hash->Htable);
 	finish_tag(gctx, hash, total_processed);
 	vsx_end();
 
@@ -302,17 +317,63 @@ static int p10_aes_gcm_crypt(struct aead_request *req, int enc)
 	return 0;
 }
 
+static int rfc4106_setkey(struct crypto_aead *tfm, const u8 *inkey,
+			  unsigned int keylen)
+{
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+	int err;
+
+	keylen -= RFC4106_NONCE_SIZE;
+	err = p10_aes_gcm_setkey(tfm, inkey, keylen);
+	if (err)
+		return err;
+
+	memcpy(ctx->nonce, inkey + keylen, RFC4106_NONCE_SIZE);
+	return 0;
+}
+
+static int rfc4106_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	return crypto_rfc4106_check_authsize(authsize);
+}
+
+static int rfc4106_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, ctx->nonce, RFC4106_NONCE_SIZE);
+	memcpy(iv + RFC4106_NONCE_SIZE, req->iv, GCM_RFC4106_IV_SIZE);
+
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       p10_aes_gcm_crypt(req, iv, req->assoclen - GCM_RFC4106_IV_SIZE, 1);
+}
+
+static int rfc4106_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct p10_aes_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	u8 iv[AES_BLOCK_SIZE];
+
+	memcpy(iv, ctx->nonce, RFC4106_NONCE_SIZE);
+	memcpy(iv + RFC4106_NONCE_SIZE, req->iv, GCM_RFC4106_IV_SIZE);
+
+	return crypto_ipsec_check_assoclen(req->assoclen) ?:
+	       p10_aes_gcm_crypt(req, iv, req->assoclen - GCM_RFC4106_IV_SIZE, 0);
+}
+
 static int p10_aes_gcm_encrypt(struct aead_request *req)
 {
-	return p10_aes_gcm_crypt(req, 1);
+	return p10_aes_gcm_crypt(req, req->iv, req->assoclen, 1);
 }
 
 static int p10_aes_gcm_decrypt(struct aead_request *req)
 {
-	return p10_aes_gcm_crypt(req, 0);
+	return p10_aes_gcm_crypt(req, req->iv, req->assoclen, 0);
 }
 
-static struct aead_alg gcm_aes_alg = {
+static struct aead_alg gcm_aes_algs[] = {{
 	.ivsize			= GCM_IV_SIZE,
 	.maxauthsize		= 16,
 
@@ -321,23 +382,57 @@ static struct aead_alg gcm_aes_alg = {
 	.encrypt		= p10_aes_gcm_encrypt,
 	.decrypt		= p10_aes_gcm_decrypt,
 
-	.base.cra_name		= "gcm(aes)",
-	.base.cra_driver_name	= "aes_gcm_p10",
+	.base.cra_name		= "__gcm(aes)",
+	.base.cra_driver_name	= "__aes_gcm_p10",
 	.base.cra_priority	= 2100,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct p10_aes_gcm_ctx),
+	.base.cra_ctxsize	= sizeof(struct p10_aes_gcm_ctx)+
+				  4 * sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
-};
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+}, {
+	.ivsize			= GCM_RFC4106_IV_SIZE,
+	.maxauthsize		= 16,
+	.setkey			= rfc4106_setkey,
+	.setauthsize		= rfc4106_setauthsize,
+	.encrypt		= rfc4106_encrypt,
+	.decrypt		= rfc4106_decrypt,
+
+	.base.cra_name		= "__rfc4106(gcm(aes))",
+	.base.cra_driver_name	= "__rfc4106_aes_gcm_p10",
+	.base.cra_priority	= 2100,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct p10_aes_gcm_ctx) +
+				  4 * sizeof(u64[2]),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+}};
+
+static struct simd_aead_alg *p10_simd_aeads[ARRAY_SIZE(gcm_aes_algs)];
 
 static int __init p10_init(void)
 {
-	return crypto_register_aead(&gcm_aes_alg);
+	int ret;
+
+	if (!cpu_has_feature(PPC_FEATURE2_ARCH_3_1))
+		return 0;
+
+	ret = simd_register_aeads_compat(gcm_aes_algs,
+					 ARRAY_SIZE(gcm_aes_algs),
+					 p10_simd_aeads);
+	if (ret) {
+		simd_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs),
+				      p10_simd_aeads);
+		return ret;
+	}
+	return 0;
 }
 
 static void __exit p10_exit(void)
 {
-	crypto_unregister_aead(&gcm_aes_alg);
+	simd_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs),
+			      p10_simd_aeads);
 }
 
-module_cpu_feature_match(PPC_MODULE_FEATURE_P10, p10_init);
+module_init(p10_init);
 module_exit(p10_exit);
-- 
2.43.0



