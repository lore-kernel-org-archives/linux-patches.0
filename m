Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A156D168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCF3C433D2;
	Mon,  8 May 2023 11:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543769;
	bh=aZprBkywQ8QIao+70yB4yoQDZiCG2hdbtnke2ILmpyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OevdZLNos0gALxYKObTZNeIfceLqDGEcaxOc8I2ntsJtb/mff15ZvZ8uvSLof2W2e
	 mqxLdqJLPeKdwISVQTPPzjBrxkxolenHHhowWfG18Rfj0tVApe14hUFb+KxXcE2EVM
	 BWy38p6c6YC7scqPORcxiDXCXj8YnsnVD41Ollns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 178/694] arm64: dts: qcom: sm8550: Fix PCIe PHYs and controllers nodes
Date: Mon,  8 May 2023 11:40:13 +0200
Message-Id: <20230508094438.209752862@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 32734bbd1802efbd60ea4f0c3c1d5500bd0b20fe ]

First, move the pinctrl related propeties out from SoC dtsi and into the
board dts and add blank lines before status properties in the PHY nodes
to be consistent with the rest of the nodes. Then drop the pipe clock
from the controller nodes. Rename the aggre0 and aggre1 clocks to more
generic noc_aggr, and then the cnoc_pcie_sf_axi to cnoc_sf_axi. Add the
cpu-pcie interconnects to both controller nodes. Rename the pcie1 second
reset to link_down and drop the unnecessary enable-gpios. Switch the aux
clock to GCC_PCIE_1_PHY_AUX_CLK for the pcie1 PHY and drop the aux_phy
from clock-names. Also rename the nocsr reset to phy_nocsr. With this
changes we are now in line with the SC8280XP bindings.

Fixes: 7d1158c984d3 ("arm64: dts: qcom: sm8550: Add PCIe PHYs and controllers nodes")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230208180020.2761766-12-abel.vesa@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts | 10 +++++
 arch/arm64/boot/dts/qcom/sm8550.dtsi    | 52 +++++++++----------------
 2 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
index 5db6e789e6b87..44eab9308ff24 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
@@ -414,18 +414,27 @@
 &pcie0 {
 	wake-gpios = <&tlmm 96 GPIO_ACTIVE_HIGH>;
 	perst-gpios = <&tlmm 94 GPIO_ACTIVE_LOW>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie0_default_state>;
+
 	status = "okay";
 };
 
 &pcie0_phy {
 	vdda-phy-supply = <&vreg_l1e_0p88>;
 	vdda-pll-supply = <&vreg_l3e_1p2>;
+
 	status = "okay";
 };
 
 &pcie1 {
 	wake-gpios = <&tlmm 99 GPIO_ACTIVE_HIGH>;
 	perst-gpios = <&tlmm 97 GPIO_ACTIVE_LOW>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie1_default_state>;
+
 	status = "okay";
 };
 
@@ -433,6 +442,7 @@
 	vdda-phy-supply = <&vreg_l3c_0p91>;
 	vdda-pll-supply = <&vreg_l3e_1p2>;
 	vdda-qref-supply = <&vreg_l1e_0p88>;
+
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 5d0888398b3c3..ebc391bf1e4cc 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1672,25 +1672,24 @@
 					<0 0 0 3 &intc 0 0 0 151 IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 					<0 0 0 4 &intc 0 0 0 152 IRQ_TYPE_LEVEL_HIGH>; /* int_d */
 
-			clocks = <&gcc GCC_PCIE_0_PIPE_CLK>,
-				 <&gcc GCC_PCIE_0_AUX_CLK>,
+			clocks = <&gcc GCC_PCIE_0_AUX_CLK>,
 				 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_0_MSTR_AXI_CLK>,
 				 <&gcc GCC_PCIE_0_SLV_AXI_CLK>,
 				 <&gcc GCC_PCIE_0_SLV_Q2A_AXI_CLK>,
 				 <&gcc GCC_DDRSS_PCIE_SF_QTB_CLK>,
 				 <&gcc GCC_AGGRE_NOC_PCIE_AXI_CLK>;
-			clock-names = "pipe",
-				      "aux",
+			clock-names = "aux",
 				      "cfg",
 				      "bus_master",
 				      "bus_slave",
 				      "slave_q2a",
 				      "ddrss_sf_tbu",
-				      "aggre0";
+				      "noc_aggr";
 
-			interconnect-names = "pcie-mem";
-			interconnects = <&pcie_noc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>;
+			interconnects = <&pcie_noc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &cnoc_main SLAVE_PCIE_0 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			iommus = <&apps_smmu 0x1400 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
@@ -1704,12 +1703,6 @@
 			phys = <&pcie0_phy>;
 			phy-names = "pciephy";
 
-			perst-gpios = <&tlmm 94 GPIO_ACTIVE_LOW>;
-			wake-gpios = <&tlmm 96 GPIO_ACTIVE_HIGH>;
-
-			pinctrl-names = "default";
-			pinctrl-0 = <&pcie0_default_state>;
-
 			status = "disabled";
 		};
 
@@ -1771,8 +1764,7 @@
 					<0 0 0 3 &intc 0 0 0 438 IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 					<0 0 0 4 &intc 0 0 0 439 IRQ_TYPE_LEVEL_HIGH>; /* int_d */
 
-			clocks = <&gcc GCC_PCIE_1_PIPE_CLK>,
-				 <&gcc GCC_PCIE_1_AUX_CLK>,
+			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
 				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_1_MSTR_AXI_CLK>,
 				 <&gcc GCC_PCIE_1_SLV_AXI_CLK>,
@@ -1780,21 +1772,21 @@
 				 <&gcc GCC_DDRSS_PCIE_SF_QTB_CLK>,
 				 <&gcc GCC_AGGRE_NOC_PCIE_AXI_CLK>,
 				 <&gcc GCC_CNOC_PCIE_SF_AXI_CLK>;
-			clock-names = "pipe",
-				      "aux",
+			clock-names = "aux",
 				      "cfg",
 				      "bus_master",
 				      "bus_slave",
 				      "slave_q2a",
 				      "ddrss_sf_tbu",
-				      "aggre1",
-				      "cnoc_pcie_sf_axi";
+				      "noc_aggr",
+				      "cnoc_sf_axi";
 
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			interconnect-names = "pcie-mem";
-			interconnects = <&pcie_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>;
+			interconnects = <&pcie_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>,
+					<&gem_noc MASTER_APPSS_PROC 0 &cnoc_main SLAVE_PCIE_1 0>;
+			interconnect-names = "pcie-mem", "cpu-pcie";
 
 			iommus = <&apps_smmu 0x1480 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
@@ -1802,20 +1794,13 @@
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				<&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-			reset-names = "pci",
-				"pcie_1_link_down_reset";
+			reset-names = "pci", "link_down";
 
 			power-domains = <&gcc PCIE_1_GDSC>;
 
 			phys = <&pcie1_phy>;
 			phy-names = "pciephy";
 
-			perst-gpios = <&tlmm 97 GPIO_ACTIVE_LOW>;
-			enable-gpios = <&tlmm 99 GPIO_ACTIVE_HIGH>;
-
-			pinctrl-names = "default";
-			pinctrl-0 = <&pcie1_default_state>;
-
 			status = "disabled";
 		};
 
@@ -1823,18 +1808,17 @@
 			compatible = "qcom,sm8550-qmp-gen4x2-pcie-phy";
 			reg = <0x0 0x01c0e000 0x0 0x2000>;
 
-			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
+			clocks = <&gcc GCC_PCIE_1_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
 				 <&tcsr TCSR_PCIE_1_CLKREF_EN>,
 				 <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>,
-				 <&gcc GCC_PCIE_1_PIPE_CLK>,
-				 <&gcc GCC_PCIE_1_PHY_AUX_CLK>;
+				 <&gcc GCC_PCIE_1_PIPE_CLK>;
 			clock-names = "aux", "cfg_ahb", "ref", "rchng",
-				      "pipe", "aux_phy";
+				      "pipe";
 
 			resets = <&gcc GCC_PCIE_1_PHY_BCR>,
 				 <&gcc GCC_PCIE_1_NOCSR_COM_PHY_BCR>;
-			reset-names = "phy", "nocsr";
+			reset-names = "phy", "phy_nocsr";
 
 			assigned-clocks = <&gcc GCC_PCIE_1_PHY_RCHNG_CLK>;
 			assigned-clock-rates = <100000000>;
-- 
2.39.2



