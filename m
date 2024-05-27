Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97115FCFC;
	Mon, 27 May 2024 19:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838137; cv=none; b=M5JZWHjPDG3ntEqhPKie0zlkVKbGP7HOg6P51MjaPBLivAodikMtC0A2dnBHs9NuhKRyYfhhVAC05v6P4t7MtnJb/0dCHGh9IHnMp37f0woCchhlUb6GpcatIT5V+367Z/jyxRKNnT7pbyV9B60TdoS2useVmyZQPor5bdHVkUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838137; c=relaxed/simple;
	bh=RlDy7A6O2Rns+c/i5LwhtIZu1J5ncy0NDQo0G1yIlxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4BWkDhFe0lN87DMhyGu9bHcJxLN9Qg2lf7W9oliGPZfn3c4SShKUlaIKO0Vd2YpFhaszxbbqUbYzJSqF0eeUlv8h+z8KiXM77rp/PO2DHvGw+iacn46AbVBaf5l2lrj5xg8jkGcABAAkmUYe0t9LNzjiiz7h8deQwHkfcBsiTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jb8aYWdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jb8aYWdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACEAC2BBFC;
	Mon, 27 May 2024 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838137;
	bh=RlDy7A6O2Rns+c/i5LwhtIZu1J5ncy0NDQo0G1yIlxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jb8aYWdDU1mmjveZs//Ua7dmk3IJz8RUMInM2TcVw65TQrAPO/opNpKkKH+TVhXLD
	 u4993XDlngL1rlEYTzdnCAVzc/nz4TIOmx1btDVnc9BA8ZTNh/tVj4xmX+84LyYHS5
	 7786KqTpdnLpS+PN3jpPaWOjd8Dyh+dXQOZ9gmP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 263/493] pwm: meson: Make use of pwmchip_parent() accessor
Date: Mon, 27 May 2024 20:54:25 +0200
Message-ID: <20240527185638.888817949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e369035a98894a7327e78ebd01ec859c6654fc52 ]

struct pwm_chip::dev is about to change. To not have to touch this
driver in the same commit as struct pwm_chip::dev, use the accessor
function provided for exactly this purpose.

Link: https://lore.kernel.org/r/02d5f32001c4d0817fa79f5831cfd16b7e345f00.1707900770.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 3e551115aee0 ("pwm: meson: Add check for error from clk_round_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 7ce41811537dd..8f67d6ba443de 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -122,7 +122,7 @@ static int meson_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct meson_pwm *meson = to_meson_pwm(chip);
 	struct meson_pwm_channel *channel = &meson->channels[pwm->hwpwm];
-	struct device *dev = chip->dev;
+	struct device *dev = pwmchip_parent(chip);
 	int err;
 
 	err = clk_prepare_enable(channel->clk);
@@ -170,19 +170,19 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	fin_freq = clk_round_rate(channel->clk, freq);
 	if (fin_freq == 0) {
-		dev_err(chip->dev, "invalid source clock frequency\n");
+		dev_err(pwmchip_parent(chip), "invalid source clock frequency\n");
 		return -EINVAL;
 	}
 
-	dev_dbg(chip->dev, "fin_freq: %lu Hz\n", fin_freq);
+	dev_dbg(pwmchip_parent(chip), "fin_freq: %lu Hz\n", fin_freq);
 
 	cnt = div_u64(fin_freq * period, NSEC_PER_SEC);
 	if (cnt > 0xffff) {
-		dev_err(chip->dev, "unable to get period cnt\n");
+		dev_err(pwmchip_parent(chip), "unable to get period cnt\n");
 		return -EINVAL;
 	}
 
-	dev_dbg(chip->dev, "period=%llu cnt=%u\n", period, cnt);
+	dev_dbg(pwmchip_parent(chip), "period=%llu cnt=%u\n", period, cnt);
 
 	if (duty == period) {
 		channel->hi = cnt;
@@ -193,7 +193,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 	} else {
 		duty_cnt = div_u64(fin_freq * duty, NSEC_PER_SEC);
 
-		dev_dbg(chip->dev, "duty=%llu duty_cnt=%u\n", duty, duty_cnt);
+		dev_dbg(pwmchip_parent(chip), "duty=%llu duty_cnt=%u\n", duty, duty_cnt);
 
 		channel->hi = duty_cnt;
 		channel->lo = cnt - duty_cnt;
@@ -217,7 +217,7 @@ static void meson_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	err = clk_set_rate(channel->clk, channel->rate);
 	if (err)
-		dev_err(chip->dev, "setting clock rate failed\n");
+		dev_err(pwmchip_parent(chip), "setting clock rate failed\n");
 
 	spin_lock_irqsave(&meson->lock, flags);
 
@@ -439,7 +439,7 @@ static int meson_pwm_init_channels(struct pwm_chip *chip)
 {
 	struct meson_pwm *meson = to_meson_pwm(chip);
 	struct clk_parent_data mux_parent_data[MESON_MAX_MUX_PARENTS] = {};
-	struct device *dev = chip->dev;
+	struct device *dev = pwmchip_parent(chip);
 	unsigned int i;
 	char name[255];
 	int err;
-- 
2.43.0



