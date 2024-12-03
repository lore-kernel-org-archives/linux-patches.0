Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B06E1F75B4;
	Tue,  3 Dec 2024 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241561; cv=none; b=rq7mT0bvPNjSGAHdL9vsN3UkPhNocp8yQMLgkRzV+p7LNPMmF1s8JwU6jyz3i9E5KupS6ZPqLNZVELMsOUG/EilHUvB21Aha5VKHsf5oQkns4DuQ05grd1a8qeMr+0a9BlJAWqSc1y8KS7Wzt0LBeZt6oN4W5cxtyWzM+1GF3sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241561; c=relaxed/simple;
	bh=TTpN1/Gse/VDQ6AGj9R6kkXwBubFyjm0+mRyTXu/BSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSyvLsnEzC9BsolAY2ZXdNG7U6uciDj0MsMSpGvF7gqLKC256hIlE3JJDq7nwkDlJ0MJY47yPwEVUeWmHgyWVTdDJ6Aort6b8fdK45b7SpDrpC3JdHDUGlwIN51/goh1Zw71iRRoeimqHe558ZDmMqLP7m4adESsJtISvluDe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv479cjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv479cjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2635EC4CECF;
	Tue,  3 Dec 2024 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241561;
	bh=TTpN1/Gse/VDQ6AGj9R6kkXwBubFyjm0+mRyTXu/BSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jv479cjSJm2NRwVeY4Hf/4LVvLC76QVbSQsngFGXsVclTCvuvs5aeLb6cy+ih35hD
	 8ioIhlIqgmnf6sFpssyQqYI2CZfF7PUhx9/d1uwUpYqKBOGe4MGh07QJxHNrlUcht1
	 UVszwZX/rL7+RplZNucQV90pMuYWU65GxfWBmngA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 453/826] clk: en7523: fix estimation of fixed rate for EN7581
Date: Tue,  3 Dec 2024 15:43:00 +0100
Message-ID: <20241203144801.429990583@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f98eded9e9ab048c88ff59c5523e703a6ced5523 ]

Introduce en7581_base_clks array in order to define per-SoC fixed-rate
clock parameters and fix wrong parameters for emi, npu and crypto EN7581
clocks

Fixes: 66bc47326ce2 ("clk: en7523: Add EN7581 support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20241112-clk-en7581-syscon-v2-5-8ada5e394ae4@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 105 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index 7f83cbce01eeb..fdd8ea989ed24 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -37,6 +37,7 @@
 #define REG_NP_SCU_SSTR			0x9c
 #define REG_PCIE_XSI0_SEL_MASK		GENMASK(14, 13)
 #define REG_PCIE_XSI1_SEL_MASK		GENMASK(12, 11)
+#define REG_CRYPTO_CLKSRC2		0x20c
 
 #define REG_RST_CTRL2			0x00
 #define REG_RST_CTRL1			0x04
@@ -89,6 +90,10 @@ static const u32 emi_base[] = { 333000000, 400000000 };
 static const u32 bus_base[] = { 500000000, 540000000 };
 static const u32 slic_base[] = { 100000000, 3125000 };
 static const u32 npu_base[] = { 333000000, 400000000, 500000000 };
+/* EN7581 */
+static const u32 emi7581_base[] = { 540000000, 480000000, 400000000, 300000000 };
+static const u32 npu7581_base[] = { 800000000, 750000000, 720000000, 600000000 };
+static const u32 crypto_base[] = { 540000000, 480000000 };
 
 static const struct en_clk_desc en7523_base_clks[] = {
 	{
@@ -186,6 +191,102 @@ static const struct en_clk_desc en7523_base_clks[] = {
 	}
 };
 
+static const struct en_clk_desc en7581_base_clks[] = {
+	{
+		.id = EN7523_CLK_GSW,
+		.name = "gsw",
+
+		.base_reg = REG_GSW_CLK_DIV_SEL,
+		.base_bits = 1,
+		.base_shift = 8,
+		.base_values = gsw_base,
+		.n_base_values = ARRAY_SIZE(gsw_base),
+
+		.div_bits = 3,
+		.div_shift = 0,
+		.div_step = 1,
+		.div_offset = 1,
+	}, {
+		.id = EN7523_CLK_EMI,
+		.name = "emi",
+
+		.base_reg = REG_EMI_CLK_DIV_SEL,
+		.base_bits = 2,
+		.base_shift = 8,
+		.base_values = emi7581_base,
+		.n_base_values = ARRAY_SIZE(emi7581_base),
+
+		.div_bits = 3,
+		.div_shift = 0,
+		.div_step = 1,
+		.div_offset = 1,
+	}, {
+		.id = EN7523_CLK_BUS,
+		.name = "bus",
+
+		.base_reg = REG_BUS_CLK_DIV_SEL,
+		.base_bits = 1,
+		.base_shift = 8,
+		.base_values = bus_base,
+		.n_base_values = ARRAY_SIZE(bus_base),
+
+		.div_bits = 3,
+		.div_shift = 0,
+		.div_step = 1,
+		.div_offset = 1,
+	}, {
+		.id = EN7523_CLK_SLIC,
+		.name = "slic",
+
+		.base_reg = REG_SPI_CLK_FREQ_SEL,
+		.base_bits = 1,
+		.base_shift = 0,
+		.base_values = slic_base,
+		.n_base_values = ARRAY_SIZE(slic_base),
+
+		.div_reg = REG_SPI_CLK_DIV_SEL,
+		.div_bits = 5,
+		.div_shift = 24,
+		.div_val0 = 20,
+		.div_step = 2,
+	}, {
+		.id = EN7523_CLK_SPI,
+		.name = "spi",
+
+		.base_reg = REG_SPI_CLK_DIV_SEL,
+
+		.base_value = 400000000,
+
+		.div_bits = 5,
+		.div_shift = 8,
+		.div_val0 = 40,
+		.div_step = 2,
+	}, {
+		.id = EN7523_CLK_NPU,
+		.name = "npu",
+
+		.base_reg = REG_NPU_CLK_DIV_SEL,
+		.base_bits = 2,
+		.base_shift = 8,
+		.base_values = npu7581_base,
+		.n_base_values = ARRAY_SIZE(npu7581_base),
+
+		.div_bits = 3,
+		.div_shift = 0,
+		.div_step = 1,
+		.div_offset = 1,
+	}, {
+		.id = EN7523_CLK_CRYPTO,
+		.name = "crypto",
+
+		.base_reg = REG_CRYPTO_CLKSRC2,
+		.base_bits = 1,
+		.base_shift = 0,
+		.base_values = crypto_base,
+		.n_base_values = ARRAY_SIZE(crypto_base),
+	}
+};
+
 static const u16 en7581_rst_ofs[] = {
 	REG_RST_CTRL2,
 	REG_RST_CTRL1,
@@ -457,8 +558,8 @@ static void en7581_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 	u32 rate;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(en7523_base_clks); i++) {
-		const struct en_clk_desc *desc = &en7523_base_clks[i];
+	for (i = 0; i < ARRAY_SIZE(en7581_base_clks); i++) {
+		const struct en_clk_desc *desc = &en7581_base_clks[i];
 		u32 val, reg = desc->div_reg ? desc->div_reg : desc->base_reg;
 		int err;
 
-- 
2.43.0



