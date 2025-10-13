Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B7311C20;
	Mon, 13 Oct 2025 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368191; cv=none; b=Dp+GLtPI/MSrgMULVOFkLVFadvwOpZao32/pLKPQ/1Ulz6bueTwifsErLQ7Ia1FOytYvk2uzBVR7ydtsgxYH+ZsIcbDcpSUj249k3DsBhDPq4vlExp/ussbRh6bUWKd99RLYAwZR3pbay9do0Os1vQV5/xZdqRWm/NsTyP8aoW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368191; c=relaxed/simple;
	bh=ouN30tGe5Chl15z6LNQleJKIYr8SDDHv7ynvbfIyb1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKtj+jahx2RQaGWUa34QhIZ5qiTX18OVLtV0R8N1k4Eb2lrZ1wiP/KafISWDoK87T+JucLA1t6EkTvIkEVwvC8AdxoRTWFneTFf9rIsHI0IWdkwBvUX4TSXmGaP4ntW6tobTOW1ZcKGGKuKq1L3+SFTrnoaFsFfH2AJ5xa6Dv10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGGeICq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGGeICq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF871C4CEE7;
	Mon, 13 Oct 2025 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368191;
	bh=ouN30tGe5Chl15z6LNQleJKIYr8SDDHv7ynvbfIyb1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGGeICq9OEQD17pGxpXYY/WudtgV5vpjd6cmOplacjmA0GoReEbQ5pUpUhUhKOXv9
	 e2upXI0ssSP2AsFLVnoFcJIwbuinJBEFdha/oNSxsVzHtNonBp6P7O5h85BVMB9qOp
	 aTgBX2Ub5MoXNw+pfGDNTRImoWXteMlHM+iw5MOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/262] pwm: tiehrpwm: Fix corner case in clock divisor calculation
Date: Mon, 13 Oct 2025 16:43:30 +0200
Message-ID: <20251013144328.577141589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 00f83f0e07e44e2f1fb94b223e77ab7b18ee2d7d ]

The function set_prescale_div() is responsible for calculating the clock
divisor settings such that the input clock rate is divided down such that
the required period length is at most 0x10000 clock ticks. If period_cycles
is an integer multiple of 0x10000, the divisor period_cycles / 0x10000 is
good enough. So round up in the calculation of the required divisor and
compare it using >= instead of >.

Fixes: 19891b20e7c2 ("pwm: pwm-tiehrpwm: PWM driver support for EHRPWM")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/85488616d7bfcd9c32717651d0be7e330e761b9c.1754927682.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index a23e48b8523db..7a86cb090f76f 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -161,7 +161,7 @@ static int set_prescale_div(unsigned long rqst_prescaler, u16 *prescale_div,
 
 			*prescale_div = (1 << clkdiv) *
 					(hspclkdiv ? (hspclkdiv * 2) : 1);
-			if (*prescale_div > rqst_prescaler) {
+			if (*prescale_div >= rqst_prescaler) {
 				*tb_clk_div = (clkdiv << TBCTL_CLKDIV_SHIFT) |
 					(hspclkdiv << TBCTL_HSPCLKDIV_SHIFT);
 				return 0;
@@ -224,7 +224,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	pc->period_cycles[pwm->hwpwm] = period_cycles;
 
 	/* Configure clock prescaler to support Low frequency PWM wave */
-	if (set_prescale_div(period_cycles/PERIOD_MAX, &ps_divval,
+	if (set_prescale_div(DIV_ROUND_UP(period_cycles, PERIOD_MAX), &ps_divval,
 			     &tb_divval)) {
 		dev_err(pwmchip_parent(chip), "Unsupported values\n");
 		return -EINVAL;
-- 
2.51.0



