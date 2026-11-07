Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064343;
	b=c/SAinC/fH+OShDa3dJ2mXQkJ9QuYwkck6cE4tspFbTeKpcOclFJJbD2GGXqOSX0peZx
	 f0W1482dJxm+tqAe27UXRZ0W7dkS0WFG/Ly0Dvc7I1igXlV/989+DBXymMDoZRt+kQxdJ
	 5/020/o2AGeHS9KP5ZqBUQL5KPkdqcm36tbyrUyImjB5pZPLxbQKR0FytHsZlPGfceFz9
	 tm8JXwjecsIM6IBKwK7HAsNcbKrFt/AevLesA0WkgYLZcrqZue80cboNZreXCvSKdrwIF
	 uS0O69iHKAiaerJQD0E1ZT8wzNXrgZYIJGnQzi0GCmkegxFx0dnLeQRLdjIU7ECp6og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I+lvDbzMyGWcqC3/FJ0k4WqpvaoLWgrybN37KAXO0Sk=;
	b=PYKt+aE+2lhdNK5eqvboZSErMfq/7NDYyeiYHPo6wite+7wQ9/BkOlRJs1YDZ6mBV2HA
	 l6lo2zs+wZgxjtuXoLS6zkMwR+62I5sT1C1AEcfdhPfj/jpmz0GuP7LF7WmGfTt4HJrBW
	 WB5azj4sDLyPpt0U9gs9oY9T9AD+UQ5eutUjtzH4h7e70gB1QTEaEnPTnkDqbrI30/zze
	 9/wFiOKT1B8SrpEEATRwjMTjlxvKQwIXnUWyihw73PdI2goKFd6OBaA3pI/JTk1YT+yS/
	 T9pB2Tyn6ZdivR6znVazmGctNUkzPxAIAymaiSDxLIXO6gecKc8RER2OF8mBnSRIw9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIdWGwt+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA7C606A33A;
	Sat,  7 Nov 2026 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aIdWGwt+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C21F008A1;
	Sat,  7 Nov 2026 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064343;
	bh=I+lvDbzMyGWcqC3/FJ0k4WqpvaoLWgrybN37KAXO0Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIdWGwt+/e0zknZyBVkhuC3AZZLflhyZji43e0sOb48Si1BBNKYHqag1011HOklQR
	 /oW6Smsh1S7IfS5ri270+Ish+osakFN6AAZgHSZ2qPMYcS+6qTvYYxxOJ9yYiy+Cil
	 JzxPIRw4/RiWJeFUqNC1RQEabkPOSzLRGhZR1884=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0429/1257] crypto: sa2ul - Fix HMAC key preparation
Date: Sat,  7 Nov 2026 08:45:25 -0500
Message-ID: <20261107134951.339733178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 780cd10c8e78f97ed768be229acff0ffd5483477 ]

sa_prepare_iopads() has multiple bugs, as discussed at
https://lore.kernel.org/linux-crypto/20260831055141.1632832-1-s-vadapalli@ti.com/T/#u

- Commit 3bf533787910 ("crypto: sha256 - Use the partial block API")
  introduced a 1-byte buffer overflow in the SHA-256 case by making the
  crypto_shash_export() write 1 more than sizeof(struct sha256_state).

- It never worked for HMAC keys longer than 64 bytes in the first place.

Fix both of these bugs by just using the crypto library to prepare the
key, like what the chelsio and qat drivers do.  Also remove the
pointless use of an indirect call.

Fixes: 3bf533787910 ("crypto: sha256 - Use the partial block API")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 121 +++++++++--------------------------------
 1 file changed, 27 insertions(+), 94 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9846cbeb3449c..255334b6b0db9 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -125,9 +125,7 @@ struct sa_cmdl_cfg {
  * @mci_enc: Mode Control Instruction for Encryption algorithm
  * @mci_dec: Mode Control Instruction for Decryption
  * @inv_key: Whether the encryption algorithm demands key inversion
- * @ctx: Pointer to the algorithm context
  * @keyed_mac: Whether the authentication algorithm has key
- * @prep_iopad: Function pointer to generate intermediate ipad/opad
  */
 struct algo_data {
 	struct sa_eng_info enc_eng;
@@ -141,10 +139,7 @@ struct algo_data {
 	u8 *mci_enc;
 	u8 *mci_dec;
 	bool inv_key;
-	struct sa_tfm_ctx *ctx;
 	bool keyed_mac;
-	void (*prep_iopad)(struct algo_data *algo, const u8 *key,
-			   u16 key_sz, __be32 *ipad, __be32 *opad);
 };
 
 /**
@@ -381,86 +376,36 @@ static void sa_swiz_128(u8 *in, u16 len)
 	}
 }
 
-/* Prepare the ipad and opad from key as per SHA algorithm step 1*/
-static void prepare_kipad(u8 *k_ipad, const u8 *key, u16 key_sz)
+static void sa_prepare_iopads(struct algo_data *data, const u8 *key, u16 key_sz,
+			      __be32 *ipad, __be32 *opad)
 {
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_ipad[i] = key[i] ^ 0x36;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_ipad[i] = 0x36;
-}
-
-static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
-{
-	int i;
-
-	for (i = 0; i < key_sz; i++)
-		k_opad[i] = key[i] ^ 0x5c;
-
-	/* Instead of XOR with 0 */
-	for (; i < SHA1_BLOCK_SIZE; i++)
-		k_opad[i] = 0x5c;
-}
-
-static void sa_export_shash(void *state, struct shash_desc *hash,
-			    int digest_size, __be32 *out)
-{
-	struct sha1_state *sha1;
-	struct sha256_state *sha256;
-	u32 *result;
-
-	switch (digest_size) {
-	case SHA1_DIGEST_SIZE:
-		sha1 = state;
-		result = sha1->state;
+	union {
+		struct hmac_sha1_key sha1;
+		struct hmac_sha256_key sha256;
+	} k;
+
+	switch (data->aalg_id) {
+	case SA_AALG_ID_HMAC_SHA1:
+		hmac_sha1_preparekey(&k.sha1, key, key_sz);
+		cpu_to_be32_array(ipad, k.sha1.istate.h,
+				  ARRAY_SIZE(k.sha1.istate.h));
+		cpu_to_be32_array(opad, k.sha1.ostate.h,
+				  ARRAY_SIZE(k.sha1.ostate.h));
 		break;
-	case SHA256_DIGEST_SIZE:
-		sha256 = state;
-		result = sha256->state;
+	case SA_AALG_ID_HMAC_SHA2_256:
+		hmac_sha256_preparekey(&k.sha256, key, key_sz);
+		cpu_to_be32_array(ipad, k.sha256.key.istate.h,
+				  ARRAY_SIZE(k.sha256.key.istate.h));
+		cpu_to_be32_array(opad, k.sha256.key.ostate.h,
+				  ARRAY_SIZE(k.sha256.key.ostate.h));
 		break;
 	default:
-		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
-			digest_size);
+		dev_err(sa_k3_dev, "%s: bad aalg_id=%d\n", __func__,
+			data->aalg_id);
 		return;
 	}
 
-	crypto_shash_export(hash, state);
-
-	cpu_to_be32_array(out, result, digest_size / 4);
-}
-
-static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
-			      u16 key_sz, __be32 *ipad, __be32 *opad)
-{
-	SHASH_DESC_ON_STACK(shash, data->ctx->shash);
-	int block_size = crypto_shash_blocksize(data->ctx->shash);
-	int digest_size = crypto_shash_digestsize(data->ctx->shash);
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		u8 k_pad[SHA1_BLOCK_SIZE];
-	} sha;
-
-	shash->tfm = data->ctx->shash;
-
-	prepare_kipad(sha.k_pad, key, key_sz);
-
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-	sa_export_shash(&sha, shash, digest_size, ipad);
-
-	prepare_kopad(sha.k_pad, key, key_sz);
-
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-
-	sa_export_shash(&sha, shash, digest_size, opad);
-
-	memzero_explicit(&sha, sizeof(sha));
+	memzero_explicit(&k, sizeof(k));
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
@@ -544,7 +489,7 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 
 	/* Copy the keys or ipad/opad */
 	if (ad->keyed_mac)
-		ad->prep_iopad(ad, key, key_sz, ipad, opad);
+		sa_prepare_iopads(ad, key, key_sz, ipad, opad);
 	else {
 		/* basic hash */
 		sc_buf[1] |= SA_BASIC_HASH;
@@ -1697,8 +1642,7 @@ static void sa_aead_dma_in_callback(void *data)
 	aead_request_complete(req, err);
 }
 
-static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
-			    const char *fallback)
+static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 {
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
@@ -1707,12 +1651,6 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	memzero_explicit(ctx, sizeof(*ctx));
 	ctx->dev_data = data;
 
-	ctx->shash = crypto_alloc_shash(hash, 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->shash)) {
-		dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n", hash);
-		return PTR_ERR(ctx->shash);
-	}
-
 	ctx->fallback.aead = crypto_alloc_aead(fallback, 0,
 					       CRYPTO_ALG_NEED_FALLBACK);
 
@@ -1744,14 +1682,12 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "sha1",
-				"authenc(hmac(sha1),cbc(aes))");
+	return sa_cra_init_aead(tfm, "authenc(hmac(sha1),cbc(aes))");
 }
 
 static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "sha256",
-				"authenc(hmac(sha256),cbc(aes))");
+	return sa_cra_init_aead(tfm, "authenc(hmac(sha256),cbc(aes))");
 }
 
 static void sa_exit_tfm_aead(struct crypto_aead *tfm)
@@ -1759,7 +1695,6 @@ static void sa_exit_tfm_aead(struct crypto_aead *tfm)
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 
-	crypto_free_shash(ctx->shash);
 	crypto_free_aead(ctx->fallback.aead);
 
 	sa_free_ctx_info(&ctx->enc, data);
@@ -1785,7 +1720,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	if (key_idx >= 3)
 		return -EINVAL;
 
-	ad->ctx = ctx;
 	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
 	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
 	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
@@ -1795,7 +1729,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	ad->inv_key = true;
 	ad->keyed_mac = true;
 	ad->ealg_id = SA_EALG_ID_AES_CBC;
-	ad->prep_iopad = sa_prepare_iopads;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.enc = true;
-- 
2.53.0



