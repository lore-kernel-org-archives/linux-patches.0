Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD837F465;
	Mon, 15 Apr 2024 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191978; cv=none; b=Usv9gk+0M5/IC8Gqj4XneDdUFP5ZIrtp2E/Sslme/TKN2OKHRDk5V0zyJFKnFGLLesXs4LnNWUKxgdrDNhy6/SVWqsWW+yG0hH0BfLJNPMdTSb03iBiqSQwU46duqfXGezsgGibl18zmf29JPoxXoV3wLR71f1XLB0LGW7bwhDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191978; c=relaxed/simple;
	bh=RM3D/FgMSL1W4YYSaICA0GbIvd7SQPSBaXTZ83Ey++Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMi8O2doJYabeB80yIDwodKa46IPuq6glMVUWuN01jvYFyesr3x3lu7m7IFHmBGyie9oYIKqJMR2l9aupJpeRhnHevXicwg1RQWG9GsjxQXQ1TKu/IhWhwlwI3F/7yZV/Mw99A25Pp/ddC2rJsSYst95Gt7z1oSHA9IUkungqEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alXZBDOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alXZBDOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C0CC113CC;
	Mon, 15 Apr 2024 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191978;
	bh=RM3D/FgMSL1W4YYSaICA0GbIvd7SQPSBaXTZ83Ey++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alXZBDOSjJxUPD3um8DDd1kTCp7lBqeYxOcKxANO/0/NS8YBgoxzxibwf8dQwaxdA
	 4r7wUjYQ+Dxc3RGwSBEJw4KPh67RTR2k9YzbcEdbGaJyVnaHNiL3oW6ynZDvGwi/g8
	 rNOOwr/TN+r1ZJDlBhEwMpp6vDzcxhoB2ppUsZD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/69] arm64: dts: imx8-ss-conn: fix usdhc wrong lpcg clock order
Date: Mon, 15 Apr 2024 16:20:40 +0200
Message-ID: <20240415141946.451519586@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit c6ddd6e7b166532a0816825442ff60f70aed9647 ]

The actual clock show wrong frequency:

   echo on >/sys/devices/platform/bus\@5b000000/5b010000.mmc/power/control
   cat /sys/kernel/debug/mmc0/ios

   clock:          200000000 Hz
   actual clock:   166000000 Hz
                   ^^^^^^^^^
   .....

According to

sdhc0_lpcg: clock-controller@5b200000 {
                compatible = "fsl,imx8qxp-lpcg";
                reg = <0x5b200000 0x10000>;
                #clock-cells = <1>;
                clocks = <&clk IMX_SC_R_SDHC_0 IMX_SC_PM_CLK_PER>,
                         <&conn_ipg_clk>, <&conn_axi_clk>;
                clock-indices = <IMX_LPCG_CLK_0>, <IMX_LPCG_CLK_4>,
                                <IMX_LPCG_CLK_5>;
                clock-output-names = "sdhc0_lpcg_per_clk",
                                     "sdhc0_lpcg_ipg_clk",
                                     "sdhc0_lpcg_ahb_clk";
                power-domains = <&pd IMX_SC_R_SDHC_0>;
        }

"per_clk" should be IMX_LPCG_CLK_0 instead of IMX_LPCG_CLK_5.

After correct clocks order:

   echo on >/sys/devices/platform/bus\@5b000000/5b010000.mmc/power/control
   cat /sys/kernel/debug/mmc0/ios

   clock:          200000000 Hz
   actual clock:   198000000 Hz
                   ^^^^^^^^
   ...

Fixes: 16c4ea7501b1 ("arm64: dts: imx8: switch to new lpcg clock binding")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
index 10370d1a6c6de..dbb298b907c1c 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
@@ -38,8 +38,8 @@ usdhc1: mmc@5b010000 {
 		interrupts = <GIC_SPI 232 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b010000 0x10000>;
 		clocks = <&sdhc0_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc0_lpcg IMX_LPCG_CLK_0>,
-			 <&sdhc0_lpcg IMX_LPCG_CLK_5>;
+			 <&sdhc0_lpcg IMX_LPCG_CLK_5>,
+			 <&sdhc0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_0>;
 		status = "disabled";
@@ -49,8 +49,8 @@ usdhc2: mmc@5b020000 {
 		interrupts = <GIC_SPI 233 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b020000 0x10000>;
 		clocks = <&sdhc1_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc1_lpcg IMX_LPCG_CLK_0>,
-			 <&sdhc1_lpcg IMX_LPCG_CLK_5>;
+			 <&sdhc1_lpcg IMX_LPCG_CLK_5>,
+			 <&sdhc1_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_1>;
 		fsl,tuning-start-tap = <20>;
@@ -62,8 +62,8 @@ usdhc3: mmc@5b030000 {
 		interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
 		reg = <0x5b030000 0x10000>;
 		clocks = <&sdhc2_lpcg IMX_LPCG_CLK_4>,
-			 <&sdhc2_lpcg IMX_LPCG_CLK_0>,
-			 <&sdhc2_lpcg IMX_LPCG_CLK_5>;
+			 <&sdhc2_lpcg IMX_LPCG_CLK_5>,
+			 <&sdhc2_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "ahb", "per";
 		power-domains = <&pd IMX_SC_R_SDHC_2>;
 		status = "disabled";
-- 
2.43.0



