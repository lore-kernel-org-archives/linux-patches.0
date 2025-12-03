Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862CB31A7F1;
	Wed,  3 Dec 2025 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777223; cv=none; b=j+2PqAis4MQuZ/fNmjQkDDnK2xN9dNWeI2u0+0KN1D4nOgC2SlGnXs2PwXiPpQ1YbUbOkYYiHjOyvBWL8PUcvCcZzneHL/R0RiyXXFdA6u/DIHElioRd0JEeTwmIjkcQn3y5RrkuuEuEqvF5n2onPWGr72llIY8wpltHsg7AWfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777223; c=relaxed/simple;
	bh=0tEoipaoI7q/1ylKZCH2S5Ra3/kuW4m4lqEWuKlT3go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTkkMp3j1PR1LGOq0of9J89zaDAOUBoTrJucVdc3GowXflBgvBVRGVuS1TfW3cpvouiCd5/e7a0Zuq5v5HE2R0flelXO59MBjp1UEhpiAYJ0Z6/Th+jh0pPQg1r6Z+bO3Bf7WK3s3lmBOgqOLxKwWTeucA94hjfITN/4wdWuiYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMbtMoJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMbtMoJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3594C116C6;
	Wed,  3 Dec 2025 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777223;
	bh=0tEoipaoI7q/1ylKZCH2S5Ra3/kuW4m4lqEWuKlT3go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMbtMoJSJTHJM1m/SLNO+6DP6gCFnmVc6UBeKd3rEFM+qFfXuKbq82Yl0u0UBixhY
	 z+3g4EwD0sHWTwZtZGx+55lPZKQYDY6Nc9R9ihBohiPQJODAMT2vFOoF1Cb4pRh7CE
	 6MnrxBGCE+4oTSIZwxs6T9//XF7YJ6+/pmbu002E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.17 121/146] xhci: fix stale flag preventig URBs after link state error is cleared
Date: Wed,  3 Dec 2025 16:28:19 +0100
Message-ID: <20251203152350.891194194@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1984,6 +1984,7 @@ static void xhci_cavium_reset_phy_quirk(
 
 static void handle_port_status(struct xhci_hcd *xhci, union xhci_trb *event)
 {
+	struct xhci_virt_device *vdev = NULL;
 	struct usb_hcd *hcd;
 	u32 port_id;
 	u32 portsc, cmd_reg;
@@ -2015,6 +2016,9 @@ static void handle_port_status(struct xh
 		goto cleanup;
 	}
 
+	if (port->slot_id)
+		vdev = xhci->devs[port->slot_id];
+
 	/* We might get interrupts after shared_hcd is removed */
 	if (port->rhub == &xhci->usb3_rhub && xhci->shared_hcd == NULL) {
 		xhci_dbg(xhci, "ignore port event for removed USB3 hcd\n");
@@ -2037,10 +2041,11 @@ static void handle_port_status(struct xh
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
@@ -2098,7 +2103,7 @@ static void handle_port_status(struct xh
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
@@ -3993,6 +3993,7 @@ static int xhci_discover_or_reset_device
 				xhci_get_slot_state(xhci, virt_dev->out_ctx));
 		xhci_dbg(xhci, "Not freeing device rings.\n");
 		/* Don't treat this as an error.  May change my mind later. */
+		virt_dev->flags = 0;
 		ret = 0;
 		goto command_cleanup;
 	case COMP_SUCCESS:


