Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452EE139579;
	Thu, 13 Feb 2025 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458150; cv=none; b=gm+5fN6JPPLILEZTJqNdcokTuMXppwD8VcuuzPJ4PBcszl8i78YoxMiWVDrIJAuUFiaLL6eiiUoqLtHmifLHOwqgN+XiI5rTRDCb2SejObBDYMcJWik+IefzuDoeGiOcvaJv+vPQulVRB+VndxSdrqmSpg6Mu/f35sVZIFs505E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458150; c=relaxed/simple;
	bh=brPE4bIGZj0bW1L1npgHLLQxmZZkuKpQ8HAHLlc3kOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYFAsKwNwwmhlx6ph+PJQaRLuUP1CwkIqCz3wDIlYFFAmyWwR+TXDNgCXn3tU0hsF5QSwFHphgKRHWGIWeCmx+SHDU5o0r88fQnl+5/wdIOQtHRxlzdK1XW8uX0rXW+jd+tP7jOJ4mE0EmG7IGCiv4KjglNXp39U3Viu9ApmDdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH1dYkjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH1dYkjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC9C4CED1;
	Thu, 13 Feb 2025 14:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458149;
	bh=brPE4bIGZj0bW1L1npgHLLQxmZZkuKpQ8HAHLlc3kOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wH1dYkjcjKN7QEH1COho3KD0qdrdeODR3Z+gPLdBmcMFlnbbWAmXK/vp90YcqjmXN
	 rcPmrRU61UtgOOwVYfToeHYGKlG2JZ7T6j2r5UKk7eETRE0GVOcDKrfapUWjZgqMXG
	 hnBt/O72STh+wRjW/iogShtq2RtJbqW9F1v7HhXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.12 299/422] pwm: microchip-core: fix incorrect comparison with max period
Date: Thu, 13 Feb 2025 15:27:28 +0100
Message-ID: <20250213142448.080115927@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -327,7 +327,7 @@ static int mchp_core_pwm_apply_locked(st
 		 * mchp_core_pwm_calc_period().
 		 * The period is locked and we cannot change this, so we abort.
 		 */
-		if (hw_period_steps == MCHPCOREPWM_PERIOD_STEPS_MAX)
+		if (hw_period_steps > MCHPCOREPWM_PERIOD_STEPS_MAX)
 			return -EINVAL;
 
 		prescale = hw_prescale;


