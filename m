Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5EB14288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="daFjZ6e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B3C433C8;
	Mon, 16 Oct 2023 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467849;
	bh=czlzfT4vGBvrQnw0VU2G0re1cbszAGeldy1GksgSN/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daFjZ6e/z8mIdih0komf+KNyA5+aqPpVepBc8uVjwICdBuIQKcWQ9nY2wdldUSE6N
	 DLvb8/3u+3Yt6fyFf+QbLDHPMCJENyF2esVHuCGRkJyomm6TAJj63Wn/x2ZgVAFziL
	 kUQjz0lFmumbQS2ZJ7+zP0EOBWxPwv7hQM2E73GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenta Sato <tosainu.maple@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.5 104/191] usb: dwc3: Soft reset phy on probe for host
Date: Mon, 16 Oct 2023 10:41:29 +0200
Message-ID: <20231016084017.817278581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 8bea147dfdf823eaa8d3baeccc7aeb041b41944b upstream.

When there's phy initialization, we need to initiate a soft-reset
sequence. That's done through USBCMD.HCRST in the xHCI driver and its
initialization, However, the dwc3 driver may modify core configs before
the soft-reset. This may result in some connection instability. So,
ensure the phy is ready before the controller updates the GCTL.PRTCAPDIR
or other settings by issuing phy soft-reset.

Note that some host-mode configurations may not expose device registers
to initiate the controller soft-reset (via DCTL.CoreSftRst). So we reset
through GUSB3PIPECTL and GUSB2PHYCFG instead.

Cc: stable@vger.kernel.org
Fixes: e835c0a4e23c ("usb: dwc3: don't reset device side if dwc3 was configured as host-only")
Reported-by: Kenta Sato <tosainu.maple@gmail.com>
Closes: https://lore.kernel.org/linux-usb/ZPUciRLUcjDywMVS@debian.me/
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Tested-by: Kenta Sato <tosainu.maple@gmail.com>
Link: https://lore.kernel.org/r/70aea513215d273669152696cc02b20ddcdb6f1a.1694564261.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -279,9 +279,46 @@ int dwc3_core_soft_reset(struct dwc3 *dw
 	 * XHCI driver will reset the host block. If dwc3 was configured for
 	 * host-only mode or current role is host, then we can return early.
 	 */
-	if (dwc->dr_mode == USB_DR_MODE_HOST || dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
+	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
 		return 0;
 
+	/*
+	 * If the dr_mode is host and the dwc->current_dr_role is not the
+	 * corresponding DWC3_GCTL_PRTCAP_HOST, then the dwc3_core_init_mode
+	 * isn't executed yet. Ensure the phy is ready before the controller
+	 * updates the GCTL.PRTCAPDIR or other settings by soft-resetting
+	 * the phy.
+	 *
+	 * Note: GUSB3PIPECTL[n] and GUSB2PHYCFG[n] are port settings where n
+	 * is port index. If this is a multiport host, then we need to reset
+	 * all active ports.
+	 */
+	if (dwc->dr_mode == USB_DR_MODE_HOST) {
+		u32 usb3_port;
+		u32 usb2_port;
+
+		usb3_port = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
+		usb3_port |= DWC3_GUSB3PIPECTL_PHYSOFTRST;
+		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
+
+		usb2_port = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+		usb2_port |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
+		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
+
+		/* Small delay for phy reset assertion */
+		usleep_range(1000, 2000);
+
+		usb3_port &= ~DWC3_GUSB3PIPECTL_PHYSOFTRST;
+		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
+
+		usb2_port &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
+		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
+
+		/* Wait for clock synchronization */
+		msleep(50);
+		return 0;
+	}
+
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
 	reg &= ~DWC3_DCTL_RUN_STOP;


