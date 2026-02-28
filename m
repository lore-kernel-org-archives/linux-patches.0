Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C6B33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300935; cv=none; b=t6nsVWtgTdP34/zAj4UxuvpHY4mU1QbyPyVtjpyGxprIzFrXwO2UUAopHqslIJz3TGGfv8nsVh0XgxgTnobriKDAl2NmqRmaah5P1T7dDlAmzNQFaFNpK0nNR95oyRLuuNJ5elksfMnnRZ+gVZ/SbzZy/EyRjaIp0t1ctjtgyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300935; c=relaxed/simple;
	bh=0CCz9biBOud+8uzG72V1nDJ7Iom/YHhR3IuKnMgsuys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Me1hW7sPtJKcquQHnpt9jHcFXdosuKPM5Sl023mkMk2QwjKyBgPiTvys9fhS83T0SfqMg/VYd6BwpJkN46kdHtvaiTQDJL8VcEAn73xUgt08I8WEaghvQSRi28HPkvaShcq3kQ3WLbPdtylVbyfndk+iOnoutU0txbjMVxfFpWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IhojQ9iV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IhojQ9iV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0483FC116D0;
	Sat, 28 Feb 2026 17:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300935;
	bh=0CCz9biBOud+8uzG72V1nDJ7Iom/YHhR3IuKnMgsuys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhojQ9iVors4VeAGvWai76RXTbjZhwB31OJq84vX6HK0SAQ6HLnDNCWGm7Cs+9gq8
	 GZIsKZe4y0lBRWm88zZ5MPRG4KjZNumflNAwTcbO3upJACN0e7uVN4Wlu0E0//9Ehg
	 tqg50cX8P91RmRKNxVpxjT0EDJ3hUJcvp24yr2VA1tyoQak9NE472aPKYyrJNCxxYc
	 GExfiE2b0ZqLAAk3Iz9IT+63f/JVKY5hhW5Ce6sGgaLFPkaELjs1K1U3Unz6TzsEBE
	 RbDOFRTJHS6+RR3QuC2K6yG/ciUUWY3byfuActgiKxjCkYuSSjz6JgbXSXra6jYb68
	 By+94XAY37CAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tuo Li <islituo@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/752] ACPI: processor: Fix NULL-pointer dereference in acpi_processor_errata_piix4()
Date: Sat, 28 Feb 2026 12:36:06 -0500
Message-ID: <20260228174750.1542406-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit f132e089fe89cadc2098991f0a3cb05c3f824ac6 ]

In acpi_processor_errata_piix4(), the pointer dev is first assigned an IDE
device and then reassigned an ISA device:

  dev = pci_get_subsys(..., PCI_DEVICE_ID_INTEL_82371AB, ...);
  dev = pci_get_subsys(..., PCI_DEVICE_ID_INTEL_82371AB_0, ...);

If the first lookup succeeds but the second fails, dev becomes NULL. This
leads to a potential null-pointer dereference when dev_dbg() is called:

  if (errata.piix4.bmisx)
    dev_dbg(&dev->dev, ...);

To prevent this, use two temporary pointers and retrieve each device
independently, avoiding overwriting dev with a possible NULL value.

Signed-off-by: Tuo Li <islituo@gmail.com>
[ rjw: Subject adjustment, added an empty code line ]
Link: https://patch.msgid.link/20260111163214.202262-1-islituo@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 7ec1dc04fd11b..85096ce7b658b 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -50,6 +50,7 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 {
 	u8 value1 = 0;
 	u8 value2 = 0;
+	struct pci_dev *ide_dev = NULL, *isa_dev = NULL;
 
 
 	if (!dev)
@@ -107,12 +108,12 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 		 * each IDE controller's DMA status to make sure we catch all
 		 * DMA activity.
 		 */
-		dev = pci_get_subsys(PCI_VENDOR_ID_INTEL,
+		ide_dev = pci_get_subsys(PCI_VENDOR_ID_INTEL,
 				     PCI_DEVICE_ID_INTEL_82371AB,
 				     PCI_ANY_ID, PCI_ANY_ID, NULL);
-		if (dev) {
-			errata.piix4.bmisx = pci_resource_start(dev, 4);
-			pci_dev_put(dev);
+		if (ide_dev) {
+			errata.piix4.bmisx = pci_resource_start(ide_dev, 4);
+			pci_dev_put(ide_dev);
 		}
 
 		/*
@@ -124,24 +125,25 @@ static int acpi_processor_errata_piix4(struct pci_dev *dev)
 		 * disable C3 support if this is enabled, as some legacy
 		 * devices won't operate well if fast DMA is disabled.
 		 */
-		dev = pci_get_subsys(PCI_VENDOR_ID_INTEL,
+		isa_dev = pci_get_subsys(PCI_VENDOR_ID_INTEL,
 				     PCI_DEVICE_ID_INTEL_82371AB_0,
 				     PCI_ANY_ID, PCI_ANY_ID, NULL);
-		if (dev) {
-			pci_read_config_byte(dev, 0x76, &value1);
-			pci_read_config_byte(dev, 0x77, &value2);
+		if (isa_dev) {
+			pci_read_config_byte(isa_dev, 0x76, &value1);
+			pci_read_config_byte(isa_dev, 0x77, &value2);
 			if ((value1 & 0x80) || (value2 & 0x80))
 				errata.piix4.fdma = 1;
-			pci_dev_put(dev);
+			pci_dev_put(isa_dev);
 		}
 
 		break;
 	}
 
-	if (errata.piix4.bmisx)
-		dev_dbg(&dev->dev, "Bus master activity detection (BM-IDE) erratum enabled\n");
-	if (errata.piix4.fdma)
-		dev_dbg(&dev->dev, "Type-F DMA livelock erratum (C3 disabled)\n");
+	if (ide_dev)
+		dev_dbg(&ide_dev->dev, "Bus master activity detection (BM-IDE) erratum enabled\n");
+
+	if (isa_dev)
+		dev_dbg(&isa_dev->dev, "Type-F DMA livelock erratum (C3 disabled)\n");
 
 	return 0;
 }
-- 
2.51.0

