Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4D354AC6;
	Wed,  3 Dec 2025 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780953; cv=none; b=PlR2nrNOT9o6Eshz89ekj4ta8zj05/XBMVvCuhpJw4lbN1srNz/thvrCiFr0j/uSDhCOTJRAUuwH/4ukNYYCf1+QOPm8cFptjdkrUDjMCc0LC9c/1QNkdu1Fb6LqI8S8ASkrHIHEhVPEJCDtUUb5K0p8tkgg5RRFAQaNx2urILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780953; c=relaxed/simple;
	bh=Jo/FjSZd+PE0S6ph+TlOAFLB6F/1iNLEMkBh6Db5Zt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEKqg4GBozFLoau7wFvkHT5fKcSDkMHS7W/wy5nHf+BEJvHoMtqCUbi15s65DuwpCj16kuuSMc9+vfq4qq3EQWjYLtwcKhOCqqFIPaDXAf7xLUItQsGQ9nJ2sXPwD4rKcudl+8O1SvUnfli2Nvt8/RnDNCj2Htk7OuH9qisSm+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xw9H+f1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xw9H+f1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F7FC4CEF5;
	Wed,  3 Dec 2025 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780951;
	bh=Jo/FjSZd+PE0S6ph+TlOAFLB6F/1iNLEMkBh6Db5Zt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw9H+f1lXQBJ55+PZb6ngUgHEwvbSiKVyU0hm8fUQfF11qExlmsEAfHGWzOe+mkxK
	 uL419ZhJhvs4622koI4VegQixy0FeVtz28TIYuTsldvdH6cy0kO3+DQUp1xdNFw0tG
	 vXgRjFAVr3VSSTcUA689VCinCp4owY+FVZMb6spA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 098/132] xhci: fix stale flag preventig URBs after link state error is cleared
Date: Wed,  3 Dec 2025 16:29:37 +0100
Message-ID: <20251203152346.917986901@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit b69dfcab6894b1fed5362a364411502a7469fce3 upstream.

A usb device caught behind a link in ss.Inactive error state needs to
be reset to recover. A VDEV_PORT_ERROR flag is used to track this state,
preventing new transfers from being queued until error is cleared.

This flag may be left uncleared if link goes to error state between two
resets, and print the following message:

"xhci_hcd 0000:00:14.0: Can't queue urb, port error, link inactive"

Fix setting and clearing the flag.

The flag is cleared after hub driver has successfully reset the device
when hcd->reset_device is called. xhci-hcd issues an internal "reset
device" command in this callback, and clear all flags once the command
completes successfully.

This command may complete with a context state error if slot was recently
reset and is already in the defauilt state. This is treated as a success
but flag was left uncleared.

The link state field is also unreliable if port is currently in reset,
so don't set the flag in active reset cases.
Also clear the flag immediately when link is no longer in ss.Inactive
state and port event handler detects a completed reset.

This issue was discovered while debugging kernel bugzilla issue 220491.
It is likely one small part of the problem, causing some of the failures,
but root cause remains unknown

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220491
Fixes: b8c3b718087b ("usb: xhci: Don't try to recover an endpoint if port is in error state.")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251107162819.1362579-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   15 ++++++++++-----
 drivers/usb/host/xhci.c      |    1 +
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1950,6 +1950,7 @@ static void xhci_cavium_reset_phy_quirk(
 
 static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 {
+	struct xhci_virt_device *vdev = NULL;
 	struct usb_hcd *hcd;
 	u32 port_id;
 	u32 portsc, cmd_reg;
@@ -1981,6 +1982,9 @@ static void handle_port_status(struct xh
 		goto cleanup;
 	}
 
+	if (port->slot_id)
+		vdev = xhci->devs[port->slot_id];
+
 	/* We might get interrupts after shared_hcd is removed */
 	if (port->rhub == &xhci->usb3_rhub && xhci->shared_hcd == NULL) {
 		xhci_dbg(xhci, "ignore port event for removed USB3 hcd\n");
@@ -2003,10 +2007,11 @@ static void handle_port_status(struct xh
 		usb_hcd_resume_root_hub(hcd);
 	}
 
-	if (hcd->speed >= HCD_USB3 &&
-	    (portsc & PORT_PLS_MASK) == XDEV_INACTIVE) {
-		if (port->slot_id && xhci->devs[port->slot_id])
-			xhci->devs[port->slot_id]->flags |= VDEV_PORT_ERROR;
+	if (vdev && (portsc & PORT_PLS_MASK) == XDEV_INACTIVE) {
+		if (!(portsc & PORT_RESET))
+			vdev->flags |= VDEV_PORT_ERROR;
+	} else if (vdev && portsc & PORT_RC) {
+		vdev->flags &= ~VDEV_PORT_ERROR;
 	}
 
 	if ((portsc & PORT_PLC) && (portsc & PORT_PLS_MASK) == XDEV_RESUME) {
@@ -2064,7 +2069,7 @@ static void handle_port_status(struct xh
 		 * so the roothub behavior is consistent with external
 		 * USB 3.0 hub behavior.
 		 */
-		if (port->slot_id && xhci->devs[port->slot_id])
+		if (vdev)
 			xhci_ring_device(xhci, port->slot_id);
 		if (bus_state->port_remote_wakeup & (1 << hcd_portnum)) {
 			xhci_test_and_clear_bit(xhci, port, PORT_PLC);
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3818,6 +3818,7 @@ static int xhci_discover_or_reset_device
 				xhci_get_slot_state(xhci, virt_dev->out_ctx));
 		xhci_dbg(xhci, "Not freeing device rings.\n");
 		/* Don't treat this as an error.  May change my mind later. */
+		virt_dev->flags = 0;
 		ret = 0;
 		goto command_cleanup;
 	case COMP_SUCCESS:


