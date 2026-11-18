Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026016;
	b=zYM9GqEN+CpTlP5FZBpvyamAoKldED8dFIbmJxQdxsBaipxvMhRU3CvjwCiCHihq0Q+U
	 BZGehUl0fSKXzXFaOL/NAdmzqusdXeNQnrndyJHvQc9omg+KR/vMVx63hK5XdEeaxZfJz
	 3GlQ/BDaSuTlgKuSarnFVYsuMbduAkx1+2Mr2e3CN1BeEqrR2Gw8If6xPkz+VVDzx/hTW
	 MvXDWj55MwiXvkF1Ki3C2Jf7v42PDnPQuOhHlo0djfv+zSlvEQav4SpIYo26eJJQjH0Sw
	 9Z3VPKX3Lib59dNQWVlWhbP01SnpsvnjBYl8cqtUUGekxtDtJHkh0os4avQ35EmdWHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vim/7HzDjDN5BFoiaBdY4SoB3pr2nuqG3sGKyv4Oo0Y=;
	b=hdMKdv4fYCzkqRiYHrRFhn2WBV1N11l9wssPWLGV7/7YJS1ltNzSr8I/md8q64v2aKTI
	 FCLjJAaQKuC3dQibctjTxsCaNTC/X4lD6FEDjCYPAXKMzMAmozD+nULWCgIa4G68Dazxy
	 g6g8RPgLsMJXdYWJANBN7SkP9CamLDJn9OmvV40XZYHp7XdUeLmjpQqJln6KRVTMkdCiJ
	 JwIj90wGxfopOPLO9Lgkpv9Xctm38ypNZwzdhcv3FJoNH7dvAHDNxmc7bN5k265XFTtmH
	 wNggNwleCnAkUtxVamjcIJnC0Ggeu+DJ40IhNsNt3jV6mpKXK9+NioNiwaE7aHyBKXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/0xERmK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AEF606A320;
	Wed, 18 Nov 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/0xERmK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414521F000C4;
	Wed, 18 Nov 2026 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026015;
	bh=vim/7HzDjDN5BFoiaBdY4SoB3pr2nuqG3sGKyv4Oo0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/0xERmKeRkyFf9h7C4W9LrxU4Wsoa9T9I9Vv9b49pvaPLrnCfuugvOaXGkD4lQQu
	 5G3aMqreaRt8R4hwW76zK/d7Ul5aCJp00GcVogVMGh4JfcvEK8hyur6MIVcE2m5Whv
	 Z97r/zYCrA3pCpynOnQsjY7y/ncKj47vHanjB74s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1282/2151] ALSA: usb-audio: Fix data race at mixer_ctl_feature_info()
Date: Wed, 18 Nov 2026 15:50:17 +0100
Message-ID: <20261118150208.830753281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 800719383ee83..0f6ced6bb8cec 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1389,6 +1389,7 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 {
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 
+	guard(mutex)(&cval->head.mixer->lock);
 	if (cval->val_type == USB_MIXER_BOOLEAN ||
 	    cval->val_type == USB_MIXER_INV_BOOLEAN)
 		uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
@@ -1422,6 +1423,7 @@ static int mixer_ctl_feature_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int c, cnt, val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	ucontrol->value.integer.value[0] = cval->min;
 	if (cval->cmask) {
 		cnt = 0;
@@ -1452,10 +1454,12 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -1503,6 +1507,7 @@ static int mixer_ctl_master_bool_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = snd_usb_get_cur_mix_value(cval, 0, 0, &val);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2384,6 +2389,7 @@ static int mixer_ctl_procunit_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int err, val;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.integer.value[0] = cval->min;
@@ -2401,6 +2407,7 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2750,6 +2757,7 @@ static int mixer_ctl_selector_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.enumerated.item[0] = 0;
@@ -2767,6 +2775,7 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -3039,6 +3048,7 @@ static void snd_usb_mixer_free(struct usb_mixer_interface *mixer)
 	}
 	usb_free_urb(mixer->rc_urb);
 	kfree(mixer->rc_setup_packet);
+	mutex_destroy(&mixer->lock);
 	kfree(mixer);
 }
 
@@ -3681,6 +3691,8 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif)
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



