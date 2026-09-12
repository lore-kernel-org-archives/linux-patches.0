Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9453242D65;
	Sat, 12 Sep 2026 16:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232065; cv=none; b=VVIhwbha37cTBg+1d0XeVG43e8kMgABGrPIVS8O0sVSzSjYGwCAxA47uMzPKnPWM0EVRlVT8WxbsJC8YNprRHZTUtKnkQzv43thwhQQVTwo6IpAxT0KY/veKDavpxxZFVhozlsvD83nLMVAwEVjq3J1PspGR1CUAUOVnEXMA1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232065; c=relaxed/simple;
	bh=19NoCnd9BD+aDS+kLSPyk6bLqPu+6R5Ah2TyKMf4DH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INlvcjqwgER34URnIl5RaEKSuDPdueF4erJC2p9yofs5yETcSLvE3OM7qT28OziuJp/3op/645NG+Owl2CV+z1vG0Fcg+QjVsg1a+Wc394PwEks2KYW/NSsWXEDPKGLTIrhw6YC46Zw/quAEoqH/6h6I6o66Fsu92JrWvgdBY64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdWGVbh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdWGVbh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BF41F000FF;
	Sat, 12 Sep 2026 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232063;
	bh=v+lGkWP9XyLBYuziyj/2T9jeTc1uzXPkLeMFaJMgtLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdWGVbh7e/336gRaiETu0CjQf0HtiiG5ti4dJkUwqa4aCmwWZm80dmzvRs+NAfHmX
	 C5BsiDwTViENMtsY4oSiqsKKzgpCnVMTOoYJSAqFc/D/N4s5qo6mGMsw0Vec+MnlL9
	 ewhz8rr2/p8PAzZcKlvrWE72NLqqDw38ssYZihpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1126/1191] ALSA: control_led: Use guard() for locking
Date: Sat, 12 Sep 2026 09:04:14 +0200
Message-ID: <20260912065613.441264289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7dba48a474e68dcdda2b212cea131b4c9ddc7d89 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

A couple of functions that use snd_card_ref() and *_unref() are also
cleaned up with a defined class, too.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-25-tiwai@suse.de
Stable-dep-of: 74e3b979ce8b ("ALSA: control: Don't add invalid kcontrols to LED layer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 150 +++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 85 deletions(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index 0f35f77af1bfe..dd6ad4735fc4b 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -147,29 +147,27 @@ static void snd_ctl_led_set_state(struct snd_card *card, unsigned int access,
 		return;
 	route = -1;
 	found = false;
-	mutex_lock(&snd_ctl_led_mutex);
-	/* the card may not be registered (active) at this point */
-	if (card && !snd_ctl_led_card_valid[card->number]) {
-		mutex_unlock(&snd_ctl_led_mutex);
-		return;
-	}
-	list_for_each_entry(lctl, &led->controls, list) {
-		if (lctl->kctl == kctl && lctl->index_offset == ioff)
-			found = true;
-		UPDATE_ROUTE(route, snd_ctl_led_get(lctl));
-	}
-	if (!found && kctl && card) {
-		lctl = kzalloc(sizeof(*lctl), GFP_KERNEL);
-		if (lctl) {
-			lctl->card = card;
-			lctl->access = access;
-			lctl->kctl = kctl;
-			lctl->index_offset = ioff;
-			list_add(&lctl->list, &led->controls);
+	scoped_guard(mutex, &snd_ctl_led_mutex) {
+		/* the card may not be registered (active) at this point */
+		if (card && !snd_ctl_led_card_valid[card->number])
+			return;
+		list_for_each_entry(lctl, &led->controls, list) {
+			if (lctl->kctl == kctl && lctl->index_offset == ioff)
+				found = true;
 			UPDATE_ROUTE(route, snd_ctl_led_get(lctl));
 		}
+		if (!found && kctl && card) {
+			lctl = kzalloc(sizeof(*lctl), GFP_KERNEL);
+			if (lctl) {
+				lctl->card = card;
+				lctl->access = access;
+				lctl->kctl = kctl;
+				lctl->index_offset = ioff;
+				list_add(&lctl->list, &led->controls);
+				UPDATE_ROUTE(route, snd_ctl_led_get(lctl));
+			}
+		}
 	}
-	mutex_unlock(&snd_ctl_led_mutex);
 	switch (led->mode) {
 	case MODE_OFF:		route = 1; break;
 	case MODE_ON:		route = 0; break;
@@ -201,14 +199,13 @@ static unsigned int snd_ctl_led_remove(struct snd_kcontrol *kctl, unsigned int i
 	struct snd_ctl_led_ctl *lctl;
 	unsigned int ret = 0;
 
-	mutex_lock(&snd_ctl_led_mutex);
+	guard(mutex)(&snd_ctl_led_mutex);
 	lctl = snd_ctl_led_find(kctl, ioff);
 	if (lctl && (access == 0 || access != lctl->access)) {
 		ret = lctl->access;
 		list_del(&lctl->list);
 		kfree(lctl);
 	}
-	mutex_unlock(&snd_ctl_led_mutex);
 	return ret;
 }
 
@@ -239,44 +236,36 @@ static void snd_ctl_led_notify(struct snd_card *card, unsigned int mask,
 	}
 }
 
+DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
+
 static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 			      unsigned int group, bool set)
 {
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_kcontrol_volatile *vd;
 	unsigned int ioff, access, new_access;
-	int err = 0;
 
 	card = snd_card_ref(card_number);
-	if (card) {
-		down_write(&card->controls_rwsem);
-		kctl = snd_ctl_find_id_locked(card, id);
-		if (kctl) {
-			ioff = snd_ctl_get_ioff(kctl, id);
-			vd = &kctl->vd[ioff];
-			access = vd->access & SNDRV_CTL_ELEM_ACCESS_LED_MASK;
-			if (access != 0 && access != group_to_access(group)) {
-				err = -EXDEV;
-				goto unlock;
-			}
-			new_access = vd->access & ~SNDRV_CTL_ELEM_ACCESS_LED_MASK;
-			if (set)
-				new_access |= group_to_access(group);
-			if (new_access != vd->access) {
-				vd->access = new_access;
-				snd_ctl_led_notify(card, SNDRV_CTL_EVENT_MASK_INFO, kctl, ioff);
-			}
-		} else {
-			err = -ENOENT;
-		}
-unlock:
-		up_write(&card->controls_rwsem);
-		snd_card_unref(card);
-	} else {
-		err = -ENXIO;
+	if (!card)
+		return -ENXIO;
+	guard(rwsem_write)(&card->controls_rwsem);
+	kctl = snd_ctl_find_id_locked(card, id);
+	if (!kctl)
+		return -ENOENT;
+	ioff = snd_ctl_get_ioff(kctl, id);
+	vd = &kctl->vd[ioff];
+	access = vd->access & SNDRV_CTL_ELEM_ACCESS_LED_MASK;
+	if (access != 0 && access != group_to_access(group))
+		return -EXDEV;
+	new_access = vd->access & ~SNDRV_CTL_ELEM_ACCESS_LED_MASK;
+	if (set)
+		new_access |= group_to_access(group);
+	if (new_access != vd->access) {
+		vd->access = new_access;
+		snd_ctl_led_notify(card, SNDRV_CTL_EVENT_MASK_INFO, kctl, ioff);
 	}
-	return err;
+	return 0;
 }
 
 static void snd_ctl_led_refresh(void)
@@ -312,7 +301,7 @@ static void snd_ctl_led_clean(struct snd_card *card)
 
 static int snd_ctl_led_reset(int card_number, unsigned int group)
 {
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led *led;
 	struct snd_ctl_led_ctl *lctl;
 	struct snd_kcontrol_volatile *vd;
@@ -322,26 +311,22 @@ static int snd_ctl_led_reset(int card_number, unsigned int group)
 	if (!card)
 		return -ENXIO;
 
-	mutex_lock(&snd_ctl_led_mutex);
-	if (!snd_ctl_led_card_valid[card_number]) {
-		mutex_unlock(&snd_ctl_led_mutex);
-		snd_card_unref(card);
-		return -ENXIO;
-	}
-	led = &snd_ctl_leds[group];
+	scoped_guard(mutex, &snd_ctl_led_mutex) {
+		if (!snd_ctl_led_card_valid[card_number])
+			return -ENXIO;
+		led = &snd_ctl_leds[group];
 repeat:
-	list_for_each_entry(lctl, &led->controls, list)
-		if (lctl->card == card) {
-			vd = &lctl->kctl->vd[lctl->index_offset];
-			vd->access &= ~group_to_access(group);
-			snd_ctl_led_ctl_destroy(lctl);
-			change = true;
-			goto repeat;
-		}
-	mutex_unlock(&snd_ctl_led_mutex);
+		list_for_each_entry(lctl, &led->controls, list)
+			if (lctl->card == card) {
+				vd = &lctl->kctl->vd[lctl->index_offset];
+				vd->access &= ~group_to_access(group);
+				snd_ctl_led_ctl_destroy(lctl);
+				change = true;
+				goto repeat;
+			}
+	}
 	if (change)
 		snd_ctl_led_set_state(NULL, group_to_access(group), NULL, 0);
-	snd_card_unref(card);
 	return 0;
 }
 
@@ -353,9 +338,8 @@ static void snd_ctl_led_register(struct snd_card *card)
 	if (snd_BUG_ON(card->number < 0 ||
 		       card->number >= ARRAY_SIZE(snd_ctl_led_card_valid)))
 		return;
-	mutex_lock(&snd_ctl_led_mutex);
-	snd_ctl_led_card_valid[card->number] = true;
-	mutex_unlock(&snd_ctl_led_mutex);
+	scoped_guard(mutex, &snd_ctl_led_mutex)
+		snd_ctl_led_card_valid[card->number] = true;
 	/* the register callback is already called with held card->controls_rwsem */
 	list_for_each_entry(kctl, &card->controls, list)
 		for (ioff = 0; ioff < kctl->count; ioff++)
@@ -367,10 +351,10 @@ static void snd_ctl_led_register(struct snd_card *card)
 static void snd_ctl_led_disconnect(struct snd_card *card)
 {
 	snd_ctl_led_sysfs_remove(card);
-	mutex_lock(&snd_ctl_led_mutex);
-	snd_ctl_led_card_valid[card->number] = false;
-	snd_ctl_led_clean(card);
-	mutex_unlock(&snd_ctl_led_mutex);
+	scoped_guard(mutex, &snd_ctl_led_mutex) {
+		snd_ctl_led_card_valid[card->number] = false;
+		snd_ctl_led_clean(card);
+	}
 	snd_ctl_led_refresh();
 }
 
@@ -430,9 +414,8 @@ static ssize_t mode_store(struct device *dev,
 	else
 		return count;
 
-	mutex_lock(&snd_ctl_led_mutex);
-	led->mode = mode;
-	mutex_unlock(&snd_ctl_led_mutex);
+	scoped_guard(mutex, &snd_ctl_led_mutex)
+		led->mode = mode;
 
 	snd_ctl_led_set_state(NULL, group_to_access(led->group), NULL, 0);
 	return count;
@@ -615,15 +598,15 @@ static ssize_t list_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
-	struct snd_card *card;
+	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led_ctl *lctl;
 	size_t l = 0;
 
 	card = snd_card_ref(led_card->number);
 	if (!card)
 		return -ENXIO;
-	down_read(&card->controls_rwsem);
-	mutex_lock(&snd_ctl_led_mutex);
+	guard(rwsem_read)(&card->controls_rwsem);
+	guard(mutex)(&snd_ctl_led_mutex);
 	if (snd_ctl_led_card_valid[led_card->number]) {
 		list_for_each_entry(lctl, &led_card->led->controls, list) {
 			if (lctl->card != card)
@@ -634,9 +617,6 @@ static ssize_t list_show(struct device *dev,
 					   lctl->kctl->id.numid + lctl->index_offset);
 		}
 	}
-	mutex_unlock(&snd_ctl_led_mutex);
-	up_read(&card->controls_rwsem);
-	snd_card_unref(card);
 	return l;
 }
 
-- 
2.53.0



