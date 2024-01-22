Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF5064CF2;
	Tue, 23 Jan 2024 00:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971542; cv=none; b=XgKPXPrDxzLXAKGAMOFVkiClTdNTq4r27+vpWyzSpMylD8eNrzPbWhsNc+4ylqbqyXgietnOSJNgeBA88Zh0ywM0uVjNGl9crFLcJr3fdzfF538TStLCXP8Rct7c9Evzs4L3vhEScE/mvCPpTpcD6M/sWhphKXFO/xb0O61uq08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971542; c=relaxed/simple;
	bh=+dwElK6Oqfnped7dq9+3yqcgK/wURlaIzxMGhP7jjq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnxF1B6cwDRxAtUwfw90fFT3VGqY38C3cv8hgNPB6puVO2VEn5wzniW1IrDy9hTKp24SI6Rm80hP216tWSi5SRH182rFxr8Bfk1cOBaOQC3AQzowRQGf3op5dIu/mXePQKVjitcXTTtiFUuW63rWQCR1mUa8Bc6MIwwcEk2uLb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RI1fpr9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RI1fpr9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4181FC433F1;
	Tue, 23 Jan 2024 00:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971542;
	bh=+dwElK6Oqfnped7dq9+3yqcgK/wURlaIzxMGhP7jjq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI1fpr9JEovs3L+iQbrMBtsCaM2NtFi9x8a7tVaGwpA86nzmeXyzG78LHEEEQTIA/
	 MWXMNJDa8b8pAiJw6K9ESO+BeL2qKG69QtfwGQHRQyke9bT1I4vdkFnk6VO4BGgVym
	 ORjaqSZ1X4r3rU5CSoz86fzftBFCCoHnSquL2OHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 261/417] Revert "usb: dwc3: Soft reset phy on probe for host"
Date: Mon, 22 Jan 2024 15:57:09 -0800
Message-ID: <20240122235800.909867618@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 7059fbebcb00554c3f31e5b5d93ef6d2d96dc7b4 upstream.

This reverts commit 8bea147dfdf823eaa8d3baeccc7aeb041b41944b.

The phy soft reset GUSB2PHYCFG.PHYSOFTRST only applies to UTMI phy, not
ULPI. This fix is incomplete.

Cc:  <stable@vger.kernel.org>
Fixes: 8bea147dfdf8 ("usb: dwc3: Soft reset phy on probe for host")
Reported-by: Köry Maincent <kory.maincent@bootlin.com>
Closes: https://lore.kernel.org/linux-usb/20231205151959.5236c231@kmaincent-XPS-13-7390
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/29a26593a60eba727de872a3e580a674807b3339.1703282469.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -279,46 +279,9 @@ int dwc3_core_soft_reset(struct dwc3 *dw
 	 * XHCI driver will reset the host block. If dwc3 was configured for
 	 * host-only mode or current role is host, then we can return early.
 	 */
-	if (dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
+	if (dwc->dr_mode == USB_DR_MODE_HOST || dwc->current_dr_role == DWC3_GCTL_PRTCAP_HOST)
 		return 0;
 
-	/*
-	 * If the dr_mode is host and the dwc->current_dr_role is not the
-	 * corresponding DWC3_GCTL_PRTCAP_HOST, then the dwc3_core_init_mode
-	 * isn't executed yet. Ensure the phy is ready before the controller
-	 * updates the GCTL.PRTCAPDIR or other settings by soft-resetting
-	 * the phy.
-	 *
-	 * Note: GUSB3PIPECTL[n] and GUSB2PHYCFG[n] are port settings where n
-	 * is port index. If this is a multiport host, then we need to reset
-	 * all active ports.
-	 */
-	if (dwc->dr_mode == USB_DR_MODE_HOST) {
-		u32 usb3_port;
-		u32 usb2_port;
-
-		usb3_port = dwc3_readl(dwc->regs, DWC3_GUSB3PIPECTL(0));
-		usb3_port |= DWC3_GUSB3PIPECTL_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
-
-		usb2_port = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-		usb2_port |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
-
-		/* Small delay for phy reset assertion */
-		usleep_range(1000, 2000);
-
-		usb3_port &= ~DWC3_GUSB3PIPECTL_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB3PIPECTL(0), usb3_port);
-
-		usb2_port &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), usb2_port);
-
-		/* Wait for clock synchronization */
-		msleep(50);
-		return 0;
-	}
-
 	reg = dwc3_readl(dwc->regs, DWC3_DCTL);
 	reg |= DWC3_DCTL_CSFTRST;
 	reg &= ~DWC3_DCTL_RUN_STOP;


