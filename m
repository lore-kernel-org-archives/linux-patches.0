Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8C41D625;
	Thu, 30 Jul 2026 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423752; cv=none; b=R1s9ltR3Va2gmgWBdgTt1K6Zpm/8OfomkIa5VCyeP/hEMRxMHAW1JrTQvoy51MvZTi/TAu1b70Hkf9z3N/NbeWPJBGO54YmYNKK3vXmKsTCMpMXs+Gj/Om27C7uM5S2z1h4ZYu2LeipB/OKnQcQ6bemec3GxVEkJf1DlReNsLN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423752; c=relaxed/simple;
	bh=dVY4lEmDsa3AyQC7y4VCxk2QiMvF0oravamyxuRvIVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIJ55W8bDg1xjJbI1V36nqdVPfV+4F//DdOTjHlHZDv73FoX6VwriRZHsDCawH4MViBkg5wKEIsu2Lt2WMIJ+IuJqNIgDAq1ZiV6TNbnBtmDdbQ7YfAC4AWP68bWNhh++GLWaEmLOlKadfp8h7J8mbRRgGx1v5JKup9e/P2JW9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbFtNnR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbFtNnR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9041F00A3A;
	Thu, 30 Jul 2026 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423750;
	bh=07+ABckaMfR9hDC/JS40kOrIwtsHO9llbIqRJk8SlJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbFtNnR1lXG/P4AvZ1yBYYo+y8/Sgn4zNZfgI078FFDEV2GQNtK23J/Mom8+6nAC3
	 MwwyG3Mz6aDkb2gh2j0s7LgAXeu2W/1FMa6Zrpgk2Yvltcbtb+HlDq+xT5+sUc1/Np
	 L51aWp7TVVbyjbGATcAO6StBMf2GPLUAGS/OW5qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.18 152/675] usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown
Date: Thu, 30 Jul 2026 16:08:02 +0200
Message-ID: <20260730141448.367949599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 static void bdc_remove(struct platform_device *pdev)
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


