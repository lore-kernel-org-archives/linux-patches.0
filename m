Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038467;
	b=T7k7IlZy95Jmkn5uUkBXGzDr0AcI6RIifS2Su7m6UiqbkUH/yQVjk0rk20C+oav7xKXn
	 XXZ2mYcOqjxaaP19FMhmHZw8kevycZOhv6YLOQEJ0i9R92hWzWff77VtELxh2hQLBdWym
	 7IGVnOoFZmavDv6qvmEAhtpSnD8wsy83PsVcdn0RL8P8GYlx4QisaDk+3IeMB1Hq92szF
	 u/lzXGVhyh7UUr/R8rUzM1nSqzv2GQd1zkJLs0jrfBhiY5OSQb7EPgBdOwZ3xQYFHfXY1
	 OZTgos19H3RsoSXECOhdC7Fr9T+Nv0lpct/tiU7fRae5ZlpSFF90k2R9MVXUdcur3BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQyU7DN/lzTRdzu70rpp1Uu4Lae0EpU6XKx1JiNxNGw=;
	b=xaTNgoZHzJaFn+D73V898NUEtAed+IrKaRFRLOiCMNddzIm50u2hHzZ85iOMsjCWVUKc
	 vxnih02XX+NKIVruy9jxubXmua0c/QWMr3qW0XeCPOHxidUh6TZ1gX2vlBg3C2bJo8STo
	 NjCoIjOwXrq2ph80vOb8RVIvhQdtsyfIzkakQVSn6ScLrNJYWTwfni0yta8yLBQ672Ev+
	 7Cu+4IyHKlzvu33/H46bnT/DoSoFx/HMKwHn3Wh6fhiRI1rTk4m5fbdtr+fxKvKsanMOz
	 PRrdOwaX3wGDFmwFkbLqT+xflFI09DzKCHkxyLIK8MPYcZY8WZFUj7so68F1Dyi57CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHVA3vGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0596606A325;
	Wed, 18 Nov 2026 21:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHVA3vGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE941F000C7;
	Wed, 18 Nov 2026 21:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038466;
	bh=mQyU7DN/lzTRdzu70rpp1Uu4Lae0EpU6XKx1JiNxNGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHVA3vGsXh6jg0beLKpnaR/xJla+ZI8NvGU83ycZDo0yRfpcNVlS5fWAjbqougTwK
	 lJZ6j4wt/azOYMqxTCSceupV6F3ihhSHcER3DKTrdy6F4HacTj6K8QFtMcDFJQXA2I
	 VtALd1hfxv3haFoaGRYgPBA9ke5/V8kPxoHxBRCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1754/3318] ALSA: emux: Fix UAF of soundfont zones at note-on
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150414.478108783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c124d6c27a945..2e37d91153a05 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1220,6 +1220,9 @@ delete_preset(struct snd_sf_list *sflist, struct snd_sf_zone *zp)
  * The found zones are stored on 'table' array.  max_layers defines
  * the maximum number of elements in this array.
  * This function returns the number of found zones.  0 if not found.
+ *
+ * The caller must hold sflist->lock, and keep holding it as long as
+ * the returned zones are accessed.
  */
 int
 snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
@@ -1229,11 +1232,11 @@ snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
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



