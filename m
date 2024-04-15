Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D861EEE3;
	Mon, 15 Apr 2024 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192148; cv=none; b=V3jmn1b1HHeAEM9E6gyI4QgWJxsNvygLDnBAPzT1s8RzvgDkQkfw5MzXh5XRZbMXERDWdhRDHiZdHAWgwA9ViH+iM7axdktUSSes2hzDirJlbKrnk+LDRbM4APAPsXmEt7K85JoH/X8v5a6VTcIc5XgcrU9biqi4t5z4dFs5A6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192148; c=relaxed/simple;
	bh=1n9EqnQOhY0WhEf59c2u4n+8IQzSdaBECnVJpYsuIhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFnsgQS2RVtqsF86jj0AKVmquXPmX8Pc5s4LsW+0GnDgoDxLln9z5f4HmweSc1qWNNBmfxEa+1nPnYVeYYh2+XEn9WN+92fNTAnldrm1936JsJ8BWsBI8wt8ND+e3oCZOLvPLGygiVpHs3R3JRg4shECiq0bLpiBlbNHPT7prSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfryIiuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfryIiuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE27C113CC;
	Mon, 15 Apr 2024 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192148;
	bh=1n9EqnQOhY0WhEf59c2u4n+8IQzSdaBECnVJpYsuIhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfryIiuc3L+KDOGlVxwy99bsgwAJSgQRPYZ/0vnxRBLWM03cQwdLEmgIg26iqJNLl
	 y4JqtCs6A4qWTSCI92ael4l7Ges98V32Dr230D7OlJ1q9RPodZf+2Edso11aAcNLNH
	 aj+Ql80WKzNhyztI6Mwp63swcIRfSqbzlwNobO6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/45] arm64: dts: imx8-ss-conn: fix usdhc wrong lpcg clock order
Date: Mon, 15 Apr 2024 16:21:12 +0200
Message-ID: <20240415141942.403028938@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 639220dbff008..685e9b83d42b1 100644
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



