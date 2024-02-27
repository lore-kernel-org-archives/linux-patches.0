Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AAA13B2B4;
	Tue, 27 Feb 2024 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042989; cv=none; b=B5seBvkDtqf2CiZAyIhpMIQsiwaS+u2ouu1xpOWwxvfEffSoJLzicKhS5vDj+ygtZFi81QbpWWcLQxofS3OGGYtUx4b5cea/MY5YQI25J50SX2dVt33n2bjdGtNTNGuotJ5nN4L7IcNu1v2Y0eCGBkG321LNcTob/uEXjUS603U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042989; c=relaxed/simple;
	bh=EqB/mjrbnxUJ/wa1XLV8H453ei0S2E3nwIRR37v2S88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDXs/+/5oXyEQPn0/eLDysskYg52tGZ5+q+0geCA8LOj/VGTcm+LmKgxnn3C2Ju+9t3VPm87U3L8/JBd4Bi5du4wWanGYsuf8OlBTAsDwMARN0Q/7TGzakkn8+QDGhPC79lNyCgtggRWKYdbXm9e2GKzjhFv5RXR6CEq25spx0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH53kBo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH53kBo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE58C433F1;
	Tue, 27 Feb 2024 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042989;
	bh=EqB/mjrbnxUJ/wa1XLV8H453ei0S2E3nwIRR37v2S88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH53kBo7fa1ylA4bydVpjHiM1FJ/JZD8+QDed9X98wYtCiQUIEwhG9/xZNzLfMP/I
	 rh4Ut/tE+YGSzzENmWmiICUYiiPZk0l0mN8D+Tyr/1BeF62G3OvYt1IND289arvmZc
	 KXWKMAgNl5lO0D+2vPoOcxDRA69iUKSLnPazZQ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/245] xhci: cleanup xhci_hub_control port references
Date: Tue, 27 Feb 2024 14:26:22 +0100
Message-ID: <20240227131621.493073349@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit faaae0190dcd1e230616c85bbc3b339f27ba5b81 ]

Both port number and port structure of a port are referred to several
times when handing hub requests in xhci.

Use more suitable data types and readable names for these.
Cleanup only, no functional changes

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d7cdfc319b2b ("xhci: track port suspend state correctly in unsuccessful resume cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-hub.c | 123 ++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 60 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index b9754784161d7..3526665575af2 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1194,11 +1194,14 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	u16 test_mode = 0;
 	struct xhci_hub *rhub;
 	struct xhci_port **ports;
+	struct xhci_port *port;
+	int portnum1;
 
 	rhub = xhci_get_rhub(hcd);
 	ports = rhub->ports;
 	max_ports = rhub->num_ports;
 	bus_state = &rhub->bus_state;
+	portnum1 = wIndex & 0xff;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	switch (typeReq) {
@@ -1232,10 +1235,12 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return retval;
 	case GetPortStatus:
-		if (!wIndex || wIndex > max_ports)
+		if (!portnum1 || portnum1 > max_ports)
 			goto error;
+
 		wIndex--;
-		temp = readl(ports[wIndex]->addr);
+		port = ports[portnum1 - 1];
+		temp = readl(port->addr);
 		if (temp == ~(u32)0) {
 			xhci_hc_died(xhci);
 			retval = -ENODEV;
@@ -1248,7 +1253,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			goto error;
 
 		xhci_dbg(xhci, "Get port status %d-%d read: 0x%x, return 0x%x",
-			 hcd->self.busnum, wIndex + 1, temp, status);
+			 hcd->self.busnum, portnum1, temp, status);
 
 		put_unaligned(cpu_to_le32(status), (__le32 *) buf);
 		/* if USB 3.1 extended port status return additional 4 bytes */
@@ -1260,7 +1265,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				retval = -EINVAL;
 				break;
 			}
-			port_li = readl(ports[wIndex]->addr + PORTLI);
+			port_li = readl(port->addr + PORTLI);
 			status = xhci_get_ext_port_status(temp, port_li);
 			put_unaligned_le32(status, &buf[4]);
 		}
@@ -1274,11 +1279,14 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			test_mode = (wIndex & 0xff00) >> 8;
 		/* The MSB of wIndex is the U1/U2 timeout */
 		timeout = (wIndex & 0xff00) >> 8;
+
 		wIndex &= 0xff;
-		if (!wIndex || wIndex > max_ports)
+		if (!portnum1 || portnum1 > max_ports)
 			goto error;
+
+		port = ports[portnum1 - 1];
 		wIndex--;
-		temp = readl(ports[wIndex]->addr);
+		temp = readl(port->addr);
 		if (temp == ~(u32)0) {
 			xhci_hc_died(xhci);
 			retval = -ENODEV;
@@ -1288,11 +1296,10 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		/* FIXME: What new port features do we need to support? */
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			if ((temp & PORT_PLS_MASK) != XDEV_U0) {
 				/* Resume the port to U0 first */
-				xhci_set_link_state(xhci, ports[wIndex],
-							XDEV_U0);
+				xhci_set_link_state(xhci, port, XDEV_U0);
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				msleep(10);
 				spin_lock_irqsave(&xhci->lock, flags);
@@ -1301,16 +1308,16 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			 * a port unless the port reports that it is in the
 			 * enabled (PED = ‘1’,PLS < ‘3’) state.
 			 */
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			if ((temp & PORT_PE) == 0 || (temp & PORT_RESET)
 				|| (temp & PORT_PLS_MASK) >= XDEV_U3) {
 				xhci_warn(xhci, "USB core suspending port %d-%d not in U0/U1/U2\n",
-					  hcd->self.busnum, wIndex + 1);
+					  hcd->self.busnum, portnum1);
 				goto error;
 			}
 
 			slot_id = xhci_find_slot_id_by_port(hcd, xhci,
-					wIndex + 1);
+							    portnum1);
 			if (!slot_id) {
 				xhci_warn(xhci, "slot_id is zero\n");
 				goto error;
@@ -1320,21 +1327,21 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			xhci_stop_device(xhci, slot_id, 1);
 			spin_lock_irqsave(&xhci->lock, flags);
 
-			xhci_set_link_state(xhci, ports[wIndex], XDEV_U3);
+			xhci_set_link_state(xhci, port, XDEV_U3);
 
 			spin_unlock_irqrestore(&xhci->lock, flags);
 			msleep(10); /* wait device to enter */
 			spin_lock_irqsave(&xhci->lock, flags);
 
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			bus_state->suspended_ports |= 1 << wIndex;
 			break;
 		case USB_PORT_FEAT_LINK_STATE:
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			/* Disable port */
 			if (link_state == USB_SS_PORT_LS_SS_DISABLED) {
 				xhci_dbg(xhci, "Disable port %d-%d\n",
-					 hcd->self.busnum, wIndex + 1);
+					 hcd->self.busnum, portnum1);
 				temp = xhci_port_state_to_neutral(temp);
 				/*
 				 * Clear all change bits, so that we get a new
@@ -1343,18 +1350,17 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				temp |= PORT_CSC | PORT_PEC | PORT_WRC |
 					PORT_OCC | PORT_RC | PORT_PLC |
 					PORT_CEC;
-				writel(temp | PORT_PE, ports[wIndex]->addr);
-				temp = readl(ports[wIndex]->addr);
+				writel(temp | PORT_PE, port->addr);
+				temp = readl(port->addr);
 				break;
 			}
 
 			/* Put link in RxDetect (enable port) */
 			if (link_state == USB_SS_PORT_LS_RX_DETECT) {
 				xhci_dbg(xhci, "Enable port %d-%d\n",
-					 hcd->self.busnum, wIndex + 1);
-				xhci_set_link_state(xhci, ports[wIndex],
-							link_state);
-				temp = readl(ports[wIndex]->addr);
+					 hcd->self.busnum, portnum1);
+				xhci_set_link_state(xhci, port,	link_state);
+				temp = readl(port->addr);
 				break;
 			}
 
@@ -1384,11 +1390,10 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				}
 
 				xhci_dbg(xhci, "Enable compliance mode transition for port %d-%d\n",
-					 hcd->self.busnum, wIndex + 1);
-				xhci_set_link_state(xhci, ports[wIndex],
-						link_state);
+					 hcd->self.busnum, portnum1);
+				xhci_set_link_state(xhci, port, link_state);
 
-				temp = readl(ports[wIndex]->addr);
+				temp = readl(port->addr);
 				break;
 			}
 			/* Port must be enabled */
@@ -1399,8 +1404,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			/* Can't set port link state above '3' (U3) */
 			if (link_state > USB_SS_PORT_LS_U3) {
 				xhci_warn(xhci, "Cannot set port %d-%d link state %d\n",
-					  hcd->self.busnum, wIndex + 1,
-					  link_state);
+					  hcd->self.busnum, portnum1, link_state);
 				goto error;
 			}
 
@@ -1425,8 +1429,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					reinit_completion(&bus_state->u3exit_done[wIndex]);
 				}
 				if (pls <= XDEV_U3) /* U1, U2, U3 */
-					xhci_set_link_state(xhci, ports[wIndex],
-							    USB_SS_PORT_LS_U0);
+					xhci_set_link_state(xhci, port, USB_SS_PORT_LS_U0);
 				if (!wait_u0) {
 					if (pls > XDEV_U3)
 						goto error;
@@ -1436,16 +1439,16 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
 								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
-						 hcd->self.busnum, wIndex + 1);
+						 hcd->self.busnum, portnum1);
 				spin_lock_irqsave(&xhci->lock, flags);
-				temp = readl(ports[wIndex]->addr);
+				temp = readl(port->addr);
 				break;
 			}
 
 			if (link_state == USB_SS_PORT_LS_U3) {
 				int retries = 16;
 				slot_id = xhci_find_slot_id_by_port(hcd, xhci,
-						wIndex + 1);
+								    portnum1);
 				if (slot_id) {
 					/* unlock to execute stop endpoint
 					 * commands */
@@ -1454,16 +1457,16 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 					xhci_stop_device(xhci, slot_id, 1);
 					spin_lock_irqsave(&xhci->lock, flags);
 				}
-				xhci_set_link_state(xhci, ports[wIndex], USB_SS_PORT_LS_U3);
+				xhci_set_link_state(xhci, port, USB_SS_PORT_LS_U3);
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				while (retries--) {
 					usleep_range(4000, 8000);
-					temp = readl(ports[wIndex]->addr);
+					temp = readl(port->addr);
 					if ((temp & PORT_PLS_MASK) == XDEV_U3)
 						break;
 				}
 				spin_lock_irqsave(&xhci->lock, flags);
-				temp = readl(ports[wIndex]->addr);
+				temp = readl(port->addr);
 				bus_state->suspended_ports |= 1 << wIndex;
 			}
 			break;
@@ -1478,39 +1481,38 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			break;
 		case USB_PORT_FEAT_RESET:
 			temp = (temp | PORT_RESET);
-			writel(temp, ports[wIndex]->addr);
+			writel(temp, port->addr);
 
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			xhci_dbg(xhci, "set port reset, actual port %d-%d status  = 0x%x\n",
-				 hcd->self.busnum, wIndex + 1, temp);
+				 hcd->self.busnum, portnum1, temp);
 			break;
 		case USB_PORT_FEAT_REMOTE_WAKE_MASK:
-			xhci_set_remote_wake_mask(xhci, ports[wIndex],
-						  wake_mask);
-			temp = readl(ports[wIndex]->addr);
+			xhci_set_remote_wake_mask(xhci, port, wake_mask);
+			temp = readl(port->addr);
 			xhci_dbg(xhci, "set port remote wake mask, actual port %d-%d status  = 0x%x\n",
-				 hcd->self.busnum, wIndex + 1, temp);
+				 hcd->self.busnum, portnum1, temp);
 			break;
 		case USB_PORT_FEAT_BH_PORT_RESET:
 			temp |= PORT_WR;
-			writel(temp, ports[wIndex]->addr);
-			temp = readl(ports[wIndex]->addr);
+			writel(temp, port->addr);
+			temp = readl(port->addr);
 			break;
 		case USB_PORT_FEAT_U1_TIMEOUT:
 			if (hcd->speed < HCD_USB3)
 				goto error;
-			temp = readl(ports[wIndex]->addr + PORTPMSC);
+			temp = readl(port->addr + PORTPMSC);
 			temp &= ~PORT_U1_TIMEOUT_MASK;
 			temp |= PORT_U1_TIMEOUT(timeout);
-			writel(temp, ports[wIndex]->addr + PORTPMSC);
+			writel(temp, port->addr + PORTPMSC);
 			break;
 		case USB_PORT_FEAT_U2_TIMEOUT:
 			if (hcd->speed < HCD_USB3)
 				goto error;
-			temp = readl(ports[wIndex]->addr + PORTPMSC);
+			temp = readl(port->addr + PORTPMSC);
 			temp &= ~PORT_U2_TIMEOUT_MASK;
 			temp |= PORT_U2_TIMEOUT(timeout);
-			writel(temp, ports[wIndex]->addr + PORTPMSC);
+			writel(temp, port->addr + PORTPMSC);
 			break;
 		case USB_PORT_FEAT_TEST:
 			/* 4.19.6 Port Test Modes (USB2 Test Mode) */
@@ -1526,13 +1528,16 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			goto error;
 		}
 		/* unblock any posted writes */
-		temp = readl(ports[wIndex]->addr);
+		temp = readl(port->addr);
 		break;
 	case ClearPortFeature:
-		if (!wIndex || wIndex > max_ports)
+		if (!portnum1 || portnum1 > max_ports)
 			goto error;
+
+		port = ports[portnum1 - 1];
+
 		wIndex--;
-		temp = readl(ports[wIndex]->addr);
+		temp = readl(port->addr);
 		if (temp == ~(u32)0) {
 			xhci_hc_died(xhci);
 			retval = -ENODEV;
@@ -1542,7 +1547,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		temp = xhci_port_state_to_neutral(temp);
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			temp = readl(ports[wIndex]->addr);
+			temp = readl(port->addr);
 			xhci_dbg(xhci, "clear USB_PORT_FEAT_SUSPEND\n");
 			xhci_dbg(xhci, "PORTSC %04x\n", temp);
 			if (temp & PORT_RESET)
@@ -1553,20 +1558,18 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 				set_bit(wIndex, &bus_state->resuming_ports);
 				usb_hcd_start_port_resume(&hcd->self, wIndex);
-				xhci_set_link_state(xhci, ports[wIndex],
-						    XDEV_RESUME);
+				xhci_set_link_state(xhci, port, XDEV_RESUME);
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				msleep(USB_RESUME_TIMEOUT);
 				spin_lock_irqsave(&xhci->lock, flags);
-				xhci_set_link_state(xhci, ports[wIndex],
-							XDEV_U0);
+				xhci_set_link_state(xhci, port, XDEV_U0);
 				clear_bit(wIndex, &bus_state->resuming_ports);
 				usb_hcd_end_port_resume(&hcd->self, wIndex);
 			}
 			bus_state->port_c_suspend |= 1 << wIndex;
 
 			slot_id = xhci_find_slot_id_by_port(hcd, xhci,
-					wIndex + 1);
+					portnum1);
 			if (!slot_id) {
 				xhci_dbg(xhci, "slot_id is zero\n");
 				goto error;
@@ -1584,11 +1587,11 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		case USB_PORT_FEAT_C_PORT_LINK_STATE:
 		case USB_PORT_FEAT_C_PORT_CONFIG_ERROR:
 			xhci_clear_port_change_bit(xhci, wValue, wIndex,
-					ports[wIndex]->addr, temp);
+					port->addr, temp);
 			break;
 		case USB_PORT_FEAT_ENABLE:
 			xhci_disable_port(hcd, xhci, wIndex,
-					ports[wIndex]->addr, temp);
+					port->addr, temp);
 			break;
 		case USB_PORT_FEAT_POWER:
 			xhci_set_port_power(xhci, hcd, wIndex, false, &flags);
-- 
2.43.0



