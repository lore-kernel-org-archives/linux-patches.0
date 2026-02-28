Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A22737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302321; cv=none; b=i017EBg6n7pZ5FV1nQ/HaeDcEhbVy3yOPZS2Kn9iMAbaY0JpAxbWeOcY3PLK+JvXWSV8ae7JcMDagqRn3yWw7So0UpnrFeLawCkJFApp3wfbCELaDFUdwQV9dYmtgsWrIdT/O6GJhetGXkn/OtWbi5luJoo6yTQJOrW2pzTWhH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302321; c=relaxed/simple;
	bh=bwSHAkNJ8OjSH39t0+HP1aYvMMYhk1WL7MVHf+rrg8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYbUsCaRHi2WUwbXN3xNnp92A0EN/jyDZKsJZ5Dmz6iTSgM9gyWNNysKe4O3vtZk7YzcGg6Ol62VIemLTINyHwhDggyyNwOkZyUfS8vbwKG9/SA3HvMsd3Qm+Tlx2NdONqER6hd3gMIhV4q6toSjWRnSpbYA0BWomPmRd0IOp0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbrigkJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbrigkJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8DEC116D0;
	Sat, 28 Feb 2026 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302320;
	bh=bwSHAkNJ8OjSH39t0+HP1aYvMMYhk1WL7MVHf+rrg8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbrigkJR3t6+ojFXeof2bM1cJRdYG3OwVynnOxkPhh++g1Gyc0ODLYzyATrCIhvR9
	 HX+ihBobA23pWFP+6TDzddYlxSifdv9KY1nQGf2+dkOThm+AUhiKKCj/ZCbrYTg1Fm
	 r7SfdaVqHklqNz+pZJjIOJn98d0ttcp9kpNKGlkUUpuC3nHkMiB+HnhXnUoVJ32NJB
	 OQN1BQPTNl0ZwuCD5yM92JoL5DWoT2l4ySsOh9ZVfgvrtUaFvc/09sK7l5ckbYG8lj
	 RztJ0f4WU+zit41gL5hod1N8v+GbWAm1Sb6769ine5wUD2a6c8OfRh3CdclpEHia1r
	 cMTJ0rC5/DSdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qi Tao <taoqi10@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/232] crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable
Date: Sat, 28 Feb 2026 13:08:12 -0500
Message-ID: <20260228181127.1592657-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qi Tao <taoqi10@huawei.com>

[ Upstream commit e7507439628052363500d717caffb5c2241854dc ]

When all hardware queues are busy and no shareable queue,
new processes fail to apply for queues. To avoid affecting
tasks, support fallback mechanism when hardware queues are
unavailable.

Fixes: c16a70c1f253 ("crypto: hisilicon/sec - add new algorithm mode for AEAD")
Signed-off-by: Qi Tao <taoqi10@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 62 ++++++++++++++++------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 91917a913512a..ae760ce85578b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -591,10 +591,8 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	int i, ret;
 
 	ctx->qps = sec_create_qps();
-	if (!ctx->qps) {
-		pr_err("Can not create sec qps!\n");
+	if (!ctx->qps)
 		return -ENODEV;
-	}
 
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
@@ -633,6 +631,9 @@ static void sec_ctx_base_uninit(struct sec_ctx *ctx)
 {
 	int i;
 
+	if (!ctx->qps)
+		return;
+
 	for (i = 0; i < ctx->sec->ctx_q_num; i++)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
@@ -644,6 +645,9 @@ static int sec_cipher_init(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return 0;
+
 	c_ctx->c_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &c_ctx->c_key_dma, GFP_KERNEL);
 	if (!c_ctx->c_key)
@@ -656,6 +660,9 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(c_ctx->c_key, SEC_MAX_KEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  c_ctx->c_key, c_ctx->c_key_dma);
@@ -677,6 +684,9 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(a_ctx->a_key, SEC_MAX_AKEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_AKEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
@@ -714,7 +724,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	}
 
 	ret = sec_ctx_base_init(ctx);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		return ret;
 
 	ret = sec_cipher_init(ctx);
@@ -825,6 +835,9 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct device *dev = ctx->dev;
 	int ret;
 
+	if (!ctx->qps)
+		goto set_soft_key;
+
 	if (c_mode == SEC_CMODE_XTS) {
 		ret = xts_verify_key(tfm, key, keylen);
 		if (ret) {
@@ -855,13 +868,14 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-	if (c_ctx->fbtfm) {
-		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
-		if (ret) {
-			dev_err(dev, "failed to set fallback skcipher key!\n");
-			return ret;
-		}
+
+set_soft_key:
+	ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
+	if (ret) {
+		dev_err(dev, "failed to set fallback skcipher key!\n");
+		return ret;
 	}
+
 	return 0;
 }
 
@@ -1140,6 +1154,9 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	struct crypto_authenc_keys keys;
 	int ret;
 
+	if (!ctx->qps)
+		return sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
+
 	ctx->a_ctx.a_alg = a_alg;
 	ctx->c_ctx.c_alg = c_alg;
 	c_ctx->c_mode = c_mode;
@@ -1836,6 +1853,9 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 	if (ret)
 		return ret;
 
+	if (!ctx->qps)
+		return 0;
+
 	if (ctx->sec->qm.ver < QM_HW_V3) {
 		ctx->type_supported = SEC_BD_TYPE2;
 		ctx->req_op = &sec_skcipher_req_ops;
@@ -1844,7 +1864,7 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 		ctx->req_op = &sec_skcipher_req_ops_v3;
 	}
 
-	return ret;
+	return 0;
 }
 
 static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
@@ -1912,7 +1932,7 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		pr_err("hisi_sec2: aead init error!\n");
 		return ret;
 	}
@@ -1954,7 +1974,7 @@ static int sec_aead_xcm_ctx_init(struct crypto_aead *tfm)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		dev_err(ctx->dev, "hisi_sec2: aead xcm init error!\n");
 		return ret;
 	}
@@ -2101,6 +2121,9 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	if (!sk_req->cryptlen) {
 		if (ctx->c_ctx.c_mode == SEC_CMODE_XTS)
 			return -EINVAL;
@@ -2117,9 +2140,12 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 		return -EINVAL;
 
 	if (unlikely(ctx->c_ctx.fallback || need_fallback))
-		return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
+		goto soft_crypto;
 
 	return ctx->req_op->process(ctx, req);
+
+soft_crypto:
+	return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
 }
 
 static int sec_skcipher_encrypt(struct skcipher_request *sk_req)
@@ -2349,6 +2375,9 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
@@ -2358,11 +2387,14 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	ret = sec_aead_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret)) {
 		if (need_fallback)
-			return sec_aead_soft_crypto(ctx, a_req, encrypt);
+			goto soft_crypto;
 		return -EINVAL;
 	}
 
 	return ctx->req_op->process(ctx, req);
+
+soft_crypto:
+	return sec_aead_soft_crypto(ctx, a_req, encrypt);
 }
 
 static int sec_aead_encrypt(struct aead_request *a_req)
-- 
2.51.0

