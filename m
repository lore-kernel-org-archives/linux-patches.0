Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BFA19B5BD;
	Thu,  6 Jun 2024 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683414; cv=none; b=rayQd0x4VIxxGKYfpMCF/O3FOuZ4u3gwkKak9PJ9hIWr0lpe8xi5e4vZROf4gMEf1pqiHzcKjb7tuIuvbvxzJD9M6qq2zm1TqAVXG6vHb54T6FbR3sh5rXe/fK9cPBr/Fh/QdB7oLFJeGgAEvUAML12J4XQeVFvw4J1RQ32bZDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683414; c=relaxed/simple;
	bh=RhYiE0ZvNkteGPnZLxN6aVOgbiD/a21QMcfxAgTfrC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhuW+40PbU9Wr8vyv0WCQsMrFM+WTnFrH5Cx+99So4zGq1oypusUSPz8i3iaXjFphibLIBBPUG/cmFuJqquJTcuCYl5jYVNAs/SOHE9ebgdZZdd5cCkiMS6/TwLho9C34dHXU/uao0JsNmEyatzgy5pmWA1w7fgeX9NGl4mPpYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad3EQnAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad3EQnAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E485CC32786;
	Thu,  6 Jun 2024 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683413;
	bh=RhYiE0ZvNkteGPnZLxN6aVOgbiD/a21QMcfxAgTfrC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad3EQnAg+qvynaLRhMDsU7jvHv1jt51Ph9Xrup80RDjVY5wJZ54OIcjuoPt1YaYn+
	 SGzZHi04AxDkitX9VOts3s+ewutkZWQvGpQcsggBicIuHVkgo+nE43jL5GNeiwwLja
	 /e3hrPQ3Oto28fTAHHP86Ve/RrnyIaE0VkByxA34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/744] clk: qcom: dispcc-sm8550: fix DisplayPort clocks
Date: Thu,  6 Jun 2024 16:00:29 +0200
Message-ID: <20240606131743.932189163@linuxfoundation.org>
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

[ Upstream commit e90b5139da8465a15c3820b4b67ca9468dce93b4 ]

On SM8550 DisplayPort link clocks use frequency tables inherited from
the vendor kernel, it is not applicable in the upstream kernel. Drop
frequency tables and use clk_byte2_ops for those clocks.

This fixes frequency selection in the OPP core (which otherwise attempts
to use invalid 810 KHz as DP link rate), also fixing the following
message:
msm-dp-display ae90000.displayport-controller: _opp_config_clk_single: failed to set clock rate: -22

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240424-dispcc-dp-clocks-v2-3-b44038f3fa96@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 0b8f0904b339b..b9edeb2a221dc 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -345,26 +345,17 @@ static struct clk_rcg2 disp_cc_mdss_dptx0_aux_clk_src = {
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
 	.cmd_rcgr = 0x8170,
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_7,
-	.freq_tbl = ftbl_disp_cc_mdss_dptx0_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data) {
 		.name = "disp_cc_mdss_dptx0_link_clk_src",
 		.parent_data = disp_cc_parent_data_7,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_7),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
@@ -418,13 +409,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_link_clk_src = {
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
 
@@ -478,13 +468,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx2_link_clk_src = {
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
 
@@ -538,13 +527,12 @@ static struct clk_rcg2 disp_cc_mdss_dptx3_link_clk_src = {
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



