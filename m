Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66768178381;
	Tue,  2 Jul 2024 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940026; cv=none; b=o3M8XKRHqyTn3yjyM38wJPRdU2RehtvSKZOAO5k9FRuvAFKR1c+6YglONq/sOiPlr8iSanPdPE80mJprWyPXx2XoQ9Dksp8vck58dAaRB/fdxdzie66Ox0TgHT5bqSj8VOqHcqIdZh8njCMDswp3jVghVTfDm2pRzQxHIQ7k2xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940026; c=relaxed/simple;
	bh=89hjCFzK5SJ2eKc6wj7v9sJJljp5m1JcHG8z995VQWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtZ7McBPN1M0zs7sVaQhraPKBzT6320sLQwRx9sRZy1d43TLD3/WHvftq8fKborlvAo90RtHhnhmk5js3G6baQ9NeNCg7fUoCeAaH6dM01082fnrdGyapWm5GGIBvnFQg3QFcvaS5uNe2veGjQBr9zlpZ/FtxjzKZ+ccKMQwzL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRm8wnIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRm8wnIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17D4C4AF0A;
	Tue,  2 Jul 2024 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940026;
	bh=89hjCFzK5SJ2eKc6wj7v9sJJljp5m1JcHG8z995VQWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRm8wnIJEI1UhIUcjAQ2a09iuKxi+SySUZT7G77Bva1CbytlMbktrCZBMW64lH1ho
	 7DQ86G+fVnBqRfk+N1q9oNB39uPDtujHQOMZq8kvYxjZruH9KuRQ6f+78IxA70Lins
	 KHnmYMwVHxZskKW2nEWQR/w60xQc+NqqTIMiUQVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 013/222] pwm: stm32: Calculate prescaler with a division instead of a loop
Date: Tue,  2 Jul 2024 19:00:51 +0200
Message-ID: <20240702170244.481308773@linuxfoundation.org>
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

[ Upstream commit 8002fbeef1e469b2c397d5cd2940e37b32a17849 ]

Instead of looping over increasing values for the prescaler and testing
if it's big enough, calculate the value using a single division.

Link: https://lore.kernel.org/r/498a44b313a6c0a84ccddd03cd67aadaaaf7daf2.1710711976.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: c45fcf46ca23 ("pwm: stm32: Refuse too small period requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 27fcc90504f67..1c8911353b81d 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -311,29 +311,33 @@ static int stm32_pwm_capture(struct pwm_chip *chip, struct pwm_device *pwm,
 static int stm32_pwm_config(struct stm32_pwm *priv, unsigned int ch,
 			    u64 duty_ns, u64 period_ns)
 {
-	unsigned long long prd, div, dty;
-	unsigned int prescaler = 0;
+	unsigned long long prd, dty;
+	unsigned long long prescaler;
 	u32 ccmr, mask, shift;
 
 	/*
 	 * .probe() asserted that clk_get_rate() is not bigger than 1 GHz, so
-	 * this won't overflow.
+	 * the calculations here won't overflow.
+	 * First we need to find the minimal value for prescaler such that
+	 *
+	 *        period_ns * clkrate
+	 *   ------------------------------
+	 *   NSEC_PER_SEC * (prescaler + 1)
+	 *
+	 * isn't bigger than max_arr.
 	 */
-	div = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
-				  NSEC_PER_SEC);
-	prd = div;
-
-	while (div > priv->max_arr) {
-		prescaler++;
-		div = prd;
-		do_div(div, prescaler + 1);
-	}
 
-	prd = div;
+	prescaler = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
+					(u64)NSEC_PER_SEC * priv->max_arr);
+	if (prescaler > 0)
+		prescaler -= 1;
 
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 
+	prd = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
+				  (u64)NSEC_PER_SEC * (prescaler + 1));
+
 	/*
 	 * All channels share the same prescaler and counter so when two
 	 * channels are active at the same time we can't change them
-- 
2.43.0



