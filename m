Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3653184101;
	Tue, 10 Sep 2024 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961911; cv=none; b=VZiLgcE47Hz7HU7zw7/vY3MSv7UAzIk3YQ2dvxf2/EiaPt+tQOctkWJvVnv1412gknS8CTcxm9s5coR8uRrqL0EsEJClmc/dV+XgEss1VdWJnxUORGJA02jA4e0HxVJi0tKZU4GKq23JrDhzp28OfLuQU6vUDS6guKnNGIpXtYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961911; c=relaxed/simple;
	bh=mrY6uPgwX5m8f0dUv+0BrP4ivg3jneYiSOnu5moyjpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcKh4NqzsdWR8nvw3yEPEhoSBdekdm4ef3wi60rL4K+dZRwtfz72sPQfXjJ7VrlVVOhGjRk0CuwcioT3JEX0cGH2NmWlFrOLYE1A3C7P2fUMmGymrBBYCE8kk6Gu3EGVvGF3OkCNC5dyHEpqFLxnua6S+Y5oeoE8YS7lXhIs7qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCXA9PB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCXA9PB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6569C4CEC6;
	Tue, 10 Sep 2024 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961911;
	bh=mrY6uPgwX5m8f0dUv+0BrP4ivg3jneYiSOnu5moyjpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCXA9PB9k/IqjPRkUgZqKM2BDkRJdzR5c6Ej1NyzjWnMOR4+vVTLTptb6RVUVqF0/
	 Su1Lkil47xtt1ugp1OWjWCwobK+AkccZOYuDjNIFc1QGPsXKwGV+sQ9tR75y1TaF0M
	 HLxhAarRA98sQ1cv3XdnOh3z5uw32RYmQNSWQejg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 231/375] PCI: qcom: Override NO_SNOOP attribute for SA8775P RC
Date: Tue, 10 Sep 2024 11:30:28 +0200
Message-ID: <20240910092630.301115867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mrinmay Sarkar <quic_msarkar@quicinc.com>

[ Upstream commit 1d648bf79d4dca909f242b1a0cdc458e4f9d0253 ]

Due to some hardware changes, SA8775P has set the NO_SNOOP attribute
in its TLP for all the PCIe controllers. NO_SNOOP attribute when set,
the requester is indicating that no cache coherency issue exist for
the addressed memory on the endpoint i.e., memory is not cached. But
in reality, requester cannot assume this unless there is a complete
control/visibility over the addressed memory on the endpoint.

And worst case, if the memory is cached on the endpoint, it may lead to
memory corruption issues. It should be noted that the caching of memory
on the endpoint is not solely dependent on the NO_SNOOP attribute in TLP.

So to avoid the corruption, this patch overrides the NO_SNOOP attribute
by setting the PCIE_PARF_NO_SNOOP_OVERIDE register. This patch is not
needed for other upstream supported platforms since they do not set
NO_SNOOP attribute by default.

8775 has IP version 1.34.0 so introduce a new cfg(cfg_1_34_0) for this
platform. Assign override_no_snoop flag into struct qcom_pcie_cfg and
set it true in cfg_1_34_0 and enable cache snooping if this particular
flag is true.

Link: https://lore.kernel.org/linux-pci/1710166298-27144-2-git-send-email-quic_msarkar@quicinc.com
Signed-off-by: Mrinmay Sarkar <quic_msarkar@quicinc.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: wrap comments to fit in 80 columns]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 14772edcf0d3..7fa1fe5a29e3 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -51,6 +51,7 @@
 #define PARF_SID_OFFSET				0x234
 #define PARF_BDF_TRANSLATE_CFG			0x24c
 #define PARF_SLV_ADDR_SPACE_SIZE		0x358
+#define PARF_NO_SNOOP_OVERIDE			0x3d4
 #define PARF_DEVICE_TYPE			0x1000
 #define PARF_BDF_TO_SID_TABLE_N			0x2000
 #define PARF_BDF_TO_SID_CFG			0x2c00
@@ -118,6 +119,10 @@
 /* PARF_LTSSM register fields */
 #define LTSSM_EN				BIT(8)
 
+/* PARF_NO_SNOOP_OVERIDE register fields */
+#define WR_NO_SNOOP_OVERIDE_EN			BIT(1)
+#define RD_NO_SNOOP_OVERIDE_EN			BIT(3)
+
 /* PARF_DEVICE_TYPE register fields */
 #define DEVICE_TYPE_RC				0x4
 
@@ -231,8 +236,15 @@ struct qcom_pcie_ops {
 	int (*config_sid)(struct qcom_pcie *pcie);
 };
 
+ /**
+  * struct qcom_pcie_cfg - Per SoC config struct
+  * @ops: qcom PCIe ops structure
+  * @override_no_snoop: Override NO_SNOOP attribute in TLP to enable cache
+  * snooping
+  */
 struct qcom_pcie_cfg {
 	const struct qcom_pcie_ops *ops;
+	bool override_no_snoop;
 	bool no_l0s;
 };
 
@@ -986,6 +998,12 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 
 static int qcom_pcie_post_init_2_7_0(struct qcom_pcie *pcie)
 {
+	const struct qcom_pcie_cfg *pcie_cfg = pcie->cfg;
+
+	if (pcie_cfg->override_no_snoop)
+		writel(WR_NO_SNOOP_OVERIDE_EN | RD_NO_SNOOP_OVERIDE_EN,
+				pcie->parf + PARF_NO_SNOOP_OVERIDE);
+
 	qcom_pcie_clear_aspm_l0s(pcie->pci);
 	qcom_pcie_clear_hpc(pcie->pci);
 
@@ -1366,6 +1384,11 @@ static const struct qcom_pcie_cfg cfg_1_9_0 = {
 	.ops = &ops_1_9_0,
 };
 
+static const struct qcom_pcie_cfg cfg_1_34_0 = {
+	.ops = &ops_1_9_0,
+	.override_no_snoop = true,
+};
+
 static const struct qcom_pcie_cfg cfg_2_1_0 = {
 	.ops = &ops_2_1_0,
 };
@@ -1667,7 +1690,7 @@ static const struct of_device_id qcom_pcie_match[] = {
 	{ .compatible = "qcom,pcie-msm8996", .data = &cfg_2_3_2 },
 	{ .compatible = "qcom,pcie-qcs404", .data = &cfg_2_4_0 },
 	{ .compatible = "qcom,pcie-sa8540p", .data = &cfg_sc8280xp },
-	{ .compatible = "qcom,pcie-sa8775p", .data = &cfg_1_9_0},
+	{ .compatible = "qcom,pcie-sa8775p", .data = &cfg_1_34_0},
 	{ .compatible = "qcom,pcie-sc7280", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sc8180x", .data = &cfg_1_9_0 },
 	{ .compatible = "qcom,pcie-sc8280xp", .data = &cfg_sc8280xp },
-- 
2.43.0



