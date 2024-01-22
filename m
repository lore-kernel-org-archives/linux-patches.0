Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F4745D6;
	Tue, 23 Jan 2024 02:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975450; cv=none; b=hUgTTsfyB0UT3InFhNCj4CYsTbHauRtRWmoEAJ73XffeZrFV6fmrvLDsZtpglECR/EqOJY9gSje7AfJ3G1O+qsYl+WP94cKI/bnuGg74N45gM/QmilCfds2Ht8M1uvvyuNi9ik4TlXDzYVv2WN9/EEX/TO35gbLfiJLo22hoXaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975450; c=relaxed/simple;
	bh=GjfZkZZaEkXFiPVyGwah3+VPn3ETD24KD4tWZ3QONfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9oiHa2wlKKS5pDMZ0isPzHFGQftwCwjy7npL3s3qSnav9nfgYPBgDIJUMwogkFpjY9SP1RlKc3VjEW3tB7+3RcUBRPpKWQeL03tfn130sE1J27ezGChnLCrSAy9IrAn+C63ySBF6kZh/WNkXcfHY4W0dXYmXQpdrWKu/QwOh4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9cDv/Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9cDv/Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E62C433F1;
	Tue, 23 Jan 2024 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975450;
	bh=GjfZkZZaEkXFiPVyGwah3+VPn3ETD24KD4tWZ3QONfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9cDv/Z2FQZQ4nzP0vBE2Ooi12I75xm3Oh2zNpRgclnsp7qDrZoS5va4SfzWtRsgl
	 wIM3mr0BwCzBFkSh6WXlh+BfNh6tThG/OTVSVb117PGIW/RyHvsnZHIqam64SFiL0d
	 23/Graisu2s3pSQWotBsaYK5gu7Tak7oydG3fPac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.6 406/583] pwm: Fix out-of-bounds access in of_pwm_single_xlate()
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235824.400884078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit a297d07b9a1e4fb8cda25a4a2363a507d294b7c9 upstream.

With args->args_count == 2 args->args[2] is not defined. Actually the
flags are contained in args->args[1].

Fixes: 3ab7b6ac5d82 ("pwm: Introduce single-PWM of_xlate function")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/243908750d306e018a3d4bf2eb745d53ab50f663.1704835845.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -176,7 +176,7 @@ of_pwm_single_xlate(struct pwm_chip *chi
 	pwm->args.period = args->args[0];
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
 
-	if (args->args_count == 2 && args->args[2] & PWM_POLARITY_INVERTED)
+	if (args->args_count == 2 && args->args[1] & PWM_POLARITY_INVERTED)
 		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
 	return pwm;


