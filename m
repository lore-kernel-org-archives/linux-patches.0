Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1514063128;
	Tue, 23 Jan 2024 01:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974997; cv=none; b=g7JUyOJYxF4BsIVpt6bNPg7c2rc1hH/KIxBVG93Ql0n3DorBgeJGL97QPVvYoe+g0au1xW4x+K2oyNNUPDIXRzvn9eBxM+4E2SumoSioof1Boc8yPHpnH+I83x56DflWyt8nmqhX4VF+By80qiehLoto9HhTm11PguyjSkYhgJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974997; c=relaxed/simple;
	bh=EzUhd3PlUGiSLd9Qean1egyxdGX3fdy6ueYQr3yLXfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9sYsZgXUlNGp1HlIGaQOHk23D15AYHX0JvJDF4Fx9bRBTrEKUiEqSFs8MCkTp7qbuguYRkYcvIs3ODM/fZwMf6W4L3FU7yejNsLBw5ELIkkeOvI45Cmmfd2u6QOLI7QV2WtK1LCjF8LNWLQCW7q1W7ZFqjo+opTIqEEX+aqlxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dx94pEWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dx94pEWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833C9C43394;
	Tue, 23 Jan 2024 01:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974996;
	bh=EzUhd3PlUGiSLd9Qean1egyxdGX3fdy6ueYQr3yLXfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dx94pEWGRd6GhFrLkdKD2p3Eo7hav0z0lOlkCsYvrZGh78hH6CGVv24z0dOE0DhgQ
	 imTYoHeLbyggEHS7hWcAdzC7HHYivIgpagwSKcy/rH0ezHK06/5ykSgXSVXBPtu2Zz
	 8re+SPqD9Hsq5qYQRnM9qviFKvCAqxUbpQplKuME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/583] arm64: dts: qcom: sc8180x: switch PCIe QMP PHY to new style of bindings
Date: Mon, 22 Jan 2024 15:53:57 -0800
Message-ID: <20240122235817.692176817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a6546460ca439bade19d64eb63cee2d97c29fb72 ]

Change the PCIe QMP PHY to use newer style of QMP PHY bindings (single
resource region, no per-PHY subnodes). While we are at it, rename PHY
nodes to `phy@`.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230820142035.89903-13-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 78403b37f677 ("arm64: dts: qcom: sc8180x: Fix up PCIe nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 148 ++++++++++----------------
 1 file changed, 55 insertions(+), 93 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 0d85bdec5a82..dfaeb337960e 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1749,24 +1749,29 @@ pcie0: pci@1c00000 {
 					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			phys = <&pcie0_lane>;
+			phys = <&pcie0_phy>;
 			phy-names = "pciephy";
 			dma-coherent;
 
 			status = "disabled";
 		};
 
-		pcie0_phy: phy-wrapper@1c06000 {
+		pcie0_phy: phy@1c06000 {
 			compatible = "qcom,sc8180x-qmp-pcie-phy";
-			reg = <0 0x1c06000 0 0x1c0>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			reg = <0 0x01c06000 0 0x1000>;
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_0_CLKREF_CLK>,
-				 <&gcc GCC_PCIE1_PHY_REFGEN_CLK>;
-			clock-names = "aux", "cfg_ahb", "ref", "refgen";
+				 <&gcc GCC_PCIE1_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE_0_PIPE_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "refgen",
+				      "pipe";
+			#clock-cells = <0>;
+			clock-output-names = "pcie_0_pipe_clk";
+			#phy-cells = <0>;
 
 			resets = <&gcc GCC_PCIE_0_PHY_BCR>;
 			reset-names = "phy";
@@ -1775,21 +1780,6 @@ pcie0_phy: phy-wrapper@1c06000 {
 			assigned-clock-rates = <100000000>;
 
 			status = "disabled";
-
-			pcie0_lane: phy@1c06200 {
-				reg = <0 0x1c06200 0 0x170>, /* tx0 */
-				      <0 0x1c06400 0 0x200>, /* rx0 */
-				      <0 0x1c06a00 0 0x1f0>, /* pcs */
-				      <0 0x1c06600 0 0x170>, /* tx1 */
-				      <0 0x1c06800 0 0x200>, /* rx1 */
-				      <0 0x1c06e00 0 0xf4>; /* pcs_com */
-				clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
-				clock-names = "pipe0";
-
-				#clock-cells = <0>;
-				clock-output-names = "pcie_0_pipe_clk";
-				#phy-cells = <0>;
-			};
 		};
 
 		pcie3: pci@1c08000 {
@@ -1857,24 +1847,30 @@ pcie3: pci@1c08000 {
 					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			phys = <&pcie3_lane>;
+			phys = <&pcie3_phy>;
 			phy-names = "pciephy";
 			dma-coherent;
 
 			status = "disabled";
 		};
 
-		pcie3_phy: phy-wrapper@1c0c000 {
+		pcie3_phy: phy@1c0c000 {
 			compatible = "qcom,sc8180x-qmp-pcie-phy";
-			reg = <0 0x1c0c000 0 0x1c0>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			reg = <0 0x01c0c000 0 0x1000>;
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_3_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_3_CLKREF_CLK>,
-				 <&gcc GCC_PCIE2_PHY_REFGEN_CLK>;
-			clock-names = "aux", "cfg_ahb", "ref", "refgen";
+				 <&gcc GCC_PCIE2_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE_3_PIPE_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "refgen",
+				      "pipe";
+			#clock-cells = <0>;
+			clock-output-names = "pcie_3_pipe_clk";
+
+			#phy-cells = <0>;
 
 			resets = <&gcc GCC_PCIE_3_PHY_BCR>;
 			reset-names = "phy";
@@ -1883,21 +1879,6 @@ pcie3_phy: phy-wrapper@1c0c000 {
 			assigned-clock-rates = <100000000>;
 
 			status = "disabled";
-
-			pcie3_lane: phy@1c0c200 {
-				reg = <0 0x1c0c200 0 0x170>, /* tx0 */
-				      <0 0x1c0c400 0 0x200>, /* rx0 */
-				      <0 0x1c0ca00 0 0x1f0>, /* pcs */
-				      <0 0x1c0c600 0 0x170>, /* tx1 */
-				      <0 0x1c0c800 0 0x200>, /* rx1 */
-				      <0 0x1c0ce00 0 0xf4>; /* pcs_com */
-				clocks = <&gcc GCC_PCIE_3_PIPE_CLK>;
-				clock-names = "pipe0";
-
-				#clock-cells = <0>;
-				clock-output-names = "pcie_3_pipe_clk";
-				#phy-cells = <0>;
-			};
 		};
 
 		pcie1: pci@1c10000 {
@@ -1965,24 +1946,30 @@ pcie1: pci@1c10000 {
 					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			phys = <&pcie1_lane>;
+			phys = <&pcie1_phy>;
 			phy-names = "pciephy";
 			dma-coherent;
 
 			status = "disabled";
 		};
 
-		pcie1_phy: phy-wrapper@1c16000 {
+		pcie1_phy: phy@1c16000 {
 			compatible = "qcom,sc8180x-qmp-pcie-phy";
-			reg = <0 0x1c16000 0 0x1c0>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			reg = <0 0x01c16000 0 0x1000>;
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_1_CLKREF_CLK>,
-				 <&gcc GCC_PCIE1_PHY_REFGEN_CLK>;
-			clock-names = "aux", "cfg_ahb", "ref", "refgen";
+				 <&gcc GCC_PCIE1_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE_1_PIPE_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "refgen",
+				      "pipe";
+			#clock-cells = <0>;
+			clock-output-names = "pcie_1_pipe_clk";
+
+			#phy-cells = <0>;
 
 			resets = <&gcc GCC_PCIE_1_PHY_BCR>;
 			reset-names = "phy";
@@ -1991,21 +1978,6 @@ pcie1_phy: phy-wrapper@1c16000 {
 			assigned-clock-rates = <100000000>;
 
 			status = "disabled";
-
-			pcie1_lane: phy@1c0e200 {
-				reg = <0 0x1c16200 0 0x170>, /* tx0 */
-				      <0 0x1c16400 0 0x200>, /* rx0 */
-				      <0 0x1c16a00 0 0x1f0>, /* pcs */
-				      <0 0x1c16600 0 0x170>, /* tx1 */
-				      <0 0x1c16800 0 0x200>, /* rx1 */
-				      <0 0x1c16e00 0 0xf4>; /* pcs_com */
-				clocks = <&gcc GCC_PCIE_1_PIPE_CLK>;
-				clock-names = "pipe0";
-				#clock-cells = <0>;
-				clock-output-names = "pcie_1_pipe_clk";
-
-				#phy-cells = <0>;
-			};
 		};
 
 		pcie2: pci@1c18000 {
@@ -2073,24 +2045,30 @@ pcie2: pci@1c18000 {
 					<&gem_noc MASTER_AMPSS_M0 0 &config_noc SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			phys = <&pcie2_lane>;
+			phys = <&pcie2_phy>;
 			phy-names = "pciephy";
 			dma-coherent;
 
 			status = "disabled";
 		};
 
-		pcie2_phy: phy-wrapper@1c1c000 {
+		pcie2_phy: phy@1c1c000 {
 			compatible = "qcom,sc8180x-qmp-pcie-phy";
-			reg = <0 0x1c1c000 0 0x1c0>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			reg = <0 0x01c1c000 0 0x1000>;
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_2_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_2_CLKREF_CLK>,
-				 <&gcc GCC_PCIE2_PHY_REFGEN_CLK>;
-			clock-names = "aux", "cfg_ahb", "ref", "refgen";
+				 <&gcc GCC_PCIE2_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE_2_PIPE_CLK>;
+			clock-names = "aux",
+				      "cfg_ahb",
+				      "ref",
+				      "refgen",
+				      "pipe";
+			#clock-cells = <0>;
+			clock-output-names = "pcie_3_pipe_clk";
+
+			#phy-cells = <0>;
 
 			resets = <&gcc GCC_PCIE_2_PHY_BCR>;
 			reset-names = "phy";
@@ -2099,22 +2077,6 @@ pcie2_phy: phy-wrapper@1c1c000 {
 			assigned-clock-rates = <100000000>;
 
 			status = "disabled";
-
-			pcie2_lane: phy@1c0e200 {
-				reg = <0 0x1c1c200 0 0x170>, /* tx0 */
-				      <0 0x1c1c400 0 0x200>, /* rx0 */
-				      <0 0x1c1ca00 0 0x1f0>, /* pcs */
-				      <0 0x1c1c600 0 0x170>, /* tx1 */
-				      <0 0x1c1c800 0 0x200>, /* rx1 */
-				      <0 0x1c1ce00 0 0xf4>; /* pcs_com */
-				clocks = <&gcc GCC_PCIE_2_PIPE_CLK>;
-				clock-names = "pipe0";
-
-				#clock-cells = <0>;
-				clock-output-names = "pcie_2_pipe_clk";
-
-				#phy-cells = <0>;
-			};
 		};
 
 		ufs_mem_hc: ufshc@1d84000 {
-- 
2.43.0



