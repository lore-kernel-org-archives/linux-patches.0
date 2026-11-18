Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019304;
	b=fKjV3Jwz/Pk4xt9lXVoejUKyCsPZ16DiKiJyXLZLZOCyvjVQGkAjxS2qNsbPkX8wngNb
	 cPAYave7CjcopnpGiW9dxGsaaml6wDGNkpEjM+SUHtxp3LBt7pSWVipUFLvb2LIGX8a0a
	 6sFi1h+nRfHhY//InvvV0ZrxDOkWAfjzw1PY79yGlAoBks1khc8Gj3WI6ZJZsSYUC30xJ
	 ROtLLxl8vsPmsQwuabNCMyGygM8nG3u4L8aQ3apuMeLRn0FaCF7NDwIUX9ya6Y2srdmx2
	 JBUlMuVSOcc8hZqIbIOSrL9g6ImpNuSaDeLz8YnmFqr1+hZyXAqMsfTzDEIwplZ1KoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLcUEgFRNSjp6eVisxqG5q7a5ar6Kqlz9wpKhCdgZEc=;
	b=UE9VtcW/FYeIIGW94Bo16Vm+ruMXTOmomYMElzGRM3GfYwya2iJUFtAYoBsijnvQotOR
	 wH9Cmrk4YORoD/k/ag/HZEemxBWJbclMNfmi0k4BACV3y/kgP+4vQNkO1JdDE+u9WRNAp
	 18CDqFa4H1bpYg6IqUTqlAeYbqBq9gCSPN8TyehT37lppqUE1TWtKDslEvNnOqcsfQ0jF
	 4gNJSJsqWJD9oR30IIE48y+U6l+ycMF8JVkl99neKnz27lKlowt4xnM35WmUB3jZ80HRP
	 hlAgLgWR/kVw2S8rgD813PZMwO/C4ly1b9aJx6Dnhy+cW6/WpM5+EoDhpg+E0DUIkRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFnH391M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0BB60A2615;
	Wed, 18 Nov 2026 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFnH391M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0741F000C4;
	Wed, 18 Nov 2026 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019304;
	bh=zLcUEgFRNSjp6eVisxqG5q7a5ar6Kqlz9wpKhCdgZEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFnH391Mpu6cwnvhrjU6y62ioK9zOCETNoiyTALmw4TfgtLDOQO5sA5nFbSVRwBO2
	 +ZIgKfXtgMICHpdHsjofeskZ6KmUnEbNtniLeoOd1GkyDhjTRQXuiPyn9rSJKvaEZh
	 SaNz1iUnJb6arQjn9Q3SGl7LRwXjgg4mTnB4sKUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1548/2651] ALSA: usb: us16x08: Fix racy accesses of mixer elements
Date: Wed, 18 Nov 2026 15:46:28 +0100
Message-ID: <20261118150343.690509531@linuxfoundation.org>
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

[ Upstream commit 589fccbe1e9dd8aaf075cc073a7489c0c015ee49 ]

All get and put callbacks for us16x08 mixer have no proper protection,
hence the concurrent accesses to multiple elements may face data
races, resulting in unexpected values.

Put the new mixer->lock mutex for protecting the concurrent accesses.

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-8-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_us16x08.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 8e5ccd3282a78..b447c4f7a161d 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -189,6 +189,7 @@ static int snd_us16x08_route_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* route has no bias */
 	ucontrol->value.enumerated.item[0] = elem->cache_val[index];
 
@@ -204,6 +205,7 @@ static int snd_us16x08_route_put(struct snd_kcontrol *kcontrol,
 	char buf[sizeof(route_msg)];
 	int val, val_org, err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/*  get the new value (no bias for routes) */
 	val = ucontrol->value.enumerated.item[0];
 
@@ -258,6 +260,7 @@ static int snd_us16x08_master_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -272,6 +275,7 @@ static int snd_us16x08_master_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0];
 
@@ -310,6 +314,7 @@ static int snd_us16x08_bus_put(struct snd_kcontrol *kcontrol,
 
 	val = ucontrol->value.integer.value[0];
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* prepare the message buffer from template */
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BYPASS:
@@ -346,6 +351,7 @@ static int snd_us16x08_bus_get(struct snd_kcontrol *kcontrol,
 {
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BUSS_OUT:
 		ucontrol->value.integer.value[0] = elem->cache_val[0];
@@ -368,6 +374,7 @@ static int snd_us16x08_channel_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -382,6 +389,7 @@ static int snd_us16x08_channel_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -428,6 +436,7 @@ static int snd_us16x08_comp_get(struct snd_kcontrol *kcontrol,
 	int index = ucontrol->id.index;
 	int val_idx = COMP_STORE_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = store->val[val_idx][index];
 
 	return 0;
@@ -445,6 +454,7 @@ static int snd_us16x08_comp_put(struct snd_kcontrol *kcontrol,
 	int threshold, ratio, attack, release, gain, switch_on;
 	int err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -521,6 +531,7 @@ static int snd_us16x08_eqswitch_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_eq_store *store = elem->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* get low switch from cache is enough, cause all bands are together */
 	val = store->val[EQ_STORE_BAND_IDX(elem->head.id)]
 		[EQ_STORE_PARAM_IDX(elem->head.id)][index];
@@ -540,6 +551,7 @@ static int snd_us16x08_eqswitch_put(struct snd_kcontrol *kcontrol,
 	int val, err = 0;
 	int b_idx;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0] + SND_US16X08_KCBIAS(kcontrol);
 
@@ -582,6 +594,7 @@ static int snd_us16x08_eq_get(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = store->val[b_idx][p_idx][index];
 
 	ucontrol->value.integer.value[0] = val;
@@ -601,6 +614,7 @@ static int snd_us16x08_eq_put(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -729,6 +743,7 @@ static int snd_us16x08_meter_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	u8 meter_urb[64] = {0};
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (kcontrol->private_value) {
 	case 0: {
 		char tmp[sizeof(mix_init_msg1)];
@@ -788,6 +803,7 @@ static int snd_us16x08_meter_put(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	int val;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
-- 
2.53.0



