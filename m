Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C911233713;
	Tue, 29 Apr 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947954; cv=none; b=RagIbs3I7tJdzLvMPHTRlvhvVQKIh4eXKry/ouARl7RXMTCe50RnaaijMCUcFzdy4ZHhr8MR3dC4dhKh/HNwADSwJr0DU9iEmdb5XoIoIDLZ4ynQoj9mByUX/V54+utlA4Ug1xxxJL7fAOS9GvyuVvekQohglbENQE2g+z2ydik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947954; c=relaxed/simple;
	bh=P8/HawAHZumGTfHtNIvLiryIQXdgtAMDvPdF54cQN0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxRrobd8qAiZppz4VBHajpZXj9aVsS1akeD4WKp7Cau1TRV4tBcYwV4K8bvoUtvsZC4pb0dutVNDthIaizbHEEQI+IsUmENxjOmuoGRtz44bXVI/yFzJqnUgHpQ0M1jobwy8gmo0uEfGSv28x4ZvAwjp953nbn1DexPHW36r72c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjGpzcq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjGpzcq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A97FC4CEE3;
	Tue, 29 Apr 2025 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947954;
	bh=P8/HawAHZumGTfHtNIvLiryIQXdgtAMDvPdF54cQN0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjGpzcq3YMNO2LkoA88dSqTwTYp1cftJP0AiTDooa5XhUrnuNGDgm8dcs0wZHYnJb
	 X9V+ZKb8je2dDsACKdbigsc36LbMXiLsjw32wNTMFQ/onZjUs3Sh/un7tLeuWdu/Yg
	 4pRHWhxRjz4Ml9oS1l9fBAaf4vbAMwEghAvByjt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 136/280] xhci: Limit time spent with xHC interrupts disabled during bus resume
Date: Tue, 29 Apr 2025 18:41:17 +0200
Message-ID: <20250429161120.693407353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit bea5892d0ed274e03655223d1977cf59f9aff2f2 upstream.

Current xhci bus resume implementation prevents xHC host from generating
interrupts during high-speed USB 2 and super-speed USB 3 bus resume.

Only reason to disable interrupts during bus resume would be to prevent
the interrupt handler from interfering with the resume process of USB 2
ports.

Host initiated resume of USB 2 ports is done in two stages.

The xhci driver first transitions the port from 'U3' to 'Resume' state,
then wait in Resume for 20ms, and finally moves port to U0 state.
xhci driver can't prevent interrupts by keeping the xhci spinlock
due to this 20ms sleep.

Limit interrupt disabling to the USB 2 port resume case only.
resuming USB 2 ports in bus resume is only done in special cases where
USB 2 ports had to be forced to suspend during bus suspend.

The current way of preventing interrupts by clearing the 'Interrupt
Enable' (INTE) bit in USBCMD register won't prevent the Interrupter
registers 'Interrupt Pending' (IP), 'Event Handler Busy' (EHB) and
USBSTS register Event Interrupt (EINT) bits from being set.

New interrupts can't be issued before those bits are properly clered.

Disable interrupts by clearing the interrupter register 'Interrupt
Enable' (IE) bit instead. This way IP, EHB and INTE won't be set
before IE is enabled again and a new interrupt is triggered.

Reported-by: Devyn Liu <liudingyuan@huawei.com>
Closes: https://lore.kernel.org/linux-usb/b1a9e2d51b4d4ff7a304f77c5be8164e@huawei.com/
Cc: stable@vger.kernel.org
Tested-by: Devyn Liu <liudingyuan@huawei.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250410151828.2868740-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |   30 ++++++++++++++++--------------
 drivers/usb/host/xhci.c     |    4 ++--
 drivers/usb/host/xhci.h     |    2 ++
 3 files changed, 20 insertions(+), 16 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1878,9 +1878,10 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 	int max_ports, port_index;
 	int sret;
 	u32 next_state;
-	u32 temp, portsc;
+	u32 portsc;
 	struct xhci_hub *rhub;
 	struct xhci_port **ports;
+	bool disabled_irq = false;
 
 	rhub = xhci_get_rhub(hcd);
 	ports = rhub->ports;
@@ -1896,17 +1897,20 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 		return -ESHUTDOWN;
 	}
 
-	/* delay the irqs */
-	temp = readl(&xhci->op_regs->command);
-	temp &= ~CMD_EIE;
-	writel(temp, &xhci->op_regs->command);
-
 	/* bus specific resume for ports we suspended at bus_suspend */
-	if (hcd->speed >= HCD_USB3)
+	if (hcd->speed >= HCD_USB3) {
 		next_state = XDEV_U0;
-	else
+	} else {
 		next_state = XDEV_RESUME;
-
+		if (bus_state->bus_suspended) {
+			/*
+			 * prevent port event interrupts from interfering
+			 * with usb2 port resume process
+			 */
+			xhci_disable_interrupter(xhci->interrupters[0]);
+			disabled_irq = true;
+		}
+	}
 	port_index = max_ports;
 	while (port_index--) {
 		portsc = readl(ports[port_index]->addr);
@@ -1974,11 +1978,9 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 	(void) readl(&xhci->op_regs->command);
 
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(5);
-	/* re-enable irqs */
-	temp = readl(&xhci->op_regs->command);
-	temp |= CMD_EIE;
-	writel(temp, &xhci->op_regs->command);
-	temp = readl(&xhci->op_regs->command);
+	/* re-enable interrupter */
+	if (disabled_irq)
+		xhci_enable_interrupter(xhci->interrupters[0]);
 
 	spin_unlock_irqrestore(&xhci->lock, flags);
 	return 0;
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -321,7 +321,7 @@ static void xhci_zero_64b_regs(struct xh
 		xhci_info(xhci, "Fault detected\n");
 }
 
-static int xhci_enable_interrupter(struct xhci_interrupter *ir)
+int xhci_enable_interrupter(struct xhci_interrupter *ir)
 {
 	u32 iman;
 
@@ -334,7 +334,7 @@ static int xhci_enable_interrupter(struc
 	return 0;
 }
 
-static int xhci_disable_interrupter(struct xhci_interrupter *ir)
+int xhci_disable_interrupter(struct xhci_interrupter *ir)
 {
 	u32 iman;
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1881,6 +1881,8 @@ int xhci_alloc_tt_info(struct xhci_hcd *
 		struct usb_tt *tt, gfp_t mem_flags);
 int xhci_set_interrupter_moderation(struct xhci_interrupter *ir,
 				    u32 imod_interval);
+int xhci_enable_interrupter(struct xhci_interrupter *ir);
+int xhci_disable_interrupter(struct xhci_interrupter *ir);
 
 /* xHCI ring, segment, TRB, and TD functions */
 dma_addr_t xhci_trb_virt_to_dma(struct xhci_segment *seg, union xhci_trb *trb);


