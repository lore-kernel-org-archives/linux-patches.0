Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA90178381;
	Tue,  2 Jul 2024 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940100; cv=none; b=WRxoyzlisOuTA38LMpWWfsPc6sv4QB4IHa37q8LJd+Tei5qBpP9DXVUQ8a0dWg1v+IP/gy8cRd6zvWz8RIAwIcSa4n4A4tGUCglKX2iTTCC4BQ7LLkbuyooz8Sxu1CtHtYMtbrpWmhox9i6P5MmfVS2ZIdbptZdjs8zgc1n5OZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940100; c=relaxed/simple;
	bh=1lJzpq0Vut+MHIMfQKLJbQZgSQY/glriu5DNG08vnMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2dr94ouztDAwIrinPkwpms4yhkTJL0fheSdMAzP8rdXWQhFFAhXbv3M2hfgPDdWtY5CNFPU9FSvXwc1on7GTl9y97Gc6w4YrV/kpStmqEJPFcRHsjkrDYEo+gNjFpFcXZu1dT0Ft+XNPKYOs6/2F3TC0LJB6FqRF4Ah9v3lFzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rbl1SSTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rbl1SSTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA2C116B1;
	Tue,  2 Jul 2024 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940100;
	bh=1lJzpq0Vut+MHIMfQKLJbQZgSQY/glriu5DNG08vnMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rbl1SSTRIvazvEbN7mtwJW1qphMWp42pHEsoj8ejJ7r/j8wN3+fAZItYEHK1sAC4H
	 45QM8SEm3567UEtiAbHpjkADbkrfa2AezOLOVt6YrE6kxFS74TYlN5weCf19LqqybT
	 oEcG5si7Pj0vymrzY0NPzNr76CDEMkwLRNsrwlE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 011/222] pwm: stm32: Improve precision of calculation in .apply()
Date: Tue,  2 Jul 2024 19:00:49 +0200
Message-ID: <20240702170244.404924581@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e419617847b688799a91126eb6c94b936bfb35ff ]

While mathematically it's ok to calculate the number of cyles for the
duty cycle as:

	duty_cycles = period_cycles * duty_ns / period_ns

this doesn't always give the right result when doing integer math. This
is best demonstrated using an example: With the input clock running at
208877930 Hz a request for duty_cycle = 383 ns and period = 49996 ns
results in

	period_cycles = clkrate * period_ns / NSEC_PER_SEC = 10443.06098828

Now calculating duty_cycles with the above formula gives:

	duty_cycles = 10443.06098828 * 383 / 49996 = 80.00024719

However with period_cycle truncated to an integer results in:

	duty_cycles = 10443 * 383 / 49996 = 79.99977998239859

So while a value of (a little more than) 80 would be the right result,
only 79 is used here. The problem here is that 14443 is a rounded result
that should better not be used to do further math. So to fix that use
the exact formular similar to how period_cycles is calculated.

Link: https://lore.kernel.org/r/7628ecd8a7538aa5a7397f0fc4199a077168e8a6.1710711976.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: c45fcf46ca23 ("pwm: stm32: Refuse too small period requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 0c028d17c0752..d50194ad24b1c 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -351,8 +351,9 @@ static int stm32_pwm_config(struct stm32_pwm *priv, unsigned int ch,
 	regmap_set_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE);
 
 	/* Calculate the duty cycles */
-	dty = prd * duty_ns;
-	do_div(dty, period_ns);
+	dty = (unsigned long long)clk_get_rate(priv->clk) * duty_ns;
+	do_div(dty, prescaler + 1);
+	do_div(dty, NSEC_PER_SEC);
 
 	regmap_write(priv->regmap, TIM_CCR1 + 4 * ch, dty);
 
-- 
2.43.0



