Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E882280CFB;
	Mon, 13 Apr 2026 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098105; cv=none; b=R3fqIdiPe37tcNKDrNbqgUQzVbzzIVH6MN7DboDv/AqTZvMQHkPd/hPsiWO+7myYAscCZnLfumkZC0Lagh743JvCsKJd0uYkQpx3dtvkcAv+C6xtvIPlDTAOWdwOaKksrWHeX6bAvT4UM6GnXArxVQ2vK2h0ael2bWACmnnPsHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098105; c=relaxed/simple;
	bh=SIYZnvMGBy/gycH4Bx0/1Tzi4vP0cIVTcGJRKNGFk/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjaKiNcmoCgfMYtku1Gc1oYDL5q7hdwnicgoXI/BtctxoDFFrI4BrOJXUfL7ua2bVAAuk2uiC/9mVJYmdG+hbTIs2SC4j9rapMiFJ2OZgOYKXvgiUvYcBcf6o2Je832CMZmk+ZfTArKoOiGYkUHi7nuMJVwmZHFAxayygyo+EK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXlaDsc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXlaDsc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FE0C2BCAF;
	Mon, 13 Apr 2026 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098104;
	bh=SIYZnvMGBy/gycH4Bx0/1Tzi4vP0cIVTcGJRKNGFk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXlaDsc6jMI7ON1/ua8ewAc8A7GhUedBO6zcvjgr1b+H/M+eJ3VQnYIbL6jyA0U9o
	 r8n0GLEwNTvDw3dSvooqtIBuOzS+5LN1X3ZxFynzY6t1u+jUeTujLpUxnvv/Oufkyk
	 JOpwjQskAYyD4TcyLGGV8mLEAlxRghZgCN/EB4W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/570] dmaengine: xilinx_dma: Program interrupt delay timeout
Date: Mon, 13 Apr 2026 17:58:46 +0200
Message-ID: <20260413155845.270474192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 84b798fedf3fa8f0ab0c096593ba817abc454fe5 ]

Program IRQDelay for AXI DMA. The interrupt timeout mechanism causes
the DMA engine to generate an interrupt after the delay time period
has expired. It enables dmaengine to respond in real-time even though
interrupt coalescing is configured. It also remove the placeholder
for delay interrupt and merge it with frame completion interrupt.
Since by default interrupt delay timeout is disabled this feature
addition has no functional impact on VDMA, MCDMA and CDMA IP's.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1691387509-2113129-8-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: a17ce4bc6f4f ("dmaengine: xilinx_dma: Fix reset related timeout with two-channel AXIDMA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 00971b867ade2..f1162f7c9a52c 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -174,8 +174,10 @@
 #define XILINX_DMA_MAX_TRANS_LEN_MAX	23
 #define XILINX_DMA_V2_MAX_TRANS_LEN_MAX	26
 #define XILINX_DMA_CR_COALESCE_MAX	GENMASK(23, 16)
+#define XILINX_DMA_CR_DELAY_MAX		GENMASK(31, 24)
 #define XILINX_DMA_CR_CYCLIC_BD_EN_MASK	BIT(4)
 #define XILINX_DMA_CR_COALESCE_SHIFT	16
+#define XILINX_DMA_CR_DELAY_SHIFT	24
 #define XILINX_DMA_BD_SOP		BIT(27)
 #define XILINX_DMA_BD_EOP		BIT(26)
 #define XILINX_DMA_COALESCE_MAX		255
@@ -411,6 +413,7 @@ struct xilinx_dma_tx_descriptor {
  * @stop_transfer: Differentiate b/w DMA IP's quiesce
  * @tdest: TDEST value for mcdma
  * @has_vflip: S2MM vertical flip
+ * @irq_delay: Interrupt delay timeout
  */
 struct xilinx_dma_chan {
 	struct xilinx_dma_device *xdev;
@@ -449,6 +452,7 @@ struct xilinx_dma_chan {
 	int (*stop_transfer)(struct xilinx_dma_chan *chan);
 	u16 tdest;
 	bool has_vflip;
+	u8 irq_delay;
 };
 
 /**
@@ -1559,6 +1563,9 @@ static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
 	if (chan->has_sg)
 		xilinx_write(chan, XILINX_DMA_REG_CURDESC,
 			     head_desc->async_tx.phys);
+	reg  &= ~XILINX_DMA_CR_DELAY_MAX;
+	reg  |= chan->irq_delay << XILINX_DMA_CR_DELAY_SHIFT;
+	dma_ctrl_write(chan, XILINX_DMA_REG_DMACR, reg);
 
 	xilinx_dma_start(chan);
 
@@ -1886,15 +1893,8 @@ static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
 		}
 	}
 
-	if (status & XILINX_DMA_DMASR_DLY_CNT_IRQ) {
-		/*
-		 * Device takes too long to do the transfer when user requires
-		 * responsiveness.
-		 */
-		dev_dbg(chan->dev, "Inter-packet latency too long\n");
-	}
-
-	if (status & XILINX_DMA_DMASR_FRM_CNT_IRQ) {
+	if (status & (XILINX_DMA_DMASR_FRM_CNT_IRQ |
+		      XILINX_DMA_DMASR_DLY_CNT_IRQ)) {
 		spin_lock(&chan->lock);
 		xilinx_dma_complete_descriptor(chan);
 		chan->idle = true;
@@ -2818,6 +2818,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 	/* Retrieve the channel properties from the device tree */
 	has_dre = of_property_read_bool(node, "xlnx,include-dre");
 
+	of_property_read_u8(node, "xlnx,irq-delay", &chan->irq_delay);
+
 	chan->genlock = of_property_read_bool(node, "xlnx,genlock-mode");
 
 	err = of_property_read_u32(node, "xlnx,datawidth", &value);
-- 
2.53.0



