Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77611A6177;
	Tue, 30 Jul 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356435; cv=none; b=CuWiDofoWYl02tnVC1rW0P9d+xlq0GJVBFoPjrokE1IW05nY2AmKMJLuq0XPS83xdGpXBjRjfG7KITtFQWHaR+rsVmYqbHr1mCTYf3pPFncMVa5aYvh+BRA4SzJYeK7HT2YN1FxyGPYIlMNUqs09e03YNSAZoWdtKMRcLpq5XsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356435; c=relaxed/simple;
	bh=OmKZM7+YPrKJpK61eMdwst29xCDEvHGG2lcgQF9n1Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uk8kZMlyMCQCCdLhAVVkU0CtwMthq8QjB2I1bABfEwzT5NRZkdDAWBCWTy/Tf8KeJM1D7gsGmIL3G+/MiQkEz72nK6QbVUgicx6UE3t0G74sP+czrf1rieL624sCKfasuVxtfGlBOVXLE7BY3momD7jLpduzxPAsPnmSu7inZzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x86G4wpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x86G4wpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04339C32782;
	Tue, 30 Jul 2024 16:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356435;
	bh=OmKZM7+YPrKJpK61eMdwst29xCDEvHGG2lcgQF9n1Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x86G4wppDyIWVq7oGBads1m5ki6fTMbqI4jGb+GeBCZP4j+4Aonh3sL6egWTChZRY
	 YqY9m2ORuasdPfmivEXQe83d19uZOzWTXwj/2L5PGK3cTC7Yvy5q8tqNkh6kzlaxUG
	 GrgoScDJLFPIrb/I6r3XfylObcSGjxsdePVQDJv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Serge Semin <fancer.lancer@gmail.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/440] PCI: keystone: Dont enable BAR 0 for AM654x
Date: Tue, 30 Jul 2024 17:46:52 +0200
Message-ID: <20240730151622.866118375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 9ffa0e70b2daf9b0271e4960b7c8a2350e2cda08 ]

After 6ab15b5e7057 ("PCI: dwc: keystone: Convert .scan_bus() callback to
use add_bus"), ks_pcie_v3_65_add_bus() enabled BAR 0 for both v3.65a and
v4.90a devices.  On the AM654x SoC, which uses v4.90a, enabling BAR 0
causes Completion Timeouts when setting up MSI-X.  These timeouts delay
boot of the AM654x by about 45 seconds.

Move the BAR 0 initialization to ks_pcie_msi_host_init(), which is only
used for v3.65a devices, and remove ks_pcie_v3_65_add_bus().

[bhelgaas: commit log]
Fixes: 6ab15b5e7057 ("PCI: dwc: keystone: Convert .scan_bus() callback to use add_bus")
Link: https://lore.kernel.org/linux-pci/20240328085041.2916899-3-s-vadapalli@ti.com
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Suggested-by: Niklas Cassel <cassel@kernel.org>
Suggested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 52 ++++++++---------------
 1 file changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 348a9f755d0ba..438aa5fa4c64b 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -291,6 +291,24 @@ static void ks_pcie_clear_dbi_mode(struct keystone_pcie *ks_pcie)
 
 static int ks_pcie_msi_host_init(struct dw_pcie_rp *pp)
 {
+	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+	struct keystone_pcie *ks_pcie = to_keystone_pcie(pci);
+
+	/* Configure and set up BAR0 */
+	ks_pcie_set_dbi_mode(ks_pcie);
+
+	/* Enable BAR0 */
+	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, 1);
+	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, SZ_4K - 1);
+
+	ks_pcie_clear_dbi_mode(ks_pcie);
+
+	/*
+	 * For BAR0, just setting bus address for inbound writes (MSI) should
+	 * be sufficient.  Use physical address to avoid any conflicts.
+	 */
+	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, ks_pcie->app.start);
+
 	pp->msi_irq_chip = &ks_pcie_msi_irq_chip;
 	return dw_pcie_allocate_domains(pp);
 }
@@ -448,44 +466,10 @@ static struct pci_ops ks_child_pcie_ops = {
 	.write = pci_generic_config_write,
 };
 
-/**
- * ks_pcie_v3_65_add_bus() - keystone add_bus post initialization
- * @bus: A pointer to the PCI bus structure.
- *
- * This sets BAR0 to enable inbound access for MSI_IRQ register
- */
-static int ks_pcie_v3_65_add_bus(struct pci_bus *bus)
-{
-	struct dw_pcie_rp *pp = bus->sysdata;
-	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
-	struct keystone_pcie *ks_pcie = to_keystone_pcie(pci);
-
-	if (!pci_is_root_bus(bus))
-		return 0;
-
-	/* Configure and set up BAR0 */
-	ks_pcie_set_dbi_mode(ks_pcie);
-
-	/* Enable BAR0 */
-	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, 1);
-	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, SZ_4K - 1);
-
-	ks_pcie_clear_dbi_mode(ks_pcie);
-
-	 /*
-	  * For BAR0, just setting bus address for inbound writes (MSI) should
-	  * be sufficient.  Use physical address to avoid any conflicts.
-	  */
-	dw_pcie_writel_dbi(pci, PCI_BASE_ADDRESS_0, ks_pcie->app.start);
-
-	return 0;
-}
-
 static struct pci_ops ks_pcie_ops = {
 	.map_bus = dw_pcie_own_conf_map_bus,
 	.read = pci_generic_config_read,
 	.write = pci_generic_config_write,
-	.add_bus = ks_pcie_v3_65_add_bus,
 };
 
 /**
-- 
2.43.0



