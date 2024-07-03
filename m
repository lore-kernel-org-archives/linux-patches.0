Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153BD1946A2;
	Wed,  3 Jul 2024 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004291; cv=none; b=RyyVARLCKnsKevQSIKPoDag3vDtdU4/ZrrqBwliAuRFIA+45YQHbiqUpx89OM2Ou/gSGeXwBqSVOZBf6oLeoY6bbHWK1B8PyX15aU9djqmJMzmvtCANGZhWqlHsOjhHHH6nFW7+wlE44udjNHajoQoT/gp9LS5/VL+gV+4kT//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004291; c=relaxed/simple;
	bh=wN2/YEbmXUaQm6dQLJtelCZijrDrI3nvIC9rR+UESHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbLfxllVrPklvzUnYmIzqpgiOtsXunVcBEtI/KnnBTP47b2xMTPnixvXSllhkM2Ajd19qCD9ohOPpoVQsco7kTwxWJfJtcWddHOXKHf2acyI2hVZDXR/aXaJZV7fpGZ4Kkj630Z0E00bTBFvATxMGiuLj36A+Gv5y1FSMxgTUNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMi175IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMi175IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922CBC2BD10;
	Wed,  3 Jul 2024 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004291;
	bh=wN2/YEbmXUaQm6dQLJtelCZijrDrI3nvIC9rR+UESHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMi175IAaK2Z76EsoWibyl7A49+OjIJxvR66U3aytZwdekn2E5fHmS/RE5CN5wsDF
	 uAmFTj2LDh5K+JyvNZ0ffLJUjbPZXG5fiWPn5bzilt+3v0rLUu5e7cKSZ1+ZM0tF9i
	 RQqkaBOX17f47lyRWxlalWlXC47IKJiTqFmPsVLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.4 183/189] pwm: stm32: Refuse too small period requests
Date: Wed,  3 Jul 2024 12:40:44 +0200
Message-ID: <20240703102848.376824812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit c45fcf46ca2368dafe7e5c513a711a6f0f974308 upstream.

If period_ns is small, prd might well become 0. Catch that case because
otherwise with

	regmap_write(priv->regmap, TIM_ARR, prd - 1);

a few lines down quite a big period is configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b86f62f099983646f97eeb6bfc0117bb2d0c340d.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -337,6 +337,9 @@ static int stm32_pwm_config(struct stm32
 
 	prd = div;
 
+	if (!prd)
+		return -EINVAL;
+
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


