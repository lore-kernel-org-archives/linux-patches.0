Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885711F130D;
	Tue,  3 Dec 2024 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238324; cv=none; b=J0bf4mPcZsXbsGc8NKFbdynuWBXUr1oGCw1BicRdCnKaNV6SBWIO2jsXiML4GDzA94hU0FTnjszxP2r9BxjARTOXVI/DbFG6jaOA+WpAwrYlTsucIEBNflYTR6WDQKSMCImV4S+AQGDOso4rJVLxIC2UF1SKwQ8USp8ZlQ6I1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238324; c=relaxed/simple;
	bh=MqknNH7NPJ9Hjeov2x7W0vcCeh07V0JuycNu9JrxP5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPFV3736733ZSqgRhWHLvz5eix7zct1uyQ7D18mY2an8maENl+10Qx8/BRKzH8qcZ69PMuHi9L/SKImikPhZYr/sQuFrmFLn5suXRogUubPHHAd+egUvHB4mGdx5U4YltZkuDLfgJY1/uxvuG0snAdro6BS/x1SMdt5eAZI8rFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00y3w9H2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00y3w9H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DD0C4CECF;
	Tue,  3 Dec 2024 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238324;
	bh=MqknNH7NPJ9Hjeov2x7W0vcCeh07V0JuycNu9JrxP5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00y3w9H2mJ5KrkwSJeBg2Q9UzjgfK1HfquflRk6111NNwQ+ZxIm+rj2s7FIe7kI0G
	 TYc8XS0yqSEEBiD8Blm45lc5mITT35njfxIeynwTOO3kUOqeFCrLwTan8ZDyQgQ1Bk
	 MNS17L+kfXSIjr9ZT96boHn/jPeKOnRhXyqIq2vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 209/817] pwm: Assume a disabled PWM to emit a constant inactive output
Date: Tue,  3 Dec 2024 15:36:21 +0100
Message-ID: <20241203144003.905191606@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit b2eaa1170e45dc18eb09dcc9abafbe9a7502e960 ]

Some PWM hardwares (e.g. MC33XS2410) cannot implement a zero duty cycle
but can instead disable the hardware which also results in a constant
inactive output.

There are some checks (enabled with CONFIG_PWM_DEBUG) to help
implementing a driver without violating the normal rounding rules. Make
them less strict to let above described hardware pass without warning.

Reported-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Link: https://lore.kernel.org/r/20241103205215.GA509903@debian
Fixes: 3ad1f3a33286 ("pwm: Implement some checks for lowlevel drivers")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Tested-by: Dimitri Fedrau <dima.fedrau@gmail.com>
Link: https://lore.kernel.org/r/20241105153521.1001864-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 8acbcf5b66739..53c3a76a185ed 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -75,7 +75,7 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 	    state->duty_cycle < state->period)
 		dev_warn(pwmchip_parent(chip), ".apply ignored .polarity\n");
 
-	if (state->enabled &&
+	if (state->enabled && s2.enabled &&
 	    last->polarity == state->polarity &&
 	    last->period > s2.period &&
 	    last->period <= state->period)
@@ -83,7 +83,11 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 			 ".apply didn't pick the best available period (requested: %llu, applied: %llu, possible: %llu)\n",
 			 state->period, s2.period, last->period);
 
-	if (state->enabled && state->period < s2.period)
+	/*
+	 * Rounding period up is fine only if duty_cycle is 0 then, because a
+	 * flat line doesn't have a characteristic period.
+	 */
+	if (state->enabled && s2.enabled && state->period < s2.period && s2.duty_cycle)
 		dev_warn(pwmchip_parent(chip),
 			 ".apply is supposed to round down period (requested: %llu, applied: %llu)\n",
 			 state->period, s2.period);
@@ -99,7 +103,7 @@ static void pwm_apply_debug(struct pwm_device *pwm,
 			 s2.duty_cycle, s2.period,
 			 last->duty_cycle, last->period);
 
-	if (state->enabled && state->duty_cycle < s2.duty_cycle)
+	if (state->enabled && s2.enabled && state->duty_cycle < s2.duty_cycle)
 		dev_warn(pwmchip_parent(chip),
 			 ".apply is supposed to round down duty_cycle (requested: %llu/%llu, applied: %llu/%llu)\n",
 			 state->duty_cycle, state->period,
-- 
2.43.0



