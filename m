Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45ED364C1;
	Fri, 24 Nov 2023 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfAtJyxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA54C433C7;
	Fri, 24 Nov 2023 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853152;
	bh=aQdR3UgTcAVHsxdAn39Md2ZhiEbohxUghbOaDJueg1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfAtJyxLjvA1JUjvB47Uq1J1Z4TWMH1ZxtrheFiYEih7xG5lrI7Tl0GIT50VGEOZ3
	 MSr0UmwOeW/HfapsEAIDK4qDndeGHrM6JX8ic3Di92g6GQ4VuUhXue2KUeKLqX4c2v
	 zAfapQii7GbPkht3TA6ES+SEm11cklzFV8s2zmBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/297] PCI: tegra194: Use FIELD_GET()/FIELD_PREP() with Link Width fields
Date: Fri, 24 Nov 2023 17:51:32 +0000
Message-ID: <20231124172001.922558925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 759574abd78e3b47ec45bbd31a64e8832cf73f97 ]

Use FIELD_GET() to extract PCIe Negotiated Link Width field instead of
custom masking and shifting.

Similarly, change custom code that misleadingly used
PCI_EXP_LNKSTA_NLW_SHIFT to prepare value for PCI_EXP_LNKCAP write
to use FIELD_PREP() with correct field define (PCI_EXP_LNKCAP_MLW).

Link: https://lore.kernel.org/r/20230919125648.1920-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 765abe0732282..2f82da76e3711 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -7,6 +7,7 @@
  * Author: Vidya Sagar <vidyas@nvidia.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
@@ -328,8 +329,7 @@ static void apply_bad_link_workaround(struct pcie_port *pp)
 	 */
 	val = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base + PCI_EXP_LNKSTA);
 	if (val & PCI_EXP_LNKSTA_LBMS) {
-		current_link_width = (val & PCI_EXP_LNKSTA_NLW) >>
-				     PCI_EXP_LNKSTA_NLW_SHIFT;
+		current_link_width = FIELD_GET(PCI_EXP_LNKSTA_NLW, val);
 		if (pcie->init_link_width > current_link_width) {
 			dev_warn(pci->dev, "PCIe link is bad, width reduced\n");
 			val = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base +
@@ -731,8 +731,7 @@ static void tegra_pcie_enable_system_interrupts(struct pcie_port *pp)
 
 	val_w = dw_pcie_readw_dbi(&pcie->pci, pcie->pcie_cap_base +
 				  PCI_EXP_LNKSTA);
-	pcie->init_link_width = (val_w & PCI_EXP_LNKSTA_NLW) >>
-				PCI_EXP_LNKSTA_NLW_SHIFT;
+	pcie->init_link_width = FIELD_GET(PCI_EXP_LNKSTA_NLW, val_w);
 
 	val_w = dw_pcie_readw_dbi(&pcie->pci, pcie->pcie_cap_base +
 				  PCI_EXP_LNKCTL);
@@ -889,7 +888,7 @@ static int tegra_pcie_dw_host_init(struct pcie_port *pp)
 	/* Configure Max lane width from DT */
 	val = dw_pcie_readl_dbi(pci, pcie->pcie_cap_base + PCI_EXP_LNKCAP);
 	val &= ~PCI_EXP_LNKCAP_MLW;
-	val |= (pcie->num_lanes << PCI_EXP_LNKSTA_NLW_SHIFT);
+	val |= FIELD_PREP(PCI_EXP_LNKCAP_MLW, pcie->num_lanes);
 	dw_pcie_writel_dbi(pci, pcie->pcie_cap_base + PCI_EXP_LNKCAP, val);
 
 	config_gen3_gen4_eq_presets(pcie);
-- 
2.42.0



