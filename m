Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE81302CA6;
	Tue, 26 Aug 2025 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217045; cv=none; b=Itf3Griyx8uZj3Ae3RCyA6lt7gv0anfXoGgCx5iX8VLRRwBieJcsG+QE/HbtYqLnEgTCEKje254CT0P76gTrQCnM17RyPPlkU/vVy1l62sMuPQF47vHvm0i1dG9nAS6mAd92/YVyPBwu6dcDf5VQRIf+Xuxwm2iUCiyksJdu0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217045; c=relaxed/simple;
	bh=T/B76OhovgdMVEyOkDhrURQqtNYkcrvzyV1KPJlPFJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWJhKZOrjUIazIv4fTe2Q+ZP7vYcIEI0mbz0Ck29w8+NJ6fYdRghqgjHvMbOthtRdrMIML0BYpiVvTZ4q25R1FynpdmNi60bINdqZ323pk/4K7RT3RD4EkvlHFRUUFBLsKrXwKfBYVNzTPitoSiS4cjjgKARrk8eR6lWtjtKxZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjRVVBd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjRVVBd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87328C113CF;
	Tue, 26 Aug 2025 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217044;
	bh=T/B76OhovgdMVEyOkDhrURQqtNYkcrvzyV1KPJlPFJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjRVVBd7IDOwaRrnPLRoWhhD2PzMpazWdCO629xTslYkJmKNx22LlGgBJcxYS6I0F
	 4E0GkGOqIdZjG+76gGudpVFQD5+6a+0IszaYInJAtRpz4nCdp4V7Vs2eHnsL9l/ycq
	 FQrzYHLtW11i/OH4PDyYs90Z35pumPjq42ludQQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 608/644] pwm: mediatek: Implement .apply() callback
Date: Tue, 26 Aug 2025 13:11:39 +0200
Message-ID: <20250826111001.617622443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 758de66f4bd2cac2b1d71db917c65c3d611d4e74 ]

To eventually get rid of all legacy drivers convert this driver to the
modern world implementing .apply().
This just pushed a variant of pwm_apply_legacy() into the driver that was
slightly simplified because the driver doesn't provide a .set_polarity()
callback.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: f21d136caf81 ("pwm: mediatek: Fix duty and period setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-mediatek.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -205,10 +205,33 @@ static void pwm_mediatek_disable(struct
 	pwm_mediatek_clk_disable(chip, pwm);
 }
 
+static int pwm_mediatek_apply(struct pwm_chip *chip, struct pwm_device *pwm,
+			      const struct pwm_state *state)
+{
+	int err;
+
+	if (state->polarity != PWM_POLARITY_NORMAL)
+		return -EINVAL;
+
+	if (!state->enabled) {
+		if (pwm->state.enabled)
+			pwm_mediatek_disable(chip, pwm);
+
+		return 0;
+	}
+
+	err = pwm_mediatek_config(pwm->chip, pwm, state->duty_cycle, state->period);
+	if (err)
+		return err;
+
+	if (!pwm->state.enabled)
+		err = pwm_mediatek_enable(chip, pwm);
+
+	return err;
+}
+
 static const struct pwm_ops pwm_mediatek_ops = {
-	.config = pwm_mediatek_config,
-	.enable = pwm_mediatek_enable,
-	.disable = pwm_mediatek_disable,
+	.apply = pwm_mediatek_apply,
 	.owner = THIS_MODULE,
 };
 


