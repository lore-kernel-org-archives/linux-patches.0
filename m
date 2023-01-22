Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C087E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C786C433EF;
	Sun, 22 Jan 2023 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400141;
	bh=QxRuq8zO4+mUgMeIDw3s7YUwKHA3H2WauhIRlxgeSe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ho4ICAyXRXUSANGUPuIf5tOPp7Xdbq9P7yJ9lJ9x678A4ey1HM6w/V4kbpMlFnu/b
	 4j3wxVfKq4UxymqMcl1/YFaOL5FFFbRfiq+xuU0Hpjv5lU0vybBrgeb8513gxR8OUg
	 BN8nunIeNCsKYvEL0WZ146cYG2yuC9JK59jhfXTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 18/55] xhci: Detect lpm incapable xHC USB3 roothub ports from ACPI tables
Date: Sun, 22 Jan 2023 16:04:05 +0100
Message-Id: <20230122150222.997878553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 74622f0a81d0c2bcfc39f9192b788124e8c7f0af upstream.

USB3 ports on xHC hosts may have retimers that cause too long
exit latency to work with native USB3 U1/U2 link power management states.

For now only use usb_acpi_port_lpm_incapable() to evaluate if port lpm
should be disabled while setting up the USB3 roothub.

Other ways to identify lpm incapable ports can be added here later if
ACPI _DSM does not exist.

Limit this to Intel hosts for now, this is to my knowledge only
an Intel issue.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-8-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -339,8 +339,38 @@ static void xhci_pme_acpi_rtd3_enable(st
 				NULL);
 	ACPI_FREE(obj);
 }
+
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev)
+{
+	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct xhci_hub *rhub = &xhci->usb3_rhub;
+	int ret;
+	int i;
+
+	/* This is not the usb3 roothub we are looking for */
+	if (hcd != rhub->hcd)
+		return;
+
+	if (hdev->maxchild > rhub->num_ports) {
+		dev_err(&hdev->dev, "USB3 roothub port number mismatch\n");
+		return;
+	}
+
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_acpi_port_lpm_incapable(hdev, i);
+
+		dev_dbg(&hdev->dev, "port-%d disable U1/U2 _DSM: %d\n", i + 1, ret);
+
+		if (ret >= 0) {
+			rhub->ports[i]->lpm_incapable = ret;
+			continue;
+		}
+	}
+}
+
 #else
 static void xhci_pme_acpi_rtd3_enable(struct pci_dev *dev) { }
+static void xhci_find_lpm_incapable_ports(struct usb_hcd *hcd, struct usb_device *hdev) { }
 #endif /* CONFIG_ACPI */
 
 /* called during probe() after chip reset completes */
@@ -376,6 +406,10 @@ static int xhci_pci_setup(struct usb_hcd
 static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 				      struct usb_tt *tt, gfp_t mem_flags)
 {
+	/* Check if acpi claims some USB3 roothub ports are lpm incapable */
+	if (!hdev->parent)
+		xhci_find_lpm_incapable_ports(hcd, hdev);
+
 	return xhci_update_hub_device(hcd, hdev, tt, mem_flags);
 }
 


