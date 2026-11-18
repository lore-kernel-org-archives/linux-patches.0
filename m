Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047038;
	b=aRRlnZxW44gipiCY9iohw852TDy3lSuSCl+ZZ70TsULc1JlceP8QuYLHWMnm6L45xXSf
	 Q8/PTxtjNFIaCEM0Jrg4YQVULvacRJTterLdwIkKbZHssusiTLb/a6lLjvkvN4TQ/Frsx
	 p020PIUpU8cuX7RDEmBw1M0mZx/Pb8m59Q2/huozyYgppMyDIGXFCu9j3rjcO+MY0+raH
	 QrInY3EmtzwFrtas0ipF2fWWZUgt6v3VnyXxITqvR2LbzQds3dTaxg5Dcamtvhd7oXwKp
	 UDSEnEhZ2KGzZIs5xq2rowIpxpTUUuV3iJME5bQFWMOil+Xe9SNAalPZSRHVTpGff2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cT3+ZJ9Nkm8Drj0VppxcxLwG7RF8eTAefcjuwd18+Y0=;
	b=vg6Kh66XyhFjc0jtGnUHZrFrN99vkyE3pJy9qB7YHqTLWDWAJ34WJznxATXA72X0lAPE
	 +ms1lSY0D69JSfLtMHe/xkya4MzWk+EYTHB62w0HEi2y0ElUNmLfdxDiNyxCOcoB3ca6F
	 JaSCVU4iVO1E2cq04IRmLm6tirNAE4GS3p6D7NsFRs8GF+IguhU0BT0+EAjx8FURYYV49
	 ra5QQOZV11+83qj/aYzqGoz+mm9cWMfOG+wQiCmCRlWpn+yMNcek/uOYh3JGXc8R9WN0p
	 1IXZMLoVv9QVE0HRFaorD8+qnhRemLvDfzEF7YQZaQJhoflmRkqDAFA9bI44O6oysnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzJTeFRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B3F606A339;
	Thu, 19 Nov 2026 00:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NzJTeFRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F591F000C4;
	Thu, 19 Nov 2026 00:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047037;
	bh=cT3+ZJ9Nkm8Drj0VppxcxLwG7RF8eTAefcjuwd18+Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzJTeFRrD5XfpbcaIVz8QgdZamTddulJ2zfPzZMtHRzH5H4zN0pJTARqkQ8JIGWXA
	 g3GfI1Ng4Z176l6u8rN/v9BHMAqwRUQo7SM0uiXW1AV+rj578ZG4Z2IcjNhTqfLRSR
	 TRrBTcqhKYzGrsS0BYMA8B7AUzwlozYIGb6QcKVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1494/2857] ALSA: emux: Fix UAF of soundfont zones at note-on
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118150255.120106831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a541be1c41890..2ce6dc4000fc2 100644
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



