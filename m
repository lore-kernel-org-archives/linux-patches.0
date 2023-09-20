Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1701031A6B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA76C433C8;
	Wed, 20 Sep 2023 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213646;
	bh=L9Gtc6qn+JHPoS6MRy8rSaRNfrKvurJB62X1w9LIFfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pX3RkdIwlcSwhDyn0e12dfv88ma9lVBxlZ8JS78ztHNol+PB1C0rmCfMxEgk1AI+p
	 KGj0BZrWGOBypmG4zWekF2kSxEPCQp1uQMm1XioVHGJZgUvErsHTtfdnIhZ7VDY9Nx
	 P++295gw58SZcOcF8OuzwXDLY0fu7RwnvKcP38BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 296/367] clk: imx: pll14xx: dynamically configure PLL for 393216000/361267200Hz
Date: Wed, 20 Sep 2023 13:31:13 +0200
Message-ID: <20230920112906.208711780@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 72d00e560d10665e6139c9431956a87ded6e9880 ]

Since commit b09c68dc57c9 ("clk: imx: pll14xx: Support dynamic rates"),
the driver has the ability to dynamically compute PLL parameters to
approximate the requested rates. This is not always used, because the
logic is as follows:

  - Check if the target rate is hardcoded in the frequency table
  - Check if varying only kdiv is possible, so switch over is glitch free
  - Compute rate dynamically by iterating over pdiv range

If we skip the frequency table for the 1443x PLL, we find that the
computed values differ to the hardcoded ones. This can be valid if the
hardcoded values guarantee for example an earlier lock-in or if the
divisors are chosen, so that other important rates are more likely to
be reached glitch-free.

For rates (393216000 and 361267200, this doesn't seem to be the case:
They are only approximated by existing parameters (393215995 and
361267196 Hz, respectively) and they aren't reachable glitch-free from
other hardcoded frequencies. Dropping them from the table allows us
to lock-in to these frequencies exactly.

This is immediately noticeable because they are the assigned-clock-rates
for IMX8MN_AUDIO_PLL1 and IMX8MN_AUDIO_PLL2, respectively and a look
into clk_summary so far showed that they were a few Hz short of the target:

imx8mn-board:~# grep audio_pll[12]_out /sys/kernel/debug/clk/clk_summary
audio_pll2_out           0        0        0   361267196 0     0  50000   N
audio_pll1_out           1        1        0   393215995 0     0  50000   Y

and afterwards:

imx8mn-board:~# grep audio_pll[12]_out /sys/kernel/debug/clk/clk_summary
audio_pll2_out           0        0        0   361267200 0     0  50000   N
audio_pll1_out           1        1        0   393216000 0     0  50000   Y

This change is equivalent to adding following hardcoded values:

  /*               rate     mdiv  pdiv  sdiv   kdiv */
  PLL_1443X_RATE(393216000, 655,    5,    3,  23593),
  PLL_1443X_RATE(361267200, 497,   33,    0, -16882),

Fixes: 053a4ffe2988 ("clk: imx: imx8mm: fix audio pll setting")
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20230807084744.1184791-2-m.felsch@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index e7bf6babc28b4..0dbe8c05af478 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -57,8 +57,6 @@ static const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
 	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
 	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
 	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
-	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
-	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
 
 struct imx_pll14xx_clk imx_1443x_pll = {
-- 
2.40.1



