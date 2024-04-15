Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBE27F7F2;
	Mon, 15 Apr 2024 14:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191432; cv=none; b=SpuYqygf4KISCMYMLuAA0TGndM4JkOrTG2sGA/fNAOalH5nZRobFFiJaYf04V7rZIbiNkpn/RlmuWsIqUNSaF/jSOAl2CMroOUWOlpvRQCQPxy+JI4UR9/+5IJZR7UAcWGOs24xUiZjymqd5CpcAgSafknjYRz+N+Gc0BHpi0Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191432; c=relaxed/simple;
	bh=YkCc4IKa9RoLxQdiGwfcLagOxOa5ybHo9lHalGbhNKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNPPAVumeRQCJD9XUh1yABoiwuYX9Irl7lm7YuptquRXnLDhtK5QcFsrf7ERLp2AWsnX9cH8RG7DxYeU5PG2v3QHzjBMc82CrTYpbjWG/FOBwo/TISYVwR+TeZHaLwxMFjW9yOowbaOEG29ew7N1duA7p9WHds4eL26TXaoSy4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr0Zpqf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr0Zpqf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD23C113CC;
	Mon, 15 Apr 2024 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191432;
	bh=YkCc4IKa9RoLxQdiGwfcLagOxOa5ybHo9lHalGbhNKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr0Zpqf+vuXTcyQBs1Y7SubmxJPMdoG0BR3GRj7nq3KJc8lPjdH5ITW9hQO2ySYOs
	 /pjsTBKOp36+CwOB/zN+eeFs7Ds6PQm/8UvVXbf2XrI2QgfYKSL154udEVzeMFq50e
	 gn+/UWZypvpzFE2uRrlavFWO9XO2vHhq7FTC+5Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 133/172] arm64: dts: imx8-ss-dma: fix can lpcg indices
Date: Mon, 15 Apr 2024 16:20:32 +0200
Message-ID: <20240415142004.419154491@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 0893392334b5dffdf616a53679c6a2942c46391b upstream.

can0_lpcg: clock-controller@5acd0000 {
	...						   Col1  Col2
	clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>, // 0    0
		 <&dma_ipg_clk>,			  // 1    4
		 <&dma_ipg_clk>;			  // 2    5
        clock-indices = <IMX_LPCG_CLK_0>,
			<IMX_LPCG_CLK_4>,
			<IMX_LPCG_CLK_5>;
}

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

flexcan1: can@5a8d0000 {
	clocks = <&can0_lpcg 1>, <&can0_lpcg 0>;
			     ^^		     ^^
Should be:
	clocks = <&can0_lpcg IMX_LPCG_CLK_4>, <&can0_lpcg IMX_LPCG_CLK_0>;
};

Arg0 is divided by 4 in lpcg driver. flexcan driver get IMX_SC_PM_CLK_PER
by <&can0_lpcg 1> and <&can0_lpcg 0>. Although function can work, code
logic is wrong. Fix it by using correct clock indices.

Cc: stable@vger.kernel.org
Fixes: 5e7d5b023e03 ("arm64: dts: imx8qxp: add flexcan in adma")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -406,8 +406,8 @@ dma_subsys: bus@5a000000 {
 		reg = <0x5a8d0000 0x10000>;
 		interrupts = <GIC_SPI 235 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;
@@ -427,8 +427,8 @@ dma_subsys: bus@5a000000 {
 		 * CAN1 shares CAN0's clock and to enable CAN0's clock it
 		 * has to be powered on.
 		 */
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;
@@ -448,8 +448,8 @@ dma_subsys: bus@5a000000 {
 		 * CAN2 shares CAN0's clock and to enable CAN0's clock it
 		 * has to be powered on.
 		 */
-		clocks = <&can0_lpcg 1>,
-			 <&can0_lpcg 0>;
+		clocks = <&can0_lpcg IMX_LPCG_CLK_4>,
+			 <&can0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "per";
 		assigned-clocks = <&clk IMX_SC_R_CAN_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <40000000>;


