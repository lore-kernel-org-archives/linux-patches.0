Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5363E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE927C433C1;
	Wed, 23 Nov 2022 09:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197358;
	bh=GquhZ1aoUSoAgJ5W7DU9rAzCTWAhRGnBrpq6R36RTck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvVNq/C/kMy2y8zShhRNZzD3NYlXS0w2hXl1aFJHTB/6gmTEug89vyWw4sMGoLFUe
	 3+cQrSaf6SFf7bHVTe18sf1y79VwIA44rf67I3QWWROmHeJVb3i8FWNkJH4Igushn+
	 zqlqRcjwKC1kde9rms37jOeHpcVqhCEMOKROUgsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 6.0 241/314] usb: cdns3: host: fix endless superspeed hub port reset
Date: Wed, 23 Nov 2022 09:51:26 +0100
Message-Id: <20221123084636.401601549@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Jun <jun.li@nxp.com>

commit 9d5333c931347005352d5b8beaa43528c94cfc9c upstream.

When usb 3.0 hub connect with one USB 2.0 device and NO USB 3.0 device,
some usb hub reports endless port reset message.

[  190.324169] usb 2-1: new SuperSpeed USB device number 88 using xhci-hcd
[  190.352834] hub 2-1:1.0: USB hub found
[  190.356995] hub 2-1:1.0: 4 ports detected
[  190.700056] usb 2-1: USB disconnect, device number 88
[  192.472139] usb 2-1: new SuperSpeed USB device number 89 using xhci-hcd
[  192.500820] hub 2-1:1.0: USB hub found
[  192.504977] hub 2-1:1.0: 4 ports detected
[  192.852066] usb 2-1: USB disconnect, device number 89

The reason is the runtime pm state of USB2.0 port is active and
USB 3.0 port is suspend, so parent device is active state.

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/usb2/power/runtime_status

 suspended

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/usb1/power/runtime_status

 active

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/xhci-hcd.1.auto/power/runtime_status

 active

 cat /sys/bus/platform/devices/5b110000.usb/5b130000.usb/power/runtime_status

 active

So xhci_cdns3_suspend_quirk() have not called. U3 configure is not applied.

move U3 configure into host start. Reinit again in resume function in case
controller power lost during suspend.

Cc: stable@vger.kernel.org 5.10
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Acked-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20221026190749.2280367-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/host.c |   56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -24,11 +24,37 @@
 #define CFG_RXDET_P3_EN		BIT(15)
 #define LPM_2_STB_SWITCH_EN	BIT(25)
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd);
+static void xhci_cdns3_plat_start(struct usb_hcd *hcd)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	u32 value;
+
+	/* set usbcmd.EU3S */
+	value = readl(&xhci->op_regs->command);
+	value |= CMD_PM_INDEX;
+	writel(value, &xhci->op_regs->command);
+
+	if (hcd->regs) {
+		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
+		value |= CFG_RXDET_P3_EN;
+		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
+
+		value = readl(hcd->regs + XECP_PORT_CAP_REG);
+		value |= LPM_2_STB_SWITCH_EN;
+		writel(value, hcd->regs + XECP_PORT_CAP_REG);
+	}
+}
+
+static int xhci_cdns3_resume_quirk(struct usb_hcd *hcd)
+{
+	xhci_cdns3_plat_start(hcd);
+	return 0;
+}
 
 static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
 	.quirks = XHCI_SKIP_PHY_INIT | XHCI_AVOID_BEI,
-	.suspend_quirk = xhci_cdns3_suspend_quirk,
+	.plat_start = xhci_cdns3_plat_start,
+	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
 static int __cdns_host_init(struct cdns *cdns)
@@ -90,32 +116,6 @@ err1:
 	return ret;
 }
 
-static int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
-{
-	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
-	u32 value;
-
-	if (pm_runtime_status_suspended(hcd->self.controller))
-		return 0;
-
-	/* set usbcmd.EU3S */
-	value = readl(&xhci->op_regs->command);
-	value |= CMD_PM_INDEX;
-	writel(value, &xhci->op_regs->command);
-
-	if (hcd->regs) {
-		value = readl(hcd->regs + XECP_AUX_CTRL_REG1);
-		value |= CFG_RXDET_P3_EN;
-		writel(value, hcd->regs + XECP_AUX_CTRL_REG1);
-
-		value = readl(hcd->regs + XECP_PORT_CAP_REG);
-		value |= LPM_2_STB_SWITCH_EN;
-		writel(value, hcd->regs + XECP_PORT_CAP_REG);
-	}
-
-	return 0;
-}
-
 static void cdns_host_exit(struct cdns *cdns)
 {
 	kfree(cdns->xhci_plat_data);


