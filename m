Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376C71B3B;
	Mon, 15 Apr 2024 14:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191824; cv=none; b=HK/oeombxDEWsY9+r0RxMMP2AIGcn39RgXZDuZVfI0f2pqFcV5kOgqtJQs7PXzaQ1LDdJomrMDEPMlkK4RvchYdeJPr1pC2C5xVQLJKQlEsn/l/g9xbqBzO+Ku+rlC/u+MD1IbBHrIgrXJMxIAtHmTySreKDd25biKSpdpHnewQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191824; c=relaxed/simple;
	bh=0XXstUBli87tf5ODZWok5t6fbru/D6PZYz0ckCkTRFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q18DW4YO90GWdlYYPLn3XKp1YDZY0aM+vp5YAJIr10XrkSyuoVVtXPAX2/NBB51uQ5ZJRsMRs/Ooz+/U2Qdg38TMbo+a2QrzS8W94lpYgAGXrv6pcNCnts/m0DYMtWfSHII9UbaRjl4sbWWi8+tiT9pyMR1Dm37y9+arNKeinmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJdpQuhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJdpQuhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02DBC113CC;
	Mon, 15 Apr 2024 14:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191824;
	bh=0XXstUBli87tf5ODZWok5t6fbru/D6PZYz0ckCkTRFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJdpQuhGaEYSWnMU2gAs6oYNuW0I9GBMssjG4lm5oX67fSJ78LUfHdEY70fggubR1
	 d6DWw1g4s4Z5LlYDwG0mU9Akuu10VrSAPUwi/N0j5hpIqQTPZli5PDurjkXicL8eje
	 v/iJl/9xWTUMESOQ/G6SM+QgHOQcLw3aOt4sghlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 099/122] arm64: dts: imx8-ss-dma: fix spi lpcg indices
Date: Mon, 15 Apr 2024 16:21:04 +0200
Message-ID: <20240415141956.344814784@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit f72b544a514c07d34a0d9d5380f5905b3731e647 upstream.

spi0_lpcg: clock-controller@5a400000 {
	...                                                  Col0   Col1
	clocks = <&clk IMX_SC_R_SPI_0 IMX_SC_PM_CLK_PER>,//   0      1
		 <&dma_ipg_clk>;                         //   1      4
	clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_4>;
};

Col1: index, which existing dts try to get.
Col2: actual index in lpcg driver.

lpspi0: spi@5a000000 {
	...
	clocks = <&spi0_lpcg 0>, <&spi0_lpcg 1>;
			     ^		     ^
Should be:
	clocks = <&spi0_lpcg IMX_LPCG_CLK_0>, <&spi0_lpcg IMX_LPCG_CLK_4>;
};

Arg0 is divided by 4 in lpcg driver. <&spi0_lpcg 0> and <&spi0_lpcg 1> are
IMX_SC_PM_CLK_PER. Although code can work, code logic is wrong. It should
use IMX_LPCG_CLK_0 and IMX_LPCG_CLK_4 for lpcg arg0.

Cc: stable@vger.kernel.org
Fixes: c4098885e790 ("arm64: dts: imx8dxl: add lpspi support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -27,8 +27,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi0_lpcg 0>,
-			 <&spi0_lpcg 1>;
+		clocks = <&spi0_lpcg IMX_LPCG_CLK_0>,
+			 <&spi0_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -43,8 +43,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi1_lpcg 0>,
-			 <&spi1_lpcg 1>;
+		clocks = <&spi1_lpcg IMX_LPCG_CLK_0>,
+			 <&spi1_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_1 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -59,8 +59,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi2_lpcg 0>,
-			 <&spi2_lpcg 1>;
+		clocks = <&spi2_lpcg IMX_LPCG_CLK_0>,
+			 <&spi2_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_2 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;
@@ -75,8 +75,8 @@ dma_subsys: bus@5a000000 {
 		#size-cells = <0>;
 		interrupts = <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-parent = <&gic>;
-		clocks = <&spi3_lpcg 0>,
-			 <&spi3_lpcg 1>;
+		clocks = <&spi3_lpcg IMX_LPCG_CLK_0>,
+			 <&spi3_lpcg IMX_LPCG_CLK_4>;
 		clock-names = "per", "ipg";
 		assigned-clocks = <&clk IMX_SC_R_SPI_3 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <60000000>;


