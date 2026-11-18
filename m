Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047242;
	b=F9RLzhrct05RZBTqd+6isc0cS36xB8yBMqZqiLiq8B7Uwvjqse95Kia6Adb21SR3GwB5
	 yngbQofGRoSKJcZPMpxrd9s5IdXpQInM8n1jSI/thJbgY6sR9DL97zyXXJc323Zjb5/ui
	 vzBpVjB1Dc0nfVSEvzupEtbYSh8Gb3+iRtT10xPBF0eKahIUMzkg0ylg57hNyHy0u8Uuh
	 akoD2mVlFvmRqtvSEm2slmOK1sLa7HXzZyPGbjcPS41Guwgh+QxrozpYP6bq8D+RAD0LG
	 dbjMdFbXK034HdvfuLUXKgVQgWtikAjUYyE4v92aevMQDh/UKboibagD8Bi5V5kMK5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=epshHbx7ufSY595+g8HcBhW6HyMHSwCRSp8OqlELDZ0=;
	b=ojbHXB770tCYSUGrwjO4qpqjeIL4ftOAklGV9cWcFRhKL7smx3nOzykcOv9ksoEnMOID
	 F4qeRWW0BTU0ZiKooQseKPxog4PTlEELnt2TwLplJTid/FkDXKdxAXYoSZaAJk8/OCYI5
	 +MxNUD0fOMtdaFBXfMFaV1OsGytZIzLkRRuwwc4M4mODQ1FL2YxBfwq30N/wqStbzjl5m
	 4p6pHNIbV1ez7/QAT5Jq25wGZ9QfsNz3HgB1oqVTD2+ubYmbCRIYtbori9mH4TqYXntb5
	 95hf/UjqjtIHfLalSSQOS6+jsGkwrMnj29H5oRJY+AzupWJMOcSzRYxFIZrUokV/PDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3hkmmBN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3662606A31C;
	Thu, 19 Nov 2026 00:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H3hkmmBN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C306F1F000C4;
	Thu, 19 Nov 2026 00:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047242;
	bh=epshHbx7ufSY595+g8HcBhW6HyMHSwCRSp8OqlELDZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3hkmmBN6z9t5C9dNgYP36+B1VRHwqfm0HfZoFQErJ9TZ3iUW45UkzJyN/QBRyr75
	 lkDc4svX1T6RLvVBFVHRDugNJDJ8bcfFF4WTEtLhoRFhXkqPbvAvp/nodv6AuWdcbW
	 Ee4SjJgG7I1A3Xmwxk3+u+7mbjkxvhgfhX9CVZXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1569/2857] ALSA: aloop: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:43:23 +0100
Message-ID: <20261118150257.881310249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ebd9b6c91d4e345b7ded4b56567c46267a45d961 ]

Replace the manual mutex lock/unlock pairs with guard() for code
simplification.

Only code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829150026.6379-2-tiwai@suse.de

Limit the conversion to the four hardware rules needed by the
notify-mode playback fix. The access-control callbacks are absent,
and the remaining mutex conversions are unnecessary for that fix.
The scoped guards preserve the existing lock boundaries and release
the mutex if a hardware rule returns early.

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



