Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BF2DA76C;
	Tue, 21 Jul 2026 20:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664935; cv=none; b=sayCEFPjtpChiOlg95N4LCB/Z4l9SIKUWJfBjpUJjFj5KyYxpeieKn2QHAyW+X41h5Kxg8MIsjfAlE9ppKgPdeZrdadzAj5KasEhwvQXUVrECbcpg9IiIcgYWtiR27OD60YQUAgLEkHVdKcyA6fb46JF5LMJX63JpI51uLH6+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664935; c=relaxed/simple;
	bh=Q+zZrV5WXEMfQ6q5CDqUuHWffgRk49Zw8Q3h2RBVjDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AO1W5R/1VG0XAYlfWNRKzSE4fE7FGdMstUuqBKcRygXfHj1eJUtySbPHpjHO0QKllHdC3xLjNfDR6Qi4JspQQ8k09uEu1SCO9NMwl5LFZ+xSk4TfMN9uWKB2tKUbgD1Qqhn/yPxmuTzu0+qGcEWtN1mRrNi7PRizhKr8Dn3bi/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4VHMLam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4VHMLam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689B71F000E9;
	Tue, 21 Jul 2026 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664933;
	bh=5kb1d4IkpTtau/YfLp66W2+2hb23uHiJ9aGp5lINyAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4VHMLamhfiumrtsk19on+wYESpGYow675/aOh1wiFpye1Wyp/TxqblrYuSq5ubY6
	 ochaMdkkQgUpxg2XC1/Ktj7CQ4uoi3aU4/0StcWXG+YoXvvMiC2y2sX/blB4hdWRhX
	 SFB0iT62uJ9Utqeb5ILQToxCBXOK9OH1AAf2mTD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0114/1266] ALSA: usb-audio: Roll back quirk control caches on write errors
Date: Tue, 21 Jul 2026 17:09:11 +0200
Message-ID: <20260721152444.353595302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 6380957fa24251856a532e48a46a4dc3d1ae26b6 upstream.

Several mixer quirk callbacks cache the requested
control value in kcontrol->private_value before
issuing a single vendor or class write.

Their paired get and resume paths consume that cache
directly, so a failed write currently leaves software
state changed even though the update did not succeed.
That can make later reads report a value the device
never accepted and can replay the stale cache on resume.

Restore the previous cached value on failure in
the Audigy2NX LED, Emu0204 channel switch,
Xonar U1 output switch, Native Instruments controls,
FTU effect program switch, and Sound Blaster E1 input source switch.

Fixes: 9cf3689bfe07 ("ALSA: usb-audio: Add audigy2nx resume support")
Fixes: 5f503ee9e270 ("ALSA: usb-audio: Add Emu0204 channel switch resume support")
Fixes: 2bfb14c3b8fb ("ALSA: usb-audio: Add Xonar U1 resume support")
Fixes: da6d276957ea ("ALSA: usb-audio: Add resume support for Native Instruments controls")
Fixes: 0b4e9cfcef05 ("ALSA: usb-audio: Add resume support for FTU controls")
Fixes: 388fdb8f882a ("ALSA: usb-audio: Support changing input on Sound Blaster E1")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260429-alsa-usb-quirks-cache-rollback-v1-1-01b35c688b80@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -335,6 +335,7 @@ static int snd_audigy2nx_led_put(struct
 	int index = kcontrol->private_value & 0xff;
 	unsigned int value = ucontrol->value.integer.value[0];
 	int old_value = kcontrol->private_value >> 8;
+	unsigned long old_pval = kcontrol->private_value;
 	int err;
 
 	if (value > 1)
@@ -343,7 +344,11 @@ static int snd_audigy2nx_led_put(struct
 		return 0;
 	kcontrol->private_value = (value << 8) | index;
 	err = snd_audigy2nx_led_update(mixer, value, index);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kcontrol->private_value = old_pval;
+		return err;
+	}
+	return 1;
 }
 
 static int snd_audigy2nx_led_resume(struct usb_mixer_elem_list *list)
@@ -493,6 +498,7 @@ static int snd_emu0204_ch_switch_put(str
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
 	struct usb_mixer_interface *mixer = list->mixer;
 	unsigned int value = ucontrol->value.enumerated.item[0];
+	unsigned long old_pval = kcontrol->private_value;
 	int err;
 
 	if (value > 1)
@@ -503,7 +509,11 @@ static int snd_emu0204_ch_switch_put(str
 
 	kcontrol->private_value = value;
 	err = snd_emu0204_ch_switch_update(mixer, value);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kcontrol->private_value = old_pval;
+		return err;
+	}
+	return 1;
 }
 
 static int snd_emu0204_ch_switch_resume(struct usb_mixer_elem_list *list)
@@ -814,7 +824,11 @@ static int snd_xonar_u1_switch_put(struc
 
 	kcontrol->private_value = new_status;
 	err = snd_xonar_u1_switch_update(list->mixer, new_status);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kcontrol->private_value = old_status;
+		return err;
+	}
+	return 1;
 }
 
 static int snd_xonar_u1_switch_resume(struct usb_mixer_elem_list *list)
@@ -1163,7 +1177,8 @@ static int snd_nativeinstruments_control
 					     struct snd_ctl_elem_value *ucontrol)
 {
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
-	u8 oldval = (kcontrol->private_value >> 24) & 0xff;
+	unsigned long old_pval = kcontrol->private_value;
+	u8 oldval = (old_pval >> 24) & 0xff;
 	u8 newval = ucontrol->value.integer.value[0];
 	int err;
 
@@ -1173,7 +1188,11 @@ static int snd_nativeinstruments_control
 	kcontrol->private_value &= ~(0xff << 24);
 	kcontrol->private_value |= (unsigned int)newval << 24;
 	err = snd_ni_update_cur_val(list);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kcontrol->private_value = old_pval;
+		return err;
+	}
+	return 1;
 }
 
 static const struct snd_kcontrol_new snd_nativeinstruments_ta6_mixers[] = {
@@ -1331,7 +1350,8 @@ static int snd_ftu_eff_switch_put(struct
 					struct snd_ctl_elem_value *ucontrol)
 {
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kctl);
-	unsigned int pval = list->kctl->private_value;
+	unsigned long old_pval = list->kctl->private_value;
+	unsigned int pval = old_pval;
 	int cur_val, err, new_val;
 
 	cur_val = pval >> 24;
@@ -1342,7 +1362,11 @@ static int snd_ftu_eff_switch_put(struct
 	kctl->private_value &= ~(0xff << 24);
 	kctl->private_value |= new_val << 24;
 	err = snd_ftu_eff_switch_update(list);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kctl->private_value = old_pval;
+		return err;
+	}
+	return 1;
 }
 
 static int snd_ftu_create_effect_switch(struct usb_mixer_interface *mixer,
@@ -2140,13 +2164,18 @@ static int snd_soundblaster_e1_switch_pu
 {
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
 	unsigned char value = !!ucontrol->value.integer.value[0];
+	unsigned long old_pval = kcontrol->private_value;
 	int err;
 
 	if (kcontrol->private_value == value)
 		return 0;
 	kcontrol->private_value = value;
 	err = snd_soundblaster_e1_switch_update(list->mixer, value);
-	return err < 0 ? err : 1;
+	if (err < 0) {
+		kcontrol->private_value = old_pval;
+		return err;
+	}
+	return 1;
 }
 
 static int snd_soundblaster_e1_switch_resume(struct usb_mixer_elem_list *list)


