Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD2E346FB3;
	Thu, 12 Mar 2026 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346363; cv=none; b=sJxqTb02nrUq81IwXdvVznMucv1aNkLyKJkYRSam558vhnT1O52BoNNQl2HNXHrAmB16S3ZWq232U/3Bh2M/4ynvbl8pAWrheGE5C3teGqnM8XAf2lHtgCIeqXCOBfP8BikJWpbXzOxm8nWIaPwvXHnERyv49U56LQG1YNf44Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346363; c=relaxed/simple;
	bh=wcB+Ik1pSfcyEAmEEzI9CSAekUXb7Klc7+Ysp9XuZBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHw2cL4n+gYMkuWduLx/zgI9TpkSuXbdOAfrQF/om7hvh5f4gGALe3ElhngUBJPGrwDodM0r1Q+0Vgy1R9PJon0Mpe91LKt93NsBxh9sO7iNwjEd0I8wagzkR1P9tbGp/HvnMHkW3vYn2V/7EQyJGS8zuA20OWVggqSPkhn+OgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeIR2I3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeIR2I3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3249C19425;
	Thu, 12 Mar 2026 20:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346363;
	bh=wcB+Ik1pSfcyEAmEEzI9CSAekUXb7Klc7+Ysp9XuZBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeIR2I3uhNyFxKFISVxqW+g0WZGrY/bSY3+wvwRbhiApDii7RjmLDTclBsprf3iOl
	 JKqKnibeUbp48/wwTrDPxhMpj4o315A7wu3KYL4t1gR0IX3NNxxKfY3tG+yxlmhuDH
	 /OYviGMRDolPhkMT3txQeHqZOUoRusYsqQlwD+7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 025/265] PCI: dwc: endpoint: Implement the pci_epc_ops::align_addr() operation
Date: Thu, 12 Mar 2026 21:06:52 +0100
Message-ID: <20260312201019.093251359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit e73ea1c2d4d8f7ba5daaf7aa51171f63cf79bcd8 ]

The function dw_pcie_prog_outbound_atu() used to program outbound ATU
entries for mapping RC PCI addresses to local CPU addresses does not
allow PCI addresses that are not aligned to the value of region_align
of struct dw_pcie. This value is determined from the iATU hardware
registers during probing of the iATU (done by dw_pcie_iatu_detect()).
This value is thus valid for all DWC PCIe controllers, and valid
regardless of the hardware configuration used when synthesizing the
DWC PCIe controller.

Implement the ->align_addr() endpoint controller operation to allow
this mapping alignment to be transparently handled by endpoint function
drivers through the function pci_epc_mem_map().

Link: https://lore.kernel.org/linux-pci/20241012113246.95634-7-dlemoal@kernel.org
Link: https://lore.kernel.org/linux-pci/20241015090712.112674-1-dlemoal@kernel.org
Link: https://lore.kernel.org/linux-pci/20241017132052.4014605-5-cassel@kernel.org
Co-developed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[mani: squashed the patch that changed phy_addr_t to u64]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[kwilczynski: squashed patch that updated the pci_size variable]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c22533c66cca ("PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 00289948f9c12..b093c4153f14f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -290,6 +290,20 @@ static int dw_pcie_find_index(struct dw_pcie_ep *ep, phys_addr_t addr,
 	return -EINVAL;
 }
 
+static u64 dw_pcie_ep_align_addr(struct pci_epc *epc, u64 pci_addr,
+				 size_t *pci_size, size_t *offset)
+{
+	struct dw_pcie_ep *ep = epc_get_drvdata(epc);
+	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
+	u64 mask = pci->region_align - 1;
+	size_t ofst = pci_addr & mask;
+
+	*pci_size = ALIGN(ofst + *pci_size, epc->mem->window.page_size);
+	*offset = ofst;
+
+	return pci_addr & ~mask;
+}
+
 static void dw_pcie_ep_unmap_addr(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 				  phys_addr_t addr)
 {
@@ -467,6 +481,7 @@ static const struct pci_epc_ops epc_ops = {
 	.write_header		= dw_pcie_ep_write_header,
 	.set_bar		= dw_pcie_ep_set_bar,
 	.clear_bar		= dw_pcie_ep_clear_bar,
+	.align_addr		= dw_pcie_ep_align_addr,
 	.map_addr		= dw_pcie_ep_map_addr,
 	.unmap_addr		= dw_pcie_ep_unmap_addr,
 	.set_msi		= dw_pcie_ep_set_msi,
-- 
2.51.0



