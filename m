Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038510;
	b=Ulr0MUXc8Av4bA8232Q8+sMMPrgJ+HHDbhbvOmqKHjAZI7zjZM8OsisggW3LcsAp0z7h
	 jOcXjQpKPpHWijPg3xpSVstBDQMy8pSTX1XU9EAX3L3/zAknVcUs0zJgqlhOltUELydIA
	 ieo6HwNqUT2P/ajyyXlttcFw5KsRz5UREYqg/rYtkRMf5VDUznAr5hobPS/uVG1J4huKs
	 V+TmbFanHKVs5fqPaUpc2DlKiq+uTbQx2zRmQkfFZaUWdB456tbnEoQ51IYqXY8mqwUNz
	 vzjKcLMGh3S2bQlqBtN19XB+50f9J1rALAynZQ/Kwi1RMrLnzDcSTa1/cL9zlVKIvkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=94tOUltSKZ5fqFr8Y4l5OfDEEdKX4RX1aCrWAeoTUDo=;
	b=OrpWl4EPV0YBO2M+ZMSh75mjuqOKaqnQC4GO4esR0PyEhm4R+xKrZaEoinSPNziw/BDI
	 QcYRooGAbIeoQJosqiedsao7XZWEydAvaPzBTyFPHx+H8GOPQg5P3l6K/dh05J6DOA/oP
	 xZMi740dxUYTQHaBY/uZHzQPUg/CvNLFdruPy1h2Yt6IfcyDUPbBbjaeGUJP0uDwQKpus
	 9BZs5ECbelIm0L4in7qlnTdtIyJCJC75hNiILhKSprx/1V/3ArAXO4Sg1QMWAZl9Dx+uA
	 fpDG9mKHlrDd2OSthOpgXiSKDIqegn6T2nolKLdgHauCusxUuUk/+AzdqGq7yhcGxFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5Oy10BJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DC1606A33A;
	Wed, 18 Nov 2026 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5Oy10BJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333CC1F000CC;
	Wed, 18 Nov 2026 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038509;
	bh=94tOUltSKZ5fqFr8Y4l5OfDEEdKX4RX1aCrWAeoTUDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5Oy10BJJoQAgJIspTc1ismP56ITfUseRrEq6i3yWtXdLi3MdeE5kao88K7lJ863d
	 tx2sldp2cWZ9Dbkk3jbwDoe9Ou4NWnoGABUcsldfea+t5+ueR5GdaKswXKy9brBXSO
	 cNxoJoHqxaaTGOrg7nN2CMzX6CV5nfsYxMeRcVVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1767/3318] ALSA: emux: simplify snd_sf_list.callback handling
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150414.863532972@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 4c4cbe66828f185903d2127aed6ac9b7302e9d3a ]

Both drivers provide both sample_new and sample_free, and it makes no
sense to pretend that they could not. In fact, load_data() would already
crash if sample_new was null. So remove the remaining null checks.

Contrary to that, the emu10k1 driver actually has a null sample_reset,
though I'm not convinced that this inconsistency is justified.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-18-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 8a5d87c2ba30 ("ALSA: emux: Stop voices before freeing zones in all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux.c      |  6 ++----
 sound/synth/emux/soundfont.c | 12 +++++-------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 0006c3ddb51d6..7966590f2edbc 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -94,10 +94,8 @@ int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, ch
 	/* create soundfont list */
 	memset(&sf_cb, 0, sizeof(sf_cb));
 	sf_cb.private_data = emu;
-	if (emu->ops.sample_new)
-		sf_cb.sample_new = sf_sample_new;
-	if (emu->ops.sample_free)
-		sf_cb.sample_free = sf_sample_free;
+	sf_cb.sample_new = sf_sample_new;
+	sf_cb.sample_free = sf_sample_free;
 	if (emu->ops.sample_reset)
 		sf_cb.sample_reset = sf_sample_reset;
 	emu->sflist = snd_sf_new(&sf_cb, emu->memhdr);
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index 968c8d3f16cb0..152a85013ba8e 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1040,7 +1040,7 @@ load_guspatch(struct snd_card *card,
 	/*
 	 * load wave data
 	 */
-	if (smp->v.size > 0 && sflist->callback.sample_new) {
+	if (smp->v.size > 0) {
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, smp, sflist->memhdr,
 			 data, count);
@@ -1405,9 +1405,8 @@ snd_sf_clear(struct snd_sf_list *sflist)
 		}
 		for (sp = sf->samples; sp; sp = nextsp) {
 			nextsp = sp->next;
-			if (sflist->callback.sample_free)
-				sflist->callback.sample_free(sflist->callback.private_data,
-							     sp, sflist->memhdr);
+			sflist->callback.sample_free(sflist->callback.private_data,
+						     sp, sflist->memhdr);
 			kfree(sp);
 		}
 		kfree(sf);
@@ -1509,9 +1508,8 @@ snd_soundfont_remove_unlocked(struct snd_sf_list *sflist)
 			nextsp = sp->next;
 			sf->samples = nextsp;
 			sflist->mem_used -= sp->v.truesize;
-			if (sflist->callback.sample_free)
-				sflist->callback.sample_free(sflist->callback.private_data,
-							     sp, sflist->memhdr);
+			sflist->callback.sample_free(sflist->callback.private_data,
+						     sp, sflist->memhdr);
 			kfree(sp);
 		}
 	}
-- 
2.53.0



