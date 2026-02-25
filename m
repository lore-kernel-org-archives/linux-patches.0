Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7144369A;
	Wed, 25 Feb 2026 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982908; cv=none; b=FjuoAprK/9Zu9DTOqFzotDTPo/fuWNJMoUtCUcVmiLyr6GtA+ZOjVZawuX/eJhqHqzxkzPFhfOL4jqsVOqa9bLUDjiyPlZ9rCl9qB405yCV2TiucPPJj4ipUKRXcM/hV/b62NqjbuWiP4gnSAfA/15E9sMgCWK5VQHVY6vLYJSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982908; c=relaxed/simple;
	bh=fUm6g5WqfmJvwp00bgoI+Lmrxlw2YoYCmX7Sf2juoSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2oxcxiaxi0aMf/MpQqWIdHr4UIo5cQYzGr81SNP63R6CfmRehbDsVNI3dkUFeRLHC055BpZxnp+ZpLOvNuQi40R0mgZltqgTjJeNaaVR2shabA/99u917E8TAE2qrDnJRQ/wwSFO6kuDUyVS+YekrBTazi6iPTKRNR+EqGgsvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEeNANxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEeNANxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAA8C116D0;
	Wed, 25 Feb 2026 01:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982908;
	bh=fUm6g5WqfmJvwp00bgoI+Lmrxlw2YoYCmX7Sf2juoSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEeNANxfKdKnQ4osdI1zOveHW1UQ6synn0c+wutKL+7//WOP3LrD92kMkXrO0Ru3p
	 ymZE/QP81R2tRXcRkEOyxiDRho+p1pwhTJKNaKutbBkAaYlt7V5tx3ZhOKOHyS3b8w
	 qvFG5z3VuQAZPyELO2+Wv2gDnDUvYpq7EtcPWGFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Tao <taoqi10@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 090/781] crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable
Date: Tue, 24 Feb 2026 17:13:19 -0800
Message-ID: <20260225012401.900448860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index d09d081f42dc7..c462b58d30343 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -663,10 +663,8 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	int i, ret;
 
 	ctx->qps = sec_create_qps();
-	if (!ctx->qps) {
-		pr_err("Can not create sec qps!\n");
+	if (!ctx->qps)
 		return -ENODEV;
-	}
 
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
@@ -702,6 +700,9 @@ static void sec_ctx_base_uninit(struct sec_ctx *ctx)
 {
 	int i;
 
+	if (!ctx->qps)
+		return;
+
 	for (i = 0; i < ctx->sec->ctx_q_num; i++)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
@@ -713,6 +714,9 @@ static int sec_cipher_init(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return 0;
+
 	c_ctx->c_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 					  &c_ctx->c_key_dma, GFP_KERNEL);
 	if (!c_ctx->c_key)
@@ -725,6 +729,9 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(c_ctx->c_key, SEC_MAX_KEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
 			  c_ctx->c_key, c_ctx->c_key_dma);
@@ -746,6 +753,9 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 
+	if (!ctx->qps)
+		return;
+
 	memzero_explicit(a_ctx->a_key, SEC_MAX_AKEY_SIZE);
 	dma_free_coherent(ctx->dev, SEC_MAX_AKEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
@@ -783,7 +793,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	}
 
 	ret = sec_ctx_base_init(ctx);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		return ret;
 
 	ret = sec_cipher_init(ctx);
@@ -892,6 +902,9 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct device *dev = ctx->dev;
 	int ret;
 
+	if (!ctx->qps)
+		goto set_soft_key;
+
 	if (c_mode == SEC_CMODE_XTS) {
 		ret = xts_verify_key(tfm, key, keylen);
 		if (ret) {
@@ -922,13 +935,14 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
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
 
@@ -1392,6 +1406,9 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	struct crypto_authenc_keys keys;
 	int ret;
 
+	if (!ctx->qps)
+		return sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
+
 	ctx->a_ctx.a_alg = a_alg;
 	ctx->c_ctx.c_alg = c_alg;
 	c_ctx->c_mode = c_mode;
@@ -2048,6 +2065,9 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 	if (ret)
 		return ret;
 
+	if (!ctx->qps)
+		return 0;
+
 	if (ctx->sec->qm.ver < QM_HW_V3) {
 		ctx->type_supported = SEC_BD_TYPE2;
 		ctx->req_op = &sec_skcipher_req_ops;
@@ -2056,7 +2076,7 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 		ctx->req_op = &sec_skcipher_req_ops_v3;
 	}
 
-	return ret;
+	return 0;
 }
 
 static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
@@ -2124,7 +2144,7 @@ static int sec_aead_ctx_init(struct crypto_aead *tfm, const char *hash_name)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		pr_err("hisi_sec2: aead init error!\n");
 		return ret;
 	}
@@ -2166,7 +2186,7 @@ static int sec_aead_xcm_ctx_init(struct crypto_aead *tfm)
 	int ret;
 
 	ret = sec_aead_init(tfm);
-	if (ret) {
+	if (ret && ret != -ENODEV) {
 		dev_err(ctx->dev, "hisi_sec2: aead xcm init error!\n");
 		return ret;
 	}
@@ -2311,6 +2331,9 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	if (!sk_req->cryptlen) {
 		if (ctx->c_ctx.c_mode == SEC_CMODE_XTS)
 			return -EINVAL;
@@ -2328,9 +2351,12 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
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
@@ -2538,6 +2564,9 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	bool need_fallback = false;
 	int ret;
 
+	if (!ctx->qps)
+		goto soft_crypto;
+
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
@@ -2548,11 +2577,14 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
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



