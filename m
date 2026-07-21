Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AF8415F3F;
	Tue, 21 Jul 2026 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656993; cv=none; b=cw2mK0slsk1BGGiuXKS/SE89fIpfE6EKnCCNWqFVWlXUfPspIQ9go41kBeTwt3EEaL58CINi8nnBD1l2SM/v9m6/OCvhmrBF2+0Pf2N7JAarjYkT/3OcvHFgg9m8j62bHnD8Ji/DzOkuMOyCknZtbTnEGuPRl0wwdtqECNFH2Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656993; c=relaxed/simple;
	bh=1tG8Orz9OQC58UJv3Df8rT/QdFNvoyBK6iSbPiNa+uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsLDa1Hz+kT1rWJhqJV/xYyjn+sh18FakDnrPzBblqkRpdFcR7z3i2TgJmFfxtGmZFGkxFSAjASn2qUrrOoqfe3DRy3g3m0JQaIuUcev41/aoaiZI+BowKUvJxJvrNPGN+2NQ52AR/zJrBsA7DTHS8e00T7hqqIJAhvXCMOkxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UF5xJo0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UF5xJo0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CEC1F000E9;
	Tue, 21 Jul 2026 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656992;
	bh=lTa9z1sEIGwa38vNttPYNnZKI9kU0cNM/raC9+J53mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UF5xJo0robdBTWH6vHelO5vS4FUrY1Nd1cHkSuASivt0J4dLeqq42uLTLr9ZPjdAM
	 jX2zOC5dkNr9aAq9csbXnCDzkhw7LUZ65DxVjaduabxcOTrhx9q4nuJKkVrAKqXoic
	 oafwwH/EYWg/b9y3ZYI5AIY3VxqQcVgsfZzj9dUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <jie.luo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	George Moussalem <george.moussalem@outlook.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0595/1611] clk: qcom: cmnpll: Account for reference clock divider
Date: Tue, 21 Jul 2026 17:11:51 +0200
Message-ID: <20260721152528.768598543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dafbf57320480c..369798d1ce4279 100644
--- a/drivers/clk/qcom/ipq-cmn-pll.c
+++ b/drivers/clk/qcom/ipq-cmn-pll.c
@@ -185,7 +185,7 @@ static unsigned long clk_cmn_pll_recalc_rate(struct clk_hw *hw,
 					     unsigned long parent_rate)
 {
 	struct clk_cmn_pll *cmn_pll = to_clk_cmn_pll(hw);
-	u32 val, factor;
+	u32 val, factor, ref_div;
 
 	/*
 	 * The value of CMN_PLL_DIVIDER_CTRL_FACTOR is automatically adjusted
@@ -193,8 +193,15 @@ static unsigned long clk_cmn_pll_recalc_rate(struct clk_hw *hw,
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



