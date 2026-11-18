Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047181;
	b=3mCd1Xs4g6NWfw4PJD0AXGJkhe8+4vqxa4SKs08Bzn0Z5I4uMEYfjwehPn5IxxlSjDRi
	 nJNjRbZb+zQkZi7jQ7YCEIg/EfASm+MV1bSGVE0emcIgCqzHd4MEdewk3RPnX0e2g0+nW
	 PZmZT0QAh+wjFq+sgbbaFqNuy10qrVdXEwBsLU+N7+XaSgI/uwRclqB81CTKG7TnY/LqL
	 yaCaYTaEy+yDuIQSrDvv59lQ3MtXmrRajst4a4ES5iuMPpqFZN6SMSwA9U5xflB6u2cKp
	 mcmWxwRKYqNKbaGl7o/9Yrrls3fo3HoiZ1WjG+HBj2LmEv0k0623Kxptla9zL9AeKzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvyPu/oeD5ZWPn6FtAxsALDGIf2lciutoXyh9T04f1s=;
	b=O5OZUpKVfkg0+IiGFdZpY6cgObrs9YJ1ZlrsqQkHItZS7UWqxlk5Lg7UPwMc8fdhH198
	 TgImhsq2fymI745vTxmbq4xSZ6SrrcsN4Mput0WCb3kdQrcXa+QR6OzwDDy3XgqlnxArK
	 9nVL23IRaJ5TX7vJ47Apqt2Rs61TmsCkczy3QhT+arrK44gW+2LkN7/P2nigun8JAiuYC
	 /Pv03EFLuYMkhc4+Q4HnTJ9nbDLossbEAml+wMzGYhiJmzl96k40dBhkZeB1W3hC+n4M/
	 spcQWAW9cRtPY8v7KDtu1quPva+rpV6NesMvujbALGDet/BJjkKylSVNzi2GGeVj57w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVSzUe0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649D9606A335;
	Thu, 19 Nov 2026 00:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVSzUe0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B525E1F000C7;
	Thu, 19 Nov 2026 00:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047181;
	bh=tvyPu/oeD5ZWPn6FtAxsALDGIf2lciutoXyh9T04f1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVSzUe0WnU3v3c/jeO5fdPKwWDjHtONPO7hUsGb1FY59Ha8V5UZUpda7jhVOsoD8D
	 UQ56S4rKq4Jtb/vvAAAy7uXYuzOrOAgXzLnD24rqj0nOV2698zkJI1ce+Lq91TQbjS
	 GVW013yqITLBhN1n3T5lhjzePxOFSx5Eg6QdRdFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1510/2857] ALSA: emux: simplify snd_sf_list.callback handling
Date: Wed, 18 Nov 2026 15:42:24 +0100
Message-ID: <20261118150255.701416893@linuxfoundation.org>
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
index a870759d179ed..a02f952d74ba2 100644
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



