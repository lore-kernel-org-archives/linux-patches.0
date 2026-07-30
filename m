Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088F38DC46;
	Thu, 30 Jul 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427282; cv=none; b=pAcUKmb3gp2nkDcz8HggmQ6yaUUI0Ois5px99Q1xGR2O8cp/jl9+wsOYHGB3iytwqEJR83vw5IxMpWs1KuMdm3vSd3KL666WlLbH1J0VLyEu+2KTM2FdSofny2e6nHZiV/d+g7Cz5bI8PNybsH4WDtHRHAYl/0DEvR9JBNwz8yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427282; c=relaxed/simple;
	bh=noPyyLQiy8LJTgbEDGoVCrqFDM8QtA85VnIkhVl9qfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OineaW9+tcXxEm18tyTltZ9MK0bS0Bq9wmIzG232Dk8ag1EB07ooHZbCSXz/nRlAX/2RBgU8jrQssgi1k5VQ+f5y0g81rfIIsyEvxXwA0j/r96zLV6IfOONv5W6F88HApW3PLxolJ0ldM5vyvdDAnZhXcIaCiIBMaZJhffLmrfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kF9vj/I1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kF9vj/I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAF61F000E9;
	Thu, 30 Jul 2026 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427280;
	bh=pNdti0x9aac7/KUDmBFQrAT1HiWSIj14iGGXdlyuokQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kF9vj/I15xh90KSNWgSqYEo+/9yssvyfk1ldTKxdHTLQZv8bTaqPA3vxTLscTp7ky
	 ExMBrp7e9DCPrH2Mv1uFK1EN4yILperXdI3VLhDONSK66Lt1jO+rShsvZLB2tucb+M
	 FyHPFZSJfI7WaBUPiSJtNwtnF22qNVa+6eCvcECw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xincheng Zhang <zhangxincheng@ultrarisc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/484] usb: xhci-pci: Limit VIA VL805 DMA addressing to 36 bits
Date: Thu, 30 Jul 2026 16:10:11 +0200
Message-ID: <20260730141425.940521689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xincheng Zhang <zhangxincheng@ultrarisc.com>

commit 1fc50f1ecde39feb4fccdaf4bc71aa6c0eb25c49 upstream.

The VIA VL805/806 xHCI controller advertises AC64, but fails to handle
DMA addresses at or above 0x1000000000. On systems with large amounts of
RAM, this can cause USB device failures when the controller is given DMA
addresses beyond its usable address width.

Do not use XHCI_NO_64BIT_SUPPORT for this controller. That quirk clears
the cached AC64 capability and limits DMA to 32 bits, causing unnecessary
bouncing for addresses between 4GiB and 64GiB and hiding the controller's
real AC64 capability from code that may need to distinguish register
access width from usable DMA address width.

Track the usable DMA address width separately from the AC64 capability.
Initialize the generic xhci->dma_mask_bits field to 64 and let PCI quirks
reduce it for controllers with narrower DMA support. Set VIA VL805/806 to
36 bits so the DMA API only hands it addresses in the range it can handle
while keeping HCCPARAMS1.AC64 visible.

Cc: stable@kernel.org
Signed-off-by: Xincheng Zhang <zhangxincheng@ultrarisc.com>
Link: https://patch.msgid.link/20260630-xhci-via-dma-fix-v3-1-690dcb8cf75a@ultrarisc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c |  1 +
 drivers/usb/host/xhci.c     | 15 ++++++++++-----
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5abc48f148dcbc..d5ba5a34625bef 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -510,6 +510,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == PCI_DEVICE_ID_VIA_VL805) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_TRB_OVERFETCH;
+		xhci->dma_mask_bits = 36;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 31509845594e9f..210b5727d1a632 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5267,6 +5267,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	if (xhci->hci_version > 0x100)
 		xhci->hcc_params2 = readl(&xhci->cap_regs->hcc_params2);
 
+	xhci->dma_mask_bits = 64;
 	/* xhci-plat or xhci-pci might have set max_interrupters already */
 	if ((!xhci->max_interrupters) ||
 	    xhci->max_interrupters > HCS_MAX_INTRS(xhci->hcs_params1))
@@ -5308,12 +5309,16 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	if (xhci->quirks & XHCI_NO_64BIT_SUPPORT)
 		xhci->hcc_params &= ~BIT(0);
 
-	/* Set dma_mask and coherent_dma_mask to 64-bits,
-	 * if xHC supports 64-bit addressing */
+	/*
+	 * Set dma_mask and coherent_dma_mask to 64-bits if xHC supports
+	 * 64-bit addressing, unless a controller-specific quirk callback
+	 * limits the usable address width.
+	 */
 	if (HCC_64BIT_ADDR(xhci->hcc_params) &&
-			!dma_set_mask(dev, DMA_BIT_MASK(64))) {
-		xhci_dbg(xhci, "Enabling 64-bit DMA addresses.\n");
-		dma_set_coherent_mask(dev, DMA_BIT_MASK(64));
+	    !dma_set_mask(dev, DMA_BIT_MASK(xhci->dma_mask_bits))) {
+		xhci_dbg(xhci, "Enabling %u-bit DMA addresses.\n",
+			 xhci->dma_mask_bits);
+		dma_set_coherent_mask(dev, DMA_BIT_MASK(xhci->dma_mask_bits));
 	} else {
 		/*
 		 * This is to avoid error in cases where a 32-bit USB
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 849a83e4013cca..bb7e73df297abc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1538,6 +1538,7 @@ struct xhci_hcd {
 	int		event_ring_max;
 	/* 4KB min, 128MB max */
 	int		page_size;
+	unsigned int	dma_mask_bits;
 	/* Valid values are 12 to 20, inclusive */
 	int		page_shift;
 	/* msi-x vectors */
-- 
2.53.0



