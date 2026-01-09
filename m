Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DBF33C52A;
	Fri,  9 Jan 2026 11:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959075; cv=none; b=cdWzWYACWkzXVQ4zqgbE/wqZfomVGXY8eAeDhfQZwOTso1BlcapO3PxdvV1+JK0/9uhn4xQFs792yd2CM63A9pNXuE4QqQM22AUzLMeOGJFhQ0nENt4ZK8jWhSi8h2ZyAP0b+YwgRiXc0Y8CLmVA+znhHHCeuJ+TSQsxfsbYn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959075; c=relaxed/simple;
	bh=h6MnrMzkEqmj49Vob0ca+nD68Yd4gC7YOHR6o8Jei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSXcd2aZt8p8PDBVRnNvaTyweJlIOaqAmlGFbG6VlIOtfhTb7VQMuFfFxjFRDAYdwflAUxe2xvM+ScSUbnj1iakDEgAe/jSBlKXAuI/8LWAhjfduVab6bBnACn+Py9VkkDDu/G4SOyCEQjypSCufKsnxDZhRrk294nqiJVFjvug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAqirCdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAqirCdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D8BC4CEF1;
	Fri,  9 Jan 2026 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959075;
	bh=h6MnrMzkEqmj49Vob0ca+nD68Yd4gC7YOHR6o8Jei/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAqirCdxw3kKckYgiTgOVQHMnA76ofkvMuN9aCf1S0947o0Nu0RPrypOHtolADqyZ
	 BNg++FItvFbKBPcOVThAEDb5c9KgC6H/lV59k5EMEAqA82Ptr218AJfPLDZmfIVVho
	 SlMPZLugrGXyGiTr2tiZeub7PRGiDPTMUQMIaHQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	=?UTF-8?q?Uwe=20Kleine-K=F6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.12 15/16] pwm: stm32: Always program polarity
Date: Fri,  9 Jan 2026 12:43:56 +0100
Message-ID: <20260109111951.995524512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


