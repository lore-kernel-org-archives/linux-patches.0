Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1157720316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/ffQsh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8ACC433C7;
	Mon,  6 Nov 2023 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276446;
	bh=zdwnElSbor4xxUng/AvhN4fwig49rGco2Y0yxndh40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/ffQsh8Qpa3iB1mFOMQ3GGanB1T7amj/ftYLdQYjcu89QFbJeNDSXsTsHGYZY5z7
	 drXdL0i5PMB18XioUkdqFYR4/cMK8O0jNx8JQdMMhnCKFbWgW2oMaANBJE2lklu5Ia
	 x7X2xgIu2PXOksp7v7qi5J+6VUcKw2pjIUlR6MB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 46/62] PCI: Prevent xHCI driver from claiming AMD VanGogh USB3 DRD device
Date: Mon,  6 Nov 2023 14:03:52 +0100
Message-ID: <20231106130303.449118923@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

commit 7e6f3b6d2c352b5fde37ce3fed83bdf6172eebd4 upstream.

The AMD VanGogh SoC contains a DesignWare USB3 Dual-Role Device that can be
operated as either a USB Host or a USB Device, similar to on the AMD Nolan
platform.

be6646bfbaec ("PCI: Prevent xHCI driver from claiming AMD Nolan USB3 DRD
device") added a quirk to let the dwc3 driver claim the Nolan device since
it provides more specific support.

Extend that quirk to include the VanGogh SoC USB3 device.

Link: https://lore.kernel.org/r/20230927202212.2388216-1-vi@endrift.com
Signed-off-by: Vicki Pfau <vi@endrift.com>
[bhelgaas: include be6646bfbaec reference, add stable tag]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v3.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c    |    8 +++++---
 include/linux/pci_ids.h |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -595,7 +595,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 /*
  * In the AMD NL platform, this device ([1022:7912]) has a class code of
  * PCI_CLASS_SERIAL_USB_XHCI (0x0c0330), which means the xhci driver will
- * claim it.
+ * claim it. The same applies on the VanGogh platform device ([1022:163a]).
  *
  * But the dwc3 driver is a more specific driver for this device, and we'd
  * prefer to use it instead of xhci. To prevent xhci from claiming the
@@ -603,7 +603,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
  * defines as "USB device (not host controller)". The dwc3 driver can then
  * claim it based on its Vendor and Device ID.
  */
-static void quirk_amd_nl_class(struct pci_dev *pdev)
+static void quirk_amd_dwc_class(struct pci_dev *pdev)
 {
 	u32 class = pdev->class;
 
@@ -613,7 +613,9 @@ static void quirk_amd_nl_class(struct pc
 		 class, pdev->class);
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_NL_USB,
-		quirk_amd_nl_class);
+		quirk_amd_dwc_class);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_VANGOGH_USB,
+		quirk_amd_dwc_class);
 
 /*
  * Synopsys USB 3.x host HAPS platform has a class code of
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -568,6 +568,7 @@
 #define PCI_DEVICE_ID_AMD_19H_M60H_DF_F3 0x14e3
 #define PCI_DEVICE_ID_AMD_19H_M70H_DF_F3 0x14f3
 #define PCI_DEVICE_ID_AMD_19H_M78H_DF_F3 0x12fb
+#define PCI_DEVICE_ID_AMD_VANGOGH_USB	0x163a
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001


