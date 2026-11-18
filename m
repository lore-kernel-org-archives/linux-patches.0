Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031444;
	b=A3HYCuNP5pv0AMTJzhf94k8yCxy3UHXOEkKVCf+Ci6gXpg4nVNVAUhxJxymC2bkEkLx+
	 mVEvgHhVDmIVm0rygcJwBOqi3i78ZAVjjh5kxA+Bfxq27sscSjxZ2ozm9Izf/xl3+flB+
	 8zeCe5egd6HWJy+JT9E4Uhlg+3gpIgPhp9uPGv741VTmsBH/2pkT7nsv4vGN8AGulEj7x
	 zEDgF5GhwMl5w+XpdejHVyNbO0OrfJ9jY+JAsIguZoiMnlc/wuWhUT375Ysdx3IkiXB30
	 q70FGA1jwjPVUet5JIViYK1rjoioYV1HekBHgAjatZ/jB6hGg0udj7grzMv/ER02ZAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kCwnjoA0fkhL/WmnLDNMBI3i+0mQ9l1w9xAbVXbv/EE=;
	b=qkXpORrCsJ9MRee5R2FSTfjEOpj5fT0cG5ckB1SSXzDKX+TSkA+G1UjjYw0ZqzASt+KT
	 JI2SRJXoWEc5i2+OmsnRaZFLo1EBveehBdLAU6fVIj201l5tKt7+LMj+pfbvA0LCUbJUu
	 Vw4wTVodlil9IvL+jByMGCb/RuJlbCvQ9FBOfCYSTQDhGnbmhZxKf9dOmT6ERuY946ztI
	 uBgLYLQ5zSooBBhwPiiynIVyanVxZk0TPpbvfsDBpoW9iRu98B/dNXxP5fJBP5e68Ljzt
	 Vbn7sh5X7bRRMVrkdMmRs577pcPl039YSxs9rhxaNBCmjgS/dx3dDs/3MF+86KNtNWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCyGcXL6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56F8606A32A;
	Wed, 18 Nov 2026 19:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCyGcXL6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2113F1F000C4;
	Wed, 18 Nov 2026 19:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031444;
	bh=kCwnjoA0fkhL/WmnLDNMBI3i+0mQ9l1w9xAbVXbv/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCyGcXL6V0kxgNJ5GBWTUo4gwcmhThZgZcyTlA1cpuIK+QocG2psxzjtW4mY80QYb
	 eLcwfAxgFypIBRuWuqHRjRgcXg24AqKXZxje7nFY1oe/AyQ5FGPinDI9KxToXH6ozr
	 zKbzbji5LX9xFjAlIIt6UTfNIS1ylcrqDdX2r5TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1018/1756] ALSA: usb: us16x08: Fix racy accesses of mixer elements
Date: Wed, 18 Nov 2026 15:52:25 +0100
Message-ID: <20261118150050.648906904@linuxfoundation.org>
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
index b74e198c365c3..60565d5f113e3 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -183,6 +183,7 @@ static int snd_us16x08_route_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = kcontrol->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* route has no bias */
 	ucontrol->value.enumerated.item[0] = elem->cache_val[index];
 
@@ -198,6 +199,7 @@ static int snd_us16x08_route_put(struct snd_kcontrol *kcontrol,
 	char buf[sizeof(route_msg)];
 	int val, val_org, err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/*  get the new value (no bias for routes) */
 	val = ucontrol->value.enumerated.item[0];
 
@@ -252,6 +254,7 @@ static int snd_us16x08_master_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = kcontrol->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -266,6 +269,7 @@ static int snd_us16x08_master_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0];
 
@@ -304,6 +308,7 @@ static int snd_us16x08_bus_put(struct snd_kcontrol *kcontrol,
 
 	val = ucontrol->value.integer.value[0];
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* prepare the message buffer from template */
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BYPASS:
@@ -340,6 +345,7 @@ static int snd_us16x08_bus_get(struct snd_kcontrol *kcontrol,
 {
 	struct usb_mixer_elem_info *elem = kcontrol->private_data;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BUSS_OUT:
 		ucontrol->value.integer.value[0] = elem->cache_val[0];
@@ -362,6 +368,7 @@ static int snd_us16x08_channel_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = kcontrol->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -376,6 +383,7 @@ static int snd_us16x08_channel_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -422,6 +430,7 @@ static int snd_us16x08_comp_get(struct snd_kcontrol *kcontrol,
 	int index = ucontrol->id.index;
 	int val_idx = COMP_STORE_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = store->val[val_idx][index];
 
 	return 0;
@@ -439,6 +448,7 @@ static int snd_us16x08_comp_put(struct snd_kcontrol *kcontrol,
 	int threshold, ratio, attack, release, gain, switch_on;
 	int err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -515,6 +525,7 @@ static int snd_us16x08_eqswitch_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_eq_store *store = elem->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* get low switch from cache is enough, cause all bands are together */
 	val = store->val[EQ_STORE_BAND_IDX(elem->head.id)]
 		[EQ_STORE_PARAM_IDX(elem->head.id)][index];
@@ -534,6 +545,7 @@ static int snd_us16x08_eqswitch_put(struct snd_kcontrol *kcontrol,
 	int val, err = 0;
 	int b_idx;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0] + SND_US16X08_KCBIAS(kcontrol);
 
@@ -576,6 +588,7 @@ static int snd_us16x08_eq_get(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = store->val[b_idx][p_idx][index];
 
 	ucontrol->value.integer.value[0] = val;
@@ -595,6 +608,7 @@ static int snd_us16x08_eq_put(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -723,6 +737,7 @@ static int snd_us16x08_meter_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	u8 meter_urb[64] = {0};
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (kcontrol->private_value) {
 	case 0: {
 		char tmp[sizeof(mix_init_msg1)];
@@ -782,6 +797,7 @@ static int snd_us16x08_meter_put(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	int val;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
-- 
2.53.0



