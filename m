Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9685B31F9B1;
	Sat, 12 Sep 2026 16:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230347; cv=none; b=Enwxt/GzF6o30N3cGZAew/Aa1FoMagzDDQ6bGrhitN9SoQHoSPAmzmFb8Wx9wStqlT8dKtlDunQuXOv+w3mZ7gPQRjBla7OfrSZU9zmnXeDWidte4zqee476QG4gR3BCwRXGp+cHn7fcGhl5zoh33fiAxpo6/r/MlsYw9odjfx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230347; c=relaxed/simple;
	bh=DNX+KGpcVCJNOoLptDkx52vSNaWFiPD8BHogsj/QvJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYwnuNRidaa8MVomLYIJEHqQkY+EQuwAtMbsoeyNiTslr8r22lvUNbJF6EG3bspC+IcYGP84idN2ZyHEvT2sxzQR1vIylJjMAAHg1XcNfgvHtmi50nNFI/8+svkAB0qW6zr41FYDIolxxdzEgbTn1cH2AGkeXbu+faGAtIAHJcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQRgWo2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQRgWo2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427D11F00893;
	Sat, 12 Sep 2026 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230346;
	bh=51bRbEHOdI1LTnbwCT3H5J0osEgbCHFHRiOreIyoviI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQRgWo2xMVzydG+UiZPSUmsRqgzfXndlj9OLn2cSoVmWI+lH3Q5hbK6eoZOgwkMRh
	 xcYg06U4crQVmhaz2LsIOVnwLdjnVJv3lcF2AqyI3fkmjoW6nY+W2MLeolhRp58Fu+
	 fCqDbonvPM2Ft9QOJ1rHFQh52iHsal8KBz9SD9Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0774/1191] arm64: dts: qcom: Remove "iommus" property from PCIe nodes
Date: Sat, 12 Sep 2026 08:58:22 +0200
Message-ID: <20260912065605.660472952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 6340b391e15094575911ab0d96bfff09deadafba ]

Currently, most of the Qualcomm SoCs specify both "iommus" and "iommu-map"
properties for the PCIe nodes. First one passes the SMR mask to the iommu
driver and the latter specifies the SID for each PCIe device.

But with "iommus" property, the PCIe controller will be added to the
iommu group along with the devices. This makes no sense because the
controller will not initiate any DMA transaction on its own. And moreover,
it is not strictly required to pass the SMR mask to the iommu driver. If
the "iommus" property is not present, then the default mask of "0" would be
used which should work for all PCIe devices.

On the other side, if the SMR mask specified doesn't match the one expected
by the hypervisor, then all the PCIe transactions will end up triggering
"Unidentified Stream Fault" by the SMMU.

So to get rid of these hassles and also prohibit PCIe controllers from
adding to the iommu group, let's remove the "iommus" property from PCIe
nodes.

Reported-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/linux-arm-msm/20230227195535.GA749409-robh@kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308075648.134119-1-manivannan.sadhasivam@linaro.org
Stable-dep-of: deaea7e982bc ("arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 --
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 --
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 --
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 3 ---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 --
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 --
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 --
 7 files changed, 15 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index b778728390e53..2292f21d5a30f 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2089,8 +2089,6 @@ pcie1: pci@1c08000 {
 
 			dma-coherent;
 
-			iommus = <&apps_smmu 0x1c80 0x1>;
-
 			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
 				    <0x100 &apps_smmu 0x1c81 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 015239ed42a76..71d2ecbec22b0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2254,7 +2254,6 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommus = <&apps_smmu 0x1c10 0xf>;
 			iommu-map = <0x0   &apps_smmu 0x1c10 0x1>,
 				    <0x100 &apps_smmu 0x1c11 0x1>,
 				    <0x200 &apps_smmu 0x1c12 0x1>,
@@ -2364,7 +2363,6 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1c00 0xf>;
 			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
 				    <0x100 &apps_smmu 0x1c01 0x1>,
 				    <0x200 &apps_smmu 0x1c02 0x1>,
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index bbd322fc56460..9168173dd0e3e 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1810,7 +1810,6 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommus = <&apps_smmu 0x1d80 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
 				    <0x100 &apps_smmu 0x1d81 0x1>;
 
@@ -1913,7 +1912,6 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1e00 0x3f>;
 			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
 				    <0x100 &apps_smmu 0x1e01 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index ba912e03441ef..fbda1925f8e03 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1850,7 +1850,6 @@ pcie0: pci@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommus = <&apps_smmu 0x1c00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
 				    <0x100 &apps_smmu 0x1c01 0x1>;
 
@@ -1957,7 +1956,6 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1c80 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
 				    <0x100 &apps_smmu 0x1c81 0x1>;
 
@@ -2066,7 +2064,6 @@ pcie2: pci@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1d00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
 				    <0x100 &apps_smmu 0x1d01 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 06b44e3c021a1..1fc8caac9b12f 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1635,7 +1635,6 @@ pcie0: pci@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommus = <&apps_smmu 0x1c00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
 				    <0x100 &apps_smmu 0x1c01 0x1>;
 
@@ -1719,7 +1718,6 @@ pcie1: pci@1c08000 {
 				      "ddrss_sf_tbu",
 				      "aggre1";
 
-			iommus = <&apps_smmu 0x1c80 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
 				    <0x100 &apps_smmu 0x1c81 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index c9ca7bd886397..653998706b7ff 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1759,7 +1759,6 @@ pcie0: pci@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommus = <&apps_smmu 0x1c00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
 				    <0x100 &apps_smmu 0x1c01 0x1>;
 
@@ -1866,7 +1865,6 @@ pcie1: pci@1c08000 {
 				      "ddrss_sf_tbu",
 				      "aggre1";
 
-			iommus = <&apps_smmu 0x1c80 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
 				    <0x100 &apps_smmu 0x1c81 0x1>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 93b70cbbeb203..0734db09fbae6 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1416,7 +1416,6 @@ pcie0: pci@1c00000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>;
 
-			iommus = <&apps_smmu 0x1400 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
 				    <0x100 &apps_smmu 0x1401 0x1>;
 
@@ -1520,7 +1519,6 @@ pcie1: pci@1c08000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>;
 
-			iommus = <&apps_smmu 0x1480 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
 				    <0x100 &apps_smmu 0x1481 0x1>;
 
-- 
2.53.0



