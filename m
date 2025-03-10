Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9B17CA12;
	Mon, 10 Mar 2025 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628925; cv=none; b=ALP3RgO7Wj3HwrErUtE6l4oAd4k/Fx2xOEo+ClM6qwQemGkbV/sPWmOLPQwte1Wba1fCASCsCE4sqhMy+y0jFPJvEVgTc7t7/jMsPX1WvzKEfJnZZqTWnjmFdGmkf3ACCKo2zE2EMCcS8RsfmuyLOCPFX6YzXb1+yq1o67Wdpm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628925; c=relaxed/simple;
	bh=c53ed6WC/8IFonWm9fSPQj2m/h2mzgxOuBUOQc7hRT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdezMVPgLXgCDSfwgamPjWvMiFPfvkizsJDtmkN44/JtvrJZunulvzv6UbiNJFwY8mSshmzVyzjgWMYbahOliCB+h1kctT24KzbjNp1W7rvJNf3wZm0Zg+tBM/OvhqOkcss1Q95py52m18xM+7sXxg1OKIEMxoqhEwOmRnXNNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY/5UHLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY/5UHLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9130BC4CEE5;
	Mon, 10 Mar 2025 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628925;
	bh=c53ed6WC/8IFonWm9fSPQj2m/h2mzgxOuBUOQc7hRT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY/5UHLBlz0GlTkkoL5QJCRbhO6gf2Tv2PbDrGUTSxZVWSs2uZ8A+N6FNvMTi8xel
	 mSTGiIghB08OwymnPk8IwxPIUZu9ffqsBQr2QNNIhmACc0L7CmCndPbsfzOjq04+oN
	 FeBxBNRQwg9w/pSf6UBeo32sMsHkUuJ/sAlljIfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Ye <yekai13@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/620] crypto: hisilicon/sec - add some comments for soft fallback
Date: Mon, 10 Mar 2025 17:58:51 +0100
Message-ID: <20250310170548.939039271@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit e764d81d58070e66e61fb1b972c81eb9d2ea971e ]

Modify the print of information that might lead to user misunderstanding.
Currently only XTS mode need the fallback tfm when using 192bit key.
Others algs not need soft fallback tfm. So others algs can return
directly.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: fd337f852b26 ("crypto: hisilicon/sec2 - fix for aead icv error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 28c167e1be426..c8fa964238e7d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -643,13 +643,15 @@ static int sec_skcipher_fbtfm_init(struct crypto_skcipher *tfm)
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
 
 	c_ctx->fallback = false;
+
+	/* Currently, only XTS mode need fallback tfm when using 192bit key */
 	if (likely(strncmp(alg, "xts", SEC_XTS_NAME_SZ)))
 		return 0;
 
 	c_ctx->fbtfm = crypto_alloc_sync_skcipher(alg, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(c_ctx->fbtfm)) {
-		pr_err("failed to alloc fallback tfm!\n");
+		pr_err("failed to alloc xts mode fallback tfm!\n");
 		return PTR_ERR(c_ctx->fbtfm);
 	}
 
@@ -810,7 +812,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-	if (c_ctx->fallback) {
+	if (c_ctx->fallback && c_ctx->fbtfm) {
 		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
 		if (ret) {
 			dev_err(dev, "failed to set fallback skcipher key!\n");
@@ -2034,13 +2036,12 @@ static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
 				    struct skcipher_request *sreq, bool encrypt)
 {
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, c_ctx->fbtfm);
 	struct device *dev = ctx->dev;
 	int ret;
 
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, c_ctx->fbtfm);
-
 	if (!c_ctx->fbtfm) {
-		dev_err(dev, "failed to check fallback tfm\n");
+		dev_err_ratelimited(dev, "the soft tfm isn't supported in the current system.\n");
 		return -EINVAL;
 	}
 
@@ -2258,7 +2259,6 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	if (ctx->sec->qm.ver == QM_HW_V2) {
 		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
 		    req->cryptlen <= authsize))) {
-			dev_err(dev, "Kunpeng920 not support 0 length!\n");
 			ctx->a_ctx.fallback = true;
 			return -EINVAL;
 		}
-- 
2.39.5



