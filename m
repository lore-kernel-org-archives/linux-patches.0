Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D83370AE5;
	Wed, 20 May 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295475; cv=none; b=aAsurBpwKd97s/w880nv9zWNT5rNdgHOuyH1+UcBpZ7BCyMO6RrVnISsTKG0OOGLkwAL8WKYKLApl7GjixTKbngCJWaC0w+ulaj1b3YXqOGRLJajRbRJtidGEwdtZx+ePcCogS8NeNwGZMidAEkYU590x5QalXouDsl1gE+O5Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295475; c=relaxed/simple;
	bh=ZM5+D/8DfVgBEEGAOQ2Pggf76laI8WoSp2T6QNDirjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShHBhHfCY7R5gJhE/bBK37w0ouQyNbfHfy4lasf6/1bm0KDoBB8c5tUY1MnN6RN4wkPSPYH7r1z2n6cCTgUmQ8/LNpfiQVVBNCRr1QH6Ahb5EJCiR7J9Dz6eNnIFlUlmxF+wanvx/pkb7RoEiWziEr0Z+u0M/16jP11DZkZKWHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMpdVMaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMpdVMaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0111F000E9;
	Wed, 20 May 2026 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295474;
	bh=LD8AtAAMItB8tw1CFP+vgGFTPiIwh1yE032oC9X0FhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMpdVMaHjgJiCm9jHT2rDAc0Lx7Ob8rMJK8AP5uqlPaA1cwUnst7THhMCMECum0kB
	 QHplNldGTsRkEmrQU56hKZe+ZnpIlNE3Q4tM6eEiaFBSpKxWVNF67jMkHL0r9wmS0P
	 2y44bTe+S0YLGS3g/uU5AfbjM8sYUkT9UbgEp/K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0393/1146] PCI: imx6: Keep Root Port MSI capability with iMSI-RX to work around hardware bug
Date: Wed, 20 May 2026 18:10:43 +0200
Message-ID: <20260520162157.093572938@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 3a4e8302e72f83fd5cc8a916fc6f5c8fe5c8690e ]

On NXP i.MX7D, i.MX8MM, and i.MX8MQ chipsets, MSIs from the endpoints won't
be received by the iMSI-RX MSI controller if the Root Port MSI capability
is disabled.

Even though the Root Port MSIs won't be received by the iMSI-RX controller
due to design, these chipsets have some weird hardware bug that prevents
the endpoint MSIs from reaching when the Root Port MSI capability is
disabled.

Hence, introduce a new flag, 'dw_pcie_rp::keep_rp_msi_en', set it for the
above mentioned SoCs, and always keep the Root Port MSI capability when
this flag is set.

Note that by keeping Root Port MSI capability, Root Port MSIs such as AER,
PME and others won't be received by default. So users need to use
workarounds such as passing 'pcie_pme=nomsi' cmdline param.

Fixes: f5cd8a929c825 ("PCI: dwc: Remove MSI/MSIX capability for Root Port if iMSI-RX is used as MSI controller")
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: fix typos]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260331085252.1243108-1-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c             | 7 +++++++
 drivers/pci/controller/dwc/pcie-designware-host.c | 2 +-
 drivers/pci/controller/dwc/pcie-designware.h      | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 2aa5467d5400a..0a494c9dd6aa1 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -117,6 +117,8 @@ enum imx_pcie_variants {
 #define IMX_PCIE_FLAG_HAS_LUT			BIT(10)
 #define IMX_PCIE_FLAG_8GT_ECN_ERR051586		BIT(11)
 #define IMX_PCIE_FLAG_SKIP_L23_READY		BIT(12)
+/* Preserve MSI capability for platforms that require it */
+#define IMX_PCIE_FLAG_KEEP_MSI_CAP		BIT(13)
 
 #define imx_check_flag(pci, val)	(pci->drvdata->flags & val)
 
@@ -1830,6 +1832,8 @@ static int imx_pcie_probe(struct platform_device *pdev)
 	} else {
 		if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_SKIP_L23_READY))
 			pci->pp.skip_l23_ready = true;
+		if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_KEEP_MSI_CAP))
+			pci->pp.keep_rp_msi_en = true;
 		pci->pp.use_atu_msg = true;
 		ret = dw_pcie_host_init(&pci->pp);
 		if (ret < 0)
@@ -1908,6 +1912,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 	[IMX7D] = {
 		.variant = IMX7D,
 		.flags = IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP |
 			 IMX_PCIE_FLAG_HAS_APP_RESET |
 			 IMX_PCIE_FLAG_SKIP_L23_READY |
 			 IMX_PCIE_FLAG_HAS_PHY_RESET,
@@ -1920,6 +1925,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 	[IMX8MQ] = {
 		.variant = IMX8MQ,
 		.flags = IMX_PCIE_FLAG_HAS_APP_RESET |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP |
 			 IMX_PCIE_FLAG_HAS_PHY_RESET |
 			 IMX_PCIE_FLAG_SUPPORTS_SUSPEND,
 		.gpr = "fsl,imx8mq-iomuxc-gpr",
@@ -1934,6 +1940,7 @@ static const struct imx_pcie_drvdata drvdata[] = {
 	[IMX8MM] = {
 		.variant = IMX8MM,
 		.flags = IMX_PCIE_FLAG_SUPPORTS_SUSPEND |
+			 IMX_PCIE_FLAG_KEEP_MSI_CAP |
 			 IMX_PCIE_FLAG_HAS_PHYDRV |
 			 IMX_PCIE_FLAG_HAS_APP_RESET,
 		.gpr = "fsl,imx8mm-iomuxc-gpr",
diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index c3c2dec728eea..6adde3fc32be9 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1171,7 +1171,7 @@ int dw_pcie_setup_rc(struct dw_pcie_rp *pp)
 	 * the MSI and MSI-X capabilities of the Root Port to allow the drivers
 	 * to fall back to INTx instead.
 	 */
-	if (pp->use_imsi_rx) {
+	if (pp->use_imsi_rx && !pp->keep_rp_msi_en) {
 		dw_pcie_remove_capability(pci, PCI_CAP_ID_MSI);
 		dw_pcie_remove_capability(pci, PCI_CAP_ID_MSIX);
 	}
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index ae6389dd9caa5..b12c5334552c7 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -421,6 +421,7 @@ struct dw_pcie_host_ops {
 
 struct dw_pcie_rp {
 	bool			use_imsi_rx:1;
+	bool			keep_rp_msi_en:1;
 	bool			cfg0_io_shared:1;
 	u64			cfg0_base;
 	void __iomem		*va_cfg0_base;
-- 
2.53.0



