Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D22347884A;
	Sat, 12 Sep 2026 12:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214604; cv=none; b=DcIkJeUozxgJEBBiXUzHDuMf02X8JvAxWE2/dwdKTsDqQjqTvUEuUCkisCJPp3/gcjFjDRDunS9xuYa6KbXd6eEjV/ojRL57uTLMBOHGwRnPIomwaQp3m19KlSY6eEmddSIjwpBbGqsrDnt/qy/SeRCJ8YP2WzhxBZDMzYC6Kn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214604; c=relaxed/simple;
	bh=8W/p+2vmXsxH+9SSWmkNo5WXfYyqlQMD0JtSOryVlpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+pf21x2UMMeT+U6aiOM/NudjghFa8fFH34ANqX/XCq6kX7nsmL7DLrZzabTAKV9widdMUdE8a/I7KnYyZcxpb/ex54jlXnWSIAX085MScbPlHNsd+EBWEzAKtQJNM7x5wwnSz9cvgJ9V1L8iD4T+LBFr5f2ARMsyhgjWrLnw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No4aT/Ns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No4aT/Ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E191F000FF;
	Sat, 12 Sep 2026 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214602;
	bh=g4JsrA/21yqRMF7CESc5rutZxgVG8Nm0EyMnz+dJLmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=No4aT/Nsod185bNeGVYaZxaSkNJdshva8ULMEDT3uVebMVwzOrDySkOzZGdtBLs2j
	 pe+l+14MR3qgfvLvqFRuMwCDEN3MhQ9wZHVfzeXeaNzILDoT7GRmazsCC0Y+NrIWJQ
	 w+WZ1SM5KzChzOr1ymIZyEZRugca5ga3wxu5SaQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0333/1376] clk: nuvoton: ma35d1-pll: convert from round_rate() to determine_rate()
Date: Sat, 12 Sep 2026 08:45:59 +0200
Message-ID: <20260912065614.969651793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



