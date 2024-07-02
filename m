Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3A1BF30B;
	Tue,  2 Jul 2024 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940603; cv=none; b=QYBI1h5efYziWr1CCpzTaHOg62ywDfFNKQmxAboUjPrle5hdTvCi/SiIWp95fDwyJkXZRdCWlcrkSItPTCDsJP5klwkkI2ywbH25pgp2LDO6RW4suTK0zIkVovoesrv4GZDyWoDSMpNj32r8p/cBluKiuhhA3+787HP0rVwOFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940603; c=relaxed/simple;
	bh=fPGwyImUqJ+2wgM6IWhQE4QxbHAN93Gin6LShPybPNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ctxV0ucG2WAWHDs6w7rKUTHm2Psv7MZR7MikCl+dh++sMFcq4RW7Ad3QMfkNd7T5Xms51Qtk6l4ma9S0z6WCpZ49E4yM+O2z+vtfxBWYsHISsqHoeXxYAnv638yqgd6ckxqg/uvFlzdWeG0bN6ETc29oCBjRQqyk+h4ZM30FxZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odBmSGco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odBmSGco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE8EC4AF0F;
	Tue,  2 Jul 2024 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940603;
	bh=fPGwyImUqJ+2wgM6IWhQE4QxbHAN93Gin6LShPybPNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odBmSGcowiuX8znmAg5exmf9YQdX97g1YAEDQGYqMLThlMYmARnKHiGk9Es8L5K4j
	 VeitCQ25YBe9N6ljqLj9zztbCSOhYNN8SihSP5I2F7Xpya/Lmnn6ECEBdnc05uDSdU
	 yQe4TZbFmCYvO9xSNoT+QoRTku7/GmNSO4G1aMAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.9 204/222] pwm: stm32: Fix error message to not describe the previous error path
Date: Tue,  2 Jul 2024 19:04:02 +0200
Message-ID: <20240702170251.783773846@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit f01af3022d4a46362c5dda3d35dea939f3246d10 upstream.

"Failed to lock the clock" is an appropriate error message for
clk_rate_exclusive_get() failing, but not for the clock running too
fast for the driver's calculations.

Adapt the error message accordingly.

Fixes: d44d635635a7 ("pwm: stm32: Fix for settings using period > UINT32_MAX")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/285182163211203fc823a65b180761f46e828dcb.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -679,7 +679,8 @@ static int stm32_pwm_probe(struct platfo
 	 * .apply() won't overflow.
 	 */
 	if (clk_get_rate(priv->clk) > 1000000000)
-		return dev_err_probe(dev, -EINVAL, "Failed to lock clock\n");
+		return dev_err_probe(dev, -EINVAL, "Clock freq too high (%lu)\n",
+				     clk_get_rate(priv->clk));
 
 	chip->ops = &stm32pwm_ops;
 


