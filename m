Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06032C331;
	Mon, 27 Oct 2025 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591201; cv=none; b=eGDCAPXIBGCMdYP1ZkTnKIr2bflx2LpFUoMECUKNgavX6OPf3nI4tWG8EgmyZ5EEWBGNJ1pdrk1grJBe4oi4t1FlaiwGe0CfH8EL8nJdnDjcajVmuaEO+qKDjkPV1WyEKIqXhu9QOuTCfi9zWWSaKfo8/2m4+r2HzHgkEUGLCKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591201; c=relaxed/simple;
	bh=21hdOF/QON3yF0lasUOV7ak+PWq0pJ+BGiQvtCCCBK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MehgTJy53Ewrqdqf+rANsgGNuZoNiVzFO3KkEBnm3pJ23md/GC3VzHaW7VyafzdbC/fzjWCYsDk5E/zs93EmFAXMExG9C44Hz1a52lF26hrAn0mBJwoXoJlow0axUQo695v94Yzq7gmEYYVXTwFh8/Li/XRQcivvBrTyHKD0f6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3jrSHWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3jrSHWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594DC4CEF1;
	Mon, 27 Oct 2025 18:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591200;
	bh=21hdOF/QON3yF0lasUOV7ak+PWq0pJ+BGiQvtCCCBK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3jrSHWVHYzGpuA8edVN76kik0CdD/r8CoVwK0vPLFtv+kZ8UcXBI0W5rDOD25whc
	 alcoO1gTT+Uo2VnegYOWGHJf2T3bzdM5d0pTZeFts0X+BZzelJ+N8wy1LqnimwvJ2W
	 MP+kbk8UhjSibfXkIH2qPsIQHcZ34H3Ga5qO1duQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/332] clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()
Date: Mon, 27 Oct 2025 19:32:37 +0100
Message-ID: <20251027183527.363008002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit b46a3d323a5b7942e65025254c13801d0f475f02 ]

The round_rate() clk ops is deprecated, so migrate this driver from
round_rate() to determine_rate() using the Coccinelle semantic patch
on the cover letter of this series.

Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1624dead9a4d ("clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nxp/clk-lpc18xx-cgu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/nxp/clk-lpc18xx-cgu.c b/drivers/clk/nxp/clk-lpc18xx-cgu.c
index 8b686da5577b3..44e07a3c253b9 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -374,23 +374,25 @@ static unsigned long lpc18xx_pll0_recalc_rate(struct clk_hw *hw,
 	return 0;
 }
 
-static long lpc18xx_pll0_round_rate(struct clk_hw *hw, unsigned long rate,
-				    unsigned long *prate)
+static int lpc18xx_pll0_determine_rate(struct clk_hw *hw,
+				       struct clk_rate_request *req)
 {
 	unsigned long m;
 
-	if (*prate < rate) {
+	if (req->best_parent_rate < req->rate) {
 		pr_warn("%s: pll dividers not supported\n", __func__);
 		return -EINVAL;
 	}
 
-	m = DIV_ROUND_UP_ULL(*prate, rate * 2);
+	m = DIV_ROUND_UP_ULL(req->best_parent_rate, req->rate * 2);
 	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
-		pr_warn("%s: unable to support rate %lu\n", __func__, rate);
+		pr_warn("%s: unable to support rate %lu\n", __func__, req->rate);
 		return -EINVAL;
 	}
 
-	return 2 * *prate * m;
+	req->rate = 2 * req->best_parent_rate * m;
+
+	return 0;
 }
 
 static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -447,7 +449,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 
 static const struct clk_ops lpc18xx_pll0_ops = {
 	.recalc_rate	= lpc18xx_pll0_recalc_rate,
-	.round_rate	= lpc18xx_pll0_round_rate,
+	.determine_rate = lpc18xx_pll0_determine_rate,
 	.set_rate	= lpc18xx_pll0_set_rate,
 };
 
-- 
2.51.0



