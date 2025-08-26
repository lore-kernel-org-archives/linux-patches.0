Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF893376BA;
	Tue, 26 Aug 2025 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215870; cv=none; b=ZUsTlQd3Ou+oF8OsLAfMxRVTBTMjOO+HDJERbgpyiXc7WjHbUK1v5uQuITG+EQf2P/8bNcbZr3lwl6ZVBySuSd+aYI97BfLiJtQlxYaTEdgnZymFnet/lQzVSGZk11fAbfXnTms5nzTvbqWdV0H9GpEezRDCe0qLicpzp+kYYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215870; c=relaxed/simple;
	bh=L+nOrtWaE2PD0ka4F+YT2gqtlaDZVCMLUe07OR+i3hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXPfYiTGVdZIjZsYvc+6FpmBWm5lvGzeUYTC/wvq5CBTRTmSKnQ1hlxwrAcrK20OP3xXt/95UUwYnseHHHSFvs2cGC53LtutDfCQqu9Avdcm+1zlXtJCe6VNLgcmBRmJmymQnj7cPRwKZmtfG/ZMZzx1aETZr35xYo6Rdse3hU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkRJNFZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkRJNFZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F11BC4CEF1;
	Tue, 26 Aug 2025 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215870;
	bh=L+nOrtWaE2PD0ka4F+YT2gqtlaDZVCMLUe07OR+i3hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkRJNFZsaZQw0dVp/eF7d5EV3dspFzRWBJKY7HwObZgEW/yzFhmli5sRh2UC12ph1
	 a5xKpSa2zVvL+jQ3kHw+Qv42cfbBmd0eXDcizveuVIAlNqVFNy/v1j5UN+8+p35Cwv
	 M1EXlBa/h+HCo07BZWr1FaRg8mUr503E+xvT9nGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/644] crypto: marvell/cesa - Fix engine load inaccuracy
Date: Tue, 26 Aug 2025 13:04:17 +0200
Message-ID: <20250826110950.594652810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 442134ab30e75b7229c4bfc1ac5641d245cffe27 ]

If an error occurs during queueing the engine load will never be
decremented.  Fix this by moving the engine load adjustment into
the cleanup function.

Fixes: bf8f91e71192 ("crypto: marvell - Add load balancing between engines")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 4 +++-
 drivers/crypto/marvell/cesa/hash.c   | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 3876e3ce822f..eabed9d977df 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -75,9 +75,12 @@ mv_cesa_skcipher_dma_cleanup(struct skcipher_request *req)
 static inline void mv_cesa_skcipher_cleanup(struct skcipher_request *req)
 {
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
+	struct mv_cesa_engine *engine = creq->base.engine;
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
 		mv_cesa_skcipher_dma_cleanup(req);
+
+	atomic_sub(req->cryptlen, &engine->load);
 }
 
 static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
@@ -212,7 +215,6 @@ mv_cesa_skcipher_complete(struct crypto_async_request *req)
 	struct mv_cesa_engine *engine = creq->base.engine;
 	unsigned int ivsize;
 
-	atomic_sub(skreq->cryptlen, &engine->load);
 	ivsize = crypto_skcipher_ivsize(crypto_skcipher_reqtfm(skreq));
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 72b0f863dee0..66ebe26e59cb 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -110,9 +110,12 @@ static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
 static inline void mv_cesa_ahash_cleanup(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_engine *engine = creq->base.engine;
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ)
 		mv_cesa_ahash_dma_cleanup(req);
+
+	atomic_sub(req->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
@@ -395,8 +398,6 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 			}
 		}
 	}
-
-	atomic_sub(ahashreq->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
-- 
2.39.5



