Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31334E1AD;
	Tue, 23 Jan 2024 00:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971397; cv=none; b=XxVFGlRQ7JxXFpd+s7G4RgSqyZc7yWfwlPVbVudwUtw0KlIn+y9yvBvKpr9TljV6bn2TReDNqGGGcoU+EP5MDzeeCHALbENCIUbi737M2TsQ9x1Gh1pIEVdhit0c/VjgCdDPGbkKLYpCPxE8bl4YzeQ8AXKQYVZsIt4A6dSVJRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971397; c=relaxed/simple;
	bh=d3WQrNnaBiTeK51nhREj9Q+0Rh2ylG22DCQeGbTDw1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPy0g4jdooUFLYdEEMZ4PS8+Fk31EPtZcWWFaiHVii40qULU+BMsHwjeQ9qwJ6krdjBs5InoyflqpK9EIYqRlQ1EYBhBuca/uoeu2RpiGDEPfKnP1aKaO8ukX/AZTJzi+6Vjs0BWd++qEO03Cbsk97mdDatwtBaesWZHXiMcLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9was1Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9was1Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC3BC433C7;
	Tue, 23 Jan 2024 00:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971396;
	bh=d3WQrNnaBiTeK51nhREj9Q+0Rh2ylG22DCQeGbTDw1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9was1OmMrsdkI+rF5FfDoBNpHX6pYdHfs0MR03BxaqsPzV1qPtUpbK3zcRspFXC0
	 +BxhnJmDlKIvCBgbbtuc0quC1gxdtaxhpqN9QmsInnL+/pHeyEb+j9ij+bViVJM/v2
	 RUiy9w9MZOAXI+TjyQHWYJSBMJEkMiB4PByPySng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/417] ALSA: scarlett2: Add missing error checks to *_ctl_get()
Date: Mon, 22 Jan 2024 15:56:43 -0800
Message-ID: <20240122235800.031064785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 50603a67daef161c78c814580d57f7f0be57167e ]

The *_ctl_get() functions which call scarlett2_update_*() were not
checking the return value. Fix to check the return value and pass to
the caller.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Link: https://lore.kernel.org/r/32a5fdc83b05fa74e0fcdd672fbf71d75c5f0a6d.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 182 +++++++++++++++++++++++---------
 1 file changed, 130 insertions(+), 52 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index f8a2ba479b7c..eedac43eee7d 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1798,14 +1798,20 @@ static int scarlett2_sync_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->sync_updated)
-		scarlett2_update_sync(mixer);
+
+	if (private->sync_updated) {
+		err = scarlett2_update_sync(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->sync;
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static const struct snd_kcontrol_new scarlett2_sync_ctl = {
@@ -1888,14 +1894,20 @@ static int scarlett2_master_volume_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->vol_updated)
-		scarlett2_update_volumes(mixer);
-	mutex_unlock(&private->data_mutex);
 
+	if (private->vol_updated) {
+		err = scarlett2_update_volumes(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] = private->master_vol;
-	return 0;
+
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int line_out_remap(struct scarlett2_data *private, int index)
@@ -1921,14 +1933,20 @@ static int scarlett2_volume_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
 	int index = line_out_remap(private, elem->control);
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->vol_updated)
-		scarlett2_update_volumes(mixer);
-	mutex_unlock(&private->data_mutex);
 
+	if (private->vol_updated) {
+		err = scarlett2_update_volumes(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] = private->vol[index];
-	return 0;
+
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_volume_ctl_put(struct snd_kcontrol *kctl,
@@ -1995,14 +2013,20 @@ static int scarlett2_mute_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
 	int index = line_out_remap(private, elem->control);
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->vol_updated)
-		scarlett2_update_volumes(mixer);
-	mutex_unlock(&private->data_mutex);
 
+	if (private->vol_updated) {
+		err = scarlett2_update_volumes(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] = private->mute_switch[index];
-	return 0;
+
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_mute_ctl_put(struct snd_kcontrol *kctl,
@@ -2248,14 +2272,20 @@ static int scarlett2_level_enum_ctl_get(struct snd_kcontrol *kctl,
 	const struct scarlett2_device_info *info = private->info;
 
 	int index = elem->control + info->level_input_first;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->input_other_updated)
-		scarlett2_update_input_other(mixer);
+
+	if (private->input_other_updated) {
+		err = scarlett2_update_input_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->level_switch[index];
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_level_enum_ctl_put(struct snd_kcontrol *kctl,
@@ -2306,15 +2336,21 @@ static int scarlett2_pad_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->input_other_updated)
-		scarlett2_update_input_other(mixer);
+
+	if (private->input_other_updated) {
+		err = scarlett2_update_input_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] =
 		private->pad_switch[elem->control];
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_pad_ctl_put(struct snd_kcontrol *kctl,
@@ -2364,14 +2400,20 @@ static int scarlett2_air_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->input_other_updated)
-		scarlett2_update_input_other(mixer);
+
+	if (private->input_other_updated) {
+		err = scarlett2_update_input_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] = private->air_switch[elem->control];
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_air_ctl_put(struct snd_kcontrol *kctl,
@@ -2421,15 +2463,21 @@ static int scarlett2_phantom_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->input_other_updated)
-		scarlett2_update_input_other(mixer);
+
+	if (private->input_other_updated) {
+		err = scarlett2_update_input_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] =
 		private->phantom_switch[elem->control];
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_phantom_ctl_put(struct snd_kcontrol *kctl,
@@ -2601,14 +2649,20 @@ static int scarlett2_direct_monitor_ctl_get(
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = elem->head.mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->monitor_other_updated)
-		scarlett2_update_monitor_other(mixer);
+
+	if (private->monitor_other_updated) {
+		err = scarlett2_update_monitor_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->direct_monitor_switch;
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_direct_monitor_ctl_put(
@@ -2708,14 +2762,20 @@ static int scarlett2_speaker_switch_enum_ctl_get(
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->monitor_other_updated)
-		scarlett2_update_monitor_other(mixer);
+
+	if (private->monitor_other_updated) {
+		err = scarlett2_update_monitor_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->speaker_switching_switch;
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 /* when speaker switching gets enabled, switch the main/alt speakers
@@ -2863,14 +2923,20 @@ static int scarlett2_talkback_enum_ctl_get(
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->monitor_other_updated)
-		scarlett2_update_monitor_other(mixer);
+
+	if (private->monitor_other_updated) {
+		err = scarlett2_update_monitor_other(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->talkback_switch;
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_talkback_enum_ctl_put(
@@ -3018,14 +3084,20 @@ static int scarlett2_dim_mute_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->vol_updated)
-		scarlett2_update_volumes(mixer);
-	mutex_unlock(&private->data_mutex);
 
+	if (private->vol_updated) {
+		err = scarlett2_update_volumes(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.integer.value[0] = private->dim_mute[elem->control];
-	return 0;
+
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_dim_mute_ctl_put(struct snd_kcontrol *kctl,
@@ -3396,14 +3468,20 @@ static int scarlett2_mux_src_enum_ctl_get(struct snd_kcontrol *kctl,
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
 	int index = line_out_remap(private, elem->control);
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
-	if (private->mux_updated)
-		scarlett2_usb_get_mux(mixer);
+
+	if (private->mux_updated) {
+		err = scarlett2_usb_get_mux(mixer);
+		if (err < 0)
+			goto unlock;
+	}
 	ucontrol->value.enumerated.item[0] = private->mux[index];
-	mutex_unlock(&private->data_mutex);
 
-	return 0;
+unlock:
+	mutex_unlock(&private->data_mutex);
+	return err;
 }
 
 static int scarlett2_mux_src_enum_ctl_put(struct snd_kcontrol *kctl,
-- 
2.43.0



