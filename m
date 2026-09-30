Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F85503BEF;
	Wed, 30 Sep 2026 19:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797178; cv=none; b=N2l9nSQVfcZKk4DsL1GrxHmIocCdUv+7yv/UcY5NGeJ0lbhjZ6+fdF/cKazsoddpgkFVnUiLmpzO8Y2IvGFU5rAn/2rz5PaW/+BJ00I614UJA0d2Du+wiGpWXse85fZq2OJTXFl6XOwn34YxLyEI/MEqV9mdJl65deBE9ee9jMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797178; c=relaxed/simple;
	bh=pSipA+B7FvgGyMvf5A4mj/3UD6G/1NPFtau3ftZu69s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHo1ug6XbkSuM/6anrZyrGbNC6BQu4AmuO6dg4pN3ZRWfCS1Eka3vLf9X9ANbZu9p5WN6Dek6GSmjZRQDozG3nuWYH/OFN5QlS80MLIN8qdmcxxWhfzyqQ2MXGUVrprxOz8QcVwLg49j6JZOKrCAmDOe0u9MjWOc8CDW6c0SDo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOHEL3jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOHEL3jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C951F00898;
	Wed, 30 Sep 2026 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797176;
	bh=5VW6XbQmXy9UJGJLpBXKUkUHhTcXAV6zPjScc93HMKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOHEL3jR5x9BwbzUnq1EiiGe1qLKnZtMpZ23MpOhC1QOdkwAue0DF2UNAoWyJxkk3
	 Vwi58NxY10RzN/zB5TJ+vvqBU63BoB5UFz9kLHHxRPcSxjO6OCmtIecCSNzuFtk4NL
	 +onKete4A6z6AebBw1lVLwSCsyAJkrOcBsIKkOhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1173/1193] usb: xhci: add tracing for PORTSC register writes
Date: Wed, 30 Sep 2026 17:30:57 +0200
Message-ID: <20260930152500.307409480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 829738e59f1fad90ef7b63d6a1a4de9d5d22544a ]

Introduce a dedicated write function for the USB Port Register Set (PORTSC)
that includes tracing capabilities for values written to the PORTSC
register. This enhancement minimizes code duplication and improves
debugging.

The PORTSC register is part of the Host Controller USB Port Register Set,
comprising 4 x 32-bit registers. As the first register, PORTSC is accessed
directly via 'port->addr'. Future commits will introduce a dedicated Port
register struct to further streamline access.
By adding the xhci_portsc_writel() function prior to these changes, we
significantly reduce the number of same line modifications required.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ dep note: dropped the context-only xhci.h hunk pulling in
  xhci_stop_endpoint_sync()/xhci_update_erst_dequeue()/xhci_add_interrupter()/
  xhci_usb_endpoint_maxp() declarations from upstream's parent commit -
  those functions do not exist in this tree yet and are unrelated to this
  change; only the new xhci_portsc_writel() declaration is kept. Also, this
  tree's xhci_log_portsc trace event class still uses the older
  TP_PROTO(u32 portnum, u32 portsc) signature (the later conversion to
  struct xhci_port * is not present here), so the new xhci_portsc_writel
  tracepoint and its call site were adapted to use port->hcd_portnum
  instead of struct xhci_port * to match. ]

Stable-dep-of: 78203d5b54a4 ("usb: xhci: bail out of setup if the controller is inaccessible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c |    2 +-
 drivers/usb/host/xhci-hub.c     |   33 ++++++++++++++++-----------------
 drivers/usb/host/xhci-pci.c     |    2 +-
 drivers/usb/host/xhci-trace.h   |    5 +++++
 drivers/usb/host/xhci.c         |    9 ++++++++-
 drivers/usb/host/xhci.h         |    1 +
 6 files changed, 32 insertions(+), 20 deletions(-)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -387,7 +387,7 @@ static ssize_t xhci_port_write(struct fi
 		portsc = xhci_port_state_to_neutral(portsc);
 		portsc &= ~PORT_PLS_MASK;
 		portsc |= PORT_LINK_STROBE | XDEV_COMP_MODE;
-		writel(portsc, port->addr);
+		xhci_portsc_writel(port, portsc);
 		spin_unlock_irqrestore(&xhci->lock, flags);
 	} else {
 		return -EINVAL;
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -601,7 +601,7 @@ static void xhci_disable_port(struct xhc
 	portsc = xhci_port_state_to_neutral(portsc);
 
 	/* Write 1 to disable the port */
-	writel(portsc | PORT_PE, port->addr);
+	xhci_portsc_writel(port, portsc | PORT_PE);
 
 	portsc = readl(port->addr);
 	xhci_dbg(xhci, "disable port %d-%d, portsc: 0x%x\n",
@@ -609,7 +609,7 @@ static void xhci_disable_port(struct xhc
 }
 
 static void xhci_clear_port_change_bit(struct xhci_hcd *xhci, u16 wValue,
-		u16 wIndex, __le32 __iomem *addr, u32 port_status)
+		u16 wIndex, struct xhci_port *port, u32 port_status)
 {
 	char *port_change_bit;
 	u32 status;
@@ -652,8 +652,8 @@ static void xhci_clear_port_change_bit(s
 		return;
 	}
 	/* Change bits are all write 1 to clear */
-	writel(port_status | status, addr);
-	port_status = readl(addr);
+	xhci_portsc_writel(port, port_status | status);
+	port_status = readl(port->addr);
 
 	xhci_dbg(xhci, "clear port%d %s change, portsc: 0x%x\n",
 		 wIndex + 1, port_change_bit, port_status);
@@ -690,11 +690,11 @@ static void xhci_set_port_power(struct x
 
 	if (on) {
 		/* Power on */
-		writel(temp | PORT_POWER, port->addr);
+		xhci_portsc_writel(port, temp | PORT_POWER);
 		readl(port->addr);
 	} else {
 		/* Power off */
-		writel(temp & ~PORT_POWER, port->addr);
+		xhci_portsc_writel(port, temp & ~PORT_POWER);
 	}
 
 	spin_unlock_irqrestore(&xhci->lock, *flags);
@@ -793,7 +793,7 @@ void xhci_set_link_state(struct xhci_hcd
 	temp = xhci_port_state_to_neutral(portsc);
 	temp &= ~PORT_PLS_MASK;
 	temp |= PORT_LINK_STROBE | link_state;
-	writel(temp, port->addr);
+	xhci_portsc_writel(port, temp);
 
 	xhci_dbg(xhci, "Set port %d-%d link state, portsc: 0x%x, write 0x%x",
 		 port->rhub->hcd->self.busnum, port->hcd_portnum + 1,
@@ -823,7 +823,7 @@ static void xhci_set_remote_wake_mask(st
 	else
 		temp &= ~PORT_WKOC_E;
 
-	writel(temp, port->addr);
+	xhci_portsc_writel(port, temp);
 }
 
 /* Test and clear port RWC bit */
@@ -836,7 +836,7 @@ void xhci_test_and_clear_bit(struct xhci
 	if (temp & port_bit) {
 		temp = xhci_port_state_to_neutral(temp);
 		temp |= port_bit;
-		writel(temp, port->addr);
+		xhci_portsc_writel(port, temp);
 	}
 }
 
@@ -1365,7 +1365,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 				temp |= PORT_CSC | PORT_PEC | PORT_WRC |
 					PORT_OCC | PORT_RC | PORT_PLC |
 					PORT_CEC;
-				writel(temp | PORT_PE, port->addr);
+				xhci_portsc_writel(port, temp | PORT_PE);
 				temp = readl(port->addr);
 				break;
 			}
@@ -1496,7 +1496,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 			break;
 		case USB_PORT_FEAT_RESET:
 			temp = (temp | PORT_RESET);
-			writel(temp, port->addr);
+			xhci_portsc_writel(port, temp);
 
 			temp = readl(port->addr);
 			xhci_dbg(xhci, "set port reset, actual port %d-%d status  = 0x%x\n",
@@ -1510,7 +1510,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 			break;
 		case USB_PORT_FEAT_BH_PORT_RESET:
 			temp |= PORT_WR;
-			writel(temp, port->addr);
+			xhci_portsc_writel(port, temp);
 			temp = readl(port->addr);
 			break;
 		case USB_PORT_FEAT_U1_TIMEOUT:
@@ -1601,8 +1601,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 		case USB_PORT_FEAT_C_ENABLE:
 		case USB_PORT_FEAT_C_PORT_LINK_STATE:
 		case USB_PORT_FEAT_C_PORT_CONFIG_ERROR:
-			xhci_clear_port_change_bit(xhci, wValue, wIndex,
-					port->addr, temp);
+			xhci_clear_port_change_bit(xhci, wValue, wIndex, port, temp);
 			break;
 		case USB_PORT_FEAT_ENABLE:
 			xhci_disable_port(xhci, port);
@@ -1830,7 +1829,7 @@ retry:
 				spin_lock_irqsave(&xhci->lock, flags);
 			}
 		}
-		writel(portsc_buf[port_index], ports[port_index]->addr);
+		xhci_portsc_writel(ports[port_index], portsc_buf[port_index]);
 	}
 	hcd->state = HC_STATE_SUSPENDED;
 	bus_state->next_statechange = jiffies + msecs_to_jiffies(10);
@@ -1864,7 +1863,7 @@ static bool xhci_port_missing_cas_quirk(
 	/* clear wakeup/change bits, and do a warm port reset */
 	portsc &= ~(PORT_RWC_BITS | PORT_CEC | PORT_WAKE_BITS);
 	portsc |= PORT_WR;
-	writel(portsc, port->addr);
+	xhci_portsc_writel(port, portsc);
 	/* flush write */
 	readl(port->addr);
 	return true;
@@ -1944,7 +1943,7 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 			}
 		/* disable wake for all ports, write new link state if needed */
 		portsc &= ~(PORT_RWC_BITS | PORT_CEC | PORT_WAKE_BITS);
-		writel(portsc, ports[port_index]->addr);
+		xhci_portsc_writel(ports[port_index], portsc);
 	}
 
 	/* USB2 specific resume signaling delay and U0 link state transition */
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -964,7 +964,7 @@ static int xhci_pci_poweroff_late(struct
 		xhci_dbg(xhci, "port %d-%d in U3 without wakeup, disable it\n",
 			 port->rhub->hcd->self.busnum, port->hcd_portnum + 1);
 		portsc = xhci_port_state_to_neutral(portsc);
-		writel(portsc | PORT_PE, port->addr);
+		xhci_portsc_writel(port, portsc | PORT_PE);
 	}
 
 	return 0;
--- a/drivers/usb/host/xhci-trace.h
+++ b/drivers/usb/host/xhci-trace.h
@@ -540,6 +540,11 @@ DEFINE_EVENT(xhci_log_portsc, xhci_hub_s
 	     TP_ARGS(portnum, portsc)
 );
 
+DEFINE_EVENT(xhci_log_portsc, xhci_portsc_writel,
+	     TP_PROTO(u32 portnum, u32 portsc),
+	     TP_ARGS(portnum, portsc)
+);
+
 DECLARE_EVENT_CLASS(xhci_log_doorbell,
 	TP_PROTO(u32 slot, u32 doorbell),
 	TP_ARGS(slot, doorbell),
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -39,6 +39,13 @@ static unsigned long long quirks;
 module_param(quirks, ullong, S_IRUGO);
 MODULE_PARM_DESC(quirks, "Bit flags for quirks to be enabled as default");
 
+void xhci_portsc_writel(struct xhci_port *port, u32 val)
+{
+	trace_xhci_portsc_writel(port->hcd_portnum, val);
+	writel(val, port->addr);
+}
+EXPORT_SYMBOL_GPL(xhci_portsc_writel);
+
 static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
 {
 	struct xhci_segment *seg = ring->first_seg;
@@ -826,7 +833,7 @@ static void xhci_disable_hub_port_wake(s
 			t2 |= PORT_CSC;
 
 		if (t1 != t2) {
-			writel(t2, rhub->ports[i]->addr);
+			xhci_portsc_writel(rhub->ports[i], t2);
 			xhci_dbg(xhci, "config port %d-%d wake bits, portsc: 0x%x, write: 0x%x\n",
 				 rhub->hcd->self.busnum, i + 1, portsc, t2);
 		}
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1974,6 +1974,7 @@ void xhci_cleanup_command_queue(struct x
 void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring);
 unsigned int count_trbs(u64 addr, u64 len);
 void xhci_process_cancelled_tds(struct xhci_virt_ep *ep);
+void xhci_portsc_writel(struct xhci_port *port, u32 val);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, struct xhci_port *port,


