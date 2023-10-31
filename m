Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E090208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/iAVU/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B020CC433C9;
	Tue, 31 Oct 2023 17:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774445;
	bh=VVUXwAHOILqhH3BmsNWBj7QrvRVM92P5alnC2IgdjyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/iAVU/p2vQZc4oYabL7ReqZZFTewuZSY7gOir+4JAeoOA1lAqtyldgwedlJdNyoY
	 aDqiEmBxTK0ZPll2hBx5RdzmNEGv4xx9gdIbYtX5FYeQrDknJ7tD/9AGycGQZUTfBT
	 7KYjcvxxKELAodziW7FxAQooB+Uj6ANGry0TrnEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 048/112] clk: ti: Fix missing omap5 mcbsp functional clock and aliases
Date: Tue, 31 Oct 2023 18:00:49 +0100
Message-ID: <20231031165902.815664318@linuxfoundation.org>
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

[ Upstream commit 0b9a4a67c60d3e15b39a69d480a50ce7eeff9bc1 ]

We are using a wrong mcbsp functional clock. The interconnect target module
driver provided clock for mcbsp is not same as the mcbsp functional clock
known as the gfclk main_clk. The mcbsp functional clocks for mcbsp should
have been added before we dropped the legacy platform data.

Additionally we are also missing the clock aliases for the clocks used by
the audio driver if reparenting is needed. This causes audio driver errors
like "CLKS: could not clk_get() prcm_fck" for mcbsp as reported by Andreas.
The mcbsp clock aliases too should have been added before we dropped the
legacy platform data.

Let's add the clocks and aliases with a single patch to fix the issue
similar to omap4. On omap5, there is no mcbsp4 instance on the l4_per
interconnect.

Fixes: b1da0fa21bd1 ("ARM: OMAP2+: Drop legacy platform data for omap5 mcbsp")
Cc: H. Nikolaus Schaller <hns@goldelico.com>
Reported-by: Andreas Kemnade <andreas@kemnade.info>
Reported-by: Péter Ujfalusi <peter.ujfalusi@gmail.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap5-l4-abe.dtsi | 6 ++++++
 drivers/clk/ti/clk-54xx.c                   | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/ti/omap/omap5-l4-abe.dtsi b/arch/arm/boot/dts/ti/omap/omap5-l4-abe.dtsi
index a03bca5a35844..97b0c3b5f573f 100644
--- a/arch/arm/boot/dts/ti/omap/omap5-l4-abe.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap5-l4-abe.dtsi
@@ -109,6 +109,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49022000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP5_MCBSP1_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
@@ -142,6 +144,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49024000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP5_MCBSP2_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 22 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
@@ -175,6 +179,8 @@
 				reg = <0x0 0xff>, /* MPU private access */
 				      <0x49026000 0xff>; /* L3 Interconnect */
 				reg-names = "mpu", "dma";
+				clocks = <&abe_clkctrl OMAP5_MCBSP3_CLKCTRL 24>;
+				clock-names = "fck";
 				interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "common";
 				ti,buffer-size = <128>;
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index b4aff76eb3735..74dfd5823f835 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -565,15 +565,19 @@ static struct ti_dt_clk omap54xx_clks[] = {
 	DT_CLK(NULL, "gpio8_dbclk", "l4per-clkctrl:00f8:8"),
 	DT_CLK(NULL, "mcbsp1_gfclk", "abe-clkctrl:0028:24"),
 	DT_CLK(NULL, "mcbsp1_sync_mux_ck", "abe-clkctrl:0028:26"),
+	DT_CLK("40122000.mcbsp", "prcm_fck", "abe-clkctrl:0028:26"),
 	DT_CLK(NULL, "mcbsp2_gfclk", "abe-clkctrl:0030:24"),
 	DT_CLK(NULL, "mcbsp2_sync_mux_ck", "abe-clkctrl:0030:26"),
+	DT_CLK("40124000.mcbsp", "prcm_fck", "abe-clkctrl:0030:26"),
 	DT_CLK(NULL, "mcbsp3_gfclk", "abe-clkctrl:0038:24"),
 	DT_CLK(NULL, "mcbsp3_sync_mux_ck", "abe-clkctrl:0038:26"),
+	DT_CLK("40126000.mcbsp", "prcm_fck", "abe-clkctrl:0038:26"),
 	DT_CLK(NULL, "mmc1_32khz_clk", "l3init-clkctrl:0008:8"),
 	DT_CLK(NULL, "mmc1_fclk", "l3init-clkctrl:0008:25"),
 	DT_CLK(NULL, "mmc1_fclk_mux", "l3init-clkctrl:0008:24"),
 	DT_CLK(NULL, "mmc2_fclk", "l3init-clkctrl:0010:25"),
 	DT_CLK(NULL, "mmc2_fclk_mux", "l3init-clkctrl:0010:24"),
+	DT_CLK(NULL, "pad_fck", "pad_clks_ck"),
 	DT_CLK(NULL, "sata_ref_clk", "l3init-clkctrl:0068:8"),
 	DT_CLK(NULL, "timer10_gfclk_mux", "l4per-clkctrl:0008:24"),
 	DT_CLK(NULL, "timer11_gfclk_mux", "l4per-clkctrl:0010:24"),
-- 
2.42.0



