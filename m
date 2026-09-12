Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ED634252D;
	Sat, 12 Sep 2026 07:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199175; cv=none; b=jyBdi5FpGhTPLaGIltmml2OK2E3E0vz0FCxIpNOuPTz/2UGyHdYNsmsgC2mNFppF8y7oMMIIRieE87+dkN7E6FWHzJrtN9WjR2WB9ReADSr0wsL7WDGcyTpmfp+CyQ6CY9LOTbknsRILSFbAArR5MIVY6DfDbAkjMCHePnDw21w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199175; c=relaxed/simple;
	bh=az3NasUrf1LtgYb/ZMOL4r2lDQcSbbtoKBCzz68+v3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot3aLPdeLSxbospo45apmY7XsNnatNJvEfaTBuA6BQ7nAu+GnkCjHVAT+3mV6vPy29fPAaJTDy1KVtBiGWk7520wftr0/t/1K9lNpKjgSbzKxa3SVWgq0hJ7reeibVUV8pq1lWWr14j2BrbWpz35GH3z+Vq4JXEORfhvoP0csSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXD1McAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXD1McAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5E91F000FF;
	Sat, 12 Sep 2026 07:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199173;
	bh=81C+bvhtqQtHsUUMxQhPsFBDoGwzF1oJw+tc/lrf/bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXD1McAg7Tbc+u7NvPt741KRwVh7NE6vGFKuCjc/qgv1lYGSykpJLQGxylCWxPcw+
	 qnGuHe2Oid7d8pI6Jbp3EQPhlzP4MSHopV6Na+O8FOGTbwKYbAVXRLWOaz2ZY5Mpp2
	 lLIc2FzqSqja+hjLOF1NLjnnoxo3fbCvOSLmDK5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0530/1815] dmaengine: dw-edma: Terminate all descriptors without callbacks
Date: Sat, 12 Sep 2026 08:38:00 +0200
Message-ID: <20260912065701.324636032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 18ec188c99119..64e7d7403ab4f 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/dmaengine.h>
@@ -201,6 +202,35 @@ static int dw_edma_start_transfer(struct dw_edma_chan *chan)
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
@@ -309,20 +339,22 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
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
@@ -686,8 +718,7 @@ static void dw_edma_done_interrupt(struct dw_edma_chan *chan)
 			break;
 
 		case EDMA_REQ_STOP:
-			list_del(&vd->node);
-			vchan_cookie_complete(vd);
+			dw_edma_terminate_all_descs(chan);
 			chan->request = EDMA_REQ_NONE;
 			chan->status = EDMA_ST_IDLE;
 			break;
@@ -706,7 +737,9 @@ static void dw_edma_abort_interrupt(struct dw_edma_chan *chan)
 
 	spin_lock_irqsave(&chan->vc.lock, flags);
 	vd = vchan_next_desc(&chan->vc);
-	if (vd) {
+	if (vd && chan->request == EDMA_REQ_STOP) {
+		dw_edma_terminate_all_descs(chan);
+	} else if (vd) {
 		dw_hdma_set_callback_result(vd, DMA_TRANS_ABORTED);
 		list_del(&vd->node);
 		vchan_cookie_complete(vd);
@@ -865,21 +898,49 @@ static int dw_edma_alloc_chan_resources(struct dma_chan *dchan)
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
@@ -976,6 +1037,7 @@ static int dw_edma_channel_setup(struct dw_edma *dw, u32 wr_alloc, u32 rd_alloc)
 	dma->device_pause = dw_edma_device_pause;
 	dma->device_resume = dw_edma_device_resume;
 	dma->device_terminate_all = dw_edma_device_terminate_all;
+	dma->device_synchronize = dw_edma_device_synchronize;
 	dma->device_issue_pending = dw_edma_device_issue_pending;
 	dma->device_tx_status = dw_edma_device_tx_status;
 	dma->device_prep_slave_sg = dw_edma_device_prep_slave_sg;
-- 
2.53.0



