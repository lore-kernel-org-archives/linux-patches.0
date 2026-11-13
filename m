Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591525;
	b=2AC2oV2faMmEApVO0k9Xplly3aEgJUf4T+n1WepHsju7FZ5XZdlbhnc3s8UMfZXUYZLT
	 LulHxi/BS/3sfgGBhgINYG8k5GfHvnEunzTRmMiGm+/4zliRdrkOUNdNCCzqyC2g2X5gH
	 R3Eh6ZYkkPmF3bt1GU9M8UyZkDATrFMAjR7Ht1Mf9C3vS9NsbikramzWyTUyPjAMhUtQY
	 6DC7R5KVgrKhYm0GLAJGJv2mmnsA5zZ9Dw46mwhgJOZDuu1S8aBAx4Spdr4dvCSr/KtbP
	 vddGBInKie1f4JXwCsfNGkAVkPPnb+nwRQhqriRFzYSlo0bOeu/WgQn8iZ3G7nQv7Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoUA1KIcSQAwTa7CT6jW7CGULkzHHuzu4P0dGeVEXQU=;
	b=XTNtXqZoOfLSm5SCPUQot61YByw01oAdd6yFO/vOXv+/EwYLy1tNUdTuggZ/mgVGV2EH
	 Z2yQlRBTQEH6dZvXJcif3qAxlmNPkdgU9V37Uy0DgjSc4WgCSX9EjiE30aTpJUhf04tA8
	 mAx6pcDwM0bgqH69YAlEn9hcV1T4Yn7MUD9Haxezv3IWPfxqwLurEF6+L4Nm6GK5FI4mF
	 gp+IcfTYanAhyx4b63gy/+MMAI2RUyeBnvX4uFw0WlV5KABIteBUQFu0ryEWNTH3DN3GW
	 hccNvds4bagMblEnLYekqWQFt0k1RpVW6jdTXwa3OX5d+ly2GAvrL4KD6+V5qcbeprg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCjHtqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D89606D49D;
	Fri, 13 Nov 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzCjHtqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D66F1F000C4;
	Fri, 13 Nov 2026 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591525;
	bh=RoUA1KIcSQAwTa7CT6jW7CGULkzHHuzu4P0dGeVEXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzCjHtqGmubqVtEn70O42F+fVxta3IaPUm3RenoQVRgihD5xmEFq5Fg03GWsBzLZl
	 jUzfYFYEXHzNFvR0PVKqtDxauMYMeRc2rqcI2IlvPjcH0fny2igUhp1bEfG452zyIN
	 AMZnQBiPmLP3hupa3LvgFXANjpzrhkFWKgs0JoGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 583/670] ALSA: emux: Fix UAF of soundfont zones at note-on
Date: Fri, 13 Nov 2026 10:52:27 -0500
Message-ID: <20261113153831.595463116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

[ Upstream commit 34e3e04b8a1731a773797542f0781e99ce7cd755 ]

snd_emux_note_on() looks up the matching zones via
snd_soundfont_search_zone(), which takes sflist->lock only during the
lookup and returns the raw zone pointers after releasing it.  The
caller then stores them in vp->zone without any protection.
Meanwhile, a concurrent SNDRV_EMUX_IOCTL_REMOVE_LAST_SAMPLES ioctl may
unlink and free those zones in snd_soundfont_remove_unlocked(); this
leads to a use-after-free in snd_emux_note_on(), and later at
accessing the cached vp->zone, e.g. in snd_emux_send_effect().

Fix it by holding sflist->lock in snd_emux_note_on() over the whole
zone lookup and voice setup, and let snd_soundfont_search_zone()
require the caller to hold the lock, instead.
snd_soundfont_lock_preset() takes sflist->lock for setting
presets_locked, so the removal path now syncs with the note-on finish.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-697212bb-a434-4ff5-8778-25a84f5dad89
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020101624.205638-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux_synth.c | 3 +++
 sound/synth/emux/soundfont.c  | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/synth/emux/emux_synth.c b/sound/synth/emux/emux_synth.c
index b3c8296840a56..537a7c47ef475 100644
--- a/sound/synth/emux/emux_synth.c
+++ b/sound/synth/emux/emux_synth.c
@@ -60,6 +60,9 @@ snd_emux_note_on(void *p, int note, int vel, struct snd_midi_channel *chan)
 		return;
 
 	key = note; /* remember the original note */
+
+	/* hold sflist->lock for protecting against concurrent free */
+	guard(spinlock_irqsave)(&emu->sflist->lock);
 	nvoices = get_zone(emu, port, &note, vel, chan, table);
 	if (! nvoices)
 		return;
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index 18a919d1cdb64..ad4a0f262afa5 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1264,6 +1264,9 @@ delete_preset(struct snd_sf_list *sflist, struct snd_sf_zone *zp)
  * The found zones are stored on 'table' array.  max_layers defines
  * the maximum number of elements in this array.
  * This function returns the number of found zones.  0 if not found.
+ *
+ * The caller must hold sflist->lock, and keep holding it as long as
+ * the returned zones are accessed.
  */
 int
 snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
@@ -1273,11 +1276,11 @@ snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
 {
 	int nvoices;
 
-	/* this function is supposed to be called atomically,
-	 * so we check the lock.  if it's busy, just returns 0 to
+	lockdep_assert_held(&sflist->lock);
+
+	/* if the presets are being modified, just returns 0 to
 	 * tell the caller the busy state
 	 */
-	guard(spinlock_irqsave)(&sflist->lock);
 	if (sflist->presets_locked)
 		return 0;
 	nvoices = search_zones(sflist, notep, vel, preset, bank,
-- 
2.53.0



