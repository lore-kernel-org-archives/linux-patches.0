Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF8643AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6feHW2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B73C41679;
	Wed, 15 Nov 2023 20:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081267;
	bh=h520yRg8ZmwICoF4R3wgvMmOoQ7Fm7kUNGjsGr+SIEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6feHW2qqT9u9QFh8Ow4VpM01S2zyyqt6pjmye5T+dvoTB8dLAFnGDxuSSpO/MxG4
	 4jTfYnRXDJTddWPm6w1KKnXufP/t1iEZPgkh4VGEj5YrD+MnvHx/1dvyJDE6QUThYT
	 nLRWqGlio/D6Q1gvY6hVXmJjywxF8Q+Xk5vcz9UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/244] mt76: add support for overriding the device used for DMA mapping
Date: Wed, 15 Nov 2023 15:33:38 -0500
Message-ID: <20231115203549.934988200@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d1ddc536df93ae406ef671deb3218898d3515ea4 ]

WED support requires using non-coherent DMA, whereas the PCI device might
be configured for coherent DMA.
The WED driver will take care of changing the PCI HIF coherent IO setting
on attach.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 317620593349 ("wifi: mt76: mt7603: improve stuck beacon handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 34 +++++++++----------
 drivers/net/wireless/mediatek/mt76/mac80211.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1344c88729a84..71a04c92117a6 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -20,7 +20,7 @@ mt76_alloc_txwi(struct mt76_dev *dev)
 	if (!txwi)
 		return NULL;
 
-	addr = dma_map_single(dev->dev, txwi, dev->drv->txwi_size,
+	addr = dma_map_single(dev->dma_dev, txwi, dev->drv->txwi_size,
 			      DMA_TO_DEVICE);
 	t = (struct mt76_txwi_cache *)(txwi + dev->drv->txwi_size);
 	t->dma_addr = addr;
@@ -74,7 +74,7 @@ mt76_free_pending_txwi(struct mt76_dev *dev)
 
 	local_bh_disable();
 	while ((t = __mt76_get_txwi(dev)) != NULL) {
-		dma_unmap_single(dev->dev, t->dma_addr, dev->drv->txwi_size,
+		dma_unmap_single(dev->dma_dev, t->dma_addr, dev->drv->txwi_size,
 				 DMA_TO_DEVICE);
 		kfree(mt76_get_txwi_ptr(dev, t));
 	}
@@ -123,7 +123,7 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	q->hw_idx = idx;
 
 	size = q->ndesc * sizeof(struct mt76_desc);
-	q->desc = dmam_alloc_coherent(dev->dev, size, &q->desc_dma, GFP_KERNEL);
+	q->desc = dmam_alloc_coherent(dev->dma_dev, size, &q->desc_dma, GFP_KERNEL);
 	if (!q->desc)
 		return -ENOMEM;
 
@@ -205,11 +205,11 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	struct mt76_queue_entry *e = &q->entry[idx];
 
 	if (!e->skip_buf0)
-		dma_unmap_single(dev->dev, e->dma_addr[0], e->dma_len[0],
+		dma_unmap_single(dev->dma_dev, e->dma_addr[0], e->dma_len[0],
 				 DMA_TO_DEVICE);
 
 	if (!e->skip_buf1)
-		dma_unmap_single(dev->dev, e->dma_addr[1], e->dma_len[1],
+		dma_unmap_single(dev->dma_dev, e->dma_addr[1], e->dma_len[1],
 				 DMA_TO_DEVICE);
 
 	if (e->txwi == DMA_DUMMY_DATA)
@@ -290,7 +290,7 @@ mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	if (info)
 		*info = le32_to_cpu(desc->info);
 
-	dma_unmap_single(dev->dev, buf_addr, buf_len, DMA_FROM_DEVICE);
+	dma_unmap_single(dev->dma_dev, buf_addr, buf_len, DMA_FROM_DEVICE);
 	e->buf = NULL;
 
 	return buf;
@@ -327,9 +327,9 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 	if (q->queued + 1 >= q->ndesc - 1)
 		goto error;
 
-	addr = dma_map_single(dev->dev, skb->data, skb->len,
+	addr = dma_map_single(dev->dma_dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev, addr)))
+	if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
 		goto error;
 
 	buf.addr = addr;
@@ -376,8 +376,8 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		mt76_insert_hdr_pad(skb);
 
 	len = skb_headlen(skb);
-	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(dev->dev, addr)))
+	addr = dma_map_single(dev->dma_dev, skb->data, len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
 		goto free;
 
 	tx_info.buf[n].addr = t->dma_addr;
@@ -389,9 +389,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		if (n == ARRAY_SIZE(tx_info.buf))
 			goto unmap;
 
-		addr = dma_map_single(dev->dev, iter->data, iter->len,
+		addr = dma_map_single(dev->dma_dev, iter->data, iter->len,
 				      DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev->dev, addr)))
+		if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
 			goto unmap;
 
 		tx_info.buf[n].addr = addr;
@@ -404,10 +404,10 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		goto unmap;
 	}
 
-	dma_sync_single_for_cpu(dev->dev, t->dma_addr, dev->drv->txwi_size,
+	dma_sync_single_for_cpu(dev->dma_dev, t->dma_addr, dev->drv->txwi_size,
 				DMA_TO_DEVICE);
 	ret = dev->drv->tx_prepare_skb(dev, txwi, q->qid, wcid, sta, &tx_info);
-	dma_sync_single_for_device(dev->dev, t->dma_addr, dev->drv->txwi_size,
+	dma_sync_single_for_device(dev->dma_dev, t->dma_addr, dev->drv->txwi_size,
 				   DMA_TO_DEVICE);
 	if (ret < 0)
 		goto unmap;
@@ -417,7 +417,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 unmap:
 	for (n--; n > 0; n--)
-		dma_unmap_single(dev->dev, tx_info.buf[n].addr,
+		dma_unmap_single(dev->dma_dev, tx_info.buf[n].addr,
 				 tx_info.buf[n].len, DMA_TO_DEVICE);
 
 free:
@@ -461,8 +461,8 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 		if (!buf)
 			break;
 
-		addr = dma_map_single(dev->dev, buf, len, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dev->dev, addr))) {
+		addr = dma_map_single(dev->dma_dev, buf, len, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dev->dma_dev, addr))) {
 			skb_free_frag(buf);
 			break;
 		}
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 028519a739fd1..3c7d5abe9cc2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -428,6 +428,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	dev->hw = hw;
 	dev->dev = pdev;
 	dev->drv = drv_ops;
+	dev->dma_dev = pdev;
 
 	phy = &dev->phy;
 	phy->dev = dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index eb1fb955b7777..87ae528581bbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -660,6 +660,7 @@ struct mt76_dev {
 	const struct mt76_driver_ops *drv;
 	const struct mt76_mcu_ops *mcu_ops;
 	struct device *dev;
+	struct device *dma_dev;
 
 	struct mt76_mcu mcu;
 
-- 
2.42.0



