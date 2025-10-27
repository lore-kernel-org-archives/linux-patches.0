Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015CF3203BB;
	Mon, 27 Oct 2025 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591824; cv=none; b=o5EUbZ70YHzDrCrWN3x9NNCngh5MtvUX+oAv31K7Xo6jXnR58rQl2vDUhVWkVARcREqDE8WFZQr3E1hJzQsBfFlzMzFhJjI+5GrlzIL/UKigt1afLmCgCabdsLClCYRByK7PrFow3vjlG1G6cZ05a5vSQ8Hz7s8/JoVpB0vPZPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591824; c=relaxed/simple;
	bh=VcYyikyA3eddBmokcL67c9GFs2YR4tZLWycKBwWpFtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/CT491oPyPQzdTFn+xt6/x+sPlvcTPKznoZKRZxI43TV/qebJutm3PoIalfeKIhgFovdiRPHIQlXfCvR6TQvLuMgxMJE0onwlUbRI7g+meQ/gan67c1WLmeAsi3A1DCTrk5AjQw9Ll4tsby/gEM/bVhbSBnvZmuG1Xy8E5q4lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaXwr+Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaXwr+Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8991DC4CEF1;
	Mon, 27 Oct 2025 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591823;
	bh=VcYyikyA3eddBmokcL67c9GFs2YR4tZLWycKBwWpFtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaXwr+GenV76+sb8fYO4en+FUUb13bmfUciTciI+pKXliBcLySUujpDVhSIlYx/Zt
	 4o+U2p0GHk1JqTkWFI7lkTTn/ybFbFvWRAPbcfo7VVbSwY6jjxWym1wpcrF2cot+d7
	 ie/i9Jh/D03hVxYNoqaBWiC9ytGE508JkcKExiqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/123] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Mon, 27 Oct 2025 19:34:52 +0100
Message-ID: <20251027183446.726882633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 21140e5caf019e4a24e1ceabcaaa16bd693b393f ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ removed unused rctx variable declaration since device pointer already came from tctx->dev->dev instead of rctx->dev ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -236,10 +236,9 @@ static int rk_hash_unprepare(struct cryp
 {
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
 
-	dma_unmap_sg(tctx->dev->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
+	dma_unmap_sg(tctx->dev->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
 	return 0;
 }
 


