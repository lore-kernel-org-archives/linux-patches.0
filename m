Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038652;
	b=YrYJMdGaU01G9HJqA7yxH93edowpouiI6iMGLjkyUqCvdPAU8KAzfEjwuU3bjbZGt/vn
	 z2BAkT87f97XCRK6xg9NUQCItn9FUPfqdn9trfGNB/Uyob5MvXCQwDc8BjnWbdq3MTl6G
	 8AEYO3F3OU0N6gD2OrdYmM2flPZuBQZIv6ELqtdXIGsi0H3HwCSNHQkBqIqA47JS0rA+P
	 K+bZnP2b9rjXmT5JciRo9oeKwVPA394MzIflGqpD6/Vf87CnBS04NQRCR+gbyQHADMo3p
	 +sRJRQrPK5W7heBV53/rJ1V2EGp9BiC1PDfKsRQxsQyPHAfo+FXXVS0bmZnmRboBmfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9sZcgqkxdLMVKmtQS/6OcLrSn2VM4AQREK/Xx13JE78=;
	b=0BcZvKFtKMWemVs6reUYPzvAXTZlNeiwp14h9f4E9UXZSAwKGPTWrU2c2RT14TY6zdOi
	 5ya/dCTB+zZLFURZ+7h8jAwOxY2QunvVmg0OKRQeEcBkW2vI52+YahbNXAPg4U3nhbw5D
	 Ox15SRmXwFNaQGlGKOLlgD1a0OyHEsLJ3iEPU95Y8HMcqjH+oo8Ro9Z2b6UYnwNoRZEZI
	 NFZ33xpjrlibVXP6fMXoNcUVBpbjn8nuTKkDPFpvf1rpqfmp9oN/UB3i584Jw7aZsgbNI
	 8eZvl3ys4vRtqpGUKU6zXQHdZMlIPfdWGIAYtQ7ooeIs3lpfyM29Cc9Gphk4s18NNKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mo0xuFYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD2B606A31C;
	Wed, 18 Nov 2026 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mo0xuFYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5AC1F000C4;
	Wed, 18 Nov 2026 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038652;
	bh=9sZcgqkxdLMVKmtQS/6OcLrSn2VM4AQREK/Xx13JE78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mo0xuFYWPa2u7AnhzyLh5+He7Rwp5judvXiWgXlmU01BBNY537m6kLjLVQC/PtSHO
	 GxnrPULXiS+IGQGrM6XeoLcUPBhdDN9CUSM83yP0fFyuzUUSqIyATjUdaA2Zp3bQIp
	 akdtX1wvcQIN3usr9A++vIcp90MxaGfe9Xkl/a9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1818/3318] ALSA: aloop: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150416.401353483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ebd9b6c91d4e345b7ded4b56567c46267a45d961 ]

Replace the manual mutex lock/unlock pairs with guard() for code
simplification.

Only code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829150026.6379-2-tiwai@suse.de

Keep the conversions in the format, rate, channels and period-bytes
constraint rules, which need automatic unlocking for the notify-mode
early returns. The other mutex conversions are unnecessary for that
change, and the access-mode control is absent.

Stable-dep-of: ded106036984 ("ALSA: aloop: Don't constrain playback params in notify mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 9c7671f034d54..cc0c59232d61f 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -952,10 +952,10 @@ static int rule_format(struct snd_pcm_hw_params *params,
 	struct snd_mask m;
 
 	snd_mask_none(&m);
-	mutex_lock(&dpcm->loopback->cable_lock);
-	m.bits[0] = (u_int32_t)cable->hw.formats;
-	m.bits[1] = (u_int32_t)(cable->hw.formats >> 32);
-	mutex_unlock(&dpcm->loopback->cable_lock);
+	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		m.bits[0] = (u_int32_t)cable->hw.formats;
+		m.bits[1] = (u_int32_t)(cable->hw.formats >> 32);
+	}
 	return snd_mask_refine(hw_param_mask(params, rule->var), &m);
 }
 
@@ -966,10 +966,10 @@ static int rule_rate(struct snd_pcm_hw_params *params,
 	struct loopback_cable *cable = dpcm->cable;
 	struct snd_interval t;
 
-	mutex_lock(&dpcm->loopback->cable_lock);
-	t.min = cable->hw.rate_min;
-	t.max = cable->hw.rate_max;
-	mutex_unlock(&dpcm->loopback->cable_lock);
+	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		t.min = cable->hw.rate_min;
+		t.max = cable->hw.rate_max;
+	}
         t.openmin = t.openmax = 0;
         t.integer = 0;
 	return snd_interval_refine(hw_param_interval(params, rule->var), &t);
@@ -982,10 +982,10 @@ static int rule_channels(struct snd_pcm_hw_params *params,
 	struct loopback_cable *cable = dpcm->cable;
 	struct snd_interval t;
 
-	mutex_lock(&dpcm->loopback->cable_lock);
-	t.min = cable->hw.channels_min;
-	t.max = cable->hw.channels_max;
-	mutex_unlock(&dpcm->loopback->cable_lock);
+	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		t.min = cable->hw.channels_min;
+		t.max = cable->hw.channels_max;
+	}
         t.openmin = t.openmax = 0;
         t.integer = 0;
 	return snd_interval_refine(hw_param_interval(params, rule->var), &t);
@@ -998,10 +998,10 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
 	struct loopback_cable *cable = dpcm->cable;
 	struct snd_interval t;
 
-	mutex_lock(&dpcm->loopback->cable_lock);
-	t.min = cable->hw.period_bytes_min;
-	t.max = cable->hw.period_bytes_max;
-	mutex_unlock(&dpcm->loopback->cable_lock);
+	scoped_guard(mutex, &dpcm->loopback->cable_lock) {
+		t.min = cable->hw.period_bytes_min;
+		t.max = cable->hw.period_bytes_max;
+	}
 	t.openmin = 0;
 	t.openmax = 0;
 	t.integer = 0;
-- 
2.53.0



