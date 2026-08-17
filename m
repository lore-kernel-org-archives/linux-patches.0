Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D796C404BFD;
	Mon, 17 Aug 2026 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975537; cv=none; b=q2F/ACiQepZXsIbzqVX1Eff9FxE2KyIpuZ540g4ZeaSZGx4o6DfVkFQ8GSooRMwAeb2KufDmi3ihIYpzUp8gTi52JL5vkkhlwXeK56RTZQInsr0bU9dLSJkEJya4jfXIwU+6Cw88k5Ig3ZuMr9eumpW2ckm4f8P0lTetoJczDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975537; c=relaxed/simple;
	bh=4mk8U6KWxNMTAPQmAcSeFWLF8Ai7b0fEkqR3I4z+cXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwt4Be0AXsFyTW7apx6SjMDTnDzHaqCZStNKWA/MXGblG26dni/li0JnVmpB12RZtzn0fcogfXEWgVS+Fre3UFt3ejp4P7+eK2izdOGqT5CMQjg+b8esnAUC0XccCshZGS98ruX+qwYDfBlX5WzACTNKsH8zwqh0UPDFU4Cf1qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFT/UsTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFT/UsTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DFE1F000E9;
	Mon, 17 Aug 2026 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975535;
	bh=YbIwRtl938j8+DRa2pzwwhhS2VB99vgN7bQYznVSir4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFT/UsTSEljEhPTV/G9u2suvAjlpcVa7nAdsvgQ0kkIRR7eTDsAd5lRT4atIzIi8I
	 KQPmr6qkP+nsbxCbqWrKAtt7n0R8spSJSMkxpXFb3pGnqHm2me/vPmneiYJ2kBgr+5
	 /ypfQJVp4MjGzW4ZuiTaQHSixuBP/RlDhMFvlW/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xincheng Zhang <zhangxincheng@ultrarisc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/389] usb: xhci-pci: Limit VIA VL805 DMA addressing to 36 bits
Date: Mon, 17 Aug 2026 15:28:19 +0200
Message-ID: <20260817132541.422106185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

Cc: stable <stable@kernel.org>
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
index 2be84d5e9261da..6e87f36afb49c4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -302,6 +302,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_TRB_OVERFETCH;
 		xhci->quirks |= XHCI_EP_CTX_BROKEN_DCS;
+		xhci->dma_mask_bits = 36;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 03de77fbe3af34..2cc27dba08e2d6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5323,6 +5323,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	if (xhci->hci_version > 0x100)
 		xhci->hcc_params2 = readl(&xhci->cap_regs->hcc_params2);
 
+	xhci->dma_mask_bits = 64;
 	xhci->quirks |= quirks;
 
 	get_quirks(dev, xhci);
@@ -5358,12 +5359,16 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
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
index 4d4ac8ec614b20..8d1c6c59e9e927 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1782,6 +1782,7 @@ struct xhci_hcd {
 	int		event_ring_max;
 	/* 4KB min, 128MB max */
 	int		page_size;
+	unsigned int	dma_mask_bits;
 	/* Valid values are 12 to 20, inclusive */
 	int		page_shift;
 	/* msi-x vectors */
-- 
2.53.0



