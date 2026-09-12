Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C82346A08;
	Sat, 12 Sep 2026 07:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197029; cv=none; b=EHnywn7NrVt3gaAnkmoV/wmrN8BxJRRoWp0YtLLlHs0KaTCi/3uwi1O98IZTGlGXUdk7zjCG7E9j/wjC8q/BO/7GN/qkb053iIUcVl3v5b4ndp2J0p8PvqlffeBoacFzIZfHxOe6jev/xwo3TzhwQWTS/I8pntBH0tnHux8tjNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197029; c=relaxed/simple;
	bh=MFEAeTqucpqyNR/oMaEsMhumYDfXArxSGHB/gmPLqt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjaoC7vXefQaBZqDWO07k4WPinJVbzYDmi4mU/q6Z3r7QHMCVTHWpHGjWXRql41Hn5eyL+rrqDPkiazbXMQySRHY85bf15Hsf3UWXXDIe0v8WRGF5Dv0ftiof3iVvfHHG2UXOH041Onb5MoCeitilSstaqXzA94K1hcWU2Gk0fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hedsK3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hedsK3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8BF1F000FF;
	Sat, 12 Sep 2026 07:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197027;
	bh=bYO+mumta/l2Kb7ymxf3fHnqHMadR/l+RGlcX6580r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hedsK3aO7Cl1GvYe1v6fsIy4ClIiL8zsoXEscaKw9jGncMDa9PGBeUGSTLkp6qeC
	 1tUPvTTK/6sHvJfqBc2AkVoK3wX4GElsyAVY1vMEzRy5J/gk1AID21+cA3FnlHlHVF
	 V7Gng+7K/Q7fFTfgpaMjjGzvRBJadUOutG6opDZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Lu <a0987203069@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0084/1815] clk: nuvoton: ma35d1: fix ma35d1_clk_pll_determine_rate logic
Date: Sat, 12 Sep 2026 08:30:34 +0200
Message-ID: <20260912065650.979983736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



