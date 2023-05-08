Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D698168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987CDC433EF;
	Mon,  8 May 2023 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540816;
	bh=hfEhiAuaVlMG4xQxmFS9RLPXYYi4UgQiJ+eh70j6rnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mq5SP5MYCx1dJDxJuPRyO71lgHl1ycjCDXibZwQhlxgWbmD33RdDO6qfNyUgYKXab
	 jPk7sQErbl/Z789vM18t+/tmQlYWTB1htbD4Wpzc56j5fb1Mi2sRnNQ6ibdd3x72hf
	 pXYOUJrKa+hFlDUvjhYp1fFBcYIRa/jR+BnCFfw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/611] clk: qcom: gcc-sm8350: fix PCIe PIPE clocks handling
Date: Mon,  8 May 2023 11:45:50 +0200
Message-Id: <20230508094438.567851361@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1a500e0bc97b6cb3c0d9859e81973b8dd07d1b7b ]

On SM8350 platform the PCIe PIPE clocks require additional handling to
function correctly. They are to be switched to the tcxo source before
turning PCIe GDSCs off and should be switched to PHY PIPE source once
they are working. Switch PCIe PHY clocks to use clk_regmap_phy_mux_ops,
which provide support for this dance.

Fixes: 44c20c9ed37f ("clk: qcom: gcc: Add clock driver for SM8350")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230412134829.3686467-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8350.c | 47 ++++++++++-------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8350.c b/drivers/clk/qcom/gcc-sm8350.c
index c3731f96c8e6b..430ef407a8341 100644
--- a/drivers/clk/qcom/gcc-sm8350.c
+++ b/drivers/clk/qcom/gcc-sm8350.c
@@ -17,6 +17,7 @@
 #include "clk-regmap.h"
 #include "clk-regmap-divider.h"
 #include "clk-regmap-mux.h"
+#include "clk-regmap-phy-mux.h"
 #include "gdsc.h"
 #include "reset.h"
 
@@ -167,26 +168,6 @@ static const struct clk_parent_data gcc_parent_data_3[] = {
 	{ .fw_name = "core_bi_pll_test_se" },
 };
 
-static const struct parent_map gcc_parent_map_4[] = {
-	{ P_PCIE_0_PIPE_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_4[] = {
-	{ .fw_name = "pcie_0_pipe_clk", },
-	{ .fw_name = "bi_tcxo" },
-};
-
-static const struct parent_map gcc_parent_map_5[] = {
-	{ P_PCIE_1_PIPE_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_5[] = {
-	{ .fw_name = "pcie_1_pipe_clk" },
-	{ .fw_name = "bi_tcxo" },
-};
-
 static const struct parent_map gcc_parent_map_6[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_GCC_GPLL0_OUT_MAIN, 1 },
@@ -289,32 +270,30 @@ static const struct clk_parent_data gcc_parent_data_14[] = {
 	{ .fw_name = "bi_tcxo" },
 };
 
-static struct clk_regmap_mux gcc_pcie_0_pipe_clk_src = {
+static struct clk_regmap_phy_mux gcc_pcie_0_pipe_clk_src = {
 	.reg = 0x6b054,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_4,
 	.clkr = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_pipe_clk_src",
-			.parent_data = gcc_parent_data_4,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_4),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.fw_name = "pcie_0_pipe_clk",
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
 
-static struct clk_regmap_mux gcc_pcie_1_pipe_clk_src = {
+static struct clk_regmap_phy_mux gcc_pcie_1_pipe_clk_src = {
 	.reg = 0x8d054,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_5,
 	.clkr = {
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_pipe_clk_src",
-			.parent_data = gcc_parent_data_5,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_5),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.fw_name = "pcie_1_pipe_clk",
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
-- 
2.39.2



