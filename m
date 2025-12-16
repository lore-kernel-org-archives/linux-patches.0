Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2339734DB4B;
	Tue, 16 Dec 2025 12:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887840; cv=none; b=XtH+Mwrvey+42Ro8jv0zSPB6OpHVE8cBSD6mRnHR6+HCjxagDPBKdwPD3+uAhBhFzZ6GRZnwUiXRZDZ1gN6BiPHnKFNMgqkEjz0g7yBqCOAHx2FKq9QaSecSHolw+jjHJIg86w7Jovun6xbUD+6GngDWIuhqK6UKmADLrrlqCIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887840; c=relaxed/simple;
	bh=sEIZgSgInW4ErWYpQfbHmZKvlmBmdoGEScBr4pw1QLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhQZWSLqkt1VYqctXgLbW39XWfa95IBGusAaIC4uzqEgZJbHr2zbwZYkB+NnBz4OiE2u5gcpKiKoFaRSoXnhPrUC5y6vzuQGzIutWAZNL2znErErZOsNxIsZKeaORK8YeaKUMmnPnlyeAta9zgpgsasb5iU76TCEFCZu+Tv4juo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES2XsV+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES2XsV+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB87C4CEF1;
	Tue, 16 Dec 2025 12:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887840;
	bh=sEIZgSgInW4ErWYpQfbHmZKvlmBmdoGEScBr4pw1QLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES2XsV+jRofHv46rSWNLqRoXnlxvF7Caxgg4DoXKvdbnBdR/CZgo+8P7+gyi7azdd
	 DZTFNTuR8GIrSgQE8lEtYeNHAjwDYHuW+eiIwdk8m98wk+gfXf6a3ActntLx9ipN85
	 8hZq/DAo0lZFd3wdq+EA/jo85lMwZm6Cihw9Njc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 310/614] PCI: stm32: Fix LTSSM EP race with start link
Date: Tue, 16 Dec 2025 12:11:17 +0100
Message-ID: <20251216111412.600390521@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit fa81d6099007728cae39c6f937d83903bbddab5e ]

If the host has deasserted PERST# and started link training before the link
is started on EP side, enabling LTSSM before the endpoint registers are
initialized in the perst_irq handler results in probing incorrect values.

Thus, wait for the PERST# level-triggered interrupt to start link training
at the end of initialization and cleanup the stm32_pcie_[start stop]_link
functions.

Fixes: 151f3d29baf4 ("PCI: stm32-ep: Add PCIe Endpoint support for STM32MP25")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
[mani: added fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: wrap line]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251114-perst_ep-v1-1-e7976317a890@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-stm32-ep.c | 39 +++++-----------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-stm32-ep.c b/drivers/pci/controller/dwc/pcie-stm32-ep.c
index 3400c7cd2d88a..faa6433a784f3 100644
--- a/drivers/pci/controller/dwc/pcie-stm32-ep.c
+++ b/drivers/pci/controller/dwc/pcie-stm32-ep.c
@@ -37,36 +37,9 @@ static void stm32_pcie_ep_init(struct dw_pcie_ep *ep)
 		dw_pcie_ep_reset_bar(pci, bar);
 }
 
-static int stm32_pcie_enable_link(struct dw_pcie *pci)
-{
-	struct stm32_pcie *stm32_pcie = to_stm32_pcie(pci);
-
-	regmap_update_bits(stm32_pcie->regmap, SYSCFG_PCIECR,
-			   STM32MP25_PCIECR_LTSSM_EN,
-			   STM32MP25_PCIECR_LTSSM_EN);
-
-	return dw_pcie_wait_for_link(pci);
-}
-
-static void stm32_pcie_disable_link(struct dw_pcie *pci)
-{
-	struct stm32_pcie *stm32_pcie = to_stm32_pcie(pci);
-
-	regmap_update_bits(stm32_pcie->regmap, SYSCFG_PCIECR, STM32MP25_PCIECR_LTSSM_EN, 0);
-}
-
 static int stm32_pcie_start_link(struct dw_pcie *pci)
 {
 	struct stm32_pcie *stm32_pcie = to_stm32_pcie(pci);
-	int ret;
-
-	dev_dbg(pci->dev, "Enable link\n");
-
-	ret = stm32_pcie_enable_link(pci);
-	if (ret) {
-		dev_err(pci->dev, "PCIe cannot establish link: %d\n", ret);
-		return ret;
-	}
 
 	enable_irq(stm32_pcie->perst_irq);
 
@@ -77,11 +50,7 @@ static void stm32_pcie_stop_link(struct dw_pcie *pci)
 {
 	struct stm32_pcie *stm32_pcie = to_stm32_pcie(pci);
 
-	dev_dbg(pci->dev, "Disable link\n");
-
 	disable_irq(stm32_pcie->perst_irq);
-
-	stm32_pcie_disable_link(pci);
 }
 
 static int stm32_pcie_raise_irq(struct dw_pcie_ep *ep, u8 func_no,
@@ -152,6 +121,9 @@ static void stm32_pcie_perst_assert(struct dw_pcie *pci)
 
 	dev_dbg(dev, "PERST asserted by host\n");
 
+	regmap_update_bits(stm32_pcie->regmap, SYSCFG_PCIECR,
+			   STM32MP25_PCIECR_LTSSM_EN, 0);
+
 	pci_epc_deinit_notify(ep->epc);
 
 	stm32_pcie_disable_resources(stm32_pcie);
@@ -192,6 +164,11 @@ static void stm32_pcie_perst_deassert(struct dw_pcie *pci)
 
 	pci_epc_init_notify(ep->epc);
 
+	/* Enable link training */
+	regmap_update_bits(stm32_pcie->regmap, SYSCFG_PCIECR,
+			   STM32MP25_PCIECR_LTSSM_EN,
+			   STM32MP25_PCIECR_LTSSM_EN);
+
 	return;
 
 err_disable_resources:
-- 
2.51.0



