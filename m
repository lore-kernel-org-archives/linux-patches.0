Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACF96A354;
	Tue, 23 Jan 2024 02:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975354; cv=none; b=nVmkze0t1jF4pknJDveupK+NPVCbCqxFtYxi4GWBI5J41Rv7wYUko+0UnFtw3VzW2YXOQHbc40FIDa7ZNPSF10eKIDyKQDW8VyD22BlyZcv+phsk6Sg7CtnIXhnSMMahISooVeN05i7OBOnzBEwogom6A2ZNz3nwt2p5sMrgXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975354; c=relaxed/simple;
	bh=cbyhx/8AX10ChBb9DLfvdECZPC8zC2Wzwz0HZndZWis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ROaIpp9l6wguKHqZ2A0KyZyKr4/M2LFg/MY23HJrCSxTCsCqMyAjTpioMZ1y5QHkHRxSoKTOOm5T/Qf57EFqdpYQXhflFbqkqmgfQLNHERMsBPTWkNQMRM2k17r5uHzHIFyi2nBdd2vVxcL0YwHwL7QiEHDfmYq7eBRpvMLKz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0hoHon4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0hoHon4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1167C43394;
	Tue, 23 Jan 2024 02:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975353;
	bh=cbyhx/8AX10ChBb9DLfvdECZPC8zC2Wzwz0HZndZWis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0hoHon4X8mwdVmzvVYPSl3+vW7khDzdfCyVnA0PfP7Q2azYe2UxhtIo4mY9WvY1Q
	 ZZai2zfZUZI5QTsXB0fHYrh7APiXHTLeJDCJiKs51aPszWzfPV7fDljXZlYSaD+dHj
	 p5X8P1OxWZITgIDmWh7h5ookFH4xiR+gBf8sj8XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/583] pwm: stm32: Use hweight32 in stm32_pwm_detect_channels
Date: Mon, 22 Jan 2024 15:56:07 -0800
Message-ID: <20240122235821.711114612@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d6be7749e23..0c7781f17805 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -579,10 +579,9 @@ static void stm32_pwm_detect_complementary(struct stm32_pwm *priv)
 	priv->have_complementary_output = (ccer != 0);
 }
 
-static int stm32_pwm_detect_channels(struct stm32_pwm *priv)
+static unsigned int stm32_pwm_detect_channels(struct stm32_pwm *priv)
 {
 	u32 ccer;
-	int npwm = 0;
 
 	/*
 	 * If channels enable bits don't exist writing 1 will have no
@@ -592,19 +591,7 @@ static int stm32_pwm_detect_channels(struct stm32_pwm *priv)
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



