Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019301;
	b=rZSa9JxNzSRUUsWUd7db0t7g6wYy6gTH0m3aByOl6N5k/QJi/b/V5Gv8Gdf7DS0B3CxM
	 YjQhx8MrSyIuLVtsNb9mCKbYMajGtnXxKbxcVj2KKWOg1fItqODJvFK6aqQh/KYGx/oDa
	 psRvQGr6OdWb0/bmf0eFddRYYNY9SFiVO+rTPsumKUNnh8k6KTgStYGZRLWHFoQJsy5eh
	 FnQmUPEctxFp26q8PrNSIHw1Lkz2CQpj/Tk6CjqvqIOaXKussuW307BDKOYqGoRabx9uN
	 JnF21tSzkX/MNyD2Ne4INUU0QpwXEL0hriCLGTaXS8WA2rpgTNgFwwHjI+oRI/R1ZMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A3C+qItKSCjkAACJAUTSuI1faVc+2S1VOB3txMUgJpE=;
	b=4xg3Upan2vw5TvCo4eaAHOA3r5IGHHuEmYwlCDiy+YNejDVMo1LbchMFCIVU3dEJx7ke
	 CSdxR4a75ilDQwLK+ocXfs71H9h/rk1zZvCPe+x3yy2hpbNuX9fwHI1l8pnaPVzUkQaD9
	 dU/uT0ya7Gfc5dZqlB1PieRjbiGGhJZBlyPh92cVhKKt69JcY8mstGukUcurgp4Xd9pwW
	 qZeHjmcnNmmLiOLobtsz3GvRpiYce1xWHgMFJpk9uIHfUzyUYqgfRsVlY7Ni5gsfrGHuz
	 Ccuh2PKQEvtpUEnA8NLLNOpPucnX86SrC4ZGKhFIJ/YZkp66E/8eym83ThIzh1E/P/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uiIrGnSn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1760A261B;
	Wed, 18 Nov 2026 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uiIrGnSn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB101F000C4;
	Wed, 18 Nov 2026 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019301;
	bh=A3C+qItKSCjkAACJAUTSuI1faVc+2S1VOB3txMUgJpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiIrGnSnWKXJDyIG9gVZwuTQu5B2diqpxP/UcmaliJLxS3h6ZDsQzwFe9BBMNeV5x
	 OSNzrj6a8up9fY2DAtiO2lYvpwyko0vsfinc6jAFx8mKsTNFP9idki/N7uBTWllOwV
	 Wsken3Rh8C/QHpIUM3N0wW31nqPbn2A/vilwtmTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1547/2651] ALSA: usb-audio: Fix data race at mixer_ctl_feature_info()
Date: Wed, 18 Nov 2026 15:46:27 +0100
Message-ID: <20261118150343.652614275@linuxfoundation.org>
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
index 649dabd0ed8a4..8460ad8ab01a9 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1499,6 +1499,7 @@ static int mixer_ctl_feature_info(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int ret;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	if (cval->val_type == USB_MIXER_BOOLEAN ||
 	    cval->val_type == USB_MIXER_INV_BOOLEAN)
 		uinfo->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
@@ -1533,6 +1534,7 @@ static int mixer_ctl_feature_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int c, cnt, val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	ucontrol->value.integer.value[0] = cval->min;
 	if (cval->cmask) {
 		cnt = 0;
@@ -1563,10 +1565,12 @@ static int mixer_ctl_feature_put(struct snd_kcontrol *kcontrol,
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
@@ -1614,6 +1618,7 @@ static int mixer_ctl_master_bool_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = snd_usb_get_cur_mix_value(cval, 0, 0, &val);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2560,6 +2565,7 @@ static int mixer_ctl_procunit_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int err, val;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.integer.value[0] = cval->min;
@@ -2577,6 +2583,7 @@ static int mixer_ctl_procunit_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -2928,6 +2935,7 @@ static int mixer_ctl_selector_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &val);
 	if (err < 0) {
 		ucontrol->value.enumerated.item[0] = 0;
@@ -2945,6 +2953,7 @@ static int mixer_ctl_selector_put(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *cval = snd_kcontrol_chip(kcontrol);
 	int val, oval, err;
 
+	guard(mutex)(&cval->head.mixer->lock);
 	err = get_cur_ctl_value(cval, cval->control << 8, &oval);
 	if (err < 0)
 		return filter_error(cval, err);
@@ -3217,6 +3226,7 @@ static void snd_usb_mixer_free(struct usb_mixer_interface *mixer)
 	}
 	usb_free_urb(mixer->rc_urb);
 	kfree(mixer->rc_setup_packet);
+	mutex_destroy(&mixer->lock);
 	kfree(mixer);
 }
 
@@ -3861,6 +3871,8 @@ int snd_usb_create_mixer(struct snd_usb_audio *chip, int ctrlif)
 		return -ENOMEM;
 	}
 
+	mutex_init(&mixer->lock);
+
 	mixer->hostif = &usb_ifnum_to_if(chip->dev, ctrlif)->altsetting[0];
 	switch (get_iface_desc(mixer->hostif)->bInterfaceProtocol) {
 	case UAC_VERSION_1:
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 13e9ff5b49fef..0d0a8b343756a 100644
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



