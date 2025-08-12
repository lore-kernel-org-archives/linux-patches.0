Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644EB61FFE;
	Tue, 12 Aug 2025 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022756; cv=none; b=nBtpyjcZC/ArclraN8fyyDiEUgY4/QZ6dho8sxl7WviJi3vukOMkHJmVlDY1IK8JJqYqpejmmMeH+caYCauxeaa7kIaC3WXnZhiNQCJhqDvCINIMIsnfBj/rPeEccIYEC/O+BVsBDTacXOHPdpgOvXOs6KRThNEid9J+S7UBCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022756; c=relaxed/simple;
	bh=GMPWeLIuK2YniLs8RWgTpemIRAYTkvUIDg50IbBd3oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZqvN3s1TUqYi1WCTOYLd1kCRBROaQBV5sOo3dEYsgGzm7z3r2VQ5+Dk7WwgOOqB10J6eljLCwcev9Z8bfSB3KvVyma/RX9PPkztlU2wThbU8wNHteSXhxbOb3OpGJqFPOXFA7+gNBlSCHuo9nIzW8PmxiBt/y8M3Rd2zHKVuZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2Ndhh6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2Ndhh6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60D2C4CEF6;
	Tue, 12 Aug 2025 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022756;
	bh=GMPWeLIuK2YniLs8RWgTpemIRAYTkvUIDg50IbBd3oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2Ndhh6FRiATOdqpMi2a34ItOmmuq5UluAKhJ5j62nXRXiZaJIN78aFu/a79Suy1c
	 +jmPtBvvFK8pNvdqmjbC+ORJqDTP6P2l/x/pl9TXZQd1AAsRRKrtrh09Q6wHiHSQqg
	 NEPD24kfASyPZbtDCO+kHHLUpME+bNonsaLAfERc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/369] dmaengine: mv_xor: Fix missing check after DMA map and missing unmap
Date: Tue, 12 Aug 2025 19:28:33 +0200
Message-ID: <20250812173022.875716268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 60095aca6b471b7b7a79c80b7395f7e4e414b479 ]

The DMA map functions can fail and should be tested for errors.

In case of error, unmap the already mapped regions.

Fixes: 22843545b200 ("dma: mv_xor: Add support for DMA_INTERRUPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250701123753.46935-2-fourier.thomas@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 40b76b40bc30..184813766cd1 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1061,8 +1061,16 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	 */
 	mv_chan->dummy_src_addr = dma_map_single(dma_dev->dev,
 		mv_chan->dummy_src, MV_XOR_MIN_BYTE_COUNT, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dma_dev->dev, mv_chan->dummy_src_addr))
+		return ERR_PTR(-ENOMEM);
+
 	mv_chan->dummy_dst_addr = dma_map_single(dma_dev->dev,
 		mv_chan->dummy_dst, MV_XOR_MIN_BYTE_COUNT, DMA_TO_DEVICE);
+	if (dma_mapping_error(dma_dev->dev, mv_chan->dummy_dst_addr)) {
+		ret = -ENOMEM;
+		goto err_unmap_src;
+	}
+
 
 	/* allocate coherent memory for hardware descriptors
 	 * note: writecombine gives slightly better performance, but
@@ -1071,8 +1079,10 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	mv_chan->dma_desc_pool_virt =
 	  dma_alloc_wc(&pdev->dev, MV_XOR_POOL_SIZE, &mv_chan->dma_desc_pool,
 		       GFP_KERNEL);
-	if (!mv_chan->dma_desc_pool_virt)
-		return ERR_PTR(-ENOMEM);
+	if (!mv_chan->dma_desc_pool_virt) {
+		ret = -ENOMEM;
+		goto err_unmap_dst;
+	}
 
 	/* discover transaction capabilities from the platform data */
 	dma_dev->cap_mask = cap_mask;
@@ -1155,6 +1165,13 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 err_free_dma:
 	dma_free_coherent(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
+err_unmap_dst:
+	dma_unmap_single(dma_dev->dev, mv_chan->dummy_dst_addr,
+			 MV_XOR_MIN_BYTE_COUNT, DMA_TO_DEVICE);
+err_unmap_src:
+	dma_unmap_single(dma_dev->dev, mv_chan->dummy_src_addr,
+			 MV_XOR_MIN_BYTE_COUNT, DMA_FROM_DEVICE);
+
 	return ERR_PTR(ret);
 }
 
-- 
2.39.5



