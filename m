Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031442;
	b=G3cUxpIMh5HLINkB8JahXAX+TxEFWuNkg2uTpCsdR3ax2FDVtI0550YkH5hTTEU79rgJ
	 AG/6B4Th2lT1Ry/vVFYkGkHcmRGfOoozFp4CPoKg6FBpgLNl5CO3yRFtSwHZ6xkdbWVq9
	 MqXTQfWt7JnBRW9fTt9Mj5dJu91/RMKZIUftXkSgmG9ka35B0bHJtxhaHmsM6unOdnBUI
	 09WJCzSkNvxJk9RnIIlAd+S6b/RzlnWg+hS3nsDV5jWpCepSpsXamDoWVEPCBwqVvmkSc
	 cuUKwqw9SF2iZNcmhQPRTKQS8dvDlODYYmuN3Gub8D2JgkHFUEg66wMSxkRVGqeDOfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSglaSUZT+1m9sSOf+gNe/fiV8p9EFudgflLd7yrRwI=;
	b=IcEX5/XKYOn9GiN0kt/WRMRNVPVQC/tBwCovAaLpRlmrtmlM4ShHU3idHiSYz/2PQxLV
	 LNhvaFMac8nFGbUbjEz0Dq/NLglFDRgTDfNHBR873TWsCRUw+FAen4zBn+goa+BeJD7RT
	 8gnBBBg6snrSxlMdv6kvTtxFoQI+RiqKIvqfV9RREgN3OfrtHqhX8kexNQ+2RUZw/+T5j
	 qKQHhpQp3QffxvriXeKetrcriWc4oxILnm7XepLewAjuMjY/uKfbgHaeXEAT38llYi+zv
	 Z6eaaCysHTjbHxEn6GVNJbZW2xriGuIw2zSWgejUU8FxXF9DtmV38alqx7KbLP+ISXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8xrDnPD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336CE606A320;
	Wed, 18 Nov 2026 19:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8xrDnPD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483141F000C4;
	Wed, 18 Nov 2026 19:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031441;
	bh=QSglaSUZT+1m9sSOf+gNe/fiV8p9EFudgflLd7yrRwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8xrDnPDObtgBxdtMaI8hb31l6i6KZLtX1UGgJKSOT5ciMnCc9VLEfI0vS8AhQQt1
	 xH0pZwBncxEwdAKM3DmWuxZzr9y45FhMnx6nEFNtNNK2ll48bKUu251ob3TQ2OdGXf
	 6Ve/IksSo0+qsvFQc6Vg7clKVEFeSGiqs1RtNntI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1017/1756] ALSA: usb-audio: Fix data race at mixer_ctl_feature_info()
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150050.612660286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit f701f6738de2d11e206a74d2a81465051dbf1ba3 ]

The info callback for USB-audio mixer controls for feature unit has a
dynamic initialization of the contents with the check of
cval->initialized flag.  But, since the info callback may be
concurrently called, this may lead to a data race, giving back an
inconsistent state.  Similarly, get and put callbacks may have
concurrent accesses and can get bogus states.

For avoiding the data race, introduce a mutex locking for the
controls and protect against concurrent info callback calls.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-6-tiwai@suse.de
Stable-dep-of: 589fccbe1e9d ("ALSA: usb: us16x08: Fix racy accesses of mixer elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 14 +++++++++++++-
 sound/usb/mixer.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 08f2cf9f9b7cf..07c373822e2ee 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1391,6 +1391,7 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 {
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 
+	guard(mutex)(&cval->head.mixer->lock);
 	if (cval->val_type == USB_MIXER_BOOLEAN ||
 	    cval->val_type == USB_MIXER_INV_BOOLEAN)
 		uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
@@ -1424,6 +1425,7 @@ static int mixer_ctl_feature_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int c, cnt, val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	ucontrol->value.integer.value[0] = cval->min;
 	if (cval->cmask) {
 		cnt = 0;
@@ -1454,10 +1456,12 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
-	int max_val = get_max_exposed(cval);
+	int max_val;
 	int c, cnt, val, oval, err;
 	int changed = 0;
 
+	guard(mutex)(&cval->head.mixer->lock);
+	max_val = get_max_exposed(cval);
 	if (cval->cmask) {
 		cnt = 0;
 		for (c = 0; c < MAX_CHANNELS; c++) {
@@ -1505,6 +1509,7 @@ static int mixer_ctl_master_bool_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = snd_usb_get_cur_mix_value(cval, 0, 0, &val);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2385,6 +2390,7 @@ static int mixer_ctl_procunit_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int err, val;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.integer.value[0] = cval->min;
@@ -2402,6 +2408,7 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2751,6 +2758,7 @@ static int mixer_ctl_selector_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.enumerated.item[0] = 0;
@@ -2768,6 +2776,7 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -3040,6 +3049,7 @@ static void snd_usb_mixer_free(struct usb_mixer_interface *mixer)
 	}
 	usb_free_urb(mixer->rc_urb);
 	kfree(mixer->rc_setup_packet);
+	mutex_destroy(&mixer->lock);
 	kfree(mixer);
 }
 
@@ -3682,6 +3692,8 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif)
 		return -ENOMEM;
 	}
 
+	mutex_init(&mixer->lock);
+
 	mixer->hostif = &usb_ifnum_to_if(chip->dev, ctrlif)->altsetting[0];
 	switch (get_iface_desc(mixer->hostif)->bInterfaceProtocol) {
 	case UAC_VERSION_1:
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index efaccdd923385..08d472c5ef7b5 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -18,6 +18,7 @@ struct usb_mixer_interface {
 	struct usb_host_interface *hostif;
 	struct list_head list;
 	unsigned int ignore_ctl_error;
+	struct mutex lock; /* lock for feature unit callbacks */
 	/* UAC2 status interrupt endpoint; owned by mixer.c */
 	struct urb *urb;
 	/* array[MAX_ID_ELEMS], indexed by unit id */
-- 
2.53.0



