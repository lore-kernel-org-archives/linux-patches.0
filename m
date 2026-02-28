Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47FE2C21F8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302142; cv=none; b=CFCMw2j4xBRr2kyNBmuQ7Nkn4QF8P1ZRNVbItO/nr/9gRgxnKqYkqU5yIt6kf3XjRcA1SK6DXdAUi7w/zOmbvL9z4GPKdKNQuA2cx2VN9G1cXIQi3jC5ydqs8Dpk+tTEx520EN9Av2TWqC5h1mwCdx1yZ2xtH7HH9OqaGM7JBo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302142; c=relaxed/simple;
	bh=u8VoxGaXNFIpNxyKxxA/hxdETiHnRlqT6INe15CIwCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwAGfwM1A6t7BwF/sVwR2GiveRkBETOY1mONHIOYpzO18NKh6rpADpTRzOIwX7IzCtxN1pZl4Yj/5yxbZGLtrEAvU+eEIXgYuZ0QV9iMW2nBElOJFXzmySdPuZtIZCKbHZ05hwINknykxK+TOSukGcdFZm6wgx8IkoFP7t5edsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrEvvoj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrEvvoj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33881C116D0;
	Sat, 28 Feb 2026 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302142;
	bh=u8VoxGaXNFIpNxyKxxA/hxdETiHnRlqT6INe15CIwCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrEvvoj1ZT9JpJLIRq3Wf2t+I+MtZbWVpN+wj/GtKVthTOFkeF4rFZYYQbe3ivzuL
	 p9ItOULiZttMJk0A0gVX4xQFvdMvjbN/LGaXhJ4vKosxdjv36mUeuUbCA16MpVrgXu
	 5z34XsVNFA0TCtgrrW0+xRYaYuL7sPGhbiNPfO/qP/cmcBbf8hgV1MEwnQazfyYY8E
	 j1TZ6UBmQIn6iVTj02KkJG2C3NyiKi9dMXhxhQxghdkqWZUvoGFZ0+l1DVcxgjlbfX
	 XECIDThaxnAukrrEIopGlVgDNOxdFNZcrUm/qwFInkxa0o7Vv74BihGxJW5Te37lWi
	 v+x4PlVaJ5HMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/283] PCI/ACPI: Restrict program_hpx_type2() to AER bits
Date: Sat, 28 Feb 2026 13:04:38 -0500
Message-ID: <20260228180709.1583486-136-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 9abf79c8d7b40db0e5a34aa8c744ea60ff9a3fcf ]

Previously program_hpx_type2() applied PCIe settings unconditionally,
which could incorrectly change bits like Extended Tag Field Enable and
Enable Relaxed Ordering.

When _HPX was added to ACPI r3.0, the intent of the PCIe Setting
Record (Type 2) in sec 6.2.7.3 was to configure AER registers when the
OS does not own the AER Capability:

  The PCI Express setting record contains ... [the AER] Uncorrectable
  Error Mask, Uncorrectable Error Severity, Correctable Error Mask
  ... to be used when configuring registers in the Advanced Error
  Reporting Extended Capability Structure ...

  OSPM [1] will only evaluate _HPX with Setting Record – Type 2 if
  OSPM is not controlling the PCI Express Advanced Error Reporting
  capability.

ACPI r3.0b, sec 6.2.7.3, added more AER registers, including registers
in the PCIe Capability with AER-related bits, and the restriction that
the OS use this only when it owns PCIe native hotplug:

  ... when configuring PCI Express registers in the Advanced Error
  Reporting Extended Capability Structure *or PCI Express Capability
  Structure* ...

  An OS that has assumed ownership of native hot plug but does not
  ... have ownership of the AER register set must use ... the Type 2
  record to program the AER registers ...

  However, since the Type 2 record also includes register bits that
  have functions other than AER, the OS must ignore values ... that
  are not applicable.

Restrict program_hpx_type2() to only the intended purpose:

  - Apply settings only when OS owns PCIe native hotplug but not AER,

  - Only touch the AER-related bits (Error Reporting Enables) in Device
    Control

  - Don't touch Link Control at all, since nothing there seems AER-related,
    but log _HPX settings for debugging purposes

Note that Read Completion Boundary is now configured elsewhere, since it is
unrelated to _HPX.

[1] Operating System-directed configuration and Power Management

Fixes: 40abb96c51bb ("[PATCH] pciehp: Fix programming hotplug parameters")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260129175237.727059-3-haakon.bugge@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-acpi.c | 59 +++++++++++++++++-------------------------
 drivers/pci/pci.h      |  3 +++
 drivers/pci/pcie/aer.c |  3 ---
 3 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 61bded8623d21..508873c526e71 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -246,21 +246,6 @@ static acpi_status decode_type1_hpx_record(union acpi_object *record,
 	return AE_OK;
 }
 
-static bool pcie_root_rcb_set(struct pci_dev *dev)
-{
-	struct pci_dev *rp = pcie_find_root_port(dev);
-	u16 lnkctl;
-
-	if (!rp)
-		return false;
-
-	pcie_capability_read_word(rp, PCI_EXP_LNKCTL, &lnkctl);
-	if (lnkctl & PCI_EXP_LNKCTL_RCB)
-		return true;
-
-	return false;
-}
-
 /* _HPX PCI Express Setting Record (Type 2) */
 struct hpx_type2 {
 	u32 revision;
@@ -286,6 +271,7 @@ static void program_hpx_type2(struct pci_dev *dev, struct hpx_type2 *hpx)
 {
 	int pos;
 	u32 reg32;
+	const struct pci_host_bridge *host;
 
 	if (!hpx)
 		return;
@@ -293,6 +279,15 @@ static void program_hpx_type2(struct pci_dev *dev, struct hpx_type2 *hpx)
 	if (!pci_is_pcie(dev))
 		return;
 
+	host = pci_find_host_bridge(dev->bus);
+
+	/*
+	 * Only do the _HPX Type 2 programming if OS owns PCIe native
+	 * hotplug but not AER.
+	 */
+	if (!host->native_pcie_hotplug || host->native_aer)
+		return;
+
 	if (hpx->revision > 1) {
 		pci_warn(dev, "PCIe settings rev %d not supported\n",
 			 hpx->revision);
@@ -300,33 +295,27 @@ static void program_hpx_type2(struct pci_dev *dev, struct hpx_type2 *hpx)
 	}
 
 	/*
-	 * Don't allow _HPX to change MPS or MRRS settings.  We manage
-	 * those to make sure they're consistent with the rest of the
-	 * platform.
+	 * We only allow _HPX to program DEVCTL bits related to AER, namely
+	 * PCI_EXP_DEVCTL_CERE, PCI_EXP_DEVCTL_NFERE, PCI_EXP_DEVCTL_FERE,
+	 * and PCI_EXP_DEVCTL_URRE.
+	 *
+	 * The rest of DEVCTL is managed by the OS to make sure it's
+	 * consistent with the rest of the platform.
 	 */
-	hpx->pci_exp_devctl_and |= PCI_EXP_DEVCTL_PAYLOAD |
-				    PCI_EXP_DEVCTL_READRQ;
-	hpx->pci_exp_devctl_or &= ~(PCI_EXP_DEVCTL_PAYLOAD |
-				    PCI_EXP_DEVCTL_READRQ);
+	hpx->pci_exp_devctl_and |= ~PCI_EXP_AER_FLAGS;
+	hpx->pci_exp_devctl_or &= PCI_EXP_AER_FLAGS;
 
 	/* Initialize Device Control Register */
 	pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 			~hpx->pci_exp_devctl_and, hpx->pci_exp_devctl_or);
 
-	/* Initialize Link Control Register */
+	/* Log if _HPX attempts to modify Link Control Register */
 	if (pcie_cap_has_lnkctl(dev)) {
-
-		/*
-		 * If the Root Port supports Read Completion Boundary of
-		 * 128, set RCB to 128.  Otherwise, clear it.
-		 */
-		hpx->pci_exp_lnkctl_and |= PCI_EXP_LNKCTL_RCB;
-		hpx->pci_exp_lnkctl_or &= ~PCI_EXP_LNKCTL_RCB;
-		if (pcie_root_rcb_set(dev))
-			hpx->pci_exp_lnkctl_or |= PCI_EXP_LNKCTL_RCB;
-
-		pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
-			~hpx->pci_exp_lnkctl_and, hpx->pci_exp_lnkctl_or);
+		if (hpx->pci_exp_lnkctl_and != 0xffff ||
+		    hpx->pci_exp_lnkctl_or != 0)
+			pci_info(dev, "_HPX attempts Link Control setting (AND %#06x OR %#06x)\n",
+				 hpx->pci_exp_lnkctl_and,
+				 hpx->pci_exp_lnkctl_or);
 	}
 
 	/* Find Advanced Error Reporting Enhanced Capability */
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index d333be3877b2e..24441a26be1e6 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -44,6 +44,9 @@
 #define PCI_BUS_BRIDGE_MEM_WINDOW	1
 #define PCI_BUS_BRIDGE_PREF_MEM_WINDOW	2
 
+#define PCI_EXP_AER_FLAGS	(PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE | \
+				 PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE)
+
 extern const unsigned char pcie_link_speed[];
 extern bool pci_early_dump;
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 8e700020ee0bc..42a0f86b72fa5 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -218,9 +218,6 @@ void pcie_ecrc_get_policy(char *str)
 }
 #endif	/* CONFIG_PCIE_ECRC */
 
-#define	PCI_EXP_AER_FLAGS	(PCI_EXP_DEVCTL_CERE | PCI_EXP_DEVCTL_NFERE | \
-				 PCI_EXP_DEVCTL_FERE | PCI_EXP_DEVCTL_URRE)
-
 int pcie_aer_is_native(struct pci_dev *dev)
 {
 	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
-- 
2.51.0

