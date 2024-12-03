Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11801DDC26;
	Tue,  3 Dec 2024 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240679; cv=none; b=oBbH5shzQbSiArEGyKNajbCoRU4mENkC77m05IAklS9fxSU516cpmq956DGzcvs8GbsvvML2UVcNGUMrXqd1UfQNi8VbEB25Z0HjDHMYaDi/rB9Pr92qoCyWyzuN9h4hS1heFSQfz1GuaPYci+LbSbJScaJHpWDB6vkmm2e5fbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240679; c=relaxed/simple;
	bh=2TuqysjA7LLR6zW0R220kZynJE71eLKAwAj616Ptd8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ojspBwe7dlzclJ1c8rql5Y08+dXOtkhLSSgbqj+z0IVy9Qd6GLMrL/4sZGn1y6zQsvJA+TakaQik7z+imNo/xD1KJX645cZq0JPcB9Zv4AB9xh+0SxASmQ0fN7Nepq65qdYuHpnTNs2TUl71x+ailypJYgpBmwWEaCkxmgRifv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9q2lHAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9q2lHAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A52C4CECF;
	Tue,  3 Dec 2024 15:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240678;
	bh=2TuqysjA7LLR6zW0R220kZynJE71eLKAwAj616Ptd8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9q2lHARaUfH8152vc2457IxWBS7iy7ZEFxXBPqRqcYBnf24VAWsPZWUSobgM+hQa
	 bgxbb8GJDKLV/jU15g402schCb84AoVJmWxU/4hI677lNv4CxAT+MEthc1KMGXh1cU
	 48nyrxHMgDDIAsrrN+/RuFlVCmBgS4SKRZwjWHCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dima.fedrau@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/826] pwm: Assume a disabled PWM to emit a constant inactive output
Date: Tue,  3 Dec 2024 15:38:20 +0100
Message-ID: <20241203144750.487585842@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e752e148b98c..210368099a064 100644
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



