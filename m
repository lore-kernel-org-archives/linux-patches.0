Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F0F2B9A5;
	Tue, 22 Jul 2025 13:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192704; cv=none; b=OVQklEkvV3sjEAMJTq+VzO6NUb6ut885x0rXv7wDzT3/DDHtsAp71fa1kJV+5FjNb7R69QJ7eeC0TKZ9xIKV/5Bx+BH8BJPr21z9YvnmzFhgjv7pdLh+rDIkO+n5IjeHzSexAQOdt9yJ07XI3sr4bhxkeP8VYcvGBk3dvHKMRQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192704; c=relaxed/simple;
	bh=tg/nISB6nLBSmjO5y7fNJtdR55+bp+kX9FB1wZqKEn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwCsEqelii2PkxfxC3Pa4QWRvvY5te+0xLU5Va+CN7sAcihEgrXRP3PvGA0iiP7TWwAny3bcGlzab1VXmu5Te0WUndUueM3Mr39DefvrjTH1Szuxt6dY2zUtwdlHt84/7tm4WuQjm0QMbxfo/ipsnt75Vyoy5GlK9lkMmivFQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT8Hbr5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT8Hbr5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CC3C4CEEB;
	Tue, 22 Jul 2025 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192704;
	bh=tg/nISB6nLBSmjO5y7fNJtdR55+bp+kX9FB1wZqKEn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT8Hbr5kV/LmeoXRtFDQu80T2bb//hAkif9apK3n1JDCRjC1F9rqDh0rwuJrmF8Ep
	 DpAgbpZMSAdUidiQ7d36c0g29fwXvw2B7h6UZ3BW0LduDuFF3/srtvknbxPtY66EDf
	 V6bTC3MUTEwOLVMTDlSoBRxGCkzqAB4lI2sarJSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.12 008/158] usb: dwc2: gadget: Fix enter to hibernation for UTMI+ PHY
Date: Tue, 22 Jul 2025 15:43:12 +0200
Message-ID: <20250722134341.045643474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 5724ff190b22bd04fcfd7287a39c6e5494e40f0b upstream.

For UTMI+ PHY, according to programming guide, first should be set
PMUACTV bit then STOPPCLK bit. Otherwise, when the device issues
Remote Wakeup, then host notices disconnect instead.
For ULPI PHY, above mentioned bits must be set in reversed order:
STOPPCLK then PMUACTV.

Fixes: 4483ef3c1685 ("usb: dwc2: Add hibernation updates for ULPI PHY")
Cc: stable <stable@kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/692110d3c3d9bb2a91cedf24528a7710adc55452.1751881374.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -5352,20 +5352,34 @@ int dwc2_gadget_enter_hibernation(struct
 	if (gusbcfg & GUSBCFG_ULPI_UTMI_SEL) {
 		/* ULPI interface */
 		gpwrdn |= GPWRDN_ULPI_LATCH_EN_DURING_HIB_ENTRY;
-	}
-	dwc2_writel(hsotg, gpwrdn, GPWRDN);
-	udelay(10);
+		dwc2_writel(hsotg, gpwrdn, GPWRDN);
+		udelay(10);
+
+		/* Suspend the Phy Clock */
+		pcgcctl = dwc2_readl(hsotg, PCGCTL);
+		pcgcctl |= PCGCTL_STOPPCLK;
+		dwc2_writel(hsotg, pcgcctl, PCGCTL);
+		udelay(10);
 
-	/* Suspend the Phy Clock */
-	pcgcctl = dwc2_readl(hsotg, PCGCTL);
-	pcgcctl |= PCGCTL_STOPPCLK;
-	dwc2_writel(hsotg, pcgcctl, PCGCTL);
-	udelay(10);
+		gpwrdn = dwc2_readl(hsotg, GPWRDN);
+		gpwrdn |= GPWRDN_PMUACTV;
+		dwc2_writel(hsotg, gpwrdn, GPWRDN);
+		udelay(10);
+	} else {
+		/* UTMI+ Interface */
+		dwc2_writel(hsotg, gpwrdn, GPWRDN);
+		udelay(10);
 
-	gpwrdn = dwc2_readl(hsotg, GPWRDN);
-	gpwrdn |= GPWRDN_PMUACTV;
-	dwc2_writel(hsotg, gpwrdn, GPWRDN);
-	udelay(10);
+		gpwrdn = dwc2_readl(hsotg, GPWRDN);
+		gpwrdn |= GPWRDN_PMUACTV;
+		dwc2_writel(hsotg, gpwrdn, GPWRDN);
+		udelay(10);
+
+		pcgcctl = dwc2_readl(hsotg, PCGCTL);
+		pcgcctl |= PCGCTL_STOPPCLK;
+		dwc2_writel(hsotg, pcgcctl, PCGCTL);
+		udelay(10);
+	}
 
 	/* Set flag to indicate that we are in hibernation */
 	hsotg->hibernated = 1;


