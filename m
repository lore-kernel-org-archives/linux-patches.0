Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD17913C816;
	Thu, 13 Feb 2025 15:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460717; cv=none; b=QP43kQwiVcsJu3CcwLTVUV/pxhsYMiYk8xT1cbA7sJyWWZv+NJslpfjKBq6ks/+yt8+0VmnqeH+Oh6T4GpoilSmNvHntOyvX0vKQgsQhpyRrG6wibGrAoc5oBBEPzYyRyMghLm9yui3gmnYXalAE56v05+tV5N02nte6LiolvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460717; c=relaxed/simple;
	bh=k1UOOXVni+Uw2uP8nJN+jW3nrd2vDYA7Xz8yxRAXxnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjH0w19op48wmxC18EcGylDybrrQNFljQAq0VB1vx7V/ylcT+wseXCb9JT7hsmC2uRd6imftFgcZlFAkdkU7aYKkpUyxBS3ftOOCaZMLzR9+ymvYM/7RaSinIlBHjnpTXc4Eq1HRFlnGIaRTLUhln2LGLFuyKDCheKbjLePH2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzxcsLM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzxcsLM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F96FC4CED1;
	Thu, 13 Feb 2025 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460717;
	bh=k1UOOXVni+Uw2uP8nJN+jW3nrd2vDYA7Xz8yxRAXxnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzxcsLM9H/D18K2rg7ulttHT5qugMErke23FHVdA2Q/MLM6QGcQZh8dEpFHDrVhdx
	 7Ju/tPUlSkr/gw272fva20xljuczYZULvPVeC8X0VA4y+oX3J9GlV/pVBkbMwkR0d4
	 Bv3Ij1G40nJZgjHO6BMzi7L5fbjYUCapdm7QDIOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 192/273] pwm: microchip-core: fix incorrect comparison with max period
Date: Thu, 13 Feb 2025 15:29:24 +0100
Message-ID: <20250213142414.912446551@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 752b6e3af374460a2de18f0c10bfa06bf844dbe8 upstream.

In mchp_core_pwm_apply_locked(), if hw_period_steps is equal to its max,
an error is reported and .apply fails. The max value is actually a
permitted value however, and so this check can fail where multiple
channels are enabled.

For example, the first channel to be configured requests a period that
sets hw_period_steps to the maximum value, and when a second channel
is enabled the driver reads hw_period_steps back from the hardware and
finds it to be the maximum possible value, triggering the warning on a
permitted value. The value to be avoided is 255 (PERIOD_STEPS_MAX + 1),
as that will produce undesired behaviour, so test for greater than,
rather than equal to.

Fixes: 2bf7ecf7b4ff ("pwm: add microchip soft ip corePWM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250122-pastor-fancied-0b993da2d2d2@spud
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-microchip-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/pwm-microchip-core.c
+++ b/drivers/pwm/pwm-microchip-core.c
@@ -328,7 +328,7 @@ static int mchp_core_pwm_apply_locked(st
 		 * mchp_core_pwm_calc_period().
 		 * The period is locked and we cannot change this, so we abort.
 		 */
-		if (hw_period_steps == MCHPCOREPWM_PERIOD_STEPS_MAX)
+		if (hw_period_steps > MCHPCOREPWM_PERIOD_STEPS_MAX)
 			return -EINVAL;
 
 		prescale = hw_prescale;


