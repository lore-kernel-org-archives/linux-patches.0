Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1719044682F;
	Thu, 30 Jul 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428190; cv=none; b=URj80d5+SPamVGJEPSXrVxQ6W/2QbwBs9NT0KFjnk2j0EYHDGTCZ52+P00qy9tmklq5nwtDn7hgyQX/YITtS8jg5VnmP2BnDAT8dvfnoPWPEH8JiZaRUuwZAoolG1d8RezXWLfmXwHhGlkNg4FIuk6cpeZunCD8Nc4LvfOtj6MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428190; c=relaxed/simple;
	bh=MRgrQPBFe3F5iEXbhQiVcRhzsXS1QbxRAMVmTju1b7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhnkWtJkF1CtqDPcyakIjvVK5fllUOiuhlzGbZpyTl1rlQHSlnntiae/MqC8bLhjYDLSy/TEwsOwbM8ldKzLRh2ZOh1ZGMYeeXxYzzjLIKtbRUQENWoUa8t2wrN1Q0ZrseOCe8PdL9L91BqwL9xHtp6WTu+efkZJ/UcSWlkrppA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6jXLqLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6jXLqLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161F1F000E9;
	Thu, 30 Jul 2026 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428176;
	bh=GNjXQwXCBG/420DwY+lAvxm653oeEyUwUw2jbfW4wvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6jXLqLn3B/P5viU799G6BHO35j3cEW37wHm0xGRoDiIR8XGIu22koXHX13/u3Lpz
	 Dkf9AH/9UE+Hw8phcHEzWGByXI5BKYhHu/zUxRdwdo09A45DzM5aaXiXh14T0kijiN
	 aD8FFBFnygUOIFGPLwv1jjM2W5kQd9uRHdJW2iKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 431/484] dma: dw-edma: Fix build warning in dw_edma_pcie_probe()
Date: Thu, 30 Jul 2026 16:15:28 +0200
Message-ID: <20260730141432.843766100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abinash Singh <abinashlalotra@gmail.com>

[ Upstream commit 3df63fa8f2afd051848e37ef1b8299dee28d4f87 ]

The function dw_edma_pcie_probe() in dw-edma-pcie.c triggered a
frame size warning:
ld.lld:warning:
  drivers/dma/dw-edma/dw-edma-pcie.c:162:0: stack frame size (1040) exceeds limit (1024) in function 'dw_edma_pcie_probe'

This patch reduces the stack usage by dynamically allocating the
`vsec_data` structure using kmalloc(), rather than placing it on
the stack. This eliminates the overflow warning and improves kernel
robustness.

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20250705160055.808165-1-abinashsinghlalotra@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 11d7cfe0c119 ("dmaengine: dw-edma-pcie: Reject devices without driver data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-pcie.c |   62 +++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

--- a/drivers/dma/dw-edma/dw-edma-pcie.c
+++ b/drivers/dma/dw-edma/dw-edma-pcie.c
@@ -160,12 +160,16 @@ static int dw_edma_pcie_probe(struct pci
 			      const struct pci_device_id *pid)
 {
 	struct dw_edma_pcie_data *pdata = (void *)pid->driver_data;
-	struct dw_edma_pcie_data vsec_data;
+	struct dw_edma_pcie_data *vsec_data __free(kfree) = NULL;
 	struct device *dev = &pdev->dev;
 	struct dw_edma_chip *chip;
 	int err, nr_irqs;
 	int i, mask;
 
+	vsec_data = kmalloc(sizeof(*vsec_data), GFP_KERNEL);
+	if (!vsec_data)
+		return -ENOMEM;
+
 	/* Enable PCI device */
 	err = pcim_enable_device(pdev);
 	if (err) {
@@ -173,23 +177,23 @@ static int dw_edma_pcie_probe(struct pci
 		return err;
 	}
 
-	memcpy(&vsec_data, pdata, sizeof(struct dw_edma_pcie_data));
+	memcpy(vsec_data, pdata, sizeof(struct dw_edma_pcie_data));
 
 	/*
 	 * Tries to find if exists a PCIe Vendor-Specific Extended Capability
 	 * for the DMA, if one exists, then reconfigures it.
 	 */
-	dw_edma_pcie_get_vsec_dma_data(pdev, &vsec_data);
+	dw_edma_pcie_get_vsec_dma_data(pdev, vsec_data);
 
 	/* Mapping PCI BAR regions */
-	mask = BIT(vsec_data.rg.bar);
-	for (i = 0; i < vsec_data.wr_ch_cnt; i++) {
-		mask |= BIT(vsec_data.ll_wr[i].bar);
-		mask |= BIT(vsec_data.dt_wr[i].bar);
-	}
-	for (i = 0; i < vsec_data.rd_ch_cnt; i++) {
-		mask |= BIT(vsec_data.ll_rd[i].bar);
-		mask |= BIT(vsec_data.dt_rd[i].bar);
+	mask = BIT(vsec_data->rg.bar);
+	for (i = 0; i < vsec_data->wr_ch_cnt; i++) {
+		mask |= BIT(vsec_data->ll_wr[i].bar);
+		mask |= BIT(vsec_data->dt_wr[i].bar);
+	}
+	for (i = 0; i < vsec_data->rd_ch_cnt; i++) {
+		mask |= BIT(vsec_data->ll_rd[i].bar);
+		mask |= BIT(vsec_data->dt_rd[i].bar);
 	}
 	err = pcim_iomap_regions(pdev, mask, pci_name(pdev));
 	if (err) {
@@ -212,7 +216,7 @@ static int dw_edma_pcie_probe(struct pci
 		return -ENOMEM;
 
 	/* IRQs allocation */
-	nr_irqs = pci_alloc_irq_vectors(pdev, 1, vsec_data.irqs,
+	nr_irqs = pci_alloc_irq_vectors(pdev, 1, vsec_data->irqs,
 					PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (nr_irqs < 1) {
 		pci_err(pdev, "fail to alloc IRQ vector (number of IRQs=%u)\n",
@@ -223,22 +227,22 @@ static int dw_edma_pcie_probe(struct pci
 	/* Data structure initialization */
 	chip->dev = dev;
 
-	chip->mf = vsec_data.mf;
+	chip->mf = vsec_data->mf;
 	chip->nr_irqs = nr_irqs;
 	chip->ops = &dw_edma_pcie_plat_ops;
 
-	chip->ll_wr_cnt = vsec_data.wr_ch_cnt;
-	chip->ll_rd_cnt = vsec_data.rd_ch_cnt;
+	chip->ll_wr_cnt = vsec_data->wr_ch_cnt;
+	chip->ll_rd_cnt = vsec_data->rd_ch_cnt;
 
-	chip->reg_base = pcim_iomap_table(pdev)[vsec_data.rg.bar];
+	chip->reg_base = pcim_iomap_table(pdev)[vsec_data->rg.bar];
 	if (!chip->reg_base)
 		return -ENOMEM;
 
 	for (i = 0; i < chip->ll_wr_cnt; i++) {
 		struct dw_edma_region *ll_region = &chip->ll_region_wr[i];
 		struct dw_edma_region *dt_region = &chip->dt_region_wr[i];
-		struct dw_edma_block *ll_block = &vsec_data.ll_wr[i];
-		struct dw_edma_block *dt_block = &vsec_data.dt_wr[i];
+		struct dw_edma_block *ll_block = &vsec_data->ll_wr[i];
+		struct dw_edma_block *dt_block = &vsec_data->dt_wr[i];
 
 		ll_region->vaddr.io = pcim_iomap_table(pdev)[ll_block->bar];
 		if (!ll_region->vaddr.io)
@@ -262,8 +266,8 @@ static int dw_edma_pcie_probe(struct pci
 	for (i = 0; i < chip->ll_rd_cnt; i++) {
 		struct dw_edma_region *ll_region = &chip->ll_region_rd[i];
 		struct dw_edma_region *dt_region = &chip->dt_region_rd[i];
-		struct dw_edma_block *ll_block = &vsec_data.ll_rd[i];
-		struct dw_edma_block *dt_block = &vsec_data.dt_rd[i];
+		struct dw_edma_block *ll_block = &vsec_data->ll_rd[i];
+		struct dw_edma_block *dt_block = &vsec_data->dt_rd[i];
 
 		ll_region->vaddr.io = pcim_iomap_table(pdev)[ll_block->bar];
 		if (!ll_region->vaddr.io)
@@ -295,31 +299,31 @@ static int dw_edma_pcie_probe(struct pci
 		pci_dbg(pdev, "Version:\tUnknown (0x%x)\n", chip->mf);
 
 	pci_dbg(pdev, "Registers:\tBAR=%u, off=0x%.8lx, sz=0x%zx bytes, addr(v=%p)\n",
-		vsec_data.rg.bar, vsec_data.rg.off, vsec_data.rg.sz,
+		vsec_data->rg.bar, vsec_data->rg.off, vsec_data->rg.sz,
 		chip->reg_base);
 
 
 	for (i = 0; i < chip->ll_wr_cnt; i++) {
 		pci_dbg(pdev, "L. List:\tWRITE CH%.2u, BAR=%u, off=0x%.8lx, sz=0x%zx bytes, addr(v=%p, p=%pa)\n",
-			i, vsec_data.ll_wr[i].bar,
-			vsec_data.ll_wr[i].off, chip->ll_region_wr[i].sz,
+			i, vsec_data->ll_wr[i].bar,
+			vsec_data->ll_wr[i].off, chip->ll_region_wr[i].sz,
 			chip->ll_region_wr[i].vaddr.io, &chip->ll_region_wr[i].paddr);
 
 		pci_dbg(pdev, "Data:\tWRITE CH%.2u, BAR=%u, off=0x%.8lx, sz=0x%zx bytes, addr(v=%p, p=%pa)\n",
-			i, vsec_data.dt_wr[i].bar,
-			vsec_data.dt_wr[i].off, chip->dt_region_wr[i].sz,
+			i, vsec_data->dt_wr[i].bar,
+			vsec_data->dt_wr[i].off, chip->dt_region_wr[i].sz,
 			chip->dt_region_wr[i].vaddr.io, &chip->dt_region_wr[i].paddr);
 	}
 
 	for (i = 0; i < chip->ll_rd_cnt; i++) {
 		pci_dbg(pdev, "L. List:\tREAD CH%.2u, BAR=%u, off=0x%.8lx, sz=0x%zx bytes, addr(v=%p, p=%pa)\n",
-			i, vsec_data.ll_rd[i].bar,
-			vsec_data.ll_rd[i].off, chip->ll_region_rd[i].sz,
+			i, vsec_data->ll_rd[i].bar,
+			vsec_data->ll_rd[i].off, chip->ll_region_rd[i].sz,
 			chip->ll_region_rd[i].vaddr.io, &chip->ll_region_rd[i].paddr);
 
 		pci_dbg(pdev, "Data:\tREAD CH%.2u, BAR=%u, off=0x%.8lx, sz=0x%zx bytes, addr(v=%p, p=%pa)\n",
-			i, vsec_data.dt_rd[i].bar,
-			vsec_data.dt_rd[i].off, chip->dt_region_rd[i].sz,
+			i, vsec_data->dt_rd[i].bar,
+			vsec_data->dt_rd[i].off, chip->dt_region_rd[i].sz,
 			chip->dt_region_rd[i].vaddr.io, &chip->dt_region_rd[i].paddr);
 	}
 


