Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F96E237A4F;
	Mon, 13 Oct 2025 14:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367532; cv=none; b=ULseDYuZH+Ge0PHqVNnKXKl+QpDAmh+WFBdCI3NkhoKN+C1PVZPpSMQti0nO138AqkZdRIBCCypZvzZNZ0riPgEjD1MLKiQKXuvVYJyHtcS42Ic1MOBUjb4BngmiP3ngiCqHGtps30eIwaT089R3DfS7r/miAzn3wegaYDYg2xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367532; c=relaxed/simple;
	bh=ehu6//+Sr4NPwrEzedN5i0hS5MnYRw1R0B2wH5uhQF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIvwOF4ZKK6gu82u7NMZHsbKqDkpkWMDP5iAFxas+jJiFUKkIlQeCtd3Xxnynb3hUjx+rdzDsxnj5xEXw+HDR1vSR0dVXK25yjPWIIRTaZolJG5q9DthZ3JmwCfVG4Ug4Pg7YbOBYyVWw0u7x0V30fE3CCn6d4CH+th3vbYySAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhzqkN4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhzqkN4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E184FC4CEE7;
	Mon, 13 Oct 2025 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367532;
	bh=ehu6//+Sr4NPwrEzedN5i0hS5MnYRw1R0B2wH5uhQF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhzqkN4CGfHfvQj7U3fhyiJTKRzNDooVEcq31AshO1VA8WpYezC94q8vBYrepkLAQ
	 lh4VdTFt8FuOBpPRaAsrnebBHi93ke/kKt7MUIJpOC1+OMtbW3s0YwqhdOrKT89Vh2
	 +UXZPmusX4wo6s+Dej52N7V9GSYqtb6LmWsPQRJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/196] pwm: tiehrpwm: Fix corner case in clock divisor calculation
Date: Mon, 13 Oct 2025 16:43:56 +0200
Message-ID: <20251013144316.832447474@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index ecbfd7e954ecb..d693b2d65cccf 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -167,7 +167,7 @@ static int set_prescale_div(unsigned long rqst_prescaler, u16 *prescale_div,
 
 			*prescale_div = (1 << clkdiv) *
 					(hspclkdiv ? (hspclkdiv * 2) : 1);
-			if (*prescale_div > rqst_prescaler) {
+			if (*prescale_div >= rqst_prescaler) {
 				*tb_clk_div = (clkdiv << TBCTL_CLKDIV_SHIFT) |
 					(hspclkdiv << TBCTL_HSPCLKDIV_SHIFT);
 				return 0;
@@ -266,7 +266,7 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	pc->period_cycles[pwm->hwpwm] = period_cycles;
 
 	/* Configure clock prescaler to support Low frequency PWM wave */
-	if (set_prescale_div(period_cycles/PERIOD_MAX, &ps_divval,
+	if (set_prescale_div(DIV_ROUND_UP(period_cycles, PERIOD_MAX), &ps_divval,
 			     &tb_divval)) {
 		dev_err(chip->dev, "Unsupported values\n");
 		return -EINVAL;
-- 
2.51.0



