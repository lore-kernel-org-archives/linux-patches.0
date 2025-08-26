Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8F42AE68;
	Tue, 26 Aug 2025 14:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218397; cv=none; b=Dmtdm6V33+Dh6+dXblUHtloMTukFRr1wzJ1KtmjVy76y00p/RoZcRpyUqz7E0mlnJpDYpUV9x/NIs7CtOkGwaZsHUqYLfgvUa51dhb1EJV8P9QSiSyGNHHFk/kKGhjWSSwiEnZ/asGYCFoQcNJDADeQVzMEVhuDHl4hYFZuCBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218397; c=relaxed/simple;
	bh=ns3XXk+8zItA3WREVeUHPCPJBPUo6uHHsq4xX2/Cuck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyICQ9C7neWyDQi9p3PojYTtuq6bo3T0gYmYs1DIktVbWD4mHS4r84vpOXLRcLCojjAMQzn3th4a39XF7qLgwz54w3LowbB+UDdKNp0FhJh9f3IHfLrl5/b8AA15ogCHUtSzUQH5Xy20K55RgIL/Uw2zuH/aAWm+omHMzSscmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByeOtDIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByeOtDIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D1EC4CEF1;
	Tue, 26 Aug 2025 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218397;
	bh=ns3XXk+8zItA3WREVeUHPCPJBPUo6uHHsq4xX2/Cuck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByeOtDIU3HpcftVAHceiVj/PYk3Dyti8iKzmdaKL8d+2ZAAQhPBjzJQrMI6UqEayC
	 F9FpqAX3441+lsKhaaBCsiCXR7oSKig+Y47vDLxhpgRGsDbECOTvGvQ+2GXAFehdsg
	 fYI0eaDeNp6bAtvI0PeHCeFDXhGNM14fewAmEwYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/523] pwm: mediatek: Implement .apply() callback
Date: Tue, 26 Aug 2025 13:11:26 +0200
Message-ID: <20250826110936.186923332@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
@@ -211,10 +211,33 @@ static void pwm_mediatek_disable(struct
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
 


