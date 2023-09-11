Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB11170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14824C433C8;
	Mon, 11 Sep 2023 14:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441428;
	bh=1MLbwbBH3zbv3sfGQ+MXID2YbBrociFW3O2eiD3MMkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrC2o041m81Wjg5bEuoPfxFlH52GElMYOK2BQnhqPMMI3iTQOKpWiDSvIkBzYkkmG
	 SEeMf7mCtczf6juNcf4bGAbEYIH/d6zgVjBJ97CWVyAJOyIcpVHispDW+PMdUHm76a
	 11UW+LeuY5Q/tm3U+cmwZh9NxcNvWnxvPv2yOrr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 410/739] clk: qcom: gcc-qdu1000: Fix gcc_pcie_0_pipe_clk_src clock handling
Date: Mon, 11 Sep 2023 15:43:29 +0200
Message-ID: <20230911134702.633090195@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <quic_imrashai@quicinc.com>

[ Upstream commit b311f5d3c4749259043a9a458a8db07915210142 ]

Fix the gcc pcie pipe clock handling as per the clk_regmap_phy_mux_ops
implementation to let the clock framework automatically park the clock
at XO when the clock is switched off and restore the parent when the
clock is switched on.

Fixes: 1c9efb0bc040 ("clk: qcom: Add QDU1000 and QRU1000 GCC support")
Co-developed-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230803105741.2292309-3-quic_imrashai@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qdu1000.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qdu1000.c b/drivers/clk/qcom/gcc-qdu1000.c
index 5051769ad90c7..c00d26a3e6df5 100644
--- a/drivers/clk/qcom/gcc-qdu1000.c
+++ b/drivers/clk/qcom/gcc-qdu1000.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -370,16 +370,6 @@ static const struct clk_parent_data gcc_parent_data_6[] = {
 	{ .index = DT_TCXO_IDX },
 };
 
-static const struct parent_map gcc_parent_map_7[] = {
-	{ P_PCIE_0_PIPE_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data gcc_parent_data_7[] = {
-	{ .index = DT_PCIE_0_PIPE_CLK_IDX },
-	{ .index = DT_TCXO_IDX },
-};
-
 static const struct parent_map gcc_parent_map_8[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_GCC_GPLL0_OUT_MAIN, 1 },
@@ -439,16 +429,15 @@ static struct clk_regmap_mux gcc_pcie_0_phy_aux_clk_src = {
 	},
 };
 
-static struct clk_regmap_mux gcc_pcie_0_pipe_clk_src = {
+static struct clk_regmap_phy_mux gcc_pcie_0_pipe_clk_src = {
 	.reg = 0x9d064,
-	.shift = 0,
-	.width = 2,
-	.parent_map = gcc_parent_map_7,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_pcie_0_pipe_clk_src",
-			.parent_data = gcc_parent_data_7,
-			.num_parents = ARRAY_SIZE(gcc_parent_data_7),
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_PCIE_0_PIPE_CLK_IDX,
+			},
+			.num_parents = 1,
 			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
-- 
2.40.1



