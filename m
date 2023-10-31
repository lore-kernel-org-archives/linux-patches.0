Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C15D208C6
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quwzOlxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB342C433C7;
	Tue, 31 Oct 2023 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774442;
	bh=DJ90cru+/nRTcOCF4LgMyLqkhn+XIlu81/zyIkY/GHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quwzOlxt1dS793YoOnkTXUmZlfGBFo5PdXEnt2Yi1kRmdrQCuqxBqbnvC6CJEUBbr
	 ZWFKv6UiBNeanCQguylXpheDokOGyvCH2z+czhjvMOMOk+l/WyjE41mOCHnb2LCncx
	 zkzJkLoTOUXeJAzs6Jugd4RKJHe9/7PdSWhlNLrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 047/112] clk: ti: Fix missing omap4 mcbsp functional clock and aliases
Date: Tue, 31 Oct 2023 18:00:48 +0100
Message-ID: <20231031165902.784755014@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit cc2d819dd7df94a72bde7b9b9331a6535084092d ]

We are using a wrong mcbsp functional clock. The interconnect target module
driver provided clock for mcbsp is not same as the mcbsp functional clock
known as the gfclk main_clk. The mcbsp functional clocks for mcbsp should
have been added before we dropped the legacy platform data.

Additionally we are also missing the clock aliases for the clocks used by
the audio driver if reparenting is needed. This causes audio driver errors
like "CLKS: could not clk_get() prcm_fck" for mcbsp as reported by Andreas.
The mcbsp clock aliases too should have been added before we dropped the
legacy platform data.

Let's add the clocks and aliases with a single patch to fix the issue.

Fixes: 349355ce3a05 ("ARM: OMAP2+: Drop legacy platform data for omap4 mcbsp")
Reported-by: Andreas Kemnade <andreas@kemnade.info>
Reported-by: Péter Ujfalusi <peter.ujfalusi@gmail.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap4-l4-abe.dtsi | 6 ++++++
 arch/arm/boot/dts/ti/omap/omap4-l4.dtsi     | 2 ++
 drivers/clk/ti/clk-44xx.c                   | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/ti/omap/omap4-l4-abe.dtsi b/arch/arm/boot/dts/ti/omap/omap4-l4-abe.dtsi
index 7ae8b620515c5..59f546a278f87 100644
--- a/arch/arm/boot/dts/ti/omap/omap4-l4-abe.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap4-l4-abe.dtsi
@@ -109,6 +109,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49022000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP4_MCBSP1_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
@@ -142,6 +144,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49024000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP4_MCBSP2_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
@@ -175,6 +179,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49026000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP4_MCBSP3_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
diff --git a/arch/arm/boot/dts/ti/omap/omap4-l4.dtsi b/arch/arm/boot/dts/ti/omap/omap4-l4.dtsi
index 46b8f9efd4131..3fcef3080eaec 100644
--- a/arch/arm/boot/dts/ti/omap/omap4-l4.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap4-l4.dtsi
@@ -2043,6 +2043,8 @@
 				compatible = "ti,omap4-mcbsp";
 				reg = <0x0 0xff>; /* L4 Interconnect */
 				reg-names = "mpu";
+				clocks = <&l4_per_clkctrl OMAP4_MCBSP4_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index 868bc7af21b0b..9b2824ed785b9 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -749,9 +749,14 @@ static struct ti_dt_clk omap44xx_clks[] = {
 	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
 	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
 	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
+	DT_CLK("40122000.mcbsp", "prcm_fck", "abe-clkctrl:0028:26"),
+	DT_CLK("40124000.mcbsp", "prcm_fck", "abe-clkctrl:0030:26"),
+	DT_CLK("40126000.mcbsp", "prcm_fck", "abe-clkctrl:0038:26"),
 	DT_CLK(NULL, "mcbsp4_sync_mux_ck", "l4-per-clkctrl:00c0:26"),
+	DT_CLK("48096000.mcbsp", "prcm_fck", "l4-per-clkctrl:00c0:26"),
 	DT_CLK(NULL, "ocp2scp_usb_phy_phy_48m", "l3-init-clkctrl:00c0:8"),
 	DT_CLK(NULL, "otg_60m_gfclk", "l3-init-clkctrl:0040:24"),
+	DT_CLK(NULL, "pad_fck", "pad_clks_ck"),
 	DT_CLK(NULL, "per_mcbsp4_gfclk", "l4-per-clkctrl:00c0:24"),
 	DT_CLK(NULL, "pmd_stm_clock_mux_ck", "emu-sys-clkctrl:0000:20"),
 	DT_CLK(NULL, "pmd_trace_clk_mux_ck", "emu-sys-clkctrl:0000:22"),
-- 
2.42.0



