Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FB11DFDAF;
	Wed,  6 Nov 2024 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895777; cv=none; b=J8wayWNYye3PprE9KfQUPNHfJs3ywcDCsJhnwSzV0VLkIbHwUK9A2Ge6wAIjq6pt/qfpxnNrJYGijetS8IpAI0a2B1V3i9Z8qKn8k9USpPzz4pnq3scrmUpz/74X4B/3u9ZZd/ksozq3wQFFz6+gsGpVoQroPuukQ3IniXSRK8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895777; c=relaxed/simple;
	bh=ah3NHF0q/P3SKNT3cq/L8FZtLiu2KmZwIPcI0dTzfy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETtM1JQBJ3J2Q/NNCr7zPd1xvfSme7r/VPqyjOpIePe9kPvj8p/Stv7OsZW/CG3uOp/Mo4llRs/Zho+OZtkfWy1/zw4einNqyOT/cBZtJ2CcwtAJpjGWCpfxUbuXOl4k415bq88RkXBaZXTIFCAJG2NyhUb+FjnqireKdP+kIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRoai68K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRoai68K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D3EC4CED3;
	Wed,  6 Nov 2024 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895777;
	bh=ah3NHF0q/P3SKNT3cq/L8FZtLiu2KmZwIPcI0dTzfy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRoai68KwDOK4+uIfgtmf2Hm6uhOD8TbqqyQy0n4a5nksVOBrOpk6xgZmW0qF+jxq
	 OwI0+KfPXnCRzyRnhnN8sAhEeAOgQ7wRDZDkqJ88bAdxd1hrakGtO0ekzVuShvm6Ca
	 hRhnyAJiMLGoGiHp9FMDMNt2ReAxtthWJ5iivU1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 325/350] usb: dwc3: core: Stop processing of pending events if controller is halted
Date: Wed,  6 Nov 2024 13:04:13 +0100
Message-ID: <20241106120328.764969334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

[ Upstream commit 0d410e8913f5cffebcca79ffdd596009d4a13a28 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 22 +++++++++++++++++++---
 drivers/usb/dwc3/core.h   |  4 ----
 drivers/usb/dwc3/gadget.c | 11 -----------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f50b8bf22356b..c10306234bb11 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -404,6 +404,7 @@ static int dwc3_alloc_event_buffers(struct dwc3 *dwc, unsigned length)
 int dwc3_event_buffers_setup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
+	u32				reg;
 
 	if (!dwc->ev_buf)
 		return 0;
@@ -416,8 +417,10 @@ int dwc3_event_buffers_setup(struct dwc3 *dwc)
 			upper_32_bits(evt->dma));
 	dwc3_writel(dwc->regs, DWC3_GEVNTSIZ(0),
 			DWC3_GEVNTSIZ_SIZE(evt->length));
-	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), 0);
 
+	/* Clear any stale event */
+	reg = dwc3_readl(dwc->regs, DWC3_GEVNTCOUNT(0));
+	dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), reg);
 	return 0;
 }
 
@@ -444,7 +447,10 @@ void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
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
@@ -1792,7 +1798,11 @@ static int dwc3_runtime_resume(struct device *dev)
 
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
@@ -1879,6 +1889,12 @@ static void dwc3_complete(struct device *dev)
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
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 7f8804e9e74c3..1115ed88f3571 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1430,7 +1430,6 @@ static inline void dwc3_otg_host_init(struct dwc3 *dwc)
 #if !IS_ENABLED(CONFIG_USB_DWC3_HOST)
 int dwc3_gadget_suspend(struct dwc3 *dwc);
 int dwc3_gadget_resume(struct dwc3 *dwc);
-void dwc3_gadget_process_pending_events(struct dwc3 *dwc);
 #else
 static inline int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
@@ -1442,9 +1441,6 @@ static inline int dwc3_gadget_resume(struct dwc3 *dwc)
 	return 0;
 }
 
-static inline void dwc3_gadget_process_pending_events(struct dwc3 *dwc)
-{
-}
 #endif /* !IS_ENABLED(CONFIG_USB_DWC3_HOST) */
 
 #if IS_ENABLED(CONFIG_USB_DWC3_ULPI)
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e617a28aca436..c6610c15e03ed 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3474,14 +3474,3 @@ int dwc3_gadget_resume(struct dwc3 *dwc)
 err0:
 	return ret;
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
-- 
2.43.0



