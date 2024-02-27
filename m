Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB171420A6;
	Tue, 27 Feb 2024 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042992; cv=none; b=aX2HlK0ldx3hfV0gIlLQAZuNu89vNmNdc0ToAtNfoP1wCqwoUuCVAQMVwimGM0Np+nI+XHVTG8Qjvvkhxa8d1A4QGYylVsZUSvXoYubMBxth4XPx8Uqdt0o+4QXohUUDOcq/uHhXF+s6Avs0TmS37VvSQEUkpq1CgjwWKh4MgrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042992; c=relaxed/simple;
	bh=QTm/9xmA4uqh4SNk7mqRQfuP45y+494+CbxvOJoaBYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHw6yL5jI57t5Z2v0yDragPSjfpfFH3Q41Kr5mpL6GfJqpTnzf6S7muZ3v4Tgg14UdwXejIXR1ljkRU44+8VV5Gi9tIaSlNUMkvrcfnwYWkavNKA11RrX4Mea0//tr5YBu6EA0I3UbjGZi6cI/qBgw3sGR3znt50Px3bpt7/TkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1E09J2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1E09J2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDDDC43399;
	Tue, 27 Feb 2024 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042992;
	bh=QTm/9xmA4uqh4SNk7mqRQfuP45y+494+CbxvOJoaBYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1E09J2uHou0IGNI0eqcEOs9th6b73fEFlGCD04P+u1hI3UatSrL40tZTmOVWDjC4
	 Xv53kEkytWS8X3Tz1OZloVbVExVGLb8Gh6SdHFwdbJb1G9eLBZzT8wljXnwnuR8IhP
	 njsvgk5tBrlrekLTC9MY8aaoLn2aK8Dp40558Nqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/245] xhci: move port specific items such as state completions to port structure
Date: Tue, 27 Feb 2024 14:26:23 +0100
Message-ID: <20240227131621.533079778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 2996e9fc00c378987c18ecbafe5624581b18c0d6 ]

Now that we have a port structure for each port it makes sense to
move per port variables, timestamps and completions there.
Get rid of storing bitfileds and arrays of port specific items per bus.

Move
unsigned long           resume_done;
insigned long		rexit_ports
struct completion       rexit_done;
struct completion       u3exit_done;

Rename rexit_ports to rexit_active, and remove a redundant hcd
speed check while checking if rexit_active is set.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d7cdfc319b2b ("xhci: track port suspend state correctly in unsuccessful resume cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c  | 31 +++++++++++++++----------------
 drivers/usb/host/xhci-mem.c  | 10 +++-------
 drivers/usb/host/xhci-ring.c | 13 ++++++-------
 drivers/usb/host/xhci.h      |  9 ++++-----
 4 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 3526665575af2..7f0c9176b4951 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -924,7 +924,7 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 		return -EINVAL;
 	}
 	/* did port event handler already start resume timing? */
-	if (!bus_state->resume_done[wIndex]) {
+	if (!port->resume_done) {
 		/* If not, maybe we are in a host initated resume? */
 		if (test_bit(wIndex, &bus_state->resuming_ports)) {
 			/* Host initated resume doesn't time the resume
@@ -941,28 +941,27 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 				msecs_to_jiffies(USB_RESUME_TIMEOUT);
 
 			set_bit(wIndex, &bus_state->resuming_ports);
-			bus_state->resume_done[wIndex] = timeout;
+			port->resume_done = timeout;
 			mod_timer(&hcd->rh_timer, timeout);
 			usb_hcd_start_port_resume(&hcd->self, wIndex);
 		}
 	/* Has resume been signalled for USB_RESUME_TIME yet? */
-	} else if (time_after_eq(jiffies, bus_state->resume_done[wIndex])) {
+	} else if (time_after_eq(jiffies, port->resume_done)) {
 		int time_left;
 
 		xhci_dbg(xhci, "resume USB2 port %d-%d\n",
 			 hcd->self.busnum, wIndex + 1);
 
-		bus_state->resume_done[wIndex] = 0;
+		port->resume_done = 0;
 		clear_bit(wIndex, &bus_state->resuming_ports);
-
-		set_bit(wIndex, &bus_state->rexit_ports);
+		port->rexit_active = true;
 
 		xhci_test_and_clear_bit(xhci, port, PORT_PLC);
 		xhci_set_link_state(xhci, port, XDEV_U0);
 
 		spin_unlock_irqrestore(&xhci->lock, *flags);
 		time_left = wait_for_completion_timeout(
-			&bus_state->rexit_done[wIndex],
+			&port->rexit_done,
 			msecs_to_jiffies(XHCI_MAX_REXIT_TIMEOUT_MS));
 		spin_lock_irqsave(&xhci->lock, *flags);
 
@@ -981,7 +980,7 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 			xhci_warn(xhci, "Port resume timed out, port %d-%d: 0x%x\n",
 				  hcd->self.busnum, wIndex + 1, port_status);
 			*status |= USB_PORT_STAT_SUSPEND;
-			clear_bit(wIndex, &bus_state->rexit_ports);
+			port->rexit_active = false;
 		}
 
 		usb_hcd_end_port_resume(&hcd->self, wIndex);
@@ -1088,10 +1087,10 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 		if (link_state == XDEV_U2)
 			*status |= USB_PORT_STAT_L1;
 		if (link_state == XDEV_U0) {
-			if (bus_state->resume_done[portnum])
+			if (port->resume_done)
 				usb_hcd_end_port_resume(&port->rhub->hcd->self,
 							portnum);
-			bus_state->resume_done[portnum] = 0;
+			port->resume_done = 0;
 			clear_bit(portnum, &bus_state->resuming_ports);
 			if (bus_state->suspended_ports & (1 << portnum)) {
 				bus_state->suspended_ports &= ~(1 << portnum);
@@ -1163,11 +1162,11 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 	 * Clear stale usb2 resume signalling variables in case port changed
 	 * state during resume signalling. For example on error
 	 */
-	if ((bus_state->resume_done[wIndex] ||
+	if ((port->resume_done ||
 	     test_bit(wIndex, &bus_state->resuming_ports)) &&
 	    (raw_port_status & PORT_PLS_MASK) != XDEV_U3 &&
 	    (raw_port_status & PORT_PLS_MASK) != XDEV_RESUME) {
-		bus_state->resume_done[wIndex] = 0;
+		port->resume_done = 0;
 		clear_bit(wIndex, &bus_state->resuming_ports);
 		usb_hcd_end_port_resume(&hcd->self, wIndex);
 	}
@@ -1426,7 +1425,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				    pls == XDEV_RESUME ||
 				    pls == XDEV_RECOVERY) {
 					wait_u0 = true;
-					reinit_completion(&bus_state->u3exit_done[wIndex]);
+					reinit_completion(&port->u3exit_done);
 				}
 				if (pls <= XDEV_U3) /* U1, U2, U3 */
 					xhci_set_link_state(xhci, port, USB_SS_PORT_LS_U0);
@@ -1436,7 +1435,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					break;
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
-				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
+				if (!wait_for_completion_timeout(&port->u3exit_done,
 								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
 						 hcd->self.busnum, portnum1);
@@ -1675,8 +1674,8 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 		if ((temp & mask) != 0 ||
 			(bus_state->port_c_suspend & 1 << i) ||
-			(bus_state->resume_done[i] && time_after_eq(
-			    jiffies, bus_state->resume_done[i]))) {
+			(ports[i]->resume_done && time_after_eq(
+			    jiffies, ports[i]->resume_done))) {
 			buf[(i + 1) / 8] |= 1 << (i + 1) % 8;
 			status = 1;
 		}
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 6444aef33cf08..f9e3aed40984b 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2318,6 +2318,9 @@ static int xhci_setup_port_arrays(struct xhci_hcd *xhci, gfp_t flags)
 		xhci->hw_ports[i].addr = &xhci->op_regs->port_status_base +
 			NUM_PORT_REGS * i;
 		xhci->hw_ports[i].hw_portnum = i;
+
+		init_completion(&xhci->hw_ports[i].rexit_done);
+		init_completion(&xhci->hw_ports[i].u3exit_done);
 	}
 
 	xhci->rh_bw = kcalloc_node(num_ports, sizeof(*xhci->rh_bw), flags,
@@ -2587,13 +2590,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	 */
 	for (i = 0; i < MAX_HC_SLOTS; i++)
 		xhci->devs[i] = NULL;
-	for (i = 0; i < USB_MAXCHILDREN; i++) {
-		xhci->usb2_rhub.bus_state.resume_done[i] = 0;
-		xhci->usb3_rhub.bus_state.resume_done[i] = 0;
-		/* Only the USB 2.0 completions will ever be used. */
-		init_completion(&xhci->usb2_rhub.bus_state.rexit_done[i]);
-		init_completion(&xhci->usb3_rhub.bus_state.u3exit_done[i]);
-	}
 
 	if (scratchpad_alloc(xhci, flags))
 		goto fail;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 945ed5f3e8588..8038dced215c7 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1987,7 +1987,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			goto cleanup;
 		} else if (!test_bit(hcd_portnum, &bus_state->resuming_ports)) {
 			xhci_dbg(xhci, "resume HS port %d\n", port_id);
-			bus_state->resume_done[hcd_portnum] = jiffies +
+			port->resume_done = jiffies +
 				msecs_to_jiffies(USB_RESUME_TIMEOUT);
 			set_bit(hcd_portnum, &bus_state->resuming_ports);
 			/* Do the rest in GetPortStatus after resume time delay.
@@ -1996,7 +1996,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			 */
 			set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 			mod_timer(&hcd->rh_timer,
-				  bus_state->resume_done[hcd_portnum]);
+				  port->resume_done);
 			usb_hcd_start_port_resume(&hcd->self, hcd_portnum);
 			bogus_port_status = true;
 		}
@@ -2008,7 +2008,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	     (portsc & PORT_PLS_MASK) == XDEV_U1 ||
 	     (portsc & PORT_PLS_MASK) == XDEV_U2)) {
 		xhci_dbg(xhci, "resume SS port %d finished\n", port_id);
-		complete(&bus_state->u3exit_done[hcd_portnum]);
+		complete(&port->u3exit_done);
 		/* We've just brought the device into U0/1/2 through either the
 		 * Resume state after a device remote wakeup, or through the
 		 * U3Exit state after a host-initiated resume.  If it's a device
@@ -2033,10 +2033,9 @@ static void handle_port_status(struct xhci_hcd *xhci,
 	 * RExit to a disconnect state).  If so, let the the driver know it's
 	 * out of the RExit state.
 	 */
-	if (!DEV_SUPERSPEED_ANY(portsc) && hcd->speed < HCD_USB3 &&
-			test_and_clear_bit(hcd_portnum,
-				&bus_state->rexit_ports)) {
-		complete(&bus_state->rexit_done[hcd_portnum]);
+	if (hcd->speed < HCD_USB3 && port->rexit_active) {
+		complete(&port->rexit_done);
+		port->rexit_active = false;
 		bogus_port_status = true;
 		goto cleanup;
 	}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 64278cd77f988..22ffbeaa51eb6 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1708,13 +1708,8 @@ struct xhci_bus_state {
 	u32			port_c_suspend;
 	u32			suspended_ports;
 	u32			port_remote_wakeup;
-	unsigned long		resume_done[USB_MAXCHILDREN];
 	/* which ports have started to resume */
 	unsigned long		resuming_ports;
-	/* Which ports are waiting on RExit to U0 transition. */
-	unsigned long		rexit_ports;
-	struct completion	rexit_done[USB_MAXCHILDREN];
-	struct completion	u3exit_done[USB_MAXCHILDREN];
 };
 
 
@@ -1738,6 +1733,10 @@ struct xhci_port {
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
 	unsigned int		lpm_incapable:1;
+	unsigned long		resume_done;
+	bool			rexit_active;
+	struct completion	rexit_done;
+	struct completion	u3exit_done;
 };
 
 struct xhci_hub {
-- 
2.43.0



