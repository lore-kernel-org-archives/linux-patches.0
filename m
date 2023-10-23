Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE49914AA3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXvReyDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298F6C433C7;
	Mon, 23 Oct 2023 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059701;
	bh=7enSTrMjs3o9oDo890htzwLxM7ysNJQoY6yirrjEeAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXvReyDLNqLALETPTh8ps2j4xw87Q1LQDpLPTUCmj+Hbi09PbWKMZVySldeT/Y9nE
	 BIbCpwo3nUe/DYYHhDCh0O/9r7FqMu5R2LThng/N0LvqtmK8Wg6ohPBKm06Cjgcr1Y
	 PKTOk0uZ03ccAikERvcBZA26e8/W04z/TGMhiwEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenta Sato <tosainu.maple@gmail.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 4.19 23/98] usb: dwc3: Soft reset phy on probe for host
Date: Mon, 23 Oct 2023 12:56:12 +0200
Message-ID: <20231023104814.407011568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,9 +244,46 @@ static int dwc3_core_soft_reset(struct d
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
 	dwc3_writel(dwc->regs, DWC3_DCTL, reg);


