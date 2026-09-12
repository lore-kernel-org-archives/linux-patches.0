Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2452EC09B;
	Sat, 12 Sep 2026 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211856; cv=none; b=MVlMeXt+Il5mb8iQhA97NdD/jptb9WldnOHExUf0VskJQ6iVFaoERX2qsJJRRjDiGJCSwcjWZhkJXRWgGxkugqoz8DUyCQWKDG+RwRQuLkYpR/17L1iTGQAU3HH38+b2gP8hv25a2EAoYNj/Dv5alyD8oGvIFG7Jn2CoHpDH0lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211856; c=relaxed/simple;
	bh=DOWk2cwT/snpAvzYAtdeL+ivAA6G+jkXB2I4uxCoz08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=piGqlPqQQtPeUhPt2Fl1NZ+IeJG20l6D7RaTIhNATfDGsbwBYs/hgJloYXBwLfTySBDcznlOCLJEe8GLviaEXN7x7WPq3m5HkTWlGWif85tpWMpqglz6uJvi/dubQkuC7lrBl/xVmY/pBfidsn1ThDyFRaz3GNpdXZTZ98H21u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfimJUV+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfimJUV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7841C1F000FF;
	Sat, 12 Sep 2026 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211855;
	bh=nMAG2fioMVht62eU17Lhn1O9s9k7WWiw3Yw/IztqOLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfimJUV+ZDbh/XElmNT8fnogY3hWYyPaoXHgrmOP6RVj9BikKR/+bR3XSikLBbMfK
	 6LXHv6fe5jyqhw/7UjrHxXHEh3ayGXtDDlSwlEOSmzLHW6CjEavL5ebkawoNvRB+09
	 BjZUEduObRwh/6dQuy9SE2GJJr3h6NZZMh5fAgGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1316/1518] ALSA: core: Add scoped cleanup helper for card references
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065653.296425341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit c6c6f0aec6fb4cbcc547bb265315fd76f18be731 ]

Several ALSA paths acquire temporary card references with snd_card_ref()
and release them manually with snd_card_unref(). control_led.c already
defines a local cleanup helper for this pattern, while other core paths
still open-code the release.

Move the helper to the common ALSA core header and use it in control-layer
card-reference paths. This makes the ownership rule explicit and avoids
future missing-unref mistakes when adding early exits.

No functional change is intended.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260604-alsa-scoped-cleanups-v1-2-10c43152a728@gmail.com
Stable-dep-of: d736eba9c453 ("ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h     |  2 ++
 sound/core/control.c     |  6 +++---
 sound/core/control_led.c | 11 ++++-------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 64327e9711222..618055761fe01 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -314,6 +314,8 @@ static inline void snd_card_unref(struct snd_card *card)
 	put_device(&card->card_dev);
 }
 
+DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
+
 #define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 
 /* device.c */
diff --git a/sound/core/control.c b/sound/core/control.c
index c714f2e5596b3..652c09e110f6a 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -2219,7 +2219,6 @@ EXPORT_SYMBOL_GPL(snd_ctl_request_layer);
  */
 void snd_ctl_register_layer(struct snd_ctl_layer_ops *lops)
 {
-	struct snd_card *card;
 	int card_number;
 
 	scoped_guard(rwsem_write, &snd_ctl_layer_rwsem) {
@@ -2227,11 +2226,12 @@ void snd_ctl_register_layer(struct snd_ctl_layer_ops *lops)
 		snd_ctl_layer = lops;
 	}
 	for (card_number = 0; card_number < SNDRV_CARDS; card_number++) {
-		card = snd_card_ref(card_number);
+		struct snd_card *card __free(snd_card_unref) =
+			snd_card_ref(card_number);
+
 		if (card) {
 			scoped_guard(rwsem_read, &card->controls_rwsem)
 				lops->lregister(card);
-			snd_card_unref(card);
 		}
 	}
 }
diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index e33dfcf863cf1..007aba163236c 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -240,8 +240,6 @@ static void snd_ctl_led_notify(struct snd_card *card, unsigned int mask,
 	}
 }
 
-DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
-
 static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 			      unsigned int group, bool set)
 {
@@ -758,18 +756,17 @@ static int __init snd_ctl_led_init(void)
 static void __exit snd_ctl_led_exit(void)
 {
 	struct snd_ctl_led *led;
-	struct snd_card *card;
 	unsigned int group, card_number;
 
 	snd_ctl_disconnect_layer(&snd_ctl_led_lops);
 	for (card_number = 0; card_number < SNDRV_CARDS; card_number++) {
 		if (!snd_ctl_led_card_valid[card_number])
 			continue;
-		card = snd_card_ref(card_number);
-		if (card) {
+		struct snd_card *card __free(snd_card_unref) =
+			snd_card_ref(card_number);
+
+		if (card)
 			snd_ctl_led_sysfs_remove(card);
-			snd_card_unref(card);
-		}
 	}
 	for (group = 0; group < MAX_LED; group++) {
 		led = &snd_ctl_leds[group];
-- 
2.53.0



