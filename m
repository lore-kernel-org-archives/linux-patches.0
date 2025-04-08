Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27102270EDC;
	Tue,  8 Apr 2025 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116340; cv=none; b=Mn9p3d8P8dfngIV4DWy1YQlvKj823QgPVcLphUwe9QatuoZdDdN+iBJ9Vkg4YTxEQqa1MewigSyxHnLPnEmQpNn1DaGR/Aicb2U5/6eD8jVDqAosv+ivdutqo0ZZj/ZG5cZX2Vbes1MOJ5rV7aX4FVeC6UEvG5nNWnaRDSvDdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116340; c=relaxed/simple;
	bh=AykICj6O1uQ3bp4JF4uDVfRwuWVux7trcptdqqQSq0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tvxt7VXXvEwhJwLP78+3xsz+9jbJgLiUxjLDi1GTtp9MkOaLL5Bjck7Yvknh9q7WP9zx5k1jP7UMmGfhnzVnNQtWW6lCgcyDnYWhJRuPJWfHVleaXTcXpSqiIc8MS5SVblsE45ODNp7ZqLnEAC2N7Lnra7E5ekw+ql1dBTbd4+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIxRre2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIxRre2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB960C4CEE5;
	Tue,  8 Apr 2025 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116340;
	bh=AykICj6O1uQ3bp4JF4uDVfRwuWVux7trcptdqqQSq0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIxRre2oW1PqEg1OVL1hL0vIDrJtlQbQVP7laNunAF0X63UepzFo4lbkFaRsPWxVY
	 KH6r8tsvQq6+41Xy4jMPt5FQ4+pk56u57rcbbEHx/huNtlyErP1T6Lj9Ibge189B5Z
	 j1n25cip6oZCucCoe2w/bu3acsaRUCCCEAXdj4PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenkai Lin <linwenkai6@hisilicon.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/423] crypto: hisilicon/sec2 - fix for sec spec check
Date: Tue,  8 Apr 2025 12:47:11 +0200
Message-ID: <20250408104848.182532467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenkai Lin <linwenkai6@hisilicon.com>

[ Upstream commit f4f353cb7ae9bb43e34943edb693532a39118eca ]

During encryption and decryption, user requests
must be checked first, if the specifications that
are not supported by the hardware are used, the
software computing is used for processing.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 101 ++++++++-------------
 2 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 30c2b1a64695c..2fc04e210bc4f 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -37,7 +37,6 @@ struct sec_aead_req {
 	u8 *a_ivin;
 	dma_addr_t a_ivin_dma;
 	struct aead_request *aead_req;
-	bool fallback;
 };
 
 /* SEC request of Crypto */
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index ff9ad7f02cefe..0d2917b3e8158 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -690,14 +690,10 @@ static int sec_skcipher_fbtfm_init(struct crypto_skcipher *tfm)
 
 	c_ctx->fallback = false;
 
-	/* Currently, only XTS mode need fallback tfm when using 192bit key */
-	if (likely(strncmp(alg, "xts", SEC_XTS_NAME_SZ)))
-		return 0;
-
 	c_ctx->fbtfm = crypto_alloc_sync_skcipher(alg, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(c_ctx->fbtfm)) {
-		pr_err("failed to alloc xts mode fallback tfm!\n");
+		pr_err("failed to alloc fallback tfm for %s!\n", alg);
 		return PTR_ERR(c_ctx->fbtfm);
 	}
 
@@ -857,7 +853,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-	if (c_ctx->fallback && c_ctx->fbtfm) {
+	if (c_ctx->fbtfm) {
 		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
 		if (ret) {
 			dev_err(dev, "failed to set fallback skcipher key!\n");
@@ -1159,8 +1155,10 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	}
 
 	ret = crypto_authenc_extractkeys(&keys, key, keylen);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "sec extract aead keys err!\n");
 		goto bad_key;
+	}
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
 	if (ret) {
@@ -1174,12 +1172,6 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
-	if (ctx->a_ctx.a_key_len & WORD_MASK) {
-		ret = -EINVAL;
-		dev_err(dev, "AUTH key length error!\n");
-		goto bad_key;
-	}
-
 	ret = sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
 	if (ret) {
 		dev_err(dev, "set sec fallback key err!\n");
@@ -1999,8 +1991,7 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
-static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
-	struct sec_req *sreq)
+static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	u32 cryptlen = sreq->c_req.sk_req->cryptlen;
 	struct device *dev = ctx->dev;
@@ -2022,10 +2013,6 @@ static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
 		}
 		break;
 	case SEC_CMODE_CTR:
-		if (unlikely(ctx->sec->qm.ver < QM_HW_V3)) {
-			dev_err(dev, "skcipher HW version error!\n");
-			ret = -EINVAL;
-		}
 		break;
 	default:
 		ret = -EINVAL;
@@ -2034,17 +2021,21 @@ static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
 	return ret;
 }
 
-static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+static int sec_skcipher_param_check(struct sec_ctx *ctx,
+				    struct sec_req *sreq, bool *need_fallback)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
-	if (unlikely(!sk_req->src || !sk_req->dst ||
-		     sk_req->cryptlen > MAX_INPUT_DATA_LEN)) {
+	if (unlikely(!sk_req->src || !sk_req->dst)) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
+
+	if (sk_req->cryptlen > MAX_INPUT_DATA_LEN)
+		*need_fallback = true;
+
 	sreq->c_req.c_len = sk_req->cryptlen;
 
 	if (ctx->pbuf_supported && sk_req->cryptlen <= SEC_PBUF_SZ)
@@ -2102,6 +2093,7 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(sk_req);
 	struct sec_req *req = skcipher_request_ctx(sk_req);
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool need_fallback = false;
 	int ret;
 
 	if (!sk_req->cryptlen) {
@@ -2115,11 +2107,11 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
 
-	ret = sec_skcipher_param_check(ctx, req);
+	ret = sec_skcipher_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret))
 		return -EINVAL;
 
-	if (unlikely(ctx->c_ctx.fallback))
+	if (unlikely(ctx->c_ctx.fallback || need_fallback))
 		return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
 
 	return ctx->req_op->process(ctx, req);
@@ -2227,52 +2219,35 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	size_t sz = crypto_aead_authsize(tfm);
 	u8 c_mode = ctx->c_ctx.c_mode;
-	struct device *dev = ctx->dev;
 	int ret;
 
-	/* Hardware does not handle cases where authsize is not 4 bytes aligned */
-	if (c_mode == SEC_CMODE_CBC && (sz & WORD_MASK)) {
-		sreq->aead_req.fallback = true;
+	if (unlikely(ctx->sec->qm.ver == QM_HW_V2 && !sreq->c_req.c_len))
 		return -EINVAL;
-	}
 
 	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
-	    req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(dev, "aead input spec error!\n");
+		     req->assoclen > SEC_MAX_AAD_LEN))
 		return -EINVAL;
-	}
 
 	if (c_mode == SEC_CMODE_CCM) {
-		if (unlikely(req->assoclen > SEC_MAX_CCM_AAD_LEN)) {
-			dev_err_ratelimited(dev, "CCM input aad parameter is too long!\n");
+		if (unlikely(req->assoclen > SEC_MAX_CCM_AAD_LEN))
 			return -EINVAL;
-		}
-		ret = aead_iv_demension_check(req);
-		if (ret) {
-			dev_err(dev, "aead input iv param error!\n");
-			return ret;
-		}
-	}
 
-	if (sreq->c_req.encrypt)
-		sreq->c_req.c_len = req->cryptlen;
-	else
-		sreq->c_req.c_len = req->cryptlen - sz;
-	if (c_mode == SEC_CMODE_CBC) {
-		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
-			dev_err(dev, "aead crypto length error!\n");
+		ret = aead_iv_demension_check(req);
+		if (unlikely(ret))
+			return -EINVAL;
+	} else if (c_mode == SEC_CMODE_CBC) {
+		if (unlikely(sz & WORD_MASK))
+			return -EINVAL;
+		if (unlikely(ctx->a_ctx.a_key_len & WORD_MASK))
 			return -EINVAL;
-		}
 	}
 
 	return 0;
 }
 
-static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq, bool *need_fallback)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	size_t authsize = crypto_aead_authsize(tfm);
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
@@ -2281,12 +2256,10 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		return -EINVAL;
 	}
 
-	if (ctx->sec->qm.ver == QM_HW_V2) {
-		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
-			     req->cryptlen <= authsize))) {
-			sreq->aead_req.fallback = true;
-			return -EINVAL;
-		}
+	if (unlikely(ctx->c_ctx.c_mode == SEC_CMODE_CBC &&
+		     sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
+		dev_err(dev, "aead cbc mode input data length error!\n");
+		return -EINVAL;
 	}
 
 	/* Support AES or SM4 */
@@ -2295,8 +2268,10 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		return -EINVAL;
 	}
 
-	if (unlikely(sec_aead_spec_check(ctx, sreq)))
+	if (unlikely(sec_aead_spec_check(ctx, sreq))) {
+		*need_fallback = true;
 		return -EINVAL;
+	}
 
 	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
 		SEC_PBUF_SZ)
@@ -2340,17 +2315,19 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
 	struct sec_req *req = aead_request_ctx(a_req);
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
+	size_t sz = crypto_aead_authsize(tfm);
+	bool need_fallback = false;
 	int ret;
 
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
-	req->aead_req.fallback = false;
+	req->c_req.c_len = a_req->cryptlen - (req->c_req.encrypt ? 0 : sz);
 
-	ret = sec_aead_param_check(ctx, req);
+	ret = sec_aead_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret)) {
-		if (req->aead_req.fallback)
+		if (need_fallback)
 			return sec_aead_soft_crypto(ctx, a_req, encrypt);
 		return -EINVAL;
 	}
-- 
2.39.5



