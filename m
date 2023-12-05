Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE3D6FB1;
	Tue,  5 Dec 2023 03:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl6YsXJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2C6C433C7;
	Tue,  5 Dec 2023 03:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747164;
	bh=Hvlz/QFG7Nq4VW/1MUB3KqnPwM5GQv7x+2Wl1ELNs28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl6YsXJgy+xMfTFbOAZYX96MrUsEPiPR3mWI2Jz6eUIRu/2BixTnk0oAUQdi2b4m+
	 XgXOCrCkuq+1sOygtmi8ErP7xjGhdBudCyxl2dVvVkA4i1ouGFTpz0l3zhcmlMUn5F
	 UbQc8ikD2wwjTj6c0qsxboqeS8wEC5mf26zuD9VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/107] PCI: qcom-ep: Add dedicated callback for writing to DBI2 registers
Date: Tue,  5 Dec 2023 12:16:57 +0900
Message-ID: <20231205031536.692379712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit a07d2497ed657eb2efeb967af47e22f573dcd1d6 ]

The DWC core driver exposes the write_dbi2() callback for writing to the
DBI2 registers in a vendor-specific way.

On the Qcom EP platforms, the DBI_CS2 bit in the ELBI region needs to be
asserted before writing to any DBI2 registers and deasserted once done.

So, let's implement the callback for the Qcom PCIe EP driver so that the
DBI2 writes are correctly handled in the hardware.

Without this callback, the DBI2 register writes like BAR size won't go
through and as a result, the default BAR size is set for all BARs.

[kwilczynski: commit log, renamed function to match the DWC convention]
Fixes: f55fee56a631 ("PCI: qcom-ep: Add Qualcomm PCIe Endpoint controller driver")
Suggested-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/linux-pci/20231025130029.74693-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom-ep.c b/drivers/pci/controller/dwc/pcie-qcom-ep.c
index d4c566c1c8725..1c7fd05ce0280 100644
--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -120,6 +120,7 @@
 
 /* ELBI registers */
 #define ELBI_SYS_STTS				0x08
+#define ELBI_CS2_ENABLE				0xa4
 
 /* DBI registers */
 #define DBI_CON_STATUS				0x44
@@ -252,6 +253,21 @@ static void qcom_pcie_dw_stop_link(struct dw_pcie *pci)
 	disable_irq(pcie_ep->perst_irq);
 }
 
+static void qcom_pcie_dw_write_dbi2(struct dw_pcie *pci, void __iomem *base,
+				    u32 reg, size_t size, u32 val)
+{
+	struct qcom_pcie_ep *pcie_ep = to_pcie_ep(pci);
+	int ret;
+
+	writel(1, pcie_ep->elbi + ELBI_CS2_ENABLE);
+
+	ret = dw_pcie_write(pci->dbi_base2 + reg, size, val);
+	if (ret)
+		dev_err(pci->dev, "Failed to write DBI2 register (0x%x): %d\n", reg, ret);
+
+	writel(0, pcie_ep->elbi + ELBI_CS2_ENABLE);
+}
+
 static int qcom_pcie_enable_resources(struct qcom_pcie_ep *pcie_ep)
 {
 	int ret;
@@ -446,6 +462,7 @@ static const struct dw_pcie_ops pci_ops = {
 	.link_up = qcom_pcie_dw_link_up,
 	.start_link = qcom_pcie_dw_start_link,
 	.stop_link = qcom_pcie_dw_stop_link,
+	.write_dbi2 = qcom_pcie_dw_write_dbi2,
 };
 
 static int qcom_pcie_ep_get_io_resources(struct platform_device *pdev,
-- 
2.42.0



