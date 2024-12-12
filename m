Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D627235C20;
	Thu, 12 Dec 2024 16:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019648; cv=none; b=j4+hSzYKAcJBXlsWMJ0Du8g/MVOeSxRFpQS2qNNNbZKfVRFPSauq6lvUzyV5ys3k96ZP2zM4ahMsC2B00C3zrBiHbYN59IloyQgRSFqpqxkw8Nm6/l/TBfNA/gQhcCq4woWQQ7hhvqy9vMldjHRfS6cqIGYJ7bPzVFy/xIWhMno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019648; c=relaxed/simple;
	bh=Zjl8D9dAV+If303y+A+Diof5J/XBXhrA3YRYc7WwmcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PV42R35Iehg1CLrAqol0pD5NiJI6sVn5FC5WDj+ptrVuPTaJjuPjDNnsJTGVOXonpvfRkCQaBlMDUjpdqfHTYVlbyK68M+eigVe286ORd70kziILjuhg3vUGITAG1vvPhBmHfi3byjamBe/TVO6PhnfMhcSAgUxYGsEmBG0YFgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CR9GTg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CR9GTg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0403EC4CECE;
	Thu, 12 Dec 2024 16:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019648;
	bh=Zjl8D9dAV+If303y+A+Diof5J/XBXhrA3YRYc7WwmcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CR9GTg1Luz20s6g+9r3S2WJF8TO92bVblK/iyGlPim3P/89BWmuO+9RD0AUJWujG
	 QD8Vr8Sxq9XHC0FUH567sSWT88Fj/z2S9D8vzr9kTfMVxnuXjGiMeTYHYf9ehitOLt
	 IxKJBIcnJCFGIo+83JJB7p4yqxXuW0JbQWWsz0+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/772] clk: imx: fracn-gppll: correct PLL initialization flow
Date: Thu, 12 Dec 2024 15:52:57 +0100
Message-ID: <20241212144359.499095833@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 557be501c38e1864b948fc6ccdf4b035d610a2ea ]

Per i.MX93 Reference Mannual 22.4 Initialization information
1. Program appropriate value of DIV[ODIV], DIV[RDIV] and DIV[MFI]
   as per Integer mode.
2. Wait for 5 μs.
3. Program the following field in CTRL register.
   Set CTRL[POWERUP] to 1'b1 to enable PLL block.
4. Poll PLL_STATUS[PLL_LOCK] register, and wait till PLL_STATUS[PLL_LOCK]
   is 1'b1 and pll_lock output signal is 1'b1.
5. Set CTRL[CLKMUX_EN] to 1'b1 to enable PLL output clock.

So move the CLKMUX_EN operation after PLL locked.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Co-developed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241027-imx-clk-v1-v3-2-89152574d1d7@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index 421a78e295ee4..281fc62ecd3d5 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -299,13 +299,13 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
 	val |= POWERUP_MASK;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-	val |= CLKMUX_EN;
-	writel_relaxed(val, pll->base + PLL_CTRL);
-
 	ret = clk_fracn_gppll_wait_lock(pll);
 	if (ret)
 		return ret;
 
+	val |= CLKMUX_EN;
+	writel_relaxed(val, pll->base + PLL_CTRL);
+
 	val &= ~CLKMUX_BYPASS;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-- 
2.43.0



