Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137D2EFDAC;
	Tue, 22 Jul 2025 14:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193252; cv=none; b=ihCFlE0dM9QmLuYEQuP8HG+S01QMgz9ORAFfeDqBLB9eXcYsE4wHvjsNq79yus6P7XHmw9cmcdCxjCHhUcKXod2OkU2H9yYlzsUYV7reWwZrUmMi8lff7cgzuzPv1VLaCKAfPYWUUS8E6jRgd3t6ue6ZGlpf6NvH4yVxXES+ykc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193252; c=relaxed/simple;
	bh=/NNk9Dwh37eLcVwUMk1C5+WF1gK4jvYGcaa7nAyvfQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTRxApKaqccG3plba7ZiuiOBEtK3x/PiI/QJb0vWm9q9DCIcQKUiESui5X+KnQo6YcI64ZNemmxrJd+iCC9uQ4yesZMVB3Fu1wSmc3g5H2qmmh+Rs3dozm/b0kXZMcPJxO9pWuQ+qrnfwBga5w43IObNqgrP/H3DT5ut2zxOl54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVbZHVVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVbZHVVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD66FC4CEEB;
	Tue, 22 Jul 2025 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193252;
	bh=/NNk9Dwh37eLcVwUMk1C5+WF1gK4jvYGcaa7nAyvfQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVbZHVVGtIU3NkHu9DE8Ja4yU5LerPKmehZ45WQLh64kUn6bvddnfS+jpDxYsgTIG
	 XSr9y0uaTwVS2Fw719WGnTNe/WRF1UrQ0gctuOKURroYs/5Va/5c0SUCm4CFPJEjaf
	 WQj+wGLwXxDoqUC8PSWeZ3A+Mcgh1Ee+E/SL9fuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.15 008/187] usb: dwc2: gadget: Fix enter to hibernation for UTMI+ PHY
Date: Tue, 22 Jul 2025 15:42:58 +0200
Message-ID: <20250722134346.067410343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5389,20 +5389,34 @@ int dwc2_gadget_enter_hibernation(struct
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


