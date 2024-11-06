Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55461DF726;
	Wed,  6 Nov 2024 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896053; cv=none; b=jKokUYg80sNwXYh7PFH9Btvsh9quPiaoWjq4clLUaYJ1BQwXDklJ73R3fmVMOuNlmqhq9DiUSttFxaRmTYdFAKoym91xIJ0VknO5y+jMmcODYc56L69Z2AYmeXfAuX2oTNlptmT28VR8G9CV7dk4xsTpEhdIG+3X9IyNC43uwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896053; c=relaxed/simple;
	bh=Sv0kOMz0KYTQ2dIFtftFtwyJjBn1KvG5AKnUmnfdNgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIAIQuRmkKLOJ8zORuW+YeC+INVOhYK6PgrxZWlWsg7vWpe3i7N9Fz3LeTtV2su3PKslDKvBPV+stxz8YFrsv7r9+nN09P4e7tqU9fzu6gGgFr/RVWoBL8XYir8PZk0HzH7TqJdZUEIPWU3n94C47J08Js4U/zlU+Urj7CLRrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ss2776hP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ss2776hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4D7C4CECD;
	Wed,  6 Nov 2024 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896053;
	bh=Sv0kOMz0KYTQ2dIFtftFtwyJjBn1KvG5AKnUmnfdNgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss2776hPWldc6viMywKzlfFiNAJlKZX/pi4CvrRnMzPlSetj9CIThm9DI+mM6hmXl
	 SKUh7j7DcycMnA7M4nP6tKf8JOxG47BiAO+X4pwT9ynFma2fcojjb3Z2U81l+AWhKK
	 EfLHP8dAEW09KqDuvxMtt/BPNOhk4gijoPcftlCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 073/245] drm/mediatek: Use cmdq_pkt_create() and cmdq_pkt_destroy()
Date: Wed,  6 Nov 2024 13:02:06 +0100
Message-ID: <20241106120321.003003630@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Kuang Hu <chunkuang.hu@kernel.org>

[ Upstream commit d7c66b5fbc70d09348f3e0414ebf360c3125f3fa ]

Use cmdq_pkt_create() and cmdq_pkt_destroy() common function
instead of implementing drm version.

Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240810090918.7457-3-chunkuang.hu@kernel.org/
Stable-dep-of: 4018651ba5c4 ("drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 46 +++--------------------------
 1 file changed, 4 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index a90504359e8d2..4bee0328bdbee 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -120,44 +120,6 @@ static void mtk_drm_finish_page_flip(struct mtk_crtc *mtk_crtc)
 	spin_unlock_irqrestore(&mtk_crtc->config_lock, flags);
 }
 
-#if IS_REACHABLE(CONFIG_MTK_CMDQ)
-static int mtk_drm_cmdq_pkt_create(struct cmdq_client *client, struct cmdq_pkt *pkt,
-				   size_t size)
-{
-	struct device *dev;
-	dma_addr_t dma_addr;
-
-	pkt->va_base = kzalloc(size, GFP_KERNEL);
-	if (!pkt->va_base)
-		return -ENOMEM;
-
-	pkt->buf_size = size;
-	pkt->cl = (void *)client;
-
-	dev = client->chan->mbox->dev;
-	dma_addr = dma_map_single(dev, pkt->va_base, pkt->buf_size,
-				  DMA_TO_DEVICE);
-	if (dma_mapping_error(dev, dma_addr)) {
-		dev_err(dev, "dma map failed, size=%u\n", (u32)(u64)size);
-		kfree(pkt->va_base);
-		return -ENOMEM;
-	}
-
-	pkt->pa_base = dma_addr;
-
-	return 0;
-}
-
-static void mtk_drm_cmdq_pkt_destroy(struct cmdq_pkt *pkt)
-{
-	struct cmdq_client *client = (struct cmdq_client *)pkt->cl;
-
-	dma_unmap_single(client->chan->mbox->dev, pkt->pa_base, pkt->buf_size,
-			 DMA_TO_DEVICE);
-	kfree(pkt->va_base);
-}
-#endif
-
 static void mtk_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct mtk_crtc *mtk_crtc = to_mtk_crtc(crtc);
@@ -165,7 +127,7 @@ static void mtk_crtc_destroy(struct drm_crtc *crtc)
 
 	mtk_mutex_put(mtk_crtc->mutex);
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
+	cmdq_pkt_destroy(&mtk_crtc->cmdq_client, &mtk_crtc->cmdq_handle);
 
 	if (mtk_crtc->cmdq_client.chan) {
 		mbox_free_channel(mtk_crtc->cmdq_client.chan);
@@ -1122,9 +1084,9 @@ int mtk_crtc_create(struct drm_device *drm_dev, const unsigned int *path,
 			mbox_free_channel(mtk_crtc->cmdq_client.chan);
 			mtk_crtc->cmdq_client.chan = NULL;
 		} else {
-			ret = mtk_drm_cmdq_pkt_create(&mtk_crtc->cmdq_client,
-						      &mtk_crtc->cmdq_handle,
-						      PAGE_SIZE);
+			ret = cmdq_pkt_create(&mtk_crtc->cmdq_client,
+					      &mtk_crtc->cmdq_handle,
+					      PAGE_SIZE);
 			if (ret) {
 				dev_dbg(dev, "mtk_crtc %d failed to create cmdq packet\n",
 					drm_crtc_index(&mtk_crtc->base));
-- 
2.43.0



