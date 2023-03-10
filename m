Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C204881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359B3C4339E;
	Fri, 10 Mar 2023 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459470;
	bh=bnVtclUmmXEPzZLM9aqxdAVB6W6bbyQDnpg0zk+o3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yagY6z6fMw3WwbdtJaG08bW8x6KWhtGfShOc9FMQeXoZhQ/aVpsu0h836ucICxiGg
	 wMaeH032kjX5f92uG8Tkx6V9m0TFE6rWpWW62IIbY0EdD7J+Od672c9EFb2vLMcMbm
	 2VsIZYIWPybvPAUc47s6vJQLBgp3wFk08H4FNzTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawn.guo@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/529] arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes
Date: Fri, 10 Mar 2023 14:32:38 +0100
Message-Id: <20230310133805.721755344@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 942bcd33ed455ad40b71a59901bd926bbf4a500e ]

IPQ8074 PCIe PHY nodes are broken in the many ways:

- '#address-cells', '#size-cells' and 'ranges' are missing.
- Child phy/lane node is missing, and the child properties like
  '#phy-cells' and 'clocks' are mistakenly put into parent node.
- The clocks properties for parent node are missing.

Fix them to get the nodes comply with the bindings schema.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210929034253.24570-9-shawn.guo@linaro.org
Stable-dep-of: 7ba33591b45f ("arm64: dts: qcom: ipq8074: fix Gen3 PCIe QMP PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 46 +++++++++++++++++++++------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 9114402c044b3..5b17dbefe5cfd 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -167,34 +167,60 @@ qusb_phy_0: phy@79000 {
 			resets = <&gcc GCC_QUSB2_0_PHY_BCR>;
 		};
 
-		pcie_phy0: phy@86000 {
+		pcie_qmp0: phy@86000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
 			reg = <0x00086000 0x1000>;
-			#phy-cells = <0>;
-			clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
-			clock-names = "pipe_clk";
-			clock-output-names = "pcie20_phy0_pipe_clk";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
 
+			clocks = <&gcc GCC_PCIE0_AUX_CLK>,
+				<&gcc GCC_PCIE0_AHB_CLK>;
+			clock-names = "aux", "cfg_ahb";
 			resets = <&gcc GCC_PCIE0_PHY_BCR>,
 				<&gcc GCC_PCIE0PHY_PHY_BCR>;
 			reset-names = "phy",
 				      "common";
 			status = "disabled";
+
+			pcie_phy0: phy@86200 {
+				reg = <0x86200 0x16c>,
+				      <0x86400 0x200>,
+				      <0x86800 0x4f4>;
+				#phy-cells = <0>;
+				#clock-cells = <0>;
+				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
+				clock-names = "pipe0";
+				clock-output-names = "pcie_0_pipe_clk";
+			};
 		};
 
-		pcie_phy1: phy@8e000 {
+		pcie_qmp1: phy@8e000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
 			reg = <0x0008e000 0x1000>;
-			#phy-cells = <0>;
-			clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
-			clock-names = "pipe_clk";
-			clock-output-names = "pcie20_phy1_pipe_clk";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
 
+			clocks = <&gcc GCC_PCIE1_AUX_CLK>,
+				<&gcc GCC_PCIE1_AHB_CLK>;
+			clock-names = "aux", "cfg_ahb";
 			resets = <&gcc GCC_PCIE1_PHY_BCR>,
 				<&gcc GCC_PCIE1PHY_PHY_BCR>;
 			reset-names = "phy",
 				      "common";
 			status = "disabled";
+
+			pcie_phy1: phy@8e200 {
+				reg = <0x8e200 0x16c>,
+				      <0x8e400 0x200>,
+				      <0x8e800 0x4f4>;
+				#phy-cells = <0>;
+				#clock-cells = <0>;
+				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
+				clock-names = "pipe0";
+				clock-output-names = "pcie_1_pipe_clk";
+			};
 		};
 
 		tlmm: pinctrl@1000000 {
-- 
2.39.2



