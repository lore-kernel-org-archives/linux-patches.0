Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E12F90C5;
	Sat, 12 Sep 2026 14:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222417; cv=none; b=TcXPaokyov35Ys+1wL3+5qa3xpiXrwjKfiEZteOwXwCFMUVt6icEMR3rp5Y/YgWujXk5HvTa2KzLQyDkyS15MsFZ4OKqS/s7iOBSel10501jKXgfKeT4Q0x9P9cbL6VNalRkDalYdVvU/1JcikYltrlhbkZO5C0Ppv8z7Y8eBwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222417; c=relaxed/simple;
	bh=mCg+Kxng6OCrg+Nf4KjvwsLBAlxsEKo6t1ollJTz2IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHSN2nm/P5Suk5vyR8LRKlyq230KPs6XHJgvvxNwC1J+pBnqIAgmr/mWTYFBipQN7ar8a1yp0JLvQ+FYLE/KwEs1mI9VHIBzEUrMKwrfi5hb38FUbDW2rbecVH+r18FHvDMjSCqwGZNg/5CqWF0asilfLMm2RHDPp1ooMAqxZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbIGEJyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbIGEJyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB2E1F000FF;
	Sat, 12 Sep 2026 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222416;
	bh=GceHu7Xgmb7EspFeDx3+c9sSdXLfMHXfZSpkzNjkQn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbIGEJytUlLwnEHE2icG7LRhlcgV+Q7aHbdBx81Rvj6tEqOmfrVWz24GYn6lixu+n
	 UzWxDB9E9lPhU3gQV3bCswtLQXc+VEw3l8mu1xHsichxPs5Ifo1UDVa7EANvwhdfWl
	 H31h3QBAA55FQXA5H5Phv5XU2o1hLlxly4iwmwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0580/1424] clk: nuvoton: ma35d1-pll: convert from round_rate() to determine_rate()
Date: Sat, 12 Sep 2026 08:50:12 +0200
Message-ID: <20260912065620.283770578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit cd9e9bbfd93be277e316ee854614e2c4cd502fa8 ]

The round_rate() clk ops is deprecated, so migrate this driver from
round_rate() to determine_rate() using the Coccinelle semantic patch
on the cover letter of this series.

Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: e1311954cb60 ("clk: nuvoton: ma35d1: fix ma35d1_clk_pll_determine_rate logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1-pll.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1-pll.c b/drivers/clk/nuvoton/clk-ma35d1-pll.c
index 64f473fd770bc..eb9d69d2077b1 100644
--- a/drivers/clk/nuvoton/clk-ma35d1-pll.c
+++ b/drivers/clk/nuvoton/clk-ma35d1-pll.c
@@ -244,35 +244,43 @@ static unsigned long ma35d1_clk_pll_recalc_rate(struct clk_hw *hw, unsigned long
 	return 0;
 }
 
-static long ma35d1_clk_pll_round_rate(struct clk_hw *hw, unsigned long rate,
-				      unsigned long *parent_rate)
+static int ma35d1_clk_pll_determine_rate(struct clk_hw *hw,
+					 struct clk_rate_request *req)
 {
 	struct ma35d1_clk_pll *pll = to_ma35d1_clk_pll(hw);
 	u32 reg_ctl[3] = { 0 };
 	unsigned long pll_freq;
 	long ret;
 
-	if (*parent_rate < PLL_FREF_MIN_FREQ || *parent_rate > PLL_FREF_MAX_FREQ)
+	if (req->best_parent_rate < PLL_FREF_MIN_FREQ || req->best_parent_rate > PLL_FREF_MAX_FREQ)
 		return -EINVAL;
 
-	ret = ma35d1_pll_find_closest(pll, rate, *parent_rate, reg_ctl, &pll_freq);
+	ret = ma35d1_pll_find_closest(pll, req->rate, req->best_parent_rate,
+				      reg_ctl, &pll_freq);
 	if (ret < 0)
 		return ret;
 
 	switch (pll->id) {
 	case CAPLL:
 		reg_ctl[0] = readl_relaxed(pll->ctl0_base);
-		pll_freq = ma35d1_calc_smic_pll_freq(reg_ctl[0], *parent_rate);
-		return pll_freq;
+		pll_freq = ma35d1_calc_smic_pll_freq(reg_ctl[0], req->best_parent_rate);
+		req->rate = pll_freq;
+
+		return 0;
 	case DDRPLL:
 	case APLL:
 	case EPLL:
 	case VPLL:
 		reg_ctl[0] = readl_relaxed(pll->ctl0_base);
 		reg_ctl[1] = readl_relaxed(pll->ctl1_base);
-		pll_freq = ma35d1_calc_pll_freq(pll->mode, reg_ctl, *parent_rate);
-		return pll_freq;
+		pll_freq = ma35d1_calc_pll_freq(pll->mode, reg_ctl, req->best_parent_rate);
+		req->rate = pll_freq;
+
+		return 0;
 	}
+
+	req->rate = 0;
+
 	return 0;
 }
 
@@ -311,12 +319,12 @@ static const struct clk_ops ma35d1_clk_pll_ops = {
 	.unprepare = ma35d1_clk_pll_unprepare,
 	.set_rate = ma35d1_clk_pll_set_rate,
 	.recalc_rate = ma35d1_clk_pll_recalc_rate,
-	.round_rate = ma35d1_clk_pll_round_rate,
+	.determine_rate = ma35d1_clk_pll_determine_rate,
 };
 
 static const struct clk_ops ma35d1_clk_fixed_pll_ops = {
 	.recalc_rate = ma35d1_clk_pll_recalc_rate,
-	.round_rate = ma35d1_clk_pll_round_rate,
+	.determine_rate = ma35d1_clk_pll_determine_rate,
 };
 
 struct clk_hw *ma35d1_reg_clk_pll(struct device *dev, u32 id, u8 u8mode, const char *name,
-- 
2.53.0



