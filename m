Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6517C69;
	Mon, 14 Oct 2024 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920022; cv=none; b=JjS5WExqtug2TXvqHXf0C3Yejnpkcr1EWlobgbjB6VLzcokWBpuFwKVCk0Hol31onPKCmHia9ODRHh5eDo5wuayCY+cjN4uvzxF/ORQ7t8L5wajvWEI0J/Itly6K1M5CeAtnr2OKqp5acDvL7tG3LIVjnLx7hG5b/aff+iqVyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920022; c=relaxed/simple;
	bh=4rpOCwh+1ej9UT+9r6aeZE9XkZTDixug+zJySU25NLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKTZDIQPX6h6FIw5Qv4ISrygIcM4MhSS77NoM0wEdqsUqxW2uCmTOvTODCMPXqaN6bYq2GGheVwknsr0bz5MRYgQnrGC7FlCBA4HnCcYXI7D1mmcOtPtuyhRoL6EONBCICfRgdw/ulelcWil5t6QvmRMjMbR2Tut1matTPuOfNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9rdIAee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9rdIAee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0F2C4CEC3;
	Mon, 14 Oct 2024 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920021;
	bh=4rpOCwh+1ej9UT+9r6aeZE9XkZTDixug+zJySU25NLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9rdIAeedTMojj4TuLB2M+4g1kNXEH1je8mmqFaYTL+L6DDmWY0xNuQ0P+DgMZRf+
	 5EJX6guJLKvEzFBzQrOMcrfpNt8yYmcDWQe1gQg6WzxcxPYdA+A71GDJak9vBch4qE
	 aUs6U45sRl2p3HOdh+XK39LHwJ2vYl33ayXKN85c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 776/798] usb: dwc3: core: Stop processing of pending events if controller is halted
Date: Mon, 14 Oct 2024 16:22:10 +0200
Message-ID: <20241014141248.550878518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 0d410e8913f5cffebcca79ffdd596009d4a13a28 upstream.

This commit addresses an issue where events were being processed when
the controller was in a halted state. To fix this issue by stop
processing the events as the event count was considered stale or
invalid when the controller was halted.

Fixes: fc8bb91bc83e ("usb: dwc3: implement runtime PM")
Cc: stable@kernel.org
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240916231813.206-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c   |   22 +++++++++++++++++++---
 drivers/usb/dwc3/core.h   |    4 ----
 drivers/usb/dwc3/gadget.c |   11 -----------
 3 files changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -533,6 +533,7 @@ static int dwc3_alloc_event_buffers(stru
 int dwc3_event_buffers_setup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
+	u32				reg;
 
 	if (!dwc->ev_buf)
 		return 0;
@@ -545,8 +546,10 @@ int dwc3_event_buffers_setup(struct dwc3
 			upper_32_bits(evt->dma));
 	dwc3_writel(dwc->regs, DWC3_GEVNTSIZ(0),
 			DWC3_GEVNTSIZ_SIZE(evt->length));
-	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), 0);
 
+	/* Clear any stale event */
+	reg = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), reg);
 	return 0;
 }
 
@@ -573,7 +576,10 @@ void dwc3_event_buffers_cleanup(struct d
 	dwc3_writel(dwc->regs, DWC3_GEVNTADRHI(0), 0);
 	dwc3_writel(dwc->regs, DWC3_GEVNTSIZ(0), DWC3_GEVNTSIZ_INTMASK
 			| DWC3_GEVNTSIZ_SIZE(0));
-	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), 0);
+
+	/* Clear any stale event */
+	reg = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), reg);
 }
 
 static int dwc3_alloc_scratch_buffers(struct dwc3 *dwc)
@@ -2279,7 +2285,11 @@ static int dwc3_runtime_resume(struct de
 
 	switch (dwc->current_dr_role) {
 	case DWC3_GCTL_PRTCAP_DEVICE:
-		dwc3_gadget_process_pending_events(dwc);
+		if (dwc->pending_events) {
+			pm_runtime_put(dwc->dev);
+			dwc->pending_events = false;
+			enable_irq(dwc->irq_gadget);
+		}
 		break;
 	case DWC3_GCTL_PRTCAP_HOST:
 	default:
@@ -2366,6 +2376,12 @@ static void dwc3_complete(struct device
 static const struct dev_pm_ops dwc3_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(dwc3_suspend, dwc3_resume)
 	.complete = dwc3_complete,
+
+	/*
+	 * Runtime suspend halts the controller on disconnection. It relies on
+	 * platforms with custom connection notification to start the controller
+	 * again.
+	 */
 	SET_RUNTIME_PM_OPS(dwc3_runtime_suspend, dwc3_runtime_resume,
 			dwc3_runtime_idle)
 };
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1633,7 +1633,6 @@ static inline void dwc3_otg_host_init(st
 #if !IS_ENABLED(CONFIG_USB_DWC3_HOST)
 int dwc3_gadget_suspend(struct dwc3 *dwc);
 int dwc3_gadget_resume(struct dwc3 *dwc);
-void dwc3_gadget_process_pending_events(struct dwc3 *dwc);
 #else
 static inline int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
@@ -1645,9 +1644,6 @@ static inline int dwc3_gadget_resume(str
 	return 0;
 }
 
-static inline void dwc3_gadget_process_pending_events(struct dwc3 *dwc)
-{
-}
 #endif /* !IS_ENABLED(CONFIG_USB_DWC3_HOST) */
 
 #if IS_ENABLED(CONFIG_USB_DWC3_ULPI)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4618,14 +4618,3 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 
 	return dwc3_gadget_soft_connect(dwc);
 }
-
-void dwc3_gadget_process_pending_events(struct dwc3 *dwc)
-{
-	if (dwc->pending_events) {
-		dwc3_interrupt(dwc->irq_gadget, dwc->ev_buf);
-		dwc3_thread_interrupt(dwc->irq_gadget, dwc->ev_buf);
-		pm_runtime_put(dwc->dev);
-		dwc->pending_events = false;
-		enable_irq(dwc->irq_gadget);
-	}
-}


