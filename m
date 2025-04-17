Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C725525A;
	Thu, 17 Apr 2025 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915893; cv=none; b=su8u3uN2Jjty1maX8oBgVQ03PWc6D+VCd++bca2E60sMnubO4+AoF1fm+niph/QgvttlCm0Ldky8ljq7wtt8oMjz/RuNxVoyEal5SGdERGer6V3/9fkxw7xKkjO6illEMqpVJUIiA9fQ+hhGJxxEvQwXHhdI0DrCviFAQxMFwx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915893; c=relaxed/simple;
	bh=RLlU7LX8avpXmrpQUt0mtzTusUJU0v0sR6qDOoSc+Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k855yWNYbLD3dCaeHe8rIphZ9uOSVX9OxoDiUJ3+4UBZN/iPssRcNBxI0OCujSgAYAtRXmcbL/vse+F42e0qJC1mvmB5f4LtN7QhD9G5md8fYn+LX70ytV/9g0jS9cuJjYmXvRsFP9IFZLJjVLnIFG6oieq1f8VhiZWklVyw09A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQMuikEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQMuikEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00100C4CEE4;
	Thu, 17 Apr 2025 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915893;
	bh=RLlU7LX8avpXmrpQUt0mtzTusUJU0v0sR6qDOoSc+Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQMuikEoKSV5yR6uu6QbVuQ4tsTMa2Q+yfmzmtfzm43qK5FO1Jc5JBUUn/wx49cSt
	 Ld3/VlgOJth0aQ8RfxMCw2cKAvSiXwq0RWn/xymZxAJ1gU9ozvrPBigPe2u30xundQ
	 9psIMDQLRp9JG/4mPgtBt86pPwDbAZDlYzfLKgSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sebastian Reichel <sre@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 274/393] leds: rgb: leds-qcom-lpg: Fix pwm resolution max for Hi-Res PWMs
Date: Thu, 17 Apr 2025 19:51:23 +0200
Message-ID: <20250417175118.625930758@linuxfoundation.org>
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

commit b7881eacc07fdf50be3f33c662997541bb59366d upstream.

Ideally, the requested duty cycle should never translate to a PWM
value higher than the selected resolution (PWM size), but currently the
best matched period is never reported back to the PWM consumer, so the
consumer will still be using the requested period which is higher than
the best matched one. This will result in PWM consumer requesting
duty cycle values higher than the allowed PWM value.

For example, a consumer might request a period of 5ms while the best
(closest) period the PWM hardware will do is 4.26ms. For this best
matched resolution, if the selected resolution is 8-bit wide, when
the consumer asks for a duty cycle of 5ms, the PWM value will be 300,
which is outside of what the resolution allows. This will happen with
all possible resolutions when selected.

Since for these Hi-Res PWMs, the current implementation is capping the PWM
value at a 15-bit resolution, even when lower resolutions are selected,
the value will be wrapped around by the HW internal logic to the selected
resolution.

Fix the issue by capping the PWM value to the maximum value allowed by
the selected resolution.

Cc: stable@vger.kernel.org    # 6.4
Fixes: b00d2ed37617 ("leds: rgb: leds-qcom-lpg: Add support for high resolution PWM")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Sebastian Reichel <sre@kernel.org>
Link: https://lore.kernel.org/r/20250305-leds-qcom-lpg-fix-max-pwm-on-hi-res-v4-2-bfe124a53a9f@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -529,7 +529,7 @@ static void lpg_calc_duty(struct lpg_cha
 	unsigned int clk_rate;
 
 	if (chan->subtype == LPG_SUBTYPE_HI_RES_PWM) {
-		max = LPG_RESOLUTION_15BIT - 1;
+		max = BIT(lpg_pwm_resolution_hi_res[chan->pwm_resolution_sel]) - 1;
 		clk_rate = lpg_clk_rates_hi_res[chan->clk_sel];
 	} else {
 		max = LPG_RESOLUTION_9BIT - 1;


