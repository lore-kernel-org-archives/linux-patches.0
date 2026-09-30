Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1E43149B;
	Wed, 30 Sep 2026 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797186; cv=none; b=aftIlTxh9NYLKwfdfzE2J1hUxcveLqX9bldh/ISWOaznW6IYPBDTFzrfipNd+PgyhHJi7xIpN5JTFI/TN73nsciNjWHp4OiWKTdCxGs8M5sIJJTAo8YfDa90UMhdi0xMLA2hfc0z1ys9vMi2kzDqhz7Kosd7fqXfJnvZCpHW9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797186; c=relaxed/simple;
	bh=UIUoJuPZyYu5WLeG0OvZIG2EYn9rsMZcdRCt8uAYJqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3WxIuzOoLo4Z+OU7qc5Wd4CI+qq5nk77PnmCg5wQ2ApYRBseQAArt48n+zL+b0fM5fDyF1oPFU75UwrcnKuDXwbF8BYe92eumsbxUtXycORqHESyn/DM7UXVb0Nzihimh5T6WBGv+D4OVbE+gjQQ6FNzDHGzC0DaPiyET6gGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwHGB9hV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwHGB9hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CACC1F000FF;
	Wed, 30 Sep 2026 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797185;
	bh=AJMevw+BNxDv5IclWx9F7soaSPe0V9kXyTQWHFmuvJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwHGB9hVSI1IBBQ489iChzF60Z3kYM9N+nQRChX8qpn5Q1U0O6ikRLApkLMCRYVny
	 VdLyhIJ4W95EDn68eTVxcuBHKo6b1u7Al5o3lPFXTG+rPjtWLQx2XcSnrUGcw37JI2
	 ALramLSJmVRir8OHAfmpvbB+3AOA3J6BUfh7hmd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1176/1193] usb: xhci: implement USB Port Register Set struct
Date: Wed, 30 Sep 2026 17:31:00 +0200
Message-ID: <20260930152500.369888012@linuxfoundation.org>
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

[ Upstream commit f2469d89a70cc6eb3d8141770995a3b251afa6ff ]

Previously, each port's 'addr' field pointed to the base of the Host
Controller USB Port Register Set, and specific registers were accessed
using macros such as (port->addr + PORTPMSC).

This patch replaces the raw '__le32 __iomem *addr' pointer with a typed
'struct xhci_port_regs __iomem *port_reg' pointer. With this change,
individual registers can be accessed directly through the structure
fields:

Before:
  port->addr
  port->addr + PORTPMSC
  port->addr + PORTLI
  port->addr + PORTHLPMC

After:
  port->port_reg->portsc
  port->port_reg->portpmsc
  port->port_reg->portli
  port->port_reg->porthlpmc

This improves code readability and makes register access more intuitive
by using named struct members instead of pointer arithmetic and macros.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-9-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ This stable tree's xhci_portsc_writel() takes an already-different
  trace_xhci_portsc_writel() signature (u32 portnum, u32 portsc) rather
  than upstream's (struct xhci_port *port, u32 portsc), stemming from
  local commit 3db853f6be156 ("usb: xhci: add tracing for PORTSC
  register writes"). Kept the existing
  trace_xhci_portsc_writel(port->hcd_portnum, val) call as-is and only
  applied the port_reg->portsc register-access conversion from this
  commit. ]

Stable-dep-of: 78203d5b54a4 ("usb: xhci: bail out of setup if the controller is inaccessible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |   16 ++++++++--------
 drivers/usb/host/xhci-mem.c |    2 +-
 drivers/usb/host/xhci.c     |   29 ++++++++++++++---------------
 drivers/usb/host/xhci.h     |    7 +------
 4 files changed, 24 insertions(+), 30 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -714,9 +714,9 @@ static void xhci_port_set_test_mode(stru
 
 	/* xhci only supports test mode for usb2 ports */
 	port = xhci->usb2_rhub.ports[wIndex];
-	temp = readl(port->addr + PORTPMSC);
+	temp = readl(&port->port_reg->portpmsc);
 	temp |= test_mode << PORT_TEST_MODE_SHIFT;
-	writel(temp, port->addr + PORTPMSC);
+	writel(temp, &port->port_reg->portpmsc);
 	xhci->test_mode = test_mode;
 	if (test_mode == USB_TEST_FORCE_ENABLE)
 		xhci_start(xhci);
@@ -1280,7 +1280,7 @@ int xhci_hub_control(struct usb_hcd *hcd
 				retval = -EINVAL;
 				break;
 			}
-			port_li = readl(port->addr + PORTLI);
+			port_li = readl(&port->port_reg->portli);
 			status = xhci_get_ext_port_status(temp, port_li);
 			put_unaligned_le32(status, &buf[4]);
 		}
@@ -1516,18 +1516,18 @@ int xhci_hub_control(struct usb_hcd *hcd
 		case USB_PORT_FEAT_U1_TIMEOUT:
 			if (hcd->speed < HCD_USB3)
 				goto error;
-			temp = readl(port->addr + PORTPMSC);
+			temp = readl(&port->port_reg->portpmsc);
 			temp &= ~PORT_U1_TIMEOUT_MASK;
 			temp |= PORT_U1_TIMEOUT(timeout);
-			writel(temp, port->addr + PORTPMSC);
+			writel(temp, &port->port_reg->portpmsc);
 			break;
 		case USB_PORT_FEAT_U2_TIMEOUT:
 			if (hcd->speed < HCD_USB3)
 				goto error;
-			temp = readl(port->addr + PORTPMSC);
+			temp = readl(&port->port_reg->portpmsc);
 			temp &= ~PORT_U2_TIMEOUT_MASK;
 			temp |= PORT_U2_TIMEOUT(timeout);
-			writel(temp, port->addr + PORTPMSC);
+			writel(temp, &port->port_reg->portpmsc);
 			break;
 		case USB_PORT_FEAT_TEST:
 			/* 4.19.6 Port Test Modes (USB2 Test Mode) */
@@ -1964,7 +1964,7 @@ int xhci_bus_resume(struct usb_hcd *hcd)
 
 	/* poll for U0 link state complete, both USB2 and USB3 */
 	for_each_set_bit(port_index, &bus_state->bus_suspended, BITS_PER_LONG) {
-		sret = xhci_handshake(ports[port_index]->addr, PORT_PLC,
+		sret = xhci_handshake(&ports[port_index]->port_reg->portsc, PORT_PLC,
 				      PORT_PLC, 10 * 1000);
 		if (sret) {
 			xhci_warn(xhci, "port %d-%d resume PLC timeout\n",
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2182,7 +2182,7 @@ static int xhci_setup_port_arrays(struct
 		return -ENOMEM;
 
 	for (i = 0; i < num_ports; i++) {
-		xhci->hw_ports[i].addr = &xhci->op_regs->port_regs[i].portsc;
+		xhci->hw_ports[i].port_reg = &xhci->op_regs->port_regs[i];
 		xhci->hw_ports[i].hw_portnum = i;
 
 		init_completion(&xhci->hw_ports[i].rexit_done);
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -42,13 +42,13 @@ MODULE_PARM_DESC(quirks, "Bit flags for
 void xhci_portsc_writel(struct xhci_port *port, u32 val)
 {
 	trace_xhci_portsc_writel(port->hcd_portnum, val);
-	writel(val, port->addr);
+	writel(val, &port->port_reg->portsc);
 }
 EXPORT_SYMBOL_GPL(xhci_portsc_writel);
 
 u32 xhci_portsc_readl(struct xhci_port *port)
 {
-	return readl(port->addr);
+	return readl(&port->port_reg->portsc);
 }
 EXPORT_SYMBOL_GPL(xhci_portsc_readl);
 
@@ -4471,7 +4471,7 @@ static int xhci_set_usb2_hardware_lpm(st
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	struct xhci_port **ports;
-	__le32 __iomem	*pm_addr, *hlpm_addr;
+	struct xhci_port_regs __iomem *port_reg;
 	u32		pm_val, hlpm_val, field;
 	unsigned int	port_num;
 	unsigned long	flags;
@@ -4496,9 +4496,8 @@ static int xhci_set_usb2_hardware_lpm(st
 
 	ports = xhci->usb2_rhub.ports;
 	port_num = udev->portnum - 1;
-	pm_addr = ports[port_num]->addr + PORTPMSC;
-	pm_val = readl(pm_addr);
-	hlpm_addr = ports[port_num]->addr + PORTHLPMC;
+	port_reg = ports[port_num]->port_reg;
+	pm_val = readl(&port_reg->portpmsc);
 
 	xhci_dbg(xhci, "%s port %d USB2 hardware LPM\n",
 			enable ? "enable" : "disable", port_num + 1);
@@ -4527,30 +4526,30 @@ static int xhci_set_usb2_hardware_lpm(st
 			spin_lock_irqsave(&xhci->lock, flags);
 
 			hlpm_val = xhci_calculate_usb2_hw_lpm_params(udev);
-			writel(hlpm_val, hlpm_addr);
+			writel(hlpm_val, &port_reg->porthlmpc);
 			/* flush write */
-			readl(hlpm_addr);
+			readl(&port_reg->porthlmpc);
 		} else {
 			hird = xhci_calculate_hird_besl(xhci, udev);
 		}
 
 		pm_val &= ~PORT_HIRD_MASK;
 		pm_val |= PORT_HIRD(hird) | PORT_RWE | PORT_L1DS(udev->slot_id);
-		writel(pm_val, pm_addr);
-		pm_val = readl(pm_addr);
+		writel(pm_val, &port_reg->portpmsc);
+		pm_val = readl(&port_reg->portpmsc);
 		pm_val |= PORT_HLE;
-		writel(pm_val, pm_addr);
+		writel(pm_val, &port_reg->portpmsc);
 		/* flush write */
-		readl(pm_addr);
+		readl(&port_reg->portpmsc);
 	} else {
 		pm_val &= ~(PORT_HLE | PORT_RWE | PORT_HIRD_MASK | PORT_L1DS_MASK);
-		writel(pm_val, pm_addr);
+		writel(pm_val, &port_reg->portpmsc);
 		/* flush write */
-		readl(pm_addr);
+		readl(&port_reg->portpmsc);
 		if (udev->usb2_hw_lpm_besl_capable) {
 			spin_unlock_irqrestore(&xhci->lock, flags);
 			xhci_change_max_exit_latency(xhci, udev, 0);
-			readl_poll_timeout(ports[port_num]->addr, pm_val,
+			readl_poll_timeout(&ports[port_num]->port_reg->portsc, pm_val,
 					   (pm_val & PORT_PLS_MASK) == XDEV_U0,
 					   100, 10000);
 			return 0;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -66,11 +66,6 @@ struct xhci_cap_regs {
 	/* Reserved up to (CAPLENGTH - 0x1C) */
 };
 
-#define PORTSC		0
-#define PORTPMSC	1
-#define PORTLI		2
-#define PORTHLPMC	3
-
 /*
  * struct xhci_port_regs - Host Controller USB Port Register Set. xHCI spec 5.4.8
  * @portsc:	Port Status and Control
@@ -1479,7 +1474,7 @@ struct xhci_port_cap {
 };
 
 struct xhci_port {
-	__le32 __iomem		*addr;
+	struct xhci_port_regs __iomem	*port_reg;
 	int			hw_portnum;
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;


