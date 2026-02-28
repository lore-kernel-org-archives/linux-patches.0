Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF57346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302068; cv=none; b=DEGqxrg9VwMhN4MmVziaVoyZHzMx/4eDR4te4NZlg5pCcD8z6UhZECsz59ePl01fE1cA2y5fq69QWMXwZg3apDL+JZoLvjBfxawIhpmQkc4Q7dTJ7OwkBBr3k1ldbt6b0wx7w4YVnj12xX2Z2Cd0nJvglJHxhBkNJgZFgOKwgh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302068; c=relaxed/simple;
	bh=jaQ7tiCfZM1LtrQ3dDUWqiToaERPqpoY5ZDYt2wIP68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jtok1P6tLFJ3sAA9wnsveMPKxjfh6T113B0zAFi+ne+b9ez4vQlAWqdSdVoNK/KZLFDynwDE4OZYCpLvasBEM39yvta2qo5e4p5SBIc2tuebn6MfEcFS942wxmNZsJDeJCXotNlPDN6kJK0+o0mdd8hctwQPc9PxMr31Jsjs7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnaYpfVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnaYpfVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9A3C19423;
	Sat, 28 Feb 2026 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302067;
	bh=jaQ7tiCfZM1LtrQ3dDUWqiToaERPqpoY5ZDYt2wIP68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnaYpfVIUGsIoPW4eYXvfrTpaNDSLOqx/LKtk5l4f/dNtV0oewUnkDXdRuR6NX/Uv
	 jwLoUQvtp6XlEF/TGAcOM/tcYLvWlwKKz+Z9kyKqKC8gWiaSKNijlRcUu+SaqYGoi7
	 xgK3mNQ0P77lAccnXccB7DEioIZu+VV1cO5RmAnuGhgL6k5NREqoNa8bAFR8OIiI0F
	 z6rFJeaxyLyW0DsebGqmlY2fGJxvlSO/xEA1t37uFS2sqK1xPSEcsuKrIGSDcgCiCN
	 NyXmQeLeEdqAnQecIroj5QGGXY+jc8j0T3cjKM1HRJUBsAydda+h5WzwhoS4uhMkCi
	 Gbe+oPvGcuSxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qi Tao <taoqi10@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/283] crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable
Date: Sat, 28 Feb 2026 13:03:08 -0500
Message-ID: <20260228180709.1583486-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index d6727b8ff582b..8db3d2990816e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -590,10 +590,8 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	int i, ret;
 
 	ctx->qps = sec_create_qps();
-	if (!ctx->qps) {
-		pr_err("Can not create sec qps!\n");
+	if (!ctx->qps)
 		return -ENODEV;
-	}
 
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
@@ -632,6 +630,9 @@ static void sec_ctx_base_uninit(struct sec_ctx *ctx)
 {
 	int i;
 
+	if (!ctx->qps)
+		return;
+
 	for (i = 0; i < ctx->sec->ctx_q_num; i++)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
@@ -643,6 +644,9 @@ static int sec_cipher_init(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return 0;
+
 	c_ctx->c_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &c_ctx->c_key_dma, GFP_KERNEL);
 	if (!c_ctx->c_key)
@@ -655,6 +659,9 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(c_ctx->c_key, SEC_MAX_KEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  c_ctx->c_key, c_ctx->c_key_dma);
@@ -676,6 +683,9 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(a_ctx->a_key, SEC_MAX_AKEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_AKEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
@@ -713,7 +723,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	}
 
 	ret = sec_ctx_base_init(ctx);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		return ret;
 
 	ret = sec_cipher_init(ctx);
@@ -824,6 +834,9 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct device *dev = ctx->dev;
 	int ret;
 
+	if (!ctx->qps)
+		goto set_soft_key;
+
 	if (c_mode == SEC_CMODE_XTS) {
 		ret = xts_verify_key(tfm, key, keylen);
 		if (ret) {
@@ -854,13 +867,14 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
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
 
@@ -1139,6 +1153,9 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	struct crypto_authenc_keys keys;
 	int ret;
 
+	if (!ctx->qps)
+		return sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
+
 	ctx->a_ctx.a_alg = a_alg;
 	ctx->c_ctx.c_alg = c_alg;
 	c_ctx->c_mode = c_mode;
@@ -1833,6 +1850,9 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 	if (ret)
 		return ret;
 
+	if (!ctx->qps)
+		return 0;
+
 	if (ctx->sec->qm.ver < QM_HW_V3) {
 		ctx->type_supported = SEC_BD_TYPE2;
 		ctx->req_op = &sec_skcipher_req_ops;
@@ -1841,7 +1861,7 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 		ctx->req_op = &sec_skcipher_req_ops_v3;
 	}
 
-	return ret;
+	return 0;
 }
 
 static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
@@ -1909,7 +1929,7 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		pr_err("hisi_sec2: aead init error!\n");
 		return ret;
 	}
@@ -1951,7 +1971,7 @@ static int sec_aead_xcm_ctx_init(struct crypto_aead *tfm)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		dev_err(ctx->dev, "hisi_sec2: aead xcm init error!\n");
 		return ret;
 	}
@@ -2098,6 +2118,9 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	if (!sk_req->cryptlen) {
 		if (ctx->c_ctx.c_mode == SEC_CMODE_XTS)
 			return -EINVAL;
@@ -2114,9 +2137,12 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
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
@@ -2346,6 +2372,9 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
@@ -2355,11 +2384,14 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
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

