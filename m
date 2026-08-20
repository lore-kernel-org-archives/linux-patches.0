Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA55636212F;
	Thu, 20 Aug 2026 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238480; cv=none; b=iNy4FDX9VxdnCQd/DDrxVw+hFKD0g+C4z4G84rtn9TpDRmJlosfnkaKIFkkBSqWk62ODnMCG7fu+J9KSQeam6u9MdFy6Rr8gQgigHB3Jq7m7Ywavfgy7f7ifLy1X6caFG0ytxNaMorX15XsuGsHLBlUoI30NnBXy4c2h2fucEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238480; c=relaxed/simple;
	bh=CdaX+moBUiJqQeLAwSqWh7dZrzJ5uzNQ1YBZnMuBgDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3DP328HS+tzlQKXLElKQs0PLRojPnH/FCoW5ucPgfgSgIqZa7+CNBbSf2b2OkvG3+lp+27N7H55IvvSP054kAUu5eDQiZMgKbN3zlu1QE+/K+th5SQQoc/pZXJJyDtqGAN9/ThJojrAEQHJeT6A1ju3Jgm1Tdow44tp4OvKYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sAREnJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sAREnJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED011F000E9;
	Thu, 20 Aug 2026 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238479;
	bh=14aCo1TT+XVv/wFN+bEQEDFkSgSqUCtBCajhYUDpZsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sAREnJOr/5zDog7KwgGlYV/AdR5SQJLxb7NJKkJFfG/wspUfXEuao2gJPl4dEnEB
	 +wRXkiWx8QfGzVmniyFtrsPcZjo8sp7vstJwMDgL/hptfHIZ2mJjE7YVuHuAV0ttl/
	 GStapvAMgO0LfDsQewRNyHWze8MHM0SjkYH6YC8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 162/228] clk: qcom: dispcc-eliza: Fix disp_cc_mdss_mdp_clk_src RCG stall on Eliza EVK
Date: Thu, 20 Aug 2026 16:55:04 +0200
Message-ID: <20260820145249.600641856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 2ef00630c5c0b7b2c08aba7643f47594952d357e ]

Eliza EVK (eliza-cqs-evk.dts) does not have display enabled, however its
Display Clock Controller is enabled and references parent clocks from
DSI PHYs, which causes clock reparenting issues during probe (init) and
warning on Eliza EVK:

  disp_cc_mdss_mdp_clk_src: rcg didn't update its configuration.
  WARNING: drivers/clk/qcom/clk-rcg2.c:136 at update_config+0xd4/0xe4, CPU#1: udevd/273
  ...
    update_config (drivers/clk/qcom/clk-rcg2.c:136 (discriminator 2)) (P)
    clk_rcg2_shared_disable (drivers/clk/qcom/clk-rcg2.c:1471)
    clk_rcg2_shared_init (drivers/clk/qcom/clk-rcg2.c:1540)
    __clk_register (drivers/clk/clk.c:3959 drivers/clk/clk.c:4368)
    devm_clk_hw_register (drivers/clk/clk.c:4448 (discriminator 1) drivers/clk/clk.c:4672 (discriminator 1))
    devm_clk_register_regmap (drivers/clk/qcom/clk-regmap.c:104)
    qcom_cc_really_probe (drivers/clk/qcom/common.c:418)
    qcom_cc_probe (drivers/clk/qcom/common.c:445)
    disp_cc_eliza_probe (dispcc-eliza.c:?) dispcc_eliza
    platform_probe (drivers/base/platform.c:1432)

Fixes: 0e66f10942b5 ("clk: qcom: dispcc-eliza: Add Eliza display clock controller support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623115644.392477-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-eliza.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-eliza.c b/drivers/clk/qcom/dispcc-eliza.c
index 479f26e0dde29..e31c241252744 100644
--- a/drivers/clk/qcom/dispcc-eliza.c
+++ b/drivers/clk/qcom/dispcc-eliza.c
@@ -757,7 +757,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.parent_data = disp_cc_parent_data_11,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_11),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
2.53.0



