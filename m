Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C4211C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C5BC433C8;
	Thu, 24 Aug 2023 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889089;
	bh=KC1DmDpuEeaMLXBhwA8OmL6TA7c6lY0nxQiN8tiP+H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtO0PsNqa3aTWzqOYI/UTr2KV35HCwRxM6OlT/Y1q6iFOzwLP74bzRuGYBTUkbfNp
	 WbLcUOPG2T+A1F5Iq1fSUiUxb+sis+rIF/D12aPwR+YJdI4GUmijfwEVRpaDjly7eJ
	 7jby3zdd9AEdXM1nsedCwmwuilOv3FAnZ7MuaCo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Sumit Gupta <sumitg@nvidia.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/135] PCI: tegra194: Fix possible array out of bounds access
Date: Thu, 24 Aug 2023 16:49:14 +0200
Message-ID: <20230824145027.460746973@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sumit Gupta <sumitg@nvidia.com>

[ Upstream commit 205b3d02d57ce6dce96f6d2b9c230f56a9bf9817 ]

Add check to fix the possible array out of bounds violation by
making speed equal to GEN1_CORE_CLK_FREQ when its value is more
than the size of "pcie_gen_freq" array. This array has size of
four but possible speed (CLS) values are from "0 to 0xF". So,
"speed - 1" values are "-1 to 0xE".

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://lore.kernel.org/lkml/72b9168b-d4d6-4312-32ea-69358df2f2d0@nvidia.com/
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 1222f5749bc67..a215777df96c7 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -239,6 +239,7 @@
 #define EP_STATE_ENABLED	1
 
 static const unsigned int pcie_gen_freq[] = {
+	GEN1_CORE_CLK_FREQ,	/* PCI_EXP_LNKSTA_CLS == 0; undefined */
 	GEN1_CORE_CLK_FREQ,
 	GEN2_CORE_CLK_FREQ,
 	GEN3_CORE_CLK_FREQ,
@@ -470,7 +471,11 @@ static irqreturn_t tegra_pcie_ep_irq_thread(int irq, void *arg)
 
 	speed = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base + PCI_EXP_LNKSTA) &
 		PCI_EXP_LNKSTA_CLS;
-	clk_set_rate(pcie->core_clk, pcie_gen_freq[speed - 1]);
+
+	if (speed >= ARRAY_SIZE(pcie_gen_freq))
+		speed = 0;
+
+	clk_set_rate(pcie->core_clk, pcie_gen_freq[speed]);
 
 	/* If EP doesn't advertise L1SS, just return */
 	val = dw_pcie_readl_dbi(pci, pcie->cfg_link_cap_l1sub);
@@ -973,7 +978,11 @@ static int tegra_pcie_dw_host_init(struct pcie_port *pp)
 
 	speed = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base + PCI_EXP_LNKSTA) &
 		PCI_EXP_LNKSTA_CLS;
-	clk_set_rate(pcie->core_clk, pcie_gen_freq[speed - 1]);
+
+	if (speed >= ARRAY_SIZE(pcie_gen_freq))
+		speed = 0;
+
+	clk_set_rate(pcie->core_clk, pcie_gen_freq[speed]);
 
 	tegra_pcie_enable_interrupts(pp);
 
-- 
2.40.1



