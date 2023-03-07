Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC4BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D9BC433D2;
	Tue,  7 Mar 2023 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213350;
	bh=N8vrKFFhT3y4msk5YbwIAuLjAABV1gpk6Ml5L4OktDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayM83sqv14u6mdvodxwSXD7+rrzxAtACFRfZnRB3YxX/aHLXMzTYUcFZWG9mFVomz
	 e6ZxJjtjwHySlHF3gdMK+1+ZV31e0YRzBsCMciOxjCqH40dhOFfiRaZB2dM8Ek4Qja
	 SIkgU1yryPJxEw1iB8oig7qGCdhNy8gsEO8xrLeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 480/885] PCI: qcom: Fix host-init error handling
Date: Tue,  7 Mar 2023 17:56:54 +0100
Message-Id: <20230307170023.339855628@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 997e010de9134474dbfde52be03efd7d1bce902d ]

Implement the new host_deinit() callback so that the PHY is powered off
and regulators and clocks are disabled also on late host-init errors.

Link: https://lore.kernel.org/r/20221017114705.8277-2-johan+linaro@kernel.org
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index f711acacaeaf8..f8e512540fb85 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1527,8 +1527,19 @@ static int qcom_pcie_host_init(struct dw_pcie_rp *pp)
 	return ret;
 }
 
+static void qcom_pcie_host_deinit(struct dw_pcie_rp *pp)
+{
+	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+	struct qcom_pcie *pcie = to_qcom_pcie(pci);
+
+	qcom_ep_reset_assert(pcie);
+	phy_power_off(pcie->phy);
+	pcie->cfg->ops->deinit(pcie);
+}
+
 static const struct dw_pcie_host_ops qcom_pcie_dw_ops = {
-	.host_init = qcom_pcie_host_init,
+	.host_init	= qcom_pcie_host_init,
+	.host_deinit	= qcom_pcie_host_deinit,
 };
 
 /* Qcom IP rev.: 2.1.0	Synopsys IP rev.: 4.01a */
-- 
2.39.2



