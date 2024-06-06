Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8A519B5B6;
	Thu,  6 Jun 2024 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683411; cv=none; b=VBHVVQRPI7Zw4cCm3KyNS95znDenJehCjAB/L+ZvG3kTKLVmjGv5Kp61i0ZoqYVSFp/dNx3ZCkfDXGCYbUYjq/XKwqTJG2Wz0M7PRLh//x0w9gP+vIce2A2h/zlaOfbAHIZPhlPHXRFLA9VaYt5HH3nBG+tBL1mij0XT6QrpSgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683411; c=relaxed/simple;
	bh=6ZohkvxGPhQyGE+Lr6a/jaPX6t3zSQXvdBGGXwI8/Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGyxJ6rsrrQBuMzEdOSmTRvgIPjPw/qt+ZJWocdTs4v/TJuXLSzZPqtBLL70QhTXwlwyT5PUz5ydbDNii/82ksAQ+o1iQxUwgs/kYRqbCQlDw1yQKZ9F2LLLRwmqQguYPPUns8PPRgem2+/6vJGnoKg3SsrvIrgkvAVZGcJcIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWabEqrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWabEqrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9B4C32786;
	Thu,  6 Jun 2024 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683411;
	bh=6ZohkvxGPhQyGE+Lr6a/jaPX6t3zSQXvdBGGXwI8/Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWabEqrw8dWiLJaX6GGDFaC3z6KwNmfIxdO3ZKLkXy3Itn9DkiKLEk6E9qtuqtp4k
	 VYVS7QFaGEVVxYt2OTKFDtEF6dha4K/NBsXkyhY5Q5ZonGe7k0KHeEuq6UnlsmG3Fr
	 MD8XPmj9HB1kvQ5+fDyKugHGboUNytm+htqKXjng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 355/744] clk: qcom: dispcc-sm8450: fix DisplayPort clocks
Date: Thu,  6 Jun 2024 16:00:27 +0200
Message-ID: <20240606131743.866810080@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e801038a02ce1e8c652a0b668dd233a4ee48aeb7 ]

On SM8450 DisplayPort link clocks use frequency tables inherited from
the vendor kernel, it is not applicable in the upstream kernel. Drop
frequency tables and use clk_byte2_ops for those clocks.

This fixes frequency selection in the OPP core (which otherwise attempts
to use invalid 810 KHz as DP link rate), also fixing the following
message:
msm-dp-display ae90000.displayport-controller: _opp_config_clk_single: failed to set clock rate: -22

Fixes: 16fb89f92ec4 ("clk: qcom: Add support for Display Clock Controller on SM8450")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240424-dispcc-dp-clocks-v2-1-b44038f3fa96@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8450.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8450.c b/drivers/clk/qcom/dispcc-sm8450.c
index 2c4aecd75186b..239cc726c7e29 100644
--- a/drivers/clk/qcom/dispcc-sm8450.c
+++ b/drivers/clk/qcom/dispcc-sm8450.c
@@ -309,26 +309,17 @@ static struct clk_rcg2 disp_cc_mdss_dptx0_aux_clk_src = {
 	},
 };
 
-static const struct freq_tbl ftbl_disp_cc_mdss_dptx0_link_clk_src[] = {
-	F(162000, P_DP0_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(270000, P_DP0_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(540000, P_DP0_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(810000, P_DP0_PHY_PLL_LINK_CLK, 1, 0, 0),
-	{ }
-};
-
 static struct clk_rcg2 disp_cc_mdss_dptx0_link_clk_src = {
 	.cmd_rcgr = 0x819c,
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_3,
-	.freq_tbl = ftbl_disp_cc_mdss_dptx0_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data) {
 		.name = "disp_cc_mdss_dptx0_link_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
@@ -382,13 +373,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_link_clk_src = {
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_3,
-	.freq_tbl = ftbl_disp_cc_mdss_dptx0_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data) {
 		.name = "disp_cc_mdss_dptx1_link_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
@@ -442,13 +432,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx2_link_clk_src = {
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_3,
-	.freq_tbl = ftbl_disp_cc_mdss_dptx0_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data) {
 		.name = "disp_cc_mdss_dptx2_link_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
@@ -502,13 +491,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx3_link_clk_src = {
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_3,
-	.freq_tbl = ftbl_disp_cc_mdss_dptx0_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data) {
 		.name = "disp_cc_mdss_dptx3_link_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
-- 
2.43.0



