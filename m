Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7853A2DC331;
	Mon, 17 Aug 2026 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979023; cv=none; b=foo1ex6JyAnlDfdOFLOJEnYBYTCumO+ZPvXlddlZdndUzrGktIc2+jRfGc7m0mV315M3wVcKjuaywzbGBsthBTHKYqLoaE5WRN3LKO8Rk69Ktz6Bt+1WD7pbz1xQc1oN/vtXKVKx9IqneyKkezqPU3FY/WoMIDpJ90/X+eWsCD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979023; c=relaxed/simple;
	bh=XjE1oAxTPgbGMAKV5NDgMEZv1z59qdF5wMZRysx+of8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAVGq6K61fri4fJFD7hO183U5nlA/Q0uj5Ou8yxcfdCLGdRBIM3myWZPbWsHBU+trycI679d/47FToNsPob8Vh0fviO+ujkfCO3k9MAohUCJaN7Sfh5bMZHdeQxNuQUfffpR/fzY5j97lyiL9qu/ByqTWV4JxNfU2e2tBB9KFFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuVR0qQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuVR0qQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78811F000E9;
	Mon, 17 Aug 2026 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979021;
	bh=a2EZ0Il5TX8I7HiA0NVvXkyuk0a9P9tzEnX/Xv6qn/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuVR0qQiigNbSR49Knr14mCmZ/Z938eqgxaQEMdElIsiJAcOUNLbo/rK50NhiSJJL
	 p7EKz68jItSyds4G4H3mjEhm3VWYIn5Z0Flh6UjgzhfvzPNIxzI3sONxmKUR5D0lzR
	 dSFUtFgVrHr0GmpitzAELnI3nNeSbBpqH84QF6M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.1 082/609] usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown
Date: Mon, 17 Aug 2026 15:26:18 +0200
Message-ID: <20260817132546.321782594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 0583f2fbf8f86ae3a0ce054f96783dd83e65d9bb upstream.

The Broadcom BDC UDC driver registers its IRQ handler with
devm_request_irq() in bdc_udc_init(), so the IRQ is released by devm
only after bdc_remove() returns.  devm releases resources in reverse
LIFO order, but bdc_remove() runs bdc_udc_exit() and bdc_hw_exit() ->
bdc_mem_free() manually before returning: bdc_udc_exit() tears down
individual endpoint objects via bdc_free_ep(), while bdc_hw_exit() ->
bdc_mem_free() frees and NULLs the DMA-coherent status-report ring
(bdc->srr.sr_bds) and kfree()s bdc->bdc_ep_array.  Both happen while
the IRQ handler (bdc_udc_interrupt, requested with IRQF_SHARED)
remains deliverable in the window up to the post-remove devm
free_irq().

On receipt of a shared interrupt in that window, bdc_udc_interrupt()
dereferences bdc->srr.sr_bds[bdc->srr.dqp_index] (NULL or freed DMA)
and dispatches sr_handler callbacks that index into bdc_ep_array,
causing a NULL-deref or use-after-free.

The same window affects the delayed_work bdc->func_wake_notify, which is
armed from the IRQ handler via bdc_sr_uspc() -> handle_link_state_change()
-> schedule_delayed_work() and may self-rearm from its own callback
bdc_func_wake_timer().  No cancel exists anywhere in the driver, so a
queued work item that fires after bdc_remove() returns and the bdc
structure is devm-freed dereferences freed memory.

Replace devm_request_irq() with request_irq() and add an explicit
free_irq(bdc->irq, bdc) in bdc_remove().  Clear BDC_GIE before
free_irq() to stop the device from asserting interrupts, then
free_irq() drains any in-flight handler, then cancel_delayed_work_sync()
drains the func_wake_notify delayed work.  This ordering ensures the
IRQ handler and delayed work cannot interfere with the subsequent
endpoint and DMA teardown in bdc_udc_exit() and bdc_hw_exit().  Wire the
matching free_irq() into the bdc_udc_init() error path so the IRQ is
released on probe failure, and route the bdc_init_ep() failure through
err0 instead of returning directly.

This issue was found by an in-house static analysis tool.

Fixes: efed421a94e6 ("usb: gadget: Add UDC driver for Broadcom USB3.0 device controller IP BDC")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260709020904.502611-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c |   20 ++++++++++++++++++++
 drivers/usb/gadget/udc/bdc/bdc_udc.c  |    7 ++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -586,9 +586,29 @@ disable_clk:
 static int bdc_remove(struct platform_device *pdev)
 {
 	struct bdc *bdc;
+	unsigned long flags;
+	u32 temp;
 
 	bdc  = platform_get_drvdata(pdev);
 	dev_dbg(bdc->dev, "%s ()\n", __func__);
+	/*
+	 * Disable the device interrupt source before freeing the IRQ:
+	 * clear BDC_GIE so the controller stops asserting interrupts,
+	 * then free_irq drains any in-flight handler.
+	 */
+	spin_lock_irqsave(&bdc->lock, flags);
+	temp = bdc_readl(bdc->regs, BDC_BDCSC);
+	temp &= ~BDC_GIE;
+	bdc_writel(bdc->regs, BDC_BDCSC, temp);
+	spin_unlock_irqrestore(&bdc->lock, flags);
+	free_irq(bdc->irq, bdc);
+	/*
+	 * Drain func_wake_notify after free_irq: the IRQ handler arms this
+	 * delayed_work via bdc_sr_uspc -> handle_link_state_change ->
+	 * schedule_delayed_work (self-rearmed in bdc_func_wake_timer), so
+	 * the IRQ must be released first to prevent re-arm after cancel.
+	 */
+	cancel_delayed_work_sync(&bdc->func_wake_notify);
 	bdc_udc_exit(bdc);
 	bdc_hw_exit(bdc);
 	bdc_phy_exit(bdc);
--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -530,8 +530,8 @@ int bdc_udc_init(struct bdc *bdc)
 
 
 	bdc->gadget.name = BRCM_BDC_NAME;
-	ret = devm_request_irq(bdc->dev, bdc->irq, bdc_udc_interrupt,
-				IRQF_SHARED, BRCM_BDC_NAME, bdc);
+	ret = request_irq(bdc->irq, bdc_udc_interrupt, IRQF_SHARED,
+			  BRCM_BDC_NAME, bdc);
 	if (ret) {
 		dev_err(bdc->dev,
 			"failed to request irq #%d %d\n",
@@ -542,7 +542,7 @@ int bdc_udc_init(struct bdc *bdc)
 	ret = bdc_init_ep(bdc);
 	if (ret) {
 		dev_err(bdc->dev, "bdc init ep fail: %d\n", ret);
-		return ret;
+		goto err0;
 	}
 
 	ret = usb_add_gadget_udc(bdc->dev, &bdc->gadget);
@@ -571,6 +571,7 @@ int bdc_udc_init(struct bdc *bdc)
 err1:
 	usb_del_gadget_udc(&bdc->gadget);
 err0:
+	free_irq(bdc->irq, bdc);
 	bdc_free_ep(bdc);
 
 	return ret;


