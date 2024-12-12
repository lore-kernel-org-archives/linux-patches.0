Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FC721B91D;
	Thu, 12 Dec 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019295; cv=none; b=cahgg0B2H0I1h7+2noLl82fZxxKZ24TXP3q/qcer3YrJ5sIN5DtHE0Kp2BJwKpuRRH3OphUa/74VZyqGu4RLt9BWlgz0wVFgW7lAM5lbZ6GB+J+TpQcrwuxKJn0mzY9T9V+p30+waMLR+YxKn6fQTtScb8aF1mvW2Bfs+r7MatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019295; c=relaxed/simple;
	bh=bJWc6/P25G4pexBmimn4tXKBid/PolhrJ0rwdDOiEKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0yqUTsY8ICLpuAA9AQ8kaV4aSTK2j1LQAJoVBP17aPbiWzL2hIBuYDZWRvPmHGBGqRHBSGFnZhOVHOWiXUpSbbo1X6cxIobSOinTbW3rtRrB7H62Mdx++s/BJCbYtAISMYx+WpP3KT7uo7JUwHOn/zrYm/fGEwND6I4hPB9fZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd/hrNRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd/hrNRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49449C4CECE;
	Thu, 12 Dec 2024 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019293;
	bh=bJWc6/P25G4pexBmimn4tXKBid/PolhrJ0rwdDOiEKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd/hrNRYuiR2wsKynS+6cIYqTVlRDzSEZh3pbm9heCQawUixSzzCmSkKBhYVVXJDX
	 zVJk1/47Nt0kflIgIEm8w+lonWi6EFec6g0jbXwbaIAKqHF55HVnwN9w+u+MjdHkhY
	 Vb/tgKsfMLhYC3IEe/HeIUVz6KtGcl+7ONIwHuRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/772] drm/etnaviv: Request pages from DMA32 zone on addressing_limited
Date: Thu, 12 Dec 2024 15:51:55 +0100
Message-ID: <20241212144356.970608672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 13c96ac9a3f0f1c7ba1ff0656ea508e7fa065e7e ]

Remove __GFP_HIGHMEM when requesting a page from DMA32 zone,
and since all vivante GPUs in the system will share the same
DMA constraints, move the check of whether to get a page from
DMA32 to etnaviv_bind().

Fixes: b72af445cd38 ("drm/etnaviv: request pages from DMA32 zone when needed")
Suggested-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c | 10 ++++++++++
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c |  8 --------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index f29952a55c05d..b932a02efccda 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -519,6 +519,16 @@ static int etnaviv_bind(struct device *dev)
 	priv->num_gpus = 0;
 	priv->shm_gfp_mask = GFP_HIGHUSER | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
+	/*
+	 * If the GPU is part of a system with DMA addressing limitations,
+	 * request pages for our SHM backend buffers from the DMA32 zone to
+	 * hopefully avoid performance killing SWIOTLB bounce buffering.
+	 */
+	if (dma_addressing_limited(dev)) {
+		priv->shm_gfp_mask |= GFP_DMA32;
+		priv->shm_gfp_mask &= ~__GFP_HIGHMEM;
+	}
+
 	priv->cmdbuf_suballoc = etnaviv_cmdbuf_suballoc_new(drm->dev);
 	if (IS_ERR(priv->cmdbuf_suballoc)) {
 		dev_err(drm->dev, "Failed to create cmdbuf suballocator\n");
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index f667e7906d1f4..ffac685c22918 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -798,14 +798,6 @@ int etnaviv_gpu_init(struct etnaviv_gpu *gpu)
 	if (ret)
 		goto fail;
 
-	/*
-	 * If the GPU is part of a system with DMA addressing limitations,
-	 * request pages for our SHM backend buffers from the DMA32 zone to
-	 * hopefully avoid performance killing SWIOTLB bounce buffering.
-	 */
-	if (dma_addressing_limited(gpu->dev))
-		priv->shm_gfp_mask |= GFP_DMA32;
-
 	/* Create buffer: */
 	ret = etnaviv_cmdbuf_init(priv->cmdbuf_suballoc, &gpu->buffer,
 				  PAGE_SIZE);
-- 
2.43.0



