Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DD412D1FC;
	Tue, 30 Apr 2024 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474491; cv=none; b=WkEYgxV/pX+XFkq6EaT+cmBcKh4Cn8CnPit1LfyTrY1DplP9S0wYRz8Cc13OqGcHo7uZTNmTDZn0V2G+MdF7d0wvnt12mw1jy+tkSa7sgWqCxZ/R5iyDyLmNxrF/4H0jeKLt3LobRNxtzqalcXqOW2HS7gk+qqDLTtA/ww9R6Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474491; c=relaxed/simple;
	bh=xJiJbCXC4RAAqEUqDQ6wrnRp+SaDemLMTkzmzdpgXyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmp9rID3mPx8g+lSZ5sWUdhY0rbpHlJ6PMtcYXaPZhdC6LVh9w/jpRQPSHQwGaQmngBKh/Xksbufa8iaRhQwh2yXS7IkG90hmniFbE9PX1K3Xl73L3atuslU1GhQttdbATiO8fRqVtwBrTpAYIgcJlq4ttHxRG7aFDkIo1A8sD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7xwJ2ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7xwJ2ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2CDC2BBFC;
	Tue, 30 Apr 2024 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474491;
	bh=xJiJbCXC4RAAqEUqDQ6wrnRp+SaDemLMTkzmzdpgXyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7xwJ2ck8YWuiN7UER5QQddPf8MZV8G2uiXE+7ih2PzpobE3WrTQ2/IerPWinCjrQ
	 npu4K2g6SjwDbcAmk28SZDD+zhGxP5tZNl2vlXDZli3GlPRRbbOduwbADo9TL8gyAZ
	 2dbkT/pcpbW6X+f1lGO1iciDnqTXbu+k46GO+ztU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.8 172/228] dmaengine: xilinx: xdma: Fix synchronization issue
Date: Tue, 30 Apr 2024 12:39:10 +0200
Message-ID: <20240430103108.766818634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Chauvet <louis.chauvet@bootlin.com>

commit 6a40fb8245965b481b4dcce011cd63f20bf91ee0 upstream.

The current xdma_synchronize method does not properly wait for the last
transfer to be done. Due to limitations of the XMDA engine, it is not
possible to stop a transfer in the middle of a descriptor. Said
otherwise, if a stop is requested at the end of descriptor "N" and the OS
is fast enough, the DMA controller will effectively stop immediately.
However, if the OS is slightly too slow to request the stop and the DMA
engine starts descriptor "N+1", the N+1 transfer will be performed until
its end. This means that after a terminate_all, the last descriptor must
remain valid and the synchronization must wait for this last descriptor to
be terminated.

Fixes: 855c2e1d1842 ("dmaengine: xilinx: xdma: Rework xdma_terminate_all()")
Fixes: f5c392d106e7 ("dmaengine: xilinx: xdma: Add terminate_all/synchronize callbacks")
Cc: stable@vger.kernel.org
Suggested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://lore.kernel.org/r/20240327-digigram-xdma-fixes-v1-2-45f4a52c0283@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xdma-regs.h |    3 +++
 drivers/dma/xilinx/xdma.c      |   26 ++++++++++++++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/dma/xilinx/xdma-regs.h
+++ b/drivers/dma/xilinx/xdma-regs.h
@@ -117,6 +117,9 @@ struct xdma_hw_desc {
 			 CHAN_CTRL_IE_WRITE_ERROR |			\
 			 CHAN_CTRL_IE_DESC_ERROR)
 
+/* bits of the channel status register */
+#define XDMA_CHAN_STATUS_BUSY			BIT(0)
+
 #define XDMA_CHAN_STATUS_MASK CHAN_CTRL_START
 
 #define XDMA_CHAN_ERROR_MASK (CHAN_CTRL_IE_DESC_ALIGN_MISMATCH |	\
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -71,6 +71,8 @@ struct xdma_chan {
 	enum dma_transfer_direction	dir;
 	struct dma_slave_config		cfg;
 	u32				irq;
+	struct completion		last_interrupt;
+	bool				stop_requested;
 };
 
 /**
@@ -376,6 +378,8 @@ static int xdma_xfer_start(struct xdma_c
 		return ret;
 
 	xchan->busy = true;
+	xchan->stop_requested = false;
+	reinit_completion(&xchan->last_interrupt);
 
 	return 0;
 }
@@ -387,7 +391,6 @@ static int xdma_xfer_start(struct xdma_c
 static int xdma_xfer_stop(struct xdma_chan *xchan)
 {
 	int ret;
-	u32 val;
 	struct xdma_device *xdev = xchan->xdev_hdl;
 
 	/* clear run stop bit to prevent any further auto-triggering */
@@ -395,13 +398,7 @@ static int xdma_xfer_stop(struct xdma_ch
 			   CHAN_CTRL_RUN_STOP);
 	if (ret)
 		return ret;
-
-	/* Clear the channel status register */
-	ret = regmap_read(xdev->rmap, xchan->base + XDMA_CHAN_STATUS_RC, &val);
-	if (ret)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 /**
@@ -474,6 +471,8 @@ static int xdma_alloc_channels(struct xd
 		xchan->xdev_hdl = xdev;
 		xchan->base = base + i * XDMA_CHAN_STRIDE;
 		xchan->dir = dir;
+		xchan->stop_requested = false;
+		init_completion(&xchan->last_interrupt);
 
 		ret = xdma_channel_init(xchan);
 		if (ret)
@@ -521,6 +520,7 @@ static int xdma_terminate_all(struct dma
 	spin_lock_irqsave(&xdma_chan->vchan.lock, flags);
 
 	xdma_chan->busy = false;
+	xdma_chan->stop_requested = true;
 	vd = vchan_next_desc(&xdma_chan->vchan);
 	if (vd) {
 		list_del(&vd->node);
@@ -542,6 +542,13 @@ static int xdma_terminate_all(struct dma
 static void xdma_synchronize(struct dma_chan *chan)
 {
 	struct xdma_chan *xdma_chan = to_xdma_chan(chan);
+	struct xdma_device *xdev = xdma_chan->xdev_hdl;
+	int st = 0;
+
+	/* If the engine continues running, wait for the last interrupt */
+	regmap_read(xdev->rmap, xdma_chan->base + XDMA_CHAN_STATUS, &st);
+	if (st & XDMA_CHAN_STATUS_BUSY)
+		wait_for_completion_timeout(&xdma_chan->last_interrupt, msecs_to_jiffies(1000));
 
 	vchan_synchronize(&xdma_chan->vchan);
 }
@@ -876,6 +883,9 @@ static irqreturn_t xdma_channel_isr(int
 	u32 st;
 	bool repeat_tx;
 
+	if (xchan->stop_requested)
+		complete(&xchan->last_interrupt);
+
 	spin_lock(&xchan->vchan.lock);
 
 	/* get submitted request */


