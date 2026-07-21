Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A1C38910F;
	Tue, 21 Jul 2026 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660133; cv=none; b=TbLWu9o45d/+BiZxoqRg3dsZVBLmiqohTz2Utk9UWZhie93nJ4RPNWfRpsLt3oDeLu7hKFWKvjpW0ZqAkZ/V351tvciEIxivM+gVklAVJngq93BeMaFCNb+IOdKfBtROmoK5PehncMPOL1av8t1leazh5bOvNSAzDjgadn8ZM5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660133; c=relaxed/simple;
	bh=4bYt0Kw1CqbLG8eCIehJzw+Iyw1CP9aPhSEakPOF6Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I55DAr7xbsp+fD4iOZTlpqQnQs+eoO6bsdvc3zM0kQoaq39id6D3OrCrM4gjTX8EiSdfPzbosGmaI1M8rqLWfga8t7vmYiJkBeznaiXn1YpD5tBKT7n5XGTVzzJSJ3LxkRAJTb+ObFajAHbeUq76CNukjWHfKnCvVKkCKc4+KlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBwO2VXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBwO2VXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E2D1F000E9;
	Tue, 21 Jul 2026 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660132;
	bh=lcpo03oaBNqHxk5GrSzM7Yd/JN+kT6O0w2LBgchIjjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBwO2VXLg/9U/B5O51O1bd6FW5OWtgNVbMLU69r8VZ+Qq4z1UCg91BCv9c4kDMt0j
	 hOQkOIuzRpFOMe8dCVrh/PA//uFVk81/l6DS+hH3g62547Q6kn/PDPwSm7QOCWCbzm
	 1jbvvkilXeDFvur/kpy+ymV4NnhpdGOy+K7QV138=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <jie.luo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	George Moussalem <george.moussalem@outlook.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0863/2077] clk: qcom: cmnpll: Account for reference clock divider
Date: Tue, 21 Jul 2026 17:08:56 +0200
Message-ID: <20260721152613.146983588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Luo Jie <jie.luo@oss.qualcomm.com>

[ Upstream commit 88c543fff756450bcd04ec4560c4440be36c9e75 ]

The clk_cmn_pll_recalc_rate() function must account for the reference clock
divider programmed in CMN_PLL_REFCLK_CONFIG. Without this fix, platforms
with a reference divider other than 1 calculate incorrect CMN PLL rates.
For example, on IPQ5332 where the reference divider is 2, the computed rate
becomes twice the actual output.

Read CMN_PLL_REFCLK_DIV and divide the parent rate by this value before
applying the 2 * FACTOR scaling. This yields the correct rate calculation:
rate = (parent_rate / ref_div) * 2 * factor.

Maintain backward compatibility with earlier platforms (e.g. IPQ9574,
IPQ5424, IPQ5018) that use ref_div = 1.

Fixes: f81715a4c87c ("clk: qcom: Add CMN PLL clock controller driver for IPQ SoC")
Signed-off-by: Luo Jie <jie.luo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: George Moussalem <george.moussalem@outlook.com>
Link: https://lore.kernel.org/r/20260106-qcom_ipq5332_cmnpll-v2-1-f9f7e4efbd79@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/ipq-cmn-pll.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/ipq-cmn-pll.c b/drivers/clk/qcom/ipq-cmn-pll.c
index 5763e4df59a1a2..889c176089c2fe 100644
--- a/drivers/clk/qcom/ipq-cmn-pll.c
+++ b/drivers/clk/qcom/ipq-cmn-pll.c
@@ -199,7 +199,7 @@ static unsigned long clk_cmn_pll_recalc_rate(struct clk_hw *hw,
 					     unsigned long parent_rate)
 {
 	struct clk_cmn_pll *cmn_pll = to_clk_cmn_pll(hw);
-	u32 val, factor;
+	u32 val, factor, ref_div;
 
 	/*
 	 * The value of CMN_PLL_DIVIDER_CTRL_FACTOR is automatically adjusted
@@ -207,8 +207,15 @@ static unsigned long clk_cmn_pll_recalc_rate(struct clk_hw *hw,
 	 */
 	regmap_read(cmn_pll->regmap, CMN_PLL_DIVIDER_CTRL, &val);
 	factor = FIELD_GET(CMN_PLL_DIVIDER_CTRL_FACTOR, val);
+	if (WARN_ON(factor == 0))
+		factor = 1;
 
-	return parent_rate * 2 * factor;
+	regmap_read(cmn_pll->regmap, CMN_PLL_REFCLK_CONFIG, &val);
+	ref_div = FIELD_GET(CMN_PLL_REFCLK_DIV, val);
+	if (WARN_ON(ref_div == 0))
+		ref_div = 1;
+
+	return div_u64((u64)parent_rate * 2 * factor, ref_div);
 }
 
 static int clk_cmn_pll_determine_rate(struct clk_hw *hw,
-- 
2.53.0



