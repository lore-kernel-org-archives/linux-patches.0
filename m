Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32715A85A;
	Sat, 12 Sep 2026 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226172; cv=none; b=gcX1ofkmul9w2ikYTw91NA62Jct0QO85xyb1+w3wjwl0MuyiPeFtQxamK165XorWL+WkQCSGyDNWxNaQ+UQvWhUIr8DoxWN2L2UC8MUTqDd/UixgmJm+qSO8JwXtuom2wCejL4tC359GVbVGZODr0pxefnPVjMjioTJGWsik3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226172; c=relaxed/simple;
	bh=t3u8rb7ezAYPjGsODlIt7idc6LZmsrxTAgofnBGEqt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPxhZCm3xRbsGDjPnIA+KZFq2YpTQt5GdufrVjR5XtktBzhLgbmkVMmoow3kxFV4IFu/mIqFUHP8ESOjWIUq0GLC/PapPlzthVI6DQ7agNpKvDzQR1ZyiVa808N+W4yTZxPbbwKABO1ZG3owgp7k+Ea3yeC8HfmFOMr8dtG4Dns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leoEocy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leoEocy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167381F000FF;
	Sat, 12 Sep 2026 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226171;
	bh=zrr5vs5jw6oapY6iwechi3jFADEfXfF+rF5pE823TQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leoEocy8Kj5X05vHvVL+1AztReO7zQ6OR/ZXKioyBuNsvWLLT/99e/sc8qv80JPx7
	 JCtd1LFcZoD8cV3qnTflvXmex7MKvMcbb1JT73X1cAvLdfUhcyHdzgFdcLi75P5yEU
	 1d2jet4GvrcGtd8QZhnv947gaVD4xTgTk+oKFJ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1321/1424] ALSA: core: Add scoped cleanup helper for card references
Date: Sat, 12 Sep 2026 09:02:33 +0200
Message-ID: <20260912065636.845254499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
 include/sound/core.h     | 2 ++
 sound/core/control.c     | 6 +++---
 sound/core/control_led.c | 9 ++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index dfef0c9d4b9f7..fe955fb238e59 100644
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
index bc92212cf6462..3eca2ff89ab42 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -2234,7 +2234,6 @@ EXPORT_SYMBOL_GPL(snd_ctl_request_layer);
  */
 void snd_ctl_register_layer(struct snd_ctl_layer_ops *lops)
 {
-	struct snd_card *card;
 	int card_number;
 
 	scoped_guard(rwsem_write, &snd_ctl_layer_rwsem) {
@@ -2242,11 +2241,12 @@ void snd_ctl_register_layer(struct snd_ctl_layer_ops *lops)
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
index ba984ed00972d..15acb07c65150 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -775,18 +775,17 @@ static int __init snd_ctl_led_init(void)
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



