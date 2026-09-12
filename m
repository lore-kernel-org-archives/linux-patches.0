Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA614156C2;
	Sat, 12 Sep 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214657; cv=none; b=M7tmWfYkk9eZkHRVFfZ8luJ3258rTej/xu/xT/v1baXIUdBkr9yRX1ilcnplOmEzdKkatitB7Qb6MDvqYTYt+ZMKWLktj9H9ftkm1qSYSzcBCsV4IJ7L9cm+onbalR6kYN8dBTCRGIAynN269NJaI53doLWRCEuPmAiuNVckN9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214657; c=relaxed/simple;
	bh=KW9knIKRWRl1Ig5PumRVoFI/p6kVjMVsKh6Gk4TdrOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcbFyYQsq6gufO2VKUy8V223MoRaYyOtQYrBCq/72XtvLnouUmiBvUutzC6ijWaen8VhK+SNEwPD78048MUve3yaQ2HGzJoEgHzqBtbe0caPT3UmMInw717HuuDDyD3XIhMutz8pEjiF+Wv8SRzpHlP62EpJW7jh3LhChz+NVgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IO8KlF6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IO8KlF6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E570D1F000FF;
	Sat, 12 Sep 2026 12:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214656;
	bh=C8X8lTHau+qn/w2PiNJG+9xFkYXweda+TXZYHQY1v5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO8KlF6MbWlCWJ8yS2G+d2kLZ4wNhVIgwt3YPIvQnwSXE8uzwARoD5q+hBcIh2B9l
	 z+Lw80s0bdwg6Dp1h05hCOymb6Hifj18XTy+5socij+QxlFUEV8Y5aR3vxr260iQfz
	 MvyTOuj6YZ5MsknlthKvnvRFSap9LWw+KiT1ofFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Lu <a0987203069@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0334/1376] clk: nuvoton: ma35d1: fix ma35d1_clk_pll_determine_rate logic
Date: Sat, 12 Sep 2026 08:46:00 +0200
Message-ID: <20260912065614.991836092@linuxfoundation.org>
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

From: Joey Lu <a0987203069@gmail.com>

[ Upstream commit e1311954cb600d5f95cd9e2fe9a7376edc2ac3c5 ]

ma35d1_clk_pll_determine_rate() called ma35d1_pll_find_closest()
unconditionally before the switch statement, and then every case
branch overwrote pll_freq by reading the current hardware registers.
For CAPLL and DDRPLL this means find_closest() ran unnecessarily
(and incorrectly, since those PLLs are read-only) and its result
was silently discarded.

Fix by moving the find_closest() call inside the APLL/EPLL/VPLL
branch where it belongs.  Group CAPLL and DDRPLL together as
read-only PLLs that simply report their current rate; handle them
with an explicit if/else to keep the CAPLL (SMIC design) and DDRPLL
(standard design) paths distinct.

Fixes: 691521a367cf ("clk: nuvoton: Add clock driver for ma35d1 clock controller")
Signed-off-by: Joey Lu <a0987203069@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1-pll.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1-pll.c b/drivers/clk/nuvoton/clk-ma35d1-pll.c
index eb9d69d2077b1..c7c0dc91a012c 100644
--- a/drivers/clk/nuvoton/clk-ma35d1-pll.c
+++ b/drivers/clk/nuvoton/clk-ma35d1-pll.c
@@ -255,32 +255,32 @@ static int ma35d1_clk_pll_determine_rate(struct clk_hw *hw,
 	if (req->best_parent_rate < PLL_FREF_MIN_FREQ || req->best_parent_rate > PLL_FREF_MAX_FREQ)
 		return -EINVAL;
 
-	ret = ma35d1_pll_find_closest(pll, req->rate, req->best_parent_rate,
-				      reg_ctl, &pll_freq);
-	if (ret < 0)
-		return ret;
-
 	switch (pll->id) {
 	case CAPLL:
+	case DDRPLL:
+		/* Read-only PLLs: return current rate */
 		reg_ctl[0] = readl_relaxed(pll->ctl0_base);
-		pll_freq = ma35d1_calc_smic_pll_freq(reg_ctl[0], req->best_parent_rate);
+		if (pll->id == CAPLL) {
+			pll_freq = ma35d1_calc_smic_pll_freq(reg_ctl[0], req->best_parent_rate);
+		} else {
+			reg_ctl[1] = readl_relaxed(pll->ctl1_base);
+			pll_freq = ma35d1_calc_pll_freq(pll->mode, reg_ctl, req->best_parent_rate);
+		}
 		req->rate = pll_freq;
-
 		return 0;
-	case DDRPLL:
 	case APLL:
 	case EPLL:
 	case VPLL:
-		reg_ctl[0] = readl_relaxed(pll->ctl0_base);
-		reg_ctl[1] = readl_relaxed(pll->ctl1_base);
-		pll_freq = ma35d1_calc_pll_freq(pll->mode, reg_ctl, req->best_parent_rate);
+		/* Configurable PLLs: find closest achievable rate */
+		ret = ma35d1_pll_find_closest(pll, req->rate, req->best_parent_rate,
+					      reg_ctl, &pll_freq);
+		if (ret < 0)
+			return ret;
 		req->rate = pll_freq;
-
 		return 0;
 	}
 
 	req->rate = 0;
-
 	return 0;
 }
 
-- 
2.53.0



