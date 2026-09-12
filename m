Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80105479891;
	Sat, 12 Sep 2026 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215772; cv=none; b=J2lEUQQC0i+gpgFn/VKR1pLrVyV7rFQNCuD94EvCJLDyOWVKTeomdr7ZiMAStj7DoAouIdBfrkOo/Ub858vAy2byiAFLAVF6zU/qhne0/a0phYpMqY7Rh9nnBkm3VY210NV9+TwpwQS/l5PM9haBb9PJoBjAHSV0nJ7EGHPxHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215772; c=relaxed/simple;
	bh=o++RfOk64V778i6QZBJc7038xyXnKUgcCsgYGfiFfjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeHbCtTYrpm022mj1Y/7z3MgUoru5KVXQQiUe/rKr198ePTy7PmRH/jgTgJ40E8WJWkhkKM/ydXf4Vt9MKfS2bbu7zASL6bw0XaVWPXjIZ1hr+DJTIIbwYqU0+OCcIvght4DzFb5f6G5uM6RRBzFMPXZY6XHxwrJLHWzDMZa+PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Avg+tf6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Avg+tf6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4B81F000FF;
	Sat, 12 Sep 2026 12:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215771;
	bh=qeXL/uW2CnIdThwtAhlskmMWA0oAVDdumNb7K3DWAzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Avg+tf6jvPzpaWuWh/UQOoeWpZeGN4Rkv5bZcTlpqqnBwuIxr5txQriHhQV5Rc2Cw
	 wczJN0SsDUqTi4Mz7e1DqljZh+YPinXXRXhUlj5Sgyhx1TuRvNJFxcb4B9RxQh8rWu
	 8cTA0Aku8OKYGGZ0QCwK51fayTF1x7UZaAjoRx6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0598/1376] dmaengine: dw-edma: Terminate all descriptors without callbacks
Date: Sat, 12 Sep 2026 08:50:24 +0200
Message-ID: <20260912065620.861383402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 99109a51efd28c9a661fbfb9469b023c517b31d1 ]

The DMA Engine client documentation says in the "Terminate APIs" section
of Documentation/driver-api/dmaengine/client.rst:

"No callback functions will be called for any incomplete transfers."

dw-edma instead calls vchan_cookie_complete() when a deferred STOP reaches
the interrupt handler. This schedules a callback for the active descriptor
and leaves other issued or submitted descriptors queued. A late callback
after dmaengine_terminate_sync() can dereference client state that has
already been freed, while leftover descriptors may later restart into
reused buffers or leak.

Move all issued and submitted descriptors to the terminated list whenever
termination completes. For a pending STOP, do this from both the DONE and
ABORT paths. Complete their cookies in order without scheduling callbacks.

A STOP can remain pending until the running transfer raises an
interrupt. Make device_synchronize() wait for such a pending STOP to
complete before releasing terminated descriptors. Reuse it from
free_chan_resources(), then release the remaining virt-dma resources.
Sleep instead of busy-polling while waiting, and warn if the existing
timeout expires.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-3-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 90 +++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index fa0691c3b330d..e8ac14e7691e2 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/dmaengine.h>
@@ -212,6 +213,35 @@ static int dw_edma_start_transfer(struct dw_edma_chan *chan)
 	return 1;
 }
 
+static void dw_edma_terminate_vdesc(struct virt_dma_desc *vd)
+{
+	list_del(&vd->node);
+	dma_cookie_complete(&vd->tx);
+	vchan_terminate_vdesc(vd);
+}
+
+static void dw_edma_terminate_vdesc_list(struct list_head *head)
+{
+	struct virt_dma_desc *vd, *_vd;
+
+	list_for_each_entry_safe(vd, _vd, head, node)
+		dw_edma_terminate_vdesc(vd);
+}
+
+/* Must be called with vc.lock held. */
+static void dw_edma_terminate_all_descs(struct dw_edma_chan *chan)
+{
+	/*
+	 * This order must not be reversed. Cookies are assigned when
+	 * descriptors are submitted, so desc_issued contains older cookies
+	 * than desc_submitted. Completing desc_submitted first could move
+	 * chan->vc.chan.completed_cookie backwards when desc_issued is
+	 * terminated afterwards.
+	 */
+	dw_edma_terminate_vdesc_list(&chan->vc.desc_issued);
+	dw_edma_terminate_vdesc_list(&chan->vc.desc_submitted);
+}
+
 static void dw_edma_device_caps(struct dma_chan *dchan,
 				struct dma_slave_caps *caps)
 {
@@ -283,20 +313,22 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	int err = 0;
 
+	guard(spinlock_irqsave)(&chan->vc.lock);
+
 	if (!chan->configured) {
-		/* Do nothing */
+		dw_edma_terminate_all_descs(chan);
 	} else if (chan->status == EDMA_ST_PAUSE) {
+		dw_edma_terminate_all_descs(chan);
 		chan->status = EDMA_ST_IDLE;
-		chan->configured = false;
 	} else if (chan->status == EDMA_ST_IDLE) {
-		chan->configured = false;
+		dw_edma_terminate_all_descs(chan);
 	} else if (dw_edma_core_ch_status(chan) == DMA_COMPLETE) {
 		/*
 		 * The channel is in a false BUSY state, probably didn't
 		 * receive or lost an interrupt
 		 */
+		dw_edma_terminate_all_descs(chan);
 		chan->status = EDMA_ST_IDLE;
-		chan->configured = false;
 	} else if (chan->request > EDMA_REQ_PAUSE) {
 		err = -EPERM;
 	} else {
@@ -652,8 +684,7 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 			break;
 
 		case EDMA_REQ_STOP:
-			list_del(&vd->node);
-			vchan_cookie_complete(vd);
+			dw_edma_terminate_all_descs(chan);
 			chan->request = EDMA_REQ_NONE;
 			chan->status = EDMA_ST_IDLE;
 			break;
@@ -672,7 +703,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
-	if (vd) {
+	if (vd && chan->request == EDMA_REQ_STOP) {
+		dw_edma_terminate_all_descs(chan);
+	} else if (vd) {
 		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
@@ -720,21 +753,49 @@ static int dw_edma_alloc_chan_resources(struct dma_chan *dchan)
 	return 0;
 }
 
-static void dw_edma_free_chan_resources(struct dma_chan *dchan)
+static void dw_edma_wait_termination(struct dma_chan *dchan)
 {
+	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	unsigned long timeout = jiffies + msecs_to_jiffies(5000);
-	int ret;
+	bool stopping;
 
+	/*
+	 * A STOP may be deferred to a later interrupt while the channel is still
+	 * running. Wait until that handler completes the termination.
+	 */
 	while (time_before(jiffies, timeout)) {
-		ret = dw_edma_device_terminate_all(dchan);
-		if (!ret)
-			break;
+		scoped_guard(spinlock_irqsave, &chan->vc.lock)
+			stopping = chan->request == EDMA_REQ_STOP;
 
-		if (time_after_eq(jiffies, timeout))
+		if (!stopping)
 			return;
 
-		cpu_relax();
+		fsleep(1000);
 	}
+
+	dev_warn(chan->dw->chip->dev,
+		 "timeout waiting for channel termination\n");
+}
+
+static void dw_edma_device_synchronize(struct dma_chan *dchan)
+{
+	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
+
+	dw_edma_wait_termination(dchan);
+	vchan_synchronize(&chan->vc);
+}
+
+static void dw_edma_free_chan_resources(struct dma_chan *dchan)
+{
+	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
+
+	dw_edma_device_terminate_all(dchan);
+	dw_edma_device_synchronize(dchan);
+
+	scoped_guard(spinlock_irqsave, &chan->vc.lock)
+		chan->configured = false;
+
+	vchan_free_chan_resources(&chan->vc);
 }
 
 static int dw_edma_channel_setup(struct dw_edma *dw, u32 wr_alloc, u32 rd_alloc)
@@ -830,6 +891,7 @@ static int dw_edma_channel_setup(struct dw_edma *dw, u32 wr_alloc, u32 rd_alloc)
 	dma->device_pause = dw_edma_device_pause;
 	dma->device_resume = dw_edma_device_resume;
 	dma->device_terminate_all = dw_edma_device_terminate_all;
+	dma->device_synchronize = dw_edma_device_synchronize;
 	dma->device_issue_pending = dw_edma_device_issue_pending;
 	dma->device_tx_status = dw_edma_device_tx_status;
 	dma->device_prep_slave_sg = dw_edma_device_prep_slave_sg;
-- 
2.53.0



