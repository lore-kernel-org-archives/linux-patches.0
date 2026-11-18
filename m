Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026019;
	b=M6UFYhw3wO73XqXHQvRLMYzw6DzqrgYUrtNijsCvHqeZii5DImVJIXapUEk4aAKLyIa2
	 Di6aQwU1a3AvVt0bkyGUaV4nII1DSfdbtQrxIwt1/Rkj2vAUQOpe7v1h4ayRrz/xf6WHV
	 p46pJX/fVrHX6e7PIJ7icJOH8Fj+KbAAQLpS+kKFw4GdVkXN6rMGT9FhZ6/HBcIpqUyVb
	 On/v2umBsIPDNPMmJY9AVFF+8oxs5N6pBQfmo2IlwtBd4B7ekAks8iNiqz9aMydXvJdzs
	 IWkRB5BHzskgdCzLqCdKKakVfuJ+VvsPxDevYcXwTCxxkrz3NLYmnao+nKOWRLapiLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ZEQPaCARU/GGpKLFLweEeLR2dQbyjlDY+6z7USzWbI=;
	b=rxsv6oT9roOv4fn8MgjeTFCQ+eKO8QzJ8fM23SKh3fgq6VkYQArWfX4JrWXeIuH/Yqut
	 SmMHGPleJF4epvqLJUGZtA+aBOH6jIXhLAuiUL3cSLXhjZnK7KlMpCr+SpfJFbyOaIyHM
	 dXnf13jub4ljBovRKjs870WYqaIY3kBj1HIOgnLUZ2mujLyxZW5JoPGNqfvr5u8PX+821
	 DDFIs9JoDrRubXIXVM3mIG3RwnS64BffIm2A8XuOu1E9r7SXAszbY+b0v1sZMTj9jkiBD
	 +cFftVchGgUvIHowvKbY4jfm36czmwtxB8OPBpx9QQNAUNYhETNcG9jk+4j01q5OAUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7+yJ+kP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E5606A31C;
	Wed, 18 Nov 2026 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7+yJ+kP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099EA1F000C4;
	Wed, 18 Nov 2026 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026018;
	bh=/ZEQPaCARU/GGpKLFLweEeLR2dQbyjlDY+6z7USzWbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7+yJ+kP0DRJTjlZU6xFDtdA7RfekFkSiB+8r2GvGxLa558M8Xn9AXHbNbJIGhc9a
	 5ZTHYQ3shg0o9G1RRQeiC0TWgsK/6QJMRbQm7lUS9ItxRGJvTBSAz9t7XZiizuTytc
	 NwDG7x8bwBkQUNyKkqLndVicJ1Fsdf5brei1JlmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1283/2151] ALSA: usb: us16x08: Fix racy accesses of mixer elements
Date: Wed, 18 Nov 2026 15:50:18 +0100
Message-ID: <20261118150208.874245574@linuxfoundation.org>
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
index e53f0808be1ae..3040192feb61e 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -182,6 +182,7 @@ static int snd_us16x08_route_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* route has no bias */
 	ucontrol->value.enumerated.item[0] = elem->cache_val[index];
 
@@ -197,6 +198,7 @@ static int snd_us16x08_route_put(struct snd_kcontrol *kcontrol,
 	char buf[sizeof(route_msg)];
 	int val, val_org, err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/*  get the new value (no bias for routes) */
 	val = ucontrol->value.enumerated.item[0];
 
@@ -251,6 +253,7 @@ static int snd_us16x08_master_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -265,6 +268,7 @@ static int snd_us16x08_master_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0];
 
@@ -303,6 +307,7 @@ static int snd_us16x08_bus_put(struct snd_kcontrol *kcontrol,
 
 	val = ucontrol->value.integer.value[0];
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* prepare the message buffer from template */
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BYPASS:
@@ -339,6 +344,7 @@ static int snd_us16x08_bus_get(struct snd_kcontrol *kcontrol,
 {
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (elem->head.id) {
 	case SND_US16X08_ID_BUSS_OUT:
 		ucontrol->value.integer.value[0] = elem->cache_val[0];
@@ -361,6 +367,7 @@ static int snd_us16x08_channel_get(struct snd_kcontrol *kcontrol,
 	struct usb_mixer_elem_info *elem = snd_kcontrol_chip(kcontrol);
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = elem->cache_val[index];
 
 	return 0;
@@ -375,6 +382,7 @@ static int snd_us16x08_channel_put(struct snd_kcontrol *kcontrol,
 	int val, err;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -421,6 +429,7 @@ static int snd_us16x08_comp_get(struct snd_kcontrol *kcontrol,
 	int index = ucontrol->id.index;
 	int val_idx = COMP_STORE_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	ucontrol->value.integer.value[0] = store->val[val_idx][index];
 
 	return 0;
@@ -438,6 +447,7 @@ static int snd_us16x08_comp_put(struct snd_kcontrol *kcontrol,
 	int threshold, ratio, attack, release, gain, switch_on;
 	int err;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -514,6 +524,7 @@ static int snd_us16x08_eqswitch_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_eq_store *store = elem->private_data;
 	int index = ucontrol->id.index;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* get low switch from cache is enough, cause all bands are together */
 	val = store->val[EQ_STORE_BAND_IDX(elem->head.id)]
 		[EQ_STORE_PARAM_IDX(elem->head.id)][index];
@@ -533,6 +544,7 @@ static int snd_us16x08_eqswitch_put(struct snd_kcontrol *kcontrol,
 	int val, err = 0;
 	int b_idx;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	/* new control value incl. bias*/
 	val = ucontrol->value.integer.value[0] + SND_US16X08_KCBIAS(kcontrol);
 
@@ -575,6 +587,7 @@ static int snd_us16x08_eq_get(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = store->val[b_idx][p_idx][index];
 
 	ucontrol->value.integer.value[0] = val;
@@ -594,6 +607,7 @@ static int snd_us16x08_eq_put(struct snd_kcontrol *kcontrol,
 	int b_idx = EQ_STORE_BAND_IDX(elem->head.id) - 1;
 	int p_idx = EQ_STORE_PARAM_IDX(elem->head.id);
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
@@ -722,6 +736,7 @@ static int snd_us16x08_meter_get(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	u8 meter_urb[64] = {0};
 
+	guard(mutex)(&elem->head.mixer->lock);
 	switch (kcontrol->private_value) {
 	case 0: {
 		char tmp[sizeof(mix_init_msg1)];
@@ -781,6 +796,7 @@ static int snd_us16x08_meter_put(struct snd_kcontrol *kcontrol,
 	struct snd_us16x08_meter_store *store = elem->private_data;
 	int val;
 
+	guard(mutex)(&elem->head.mixer->lock);
 	val = ucontrol->value.integer.value[0];
 
 	/* sanity check */
-- 
2.53.0



