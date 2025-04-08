Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F183A26561C;
	Tue,  8 Apr 2025 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111417; cv=none; b=QyLfmISxCoTEE7tW2UK1Mah9Yz6z3D45Rr93WJ+PLPyrHV/8OAbtw5zoxiM5fmD7v3of6yom0qfLII8TfsnCjtZPrMzzkYSllnufDSP+F610S0YigMiXVR8pTY9k/pjO5P+OQERPz3Jm3HKnzsdvVnG6yFm5MQTazJ0w/o1I9mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111417; c=relaxed/simple;
	bh=46QaNiqj98yguQQI7JK4PlFcwE1R6gKth8q8SCJYBsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cieyGZLIt+5HgTfZGOsxTcuDOxp9YQgAuvdoYYDfnmBHksPR+Xdy+qeU8YGio7iIUmWuBsKlHOJF7h2sS3wAk6pky2y3EhOukCAGJ8zww4OoaRpxpbiZU9hJFJBvIcMup3yxbNWWuHkBVmvMJezkVxWQROZDkmTMUATHFyFeVO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sieatFIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sieatFIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1E1C4CEE5;
	Tue,  8 Apr 2025 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111416;
	bh=46QaNiqj98yguQQI7JK4PlFcwE1R6gKth8q8SCJYBsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sieatFIwX/fQN8HKmHAA0Vn2tHQmGJJufrD5aE+vpjgDB/IRxbGapFKhz8sGPvB4i
	 d3LVh+vr/lfovERvUJyRPtAUXx/2M0OgHALIsMRTk1Qle1T/cMIQxvWKUbrCC6W/dh
	 tUbjNSjcmwHkvZzeoINXC3Gy6I0o/JHqdzNQrS8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 384/731] crypto: tegra - finalize crypto req on error
Date: Tue,  8 Apr 2025 12:44:41 +0200
Message-ID: <20250408104923.207779881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 1e245948ca0c252f561792fabb45de5518301d97 ]

Call the crypto finalize function before exiting *do_one_req() functions.
This allows the driver to take up further requests even if the previous
one fails.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: b157e7a228ae ("crypto: tegra - Reserve keyslots to allocate dynamically")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index be0a0b51f5a59..a1b469c3a55ba 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -275,8 +275,10 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->datbuf.size = rctx->len;
 	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
 					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		return -ENOMEM;
+	if (!rctx->datbuf.buf) {
+		ret = -ENOMEM;
+		goto out_finalize;
+	}
 
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->src, 0, req->cryptlen, 0);
 
@@ -292,6 +294,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
+out_finalize:
 	crypto_finalize_skcipher_request(se->engine, req, ret);
 
 	return 0;
@@ -1155,21 +1158,21 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 
 	ret = tegra_ccm_crypt_init(req, se, rctx);
 	if (ret)
-		return ret;
+		goto out_finalize;
 
 	/* Allocate buffers required */
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
-		return -ENOMEM;
+		goto out_finalize;
 
 	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
 	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
-		goto outbuf_err;
+		goto out_free_inbuf;
 	}
 
 	if (rctx->encrypt) {
@@ -1198,10 +1201,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
-outbuf_err:
+out_free_inbuf:
 	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
+out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
 	return 0;
@@ -1232,15 +1236,17 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
-	if (!rctx->inbuf.buf)
-		return -ENOMEM;
+	if (!rctx->inbuf.buf) {
+		ret = -ENOMEM;
+		goto out_finalize;
+	}
 
 	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
 	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
-		goto outbuf_err;
+		goto out_free_inbuf;
 	}
 
 	/* If there is associated data perform GMAC operation */
@@ -1269,11 +1275,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
-outbuf_err:
+out_free_inbuf:
 	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
-	/* Finalize the request if there are no errors */
+out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
 	return 0;
-- 
2.39.5



