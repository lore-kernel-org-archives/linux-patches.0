Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AABB2AE68;
	Mon, 30 Dec 2024 15:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574079; cv=none; b=KSMTo3rhgCMaeIIWCJqU87cQpLzE30+5Ck0ddPyPjs8Ry/k+Fb6kmfFviyW1C0qJWzc73zSiSxGqulHuoia7Rpdfct8zrOGe0HQBjRLbstGyX4UHZKIjDJ47j1u57qe1yZxUQfIMzijhb6Vf3WIPbl61j0SDRreBrsIChFMJCAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574079; c=relaxed/simple;
	bh=LKzk322GJa2AJg6VlAJnAhgAn52ukY/dZKPYS+Fn5+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvPb/k0RhyRLRWKg7/f0CkpdZD1/6hFI3li19NTpeRb3aPN71BsmNYsOquW+5iBPXNpyGcO02Q8J/rXTY7G6Uvb13594R95E07keMuspznKjo+6rchjU2YqK4I3ZVLBrYQXTSKHGXzktbk5MDZgaS/t3FdmxJo9/JzCYBsNO9eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGA7lz48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGA7lz48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE385C4CED0;
	Mon, 30 Dec 2024 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574079;
	bh=LKzk322GJa2AJg6VlAJnAhgAn52ukY/dZKPYS+Fn5+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGA7lz484UDQKDrl5cUOzuSbqAXfst/MfGl62PWV3efDs4AMvujVJBFsxomSk9rjI
	 RXXZPvRnivcTKI3CbqtPxn8y2Q+I+niCHWUbL1XfxFZlnF0/Bhbi/iWQP4OkRIvxnQ
	 M4SCEMmAp2nW8Lu0y9rf3hTPeVqUtd62co8n6Pb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Christoph Hellwig <hch@lst.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 031/114] dmaengine: amd: qdma: Remove using the private get and set dma_ops APIs
Date: Mon, 30 Dec 2024 16:42:28 +0100
Message-ID: <20241230154219.262577020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

commit dcbef0798eb825cd584f7a93f62bed63f7fbbfc9 upstream.

The get_dma_ops and set_dma_ops APIs were never for driver to use. Remove
these calls from QDMA driver. Instead, pass the DMA device pointer from the
qdma_platdata structure.

Fixes: 73d5fc92a11c ("dmaengine: amd: qdma: Add AMD QDMA driver")
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240918181022.2155715-1-lizhi.hou@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/amd/qdma/qdma.c            | 28 +++++++++++---------------
 include/linux/platform_data/amd_qdma.h |  2 ++
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/amd/qdma/qdma.c b/drivers/dma/amd/qdma/qdma.c
index 6d9079458fe9..66f00ad67351 100644
--- a/drivers/dma/amd/qdma/qdma.c
+++ b/drivers/dma/amd/qdma/qdma.c
@@ -7,9 +7,9 @@
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
-#include <linux/dma-map-ops.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/amd_qdma.h>
 #include <linux/regmap.h>
@@ -492,18 +492,9 @@ static int qdma_device_verify(struct qdma_device *qdev)
 
 static int qdma_device_setup(struct qdma_device *qdev)
 {
-	struct device *dev = &qdev->pdev->dev;
 	u32 ring_sz = QDMA_DEFAULT_RING_SIZE;
 	int ret = 0;
 
-	while (dev && get_dma_ops(dev))
-		dev = dev->parent;
-	if (!dev) {
-		qdma_err(qdev, "dma device not found");
-		return -EINVAL;
-	}
-	set_dma_ops(&qdev->pdev->dev, get_dma_ops(dev));
-
 	ret = qdma_setup_fmap_context(qdev);
 	if (ret) {
 		qdma_err(qdev, "Failed setup fmap context");
@@ -548,11 +539,12 @@ static void qdma_free_queue_resources(struct dma_chan *chan)
 {
 	struct qdma_queue *queue = to_qdma_queue(chan);
 	struct qdma_device *qdev = queue->qdev;
-	struct device *dev = qdev->dma_dev.dev;
+	struct qdma_platdata *pdata;
 
 	qdma_clear_queue_context(queue);
 	vchan_free_chan_resources(&queue->vchan);
-	dma_free_coherent(dev, queue->ring_size * QDMA_MM_DESC_SIZE,
+	pdata = dev_get_platdata(&qdev->pdev->dev);
+	dma_free_coherent(pdata->dma_dev, queue->ring_size * QDMA_MM_DESC_SIZE,
 			  queue->desc_base, queue->dma_desc_base);
 }
 
@@ -565,6 +557,7 @@ static int qdma_alloc_queue_resources(struct dma_chan *chan)
 	struct qdma_queue *queue = to_qdma_queue(chan);
 	struct qdma_device *qdev = queue->qdev;
 	struct qdma_ctxt_sw_desc desc;
+	struct qdma_platdata *pdata;
 	size_t size;
 	int ret;
 
@@ -572,8 +565,9 @@ static int qdma_alloc_queue_resources(struct dma_chan *chan)
 	if (ret)
 		return ret;
 
+	pdata = dev_get_platdata(&qdev->pdev->dev);
 	size = queue->ring_size * QDMA_MM_DESC_SIZE;
-	queue->desc_base = dma_alloc_coherent(qdev->dma_dev.dev, size,
+	queue->desc_base = dma_alloc_coherent(pdata->dma_dev, size,
 					      &queue->dma_desc_base,
 					      GFP_KERNEL);
 	if (!queue->desc_base) {
@@ -588,7 +582,7 @@ static int qdma_alloc_queue_resources(struct dma_chan *chan)
 	if (ret) {
 		qdma_err(qdev, "Failed to setup SW desc ctxt for %s",
 			 chan->name);
-		dma_free_coherent(qdev->dma_dev.dev, size, queue->desc_base,
+		dma_free_coherent(pdata->dma_dev, size, queue->desc_base,
 				  queue->dma_desc_base);
 		return ret;
 	}
@@ -948,8 +942,9 @@ static int qdma_init_error_irq(struct qdma_device *qdev)
 
 static int qdmam_alloc_qintr_rings(struct qdma_device *qdev)
 {
-	u32 ctxt[QDMA_CTXT_REGMAP_LEN];
+	struct qdma_platdata *pdata = dev_get_platdata(&qdev->pdev->dev);
 	struct device *dev = &qdev->pdev->dev;
+	u32 ctxt[QDMA_CTXT_REGMAP_LEN];
 	struct qdma_intr_ring *ring;
 	struct qdma_ctxt_intr intr_ctxt;
 	u32 vector;
@@ -969,7 +964,8 @@ static int qdmam_alloc_qintr_rings(struct qdma_device *qdev)
 		ring->msix_id = qdev->err_irq_idx + i + 1;
 		ring->ridx = i;
 		ring->color = 1;
-		ring->base = dmam_alloc_coherent(dev, QDMA_INTR_RING_SIZE,
+		ring->base = dmam_alloc_coherent(pdata->dma_dev,
+						 QDMA_INTR_RING_SIZE,
 						 &ring->dev_base, GFP_KERNEL);
 		if (!ring->base) {
 			qdma_err(qdev, "Failed to alloc intr ring %d", i);
diff --git a/include/linux/platform_data/amd_qdma.h b/include/linux/platform_data/amd_qdma.h
index 576d952f97ed..967a6ef31cf9 100644
--- a/include/linux/platform_data/amd_qdma.h
+++ b/include/linux/platform_data/amd_qdma.h
@@ -26,11 +26,13 @@ struct dma_slave_map;
  * @max_mm_channels: Maximum number of MM DMA channels in each direction
  * @device_map: DMA slave map
  * @irq_index: The index of first IRQ
+ * @dma_dev: The device pointer for dma operations
  */
 struct qdma_platdata {
 	u32			max_mm_channels;
 	u32			irq_index;
 	struct dma_slave_map	*device_map;
+	struct device		*dma_dev;
 };
 
 #endif /* _PLATDATA_AMD_QDMA_H */
-- 
2.47.1



