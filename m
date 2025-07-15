Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84912E3382;
	Tue, 15 Jul 2025 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587883; cv=none; b=fNbPCsJE0vZw/3ZQH7mMivcX4gLySOxNCOKXPhckF6nv8azG3Xd07Li/O/ci0QAcQbQ12WLuOiWU1wOcC0OjTWFBKVC1hvLY1sEYA6pSivaEj66MvbsiSXSxOfcI4BElJTEvHf8tB+ZorQ6LPuxm+io8Bi/h9ioJPWezZL6tQ1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587883; c=relaxed/simple;
	bh=bI5trV/ndm/sM4Wg0kAHqXCQbUn17+CBI2A9ABRPKO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLYEdjM7vfoxGUFwZy06tXE/OMBWTZLsbfhE93vXxJRizhn85c31TsRYWRL/rdJ6xWW6044hHihlpMvgkqqF7NUgElft98/WxZzNatMLfxtobd5v2QoiDFJwRZrn8KAiG0sK44dX7MzJ+pX0Xx1snu9IuHBVUyiGlGSP9njsc9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDFvz6A3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDFvz6A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D03C4CEE3;
	Tue, 15 Jul 2025 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587883;
	bh=bI5trV/ndm/sM4Wg0kAHqXCQbUn17+CBI2A9ABRPKO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDFvz6A3hAIS3qtxrarKOCtlCzTQiEGqhf1yyGP4ag4mri3NFJm4sBmC/oFEepZOD
	 TdnAPv3Q15iSYR9E5z+bS4FAVwvkLg8tVcEpzwl7RTPku4kax368Mpm/SL0IeMXKzk
	 8EXooHwK8kA46sxNlEThhba2qtDc5RGkEt8k87aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.10 180/208] pwm: mediatek: Ensure to disable clocks in error path
Date: Tue, 15 Jul 2025 15:14:49 +0200
Message-ID: <20250715130818.173503480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -135,8 +135,10 @@ static int pwm_mediatek_config(struct pw
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
@@ -155,9 +157,9 @@ static int pwm_mediatek_config(struct pw
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
@@ -174,9 +176,10 @@ static int pwm_mediatek_config(struct pw
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_width, cnt_period);
 	pwm_mediatek_writel(pc, pwm->hwpwm, reg_thres, cnt_duty);
 
+out:
 	pwm_mediatek_clk_disable(chip, pwm);
 
-	return 0;
+	return ret;
 }
 
 static int pwm_mediatek_enable(struct pwm_chip *chip, struct pwm_device *pwm)


