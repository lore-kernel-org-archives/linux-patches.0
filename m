Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3243F27D76E;
	Wed, 23 Apr 2025 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419692; cv=none; b=HLIlctXmPg0GSNUQuwrORwQdStJVsZwiJJtmK0Twjz/NLWrykIMNeFq1w5xLN8RleTKJBQWtS516NTNBn40yH/ALIR76SrrvjaRb8HLc54RdPvvpFa+0pL5T1gEcOaRuT/tf364bR9+5MDuKSXgMTa4hX8P5KgGmdJtAN967+yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419692; c=relaxed/simple;
	bh=3LDvnr0IxNe31HJF/pNIfjQ5OPim/hb7+MiZ5dsJKp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGTKZKFWgZfqKWVSHkTrCPyGhMaHfjJ1T8fAKblv3FIq26VM+rF3zmlPwLmke1Y5t4S5Sa8Yh5YyziP4BfSBDgwYaAp2Aap11COhhgpOkwnIq3+GZ2EGVyBl/GBEjfUTyxGFa5mTt2100dccwczXOQRbYLVeyxxwab/aArvOJAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCTLXGce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCTLXGce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6EAC4CEE2;
	Wed, 23 Apr 2025 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419692;
	bh=3LDvnr0IxNe31HJF/pNIfjQ5OPim/hb7+MiZ5dsJKp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCTLXGceXWHGaDHgD7KaDLvd4iuynCgOMxueThelmPvS10xlrezp2E0JXsAl2VAmP
	 YvJ5P94B9IgotJeezxs0AwdFZT2zO0iHm6EM0pG5ho9jpkEAB838NYgUbsyykGm+W3
	 vvBwuueOy6Sm8K9HQw8GJU0/R2tsuxInk7/jWSwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/223] crypto: tegra - Do not use fixed size buffers
Date: Wed, 23 Apr 2025 16:41:28 +0200
Message-ID: <20250423142617.780437398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 1cb328da4e8f34350c61a2b6548766c79b4bb64c ]

Allocate the buffer based on the request instead of a fixed buffer
length. In operations which may require larger buffer size, a fixed
buffer may fail.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 1ddaff40c08a ("crypto: tegra - Fix IV usage for AES ECB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 124 ++++++++++++++-------------
 drivers/crypto/tegra/tegra-se-hash.c |  38 +++++---
 drivers/crypto/tegra/tegra-se.h      |   2 -
 3 files changed, 89 insertions(+), 75 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9ab832bee81a2..46c4dac92dd7a 100644
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
@@ -1120,6 +1120,11 @@ static int tegra_ccm_crypt_init(struct aead_request *req, struct tegra_se *se,
 	rctx->assoclen = req->assoclen;
 	rctx->authsize = crypto_aead_authsize(tfm);
 
+	if (rctx->encrypt)
+		rctx->cryptlen = req->cryptlen;
+	else
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
+
 	memcpy(iv, req->iv, 16);
 
 	ret = tegra_ccm_check_iv(iv);
@@ -1148,30 +1153,26 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1182,8 +1183,6 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 		if (ret)
 			goto out;
 	} else {
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
-
 		/* CTR operation */
 		ret = tegra_ccm_do_ctr(ctx, rctx);
 		if (ret)
@@ -1196,11 +1195,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1216,23 +1215,6 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1246,6 +1228,21 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1269,11 +1266,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
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
@@ -1500,6 +1497,11 @@ static int tegra_cmac_do_update(struct ahash_request *req)
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
@@ -1525,6 +1527,9 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 
 	tegra_cmac_copy_result(ctx->se, rctx);
 
+	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
+			  rctx->datbuf.buf, rctx->datbuf.addr);
+
 	return ret;
 }
 
@@ -1539,10 +1544,20 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 
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
@@ -1568,8 +1583,10 @@ static int tegra_cmac_do_final(struct ahash_request *req)
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
@@ -1681,28 +1698,15 @@ static int tegra_cmac_init(struct ahash_request *req)
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
index 726e30c0e63eb..451b8eaab16aa 100644
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
@@ -534,19 +554,11 @@ static int tegra_sha_init(struct ahash_request *req)
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



