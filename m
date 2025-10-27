Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64482D374F;
	Mon, 27 Oct 2025 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590713; cv=none; b=Jad1TjTY9qCziIripwrSbjuVZABZ2kNR/iokyYbNPjiarY6YMpW1jHkd8fWu7dc9QatdXAFmBImB+OF+jN12MlMbb00ORDXEoeB4nal/ZDjJqFYQ+YtCcCZhWRDPOcl4Nf5bZxweEuT2kjFaGM0HEHXMmLMuTweGQLu3SzlLQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590713; c=relaxed/simple;
	bh=gIuBkDWzwKLujqpzwSv/GWqHkX/VJA7Zm+jCczoi3vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQE02bmJQIOG+lpHezzkpqlyNH2gHFylU0no3VUJeHNtwFztBN1G9vKrPezG99cItxt5J96A+zWFRZ8i9rdcxxQz2SET7sc+0Tn6pOdGi7PQizXzb5mGCsyWyC5VFPK0Me3C8UzYLxOvEAYhZpH+adU0z/FTMV0OC3/Yd/Yih2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI6DDG1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI6DDG1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFE5C4CEF1;
	Mon, 27 Oct 2025 18:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590713;
	bh=gIuBkDWzwKLujqpzwSv/GWqHkX/VJA7Zm+jCczoi3vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI6DDG1hDJjh3hMKGIL9X5I64USC9/VWmBcEDL8FUEbsXe3xT/MuP5/hT6qYoDrxc
	 t5NKuWv4ez9TwwvhePSIoZT5qWk6tPbQaAxJb6nW7RsNLTzKoOQcKFmUvqYdEa8lU7
	 RyIXN5R7geVCVWhe2MLQQNJ74NliKRMxphgUrc6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.4 150/224] pwm: berlin: Fix wrong register in suspend/resume
Date: Mon, 27 Oct 2025 19:34:56 +0100
Message-ID: <20251027183512.979887499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 3a4b9d027e4061766f618292df91760ea64a1fcc upstream.

The 'enable' register should be BERLIN_PWM_EN rather than
BERLIN_PWM_ENABLE, otherwise, the driver accesses wrong address, there
will be cpu exception then kernel panic during suspend/resume.

Fixes: bbf0722c1c66 ("pwm: berlin: Add suspend/resume support")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20250819114224.31825-1-jszhang@kernel.org
Cc: stable@vger.kernel.org
[ukleinek: backport to 5.10]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-berlin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -249,7 +249,7 @@ static int berlin_pwm_suspend(struct dev
 		if (!channel)
 			continue;
 
-		channel->enable = berlin_pwm_readl(pwm, i, BERLIN_PWM_ENABLE);
+		channel->enable = berlin_pwm_readl(pwm, i, BERLIN_PWM_EN);
 		channel->ctrl = berlin_pwm_readl(pwm, i, BERLIN_PWM_CONTROL);
 		channel->duty = berlin_pwm_readl(pwm, i, BERLIN_PWM_DUTY);
 		channel->tcnt = berlin_pwm_readl(pwm, i, BERLIN_PWM_TCNT);
@@ -280,7 +280,7 @@ static int berlin_pwm_resume(struct devi
 		berlin_pwm_writel(pwm, i, channel->ctrl, BERLIN_PWM_CONTROL);
 		berlin_pwm_writel(pwm, i, channel->duty, BERLIN_PWM_DUTY);
 		berlin_pwm_writel(pwm, i, channel->tcnt, BERLIN_PWM_TCNT);
-		berlin_pwm_writel(pwm, i, channel->enable, BERLIN_PWM_ENABLE);
+		berlin_pwm_writel(pwm, i, channel->enable, BERLIN_PWM_EN);
 	}
 
 	return 0;


