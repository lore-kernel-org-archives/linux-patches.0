Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65144233722;
	Mon, 10 Mar 2025 17:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628475; cv=none; b=Nk/E0B1tPxxaG5LqfnWSH6u3QhtTU5zaBHEOjLDncJDYYmQldpUL8KfOag6Wc/lNGaPZ7Q2SGUIGvgKBoiKxAA6+ks1D3A2XoDuh0QuWZrvjw1NAZ/N6U/1lccFSVr6osxt1bMs2MZuKhWT8e+33LWlsG600K85FK3S6c60oSnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628475; c=relaxed/simple;
	bh=455Wzams3Le7p0V2xhtEryfv2yNvmZrh5yuEPtRt8jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXDsajWn8tHGLhMd2PgS/KyNJpQPBmGtvN9jNjDauuGxUH1aRh3zprCoZydn1Ovgh0TEfyB1Dz9RAinWkKK6TpkFb873B2WQVWXRjOpgVhUk0qyhPY36rIfuIvRXCGIrDWrgnVyeo/cKUoVYD9kr+CfNi7YvJDD/BvC7YI1N0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYcHtYVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYcHtYVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDCAC4CEE5;
	Mon, 10 Mar 2025 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628473;
	bh=455Wzams3Le7p0V2xhtEryfv2yNvmZrh5yuEPtRt8jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYcHtYVh+cqILXiKnGemmABoeFB4yRxnTDwrDZIyaa6NloevHWG/Skxo1knIjSNfM
	 iPNqUWNuEj28g/5Az/92MBBviHGBzqYht1lcK4s2mUoyyWYmRrCk1gPCyrQN5FYFWa
	 ejcdWAs6Igd21ph++ZMy5rPslBgXN8ZOSR1R0S+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 070/109] usb: dwc3: Set SUSPENDENABLE soon after phy init
Date: Mon, 10 Mar 2025 18:06:54 +0100
Message-ID: <20250310170430.347220951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit cc5bfc4e16fc1d1c520cd7bb28646e82b6e69217 upstream.

After phy initialization, some phy operations can only be executed while
in lower P states. Ensure GUSB3PIPECTL.SUSPENDENABLE and
GUSB2PHYCFG.SUSPHY are set soon after initialization to avoid blocking
phy ops.

Previously the SUSPENDENABLE bits are only set after the controller
initialization, which may not happen right away if there's no gadget
driver or xhci driver bound. Revise this to clear SUSPENDENABLE bits
only when there's mode switching (change in GCTL.PRTCAPDIR).

Fixes: 6d735722063a ("usb: dwc3: core: Prevent phy suspend during init")
Cc: stable <stable@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/633aef0afee7d56d2316f7cc3e1b2a6d518a8cc9.1738280911.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   69 +++++++++++++++++++++++++++++-------------------
 drivers/usb/dwc3/core.h |    2 -
 drivers/usb/dwc3/drd.c  |    4 +-
 3 files changed, 45 insertions(+), 30 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -125,11 +125,24 @@ void dwc3_enable_susphy(struct dwc3 *dwc
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
 }
 
-void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode)
+void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode, bool ignore_susphy)
 {
+	unsigned int hw_mode;
 	u32 reg;
 
 	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
+
+	 /*
+	  * For DRD controllers, GUSB3PIPECTL.SUSPENDENABLE and
+	  * GUSB2PHYCFG.SUSPHY should be cleared during mode switching,
+	  * and they can be set after core initialization.
+	  */
+	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
+	if (hw_mode == DWC3_GHWPARAMS0_MODE_DRD && !ignore_susphy) {
+		if (DWC3_GCTL_PRTCAP(reg) != mode)
+			dwc3_enable_susphy(dwc, false);
+	}
+
 	reg &= ~(DWC3_GCTL_PRTCAPDIR(DWC3_GCTL_PRTCAP_OTG));
 	reg |= DWC3_GCTL_PRTCAPDIR(mode);
 	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
@@ -209,7 +222,7 @@ static void __dwc3_set_mode(struct work_
 
 	spin_lock_irqsave(&dwc->lock, flags);
 
-	dwc3_set_prtcap(dwc, desired_dr_role);
+	dwc3_set_prtcap(dwc, desired_dr_role, false);
 
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
@@ -727,16 +740,7 @@ static int dwc3_phy_setup(struct dwc3 *d
 	 */
 	reg &= ~DWC3_GUSB3PIPECTL_UX_EXIT_PX;
 
-	/*
-	 * Above DWC_usb3.0 1.94a, it is recommended to set
-	 * DWC3_GUSB3PIPECTL_SUSPHY to '0' during coreConsultant configuration.
-	 * So default value will be '0' when the core is reset. Application
-	 * needs to set it to '1' after the core initialization is completed.
-	 *
-	 * Similarly for DRD controllers, GUSB3PIPECTL.SUSPENDENABLE must be
-	 * cleared after power-on reset, and it can be set after core
-	 * initialization.
-	 */
+	/* Ensure the GUSB3PIPECTL.SUSPENDENABLE is cleared prior to phy init. */
 	reg &= ~DWC3_GUSB3PIPECTL_SUSPHY;
 
 	if (dwc->u2ss_inp3_quirk)
@@ -809,15 +813,7 @@ static int dwc3_phy_setup(struct dwc3 *d
 		break;
 	}
 
-	/*
-	 * Above DWC_usb3.0 1.94a, it is recommended to set
-	 * DWC3_GUSB2PHYCFG_SUSPHY to '0' during coreConsultant configuration.
-	 * So default value will be '0' when the core is reset. Application
-	 * needs to set it to '1' after the core initialization is completed.
-	 *
-	 * Similarly for DRD controllers, GUSB2PHYCFG.SUSPHY must be cleared
-	 * after power-on reset, and it can be set after core initialization.
-	 */
+	/* Ensure the GUSB2PHYCFG.SUSPHY is cleared prior to phy init. */
 	reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
 
 	if (dwc->dis_enblslpm_quirk)
@@ -849,6 +845,25 @@ static int dwc3_clk_enable(struct dwc3 *
 	if (ret)
 		goto disable_ref_clk;
 
+	/*
+	 * Above DWC_usb3.0 1.94a, it is recommended to set
+	 * DWC3_GUSB3PIPECTL_SUSPHY and DWC3_GUSB2PHYCFG_SUSPHY to '0' during
+	 * coreConsultant configuration. So default value will be '0' when the
+	 * core is reset. Application needs to set it to '1' after the core
+	 * initialization is completed.
+	 *
+	 * Certain phy requires to be in P0 power state during initialization.
+	 * Make sure GUSB3PIPECTL.SUSPENDENABLE and GUSB2PHYCFG.SUSPHY are clear
+	 * prior to phy init to maintain in the P0 state.
+	 *
+	 * After phy initialization, some phy operations can only be executed
+	 * while in lower P states. Ensure GUSB3PIPECTL.SUSPENDENABLE and
+	 * GUSB2PHYCFG.SUSPHY are set soon after initialization to avoid
+	 * blocking phy ops.
+	 */
+	if (!DWC3_VER_IS_WITHIN(DWC3, ANY, 194A))
+		dwc3_enable_susphy(dwc, true);
+
 	return 0;
 
 disable_ref_clk:
@@ -1459,7 +1474,7 @@ static int dwc3_core_init_mode(struct dw
 
 	switch (dwc->dr_mode) {
 	case USB_DR_MODE_PERIPHERAL:
-		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
+		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE, false);
 
 		if (dwc->usb2_phy)
 			otg_set_vbus(dwc->usb2_phy->otg, false);
@@ -1471,7 +1486,7 @@ static int dwc3_core_init_mode(struct dw
 			return dev_err_probe(dev, ret, "failed to initialize gadget\n");
 		break;
 	case USB_DR_MODE_HOST:
-		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_HOST);
+		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_HOST, false);
 
 		if (dwc->usb2_phy)
 			otg_set_vbus(dwc->usb2_phy->otg, true);
@@ -1514,7 +1529,7 @@ static void dwc3_core_exit_mode(struct d
 	}
 
 	/* de-assert DRVVBUS for HOST and OTG mode */
-	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
+	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE, true);
 }
 
 static void dwc3_get_properties(struct dwc3 *dwc)
@@ -2217,7 +2232,7 @@ static int dwc3_resume_common(struct dwc
 		if (ret)
 			return ret;
 
-		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
+		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE, true);
 		dwc3_gadget_resume(dwc);
 		break;
 	case DWC3_GCTL_PRTCAP_HOST:
@@ -2225,7 +2240,7 @@ static int dwc3_resume_common(struct dwc
 			ret = dwc3_core_init_for_resume(dwc);
 			if (ret)
 				return ret;
-			dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_HOST);
+			dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_HOST, true);
 			break;
 		}
 		/* Restore GUSB2PHYCFG bits that were modified in suspend */
@@ -2250,7 +2265,7 @@ static int dwc3_resume_common(struct dwc
 		if (ret)
 			return ret;
 
-		dwc3_set_prtcap(dwc, dwc->current_dr_role);
+		dwc3_set_prtcap(dwc, dwc->current_dr_role, true);
 
 		dwc3_otg_init(dwc);
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_HOST) {
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1517,7 +1517,7 @@ struct dwc3_gadget_ep_cmd_params {
 #define DWC3_HAS_OTG			BIT(3)
 
 /* prototypes */
-void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode);
+void dwc3_set_prtcap(struct dwc3 *dwc, u32 mode, bool ignore_susphy);
 void dwc3_set_mode(struct dwc3 *dwc, u32 mode);
 u32 dwc3_core_fifo_space(struct dwc3_ep *dep, u8 type);
 
--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -173,7 +173,7 @@ void dwc3_otg_init(struct dwc3 *dwc)
 	 * block "Initialize GCTL for OTG operation".
 	 */
 	/* GCTL.PrtCapDir=2'b11 */
-	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_OTG);
+	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_OTG, true);
 	/* GUSB2PHYCFG0.SusPHY=0 */
 	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 	reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
@@ -553,7 +553,7 @@ int dwc3_drd_init(struct dwc3 *dwc)
 
 		dwc3_drd_update(dwc);
 	} else {
-		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_OTG);
+		dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_OTG, true);
 
 		/* use OTG block to get ID event */
 		irq = dwc3_otg_get_irq(dwc);


