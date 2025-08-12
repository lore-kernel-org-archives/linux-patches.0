Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E57F1F429C;
	Tue, 12 Aug 2025 19:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026183; cv=none; b=mv10xrsr7OUqXXR+Zdfwe9g/AfrD23IovmoUdXZ62XP2XNwphaV2uZzFxOK2IVXiSRgRStHNbMCN5Y6opXss43/6AQc21JZCtdSsPGFHQVh4CZH0+eFhLsePV7bhRX4hsfA2TudEVE9bkKpzerlorvDbl0dyZ7jq0ot97Wi7SSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026183; c=relaxed/simple;
	bh=Ngc71N2P6pfD4MslD4hMH4iq7SLDIKLHaN4moHztmxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilFtWIdetsf7laDzpZJ63Hj4NSEvnhdSPf1w+pw913s5cVv88iQd+HLXAE6nmEhHmZex/nIbhEkNSYMb2N4J+ZusFgZkERgIHgGBD5nJ6C5BGQXcY3fNwlfD4RIeqx41vIX2WV8lEsCT93eXRfT3dKIklzJ79usHwXEboPxSdAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv3Lav9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv3Lav9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64E7C4CEF0;
	Tue, 12 Aug 2025 19:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026183;
	bh=Ngc71N2P6pfD4MslD4hMH4iq7SLDIKLHaN4moHztmxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nv3Lav9gWXUa83ZDcOwP4IMjdyazTOvA7kZ74MjgDnNtZInFpQjwzn3Ls3OAWFfMs
	 AtCimCYUNOWN8yvbNcYzs91Df8KOOAb1y7KuUGydwVweMp1VPG6M7e4YVcvYKyk6L3
	 FpbPnIQKPzwblvnnDgsUxWRslzEML108tiQPhUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 228/480] crypto: marvell/cesa - Fix engine load inaccuracy
Date: Tue, 12 Aug 2025 19:47:16 +0200
Message-ID: <20250812174406.850446815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48c5c8ea8c43..3fe0fd9226cf 100644
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
index 6815eddc9068..e339ce7ad533 100644
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



