Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A5920CCD8;
	Tue,  8 Apr 2025 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114488; cv=none; b=jAa95KIy2LrZ+TfhubJm3CsywC5rsDSaMzlV1NbeZfkybJCFA14oEoYVUBvN35DKS/7NBi1BERoR79Gq8RibjysUX6rOo6+KnL5vxcdptb6lUxaLt96+EzwWaRVuwhXcggZ2f1eMX0BVBcJj2Jxi3rTQ7kN7F6v+X0DVwdsmvag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114488; c=relaxed/simple;
	bh=q3pFBO05705j6K3gV0Fj3/FNB3Ae8QILMftpC3netV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szgIRiytCzWHTMFuiauZ4gkap05SsuhggssCChK+Gu1iHyQ1IE7lXLhFsgT1Nr8PzU3At7AoruhvXsI7oroWNbm42m6AzOx/SMDsOjhY+q4xqQCTryWUTnP+rlaR6gQ+YvmCW5ji3U+sTnSW9pNZDmIYKKGmT+B3GNUKSJaNvPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6dANGgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6dANGgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E2C4CEE5;
	Tue,  8 Apr 2025 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114488;
	bh=q3pFBO05705j6K3gV0Fj3/FNB3Ae8QILMftpC3netV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6dANGgqStWtpetE7Nbyq8KfbTjsGIUpUVIRtK+KzIFmyoRNJuX/gULp5GXU5r5v/
	 XUg4s794EXaclnUBRDP21w+zJ9rWzgqOGy7XQNKkPLVikuYVz0gn5LMsSaRCUyZ4lz
	 nwSHXmUKEZD1H7GvWA/bkCf5PqqQ2fb6uNEjYkyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 123/499] crypto: tegra - Do not use fixed size buffers
Date: Tue,  8 Apr 2025 12:45:35 +0200
Message-ID: <20250408104854.269254510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 1cb328da4e8f34350c61a2b6548766c79b4bb64c ]

Allocate the buffer based on the request instead of a fixed buffer
length. In operations which may require larger buffer size, a fixed
buffer may fail.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 124 ++++++++++++++-------------
 drivers/crypto/tegra/tegra-se-hash.c |  38 +++++---
 drivers/crypto/tegra/tegra-se.h      |   2 -
 3 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 7da7e169a314b..c2b8891a905dc 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -263,12 +263,6 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	unsigned int cmdlen;
 	int ret;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_AES_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		return -ENOMEM;
-
-	rctx->datbuf.size = SE_AES_BUFLEN;
 	rctx->iv = (u32 *)req->iv;
 	rctx->len = req->cryptlen;
 
@@ -278,6 +272,12 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 			rctx->len += AES_BLOCK_SIZE - (rctx->len % AES_BLOCK_SIZE);
 	}
 
+	rctx->datbuf.size = rctx->len;
+	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->src, 0, req->cryptlen, 0);
 
 	/* Prepare the command and submit for execution */
@@ -289,7 +289,7 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->dst, 0, req->cryptlen, 1);
 
 	/* Free the buffer */
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
 	crypto_finalize_skcipher_request(se->engine, req, ret);
@@ -1117,6 +1117,11 @@ static int tegra_ccm_crypt_init(struct aead_request *req, struct tegra_se *se,
 	rctx->assoclen = req->assoclen;
 	rctx->authsize = crypto_aead_authsize(tfm);
 
+	if (rctx->encrypt)
+		rctx->cryptlen = req->cryptlen;
+	else
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
+
 	memcpy(iv, req->iv, 16);
 
 	ret = tegra_ccm_check_iv(iv);
@@ -1145,30 +1150,26 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_se *se = ctx->se;
 	int ret;
 
+	ret = tegra_ccm_crypt_init(req, se, rctx);
+	if (ret)
+		return ret;
+
 	/* Allocate buffers required */
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
 		return -ENOMEM;
 
-	rctx->inbuf.size = SE_AES_BUFLEN;
-
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
 		goto outbuf_err;
 	}
 
-	rctx->outbuf.size = SE_AES_BUFLEN;
-
-	ret = tegra_ccm_crypt_init(req, se, rctx);
-	if (ret)
-		goto out;
-
 	if (rctx->encrypt) {
-		rctx->cryptlen = req->cryptlen;
-
 		/* CBC MAC Operation */
 		ret = tegra_ccm_compute_auth(ctx, rctx);
 		if (ret)
@@ -1179,8 +1180,6 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 		if (ret)
 			goto out;
 	} else {
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
-
 		/* CTR operation */
 		ret = tegra_ccm_do_ctr(ctx, rctx);
 		if (ret)
@@ -1193,11 +1192,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	}
 
 out:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 outbuf_err:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
@@ -1213,23 +1212,6 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_aead_reqctx *rctx = aead_request_ctx(req);
 	int ret;
 
-	/* Allocate buffers required */
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
-					     &rctx->inbuf.addr, GFP_KERNEL);
-	if (!rctx->inbuf.buf)
-		return -ENOMEM;
-
-	rctx->inbuf.size = SE_AES_BUFLEN;
-
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, SE_AES_BUFLEN,
-					      &rctx->outbuf.addr, GFP_KERNEL);
-	if (!rctx->outbuf.buf) {
-		ret = -ENOMEM;
-		goto outbuf_err;
-	}
-
-	rctx->outbuf.size = SE_AES_BUFLEN;
-
 	rctx->src_sg = req->src;
 	rctx->dst_sg = req->dst;
 	rctx->assoclen = req->assoclen;
@@ -1243,6 +1225,21 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
 
+	/* Allocate buffers required */
+	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+					     &rctx->inbuf.addr, GFP_KERNEL);
+	if (!rctx->inbuf.buf)
+		return -ENOMEM;
+
+	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+					      &rctx->outbuf.addr, GFP_KERNEL);
+	if (!rctx->outbuf.buf) {
+		ret = -ENOMEM;
+		goto outbuf_err;
+	}
+
 	/* If there is associated data perform GMAC operation */
 	if (rctx->assoclen) {
 		ret = tegra_gcm_do_gmac(ctx, rctx);
@@ -1266,11 +1263,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		ret = tegra_gcm_do_verify(ctx->se, rctx);
 
 out:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 outbuf_err:
-	dma_free_coherent(ctx->se->dev, SE_AES_BUFLEN,
+	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	/* Finalize the request if there are no errors */
@@ -1497,6 +1494,11 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 		return 0;
 	}
 
+	rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	/* Copy the previous residue first */
 	if (rctx->residue.size)
 		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
@@ -1529,6 +1531,9 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	if (!(rctx->task & SHA_FINAL))
 		tegra_cmac_copy_result(ctx->se, rctx);
 
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+			  rctx->datbuf.buf, rctx->datbuf.addr);
+
 	return ret;
 }
 
@@ -1543,10 +1548,20 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 
 	if (!req->nbytes && !rctx->total_len && ctx->fallback_tfm) {
 		return crypto_shash_tfm_digest(ctx->fallback_tfm,
-					rctx->datbuf.buf, 0, req->result);
+					NULL, 0, req->result);
+	}
+
+	if (rctx->residue.size) {
+		rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->residue.size,
+						      &rctx->datbuf.addr, GFP_KERNEL);
+		if (!rctx->datbuf.buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
 	}
 
-	memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
 	rctx->datbuf.size = rctx->residue.size;
 	rctx->total_len += rctx->residue.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
@@ -1565,8 +1580,10 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 		writel(0, se->base + se->hw->regs->result + (i * 4));
 
 out:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN,
-			  rctx->datbuf.buf, rctx->datbuf.addr);
+	if (rctx->residue.size)
+		dma_free_coherent(se->dev, rctx->datbuf.size,
+				  rctx->datbuf.buf, rctx->datbuf.addr);
+out_free:
 	dma_free_coherent(se->dev, crypto_ahash_blocksize(tfm) * 2,
 			  rctx->residue.buf, rctx->residue.addr);
 	return ret;
@@ -1672,28 +1689,15 @@ static int tegra_cmac_init(struct ahash_request *req)
 	rctx->residue.buf = dma_alloc_coherent(se->dev, rctx->blk_size * 2,
 					       &rctx->residue.addr, GFP_KERNEL);
 	if (!rctx->residue.buf)
-		goto resbuf_fail;
+		return -ENOMEM;
 
 	rctx->residue.size = 0;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_SHA_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		goto datbuf_fail;
-
-	rctx->datbuf.size = 0;
-
 	/* Clear any previous result */
 	for (i = 0; i < CMAC_RESULT_REG_COUNT; i++)
 		writel(0, se->base + se->hw->regs->result + (i * 4));
 
 	return 0;
-
-datbuf_fail:
-	dma_free_coherent(se->dev, rctx->blk_size, rctx->residue.buf,
-			  rctx->residue.addr);
-resbuf_fail:
-	return -ENOMEM;
 }
 
 static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index c7b2a062a03c0..b4a179a8febd5 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -332,6 +332,11 @@ static int tegra_sha_do_update(struct ahash_request *req)
 		return 0;
 	}
 
+	rctx->datbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->datbuf.size,
+					      &rctx->datbuf.addr, GFP_KERNEL);
+	if (!rctx->datbuf.buf)
+		return -ENOMEM;
+
 	/* Copy the previous residue first */
 	if (rctx->residue.size)
 		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
@@ -368,6 +373,9 @@ static int tegra_sha_do_update(struct ahash_request *req)
 	if (!(rctx->task & SHA_FINAL))
 		tegra_sha_copy_hash_result(se, rctx);
 
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+			  rctx->datbuf.buf, rctx->datbuf.addr);
+
 	return ret;
 }
 
@@ -380,7 +388,17 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	u32 *cpuvaddr = se->cmdbuf->addr;
 	int size, ret = 0;
 
-	memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
+	if (rctx->residue.size) {
+		rctx->datbuf.buf = dma_alloc_coherent(se->dev, rctx->residue.size,
+						      &rctx->datbuf.addr, GFP_KERNEL);
+		if (!rctx->datbuf.buf) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		memcpy(rctx->datbuf.buf, rctx->residue.buf, rctx->residue.size);
+	}
+
 	rctx->datbuf.size = rctx->residue.size;
 	rctx->total_len += rctx->residue.size;
 
@@ -397,8 +415,10 @@ static int tegra_sha_do_final(struct ahash_request *req)
 	memcpy(req->result, rctx->digest.buf, rctx->digest.size);
 
 out:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN,
-			  rctx->datbuf.buf, rctx->datbuf.addr);
+	if (rctx->residue.size)
+		dma_free_coherent(se->dev, rctx->datbuf.size,
+				  rctx->datbuf.buf, rctx->datbuf.addr);
+out_free:
 	dma_free_coherent(se->dev, crypto_ahash_blocksize(tfm),
 			  rctx->residue.buf, rctx->residue.addr);
 	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
@@ -527,19 +547,11 @@ static int tegra_sha_init(struct ahash_request *req)
 	if (!rctx->residue.buf)
 		goto resbuf_fail;
 
-	rctx->datbuf.buf = dma_alloc_coherent(se->dev, SE_SHA_BUFLEN,
-					      &rctx->datbuf.addr, GFP_KERNEL);
-	if (!rctx->datbuf.buf)
-		goto datbuf_fail;
-
 	return 0;
 
-datbuf_fail:
-	dma_free_coherent(se->dev, rctx->blk_size, rctx->residue.buf,
-			  rctx->residue.addr);
 resbuf_fail:
-	dma_free_coherent(se->dev, SE_SHA_BUFLEN, rctx->datbuf.buf,
-			  rctx->datbuf.addr);
+	dma_free_coherent(se->dev, rctx->digest.size, rctx->digest.buf,
+			  rctx->digest.addr);
 digbuf_fail:
 	return -ENOMEM;
 }
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index b54aefe717a17..e196a90eedb92 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -340,8 +340,6 @@
 #define SE_CRYPTO_CTR_REG_COUNT			4
 #define SE_MAX_KEYSLOT				15
 #define SE_MAX_MEM_ALLOC			SZ_4M
-#define SE_AES_BUFLEN				0x8000
-#define SE_SHA_BUFLEN				0x2000
 
 #define SHA_FIRST	BIT(0)
 #define SHA_UPDATE	BIT(1)
-- 
2.39.5



