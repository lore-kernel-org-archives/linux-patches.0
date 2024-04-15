Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02F3BBE1;
	Mon, 15 Apr 2024 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191112; cv=none; b=PaJh3gb2J+9rqRT/Hw8MqRb9yhlokDARtC7XNWngNB6f7DIvfzmwSVI5C6PyVKrzyA8s+YtT8INTTX36ixUcO0N/hWs5k9kG7+kOZGz2Bc1AV1t84KWiXAZ3nxbIVN1RmTafCHfunwSgnyVi9jTC0vMPPJ6D9uVTL2IFWLHgqNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191112; c=relaxed/simple;
	bh=PRfhbTx4hCcumV9yY7fYqq7VcGv21VG/iNA9y2RnPIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbCUMkbwUqJBzav4BayRD7y/MMHGj8hEj2T0OSwwUYgmn/U47lT3mFWNTndldqan49immvfsDE1PgFJFUuqbVCoy0IALjNUkkqQmvwY0oa0hZBUCOQb039pW0O6Iqx2U08APwOAY4BUdn6oX55jwXGrCcGlT7NK1WNMfa+K4lz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YARmk7Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YARmk7Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7EEC113CC;
	Mon, 15 Apr 2024 14:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191112;
	bh=PRfhbTx4hCcumV9yY7fYqq7VcGv21VG/iNA9y2RnPIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YARmk7FhDlMQS1Z+25ACSwrgsazqgHz1ijqCSnIkPYqY5Fr5K49EakQhba/RKbqL8
	 N8I/E5FMba+vuCDwSYoiMcQHXHYxZnUrGJpfWCM8DieymHySfMaYBNDGLX6aJ8arIQ
	 EABpa8s1QggRYJFBdLmryWR575M77tQjirzBviUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 036/172] arm64: dts: imx8-ss-conn: fix usdhc wrong lpcg clock order
Date: Mon, 15 Apr 2024 16:18:55 +0200
Message-ID: <20240415142001.525788320@linuxfoundation.org>
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
index 3c42240e78e24..af2259e997967 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-conn.dtsi
@@ -67,8 +67,8 @@ usdhc1: mmc@5b010000 {
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
@@ -78,8 +78,8 @@ usdhc2: mmc@5b020000 {
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
@@ -91,8 +91,8 @@ usdhc3: mmc@5b030000 {
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



