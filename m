Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20650258;
	Tue, 23 Jan 2024 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974650; cv=none; b=m2+pCyjccvbJpd0b1LAok9vHCHfHmGsmzh1BJSI/RPei3VSuiane/mHh9SfBsrBycPC47Zdl/31H/uqqA9mqWpQno5AJPC7RoCFyLxXBlpsDlMz7DWZ7Fv+wzdxs6Rrp3uW9D8H45TdSyQWpRXvYz5vCzxeNy+RsJHsLUTJxCPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974650; c=relaxed/simple;
	bh=PAdJ0hTGfatsgOri0BQ8CsiugY//gcK5y4Pi124UL5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZNpU8Jj6XwboFXxraOPc2OEJN5tG5TSw+L4MZ8u5ZBe28blxkSID8XRv6w0UgrSU/vMUMTMyY3q27bHsve6JrcHFrchn564gvVFeSju52XqpuaM2sWi3te6KrvBQVs5fzmjKYOjn5ICb8YidBTZJkBn/SZvjO43WxBdw4upg7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PivSGnWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PivSGnWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76DFC43394;
	Tue, 23 Jan 2024 01:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974650;
	bh=PAdJ0hTGfatsgOri0BQ8CsiugY//gcK5y4Pi124UL5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PivSGnWn8aOXwxpt2xrko0BfBC52mgIrGSZ2ah2B13WlvVQwj49q8QWo4dzMO36sG
	 b9t7iUOSmSes6T71VeYAi4IDVePnB/ETx859xSheYT139hkNfFMm9muZv/d/bnlpcD
	 RLMH4lSNJNLelEgk6/EdIJZm5cV4sLAW1mAQQjkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/374] pwm: stm32: Use hweight32 in stm32_pwm_detect_channels
Date: Mon, 22 Jan 2024 15:58:04 -0800
Message-ID: <20240122235752.628083117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 41fa8f57c0d269243fe3bde2bce71e82c884b9ad ]

Use hweight32() to count the CCxE bits in stm32_pwm_detect_channels().
Since the return value is assigned to chip.npwm, change it to unsigned
int as well.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 19f1016ea960 ("pwm: stm32: Fix enable count for clk in .probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 21e4a34dfff3..9c260aac442d 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -575,10 +575,9 @@ static void stm32_pwm_detect_complementary(struct stm32_pwm *priv)
 	priv->have_complementary_output = (ccer != 0);
 }
 
-static int stm32_pwm_detect_channels(struct stm32_pwm *priv)
+static unsigned int stm32_pwm_detect_channels(struct stm32_pwm *priv)
 {
 	u32 ccer;
-	int npwm = 0;
 
 	/*
 	 * If channels enable bits don't exist writing 1 will have no
@@ -588,19 +587,7 @@ static int stm32_pwm_detect_channels(struct stm32_pwm *priv)
 	regmap_read(priv->regmap, TIM_CCER, &ccer);
 	regmap_clear_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE);
 
-	if (ccer & TIM_CCER_CC1E)
-		npwm++;
-
-	if (ccer & TIM_CCER_CC2E)
-		npwm++;
-
-	if (ccer & TIM_CCER_CC3E)
-		npwm++;
-
-	if (ccer & TIM_CCER_CC4E)
-		npwm++;
-
-	return npwm;
+	return hweight32(ccer & TIM_CCER_CCXE);
 }
 
 static int stm32_pwm_probe(struct platform_device *pdev)
-- 
2.43.0



