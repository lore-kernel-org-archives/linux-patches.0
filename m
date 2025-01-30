Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67081E98F1;
	Thu, 30 Jan 2025 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247028; cv=none; b=ZfojbCXC4TPTcHqWBlUt0dpTFl0VVil0kpDIgUMwVjPLdh/TjgZjr9vf/MAfZ5mnF88EN35rdEdi9E1gkdD/TRk1jsJFKJxySB+SfmJ22GuTtu8Z5/2JDjp4OFjxM8PNaEnQghp5IffYcAk+2oa5zKPfcRgx2ogj0NkUMPshdBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247028; c=relaxed/simple;
	bh=vcqM8/ZiXLgs3q21ADpRcy+5tCoxo+UtqinHuCSpF4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN7w20bPkkTT0goN5yuJJIwTyQh1Bn9FFkFqGgc/T+TRewpx2FOeuI5hb5Gm6x7fM3TuXIcWB4wAumzXPEA8q1QMhdRVOLEcUahef6xdmKI3k6JHSqZ2ahPLKawPqJZL+Zm+Jo1CfRSm0Ne56xrkgjLKgsO+VFZIgC6CYFer6Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZU0jq36/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZU0jq36/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52810C4CED2;
	Thu, 30 Jan 2025 14:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247028;
	bh=vcqM8/ZiXLgs3q21ADpRcy+5tCoxo+UtqinHuCSpF4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZU0jq36/Axa5lw3AoZq8Vn0s0aAnAv1WO0F2Fubet9FCSdLWMZv88hc3DDtEWlUEd
	 i5OdVCDBq9coRcDHZaCBEzf2GSYew3t8c6kHPte7sWLI6oLfmpRBF4wuedwov/Ys6s
	 a1fKsBDGllAwbGIPtHUuxaykF2AEC6gXGVBDTQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/133] phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers
Date: Thu, 30 Jan 2025 15:00:46 +0100
Message-ID: <20250130140144.814734853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit ae532b2b7aa5a3dad036aef4e0b177607172d276 ]

Add "wake on" support for the newer Synopsis based XHCI only controller.
This works on the 72165 and 72164 and newer chips and does not work
on 7216 based systems. Also switch the USB sysclk to a slower clock
on suspend to save additional power in S2. The clock switch will only
save power on the 72165b0 and newer chips and is a nop on older chips.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220215032422.5179-1-f.fainelli@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0a92ea87bdd6 ("phy: usb: Toggle the PHY power during init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/broadcom/phy-brcm-usb-init-synopsys.c | 46 +++++++++++++++----
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index e63457e145c7..d2524b70ea16 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -47,6 +47,8 @@
 #define   USB_CTRL_USB_PM_SOFT_RESET_MASK		0x40000000
 #define   USB_CTRL_USB_PM_BDC_SOFT_RESETB_MASK		0x00800000
 #define   USB_CTRL_USB_PM_XHC_SOFT_RESETB_MASK		0x00400000
+#define   USB_CTRL_USB_PM_XHC_PME_EN_MASK		0x00000010
+#define   USB_CTRL_USB_PM_XHC_S2_CLK_SWITCH_EN_MASK	0x00000008
 #define USB_CTRL_USB_PM_STATUS		0x08
 #define USB_CTRL_USB_DEVICE_CTL1	0x10
 #define   USB_CTRL_USB_DEVICE_CTL1_PORT_MODE_MASK	0x00000003
@@ -190,10 +192,6 @@ static void usb_init_common(struct brcm_usb_init_params *params)
 
 	pr_debug("%s\n", __func__);
 
-	USB_CTRL_UNSET(ctrl, USB_PM, USB_PWRDN);
-	/* 1 millisecond - for USB clocks to settle down */
-	usleep_range(1000, 2000);
-
 	if (USB_CTRL_MASK(USB_DEVICE_CTL1, PORT_MODE)) {
 		reg = brcm_usb_readl(USB_CTRL_REG(ctrl, USB_DEVICE_CTL1));
 		reg &= ~USB_CTRL_MASK(USB_DEVICE_CTL1, PORT_MODE);
@@ -222,6 +220,17 @@ static void usb_wake_enable_7211b0(struct brcm_usb_init_params *params,
 		USB_CTRL_UNSET(ctrl, CTLR_CSHCR, ctl_pme_en);
 }
 
+static void usb_wake_enable_7216(struct brcm_usb_init_params *params,
+				 bool enable)
+{
+	void __iomem *ctrl = params->regs[BRCM_REGS_CTRL];
+
+	if (enable)
+		USB_CTRL_SET(ctrl, USB_PM, XHC_PME_EN);
+	else
+		USB_CTRL_UNSET(ctrl, USB_PM, XHC_PME_EN);
+}
+
 static void usb_init_common_7211b0(struct brcm_usb_init_params *params)
 {
 	void __iomem *ctrl = params->regs[BRCM_REGS_CTRL];
@@ -295,6 +304,20 @@ static void usb_init_common_7211b0(struct brcm_usb_init_params *params)
 	usb2_eye_fix_7211b0(params);
 }
 
+static void usb_init_common_7216(struct brcm_usb_init_params *params)
+{
+	void __iomem *ctrl = params->regs[BRCM_REGS_CTRL];
+
+	USB_CTRL_UNSET(ctrl, USB_PM, XHC_S2_CLK_SWITCH_EN);
+	USB_CTRL_UNSET(ctrl, USB_PM, USB_PWRDN);
+
+	/* 1 millisecond - for USB clocks to settle down */
+	usleep_range(1000, 2000);
+
+	usb_wake_enable_7216(params, false);
+	usb_init_common(params);
+}
+
 static void usb_init_xhci(struct brcm_usb_init_params *params)
 {
 	pr_debug("%s\n", __func__);
@@ -302,14 +325,20 @@ static void usb_init_xhci(struct brcm_usb_init_params *params)
 	xhci_soft_reset(params, 0);
 }
 
-static void usb_uninit_common(struct brcm_usb_init_params *params)
+static void usb_uninit_common_7216(struct brcm_usb_init_params *params)
 {
 	void __iomem *ctrl = params->regs[BRCM_REGS_CTRL];
 
 	pr_debug("%s\n", __func__);
 
-	USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
+	if (!params->wake_enabled) {
+		USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
 
+		/* Switch to using slower clock during suspend to save power */
+		USB_CTRL_SET(ctrl, USB_PM, XHC_S2_CLK_SWITCH_EN);
+	} else {
+		usb_wake_enable_7216(params, true);
+	}
 }
 
 static void usb_uninit_common_7211b0(struct brcm_usb_init_params *params)
@@ -371,9 +400,9 @@ static void usb_set_dual_select(struct brcm_usb_init_params *params, int mode)
 
 static const struct brcm_usb_init_ops bcm7216_ops = {
 	.init_ipp = usb_init_ipp,
-	.init_common = usb_init_common,
+	.init_common = usb_init_common_7216,
 	.init_xhci = usb_init_xhci,
-	.uninit_common = usb_uninit_common,
+	.uninit_common = usb_uninit_common_7216,
 	.uninit_xhci = usb_uninit_xhci,
 	.get_dual_select = usb_get_dual_select,
 	.set_dual_select = usb_set_dual_select,
@@ -396,6 +425,7 @@ void brcm_usb_dvr_init_7216(struct brcm_usb_init_params *params)
 
 	params->family_name = "7216";
 	params->ops = &bcm7216_ops;
+	params->suspend_with_clocks = true;
 }
 
 void brcm_usb_dvr_init_7211b0(struct brcm_usb_init_params *params)
-- 
2.39.5



