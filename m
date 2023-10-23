Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7DF15EAD
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo1AOrHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C493C433C8;
	Mon, 23 Oct 2023 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061710;
	bh=WAX0wdzg11bPsrLrFA3ZtG3kI7v94s4of74bDeTzenE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qo1AOrHN1k5dXMYfVcRQp9YGWg/afkAzLo0z00rCDZQEWR3ekqLn33CChHHburanD
	 QtOTdhy0YoQJFCsoalL/Yv/NJ1R3FIn9E+hxHOoUFLtAO8SfxItnleqXzcaFR0ndyJ
	 uBXc7LiUCydqOo8aXJY1Ji+3O3tyNcRbHOPofOok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/202] xhci: decouple usb2 port resume and get_port_status request handling
Date: Mon, 23 Oct 2023 12:57:26 +0200
Message-ID: <20231023104830.609308220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit b0425784b942fffbbdb804896197f1dbccda37c5 ]

The get port status hub request code in xhci-hub.c will complete usb2
port resume signalling if signalling has been going on for long enough.

The code that completes the resume signalling, and the code that returns
the port status have gotten too intertwined, so separate them a bit.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-12-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d7cdfc319b2b ("xhci: track port suspend state correctly in unsuccessful resume cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 47 ++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 0aac8fcd37798..b8dad0a3aab39 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -819,7 +819,7 @@ static void xhci_del_comp_mod_timer(struct xhci_hcd *xhci, u32 status,
 }
 
 static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
-					     u32 *status, u32 portsc,
+					     u32 portsc,
 					     unsigned long *flags)
 {
 	struct xhci_bus_state *bus_state;
@@ -834,7 +834,6 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 	wIndex = port->hcd_portnum;
 
 	if ((portsc & PORT_RESET) || !(portsc & PORT_PE)) {
-		*status = 0xffffffff;
 		return -EINVAL;
 	}
 	/* did port event handler already start resume timing? */
@@ -868,6 +867,8 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 
 		port->resume_timestamp = 0;
 		clear_bit(wIndex, &bus_state->resuming_ports);
+
+		reinit_completion(&port->rexit_done);
 		port->rexit_active = true;
 
 		xhci_test_and_clear_bit(xhci, port, PORT_PLC);
@@ -884,7 +885,6 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 							    wIndex + 1);
 			if (!slot_id) {
 				xhci_dbg(xhci, "slot_id is zero\n");
-				*status = 0xffffffff;
 				return -ENODEV;
 			}
 			xhci_ring_device(xhci, slot_id);
@@ -893,22 +893,19 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 
 			xhci_warn(xhci, "Port resume timed out, port %d-%d: 0x%x\n",
 				  hcd->self.busnum, wIndex + 1, port_status);
-			*status |= USB_PORT_STAT_SUSPEND;
-			port->rexit_active = false;
+			/*
+			 * keep rexit_active set if U0 transition failed so we
+			 * know to report PORT_STAT_SUSPEND status back to
+			 * usbcore. It will be cleared later once the port is
+			 * out of RESUME/U3 state
+			 */
 		}
 
 		usb_hcd_end_port_resume(&hcd->self, wIndex);
 		bus_state->port_c_suspend |= 1 << wIndex;
 		bus_state->suspended_ports &= ~(1 << wIndex);
-	} else {
-		/*
-		 * The resume has been signaling for less than
-		 * USB_RESUME_TIME. Report the port status as SUSPEND,
-		 * let the usbcore check port status again and clear
-		 * resume signaling later.
-		 */
-		*status |= USB_PORT_STAT_SUSPEND;
 	}
+
 	return 0;
 }
 
@@ -985,6 +982,7 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 	struct xhci_bus_state *bus_state;
 	u32 link_state;
 	u32 portnum;
+	int err;
 
 	bus_state = &port->rhub->bus_state;
 	link_state = portsc & PORT_PLS_MASK;
@@ -1006,8 +1004,12 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 			}
 		}
 		if (link_state == XDEV_RESUME) {
-			xhci_handle_usb2_port_link_resume(port, status, portsc,
-							  flags);
+			err = xhci_handle_usb2_port_link_resume(port, portsc,
+								flags);
+			if (err < 0)
+				*status = 0xffffffff;
+			else if (port->resume_timestamp || port->rexit_active)
+				*status |= USB_PORT_STAT_SUSPEND;
 		}
 	}
 
@@ -1016,13 +1018,14 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 	 * or resuming. Port either resumed to U0/U1/U2, disconnected, or in a
 	 * error state. Resume related variables should be cleared in all those cases.
 	 */
-	if ((link_state != XDEV_U3 &&
-	     link_state != XDEV_RESUME) &&
-	    (port->resume_timestamp ||
-	     test_bit(portnum, &bus_state->resuming_ports))) {
-		port->resume_timestamp = 0;
-		clear_bit(portnum, &bus_state->resuming_ports);
-		usb_hcd_end_port_resume(&port->rhub->hcd->self, portnum);
+	if (link_state != XDEV_U3 && link_state != XDEV_RESUME) {
+		if (port->resume_timestamp ||
+		    test_bit(portnum, &bus_state->resuming_ports)) {
+			port->resume_timestamp = 0;
+			clear_bit(portnum, &bus_state->resuming_ports);
+			usb_hcd_end_port_resume(&port->rhub->hcd->self, portnum);
+		}
+		port->rexit_active = 0;
 	}
 }
 
-- 
2.40.1



