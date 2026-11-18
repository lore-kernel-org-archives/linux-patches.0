Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019233;
	b=NeBGvoIWM+G3kVbOnQMr9eZIyfLAIsP0qd3SXe1aZI2X0FrHKiLp43JwtlXUak6O1gc/
	 Un5K72BNXd6DGS6N/R5Q/FPU+iY7IQObnuMH1MKGet0yJBlGdkZGOKYkn0xst4GULAdQV
	 EoDP+eZhdzyQMrIcXirGJXP417shM5ljR5ebDLm2g+8cSmEesQJbQLpm9IypCIYgAtOjt
	 FJlU4g6TBBEH4NprCkir5RTV1zeiOHlB1UhTB0EBheGWMHKckqe9CbPWr354uTfZP7JSb
	 Th0bGY3qf2IlNSUAfYJiOdzVOjJpOoUm/UdPKlnP0fAinEIG8ISXox8QQcqVnoFh8Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=16mq2rBYiX7gnpwiEeo0tKTJjvL1G65MClWY8aS289o=;
	b=H4mLTVHUVjPxTzhxccxM8dFxRZxZwnxZIa4DfVS0wk1HOCEvQOBgfFMlRTWxhmOX1sjZ
	 e+8KxeEqNOFJcq4egB0cV9wikWseoAjnil4lUi9WakORD+6n0aCThigKgLH2Hz+RD0hLP
	 sdZ4i0NNWP+/FelUgNBgl+uMth58+qZKbnccuDoIV2zhzYkMIHsReqoRYFbGyaS6qj36Z
	 R3rrgZsaC9v4bJGyPPweA/O0Y42kFu0Fm4xnM+6Y4Bg/F0MNrCV48OXrS5Sq3OUSLuZ3I
	 J9uMU76rIUkm/c3TShA6Dsb0eFgjxZ2t11aN1flWwjd/vuaMFNIVRVhpdTSvrubOkBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcD6JmWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB26D606A334;
	Wed, 18 Nov 2026 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcD6JmWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0F21F000C4;
	Wed, 18 Nov 2026 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019232;
	bh=16mq2rBYiX7gnpwiEeo0tKTJjvL1G65MClWY8aS289o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcD6JmWvLmWnJN0UaR4hDobLe+Dpoc1GmLjF3Keqn9TzsHBwr19vfCCCUDROUMbHB
	 D6exTJZJsPpnxO8w2uU0olZwp3Q1/o4c14PuH8d3koZ4rDp6jp0FOjumzdz2337y+n
	 AJSPjD2CzyjmbDYRAKh61NOL3n1jtbrverNe/ync=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1521/2651] ALSA: usb-audio: Fix mixer bitmap cache over 32 channels
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118150342.748068391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f224bd39d2bf95ebe5f81e710293cabac3d22636 ]

USB-audio driver keeps the bitmap for the cached mixer channels, but
since a 32bit integer is used, it's currently broken for over 32
channels.  As the driver is supposed to support up to 64 channels,
this patch extends the bitmap properly -- now to be more flexible, use
the standard bitmap instead of the manual bit shifts.

Some checks for master channels are replaced in a slightly different
manner (checking the channel index 0) instead of the full cval->cached
check, so that it fits better in the bitmap helper usage.

Fixes: 16ee07bfa935 ("ALSA: usb-audio: Extend max number of channels to 64")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-8-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c          | 20 ++++++++++----------
 sound/usb/mixer.h          |  2 +-
 sound/usb/mixer_scarlett.c | 18 +++++++++---------
 sound/usb/mixer_us16x08.c  | 20 ++++++++++----------
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index f4bb2b780d72d..649dabd0ed8a4 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -445,7 +445,7 @@ int snd_usb_get_cur_mix_value(struct usb_mixer_elem_info *cval,
 {
 	int err;
 
-	if (cval->cached & BIT(channel)) {
+	if (test_bit(channel, cval->cached)) {
 		*value = cval->cache_val[index];
 		return 0;
 	}
@@ -462,7 +462,7 @@ int snd_usb_get_cur_mix_value(struct usb_mixer_elem_info *cval,
 				      cval->control, channel, err);
 		return err;
 	}
-	cval->cached |= BIT(channel);
+	set_bit(channel, cval->cached);
 	cval->cache_val[index] = *value;
 	return 0;
 }
@@ -551,7 +551,7 @@ int snd_usb_set_cur_mix_value(struct usb_mixer_elem_info *cval, int channel,
 					  value);
 	if (err < 0)
 		return err;
-	cval->cached |= BIT(channel);
+	set_bit(channel, cval->cached);
 	cval->cache_val[index] = value;
 	return 0;
 }
@@ -1417,7 +1417,7 @@ static int get_min_max_with_quirks(struct usb_mixer_elem_info *cval,
 		 * properly.
 		 */
 		if (ret)
-			cval->cached = 0;
+			bitmap_zero(cval->cached, MAX_CHANNELS + 1);
 
 		cval->initialized = 1;
 	}
@@ -3627,7 +3627,7 @@ void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 		info = mixer_elem_list_to_info(list);
 		/* invalidate cache, so the value is read from the device */
 		if (!info->get_cur_broken)
-			info->cached = 0;
+			bitmap_zero(info->cached, MAX_CHANNELS + 1);
 		snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
 			       &list->kctl->id);
 	}
@@ -3694,7 +3694,7 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 	__u8 channel = value & 0xff;
 	unsigned int count = 0;
 
-	if (channel >= MAX_CHANNELS) {
+	if (channel > MAX_CHANNELS) {
 		usb_audio_dbg(mixer->chip,
 			"%s(): bogus channel number %d\n",
 			__func__, channel);
@@ -3726,9 +3726,9 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 			/* invalidate cache, so the value is read from the device */
 			if (!info->get_cur_broken) {
 				if (channel)
-					info->cached &= ~BIT(channel);
+					clear_bit(channel, info->cached);
 				else /* master channel */
-					info->cached = 0;
+					bitmap_zero(info->cached, MAX_CHANNELS + 1);
 			}
 
 			snd_ctl_notify(mixer->chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
@@ -3964,7 +3964,7 @@ static int restore_mixer_value(struct usb_mixer_elem_list *list)
 		for (c = 0; c < MAX_CHANNELS; c++) {
 			if (!(cval->cmask & BIT(c)))
 				continue;
-			if (cval->cached & BIT(c + 1)) {
+			if (test_bit(c + 1, cval->cached)) {
 				err = snd_usb_set_cur_mix_value(cval, c + 1, idx,
 							cval->cache_val[idx]);
 				if (err < 0)
@@ -3974,7 +3974,7 @@ static int restore_mixer_value(struct usb_mixer_elem_list *list)
 		}
 	} else {
 		/* master */
-		if (cval->cached)
+		if (test_bit(0, cval->cached))
 			snd_usb_set_cur_mix_value(cval, 0, 0, *cval->cache_val);
 	}
 
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index cf45c39cbccc5..13e9ff5b49fef 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -92,7 +92,7 @@ struct usb_mixer_elem_info {
 	int min, max, res;
 	int max_exposed; /* control API exposes the value in 0..max_exposed */
 	int dBmin, dBmax;
-	int cached;
+	DECLARE_BITMAP(cached, MAX_CHANNELS + 1);
 	int cache_val[MAX_CHANNELS];
 	u8 initialized;
 	u8 min_mute;
diff --git a/sound/usb/mixer_scarlett.c b/sound/usb/mixer_scarlett.c
index 369968565c19d..6808730ef047e 100644
--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -292,7 +292,7 @@ static int forte_get_ctl_value(struct usb_mixer_elem_info *elem, int *value)
 	/* Device may not support reading input controls.
 	 * Return cached value or default to avoid blocking module load.
 	 */
-	if (elem->cached)
+	if (test_bit(0, elem->cached))
 		*value = elem->cache_val[0];
 	else
 		*value = 0;  /* Default: first option */
@@ -353,7 +353,7 @@ static int forte_input_gain_put(struct snd_kcontrol *kctl,
 		err = forte_set_ctl_value(elem, val);
 		if (err < 0)
 			return err;
-		elem->cached |= 1;
+		set_bit(0, elem->cached);
 		elem->cache_val[0] = val;
 		return 1;
 	}
@@ -364,7 +364,7 @@ static int forte_input_gain_resume(struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 
-	if (elem->cached)
+	if (test_bit(0, elem->cached))
 		forte_set_ctl_value(elem, *elem->cache_val);
 	return 0;
 }
@@ -405,7 +405,7 @@ static int forte_ctl_enum_put(struct snd_kcontrol *kctl,
 		err = forte_set_ctl_value(elem, val);
 		if (err < 0)
 			return err;
-		elem->cached |= 1;
+		set_bit(0, elem->cached);
 		elem->cache_val[0] = val;
 		return 1;
 	}
@@ -416,7 +416,7 @@ static int forte_ctl_enum_resume(struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 
-	if (elem->cached)
+	if (test_bit(0, elem->cached))
 		forte_set_ctl_value(elem, *elem->cache_val);
 	return 0;
 }
@@ -454,7 +454,7 @@ static int forte_ctl_switch_put(struct snd_kcontrol *kctl,
 		err = forte_set_ctl_value(elem, val);
 		if (err < 0)
 			return err;
-		elem->cached |= 1;
+		set_bit(0, elem->cached);
 		elem->cache_val[0] = val;
 		return 1;
 	}
@@ -465,7 +465,7 @@ static int forte_ctl_switch_resume(struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 
-	if (elem->cached)
+	if (test_bit(0, elem->cached))
 		forte_set_ctl_value(elem, *elem->cache_val);
 	return 0;
 }
@@ -532,7 +532,7 @@ static int scarlett_ctl_resume(struct usb_mixer_elem_list *list)
 	int i;
 
 	for (i = 0; i < elem->channels; i++)
-		if (elem->cached & (1 << i))
+		if (test_bit(i, elem->cached))
 			snd_usb_set_cur_mix_value(elem, i, i,
 						  elem->cache_val[i]);
 	return 0;
@@ -692,7 +692,7 @@ static int scarlett_ctl_enum_resume(struct usb_mixer_elem_list *list)
 {
 	struct usb_mixer_elem_info *elem = mixer_elem_list_to_info(list);
 
-	if (elem->cached)
+	if (test_bit(0, elem->cached))
 		snd_usb_set_cur_mix_value(elem, 0, 0, *elem->cache_val);
 	return 0;
 }
diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 14fb1ad764a7a..8e5ccd3282a78 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -236,7 +236,7 @@ static int snd_us16x08_route_put(struct snd_kcontrol *kcontrol,
 		return err;
 	}
 
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -295,7 +295,7 @@ static int snd_us16x08_master_put(struct snd_kcontrol *kcontrol,
 		return err;
 	}
 
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -336,7 +336,7 @@ static int snd_us16x08_bus_put(struct snd_kcontrol *kcontrol,
 		return err;
 	}
 
-	elem->cached |= 1;
+	set_bit(0, elem->cached);
 	elem->cache_val[0] = val;
 	return 1;
 }
@@ -404,7 +404,7 @@ static int snd_us16x08_channel_put(struct snd_kcontrol *kcontrol,
 		return err;
 	}
 
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -508,7 +508,7 @@ static int snd_us16x08_comp_put(struct snd_kcontrol *kcontrol,
 	}
 
 	store->val[val_idx][index] = val;
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -567,7 +567,7 @@ static int snd_us16x08_eqswitch_put(struct snd_kcontrol *kcontrol,
 		return err;
 	}
 
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -631,7 +631,7 @@ static int snd_us16x08_eq_put(struct snd_kcontrol *kcontrol,
 
 	store->val[b_idx][p_idx][index] = val;
 	/* store new value in EQ band cache */
-	elem->cached |= 1 << index;
+	set_bit(index, elem->cached);
 	elem->cache_val[index] = val;
 	return 1;
 }
@@ -1352,7 +1352,7 @@ int snd_us16x08_controls_create(struct usb_mixer_interface *mixer)
 		}
 		for (i = 0; i < 8; i++)
 			elem->cache_val[i] = i < 2 ? i : i + 2;
-		elem->cached = 0xff;
+		bitmap_set(elem->cached, 0, 8);
 
 		/* create compressor mixer elements */
 		comp_store = snd_us16x08_create_comp_store();
@@ -1374,7 +1374,7 @@ int snd_us16x08_controls_create(struct usb_mixer_interface *mixer)
 			if (err < 0)
 				return err;
 			elem->cache_val[0] = master_controls[i].default_val;
-			elem->cached = 1;
+			set_bit(0, elem->cached);
 		}
 
 		/* add channel controls */
@@ -1394,7 +1394,7 @@ int snd_us16x08_controls_create(struct usb_mixer_interface *mixer)
 				elem->cache_val[j] =
 					channel_controls[i].default_val;
 			}
-			elem->cached = 0xffff;
+			bitmap_set(elem->cached, 0, SND_US16X08_MAX_CHANNELS);
 		}
 
 		/* create eq store */
-- 
2.53.0



