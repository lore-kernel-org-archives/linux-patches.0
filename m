Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBB9EAC5;
	Mon, 15 Apr 2024 14:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191604; cv=none; b=SEhh8vT2580vN+PKRvyzqbcKe6DLx3ryJNwXvPDOfF5XHvQPGK0Rsf7LvvJd9x5V5JgqH1XxAcjlHWU4D4IjiEQwhYQrbwM/SDRRHgHX/u87OcVDryUyGDiiBjXmmQ1VxREd78AqMMG3BYE+yRB+SeohBDZKwQn1DS1r5u/tA8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191604; c=relaxed/simple;
	bh=lPdlOqn1JuCfbRvC+ho4L3mNZKXZYy8oBZLz5rhGapw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpFDFflIv6pBKvYTvVSclMQL+RJSGRO+NpoMGlln+UJyUI+hWpTh9Kergth72QxklIzGFMuGhAWAW/VsiutlkeyOOsZTFLcAh5ZLshA8M25E0eGscVfpzNrgIKUXUJ63SOvCcR+O5FKM53FqqabR6DQZ1afAls2Q2KrAkrGJIkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtRxYWy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtRxYWy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F8DC113CC;
	Mon, 15 Apr 2024 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191604;
	bh=lPdlOqn1JuCfbRvC+ho4L3mNZKXZYy8oBZLz5rhGapw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtRxYWy2kHv/JGJvtqmiPcOsP8vLD92ahKmYqcGx+hYk60wWSRM/Z7D8LXROb6Cei
	 6ws9ijoONwaz5x+nZa8Xer3x+FHfN3n4xOerW9es9yFXwb9FLtpFUpNontdjYYMewC
	 kcB6bHFMi9QjTp9ygDr/kDrCZU8RvFdQe3KJPx2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/122] arm64: dts: imx8-ss-conn: fix usdhc wrong lpcg clock order
Date: Mon, 15 Apr 2024 16:19:50 +0200
Message-ID: <20240415141954.129329042@linuxfoundation.org>
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
index fc1a5d34382b7..5f151ae78586e 100644
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



