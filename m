Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D362AE96;
	Tue, 29 Apr 2025 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949519; cv=none; b=RBdshM/m6ZNsq1u8gIvhBX1aTsvuk/OK/7N+43gIaBqFyGEl1+WjmsF+ynwPWoUQzTT3I7Pf+QbSMP+ZxBZEr2Ujw9jVbF7g/WTM9EoZizZSo5AEI3pt31RKwLDUGNN4TkJziCqtWpsF1YPusXluBYIxntYkFFfs3YvumcReI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949519; c=relaxed/simple;
	bh=l93JLlq/4MOvxyd6rqIiRR/Oo0ok6U92f9X4gZkcGRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF4ci4Y7VXX7tjzOjY+BIOH2Ta6tTCh3/u+Y9Z9jGRdz9zSVY9Rw44OGMWCXxjIsGyH+M0GAVpgaUeKqPT052MmgnvX2BP+rNLs9rb6LejS7xMejBJgAtuagYaNgClQ3bYlRkmYYVast9p+AMJ85tBELSP/7KiRtBtE32fLOu8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj20NRZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj20NRZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C36CC4CEE3;
	Tue, 29 Apr 2025 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949518;
	bh=l93JLlq/4MOvxyd6rqIiRR/Oo0ok6U92f9X4gZkcGRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oj20NRZbhaUraeOV4YcqfYCw1sVKdnpCARAt0ARif5AzjTP484FblPtYd/8/8pbfO
	 6X0WQ91vMuA59Nypkv0nyJxfuu1Fea/tQRj+Fh79oSnxWXrm9v2pIzBIybILsEjxlz
	 Sr3jjpTtreo8/1LOApmJDRVYQot+LZjv4CL3Njg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mingcong Bai <baimingcong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 5.15 314/373] USB: OHCI: Add quirk for LS7A OHCI controller (rev 0x02)
Date: Tue, 29 Apr 2025 18:43:11 +0200
Message-ID: <20250429161136.024137065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit bcb60d438547355b8f9ad48645909139b64d3482 upstream.

The OHCI controller (rev 0x02) under LS7A PCI host has a hardware flaw.
MMIO register with offset 0x60/0x64 is treated as legacy PS2-compatible
keyboard/mouse interface, which confuse the OHCI controller. Since OHCI
only use a 4KB BAR resource indeed, the LS7A OHCI controller's 32KB BAR
is wrapped around (the second 4KB BAR space is the same as the first 4KB
internally). So we can add an 4KB offset (0x1000) to the OHCI registers
(from the PCI BAR resource) as a quirk.

Cc: stable <stable@kernel.org>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Mingcong Bai <baimingcong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250328040059.3672979-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-pci.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -165,6 +165,25 @@ static int ohci_quirk_amd700(struct usb_
 	return 0;
 }
 
+static int ohci_quirk_loongson(struct usb_hcd *hcd)
+{
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
+
+	/*
+	 * Loongson's LS7A OHCI controller (rev 0x02) has a
+	 * flaw. MMIO register with offset 0x60/64 is treated
+	 * as legacy PS2-compatible keyboard/mouse interface.
+	 * Since OHCI only use 4KB BAR resource, LS7A OHCI's
+	 * 32KB BAR is wrapped around (the 2nd 4KB BAR space
+	 * is the same as the 1st 4KB internally). So add 4KB
+	 * offset (0x1000) to the OHCI registers as a quirk.
+	 */
+	if (pdev->revision == 0x2)
+		hcd->regs += SZ_4K;	/* SZ_4K = 0x1000 */
+
+	return 0;
+}
+
 static int ohci_quirk_qemu(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
@@ -225,6 +244,10 @@ static const struct pci_device_id ohci_p
 		.driver_data = (unsigned long)ohci_quirk_amd700,
 	},
 	{
+		PCI_DEVICE(PCI_VENDOR_ID_LOONGSON, 0x7a24),
+		.driver_data = (unsigned long)ohci_quirk_loongson,
+	},
+	{
 		.vendor		= PCI_VENDOR_ID_APPLE,
 		.device		= 0x003f,
 		.subvendor	= PCI_SUBVENDOR_ID_REDHAT_QUMRANET,


