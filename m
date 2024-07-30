Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7089C1A6160;
	Tue, 30 Jul 2024 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356508; cv=none; b=BxF5VLwV2M2EtpCI8MCoK4HgUAEsEDyF8TO4TmznWFmQj4BpzYCNibzk2Ly5C8MvbHk1WYggfniq8cPG1juDythHeQMPaR6UVnxLHeTyC0QX9IA1L2QRcd59AcNoguhfdqlZJznQqjCaXJ5ztBHm8XUU/Kyy8QCu+xsq6Lh/TJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356508; c=relaxed/simple;
	bh=yEfwp6WD5ijJETqGjl9J0P/xOp8B64i7f8qQ8H+zQWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jiy3h5NWtEloLo/uUfX+2XGeGWeQC67AlSMQNbigv1k4nzGY+74sTYvkXKWPSTQJxZLGyfSt0IBUeYfY7/7k/UEleKq1O6Xbs2aKo1mRGLo41v0pPLPFm9XhIFg+HkDYByxKZH+02vaHFL9iJYY2LdXt66IgnVOQR7Hokh/KYSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9OpJGPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9OpJGPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB0EC32782;
	Tue, 30 Jul 2024 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356508;
	bh=yEfwp6WD5ijJETqGjl9J0P/xOp8B64i7f8qQ8H+zQWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9OpJGPe17Bx/Fr5PPCDRzCd4dDce26U8XDICYDqSJh9R0+hkeFIEd1m3kxmBC3CQ
	 BLSrz4Rgy7VhE/Dgrd1bFqNv6OxHteZ4AJdqPVEsaYlhO+usDN7ww5gU3pefWL+QOD
	 zgBzawZHCGoC55IU21ZQ1ICWZo4ycq4nbmT2d3/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/440] PCI: keystone: Fix NULL pointer dereference in case of DT error in ks_pcie_setup_rc_app_regs()
Date: Tue, 30 Jul 2024 17:46:53 +0200
Message-ID: <20240730151622.906261764@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit a231707a91f323af1e5d9f1722055ec2fc1c7775 ]

If IORESOURCE_MEM is not provided in Device Tree due to
any error, resource_list_first_type() will return NULL and
pci_parse_request_of_pci_ranges() will just emit a warning.

This will cause a NULL pointer dereference. Fix this bug by adding NULL
return check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0f71c60ffd26 ("PCI: dwc: Remove storing of PCI resources")
Link: https://lore.kernel.org/linux-pci/20240505061517.11527-1-amishin@t-argos.ru
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Suggested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 438aa5fa4c64b..6007ffcb4752a 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -403,17 +403,22 @@ static const struct irq_domain_ops ks_pcie_legacy_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 
-static void ks_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
+static int ks_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
 {
 	u32 val;
 	u32 num_viewport = ks_pcie->num_viewport;
 	struct dw_pcie *pci = ks_pcie->pci;
 	struct dw_pcie_rp *pp = &pci->pp;
-	u64 start, end;
+	struct resource_entry *entry;
 	struct resource *mem;
+	u64 start, end;
 	int i;
 
-	mem = resource_list_first_type(&pp->bridge->windows, IORESOURCE_MEM)->res;
+	entry = resource_list_first_type(&pp->bridge->windows, IORESOURCE_MEM);
+	if (!entry)
+		return -ENODEV;
+
+	mem = entry->res;
 	start = mem->start;
 	end = mem->end;
 
@@ -424,7 +429,7 @@ static void ks_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
 	ks_pcie_clear_dbi_mode(ks_pcie);
 
 	if (ks_pcie->is_am6)
-		return;
+		return 0;
 
 	val = ilog2(OB_WIN_SIZE);
 	ks_pcie_app_writel(ks_pcie, OB_SIZE, val);
@@ -441,6 +446,8 @@ static void ks_pcie_setup_rc_app_regs(struct keystone_pcie *ks_pcie)
 	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
 	val |= OB_XLAT_EN_VAL;
 	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
+
+	return 0;
 }
 
 static void __iomem *ks_pcie_other_map_bus(struct pci_bus *bus,
@@ -802,7 +809,10 @@ static int __init ks_pcie_host_init(struct dw_pcie_rp *pp)
 		return ret;
 
 	ks_pcie_stop_link(pci);
-	ks_pcie_setup_rc_app_regs(ks_pcie);
+	ret = ks_pcie_setup_rc_app_regs(ks_pcie);
+	if (ret)
+		return ret;
+
 	writew(PCI_IO_RANGE_TYPE_32 | (PCI_IO_RANGE_TYPE_32 << 8),
 			pci->dbi_base + PCI_IO_BASE);
 
-- 
2.43.0



