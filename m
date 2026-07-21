Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C22415F14;
	Tue, 21 Jul 2026 19:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661658; cv=none; b=kYppoHEd78JoxXbzupaoY2XYwbaSy5QC1nH7jGq/3emzS5z/1ZpkPnpuyn3RsE6l3raYq1iAdmO10hEC6uhayJZdt732LFXTaOl8thKthV6BP2vW//KltS2iSyfLsqPNBpw4skba17hTdyzL8FUAGRTcNAOrm/TH5oW05+k3z7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661658; c=relaxed/simple;
	bh=yTu7xItczuTyvLfyLO/3tHJOn70DNGbDnq692HAMbDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qze0IQNg2PHyeHXkINEOPtUQBEDYxKsnVVZvO6XfryvjseB4e9kL4eWitKESiNaxI63xbi0avIDk0c17R1crvnQksrO6zg2E3ppNcYNyXbq07cIrCsxZAoWgOl1QfhA/dtCKtX98UeaXz7CD13/mEoDcApzgOyHzM+uJ/YPgP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZM9B7As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZM9B7As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254251F000E9;
	Tue, 21 Jul 2026 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661656;
	bh=QiGzSRybyxpUKr6jwI5MemE5OSmbYEy3jXHzE2R61gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZM9B7As4zHBzH75qCX3b7oVs/ThOTymGtvWDdIM2b1UNqEnkxhUL4K4rY5R/Yvqi
	 dFCQwD7bc04BWptBmRJw4jN30cVz5MzOw5VNSZhZgkQlTC4w4pC7qkJ3/eAp2EWEjB
	 jbMQcQMPMCc9ZXV9aze2wCc4WdLeYkmna/1r1ZFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronaldo Nunez <rnunez@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0150/1276] pwm: imx27: Fix variable truncation in .apply()
Date: Tue, 21 Jul 2026 17:09:53 +0200
Message-ID: <20260721152449.459645106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronaldo Nunez <rnunez@baylibre.com>

[ Upstream commit dc9e08fdbcc3eb08a1d2b868b535081c44425e27 ]

Fix a variable truncation when calculating period in microseconds as
part of the solution for the ERR051198 in .apply() callback.

Example scenario:
 - Period of 3us (PWMPR = 196 and prescaler = 1)
 - Expected value in tmp: 198000000000 (NSEC_PER_SEC * (196 + 2) * 1)
 - Actual value is 431504384 (truncation to u32)

Signed-off-by: Ronaldo Nunez <rnunez@baylibre.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260522191348.6227-1-rnunez@baylibre.com
Fixes: a25351e4c774 ("pwm: imx27: Workaround of the pwm output bug when decrease the duty cycle")
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-imx27.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx27.c b/drivers/pwm/pwm-imx27.c
index 0375987194318f..32613165f2b3fa 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -220,7 +220,7 @@ static void pwm_imx27_wait_fifo_slot(struct pwm_chip *chip,
 static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			   const struct pwm_state *state)
 {
-	unsigned long period_cycles, duty_cycles, prescale, period_us, tmp;
+	unsigned long period_cycles, duty_cycles, prescale, period_us;
 	struct pwm_imx27_chip *imx = to_pwm_imx27_chip(chip);
 	unsigned long long c;
 	unsigned long long clkrate;
@@ -228,6 +228,7 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int val;
 	int ret;
 	u32 cr;
+	u64 tmp;
 
 	clkrate = clk_get_rate(imx->clk_per);
 	c = clkrate * state->period;
@@ -269,6 +270,11 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	val = readl(imx->mmio_base + MX3_PWMPR);
 	val = val >= MX3_PWMPR_MAX ? MX3_PWMPR_MAX : val;
 	cr = readl(imx->mmio_base + MX3_PWMCR);
+
+	/*
+	 * tmp stores period in nanoseconds. Result fits in u64 since
+	 * val <= 0xfffe and prescaler in [1, 0x1000].
+	 */
 	tmp = NSEC_PER_SEC * (u64)(val + 2) * MX3_PWMCR_PRESCALER_GET(cr);
 	tmp = DIV_ROUND_UP_ULL(tmp, clkrate);
 	period_us = DIV_ROUND_UP_ULL(tmp, 1000);
-- 
2.53.0



