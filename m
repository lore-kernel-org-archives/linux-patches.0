Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB32DE1FA;
	Tue,  8 Jul 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993727; cv=none; b=kPygHMcM9MwjrXHDhTMb128U7WBGTpDrKljKmJwd0qpmLMJ75JNAFd3lVfgNKNH6+mvQemiK9Q2xffv1B6veSIS0L1UTtcRXnBvnQACjXqclSxj1vZo9758si356+NApEqFVNcBuANtgAU3+O48wizH5PlJIK2wbejX64fNVQJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993727; c=relaxed/simple;
	bh=yDPtLPVkG3PC3jWcRWF3KXiAGZCx3lp+qrgu359k9io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq7ivy0SvTP2Ne0tlUPaDrgcp2BRMdAYA8LAyA/dM2ZrYOiKt39ptEJ+AMFsydf0Kzg4teyJfoZyUWLnjG6ea82P1iUbM44OeBXItBlnoSek87XwEXmueKPaPcID+1ZS2CKXo9DWLiLSmW/UfQuTqckbIid+zcV7rZf/cdmdqxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGROQzm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGROQzm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55BBC4CEF5;
	Tue,  8 Jul 2025 16:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993727;
	bh=yDPtLPVkG3PC3jWcRWF3KXiAGZCx3lp+qrgu359k9io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGROQzm/0PVjIeUXsaIZ6PIUg4BjcvMC+15gJwLWi/cUDEQxaHRXBFfD4i9n9d/RL
	 rIS2TCWolZ/Wb1ENd9m9gbPuTXqNLOwqXFxOLoCprDSBTyd31aLRe4Cmp6GJ6kyotY
	 CX7ddYp4ATmNknlQqWPmq1WIkm6+54dJgEY85eIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Roy Luo <royluo@google.com>
Subject: [PATCH 6.15 142/178] Revert "usb: xhci: Implement xhci_handshake_check_state() helper"
Date: Tue,  8 Jul 2025 18:22:59 +0200
Message-ID: <20250708162240.245949743@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Luo <royluo@google.com>

commit 7aed15379db9c6ec67999cdaf5c443b7be06ea73 upstream.

This reverts commit 6ccb83d6c4972ebe6ae49de5eba051de3638362c.

Commit 6ccb83d6c497 ("usb: xhci: Implement xhci_handshake_check_state()
helper") was introduced to workaround watchdog timeout issues on some
platforms, allowing xhci_reset() to bail out early without waiting
for the reset to complete.

Skipping the xhci handshake during a reset is a dangerous move. The
xhci specification explicitly states that certain registers cannot
be accessed during reset in section 5.4.1 USB Command Register (USBCMD),
Host Controller Reset (HCRST) field:
"This bit is cleared to '0' by the Host Controller when the reset
process is complete. Software cannot terminate the reset process
early by writinga '0' to this bit and shall not write any xHC
Operational or Runtime registers until while HCRST is '1'."

This behavior causes a regression on SNPS DWC3 USB controller with
dual-role capability. When the DWC3 controller exits host mode and
removes xhci while a reset is still in progress, and then tries to
configure its hardware for device mode, the ongoing reset leads to
register access issues; specifically, all register reads returns 0.
These issues extend beyond the xhci register space (which is expected
during a reset) and affect the entire DWC3 IP block, causing the DWC3
device mode to malfunction.

Cc: stable <stable@kernel.org>
Fixes: 6ccb83d6c497 ("usb: xhci: Implement xhci_handshake_check_state() helper")
Signed-off-by: Roy Luo <royluo@google.com>
Link: https://lore.kernel.org/r/20250522190912.457583-3-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    5 ++---
 drivers/usb/host/xhci.c      |   26 +-------------------------
 drivers/usb/host/xhci.h      |    2 --
 3 files changed, 3 insertions(+), 30 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -518,9 +518,8 @@ static int xhci_abort_cmd_ring(struct xh
 	 * In the future we should distinguish between -ENODEV and -ETIMEDOUT
 	 * and try to recover a -ETIMEDOUT with a host controller reset.
 	 */
-	ret = xhci_handshake_check_state(xhci, &xhci->op_regs->cmd_ring,
-			CMD_RING_RUNNING, 0, 5 * 1000 * 1000,
-			XHCI_STATE_REMOVING);
+	ret = xhci_handshake(&xhci->op_regs->cmd_ring,
+			CMD_RING_RUNNING, 0, 5 * 1000 * 1000);
 	if (ret < 0) {
 		xhci_err(xhci, "Abort failed to stop command ring: %d\n", ret);
 		xhci_halt(xhci);
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -84,29 +84,6 @@ int xhci_handshake(void __iomem *ptr, u3
 }
 
 /*
- * xhci_handshake_check_state - same as xhci_handshake but takes an additional
- * exit_state parameter, and bails out with an error immediately when xhc_state
- * has exit_state flag set.
- */
-int xhci_handshake_check_state(struct xhci_hcd *xhci, void __iomem *ptr,
-		u32 mask, u32 done, int usec, unsigned int exit_state)
-{
-	u32	result;
-	int	ret;
-
-	ret = readl_poll_timeout_atomic(ptr, result,
-				(result & mask) == done ||
-				result == U32_MAX ||
-				xhci->xhc_state & exit_state,
-				1, usec);
-
-	if (result == U32_MAX || xhci->xhc_state & exit_state)
-		return -ENODEV;
-
-	return ret;
-}
-
-/*
  * Disable interrupts and begin the xHCI halting process.
  */
 void xhci_quiesce(struct xhci_hcd *xhci)
@@ -226,8 +203,7 @@ int xhci_reset(struct xhci_hcd *xhci, u6
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake_check_state(xhci, &xhci->op_regs->command,
-				CMD_RESET, 0, timeout_us, XHCI_STATE_REMOVING);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1855,8 +1855,6 @@ void xhci_remove_secondary_interrupter(s
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
 int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us);
-int xhci_handshake_check_state(struct xhci_hcd *xhci, void __iomem *ptr,
-		u32 mask, u32 done, int usec, unsigned int exit_state);
 void xhci_quiesce(struct xhci_hcd *xhci);
 int xhci_halt(struct xhci_hcd *xhci);
 int xhci_start(struct xhci_hcd *xhci);


