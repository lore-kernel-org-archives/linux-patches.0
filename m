Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A9927E045;
	Wed, 20 May 2026 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296356; cv=none; b=OwKshVx0ZF2X2i97bw9angGrK3r5OMmFILUynXrDy6EkxRHIo1mwBgFlTwRYRaNXAYs3hJwUvt6RHhNoBSnWzYYjFt2rFrNxvLsjIcfeHD9/4b3Rd1tOd/OPWs3+OKWKDmvRGImoOqvRDv8gUDx9HalqvflBinDfC/8lBoUhbxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296356; c=relaxed/simple;
	bh=e8s+jkPG9Tn7a+Cx4R/kxO1qwZj9eSlMeXmcTpEz0zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEFpkGyhJX94jAnhkMhpIeNQQpcMfQyWUvYUpOQHiKGtqHui1WpN8jVwkQZMXunYK+nHxm7NcUxXIMosK87dzMUTpJ1fjy4CFWaqoV9xxh7hzpMqt0v2aorXcUQnHJM7E/n2mJ1lAD5nmKrjq7u7N7R3ZlwWlvX4ZkFbSBx1s/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJHIsUBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJHIsUBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA391F000E9;
	Wed, 20 May 2026 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296355;
	bh=iiyPWk02KnNYFnVPAiLlwq3c+hEBSn0lWcdIi111vgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJHIsUBb+KU4SHTGt+q3exvmgmBMu9IV1G5lxidvdmKz6oyBR8vaxqQHqxu4L4WJF
	 KcAueNJS+B07+lDfrt02rjyhB4mqHRnXaHF+zhMGvBQWuTGqEQSsJ5MRQxP+oI2XQ9
	 0ncYP+ZsUdg6x9vlX+YVTiThKwTPc576dhHpztdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0767/1146] pwm: stm32: Fix rounding issue for requests with inverted polarity
Date: Wed, 20 May 2026 18:16:57 +0200
Message-ID: <20260520162205.572415178@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 5d087c485b6ecf200a9ebb2a032bf8571d330250 ]

The calculation of the number of pwm clk ticks from a time length in
nanoseconds involves a division and thus some rounding. That might
result in

	duty_ticks + offset_ticks < period_ticks

despite

	duty_length_ns + duty_offset_ns >= period_length_ns

. The stm32 PWM cannot configure offset_ticks freely, it can only select
0 or period_length_ns - duty_length_ns---that is the classic normal and
inverted polarity. The decision to select the hardware polarity must be
done using the ticks values and not the nanoseconds times to adhere to
the rounding rules by the pwm core.

With the pwm clk running at 208900 kHz on my test machine
(stm32mp135f-dk), a test case that was handled wrong is:

	# pwmround -P 9999962 -O 24970 -D 9974992
	period_length = 9999962
	duty_length = 9974840
	duty_offset = 25123

With this change applied the rounding is done correctly:

	# pwmround -P 9999962 -O 24970 -D 9974992
	period_length = 9999962
	duty_length = 9974840
	duty_offset = 0

Fixes: deaba9cff809 ("pwm: stm32: Implementation of the waveform callbacks")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/c5e7767cee821b5f6e00f95bd14a5e13015646fb.1776264104.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 2594fb771b04a..935257a890b06 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -68,7 +68,7 @@ static int stm32_pwm_round_waveform_tohw(struct pwm_chip *chip,
 	struct stm32_pwm *priv = to_stm32_pwm_dev(chip);
 	unsigned int ch = pwm->hwpwm;
 	unsigned long rate;
-	u64 ccr, duty;
+	u64 duty_ticks, offset_ticks;
 	int ret;
 
 	if (wf->period_length_ns == 0) {
@@ -164,23 +164,25 @@ static int stm32_pwm_round_waveform_tohw(struct pwm_chip *chip,
 		wfhw->arr = min_t(u64, arr, priv->max_arr) - 1;
 	}
 
-	duty = mul_u64_u64_div_u64(wf->duty_length_ns, rate,
-				   (u64)NSEC_PER_SEC * (wfhw->psc + 1));
-	duty = min_t(u64, duty, wfhw->arr + 1);
+	duty_ticks = mul_u64_u64_div_u64(wf->duty_length_ns, rate,
+					 (u64)NSEC_PER_SEC * (wfhw->psc + 1));
+	duty_ticks = min_t(u64, duty_ticks, wfhw->arr + 1);
 
-	if (wf->duty_length_ns && wf->duty_offset_ns &&
-	    wf->duty_length_ns + wf->duty_offset_ns >= wf->period_length_ns) {
+	offset_ticks = mul_u64_u64_div_u64(wf->duty_offset_ns, rate,
+					   (u64)NSEC_PER_SEC * (wfhw->psc + 1));
+	offset_ticks = min_t(u64, offset_ticks, wfhw->arr + 1);
+
+	if (duty_ticks && offset_ticks &&
+	    duty_ticks + offset_ticks >= wfhw->arr + 1) {
 		wfhw->ccer |= TIM_CCER_CCxP(ch + 1);
 		if (priv->have_complementary_output)
 			wfhw->ccer |= TIM_CCER_CCxNP(ch + 1);
 
-		ccr = wfhw->arr + 1 - duty;
+		wfhw->ccr = wfhw->arr + 1 - duty_ticks;
 	} else {
-		ccr = duty;
+		wfhw->ccr = duty_ticks;
 	}
 
-	wfhw->ccr = min_t(u64, ccr, wfhw->arr + 1);
-
 out:
 	dev_dbg(&chip->dev, "pwm#%u: %lld/%lld [+%lld] @%lu -> CCER: %08x, PSC: %08x, ARR: %08x, CCR: %08x\n",
 		pwm->hwpwm, wf->duty_length_ns, wf->period_length_ns, wf->duty_offset_ns,
-- 
2.53.0



