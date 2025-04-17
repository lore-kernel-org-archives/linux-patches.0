Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7CE2571A1;
	Thu, 17 Apr 2025 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915896; cv=none; b=rLikF6qopV5Xcv5WQZ5EkKE9qHm2zKGCVqQuBOKugSZeUkOWhyMksjRi3KwBVxTUZnckJ6Jhw0D1wzYiJNBaPwG/MAjYTIVRvEdMHv5mJ55tIhKb2qFvwPE+ea1Xc1swAow26x1ma9wrGhU87izSwmDIX5uvjf4p6816ZQ45oeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915896; c=relaxed/simple;
	bh=m9KpxUVHMJk4EfnKACnAlRNTU5QmwGjFBHggFymaPHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ifo3Q2Fkhj/LAInDqEnFYwefcpf9GZ3W0I9dsul3GQlrnMNd42S6o+pFNRgGclRQIWBvEDyat2/9kxsHu2HZ8ssbOt1n+c0N1lOwKe5O/6FHXTOjFXRfF58vv48EJg0h9SQtw5ugOEIBaYwmjfV37o7Wh2suL5CQyoQOIDEeMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0//qJWbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0//qJWbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DA9C4CEE4;
	Thu, 17 Apr 2025 18:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915896;
	bh=m9KpxUVHMJk4EfnKACnAlRNTU5QmwGjFBHggFymaPHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0//qJWbYR6E2pBDjup2Sm2qmWrflCsqm1wWq60mHmtSuIAuGAkgA1ZTsQNqAFHfkR
	 kOVa75NfWCqYj3fy0Cx/ZA9FgSeV6HbZXVd8JyBdYWZ0fkAh5kS/G8acYJ33RMZv3t
	 2JlI/H+WUpoVi5ZCnvw87z9d+suR6ToJgspIgCms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 275/393] leds: rgb: leds-qcom-lpg: Fix calculation of best period Hi-Res PWMs
Date: Thu, 17 Apr 2025 19:51:24 +0200
Message-ID: <20250417175118.666323521@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -461,7 +461,7 @@ static int lpg_calc_freq(struct lpg_chan
 		max_res = LPG_RESOLUTION_9BIT;
 	}
 
-	min_period = div64_u64((u64)NSEC_PER_SEC * (1 << pwm_resolution_arr[0]),
+	min_period = div64_u64((u64)NSEC_PER_SEC * ((1 << pwm_resolution_arr[0]) - 1),
 			       clk_rate_arr[clk_len - 1]);
 	if (period <= min_period)
 		return -EINVAL;
@@ -482,7 +482,7 @@ static int lpg_calc_freq(struct lpg_chan
 	 */
 
 	for (i = 0; i < pwm_resolution_count; i++) {
-		resolution = 1 << pwm_resolution_arr[i];
+		resolution = (1 << pwm_resolution_arr[i]) - 1;
 		for (clk_sel = 1; clk_sel < clk_len; clk_sel++) {
 			u64 numerator = period * clk_rate_arr[clk_sel];
 
@@ -1291,7 +1291,7 @@ static int lpg_pwm_get_state(struct pwm_
 		if (ret)
 			return ret;
 
-		state->period = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * (1 << resolution) *
+		state->period = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * ((1 << resolution) - 1) *
 						 pre_div * (1 << m), refclk);
 		state->duty_cycle = DIV_ROUND_UP_ULL((u64)NSEC_PER_SEC * pwm_value * pre_div * (1 << m), refclk);
 	} else {


