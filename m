Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BE1330B17;
	Fri, 17 Oct 2025 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716287; cv=none; b=uiqaJm223c9STmi93+vuQN6jlK6pdjfUNkJTHK/rnX2dEOTwkuva28F+9q+03SizZu131ztEVezcFWL9MepJ9IQSaq/nUZZyODLSO59UB+9vHa64kwPDntXvq69R5+SUAf7p81ZSIctduemN/oSte4HnS232RZy0DEtESFKlOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716287; c=relaxed/simple;
	bh=yICCwW4j3tnPLLWi6r9JW0nu/ARFV20zQPbosPSv8Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNB1Si9CPB4Em0MS7uCkw8YQGghMGEgPEyEc1+Kz94VEe+mgMI2z/GTYARs6ALMfRUn/oZi4A9HSHS/PZSPgjpLRrSK52g/nn3kmnys0yElFxE5kKDdHbLZRjTg9tcb2Cb8NhHQYCp9FPuMtY2KCQvfepysft70d/bV/qXZWJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mb5LDI/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mb5LDI/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DC0C116B1;
	Fri, 17 Oct 2025 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716287;
	bh=yICCwW4j3tnPLLWi6r9JW0nu/ARFV20zQPbosPSv8Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mb5LDI/K4jVgMiyOxPUCAXoJwZvcSm2KgrFZtWtHtpwqzdZyADUrXPnWKSAOyEqW7
	 g7Hl/dXtcxnad5x7qQfEJLQ6r/j1vDK8BFPilLkvX8PTN1RwAvXahfQpV4qO7RANya
	 HFKyJKJETwDFYx5ZJ2djkMXNvizwxysNZ5WeofvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/276] clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()
Date: Fri, 17 Oct 2025 16:53:50 +0200
Message-ID: <20251017145147.484487053@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



