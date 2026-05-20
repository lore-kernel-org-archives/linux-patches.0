Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF0F367B8D;
	Wed, 20 May 2026 16:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295468; cv=none; b=OCh+7CS/vodp5roXmON1xrg26W/XNU0dPw4/ogrb/n0IkrY6puxp03bKTotw2uTRdoKEe8ZdWwODXXcaPFEgHiJBQ/0SOyGWXnKyG/Z3qgLKLVSZoKfapL3VfkJu/emqOKQHuyFod2CDuFnbiqQZeZ/JxPXWS+wpfGuzA2BLMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295468; c=relaxed/simple;
	bh=pzIhcKcSVSHpDIV7whqqppGL+ydabpQTQ0d/YFKVH8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfBomDNaANOCFg8cHM+D5IJ7M4oxscOTj3TtIDd2Ra/K4KMfpRIdvAr51wAHrrmUq/ChpqiPsob9hxRCQJPB4zeKEBXOqDNqko0HjX/1cbH9cK4pAJBnwbNSWDWtBS66UT6Z6y8zJb8SwU63r+n+XYpbP0gJbQ5h1/e9Ivh0l0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiwpofnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiwpofnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C681F000E9;
	Wed, 20 May 2026 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295466;
	bh=xNkKbOTGR6hIcaUYTpxY1/kPJJiEuAArXtq65/WVSZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiwpofnXvs1bMnnThcJ1QbXvzI2NEnt157JA3YsesFWMU3stfPrK1S+Kl5WcUmrID
	 gI50pxQSwXWzEpZFurCaQDovUUzk6tWoJdedogrUvbK22ijHyYwfLcv/zywEd1Sr4u
	 0DzeyHnHGc/zOQiraiM3i7AsMxWn4LvVH98cS7SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0390/1146] ALSA: hda: Notify IEC958 Default PCM switch state changes
Date: Wed, 20 May 2026 18:10:40 +0200
Message-ID: <20260520162157.025228385@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 6692ed9b4ced29aa819c95cc4ad9e2dc8720c081 ]

The "IEC958 Default PCM Playback Switch" control is backed directly by
mout->share_spdif. The share-switch callbacks currently access that state
without serialization, and spdif_share_sw_put() always returns 0, so
normal userspace writes never emit the standard ALSA control value
notification.

snd_hda_multi_out_analog_open() may also clear mout->share_spdif when the
analog PCM capabilities and the SPDIF capabilities no longer intersect.
That fallback is still needed to avoid creating an impossible hw
constraint set, but it changes the mixer backing value without notifying
subscribers.

Protect the share-switch callbacks with spdif_mutex like the other SPDIF
control handlers, return the actual change value from spdif_share_sw_put(),
and notify the cached control when the open path forcibly disables
shared SPDIF mode after dropping spdif_mutex.

This keeps the existing auto-disable behavior while making switch state
changes visible to userspace.

Fixes: 9a08160bdbe3 ("[ALSA] hda-codec - Add "IEC958 Default PCM" switch")
Fixes: 022b466fc353 ("ALSA: hda - Avoid invalid formats and rates with shared SPDIF")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260403-hda-spdif-share-notify-v3-1-4eb1356b0f17@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/codec.c     | 46 +++++++++++++++++++++++++++++-------
 sound/hda/common/hda_local.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 09b1329bb8f35..5123df32ad89f 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -2529,7 +2529,10 @@ EXPORT_SYMBOL_GPL(snd_hda_spdif_ctls_assign);
 static int spdif_share_sw_get(struct snd_kcontrol *kcontrol,
 			      struct snd_ctl_elem_value *ucontrol)
 {
-	struct hda_multi_out *mout = snd_kcontrol_chip(kcontrol);
+	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct hda_multi_out *mout = (void *)kcontrol->private_value;
+
+	guard(mutex)(&codec->spdif_mutex);
 	ucontrol->value.integer.value[0] = mout->share_spdif;
 	return 0;
 }
@@ -2537,9 +2540,15 @@ static int spdif_share_sw_get(struct snd_kcontrol *kcontrol,
 static int spdif_share_sw_put(struct snd_kcontrol *kcontrol,
 			      struct snd_ctl_elem_value *ucontrol)
 {
-	struct hda_multi_out *mout = snd_kcontrol_chip(kcontrol);
-	mout->share_spdif = !!ucontrol->value.integer.value[0];
-	return 0;
+	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct hda_multi_out *mout = (void *)kcontrol->private_value;
+	bool val = !!ucontrol->value.integer.value[0];
+	int change;
+
+	guard(mutex)(&codec->spdif_mutex);
+	change = mout->share_spdif != val;
+	mout->share_spdif = val;
+	return change;
 }
 
 static const struct snd_kcontrol_new spdif_share_sw = {
@@ -2550,6 +2559,14 @@ static const struct snd_kcontrol_new spdif_share_sw = {
 	.put = spdif_share_sw_put,
 };
 
+static void notify_spdif_share_sw(struct hda_codec *codec,
+				  struct hda_multi_out *mout)
+{
+	if (mout->share_spdif_kctl)
+		snd_ctl_notify_one(codec->card, SNDRV_CTL_EVENT_MASK_VALUE,
+				   mout->share_spdif_kctl, 0);
+}
+
 /**
  * snd_hda_create_spdif_share_sw - create Default PCM switch
  * @codec: the HDA codec
@@ -2559,15 +2576,24 @@ int snd_hda_create_spdif_share_sw(struct hda_codec *codec,
 				  struct hda_multi_out *mout)
 {
 	struct snd_kcontrol *kctl;
+	int err;
 
 	if (!mout->dig_out_nid)
 		return 0;
 
-	kctl = snd_ctl_new1(&spdif_share_sw, mout);
+	kctl = snd_ctl_new1(&spdif_share_sw, codec);
 	if (!kctl)
 		return -ENOMEM;
-	/* ATTENTION: here mout is passed as private_data, instead of codec */
-	return snd_hda_ctl_add(codec, mout->dig_out_nid, kctl);
+	/* snd_ctl_new1() stores @codec in private_data; stash @mout in
+	 * private_value for the share-switch callbacks and cache the
+	 * assigned control for forced-disable notifications.
+	 */
+	kctl->private_value = (unsigned long)mout;
+	err = snd_hda_ctl_add(codec, mout->dig_out_nid, kctl);
+	if (err < 0)
+		return err;
+	mout->share_spdif_kctl = kctl;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_hda_create_spdif_share_sw);
 
@@ -3701,6 +3727,8 @@ int snd_hda_multi_out_analog_open(struct hda_codec *codec,
 				  struct hda_pcm_stream *hinfo)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	bool notify_share_sw = false;
+
 	runtime->hw.channels_max = mout->max_channels;
 	if (mout->dig_out_nid) {
 		if (!mout->analog_rates) {
@@ -3729,10 +3757,12 @@ int snd_hda_multi_out_analog_open(struct hda_codec *codec,
 					hinfo->maxbps = mout->spdif_maxbps;
 			} else {
 				mout->share_spdif = 0;
-				/* FIXME: need notify? */
+				notify_share_sw = true;
 			}
 		}
 	}
+	if (notify_share_sw)
+		notify_spdif_share_sw(codec, mout);
 	return snd_pcm_hw_constraint_step(substream->runtime, 0,
 					  SNDRV_PCM_HW_PARAM_CHANNELS, 2);
 }
diff --git a/sound/hda/common/hda_local.h b/sound/hda/common/hda_local.h
index ab423f1cef549..98b2c4acebc27 100644
--- a/sound/hda/common/hda_local.h
+++ b/sound/hda/common/hda_local.h
@@ -221,6 +221,7 @@ struct hda_multi_out {
 	unsigned int spdif_rates;
 	unsigned int spdif_maxbps;
 	u64 spdif_formats;
+	struct snd_kcontrol *share_spdif_kctl; /* cached shared SPDIF switch */
 };
 
 int snd_hda_create_spdif_share_sw(struct hda_codec *codec,
-- 
2.53.0



