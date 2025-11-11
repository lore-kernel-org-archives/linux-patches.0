Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652E327D786;
	Tue, 11 Nov 2025 01:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824853; cv=none; b=Uw7cG6zlzJSfgMeWSWu4LnAT8LD8XTTnuznUqEtYQMb9XiSto4rFpGYCcVQiqSzIbH/PFS0zOyC5yl05ZNPaUjN870SQe7DwBxdKQme5diIXDScqK/b45++wPTij2JNrX4pSDlpxGRdRGXmKPinmuAfuGUCl30yUFhiNr9AtzeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824853; c=relaxed/simple;
	bh=mmz9loR48Y1ezoV67N8UpCDRx7yjlSKbSiaq6OCsGVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP0Va44xmm359BBoQHso3vn3J+pGrH7ljFZpo+C6RoJgMzAvK3EUVTUEIgHi0rkUA316z0eI3yOZP8eaPxIrkOim/HQeSpp54rWZnuP9DtzT1nLzLQOul0ptobUK/UiWQy51qQV9TJhWqhWFBIVHW0DzHSuOXEVDGZQw3QLyMBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axZ1YLVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axZ1YLVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DE6C16AAE;
	Tue, 11 Nov 2025 01:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824853;
	bh=mmz9loR48Y1ezoV67N8UpCDRx7yjlSKbSiaq6OCsGVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axZ1YLVa0kg4Wm8ZcoBa6QI3r4HM40BY4NlvQSe6Dx7QgrkBIaEswRd12u8hqxXY+
	 R6yZyJUoJWr5BlajGJipq7qpfkj3ZoCoxp4iBSTZZXyv7q4IMR19h2llDmXEhLSCNl
	 PYZW77L3CAR8Nz+/6S7JRZ7XQhE0jhDq7I3BTcMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Nielsen <nick.kainielsen@free.fr>,
	grm1 <grm1@mailbox.org>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 585/849] usb: xhci-pci: add support for hosts with zero USB3 ports
Date: Tue, 11 Nov 2025 09:42:35 +0900
Message-ID: <20251111004550.563791234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 719de070f764e079cdcb4ddeeb5b19b3ddddf9c1 ]

Add xhci support for PCI hosts that have zero USB3 ports.
Avoid creating a shared Host Controller Driver (HCD) when there is only
one root hub. Additionally, all references to 'xhci->shared_hcd' are now
checked before use.

Only xhci-pci.c requires modification to accommodate this change, as the
xhci core already supports configurations with zero USB3 ports. This
capability was introduced when xHCI Platform and MediaTek added support
for zero USB3 ports.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220181
Tested-by: Nick Nielsen <nick.kainielsen@free.fr>
Tested-by: grm1 <grm1@mailbox.org>
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250917210726.97100-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 42 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 00fac8b233d2a..5c8ab519f497d 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -610,7 +610,7 @@ int xhci_pci_common_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int retval;
 	struct xhci_hcd *xhci;
-	struct usb_hcd *hcd;
+	struct usb_hcd *hcd, *usb3_hcd;
 	struct reset_control *reset;
 
 	reset = devm_reset_control_get_optional_exclusive(&dev->dev, NULL);
@@ -636,26 +636,32 @@ int xhci_pci_common_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	hcd = dev_get_drvdata(&dev->dev);
 	xhci = hcd_to_xhci(hcd);
 	xhci->reset = reset;
-	xhci->shared_hcd = usb_create_shared_hcd(&xhci_pci_hc_driver, &dev->dev,
-						 pci_name(dev), hcd);
-	if (!xhci->shared_hcd) {
-		retval = -ENOMEM;
-		goto dealloc_usb2_hcd;
-	}
 
-	retval = xhci_ext_cap_init(xhci);
-	if (retval)
-		goto put_usb3_hcd;
+	xhci->allow_single_roothub = 1;
+	if (!xhci_has_one_roothub(xhci)) {
+		xhci->shared_hcd = usb_create_shared_hcd(&xhci_pci_hc_driver, &dev->dev,
+							 pci_name(dev), hcd);
+		if (!xhci->shared_hcd) {
+			retval = -ENOMEM;
+			goto dealloc_usb2_hcd;
+		}
 
-	retval = usb_add_hcd(xhci->shared_hcd, dev->irq,
-			IRQF_SHARED);
-	if (retval)
-		goto put_usb3_hcd;
-	/* Roothub already marked as USB 3.0 speed */
+		retval = xhci_ext_cap_init(xhci);
+		if (retval)
+			goto put_usb3_hcd;
+
+		retval = usb_add_hcd(xhci->shared_hcd, dev->irq, IRQF_SHARED);
+		if (retval)
+			goto put_usb3_hcd;
+	} else {
+		retval = xhci_ext_cap_init(xhci);
+		if (retval)
+			goto dealloc_usb2_hcd;
+	}
 
-	if (!(xhci->quirks & XHCI_BROKEN_STREAMS) &&
-			HCC_MAX_PSA(xhci->hcc_params) >= 4)
-		xhci->shared_hcd->can_do_streams = 1;
+	usb3_hcd = xhci_get_usb3_hcd(xhci);
+	if (usb3_hcd && !(xhci->quirks & XHCI_BROKEN_STREAMS) && HCC_MAX_PSA(xhci->hcc_params) >= 4)
+		usb3_hcd->can_do_streams = 1;
 
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
 	pm_runtime_put_noidle(&dev->dev);
-- 
2.51.0



