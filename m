Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03C62E339B;
	Tue, 15 Jul 2025 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586594; cv=none; b=r51NdbOsFKb1LT3O+wMms1c34JquF8GK3mYOsEIfIc2P2E/Vs9KSPconr3IFdw1xwFjeB831qtj+dCYB9POZnBPntq1kAJllqbgZdJGxPaeQtzf27kiPcJehKpeIHImFzcwvXNGvLvdtwfsJPn7y7m1uxijPWaHkz3BcqkhsQ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586594; c=relaxed/simple;
	bh=XhuFar+czKwtrq5n5FX4r44OQk0bq1tC6Im/TeeKOWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCRU8qTKF8Z3aBx9n1tcYxwb1HU+WiQEf8AVOgXu+NqGBzRduoE1o3ofbuAdcggP34SdHbL26M8yoAQo/tGt1/htFSPvJROdjY8BgBUdM0oPvqxYsfwbGs+x28YRpaStBZ612rncSX4/Fwwfy0Az6geQgeKbq5UMs4Bb2vl2Nk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDsE6jrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDsE6jrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396DDC4CEE3;
	Tue, 15 Jul 2025 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586594;
	bh=XhuFar+czKwtrq5n5FX4r44OQk0bq1tC6Im/TeeKOWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDsE6jrTnsKDw+Azac5TVgOSjNOE96Q0mX3cyC89wL/0j5mBD1DlgzYtrAfnh8s18
	 961JFDqCQoBD2raGGz2hm7rtJOey0MbJAIVAuWp9TWwZ72+tXf72krqN9Cklv+d8Fx
	 Y8TpWA67EvVGX9g89jqDGkK1XFwQoQxX0dWylZG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.4 124/148] pwm: mediatek: Ensure to disable clocks in error path
Date: Tue, 15 Jul 2025 15:14:06 +0200
Message-ID: <20250715130805.262630586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ukleinek: backported to 5.15.y]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mediatek.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -134,8 +134,10 @@ static int pwm_mediatek_config(struct pw
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
@@ -154,9 +156,9 @@ static int pwm_mediatek_config(struct pw
 	}
 
 	if (clkdiv > PWM_CLK_DIV_MAX) {
-		pwm_mediatek_clk_disable(chip, pwm);
-		dev_err(chip->dev, "period %d not supported\n", period_ns);
-		return -EINVAL;
+		dev_err(chip->dev, "period of %d ns not supported\n", period_ns);
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (pc->soc->pwm45_fixup && pwm->hwpwm > 2) {
@@ -173,9 +175,10 @@ static int pwm_mediatek_config(struct pw
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_width, cnt_period);
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_thres, cnt_duty);
 
+out:
 	pwm_mediatek_clk_disable(chip, pwm);
 
-	return 0;
+	return ret;
 }
 
 static int pwm_mediatek_enable(struct pwm_chip *chip, struct pwm_device *pwm)


