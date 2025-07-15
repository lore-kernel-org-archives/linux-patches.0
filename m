Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565F2E2EEF;
	Tue, 15 Jul 2025 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586857; cv=none; b=JLDtugZ7rL57tx6MArZkKglAgqBgt07GE3cEBeOLJ9gAoefDFcTwS64nWPyttlZTaMLYyC9L+rvYa7pv85kqvqa+CV4Gg+Q4rBKYE/+3+kTzFU9RxbUa9kZk/wnyRapNJjIZa83N3A0m9eqMuRI7GshXecMHXkasGVoED4ON/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586857; c=relaxed/simple;
	bh=b9ZPXrdNa5wB32Q8GxpjOHmq9CshDNWVZbnRum3/Rwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DQUhqu8DXyStk38KtgNTKfPLcZiiedgyxIy1Tyc1Av88ZO0NV4VWXbtwNGvJQGz1hgPyd9u3/5kv94tQ1VUHvMWMjcRaNe90EpsiAW3JoPXm/BzXI9k4xEfESCwIlFJshf0WzZY6kXq15oN3kGf1sytp60dg8sMtT1Q8GoKNUIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCyQ2t/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCyQ2t/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABFAC4CEE3;
	Tue, 15 Jul 2025 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586856;
	bh=b9ZPXrdNa5wB32Q8GxpjOHmq9CshDNWVZbnRum3/Rwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCyQ2t/ua2mfs4s6+8OCLSLX/KJQetiNVEed1BaxhpXIeEQoWw5y1OBB4tcbvfhrQ
	 ywwbChDp3zGjzMs4gzwLM9LHiyb3c1b39Eknks4odz2/M6YIsKIWazWTnA1uQryLPH
	 aIA7LmL3s+6Z148A9uAf/8ogGOLppYKmS4eFeJrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.15 074/192] pwm: mediatek: Ensure to disable clocks in error path
Date: Tue, 15 Jul 2025 15:12:49 +0200
Message-ID: <20250715130817.902186916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 505b730ede7f5c4083ff212aa955155b5b92e574 upstream.

After enabling the clocks each error path must disable the clocks again.
One of them failed to do so. Unify the error paths to use goto to make it
harder for future changes to add a similar bug.

Fixes: 7ca59947b5fc ("pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250704172728.626815-2-u.kleine-koenig@baylibre.com
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mediatek.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -130,8 +130,10 @@ static int pwm_mediatek_config(struct pw
 		return ret;
 
 	clk_rate = clk_get_rate(pc->clk_pwms[pwm->hwpwm]);
-	if (!clk_rate)
-		return -EINVAL;
+	if (!clk_rate) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Make sure we use the bus clock and not the 26MHz clock */
 	if (pc->soc->has_ck_26m_sel)
@@ -150,9 +152,9 @@ static int pwm_mediatek_config(struct pw
 	}
 
 	if (clkdiv > PWM_CLK_DIV_MAX) {
-		pwm_mediatek_clk_disable(chip, pwm);
 		dev_err(pwmchip_parent(chip), "period of %d ns not supported\n", period_ns);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (pc->soc->pwm45_fixup && pwm->hwpwm > 2) {
@@ -169,9 +171,10 @@ static int pwm_mediatek_config(struct pw
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_width, cnt_period);
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_thres, cnt_duty);
 
+out:
 	pwm_mediatek_clk_disable(chip, pwm);
 
-	return 0;
+	return ret;
 }
 
 static int pwm_mediatek_enable(struct pwm_chip *chip, struct pwm_device *pwm)


