Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE26328B62;
	Mon, 27 Oct 2025 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591747; cv=none; b=EJUiQ1BOZF5LAK8Ku0QxuQ9GH/+/s/tV0ScJ+JHguOvAxI8tFgCp+0htT6LPQ+THCpDmeGFECWJJT1sFG1sTt5o1mn8PVu2wvjzUOWMpf8Pl1Dr2Ff4HBdo6wqtze+H09gdJ68CRGoqYJRavH5xMfRUvtyEwybuXI0XiFfOX31s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591747; c=relaxed/simple;
	bh=uz1bYlqcHNooSUEodX1K7vUoATpEUQc7OJIUJ2f1cP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITcbJXDbrqsT3lX9Q9pUY+MW/bLj4MCG3G2bLjHYAFjltAzz11GO29jDV7OK2Z5VuP5acbAt45uHgv5B09erJbvXbcYl1npgWHWU7hiWHf4Jc0iAwdea/D0jKW3xUVWK2xpLBjEgVKphKSHTTda5L8jjMdnxO4rPwNW2uQQHx88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwBgrx2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwBgrx2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7DCC4CEF1;
	Mon, 27 Oct 2025 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591747;
	bh=uz1bYlqcHNooSUEodX1K7vUoATpEUQc7OJIUJ2f1cP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwBgrx2tGclFCtEVltUCnVCWxagaHxaKZdqFd9hY3+GaWZxq1KK1+JMelZe+tz67D
	 dtRARpxu5szRo0aZe0BIFynARGf4xi/rWkRPbPhXePtAoVapvdkRh6RadtTJ7zpaMc
	 3Qw+THBe0qY6G1Ea6g9rsDLzXxQTHihv7FdBZyjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/332] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Mon, 27 Oct 2025 19:36:09 +0100
Message-ID: <20251027183533.203889873@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


