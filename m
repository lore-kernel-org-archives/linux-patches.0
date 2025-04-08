Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165AB267F4F;
	Tue,  8 Apr 2025 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111603; cv=none; b=U6e35/e8LiAkl/0/CsidSW/b6y5BhrJLTJc0leGa7TA4XOa/VYBimUV4b6Xy/3rjynmdV3sIjvFr4pROH5dEk4xszy5kCuKSX7oGPCopiKjg17mcC2O7udUMR9eFm71Opfa5AuQpt1zYBRpIACTV8xUo1YfWVbNGZQKE/aRezyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111603; c=relaxed/simple;
	bh=xYKALRgjelDbRTKfNsknEaY2Dh9Wfg/ZkwU75sIy2gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUIQdwiHW2uLDxWFzjk9L4gA0FEUnXV+S0cgwFegyFFAiqXRsYfnCfKHNke8BPxShGq+ZGrU4+6Lh5n8DdHLGDJC/Rokt1IvywX07P25WzGGvBZB2EaYGdavcSS8wJ384esXxzVVdL4rulYGyVZbo4KQG3vOTrm78TSAPsM6CSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTdHiuSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTdHiuSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36095C4CEE5;
	Tue,  8 Apr 2025 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111601;
	bh=xYKALRgjelDbRTKfNsknEaY2Dh9Wfg/ZkwU75sIy2gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTdHiuSUcGfuPh4RwsGVFKM6uY6LlwryUCm8vUB+cMH5pbN/weyYj7D5hRRRft2yG
	 2dk2pW/WoM2r9kVlmZUzdIUfM+3Zw/KOkw9SmfeREQAhOl6iNdM8rLG8DIUTnk9awN
	 uEYND7bWKKz2Lbl2Usj9zE+ww9zMqVFQayeCb7tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 490/731] dmaengine: ptdma: Utilize the AE4DMA engines multi-queue functionality
Date: Tue,  8 Apr 2025 12:46:27 +0200
Message-ID: <20250408104925.674031947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 6565439894570a07b00dba0b739729fe6b56fba4 ]

As AE4DMA offers multi-channel functionality compared to PTDMA’s single
queue, utilize multi-queue, which supports higher speeds than PTDMA, to
achieve higher performance using the AE4DMA workqueue based mechanism.

Fixes: 69a47b16a51b ("dmaengine: ptdma: Extend ptdma to support multi-channel and version")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://lore.kernel.org/r/20250203162511.911946-4-Basavaraj.Natikar@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/amd/ae4dma/ae4dma.h         |  2 +
 drivers/dma/amd/ptdma/ptdma-dmaengine.c | 90 ++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/amd/ae4dma/ae4dma.h b/drivers/dma/amd/ae4dma/ae4dma.h
index 265c5d4360080..57f6048726bb6 100644
--- a/drivers/dma/amd/ae4dma/ae4dma.h
+++ b/drivers/dma/amd/ae4dma/ae4dma.h
@@ -37,6 +37,8 @@
 #define AE4_DMA_VERSION			4
 #define CMD_AE4_DESC_DW0_VAL		2
 
+#define AE4_TIME_OUT			5000
+
 struct ae4_msix {
 	int msix_count;
 	struct msix_entry msix_entry[MAX_AE4_HW_QUEUES];
diff --git a/drivers/dma/amd/ptdma/ptdma-dmaengine.c b/drivers/dma/amd/ptdma/ptdma-dmaengine.c
index 35c84ec9608b4..715ac3ae067b8 100644
--- a/drivers/dma/amd/ptdma/ptdma-dmaengine.c
+++ b/drivers/dma/amd/ptdma/ptdma-dmaengine.c
@@ -198,8 +198,10 @@ static struct pt_dma_desc *pt_handle_active_desc(struct pt_dma_chan *chan,
 {
 	struct dma_async_tx_descriptor *tx_desc;
 	struct virt_dma_desc *vd;
+	struct pt_device *pt;
 	unsigned long flags;
 
+	pt = chan->pt;
 	/* Loop over descriptors until one is found with commands */
 	do {
 		if (desc) {
@@ -217,7 +219,7 @@ static struct pt_dma_desc *pt_handle_active_desc(struct pt_dma_chan *chan,
 
 		spin_lock_irqsave(&chan->vc.lock, flags);
 
-		if (desc) {
+		if (pt->ver != AE4_DMA_VERSION && desc) {
 			if (desc->status != DMA_COMPLETE) {
 				if (desc->status != DMA_ERROR)
 					desc->status = DMA_COMPLETE;
@@ -235,7 +237,7 @@ static struct pt_dma_desc *pt_handle_active_desc(struct pt_dma_chan *chan,
 
 		spin_unlock_irqrestore(&chan->vc.lock, flags);
 
-		if (tx_desc) {
+		if (pt->ver != AE4_DMA_VERSION && tx_desc) {
 			dmaengine_desc_get_callback_invoke(tx_desc, NULL);
 			dma_run_dependencies(tx_desc);
 			vchan_vdesc_fini(vd);
@@ -245,11 +247,25 @@ static struct pt_dma_desc *pt_handle_active_desc(struct pt_dma_chan *chan,
 	return NULL;
 }
 
+static inline bool ae4_core_queue_full(struct pt_cmd_queue *cmd_q)
+{
+	u32 front_wi = readl(cmd_q->reg_control + AE4_WR_IDX_OFF);
+	u32 rear_ri = readl(cmd_q->reg_control + AE4_RD_IDX_OFF);
+
+	if (((MAX_CMD_QLEN + front_wi - rear_ri) % MAX_CMD_QLEN)  >= (MAX_CMD_QLEN - 1))
+		return true;
+
+	return false;
+}
+
 static void pt_cmd_callback(void *data, int err)
 {
 	struct pt_dma_desc *desc = data;
+	struct ae4_cmd_queue *ae4cmd_q;
 	struct dma_chan *dma_chan;
 	struct pt_dma_chan *chan;
+	struct ae4_device *ae4;
+	struct pt_device *pt;
 	int ret;
 
 	if (err == -EINPROGRESS)
@@ -257,11 +273,32 @@ static void pt_cmd_callback(void *data, int err)
 
 	dma_chan = desc->vd.tx.chan;
 	chan = to_pt_chan(dma_chan);
+	pt = chan->pt;
 
 	if (err)
 		desc->status = DMA_ERROR;
 
 	while (true) {
+		if (pt->ver == AE4_DMA_VERSION) {
+			ae4 = container_of(pt, struct ae4_device, pt);
+			ae4cmd_q = &ae4->ae4cmd_q[chan->id];
+
+			if (ae4cmd_q->q_cmd_count >= (CMD_Q_LEN - 1) ||
+			    ae4_core_queue_full(&ae4cmd_q->cmd_q)) {
+				wake_up(&ae4cmd_q->q_w);
+
+				if (wait_for_completion_timeout(&ae4cmd_q->cmp,
+								msecs_to_jiffies(AE4_TIME_OUT))
+								== 0) {
+					dev_err(pt->dev, "TIMEOUT %d:\n", ae4cmd_q->id);
+					break;
+				}
+
+				reinit_completion(&ae4cmd_q->cmp);
+				continue;
+			}
+		}
+
 		/* Check for DMA descriptor completion */
 		desc = pt_handle_active_desc(chan, desc);
 
@@ -296,6 +333,49 @@ static struct pt_dma_desc *pt_alloc_dma_desc(struct pt_dma_chan *chan,
 	return desc;
 }
 
+static void pt_cmd_callback_work(void *data, int err)
+{
+	struct dma_async_tx_descriptor *tx_desc;
+	struct pt_dma_desc *desc = data;
+	struct dma_chan *dma_chan;
+	struct virt_dma_desc *vd;
+	struct pt_dma_chan *chan;
+	unsigned long flags;
+
+	dma_chan = desc->vd.tx.chan;
+	chan = to_pt_chan(dma_chan);
+
+	if (err == -EINPROGRESS)
+		return;
+
+	tx_desc = &desc->vd.tx;
+	vd = &desc->vd;
+
+	if (err)
+		desc->status = DMA_ERROR;
+
+	spin_lock_irqsave(&chan->vc.lock, flags);
+	if (desc) {
+		if (desc->status != DMA_COMPLETE) {
+			if (desc->status != DMA_ERROR)
+				desc->status = DMA_COMPLETE;
+
+			dma_cookie_complete(tx_desc);
+			dma_descriptor_unmap(tx_desc);
+		} else {
+			tx_desc = NULL;
+		}
+	}
+	spin_unlock_irqrestore(&chan->vc.lock, flags);
+
+	if (tx_desc) {
+		dmaengine_desc_get_callback_invoke(tx_desc, NULL);
+		dma_run_dependencies(tx_desc);
+		list_del(&desc->vd.node);
+		vchan_vdesc_fini(vd);
+	}
+}
+
 static struct pt_dma_desc *pt_create_desc(struct dma_chan *dma_chan,
 					  dma_addr_t dst,
 					  dma_addr_t src,
@@ -327,6 +407,7 @@ static struct pt_dma_desc *pt_create_desc(struct dma_chan *dma_chan,
 	desc->len = len;
 
 	if (pt->ver == AE4_DMA_VERSION) {
+		pt_cmd->pt_cmd_callback = pt_cmd_callback_work;
 		ae4 = container_of(pt, struct ae4_device, pt);
 		ae4cmd_q = &ae4->ae4cmd_q[chan->id];
 		mutex_lock(&ae4cmd_q->cmd_lock);
@@ -367,13 +448,16 @@ static void pt_issue_pending(struct dma_chan *dma_chan)
 {
 	struct pt_dma_chan *chan = to_pt_chan(dma_chan);
 	struct pt_dma_desc *desc;
+	struct pt_device *pt;
 	unsigned long flags;
 	bool engine_is_idle = true;
 
+	pt = chan->pt;
+
 	spin_lock_irqsave(&chan->vc.lock, flags);
 
 	desc = pt_next_dma_desc(chan);
-	if (desc)
+	if (desc && pt->ver != AE4_DMA_VERSION)
 		engine_is_idle = false;
 
 	vchan_issue_pending(&chan->vc);
-- 
2.39.5



