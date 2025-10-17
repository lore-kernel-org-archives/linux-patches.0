Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EDE337100;
	Fri, 17 Oct 2025 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713117; cv=none; b=PMXGg02dND1Uit6tfM2Effl9lhGvgFd1/COBOy57I1H4nZhM5hm4aR13ovWfOwxbbzri9XpjBcnRezbCt/Eheu+oHShH9G335cKbV0Ivp+4Fwi0WjM98CeWfu+rqSCOlbRD8zUNK4wJSEVqSnSRWZ7b+JQarACk34vdmR0twyOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713117; c=relaxed/simple;
	bh=8XIcjDTpwWtUowTtMMhMRxcnzUe2E+03RXfBQFuW7Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MezD/EgrKXwlxZBTm48Oa8lA00jCEsy3JJP4u8cWf1ulNm88+6FXl656KuXxZLIFTCF1vXoqLezTmSKCKIyXiXy97cbR+JfqT0Oah39F2nQGLsPirP5SUaRSEl6MubliUnNBeIaWTgNh947HekBQ1Vkn+wPCkn1vGcsZ9Llfx3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrkJcjba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrkJcjba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923CBC113D0;
	Fri, 17 Oct 2025 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713116;
	bh=8XIcjDTpwWtUowTtMMhMRxcnzUe2E+03RXfBQFuW7Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrkJcjbadK/v+NFwbYW/K9GWA1MV1XYQ2b8pl3pgc4QpXhnoa4RSQ4uzDTgdTinlf
	 /Ts9gAZXSTTbhBrID4zEThQz8cmnvz9+Dd2bWYkUy4XRtYrdKi9mOrD4mku8nfi59Z
	 Bw2wIe9sciF+475v/EBp4ZuKDJtjXQkZV8no7Mk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/168] clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()
Date: Fri, 17 Oct 2025 16:51:39 +0200
Message-ID: <20251017145129.764001504@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 69ebf65081b81..821155f79b015 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -371,23 +371,25 @@ static unsigned long lpc18xx_pll0_recalc_rate(struct clk_hw *hw,
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
@@ -444,7 +446,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 
 static const struct clk_ops lpc18xx_pll0_ops = {
 	.recalc_rate	= lpc18xx_pll0_recalc_rate,
-	.round_rate	= lpc18xx_pll0_round_rate,
+	.determine_rate = lpc18xx_pll0_determine_rate,
 	.set_rate	= lpc18xx_pll0_set_rate,
 };
 
-- 
2.51.0



