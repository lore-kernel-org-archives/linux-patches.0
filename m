Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECB71B4F2D;
	Mon, 14 Oct 2024 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917206; cv=none; b=QEtEFXDmVeP39vRVlVTO59xqSvE0683S5nTbv87gPXfWiqKCxsxi82mIedMXk/h+2n5DDtz0mUd9Olo7/bpI0dwEqH9eErJpe+miFdxHOLm2sj94YQ+ZgotqfxVT2f5zPS8VY3/zKHpVjcAObuuG7cTUDNqxSMewQnRdXEsH3dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917206; c=relaxed/simple;
	bh=1ZjcxIm/wyFtuUnpi789j8+8PcqfCrS29NpejmZYuos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hypyloWiq/jGrsJQ1YGNMDhcx1JEWHXdRWXawbCQHe1Kr4OIS5KKorzrARjnGV5bJzUh6B8fONknFA2ZszvAXantGYyI1gmoG/pKkftt1UDViKcOoCzcgxYUJpN3hH+Qv5fxRFGv4kAwGZvo7RzadlizBgicwFzrpPjWtPQlw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7ZqQaM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7ZqQaM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301F2C4CEC3;
	Mon, 14 Oct 2024 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917205;
	bh=1ZjcxIm/wyFtuUnpi789j8+8PcqfCrS29NpejmZYuos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7ZqQaM4XBPXknXHRk3Hquk8kG2XjIPxY0ZueGMLZ5lY+pTEkF3If0FEM4uVoHkd9
	 wG/E/e7p1duCs5G56MXLIaONO/VM7NQwEfdEAjJY+8uFbYwa2TlE/ty0/LgcA3VN1k
	 L4Dt+JSGT1CG86uhyawIWUZs1sfv58m+pOvujToE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 183/213] usb: dwc3: core: Stop processing of pending events if controller is halted
Date: Mon, 14 Oct 2024 16:21:29 +0200
Message-ID: <20241014141050.106883509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
 static void dwc3_core_num_eps(struct dwc3 *dwc)
@@ -2254,7 +2260,11 @@ static int dwc3_runtime_resume(struct de
 
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
@@ -2341,6 +2351,12 @@ static void dwc3_complete(struct device
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
@@ -1643,7 +1643,6 @@ static inline void dwc3_otg_host_init(st
 #if !IS_ENABLED(CONFIG_USB_DWC3_HOST)
 int dwc3_gadget_suspend(struct dwc3 *dwc);
 int dwc3_gadget_resume(struct dwc3 *dwc);
-void dwc3_gadget_process_pending_events(struct dwc3 *dwc);
 #else
 static inline int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
@@ -1655,9 +1654,6 @@ static inline int dwc3_gadget_resume(str
 	return 0;
 }
 
-static inline void dwc3_gadget_process_pending_events(struct dwc3 *dwc)
-{
-}
 #endif /* !IS_ENABLED(CONFIG_USB_DWC3_HOST) */
 
 #if IS_ENABLED(CONFIG_USB_DWC3_ULPI)
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4741,14 +4741,3 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 
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


