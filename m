Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053965;
	b=gQ0U0YAz+jyei1PWs94cM5MlaKfS31Pbr8T0MtoDHHsXTCg8WTKWdX58hRDjh1ay098f
	 o10199XugYwqNGNCeBcjQumjILwmeAXQtB/H9IjR43gUSwmErcItCn9fEuqLAYvdzfnxr
	 +WjTbLOg9mRf7Fmg8mkL3mGeWm5n5Jvbvyj4IEHFqNYpnv6As9t/NOfn+HgPEQhLQJXyE
	 Efp+uWLHplVn8poOHHXizrDTHKvZ2uSdJt0eOiCm0K8VyVZIqd5IGc0BVFQvkHgyVzVTV
	 miZ1BmUgK03SeWW6guLK/fVzh9uFI4vwa5/+B3so85PpvgvvgciLyA01OnsKZmK+n8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIySBPTgVZlde/nwcZjoS2fs6pj+Dbvr5dCL3cJUpNw=;
	b=I5io6892KkyaLBfNbjvERvvWH7W3Jo5yqa0IzjiwE61hslOS7hs7l+KrvGUNvEmnOJok
	 4/1PukJTNRW3D+XirSQSucYBAxFgjlYgjll4UmTQPMPgbdPDow12r6JJ28ZMgedbqxuJw
	 C5HLT4Zwf+pus7u61hbYyRpZbDqU2gRbfVWcLeqJsSMeo/EoHhxzUSMuvgE0elZMLICIF
	 JtpUXgm8AGi4MD3r320+aIsWKqCGRE3PfpKP4QwOwdqjmghfxwQP+/llSBNyb9jipVAuW
	 TBBhpO2qw4PYvGLHfOEVON+Af2fk636AMEYhdS+h2323Rr8SbA7nfkyTuY+wCV8gWpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XF79KG7k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CE2606A32A;
	Thu, 19 Nov 2026 02:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XF79KG7k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399121F000C4;
	Thu, 19 Nov 2026 02:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053965;
	bh=VIySBPTgVZlde/nwcZjoS2fs6pj+Dbvr5dCL3cJUpNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XF79KG7k02Sl+THHsvld8xPtli+0EoFJ6RhW8h6tE0Z71zOGsrpemG8eQXAY/05Im
	 fZ4imSDn3QKuZyfoZbYvQuEFrtnRG05L429JyuW0WPNkP0tKb0fFOe83fLUeUibEjh
	 7/PZPdWG2sdyvP5vpHYXp4qv6EB3d1tWyA3UhWJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1105/2214] ALSA: emux: simplify snd_sf_list.callback handling
Date: Wed, 18 Nov 2026 15:46:21 +0100
Message-ID: <20261118150056.370625771@linuxfoundation.org>
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
index 6c5751bf6ed6d..f7155ce59b417 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1052,7 +1052,7 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 	/*
 	 * load wave data
 	 */
-	if (smp->v.size > 0 && sflist->callback.sample_new) {
+	if (smp->v.size > 0) {
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, smp, sflist->memhdr,
 			 data, count);
@@ -1416,9 +1416,8 @@ snd_sf_clear(struct snd_sf_list *sflist)
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
@@ -1520,9 +1519,8 @@ snd_soundfont_remove_unlocked(struct snd_sf_list *sflist)
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



