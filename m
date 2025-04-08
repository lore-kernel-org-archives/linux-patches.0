Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7352676E1;
	Tue,  8 Apr 2025 12:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114564; cv=none; b=pdwYh8Y3Q8B+A0mRo4d4OFk4P9HbKJdy76pgjXKfr0CJtdMVXl6kuZT+0/1PWw0MiLkB4FC1FZ5oFzxYBqRwh9SV/Sop9+5WilnIfC8+yRAOrAqdcNzwMuENkirow0Pa9M/pm7q+BVwlFW2Hl4gI+Gec6iQ0tlXpYhyTlEJA9e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114564; c=relaxed/simple;
	bh=E4Iq+4QFfAKxp7C6ruyBYfTg3cIhhC6LJU43tUatH9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cosO7htopD3PeK4dLkZrXQ/ks5Ax8bwjEFPfirHMWlc4gBGH38IEQYoZs3uxdeb/ebZzWmiofUaCey9UCEH1CVgSTP39YAaswTYsD1A4DltcYs00pTYFd6HEknkslLeESEkv3sOp+1GPYeYYSdAHi1QaCcxuW+M4ow2nMpqGiBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0o/zPeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0o/zPeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6F7C4CEE5;
	Tue,  8 Apr 2025 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114564;
	bh=E4Iq+4QFfAKxp7C6ruyBYfTg3cIhhC6LJU43tUatH9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0o/zPeBCmVbdqBfgggJGzap3gjYtrppKm/U5D4U0GZ6kAn/TPJ/3yqLimrq2Shy3
	 lvYOSYITLQzU0rB1Y8pYrgDDfRfiyBZwYDi/wqX8Z6OwMX8GDBskE7bXqZ7rLz9mmg
	 HumI0pwDVz06wYbO/ugXn02No0il8GWil8I0jgvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 153/499] crypto: tegra - finalize crypto req on error
Date: Tue,  8 Apr 2025 12:46:05 +0200
Message-ID: <20250408104855.002401055@linuxfoundation.org>
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

[ Upstream commit 1e245948ca0c252f561792fabb45de5518301d97 ]

Call the crypto finalize function before exiting *do_one_req() functions.
This allows the driver to take up further requests even if the previous
one fails.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
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



