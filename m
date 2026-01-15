Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DC2C21F4;
	Thu, 15 Jan 2026 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498690; cv=none; b=TzNUOiK8DHLkaatMZ0wxZzpQROYyG2Q7ZEmnQ8Or3VDYmJy4BHWZhtFgdOdSPgMXUxbhK6Iu7BjohPhpDrNNbiqwn8zxNLcqSbPQxk+Nom1BqjUhLW5l+egR7Djsdaeh/DhEgeMFRlOa9kS9/QV9Y6GNOxjKhdybMCMMr5tn2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498690; c=relaxed/simple;
	bh=JlW/HzosNDTyr28SGTzV/WvYBKZFSE/8xbeHWMAsGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eoA51fC0iXdg5CNufxgmM9d/GNU9rfB1vPnGLPxbfC95LJ/kYAW9LV18lhNJHtgDzlWr3NIopVGIJn4PYP/w/qFImG6G8SDvb7VWVOf316Ff0RUVJYiVd+3gj0+mUsHw8fTolNMBRUOqYnTfvcgGSRimDhOerMR1kMucIDu9Vc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRfpHKnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRfpHKnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10178C116D0;
	Thu, 15 Jan 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498690;
	bh=JlW/HzosNDTyr28SGTzV/WvYBKZFSE/8xbeHWMAsGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRfpHKnYvwxGSkjsGYQqPX9JqcLuXeMrNgCJOjwjNIOCDVSu+HuF3smJXHRY3K+nB
	 HEoswJHsqqKupjeQGcYu+8wgOjkJUsiPkPMQmqlTfWBwiWZYB2RN8tDgvzf9HmKg+5
	 uRocWWPwdoHBZX2AD5fRcHdvFa9qcGSw2U/TVPzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	=?UTF-8?q?Uwe=20Kleine-K=F6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.15 493/554] pwm: stm32: Always program polarity
Date: Thu, 15 Jan 2026 17:49:19 +0100
Message-ID: <20260115164304.162076252@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sean Nyekjaer <sean@geanix.com>

Commit 7346e7a058a2 ("pwm: stm32: Always do lazy disabling") triggered a
regression where PWM polarity changes could be ignored.

stm32_pwm_set_polarity() was skipped due to a mismatch between the
cached pwm->state.polarity and the actual hardware state, leaving the
hardware polarity unchanged.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org # <= 6.12
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Co-developed-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
---
 drivers/pwm/pwm-stm32.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -458,8 +458,7 @@ static int stm32_pwm_apply(struct pwm_ch
 		return 0;
 	}
 
-	if (state->polarity != pwm->state.polarity)
-		stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
+	stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
 
 	ret = stm32_pwm_config(priv, pwm->hwpwm,
 			       state->duty_cycle, state->period);


