Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59A07317E;
	Tue, 23 Jan 2024 02:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975430; cv=none; b=WEhGZyE33U5PG4r2xCT6XnGpqyi2gXHImczPGlDvpraGRf4M5bdQnowGRZB8mIJ4LRjezlzYsMbDsnIpxojNeDgtEsG+2CpmgIzBWvULnCnG3o0WY7YE0nYYKZtlOVdpUagpWOt4e4HOmDQf48VS5tSSeBLT3BNi/lV/zdibv/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975430; c=relaxed/simple;
	bh=Qi/5AQ5ImAwzgVG9vjfY0l4nV3ifvwZiu+DruSd4f2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQbSBO8X35DKSOgwyNYLR3IVybUMGuD5LPLoW33r4yTI5c0IXmXA24ymCxa7vh/rcWq2uhwO0/lca5Iu7PnLBD2iIkjsjNOTw/TNc2lQazbGvNTSWVbcNPaRfikiiHDidCRKi24VN9fRll399TYJWQKXIOL2FbMTSUZBMFUyYLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeLthV4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeLthV4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC712C43399;
	Tue, 23 Jan 2024 02:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975429;
	bh=Qi/5AQ5ImAwzgVG9vjfY0l4nV3ifvwZiu+DruSd4f2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeLthV4bhvRiEfnO3ZDQlse5fakBc7BpZzXorgVGaoR4Bb7E/jo4E/c/JdliS7Mnq
	 B1lh8U4lvDUBmFLxjZrQ9VircP3Kvzrs2I/UUI6y7HnI0pVmq5mKsCgnGLyUM4TwV0
	 OL875UooeUVptf9MX1160vQ72c7yxFnV+NUgRgLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 362/583] Revert "usb: dwc3: Soft reset phy on probe for host"
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235823.098376452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


