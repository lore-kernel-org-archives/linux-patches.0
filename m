Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7437211278;
	Wed,  7 May 2025 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645236; cv=none; b=js519YHSHzzwafSQFbRNdeRIdROuDEzaD40a0YMgyuIqUjG51Q7BrOVcyrpSvvZZ3P3hO3O9sfDPFnCtKnecl4U1rbd1oH9EG9MRKS/g6jZ1oo+wuh7tQgKLQs3awl6jOgUfFc5qX9dfCRdX28iGxw4BWnyMStheYnQ6a528BSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645236; c=relaxed/simple;
	bh=4/dN1AAtXinKJ4FPmFK1zGql8HLSKosoEhc38nMR8YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCeuNVa1sM2DvIKDbN/BK5hKYTUyS56zmSmBEoV3Lbd/wJRqr1+XXf5pK9DCIrrdv/d4PpVSbmuqk8RM0zi76j0QNUrvQtWo9Oj4e5ahbq1zldDXyuCCrtgziPPWZ6blYpcSbXmPMZd1lwgmf6bz6nZgtbnUIYnLdSLcE7zZN9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/uZ7kIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/uZ7kIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3563DC4CEE2;
	Wed,  7 May 2025 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645236;
	bh=4/dN1AAtXinKJ4FPmFK1zGql8HLSKosoEhc38nMR8YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/uZ7kIs+iTSiZ5IzTw4IxCe8ZfgyZ8ahFBW4De0oWcp1wlvORXqbN8x+o1nMNdTY
	 7KdPHKeDDaxGvYXtRqoIhSNejQWeHAMFLQUuHUrCX6Q2a0Otj9glHCYcMYD39+A1YG
	 nwW6rzVW6rBsPHRHPFlx14c605wFPnFUAnQn8jqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/129] xhci: Add helper to set an interrupters interrupt moderation interval
Date: Wed,  7 May 2025 20:40:51 +0200
Message-ID: <20250507183818.253599621@linuxfoundation.org>
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

[ Upstream commit ace21625878f78708b75b7a872ec7a0e2ed15ca4 ]

Add a helper to set the interrupt moderation interval for an interrupter.
Each interrupter can have its own moderation value.

Hardware has a 16bit register for the moderation value, each step is 250ns.

Helper function imod_interval argument is in nanoseconds.

Values from 0 to 16383750 (250 x 0xffff) are accepted.
0 means no interrupt throttling.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240217001017.29969-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5c3250989047e..d6a0c79e5fada 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -323,6 +323,23 @@ static int xhci_disable_interrupter(struct xhci_interrupter *ir)
 	return 0;
 }
 
+/* interrupt moderation interval imod_interval in nanoseconds */
+static int xhci_set_interrupter_moderation(struct xhci_interrupter *ir,
+					   u32 imod_interval)
+{
+	u32 imod;
+
+	if (!ir || !ir->ir_set || imod_interval > U16_MAX * 250)
+		return -EINVAL;
+
+	imod = readl(&ir->ir_set->irq_control);
+	imod &= ~ER_IRQ_INTERVAL_MASK;
+	imod |= (imod_interval / 250) & ER_IRQ_INTERVAL_MASK;
+	writel(imod, &ir->ir_set->irq_control);
+
+	return 0;
+}
+
 static void compliance_mode_recovery(struct timer_list *t)
 {
 	struct xhci_hcd *xhci;
@@ -505,7 +522,6 @@ static int xhci_run_finished(struct xhci_hcd *xhci)
  */
 int xhci_run(struct usb_hcd *hcd)
 {
-	u32 temp;
 	u64 temp_64;
 	int ret;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -525,12 +541,7 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"ERST deq = 64'h%0lx", (long unsigned int) temp_64);
 
-	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
-			"// Set the interrupt modulation register");
-	temp = readl(&ir->ir_set->irq_control);
-	temp &= ~ER_IRQ_INTERVAL_MASK;
-	temp |= (xhci->imod_interval / 250) & ER_IRQ_INTERVAL_MASK;
-	writel(temp, &ir->ir_set->irq_control);
+	xhci_set_interrupter_moderation(ir, xhci->imod_interval);
 
 	if (xhci->quirks & XHCI_NEC_HOST) {
 		struct xhci_command *command;
-- 
2.39.5



