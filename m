Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57441DFFC;
	Mon,  1 Apr 2024 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988386; cv=none; b=X4XLM5rCQksc+Tqc9IVM///aPwozLQnt+shzRqkWSyvUEXFcZ3XX9bIt6JMat7MnC2FC4u1hvCCMrET4wu+f1xcc97UTVES/fvmtaCf2qgvE1/Ng0wjWVybdxWrGfVsDSkai86phkGlCZrBXx74o+8T6JBbyPHYBWjQlTqHE+OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988386; c=relaxed/simple;
	bh=FcQ0CaKzzFQxB7PbCaj0S0nV7YIKZRvzGRhmL5a44Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJurlJvLjHw1eSk4UH+vHNjdBBdu3vJGgEE17ZABVxj90yT1wl9zKZ+qwWWu+ngOhDYb/li7xFI9+pv3uWOBEV43+yyuq5q/Y/3XnbZIu5xBCTEO/Mko0Yce4wx9ArcjW0TAHwxcA111JL5LE57hOEEfYKO8rFEJTdCv7agRe6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LVardwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LVardwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45022C433F1;
	Mon,  1 Apr 2024 16:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988386;
	bh=FcQ0CaKzzFQxB7PbCaj0S0nV7YIKZRvzGRhmL5a44Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LVardwQPOZPCn635qm5YjRZFQ8vmBtbVRdN2CextSKwEQkn21E0fMXKtsOEo0qsX
	 GO4XUGAy3I5yk9VXGW9cflFYp5tl5w15AZFvJmId73q1pW6x4c70gk8KyRulBGzDRV
	 Um76R/CrjUx9zSX6LcKSj/2ldnc0/7lAnyORjee0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 131/432] PCI: qcom: Disable ASPM L0s for sc8280xp, sa8540p and sa8295p
Date: Mon,  1 Apr 2024 17:41:58 +0200
Message-ID: <20240401152557.038431065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit d1997c98781459f7b6d0bf1858f538f48454a97b ]

Commit 9f4f3dfad8cf ("PCI: qcom: Enable ASPM for platforms supporting
1.9.0 ops") started enabling ASPM unconditionally when the hardware
claims to support it. This triggers Correctable Errors for some PCIe
devices on machines like the Lenovo ThinkPad X13s when L0s is enabled,
which could indicate an incomplete driver ASPM implementation or that
the hardware does in fact not support L0s.

This has now been confirmed by Qualcomm to be the case for sc8280xp and
its derivate platforms (e.g. sa8540p and sa8295p). Specifically, the PHY
configuration used on these platforms is not correctly tuned for L0s and
there is currently no updated configuration available.

Add a new flag to the driver configuration data and use it to disable
ASPM L0s on sc8280xp, sa8540p and sa8295p for now.

Note that only the 1.9.0 ops enable ASPM currently.

Link: https://lore.kernel.org/r/20240306095651.4551-4-johan+linaro@kernel.org
Fixes: 9f4f3dfad8cf ("PCI: qcom: Enable ASPM for platforms supporting 1.9.0 ops")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org      # 6.7
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 31 ++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index cbc3f08817708..c995adb66b48e 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -229,6 +229,7 @@ struct qcom_pcie_ops {
 
 struct qcom_pcie_cfg {
 	const struct qcom_pcie_ops *ops;
+	bool no_l0s;
 };
 
 struct qcom_pcie {
@@ -272,6 +273,26 @@ static int qcom_pcie_start_link(struct dw_pcie *pci)
 	return 0;
 }
 
+static void qcom_pcie_clear_aspm_l0s(struct dw_pcie *pci)
+{
+	struct qcom_pcie *pcie = to_qcom_pcie(pci);
+	u16 offset;
+	u32 val;
+
+	if (!pcie->cfg->no_l0s)
+		return;
+
+	offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+
+	dw_pcie_dbi_ro_wr_en(pci);
+
+	val = readl(pci->dbi_base + offset + PCI_EXP_LNKCAP);
+	val &= ~PCI_EXP_LNKCAP_ASPM_L0S;
+	writel(val, pci->dbi_base + offset + PCI_EXP_LNKCAP);
+
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+
 static void qcom_pcie_clear_hpc(struct dw_pcie *pci)
 {
 	u16 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
@@ -961,6 +982,7 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 
 static int qcom_pcie_post_init_2_7_0(struct qcom_pcie *pcie)
 {
+	qcom_pcie_clear_aspm_l0s(pcie->pci);
 	qcom_pcie_clear_hpc(pcie->pci);
 
 	return 0;
@@ -1358,6 +1380,11 @@ static const struct qcom_pcie_cfg cfg_2_9_0 = {
 	.ops = &ops_2_9_0,
 };
 
+static const struct qcom_pcie_cfg cfg_sc8280xp = {
+	.ops = &ops_1_9_0,
+	.no_l0s = true,
+};
+
 static const struct dw_pcie_ops dw_pcie_ops = {
 	.link_up = qcom_pcie_link_up,
 	.start_link = qcom_pcie_start_link,
@@ -1629,11 +1656,11 @@ static const struct of_device_id qcom_pcie_match[] = {
 	{ .compatible = "qcom,pcie-ipq8074-gen3", .data = &cfg_2_9_0 },
 	{ .compatible = "qcom,pcie-msm8996", .data = &cfg_2_3_2 },
 	{ .compatible = "qcom,pcie-qcs404", .data = &cfg_2_4_0 },
-	{ .compatible = "qcom,pcie-sa8540p", .data = &cfg_1_9_0 },
+	{ .compatible = "qcom,pcie-sa8540p", .data = &cfg_sc8280xp },
 	{ .compatible = "qcom,pcie-sa8775p", .data = &cfg_1_9_0},
 	{ .compatible = "qcom,pcie-sc7280", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sc8180x", .data = &cfg_1_9_0 },
-	{ .compatible = "qcom,pcie-sc8280xp", .data = &cfg_1_9_0 },
+	{ .compatible = "qcom,pcie-sc8280xp", .data = &cfg_sc8280xp },
 	{ .compatible = "qcom,pcie-sdm845", .data = &cfg_2_7_0 },
 	{ .compatible = "qcom,pcie-sdx55", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sm8150", .data = &cfg_1_9_0 },
-- 
2.43.0



