Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D924E3370FB;
	Fri, 17 Oct 2025 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713119; cv=none; b=hSyRLDu8wZu2eUC1bq9VaQSL8vMsCW5hvEevcAYuVpqPFy25Z1TeN5IG3PiTE6Ul37fmUYeOGaHwAVOrTvBGKsSdyIOovWHPd+k06ZOhtTOLH+j3oMNqt0sfUEIjHhAkG7mEvIY+cv5gpJpQ9zGSwPK+7Hp3kxr+Go8Vl3mzD7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713119; c=relaxed/simple;
	bh=WxfrMWgp7y022tna2FxrONf2j3A5z6XFp3E2gmszvOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfvqrJi5SZuXDLzpThwYcoqtg/KCY5RO6QVlmv1J7hWEOmGtMOxlohCvtF+xD2gFGmDpTxO+bFRxpx0ahQ3R73Yy4dqEfXH6mvd2heaao86vfJ1kBJV4G8ysR3ayURI0/s8BsKG4KMuyZLfoA7YW/m0m15c1iS1IZnC3u0BdPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGkGbm0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGkGbm0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BC4C4CEE7;
	Fri, 17 Oct 2025 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713119;
	bh=WxfrMWgp7y022tna2FxrONf2j3A5z6XFp3E2gmszvOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGkGbm0AAtIKmpqe+WnM4veuOMWVic9Sbzcfw86hc1ziKjsBcI0XrpSnPQ1MDDRiO
	 JRf+5bKpiRseB5x3nZqX916XB4u+QJRQ2lJZSKxozTp1tRTBFUqTPUsvt1HjaSPdu7
	 KFbBcTaCXuibuFvm4FpVld1v4KQxcmL1Tm4DXj1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/168] clk: nxp: Fix pll0 rate check condition in LPC18xx CGU driver
Date: Fri, 17 Oct 2025 16:51:40 +0200
Message-ID: <20251017145129.800181773@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 1624dead9a4d288a594fdf19735ebfe4bb567cb8 ]

The conditional check for the PLL0 multiplier 'm' used a logical AND
instead of OR, making the range check ineffective. This patch replaces
&& with || to correctly reject invalid values of 'm' that are either
less than or equal to 0 or greater than LPC18XX_PLL0_MSEL_MAX.

This ensures proper bounds checking during clk rate setting and rounding.

Fixes: b04e0b8fd544 ("clk: add lpc18xx cgu clk driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
[sboyd@kernel.org: 'm' is unsigned so remove < condition]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nxp/clk-lpc18xx-cgu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nxp/clk-lpc18xx-cgu.c b/drivers/clk/nxp/clk-lpc18xx-cgu.c
index 821155f79b015..bbd7d64038fab 100644
--- a/drivers/clk/nxp/clk-lpc18xx-cgu.c
+++ b/drivers/clk/nxp/clk-lpc18xx-cgu.c
@@ -382,7 +382,7 @@ static int lpc18xx_pll0_determine_rate(struct clk_hw *hw,
 	}
 
 	m = DIV_ROUND_UP_ULL(req->best_parent_rate, req->rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, req->rate);
 		return -EINVAL;
 	}
@@ -405,7 +405,7 @@ static int lpc18xx_pll0_set_rate(struct clk_hw *hw, unsigned long rate,
 	}
 
 	m = DIV_ROUND_UP_ULL(parent_rate, rate * 2);
-	if (m <= 0 && m > LPC18XX_PLL0_MSEL_MAX) {
+	if (m == 0 || m > LPC18XX_PLL0_MSEL_MAX) {
 		pr_warn("%s: unable to support rate %lu\n", __func__, rate);
 		return -EINVAL;
 	}
-- 
2.51.0



