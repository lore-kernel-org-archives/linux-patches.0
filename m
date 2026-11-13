Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591607;
	b=VOYRo+jgbG42Y7CXn6JJ6hAPBebwNdI7TGYoa6uQ1/LGhNNNKZ1Au9QqUvQ1cXHlw7aB
	 jgFiCBXOGeze4Ow+f9Ahd2wQhWaNCPz811gTSJNmuAEex/x0EmYy6ee2S7CrxTIG0z8/Y
	 s9HOx3bwz3pHqArIfSwPQG0w4/tPTGzoF3DBUv6Q55TRQtTasPKawtHLq/tSrXD6sAggz
	 kZA/6tpVhlWvXK928CwYIMmdHfXLh0Fk+eGO7cEtWxiZ9YPAEFl5L7uYC9IVUqNHZtKqS
	 RgNnrTMr1MI+mLv/g9I1PTBFKP/ZvPOsO+51hiAoVeak4Y4Zlc1X7A/JnyfzMvEgRWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g32LCZG4iSWyIYCqECvEHfWB8CxblXK0Sj9BkbFRx5w=;
	b=gwOfB6JHb4umTe6TLiD3H/L0hmxJD8YK14uPsdaCkZU8fA0qE57jcC19VgtOmk2JHG1Q
	 AaLPol1mJd3QSfEa7nFvXSeXbfl7Ojt31uRnEOMnEpdXwpd7S0ZfieinSbJykhOeCCmVf
	 qE1bllWRKYxmCv3UuNzp96XLQGE6T/dhUE2l0adT/WpWhO3t+M4Y2jq42pTBkN7vNgXaN
	 gX5fR40+mFxzPFQSLcLmGnYtm0TxT6MtaZfY32hd+jpA8mnvlGdvutmT8RCZ3a0ZDkBTi
	 nFF8wVm4m2eII9NIxw2TOzy0T4G0Hn1lJqBxQlhgw7oO2HkqRLc3sINJwrQgf9oioEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gL9Je+0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074B606B452;
	Fri, 13 Nov 2026 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gL9Je+0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0A41F000C7;
	Fri, 13 Nov 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591606;
	bh=g32LCZG4iSWyIYCqECvEHfWB8CxblXK0Sj9BkbFRx5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gL9Je+0CQ+Tu4HTOkRB1nYcTzbawoijlhlWqAXUXWJA4OhByOKqWeBPzNmbwIhuD9
	 Zv06XYksakS3OsG7syHEGOmNQFhOjoclvNWtDi8MexeYten5NAB1ktna/toSBKpoBQ
	 m9poO/VzY5OxV4GBhgiy+fqAhZzXxvch8SjD1wVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 647/670] ALSA: aloop: Use guard() for mutex locks
Date: Fri, 13 Nov 2026 10:53:31 -0500
Message-ID: <20261113153833.727715676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ebd9b6c91d4e345b7ded4b56567c46267a45d961 ]

Replace the manual mutex lock/unlock pairs with guard() for code
simplification.

Only code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829150026.6379-2-tiwai@suse.de
Stable-dep-of: ded106036984 ("ALSA: aloop: Don't constrain playback params in notify mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 83 +++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 50 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 50b8e7b3d8179..24ab1a7fd773d 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -532,13 +532,12 @@ static int loopback_prepare(struct snd_pcm_substream *substream)
 	dpcm->pcm_salign = salign;
 	dpcm->pcm_period_size = frames_to_bytes(runtime, runtime->period_size);
 
-	mutex_lock(&dpcm->loopback->cable_lock);
+	guard(mutex)(&dpcm->loopback->cable_lock);
 	if (!(cable->valid & ~(1 << substream->stream)) ||
             (get_setup(dpcm)->notify &&
 	     substream->stream == SNDRV_PCM_STREAM_PLAYBACK))
 		params_change(substream);
 	cable->valid |= 1 << substream->stream;
-	mutex_unlock(&dpcm->loopback->cable_lock);
 
 	return 0;
 }
@@ -979,9 +978,8 @@ static int loopback_hw_free(struct snd_pcm_substream *substream)
 	struct loopback_pcm *dpcm = runtime->private_data;
 	struct loopback_cable *cable = dpcm->cable;
 
-	mutex_lock(&dpcm->loopback->cable_lock);
+	guard(mutex)(&dpcm->loopback->cable_lock);
 	cable->valid &= ~(1 << substream->stream);
-	mutex_unlock(&dpcm->loopback->cable_lock);
 	return 0;
 }
 
@@ -1001,10 +999,10 @@ static int rule_format(struct snd_pcm_hw_params *params,
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
 
@@ -1015,10 +1013,10 @@ static int rule_rate(struct snd_pcm_hw_params *params,
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
@@ -1031,10 +1029,10 @@ static int rule_channels(struct snd_pcm_hw_params *params,
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
@@ -1047,10 +1045,10 @@ static int rule_period_bytes(struct snd_pcm_hw_params *params,
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
@@ -1264,12 +1262,10 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	int err = 0;
 	int dev = get_cable_index(substream);
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	dpcm = kzalloc(sizeof(*dpcm), GFP_KERNEL);
-	if (!dpcm) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!dpcm)
+		return -ENOMEM;
 	dpcm->loopback = loopback;
 	dpcm->substream = substream;
 
@@ -1354,7 +1350,6 @@ static int loopback_open(struct snd_pcm_substream *substream)
 		free_cable(substream);
 		kfree(dpcm);
 	}
-	mutex_unlock(&loopback->cable_lock);
 	return err;
 }
 
@@ -1366,9 +1361,8 @@ static int loopback_close(struct snd_pcm_substream *substream)
 
 	if (dpcm->cable->ops->close_substream)
 		err = dpcm->cable->ops->close_substream(dpcm);
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	free_cable(substream);
-	mutex_unlock(&loopback->cable_lock);
 	return err;
 }
 
@@ -1419,11 +1413,10 @@ static int loopback_rate_shift_get(struct snd_kcontrol *kcontrol,
 {
 	struct loopback *loopback = snd_kcontrol_chip(kcontrol);
 	
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	ucontrol->value.integer.value[0] =
 		loopback->setup[kcontrol->id.subdevice]
 			       [kcontrol->id.device].rate_shift;
-	mutex_unlock(&loopback->cable_lock);
 	return 0;
 }
 
@@ -1439,14 +1432,13 @@ static int loopback_rate_shift_put(struct snd_kcontrol *kcontrol,
 		val = 80000;
 	if (val > 120000)
 		val = 120000;	
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	if (val != loopback->setup[kcontrol->id.subdevice]
 				  [kcontrol->id.device].rate_shift) {
 		loopback->setup[kcontrol->id.subdevice]
 			       [kcontrol->id.device].rate_shift = val;
 		change = 1;
 	}
-	mutex_unlock(&loopback->cable_lock);
 	return change;
 }
 
@@ -1455,11 +1447,10 @@ static int loopback_notify_get(struct snd_kcontrol *kcontrol,
 {
 	struct loopback *loopback = snd_kcontrol_chip(kcontrol);
 	
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	ucontrol->value.integer.value[0] =
 		loopback->setup[kcontrol->id.subdevice]
 			       [kcontrol->id.device].notify;
-	mutex_unlock(&loopback->cable_lock);
 	return 0;
 }
 
@@ -1471,14 +1462,13 @@ static int loopback_notify_put(struct snd_kcontrol *kcontrol,
 	int change = 0;
 
 	val = ucontrol->value.integer.value[0] ? 1 : 0;
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	if (val != loopback->setup[kcontrol->id.subdevice]
 				[kcontrol->id.device].notify) {
 		loopback->setup[kcontrol->id.subdevice]
 			[kcontrol->id.device].notify = val;
 		change = 1;
 	}
-	mutex_unlock(&loopback->cable_lock);
 	return change;
 }
 
@@ -1490,14 +1480,13 @@ static int loopback_active_get(struct snd_kcontrol *kcontrol,
 
 	unsigned int val = 0;
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	cable = loopback->cables[kcontrol->id.subdevice][kcontrol->id.device ^ 1];
 	if (cable != NULL) {
 		unsigned int running = cable->running ^ cable->pause;
 
 		val = (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) ? 1 : 0;
 	}
-	mutex_unlock(&loopback->cable_lock);
 	ucontrol->value.integer.value[0] = val;
 	return 0;
 }
@@ -1540,11 +1529,10 @@ static int loopback_rate_get(struct snd_kcontrol *kcontrol,
 {
 	struct loopback *loopback = snd_kcontrol_chip(kcontrol);
 	
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	ucontrol->value.integer.value[0] =
 		loopback->setup[kcontrol->id.subdevice]
 			       [kcontrol->id.device].rate;
-	mutex_unlock(&loopback->cable_lock);
 	return 0;
 }
 
@@ -1564,11 +1552,10 @@ static int loopback_channels_get(struct snd_kcontrol *kcontrol,
 {
 	struct loopback *loopback = snd_kcontrol_chip(kcontrol);
 	
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	ucontrol->value.integer.value[0] =
 		loopback->setup[kcontrol->id.subdevice]
 			       [kcontrol->id.device].channels;
-	mutex_unlock(&loopback->cable_lock);
 	return 0;
 }
 
@@ -1586,12 +1573,11 @@ static int loopback_access_get(struct snd_kcontrol *kcontrol,
 	struct loopback *loopback = snd_kcontrol_chip(kcontrol);
 	snd_pcm_access_t access;
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	access = loopback->setup[kcontrol->id.subdevice][kcontrol->id.device].access;
 
 	ucontrol->value.enumerated.item[0] = !is_access_interleaved(access);
 
-	mutex_unlock(&loopback->cable_lock);
 	return 0;
 }
 
@@ -1759,12 +1745,11 @@ static void print_cable_info(struct snd_info_entry *entry,
 	struct loopback *loopback = entry->private_data;
 	int sub, num;
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	num = entry->name[strlen(entry->name)-1];
 	num = num == '0' ? 0 : 1;
 	for (sub = 0; sub < MAX_PCM_SUBSTREAMS; sub++)
 		print_substream_info(buffer, loopback, sub, num);
-	mutex_unlock(&loopback->cable_lock);
 }
 
 static int loopback_cable_proc_new(struct loopback *loopback, int cidx)
@@ -1793,10 +1778,9 @@ static void print_timer_source_info(struct snd_info_entry *entry,
 {
 	struct loopback *loopback = entry->private_data;
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	snd_iprintf(buffer, "%s\n",
 		    loopback->timer_source ? loopback->timer_source : "");
-	mutex_unlock(&loopback->cable_lock);
 }
 
 static void change_timer_source_info(struct snd_info_entry *entry,
@@ -1805,10 +1789,9 @@ static void change_timer_source_info(struct snd_info_entry *entry,
 	struct loopback *loopback = entry->private_data;
 	char line[64];
 
-	mutex_lock(&loopback->cable_lock);
+	guard(mutex)(&loopback->cable_lock);
 	if (!snd_info_get_line(buffer, line, sizeof(line)))
 		loopback_set_timer_source(loopback, strim(line));
-	mutex_unlock(&loopback->cable_lock);
 }
 
 static int loopback_timer_source_proc_new(struct loopback *loopback)
-- 
2.53.0



