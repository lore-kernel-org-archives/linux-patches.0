Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72B2367A0;
	Wed, 23 Apr 2025 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421355; cv=none; b=cG35ghCbg6NPLyqhrPeHTVflopkVtSi1MXZIgexDuNvXWW37F7crq87Z1do6CTkDB0yIqajkTxOAFec2sWQ10VAA3kte81lcSoqP5e94icWx7f7qNWqysfsedUJkiGkTWzRgLLs+Z0VEXYfGqwmNuWD/rmn0+BGCcDbFQihVjmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421355; c=relaxed/simple;
	bh=MDj5btanynEtJ4iLEN/oYQiYzzRKcBfhdL5tYb2fDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEhk3KzfF3JW23ecyfHf+V6nc+toLDnRK1L1d3TmD31OaQtDLQljcu9nkXgIGbubFnNddWMNvovOnLuNcijawXMG1VXPVv/+J9dnLqX3CdNuJrkUbdWw8jAN1bjK5n2WInF7NafQVqQNaJQnUWSSJ3CVgoot+0pTaK9oj08iehk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFS6mLnh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFS6mLnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EA3C4CEE3;
	Wed, 23 Apr 2025 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421354;
	bh=MDj5btanynEtJ4iLEN/oYQiYzzRKcBfhdL5tYb2fDi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFS6mLnhB/Ns2L4Lkq00HnHSc5FdYKU5yJ2fTJlkI+1MFVBQldo7U9OZppd5eUasD
	 Fewzn7yNR2pLmT7gzuuHVT0+6XGMkVbVzF4iaXKYAUa5eS9R9lgF8eqF/jbJKrQtrj
	 tWzUliiH8K9Eq5BJoUD8L0B1GFbp9B9mxlbS65iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 171/393] leds: rgb: leds-qcom-lpg: Fix calculation of best period Hi-Res PWMs
Date: Wed, 23 Apr 2025 16:41:07 +0200
Message-ID: <20250423142650.442255933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 2528eec7da0ec58fcae6d12cfa79a622c933d86b upstream.

When determining the actual best period by looping through all
possible PWM configs, the resolution currently used is based on
bit shift value which is off-by-one above the possible maximum
PWM value allowed.

So subtract one from the resolution before determining the best
period so that the maximum duty cycle requested by the PWM user
won't result in a value above the maximum allowed by the selected
resolution.

Cc: stable@vger.kernel.org    # 6.4
Fixes: b00d2ed37617 ("leds: rgb: leds-qcom-lpg: Add support for high resolution PWM")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Sebastian Reichel <sre@kernel.org>
Link: https://lore.kernel.org/r/20250305-leds-qcom-lpg-fix-max-pwm-on-hi-res-v4-3-bfe124a53a9f@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -311,7 +311,7 @@ static int lpg_calc_freq(struct lpg_chan
 		max_res = LPG_RESOLUTION_9BIT;
 	}
 
-	min_period = div64_u64((u64)NSEC_PER_SEC * (1 << pwm_resolution_arr[0]),
+	min_period = div64_u64((u64)NSEC_PER_SEC * ((1 << pwm_resolution_arr[0]) - 1),
 			       clk_rate_arr[clk_len - 1]);
 	if (period <= min_period)
 		return -EINVAL;
@@ -332,7 +332,7 @@ static int lpg_calc_freq(struct lpg_chan
 	 */
 
 	for (i = 0; i < pwm_resolution_count; i++) {
-		resolution = 1 << pwm_resolution_arr[i];
+		resolution = (1 << pwm_resolution_arr[i]) - 1;
 		for (clk_sel = 1; clk_sel < clk_len; clk_sel++) {
 			u64 numerator = period * clk_rate_arr[clk_sel];
 
@@ -1060,7 +1060,7 @@ static int lpg_pwm_get_state(struct pwm_
 		if (ret)
 			return ret;
 
-		state->period = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * (1 << resolution) *
+		state->period = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * ((1 << resolution) - 1) *
 						 pre_div * (1 << m), refclk);
 		state->duty_cycle = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * pwm_value * pre_div * (1 << m), refclk);
 	} else {


