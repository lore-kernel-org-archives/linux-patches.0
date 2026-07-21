Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A916E3783D4;
	Tue, 21 Jul 2026 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665759; cv=none; b=VZzQeBaiWO6YTxSp1fWkqBtWlkgKvcwVQsXbpNhVGs4+LtKa+AubagNRdx7Mj6mladtw7SCOOCfwolE9CfiQ7ThSDxdBgQ5FrpZsLEzYks/ZySiP6MqX2JDA132EbIKWjcUH2Ydl5ImBYKxlxqV1PUJNCC4Wmo1UtnY+wFm1CPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665759; c=relaxed/simple;
	bh=6xOmz7puWbxaweAkWfmcVcKBuEkgr8tJqxJTj7hLxDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4YuCbsS2WEVt8Z2i8AqMorJpDOymoKt+LsvzFI+u4r/mdNf0JkOmqWi8TrEa9EwiLQFUqBiOnJ3isBp0O2osQta5632UkYi4j/G6db0EAGZUuJ07Egv974WnYOewPqFb+zY/srpViFATOLHZjoFOGjRZ4s01vNOvB9627Iz1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3VWwHbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3VWwHbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6EB1F000E9;
	Tue, 21 Jul 2026 20:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665758;
	bh=Z8eY12of7nDFKz7ehMb41JdAWZ4zxKbBJj0NUWaIZdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3VWwHbdDEDjxmHxmtcOB0rERuo02OPwFs5o/AXRMQe6J3ZadjN7lmJpvnUxuiAZi
	 yLLyKHbqWckwBuRACn4p1V8MH2HyKnsb+tOWpkb741CZJw3sl1UyXcNFI7P22d+2YJ
	 BW76W9lXR5q07FjYPHg39IXRgJOhcHU3Zmqxr5EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronaldo Nunez <rnunez@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0426/1266] pwm: imx27: Fix variable truncation in .apply()
Date: Tue, 21 Jul 2026 17:14:23 +0200
Message-ID: <20260721152451.374022353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 660a71b7263ce0..8a4187a67f7d4e 100644
--- a/drivers/pwm/pwm-imx27.c
+++ b/drivers/pwm/pwm-imx27.c
@@ -218,7 +218,7 @@ static void pwm_imx27_wait_fifo_slot(struct pwm_chip *chip,
 static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			   const struct pwm_state *state)
 {
-	unsigned long period_cycles, duty_cycles, prescale, period_us, tmp;
+	unsigned long period_cycles, duty_cycles, prescale, period_us;
 	struct pwm_imx27_chip *imx = to_pwm_imx27_chip(chip);
 	struct pwm_state cstate;
 	unsigned long long c;
@@ -227,6 +227,7 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	int val;
 	int ret;
 	u32 cr;
+	u64 tmp;
 
 	pwm_get_state(pwm, &cstate);
 
@@ -270,6 +271,11 @@ static int pwm_imx27_apply(struct pwm_chip *chip, struct pwm_device *pwm,
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



