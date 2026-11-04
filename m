Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827132;
	b=bzxGPRP+Dml2ONC+3PxMrItCdb/SstaGrkR9aCGPYUdQGombCL+OFm13BiIIYWtI1pJ3
	 hz6rLLnG/LfAS7AFNsMTiS8Y0ZLdiJojWUBW99zQId8QXHs/CvFMhwYUE2bJRbWJeDPr1
	 p+e0F24wbxriVA6pps0sNuC2v0aBPnVcDr/tsKplb0rAH7+903trSprUrbqut3XL9Qlfc
	 fZCZT4k+LW8l6SScWdfn9oFz6Ki79KpJ0ehg7eWJBz63C580B0SnRwkDaO+2vBWVLgaWg
	 1yG9mr0GlcxlAy+2o0oCCHrH7Q/cFUs3RKNKbI9Rx1ELWlJ3OgZZsxyVHKm+XbV+RBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+JJEg6cmLoq5hjCGluyFH7GH/qu5G2BspOopTyqJRI=;
	b=03LemkLWGrvmTNnFft2j8/BbJrGIvPrcBDIkn+QNDQlWxvN/fOstNQ6UE6KdIuxRaDB5
	 2DH75jOvVO1gTkJCtqMNBfkkanXHLCcplewkDypFyC401LcV9CK79j/JZjT04nVWm+iQ7
	 eq9NfNcdVo/juf+aBUwoZCqYM5LFUKGaXmAIeRrayh+MrXGG7uGRGBdoX/Xrfi4+iFe10
	 aDnpEVGcQPXa90g4lX0dMI5QwkUtNquOtjUh/7T6eVAlPeWpV91jdUQGRYMHtcxR63gb3
	 NojR1cqQNu8I9Z0ZaQVI+HtU2Y2ZAsIPYaLVFJi3jbQw6gbu1X1FPaZdNZ3Bg/rkreA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTkkSrkS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8292B606AB0D;
	Wed,  4 Nov 2026 21:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTkkSrkS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB331F000C1;
	Wed,  4 Nov 2026 21:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827132;
	bh=w+JJEg6cmLoq5hjCGluyFH7GH/qu5G2BspOopTyqJRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTkkSrkSnjdYx1fLRywISUAGEcW2m+p/d3Lm5ODILB3gZ8Ux25CjZpod4bugovy3p
	 qMG3lVtUdnCppKeus9rFZuWqdNZclueocxn6vWShPJvXSnepqojjEdSEjqFLYQBSzv
	 c1uBsJ/MJ1KIvFccVkhHTrLnSGuQDwdvPkd81jCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 206/547] ALSA: emux: Fix UAF of soundfont zones at note-on
Date: Wed,  4 Nov 2026 16:06:30 -0500
Message-ID: <20261104211043.997236019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

commit 34e3e04b8a1731a773797542f0781e99ce7cd755 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux_synth.c |    3 +++
 sound/synth/emux/soundfont.c  |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/sound/synth/emux/emux_synth.c
+++ b/sound/synth/emux/emux_synth.c
@@ -60,6 +60,9 @@ snd_emux_note_on(void *p, int note, int
 		return;
 
 	key = note; /* remember the original note */
+
+	/* hold sflist->lock for protecting against concurrent free */
+	guard(spinlock_irqsave)(&emu->sflist->lock);
 	nvoices = get_zone(emu, port, &note, vel, chan, table);
 	if (! nvoices)
 		return;
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1225,6 +1225,9 @@ delete_preset(struct snd_sf_list *sflist
  * The found zones are stored on 'table' array.  max_layers defines
  * the maximum number of elements in this array.
  * This function returns the number of found zones.  0 if not found.
+ *
+ * The caller must hold sflist->lock, and keep holding it as long as
+ * the returned zones are accessed.
  */
 int
 snd_soundfont_search_zone(struct snd_sf_list *sflist, int *notep, int vel,
@@ -1234,11 +1237,11 @@ snd_soundfont_search_zone(struct snd_sf_
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


