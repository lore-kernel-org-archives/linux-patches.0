Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810BC1CAA68;
	Wed, 19 Feb 2025 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954907; cv=none; b=JGdAa0UFz8sfsO7EMReKjDA24CJ84rw2/C1eFoK+K39EVwWIRhyqyYW8XrD/jvlPtlAp0d77BA39dqxsuHpj8tSAUmOrMF5HjVb2ogFx6BJMVKmOUEC1AJdzVhGZAYPYvyqVbxzPAag2O+F168knn1dvCzMBe2z+qay02/eHpMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954907; c=relaxed/simple;
	bh=7tZtrfzqq0ZC6OOwKJKNV16KgcZCnbwYD6bR80oJvF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psgOCXQ9aGqTrBkwUND9EfEtCXbnsMX30p9MhtbZ9J7C9scA7McMFKakcBOC8YuKnEyLnd1qaL3cAGfSE/uyono2GuQEQulIzu3Z2FflRm/30AOQEv6lzWmeVX08DdFLe+pBBow8zR4iLxPaSxrwar5bfXHGh39+NAKIZZWErYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYKqB3Hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYKqB3Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE15C4CED1;
	Wed, 19 Feb 2025 08:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954907;
	bh=7tZtrfzqq0ZC6OOwKJKNV16KgcZCnbwYD6bR80oJvF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYKqB3HqDcLGlMjRFlM2LMBEvIBGcxv9pGFaAdGHnhxfnzBsUaWd/mbGrtPk+U+dN
	 K8RLkFT1A0HsTKbiBantffd3WZAvCO8KLzUe3Su/ZzlpKEzfYmBlzqSOHVpxNZYK2B
	 N1SBtxY4N+qugMcZ/zZZHs5HI/RnCV0yP0FU+gFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Babu Saladi <Saladi.Rakeshbabu@microchip.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/230] PCI: switchtec: Add Microchip PCI100X device IDs
Date: Wed, 19 Feb 2025 09:26:30 +0100
Message-ID: <20250219082604.563282082@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Rakesh Babu Saladi <Saladi.Rakeshbabu@microchip.com>

[ Upstream commit a3282f84b2151d254dc4abf24d1255c6382be774 ]

Add Microchip parts to the Device ID table so the driver supports PCI100x
devices.

Add a new macro to quirk the Microchip Switchtec PCI100x parts to allow DMA
access via NTB to work when the IOMMU is turned on.

PCI100x family has 6 variants; each variant is designed for different
application usages, different port counts and lane counts:

  PCI1001 has 1 x4 upstream port and 3 x4 downstream ports
  PCI1002 has 1 x4 upstream port and 4 x2 downstream ports
  PCI1003 has 2 x4 upstream ports, 2 x2 upstream ports, and 2 x2
    downstream ports
  PCI1004 has 4 x4 upstream ports
  PCI1005 has 1 x4 upstream port and 6 x2 downstream ports
  PCI1006 has 6 x2 upstream ports and 2 x2 downstream ports

[Historical note: these parts use PCI_VENDOR_ID_EFAR (0x1055), from EFAR
Microsystems, which was acquired in 1996 by Standard Microsystems Corp,
which was acquired by Microchip Technology in 2012.  The PCI-SIG confirms
that Vendor ID 0x1055 is assigned to Microchip even though it's not
visible via https://pcisig.com/membership/member-companies]

Link: https://lore.kernel.org/r/20250120095524.243103-1-Saladi.Rakeshbabu@microchip.com
Signed-off-by: Rakesh Babu Saladi <Saladi.Rakeshbabu@microchip.com>
[bhelgaas: Vendor ID history]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-By: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c           | 11 +++++++++++
 drivers/pci/switch/switchtec.c | 26 ++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 11fe6869ec3ab..af6cfd88f4b64 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5985,6 +5985,17 @@ SWITCHTEC_QUIRK(0x5552);  /* PAXA 52XG5 */
 SWITCHTEC_QUIRK(0x5536);  /* PAXA 36XG5 */
 SWITCHTEC_QUIRK(0x5528);  /* PAXA 28XG5 */
 
+#define SWITCHTEC_PCI100X_QUIRK(vid) \
+	DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_EFAR, vid, \
+		PCI_CLASS_BRIDGE_OTHER, 8, quirk_switchtec_ntb_dma_alias)
+SWITCHTEC_PCI100X_QUIRK(0x1001);  /* PCI1001XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1002);  /* PCI1002XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+
+
 /*
  * The PLX NTB uses devfn proxy IDs to move TLPs between NT endpoints.
  * These IDs are used to forward responses to the originator on the other
diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index c7e1089ffdafc..b14dfab04d846 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1739,6 +1739,26 @@ static void switchtec_pci_remove(struct pci_dev *pdev)
 		.driver_data = gen, \
 	}
 
+#define SWITCHTEC_PCI100X_DEVICE(device_id, gen) \
+	{ \
+		.vendor     = PCI_VENDOR_ID_EFAR, \
+		.device     = device_id, \
+		.subvendor  = PCI_ANY_ID, \
+		.subdevice  = PCI_ANY_ID, \
+		.class      = (PCI_CLASS_MEMORY_OTHER << 8), \
+		.class_mask = 0xFFFFFFFF, \
+		.driver_data = gen, \
+	}, \
+	{ \
+		.vendor     = PCI_VENDOR_ID_EFAR, \
+		.device     = device_id, \
+		.subvendor  = PCI_ANY_ID, \
+		.subdevice  = PCI_ANY_ID, \
+		.class      = (PCI_CLASS_BRIDGE_OTHER << 8), \
+		.class_mask = 0xFFFFFFFF, \
+		.driver_data = gen, \
+	}
+
 static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI_DEVICE(0x8531, SWITCHTEC_GEN3),  /* PFX 24xG3 */
 	SWITCHTEC_PCI_DEVICE(0x8532, SWITCHTEC_GEN3),  /* PFX 32xG3 */
@@ -1833,6 +1853,12 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI_DEVICE(0x5552, SWITCHTEC_GEN5),  /* PAXA 52XG5 */
 	SWITCHTEC_PCI_DEVICE(0x5536, SWITCHTEC_GEN5),  /* PAXA 36XG5 */
 	SWITCHTEC_PCI_DEVICE(0x5528, SWITCHTEC_GEN5),  /* PAXA 28XG5 */
+	SWITCHTEC_PCI100X_DEVICE(0x1001, SWITCHTEC_GEN4),  /* PCI1001 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1002, SWITCHTEC_GEN4),  /* PCI1002 12XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1003, SWITCHTEC_GEN4),  /* PCI1003 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.39.5



