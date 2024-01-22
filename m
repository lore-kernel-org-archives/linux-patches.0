Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179DB14D450;
	Tue, 23 Jan 2024 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969359; cv=none; b=lf7e+Rb20oEryAHxeL9OXjtfBqwx0tnhU9t5/WWu9FM9QTUM+5kAY3uUfa9HSaGqzV9jy4sTXASSrpUXwOmdJznlYrVseSZnjuicvwRlv9367wnAUPUS0FF83b4JB/sjZcyPZ1d8Uiiyb2Y/2d3yMuio6I0GU4BJKRlSArkcpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969359; c=relaxed/simple;
	bh=Hz6WutdHYTF7x6Xb+DFSvckWRbWgbzwTj1gWVvEBbH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqSSC/nP01vUEaOhtdXFOL3OKC8H0Mbmt6nDmstLbMTJw274f34HPMV8Z4u7+8wjPMIH3oTctcTyXeLbAycI4afK6GYHJjkPGtWDxjvNCskC+PVhtUxQ/5Aflz3yA9MQdc8goCUcCW3WgWohMsdnBSA8ya+Gd4Ollq0e1kMC/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THpsdSiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THpsdSiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5F3C43394;
	Tue, 23 Jan 2024 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969358;
	bh=Hz6WutdHYTF7x6Xb+DFSvckWRbWgbzwTj1gWVvEBbH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THpsdSiI9rvY7vb/gCMNmdUc9s9upJ5SVc9dOx3eRvpVvwNozkAHxwl9OvPkkR177
	 kVcv+otYRQAwSA/rNiduuHlXUr9O9//i28qDVBtEAcI90pbNx4QO0TTH84bP3cQlum
	 jcbvUmc9xZW0TBpNFTeBbnaeU8pAJBvfKFhk/q28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 194/641] arm64: dts: qcom: sm6375: Hook up MPM
Date: Mon, 22 Jan 2024 15:51:38 -0800
Message-ID: <20240122235824.041523329@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit d3246a0cf43fd24a1986163284edd2389143809d ]

Add a node for MPM and wire it up on consumers that use it. This also
fixes a very bad and sad assumption I made when initially porting this
SoC that the downstream MPM-TLMM mappings were 1-1. That apparently
changed some time ago, so with this patch the MPM consumers will actually
be hooked up to the correct interrupt lines.

Fixes: 59d34ca97f91 ("arm64: dts: qcom: Add initial device tree for SM6375")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231215-topic-mpm_dt-v1-1-c6636fc75ce3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi | 41 +++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6375.dtsi b/arch/arm64/boot/dts/qcom/sm6375.dtsi
index b479f3d9a3a8..e56f7ea4ebc6 100644
--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -311,6 +311,25 @@ scm {
 		};
 	};
 
+	mpm: interrupt-controller {
+		compatible = "qcom,mpm";
+		qcom,rpm-msg-ram = <&apss_mpm>;
+		interrupts = <GIC_SPI 197 IRQ_TYPE_EDGE_RISING>;
+		mboxes = <&ipcc IPCC_CLIENT_AOP IPCC_MPROC_SIGNAL_SMP2P>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		#power-domain-cells = <0>;
+		interrupt-parent = <&intc>;
+		qcom,mpm-pin-count = <96>;
+		qcom,mpm-pin-map = <5 296>,  /* Soundwire wake_irq */
+				   <12 422>, /* DWC3 ss_phy_irq */
+				   <86 183>, /* MPM wake, SPMI */
+				   <89 314>, /* TSENS0 0C */
+				   <90 315>, /* TSENS1 0C */
+				   <93 164>, /* DWC3 dm_hs_phy_irq */
+				   <94 165>; /* DWC3 dp_hs_phy_irq */
+	};
+
 	memory@80000000 {
 		device_type = "memory";
 		/* We expect the bootloader to fill in the size */
@@ -486,6 +505,7 @@ CPU_PD7: power-domain-cpu7 {
 
 		CLUSTER_PD: power-domain-cpu-cluster0 {
 			#power-domain-cells = <0>;
+			power-domains = <&mpm>;
 			domain-idle-states = <&CLUSTER_SLEEP_0>;
 		};
 	};
@@ -808,7 +828,7 @@ tlmm: pinctrl@500000 {
 			reg = <0 0x00500000 0 0x800000>;
 			interrupts = <GIC_SPI 227 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-ranges = <&tlmm 0 0 157>;
-			/* TODO: Hook up MPM as wakeup-parent when it's there */
+			wakeup-parent = <&mpm>;
 			interrupt-controller;
 			gpio-controller;
 			#interrupt-cells = <2>;
@@ -930,7 +950,7 @@ spmi_bus: spmi@1c40000 {
 			      <0 0x01c0a000 0 0x26000>;
 			reg-names = "core", "chnls", "obsrvr", "intr", "cnfg";
 			interrupt-names = "periph_irq";
-			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts-extended = <&mpm 86 IRQ_TYPE_LEVEL_HIGH>;
 			qcom,ee = <0>;
 			qcom,channel = <0>;
 			#address-cells = <2>;
@@ -962,8 +982,15 @@ tsens1: thermal-sensor@4413000 {
 		};
 
 		rpm_msg_ram: sram@45f0000 {
-			compatible = "qcom,rpm-msg-ram";
+			compatible = "qcom,rpm-msg-ram", "mmio-sram";
 			reg = <0 0x045f0000 0 0x7000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x0 0x045f0000 0x7000>;
+
+			apss_mpm: sram@1b8 {
+				reg = <0x1b8 0x48>;
+			};
 		};
 
 		sram@4690000 {
@@ -1360,10 +1387,10 @@ usb_1: usb@4ef8800 {
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <133333333>;
 
-			interrupts = <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 93 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 94 IRQ_TYPE_EDGE_BOTH>;
+			interrupts-extended = <&intc GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
+					      <&mpm 12 IRQ_TYPE_LEVEL_HIGH>,
+					      <&mpm 93 IRQ_TYPE_EDGE_BOTH>,
+					      <&mpm 94 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "ss_phy_irq",
 					  "dm_hs_phy_irq",
-- 
2.43.0



