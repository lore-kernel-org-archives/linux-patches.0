Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFB746EF62;
	Tue, 21 Jul 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659583; cv=none; b=jQoICgzupgER5gISRZVV6D4rlDmKcfdLM9m0QBWGyXbksXF+uFTG+dwFbJzmmmSIXcWXjguEuKIZFLY9KyXUXsfUmJ9rpqnw2eoyAXP9yWbpi4bypjQ15IG3NPoZ9pOMWN8icENdaoSYTAYQZNpiZI8yE5i6nnl72pM4mvmFboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659583; c=relaxed/simple;
	bh=uo4p7JuZCtws/7Vqct0www5AObBP0STlXYNBg+aWN5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du8Z0Auxp/BkD+l3OzhSQWsZ4CJZ5r6OnnzngYTVm3Izl5i9BiW61jsdJ+K4m79bFG6neijQvJIoOejMY1IzCKvZT+9C/6sU/pALewGLtgnimTlAWJb113YWw5MwiR9Ntyi1y5E2sXtpvp01QNt6S5I5+W5Oy97Z2DgTeAvYMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO9LRRQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO9LRRQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6041C1F000E9;
	Tue, 21 Jul 2026 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659581;
	bh=cvXOljCJsBimiRslrXQvtmlZEHLbuRCV7e9nzPWY9FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO9LRRQDQN+wRComcfk6OfuAlFFwbdrjCTtjeBIL0G8EngGQBzuyOFRg69+ZKtQtU
	 2RMcu1JdW0l3CQ/E7DekAuHOvQX/LF/H6lSanf9kWGRkoTnePXmVAp4+TUfkW5ntDk
	 5HK+k5YHQPz2rrecJNvo3X9oYTBw7Ha0DZw2f85I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Rohloff <ingo.rohloff@lauterbach.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1573/1611] usb: dwc3: Support USB3340x ULPI PHY high-speed negotiation.
Date: Tue, 21 Jul 2026 17:28:09 +0200
Message-ID: <20260721152550.851115775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Rohloff <ingo.rohloff@lauterbach.com>

[ Upstream commit a28de63356575612954d4e5d5f48a2488f50e16d ]

The Microchip USB3340x ULPI PHY requires a delay when switching to the
high-speed transmitter. See:
    http://ww1.microchip.com/downloads/en/DeviceDoc/80000645A.pdf
    Module 2 "Device Enumeration Failure with Link IP Systems"

For details on the behavior and fix, refer to the AMD (formerly Xilinx)
forum post: "USB stuck in full speed mode with USB3340 ULPI PHY, ZynqMP."

This patch uses the USB PHY Vendor-ID and Product-ID to detect the
USB3340 PHY and then applies the necessary fix if this PHY is found.

Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260305121452.54082-2-ingo.rohloff@lauterbach.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e0f844d9d742 ("usb: dwc3: fix dwc3_readl() and dwc3_writel() calls in dwc3_ulpi_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   20 ++++++++++++++++++++
 drivers/usb/dwc3/core.h |    4 ++++
 drivers/usb/dwc3/ulpi.c |   25 +++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -781,6 +781,24 @@ static int dwc3_hs_phy_setup(struct dwc3
 	return 0;
 }
 
+static void dwc3_ulpi_setup(struct dwc3 *dwc)
+{
+	int index;
+	u32 reg;
+
+	/* Don't do anything if there is no ULPI PHY */
+	if (!dwc->ulpi)
+		return;
+
+	if (dwc->enable_usb2_transceiver_delay) {
+		for (index = 0; index < dwc->num_usb2_ports; index++) {
+			reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(index));
+			reg |= DWC3_GUSB2PHYCFG_XCVRDLY;
+			dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(index), reg);
+		}
+	}
+}
+
 /**
  * dwc3_phy_setup - Configure USB PHY Interface of DWC3 Core
  * @dwc: Pointer to our controller context structure
@@ -1355,6 +1373,8 @@ static int dwc3_core_init(struct dwc3 *d
 		dwc->ulpi_ready = true;
 	}
 
+	dwc3_ulpi_setup(dwc);
+
 	if (!dwc->phys_ready) {
 		ret = dwc3_core_get_phy(dwc);
 		if (ret)
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -302,6 +302,7 @@
 #define DWC3_GUSB2PHYCFG_SUSPHY		BIT(6)
 #define DWC3_GUSB2PHYCFG_ULPI_UTMI	BIT(4)
 #define DWC3_GUSB2PHYCFG_ENBLSLPM	BIT(8)
+#define DWC3_GUSB2PHYCFG_XCVRDLY	BIT(9)
 #define DWC3_GUSB2PHYCFG_PHYIF(n)	(n << 3)
 #define DWC3_GUSB2PHYCFG_PHYIF_MASK	DWC3_GUSB2PHYCFG_PHYIF(1)
 #define DWC3_GUSB2PHYCFG_USBTRDTIM(n)	(n << 10)
@@ -1161,6 +1162,8 @@ struct dwc3_glue_ops {
  *	3	- Reserved
  * @dis_metastability_quirk: set to disable metastability quirk.
  * @dis_split_quirk: set to disable split boundary.
+ * @enable_usb2_transceiver_delay: Set to insert a delay before the
+ *			assertion of the TxValid signal during a HS Chirp.
  * @sys_wakeup: set if the device may do system wakeup.
  * @wakeup_configured: set if the device is configured for remote wakeup.
  * @suspended: set to track suspend event due to U3/L2.
@@ -1403,6 +1406,7 @@ struct dwc3 {
 	unsigned		dis_metastability_quirk:1;
 
 	unsigned		dis_split_quirk:1;
+	unsigned		enable_usb2_transceiver_delay:1;
 	unsigned		async_callbacks:1;
 	unsigned		sys_wakeup:1;
 	unsigned		wakeup_configured:1;
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -10,10 +10,13 @@
 #include <linux/delay.h>
 #include <linux/time64.h>
 #include <linux/ulpi/regs.h>
+#include <linux/ulpi/driver.h>
 
 #include "core.h"
 #include "io.h"
 
+#define USB_VENDOR_MICROCHIP 0x0424
+
 #define DWC3_ULPI_ADDR(a) \
 		((a >= ULPI_EXT_VENDOR_SPECIFIC) ? \
 		DWC3_GUSB2PHYACC_ADDR(ULPI_ACCESS_EXTENDED) | \
@@ -83,6 +86,26 @@ static const struct ulpi_ops dwc3_ulpi_o
 	.write = dwc3_ulpi_write,
 };
 
+static void dwc3_ulpi_detect_config(struct dwc3 *dwc)
+{
+	struct ulpi *ulpi = dwc->ulpi;
+
+	switch (ulpi->id.vendor) {
+	case USB_VENDOR_MICROCHIP:
+		switch (ulpi->id.product) {
+		case 0x0009:
+			/* Microchip USB3340 ULPI PHY */
+			dwc->enable_usb2_transceiver_delay = true;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 int dwc3_ulpi_init(struct dwc3 *dwc)
 {
 	/* Register the interface */
@@ -92,6 +115,8 @@ int dwc3_ulpi_init(struct dwc3 *dwc)
 		return PTR_ERR(dwc->ulpi);
 	}
 
+	dwc3_ulpi_detect_config(dwc);
+
 	return 0;
 }
 


