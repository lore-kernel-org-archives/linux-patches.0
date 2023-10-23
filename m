Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225F115EAD
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtD7jber"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93421C433C8;
	Mon, 23 Oct 2023 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061705;
	bh=J40IjoVbKHGrKOgMcdlNTlA2Y4h5k2HTIweJzuxMovs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtD7jberrQ2n6fnkXV4TJnsebs7Di55MgZKzoKTiTWbRKiWttgnfXhwQ44UpPrZmk
	 LGAkoaO+tn/dSU5inSKDdZwXAQhWUBsLaFIZnUqnKhlLLGFDaAVA9O8wTF9n9F5voF
	 qxnPYZI13aieRoqlht/zkjiyLGAqBn7tUfabETSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/202] xhci: rename resume_done to resume_timestamp
Date: Mon, 23 Oct 2023 12:57:24 +0200
Message-ID: <20231023104830.548363030@linuxfoundation.org>
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

[ Upstream commit a909d629ae77b97b6288bc3cfe68560454bf79c6 ]

resume_done is just a timestamp, avoid confusing it with completions
related to port state transitions that are named *_done

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d7cdfc319b2b ("xhci: track port suspend state correctly in unsuccessful resume cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c  | 20 ++++++++++----------
 drivers/usb/host/xhci-ring.c |  4 ++--
 drivers/usb/host/xhci.h      |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index f836710bcd6e6..39c58b1782d5c 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -838,7 +838,7 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 		return -EINVAL;
 	}
 	/* did port event handler already start resume timing? */
-	if (!port->resume_done) {
+	if (!port->resume_timestamp) {
 		/* If not, maybe we are in a host initated resume? */
 		if (test_bit(wIndex, &bus_state->resuming_ports)) {
 			/* Host initated resume doesn't time the resume
@@ -855,18 +855,18 @@ static int xhci_handle_usb2_port_link_resume(struct xhci_port *port,
 				msecs_to_jiffies(USB_RESUME_TIMEOUT);
 
 			set_bit(wIndex, &bus_state->resuming_ports);
-			port->resume_done = timeout;
+			port->resume_timestamp = timeout;
 			mod_timer(&hcd->rh_timer, timeout);
 			usb_hcd_start_port_resume(&hcd->self, wIndex);
 		}
 	/* Has resume been signalled for USB_RESUME_TIME yet? */
-	} else if (time_after_eq(jiffies, port->resume_done)) {
+	} else if (time_after_eq(jiffies, port->resume_timestamp)) {
 		int time_left;
 
 		xhci_dbg(xhci, "resume USB2 port %d-%d\n",
 			 hcd->self.busnum, wIndex + 1);
 
-		port->resume_done = 0;
+		port->resume_timestamp = 0;
 		clear_bit(wIndex, &bus_state->resuming_ports);
 		port->rexit_active = true;
 
@@ -1001,10 +1001,10 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 		if (link_state == XDEV_U2)
 			*status |= USB_PORT_STAT_L1;
 		if (link_state == XDEV_U0) {
-			if (port->resume_done)
+			if (port->resume_timestamp)
 				usb_hcd_end_port_resume(&port->rhub->hcd->self,
 							portnum);
-			port->resume_done = 0;
+			port->resume_timestamp = 0;
 			clear_bit(portnum, &bus_state->resuming_ports);
 			if (bus_state->suspended_ports & (1 << portnum)) {
 				bus_state->suspended_ports &= ~(1 << portnum);
@@ -1076,11 +1076,11 @@ static u32 xhci_get_port_status(struct usb_hcd *hcd,
 	 * Clear stale usb2 resume signalling variables in case port changed
 	 * state during resume signalling. For example on error
 	 */
-	if ((port->resume_done ||
+	if ((port->resume_timestamp ||
 	     test_bit(wIndex, &bus_state->resuming_ports)) &&
 	    (raw_port_status & PORT_PLS_MASK) != XDEV_U3 &&
 	    (raw_port_status & PORT_PLS_MASK) != XDEV_RESUME) {
-		port->resume_done = 0;
+		port->resume_timestamp = 0;
 		clear_bit(wIndex, &bus_state->resuming_ports);
 		usb_hcd_end_port_resume(&hcd->self, wIndex);
 	}
@@ -1588,8 +1588,8 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 		if ((temp & mask) != 0 ||
 			(bus_state->port_c_suspend & 1 << i) ||
-			(ports[i]->resume_done && time_after_eq(
-			    jiffies, ports[i]->resume_done))) {
+			(ports[i]->resume_timestamp && time_after_eq(
+			    jiffies, ports[i]->resume_timestamp))) {
 			buf[(i + 1) / 8] |= 1 << (i + 1) % 8;
 			status = 1;
 		}
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ada9977c41aa9..5ee095a5d38aa 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1851,7 +1851,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			goto cleanup;
 		} else if (!test_bit(hcd_portnum, &bus_state->resuming_ports)) {
 			xhci_dbg(xhci, "resume HS port %d\n", port_id);
-			port->resume_done = jiffies +
+			port->resume_timestamp = jiffies +
 				msecs_to_jiffies(USB_RESUME_TIMEOUT);
 			set_bit(hcd_portnum, &bus_state->resuming_ports);
 			/* Do the rest in GetPortStatus after resume time delay.
@@ -1860,7 +1860,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 			 */
 			set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 			mod_timer(&hcd->rh_timer,
-				  port->resume_done);
+				  port->resume_timestamp);
 			usb_hcd_start_port_resume(&hcd->self, hcd_portnum);
 			bogus_port_status = true;
 		}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 14eb13a85fce3..bb3c362a194b2 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1724,7 +1724,7 @@ struct xhci_port {
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
 	unsigned int		lpm_incapable:1;
-	unsigned long		resume_done;
+	unsigned long		resume_timestamp;
 	bool			rexit_active;
 	struct completion	rexit_done;
 	struct completion	u3exit_done;
-- 
2.40.1



