Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9933CFD;
	Fri, 24 Nov 2023 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srow3AV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DD5C433C7;
	Fri, 24 Nov 2023 18:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849858;
	bh=VlqlKH0J476LlKxUcqr95kjNoSyu8flBomBCTcsevMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srow3AV71+lNzq1aciSsluWMLj8XFHTn3blrAR/GZQfDHsu7+9f/QcPBhLSXUfpXx
	 I5cv4zN+USIrf939F6EwDSJtshkRdOrJammd/E2znzGF8sF8yojmRwhVDwSJDA7FKJ
	 FyIPaA06aYQalKRiv8R7sxFXZP+iRv0jb+Gmhq+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 324/530] PCI: qcom-ep: Add dedicated callback for writing to DBI2 registers
Date: Fri, 24 Nov 2023 17:48:10 +0000
Message-ID: <20231124172037.896453284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a07d2497ed657eb2efeb967af47e22f573dcd1d6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom-ep.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-qcom-ep.c
+++ b/drivers/pci/controller/dwc/pcie-qcom-ep.c
@@ -123,6 +123,7 @@
 
 /* ELBI registers */
 #define ELBI_SYS_STTS				0x08
+#define ELBI_CS2_ENABLE				0xa4
 
 /* DBI registers */
 #define DBI_CON_STATUS				0x44
@@ -263,6 +264,21 @@ static void qcom_pcie_dw_stop_link(struc
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
 static void qcom_pcie_ep_icc_update(struct qcom_pcie_ep *pcie_ep)
 {
 	struct dw_pcie *pci = &pcie_ep->pci;
@@ -519,6 +535,7 @@ static const struct dw_pcie_ops pci_ops
 	.link_up = qcom_pcie_dw_link_up,
 	.start_link = qcom_pcie_dw_start_link,
 	.stop_link = qcom_pcie_dw_stop_link,
+	.write_dbi2 = qcom_pcie_dw_write_dbi2,
 };
 
 static int qcom_pcie_ep_get_io_resources(struct platform_device *pdev,


