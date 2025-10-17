Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C992A32C93E;
	Fri, 17 Oct 2025 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715095; cv=none; b=TyGNVRrGraWXbEHo4SywSCs85JONXzdEWvwADRGokPvHfht+RdHovRlp554rzMQVDDJwW1PCo5jTvF+XADoh8Xy0Z6o6VhGsuA09rIb5ST4cp59kPVVGwBc8ZHuw2nyyMMyrivRCfPHUTxuDvuedIagMOzp9R+b2v8S94eEY9N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715095; c=relaxed/simple;
	bh=n5JT378is70nGsmUiCVr/+3lnjZSqc0fXDc1VDUynJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOj8OOjNut4amiT6Q5OJpejsuOerc5ex5iPwWnsTBzVQMJpEGvgbdyo9Mvee6Oo3o6BO6SaT6SdYtsXLNjTaKLqQ4YuxQS7l1sSLs9OxHVNFXGRv6uA+Unyf/wna+JlCc0aNM8qUJLYDndKdtm6lsDQWNA3uPHEFDjMUvT/mTmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4fwoDV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4fwoDV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56718C4CEE7;
	Fri, 17 Oct 2025 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715095;
	bh=n5JT378is70nGsmUiCVr/+3lnjZSqc0fXDc1VDUynJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4fwoDV0dkyv9j+QuzBm9j/8pFOZ5i5YG4DEzV5vxozP/JE7v6v0SvVJLrTf5lzmi
	 V7txOWPlNakdgPSfWWAXi18MG3lRlubMd2cZdQ3hhbdUEqtx4MgF6jhWX3RW1mK6U9
	 yXyTF0RmoT7qrA2BxXxukAu1CGu8z5KIVo43P1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 053/371] clk: nxp: lpc18xx-cgu: convert from round_rate() to determine_rate()
Date: Fri, 17 Oct 2025 16:50:28 +0200
Message-ID: <20251017145203.718559098@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 81efa885069b2..30e0b283ca608 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -370,23 +370,25 @@ static unsigned long lpc18xx_pll0_recalc_rate(struct clk_hw *hw,
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
@@ -443,7 +445,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 
 static const struct clk_ops lpc18xx_pll0_ops = {
 	.recalc_rate	= lpc18xx_pll0_recalc_rate,
-	.round_rate	= lpc18xx_pll0_round_rate,
+	.determine_rate = lpc18xx_pll0_determine_rate,
 	.set_rate	= lpc18xx_pll0_set_rate,
 };
 
-- 
2.51.0



