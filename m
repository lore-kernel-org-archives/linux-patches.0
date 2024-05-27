Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3F61FDF;
	Mon, 27 May 2024 19:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838682; cv=none; b=gqQS36107xNYNdmueisvgEroiq7IDCElWcxcpSsy8WUEY4fHV/3XB1hokcG9CVY7NOXvbEIrzLfHfC9bzRoa0MMZa3NrHYXxF9NZsmxjbwCavGBkE7mZiCcLhQfNN2gHiUB97i2RbS3AdtnfM6eKfsXMP/sTDP+pCPruO+2I3kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838682; c=relaxed/simple;
	bh=tjFm5hsxDafpMR1PwzlloO1IKP+4UWmcoLfd67KmuGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh3mKVfz3ckDGPxoQ9mKc6rlAiv9AEZhhbBTuBv8YLzMQXzXcyU55oEPg03+t7QLB7g6rEsCCSxuZ/akY6TZ689HdqGejT6bPZV9hxam0n7CD8WYTfv7YOqBoZZHMZDqcMotsSsSnc+1DEQPGmTonkrbtrDxUo6nZopNUc4vxQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxsQdAvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxsQdAvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7358FC2BBFC;
	Mon, 27 May 2024 19:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838681;
	bh=tjFm5hsxDafpMR1PwzlloO1IKP+4UWmcoLfd67KmuGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxsQdAvL9WHx6dNTl5pdpNSQyFcutOH9Xx25SQDHK310p+dZXObfuY3CKiL9aDFU7
	 2CTiax6p6vAluPQYKsESofGPkehfhas1JF/zTx6L6IS9cGf8hVMjI0hJe6VCOSMkXH
	 Kp91IMpJR15jql5JjmBUphC9Xmu67OXJrnXvLE1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 444/493] clk: qcom: dispcc-sm6350: fix DisplayPort clocks
Date: Mon, 27 May 2024 20:57:26 +0200
Message-ID: <20240527185644.773045141@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1113501cfb46d5c0eb960f0a8a9f6c0f91dc6fb6 ]

On SM6350 DisplayPort link clocks use frequency tables inherited from
the vendor kernel, it is not applicable in the upstream kernel. Drop
frequency tables and use clk_byte2_ops for those clocks.

This fixes frequency selection in the OPP core (which otherwise attempts
to use invalid 810 KHz as DP link rate), also fixing the following
message:
msm-dp-display ae90000.displayport-controller: _opp_config_clk_single: failed to set clock rate: -22

Fixes: 837519775f1d ("clk: qcom: Add display clock controller driver for SM6350")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240424-dispcc-dp-clocks-v2-2-b44038f3fa96@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm6350.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm6350.c b/drivers/clk/qcom/dispcc-sm6350.c
index ea6f54ed846ec..441f042f5ea45 100644
--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -221,26 +221,17 @@ static struct clk_rcg2 disp_cc_mdss_dp_crypto_clk_src = {
 	},
 };
 
-static const struct freq_tbl ftbl_disp_cc_mdss_dp_link_clk_src[] = {
-	F(162000, P_DP_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(270000, P_DP_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(540000, P_DP_PHY_PLL_LINK_CLK, 1, 0, 0),
-	F(810000, P_DP_PHY_PLL_LINK_CLK, 1, 0, 0),
-	{ }
-};
-
 static struct clk_rcg2 disp_cc_mdss_dp_link_clk_src = {
 	.cmd_rcgr = 0x10f8,
 	.mnd_width = 0,
 	.hid_width = 5,
 	.parent_map = disp_cc_parent_map_0,
-	.freq_tbl = ftbl_disp_cc_mdss_dp_link_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_link_clk_src",
 		.parent_data = disp_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT | CLK_GET_RATE_NOCACHE,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_byte2_ops,
 	},
 };
 
-- 
2.43.0



