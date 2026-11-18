Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053938;
	b=IywmH8GbAlRSguCPP4+v3A/UrjVxkkoHCtqjHzEg+tU7h0KEGtDaKzfeEwO2jA2i4du5
	 AkwutsK3oeJkoVyscy1bYtI5uvKVspMjw67b1tzY2Uidn7NCk6emVM9+eRUUYKdd5PHXZ
	 gaPpalbdIkuqHQASmnw+p31tugtWSZuoRsSj311GngpsHCMDsfElm1uoObRnQ9rGUWT8e
	 7/4dZi1Pe+7+MjrM6WKwHe4h+lq5ITGnAMbpuWIcF5jxjeI916L6HU6GAC0KEeYbOdYFr
	 Awc9KEYNWavcgc1LX8L5h00dFnxBvgJ/XX0l/Zi2ZDwSg8xq3C08B9NxVqvSk5U0iSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKvsoTNV2b73MGb+X9dP7FzudrZiBGib+a1n8hgHnfA=;
	b=iQTN/3VdMrQN6MimxqXJsa5FdMoT3qGspiiOUvnGloQ5zBmqMf+Fb3Brf8HW/PYHPA7I
	 K7t5h+yaHxxzSUbnDHGUcuzKwHnG/ZwR4RSFjwCqHOvEDqNoUeF+mIwJexnJIKfyGRqkP
	 GRtOmu+F6fOdIpJmfkdqqTHq+d500QI53arv+RV34AE9GXC2f/WgyuWsPxLyPxHjtG7gn
	 ahYmTx6p35a4RVRfumeZRMJ29fCAmgleJgCoe5hyy3ATiliUmQoCZ2occUAoIjp0i0wLi
	 QaGYC8Xrsvz1F1uZBzue6zuovrJhXc8JdSHr+eXcUu7mhu7yX2en3uioLDHcrBhHhXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVxr2tFm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B02606A32A;
	Thu, 19 Nov 2026 02:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DVxr2tFm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DAD1F000C4;
	Thu, 19 Nov 2026 02:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053938;
	bh=mKvsoTNV2b73MGb+X9dP7FzudrZiBGib+a1n8hgHnfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVxr2tFmC9JEFNpx0/c6vW9Q50rIalvx4GIdvAwvetQQuG/ZSGy2DM3hS8kL6K58k
	 votHzvk8EeyyNEEj7gIyJxvEc0pi4g17W96Zq9QDbkusgbZbYQCgBCrdYFeenouQrD
	 vtw8mjpnUsvYF4aIGd1f6kiZJBS8mqVdUu5aeHSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1096/2214] ALSA: emux: Fix UAF of soundfont zones at note-on
Date: Wed, 18 Nov 2026 15:46:12 +0100
Message-ID: <20261118150056.052954832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the scoped spinlock guard with explicit lock/unlock calls using a shared unlock path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux_synth.c |  9 +++++++--
 sound/synth/emux/soundfont.c  | 15 +++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/sound/synth/emux/emux_synth.c b/sound/synth/emux/emux_synth.c
index a5385efcedb6c..195cb58fd428f 100644
--- a/sound/synth/emux/emux_synth.c
+++ b/sound/synth/emux/emux_synth.c
@@ -49,7 +49,7 @@ snd_emux_note_on(void *p, int note, int vel, struct snd_midi_channel *chan)
 	int i, key, nvoices;
 	struct snd_emux_voice *vp;
 	struct snd_sf_zone *table[SNDRV_EMUX_MAX_MULTI_VOICES];
-	unsigned long flags;
+	unsigned long flags, sf_flags;
 	struct snd_emux_port *port;
 
 	port = p;
@@ -61,9 +61,12 @@ snd_emux_note_on(void *p, int note, int vel, struct snd_midi_channel *chan)
 		return;
 
 	key = note; /* remember the original note */
+
+	/* hold sflist->lock for protecting against concurrent free */
+	spin_lock_irqsave(&emu->sflist->lock, sf_flags);
 	nvoices = get_zone(emu, port, &note, vel, chan, table);
 	if (! nvoices)
-		return;
+		goto unlock;
 
 	/* exclusive note off */
 	for (i = 0; i < nvoices; i++) {
@@ -136,6 +139,8 @@ snd_emux_note_on(void *p, int note, int vel, struct snd_midi_channel *chan)
 		}
 	}
 #endif
+unlock:
+	spin_unlock_irqrestore(&emu->sflist->lock, sf_flags);
 }
 
 /*
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index eed47e4830248..0a788fe8bb8e0 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1231,6 +1231,9 @@ delete_preset(struct snd_sf_list *sflist, struct snd_sf_zone *zp)
  * The found zones are stored on 'table' array.  max_layers defines
  * the maximum number of elements in this array.
  * This function returns the number of found zones.  0 if not found.
+ *
+ * The caller must hold sflist->lock, and keep holding it as long as
+ * the returned zones are accessed.
  */
 int
 snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
@@ -1239,17 +1242,14 @@ snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
 			  struct snd_sf_zone **table, int max_layers)
 {
 	int nvoices;
-	unsigned long flags;
 
-	/* this function is supposed to be called atomically,
-	 * so we check the lock.  if it's busy, just returns 0 to
+	lockdep_assert_held(&sflist->lock);
+
+	/* if the presets are being modified, just returns 0 to
 	 * tell the caller the busy state
 	 */
-	spin_lock_irqsave(&sflist->lock, flags);
-	if (sflist->presets_locked) {
-		spin_unlock_irqrestore(&sflist->lock, flags);
+	if (sflist->presets_locked)
 		return 0;
-	}
 	nvoices = search_zones(sflist, notep, vel, preset, bank,
 			       table, max_layers, 0);
 	if (! nvoices) {
@@ -1258,7 +1258,6 @@ snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
 					       def_preset, def_bank,
 					       table, max_layers, 0);
 	}
-	spin_unlock_irqrestore(&sflist->lock, flags);
 	return nvoices;
 }
 
-- 
2.53.0



