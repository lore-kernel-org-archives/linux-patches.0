Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE4211278;
	Wed,  7 May 2025 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645168; cv=none; b=LFBOsHB207k0T9KTXPtim+dhE3D+lu9WDe1pFg1o6u5FZ+cWQcg4zzZlUMYcXESyCi92eUgK9HZ5b08CwtA7zuGlASPUj0nENzN/MMk2tZBSEbNy6RAMvu6AnS0jkxuC6yMAkhUIvind++w3F69t07CxveEtBVRXT7QL2mcBgh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645168; c=relaxed/simple;
	bh=5s85lvBc3vwGbCvieBPLnBPTIlSkQDebIhepD7FVx8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMGZjDfoIwU/VatYqsLauaOMdSvB3PXBb366NrzI8Prt4NbKTxjNBsJAXeiEg2M6f/kxtiFJdrtxgo4mdNHxUJsH4ou3X1arwz3k+gdGyIU46RwC+ORKL66b/lQHGbBE+GAb8teDhJM2xtQBdFRa0l2EBiB5tQQrIxqAqQGqerI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RSqJDYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RSqJDYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBAEC4CEE9;
	Wed,  7 May 2025 19:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645167;
	bh=5s85lvBc3vwGbCvieBPLnBPTIlSkQDebIhepD7FVx8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RSqJDYOM8zauscFMluGRA29hwk957dJWXlVneIkhfogK0EPD0NCNLH8laKF7hRhu
	 +mVcWrISR5tgkQM593zjikjB5Pll3bH9QT2RnCw5xUaQ2fyCo8iLGNqjaNEcNhYoZH
	 yQP6LC5d0hR0uMOQR5GW+YzkSFB66gwYhCXGgp5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/129] xhci: add support to allocate several interrupters
Date: Wed,  7 May 2025 20:40:50 +0200
Message-ID: <20250507183818.212896041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit c99b38c412343053e9af187e595793c8805bb9b8 ]

Modify the XHCI drivers to accommodate for handling multiple event rings in
case there are multiple interrupters.  Add the required APIs so clients are
able to allocate/request for an interrupter ring, and pass this information
back to the client driver.  This allows for users to handle the resource
accordingly, such as passing the event ring base address to an audio DSP.
There is no actual support for multiple MSI/MSI-X vectors.

[export xhci_initialize_ring_info() -wcheng]

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240102214549.22498-2-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-debugfs.c |   2 +-
 drivers/usb/host/xhci-mem.c     | 108 ++++++++++++++++++++++++++++----
 drivers/usb/host/xhci-ring.c    |   2 +-
 drivers/usb/host/xhci.c         |  51 +++++++++------
 drivers/usb/host/xhci.h         |   6 +-
 5 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 99baa60ef50fe..15a8402ee8a17 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -693,7 +693,7 @@ void xhci_debugfs_init(struct xhci_hcd *xhci)
 				     "command-ring",
 				     xhci->debugfs_root);
 
-	xhci_debugfs_create_ring_dir(xhci, &xhci->interrupter->event_ring,
+	xhci_debugfs_create_ring_dir(xhci, &xhci->interrupters[0]->event_ring,
 				     "event-ring",
 				     xhci->debugfs_root);
 
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index f00e96c9ca57a..3ab547a6e4ce9 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -318,6 +318,7 @@ void xhci_initialize_ring_info(struct xhci_ring *ring,
 	 */
 	ring->num_trbs_free = ring->num_segs * (TRBS_PER_SEGMENT - 1) - 1;
 }
+EXPORT_SYMBOL_GPL(xhci_initialize_ring_info);
 
 /* Allocate segments and link them for a ring */
 static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
@@ -1849,6 +1850,31 @@ xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 	kfree(ir);
 }
 
+void xhci_remove_secondary_interrupter(struct usb_hcd *hcd, struct xhci_interrupter *ir)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	unsigned int intr_num;
+
+	/* interrupter 0 is primary interrupter, don't touch it */
+	if (!ir || !ir->intr_num || ir->intr_num >= xhci->max_interrupters)
+		xhci_dbg(xhci, "Invalid secondary interrupter, can't remove\n");
+
+	/* fixme, should we check xhci->interrupter[intr_num] == ir */
+	/* fixme locking */
+
+	spin_lock_irq(&xhci->lock);
+
+	intr_num = ir->intr_num;
+
+	xhci_remove_interrupter(xhci, ir);
+	xhci->interrupters[intr_num] = NULL;
+
+	spin_unlock_irq(&xhci->lock);
+
+	xhci_free_interrupter(xhci, ir);
+}
+EXPORT_SYMBOL_GPL(xhci_remove_secondary_interrupter);
+
 void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct device	*dev = xhci_to_hcd(xhci)->self.sysdev;
@@ -1856,10 +1882,14 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 
 	cancel_delayed_work_sync(&xhci->cmd_timer);
 
-	xhci_remove_interrupter(xhci, xhci->interrupter);
-	xhci_free_interrupter(xhci, xhci->interrupter);
-	xhci->interrupter = NULL;
-	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Freed primary event ring");
+	for (i = 0; i < xhci->max_interrupters; i++) {
+		if (xhci->interrupters[i]) {
+			xhci_remove_interrupter(xhci, xhci->interrupters[i]);
+			xhci_free_interrupter(xhci, xhci->interrupters[i]);
+			xhci->interrupters[i] = NULL;
+		}
+	}
+	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Freed interrupters");
 
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
@@ -1929,6 +1959,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	for (i = 0; i < xhci->num_port_caps; i++)
 		kfree(xhci->port_caps[i].psi);
 	kfree(xhci->port_caps);
+	kfree(xhci->interrupters);
 	xhci->num_port_caps = 0;
 
 	xhci->usb2_rhub.ports = NULL;
@@ -1937,6 +1968,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
 	xhci->port_caps = NULL;
+	xhci->interrupters = NULL;
 
 	xhci->page_size = 0;
 	xhci->page_shift = 0;
@@ -2243,18 +2275,20 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 }
 
 static struct xhci_interrupter *
-xhci_alloc_interrupter(struct xhci_hcd *xhci, gfp_t flags)
+xhci_alloc_interrupter(struct xhci_hcd *xhci, int segs, gfp_t flags)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	struct xhci_interrupter *ir;
-	unsigned int num_segs;
+	unsigned int num_segs = segs;
 	int ret;
 
 	ir = kzalloc_node(sizeof(*ir), flags, dev_to_node(dev));
 	if (!ir)
 		return NULL;
 
-	num_segs = min_t(unsigned int, 1 << HCS_ERST_MAX(xhci->hcs_params2),
+	/* number of ring segments should be greater than 0 */
+	if (segs <= 0)
+		num_segs = min_t(unsigned int, 1 << HCS_ERST_MAX(xhci->hcs_params2),
 			 ERST_MAX_SEGS);
 
 	ir->event_ring = xhci_ring_alloc(xhci, num_segs, 1, TYPE_EVENT, 0,
@@ -2289,6 +2323,13 @@ xhci_add_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir,
 		return -EINVAL;
 	}
 
+	if (xhci->interrupters[intr_num]) {
+		xhci_warn(xhci, "Interrupter %d\n already set up", intr_num);
+		return -EINVAL;
+	}
+
+	xhci->interrupters[intr_num] = ir;
+	ir->intr_num = intr_num;
 	ir->ir_set = &xhci->run_regs->ir_set[intr_num];
 
 	/* set ERST count with the number of entries in the segment table */
@@ -2311,10 +2352,52 @@ xhci_add_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir,
 	return 0;
 }
 
+struct xhci_interrupter *
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, int num_seg)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct xhci_interrupter *ir;
+	unsigned int i;
+	int err = -ENOSPC;
+
+	if (!xhci->interrupters || xhci->max_interrupters <= 1)
+		return NULL;
+
+	ir = xhci_alloc_interrupter(xhci, num_seg, GFP_KERNEL);
+	if (!ir)
+		return NULL;
+
+	spin_lock_irq(&xhci->lock);
+
+	/* Find available secondary interrupter, interrupter 0 is reserved for primary */
+	for (i = 1; i < xhci->max_interrupters; i++) {
+		if (xhci->interrupters[i] == NULL) {
+			err = xhci_add_interrupter(xhci, ir, i);
+			break;
+		}
+	}
+
+	spin_unlock_irq(&xhci->lock);
+
+	if (err) {
+		xhci_warn(xhci, "Failed to add secondary interrupter, max interrupters %d\n",
+			  xhci->max_interrupters);
+		xhci_free_interrupter(xhci, ir);
+		return NULL;
+	}
+
+	xhci_dbg(xhci, "Add secondary interrupter %d, max interrupters %d\n",
+		 i, xhci->max_interrupters);
+
+	return ir;
+}
+EXPORT_SYMBOL_GPL(xhci_create_secondary_interrupter);
+
 int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 {
-	dma_addr_t	dma;
+	struct xhci_interrupter *ir;
 	struct device	*dev = xhci_to_hcd(xhci)->self.sysdev;
+	dma_addr_t	dma;
 	unsigned int	val, val2;
 	u64		val_64;
 	u32		page_size, temp;
@@ -2439,11 +2522,14 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	/* Allocate and set up primary interrupter 0 with an event ring. */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 		       "Allocating primary event ring");
-	xhci->interrupter = xhci_alloc_interrupter(xhci, flags);
-	if (!xhci->interrupter)
+	xhci->interrupters = kcalloc_node(xhci->max_interrupters, sizeof(*xhci->interrupters),
+					  flags, dev_to_node(dev));
+
+	ir = xhci_alloc_interrupter(xhci, 0, flags);
+	if (!ir)
 		goto fail;
 
-	if (xhci_add_interrupter(xhci, xhci->interrupter, 0))
+	if (xhci_add_interrupter(xhci, ir, 0))
 		goto fail;
 
 	xhci->isoc_bei_interval = AVOID_BEI_INTERVAL_MAX;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 884a668cca367..5a53280fa2edf 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3225,7 +3225,7 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	writel(status, &xhci->op_regs->status);
 
 	/* This is the handler of the primary interrupter */
-	ir = xhci->interrupter;
+	ir = xhci->interrupters[0];
 	if (!hcd->msi_enabled) {
 		u32 irq_pending;
 		irq_pending = readl(&ir->ir_set->irq_pending);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 70e6c240a5409..5c3250989047e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -457,7 +457,7 @@ static int xhci_init(struct usb_hcd *hcd)
 
 static int xhci_run_finished(struct xhci_hcd *xhci)
 {
-	struct xhci_interrupter *ir = xhci->interrupter;
+	struct xhci_interrupter *ir = xhci->interrupters[0];
 	unsigned long	flags;
 	u32		temp;
 
@@ -509,7 +509,7 @@ int xhci_run(struct usb_hcd *hcd)
 	u64 temp_64;
 	int ret;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct xhci_interrupter *ir = xhci->interrupter;
+	struct xhci_interrupter *ir = xhci->interrupters[0];
 	/* Start the xHCI host controller running only after the USB 2.0 roothub
 	 * is setup.
 	 */
@@ -573,7 +573,7 @@ void xhci_stop(struct usb_hcd *hcd)
 {
 	u32 temp;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct xhci_interrupter *ir = xhci->interrupter;
+	struct xhci_interrupter *ir = xhci->interrupters[0];
 
 	mutex_lock(&xhci->mutex);
 
@@ -669,36 +669,51 @@ EXPORT_SYMBOL_GPL(xhci_shutdown);
 #ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
 {
-	struct xhci_interrupter *ir = xhci->interrupter;
+	struct xhci_interrupter *ir;
+	unsigned int i;
 
 	xhci->s3.command = readl(&xhci->op_regs->command);
 	xhci->s3.dev_nt = readl(&xhci->op_regs->dev_notification);
 	xhci->s3.dcbaa_ptr = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
 	xhci->s3.config_reg = readl(&xhci->op_regs->config_reg);
 
-	if (!ir)
-		return;
+	/* save both primary and all secondary interrupters */
+	/* fixme, shold we lock  to prevent race with remove secondary interrupter? */
+	for (i = 0; i < xhci->max_interrupters; i++) {
+		ir = xhci->interrupters[i];
+		if (!ir)
+			continue;
 
-	ir->s3_erst_size = readl(&ir->ir_set->erst_size);
-	ir->s3_erst_base = xhci_read_64(xhci, &ir->ir_set->erst_base);
-	ir->s3_erst_dequeue = xhci_read_64(xhci, &ir->ir_set->erst_dequeue);
-	ir->s3_irq_pending = readl(&ir->ir_set->irq_pending);
-	ir->s3_irq_control = readl(&ir->ir_set->irq_control);
+		ir->s3_erst_size = readl(&ir->ir_set->erst_size);
+		ir->s3_erst_base = xhci_read_64(xhci, &ir->ir_set->erst_base);
+		ir->s3_erst_dequeue = xhci_read_64(xhci, &ir->ir_set->erst_dequeue);
+		ir->s3_irq_pending = readl(&ir->ir_set->irq_pending);
+		ir->s3_irq_control = readl(&ir->ir_set->irq_control);
+	}
 }
 
 static void xhci_restore_registers(struct xhci_hcd *xhci)
 {
-	struct xhci_interrupter *ir = xhci->interrupter;
+	struct xhci_interrupter *ir;
+	unsigned int i;
 
 	writel(xhci->s3.command, &xhci->op_regs->command);
 	writel(xhci->s3.dev_nt, &xhci->op_regs->dev_notification);
 	xhci_write_64(xhci, xhci->s3.dcbaa_ptr, &xhci->op_regs->dcbaa_ptr);
 	writel(xhci->s3.config_reg, &xhci->op_regs->config_reg);
-	writel(ir->s3_erst_size, &ir->ir_set->erst_size);
-	xhci_write_64(xhci, ir->s3_erst_base, &ir->ir_set->erst_base);
-	xhci_write_64(xhci, ir->s3_erst_dequeue, &ir->ir_set->erst_dequeue);
-	writel(ir->s3_irq_pending, &ir->ir_set->irq_pending);
-	writel(ir->s3_irq_control, &ir->ir_set->irq_control);
+
+	/* FIXME should we lock to protect against freeing of interrupters */
+	for (i = 0; i < xhci->max_interrupters; i++) {
+		ir = xhci->interrupters[i];
+		if (!ir)
+			continue;
+
+		writel(ir->s3_erst_size, &ir->ir_set->erst_size);
+		xhci_write_64(xhci, ir->s3_erst_base, &ir->ir_set->erst_base);
+		xhci_write_64(xhci, ir->s3_erst_dequeue, &ir->ir_set->erst_dequeue);
+		writel(ir->s3_irq_pending, &ir->ir_set->irq_pending);
+		writel(ir->s3_irq_control, &ir->ir_set->irq_control);
+	}
 }
 
 static void xhci_set_cmd_ring_deq(struct xhci_hcd *xhci)
@@ -1061,7 +1076,7 @@ int xhci_resume(struct xhci_hcd *xhci, pm_message_t msg)
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");
 		temp = readl(&xhci->op_regs->status);
 		writel((temp & ~0x1fff) | STS_EINT, &xhci->op_regs->status);
-		xhci_disable_interrupter(xhci->interrupter);
+		xhci_disable_interrupter(xhci->interrupters[0]);
 
 		xhci_dbg(xhci, "cleaning up memory\n");
 		xhci_mem_cleanup(xhci);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index a49560145d78b..9d2cf11cef846 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1549,7 +1549,7 @@ struct xhci_hcd {
 	struct reset_control *reset;
 	/* data structures */
 	struct xhci_device_context_array *dcbaa;
-	struct xhci_interrupter *interrupter;
+	struct xhci_interrupter **interrupters;
 	struct xhci_ring	*cmd_ring;
 	unsigned int            cmd_ring_state;
 #define CMD_RING_STATE_RUNNING         (1 << 0)
@@ -1866,6 +1866,10 @@ struct xhci_container_ctx *xhci_alloc_container_ctx(struct xhci_hcd *xhci,
 		int type, gfp_t flags);
 void xhci_free_container_ctx(struct xhci_hcd *xhci,
 		struct xhci_container_ctx *ctx);
+struct xhci_interrupter *
+xhci_create_secondary_interrupter(struct usb_hcd *hcd, int num_seg);
+void xhci_remove_secondary_interrupter(struct usb_hcd
+				       *hcd, struct xhci_interrupter *ir);
 
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
-- 
2.39.5



