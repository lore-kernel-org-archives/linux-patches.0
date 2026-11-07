Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062467;
	b=Q/W0555QE2KU+KcV848Ov/3GU0EF/pzVI5qX/LzW/0asjjogkRQ1Tkn+9tZDpWzNcZ+o
	 hom/WC6GPV/tIVrMKOkScgihAi5NPuG+lllgtfsL6lU97HQCXYEdSr3OFBJe+4q6vE8bJ
	 GzsMnZRiyWKO29gzSkuEikE7s8Zo+9oa1RgHCcz8JnB12RDJbjvmDOXx4qFn2RGnAS6HV
	 eQphyMWf2ox1pgcNMCgRmncVxtOGRmcWy6UP8Cq5Xp6jUwKKFDN1PltuwzfejSG5VJ2Ob
	 F5P0cZ4qHDSHk37LqpXzBgc/TE0L/hXF8nlE85XsxULmYsdBxnzk7vOrq+IRbHXJgtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZdYKT17pieJpuQuc4lYQiEf/vOvtEVFepU7yrFE/wg=;
	b=mZ+oAMm4rRa9JYc6VqbxEoU+Y3pJkU1iYdGkHqWep4CR/18ayiMpuWXg4x6zE+m+sqlN
	 lFQHylmekyvFtSny5B2nKCK1idHg59HpjfSPF2Ty9InyVMtUsC5LlKyJ7RO6MtSz8QPef
	 I9M0con4SbfhpZwLvPs9juM3O82tHQTlWo97b2DTRabGE7lWsG+EUshoC2j2SCPORoIEO
	 rwU+I5Z/cIXwKAtAcYHsanTtmfk9lIuIFxKrDm+uf9ku87e892OL9GcjijSQ4mfpLH1w5
	 YulnAr9KaGg9Fu0w2EDu0n7X7lTe9lz9+LyoM9pYs9TUnwSFpfJw/gg8KUXMMAfSgnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L1We/1Z1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E026D606A662;
	Sat,  7 Nov 2026 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1We/1Z1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5B61F008A1;
	Sat,  7 Nov 2026 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062466;
	bh=JZdYKT17pieJpuQuc4lYQiEf/vOvtEVFepU7yrFE/wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1We/1Z1TYY45wVNWYJMlqom2AMeNJoyiNCK5YjDsJ1vqJCQsEjgitbv2Gmp5/8nf
	 9efwC2PF85z2RFj9ublAeEhJ95kscpzzZa3x0qkrqEuh7NqYbIc8Z9Pp+TBDL19786
	 FvbP4z/NsmTvB8R71FsfYxk69kNEkKDgRKztnGAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1372/1536] ALSA: emux: Stop voices before freeing zones in all cases
Date: Sat,  7 Nov 2026 08:56:28 -0500
Message-ID: <20261107135036.375475733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit 8a5d87c2ba30e8de31cfbe888fd4d95f43c63db9 ]

The emux voice caches the soundfont zone pointer in vp->zone, which
is referred to later, e.g. in snd_emux_send_effect().  For avoiding
dangling pointers, the soundfont code calls the sample_reset callback
to stop all voices before freeing zones.  However, in a few cases
(e.g. emu10k1's missing sample_reset or the call path via
remove_info()), the sample reset isn't called properly, leaving the
playing voices.

Fix it by always registering the sample_reset callback, falling back
to snd_emux_terminate_all() when the driver has no own ops, and by
calling sample_reset in remove_info() before freeing the zones.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020101624.205638-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux.c      | 10 +++++++---
 sound/synth/emux/soundfont.c |  9 +++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 01444fc960d08..863d35aff1960 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -71,7 +71,12 @@ static int sf_sample_free(void *private_data, struct snd_sf_sample *sp,
 static void sf_sample_reset(void *private_data)
 {
 	struct snd_emux *emu = private_data;
-	emu->ops.sample_reset(emu);
+
+	/* stop all voices that might refer to zones and samples to be freed */
+	if (emu->ops.sample_reset)
+		emu->ops.sample_reset(emu);
+	else
+		snd_emux_terminate_all(emu);
 }
 
 int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, char *name)
@@ -96,8 +101,7 @@ int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, ch
 	sf_cb.private_data = emu;
 	sf_cb.sample_new = sf_sample_new;
 	sf_cb.sample_free = sf_sample_free;
-	if (emu->ops.sample_reset)
-		sf_cb.sample_reset = sf_sample_reset;
+	sf_cb.sample_reset = sf_sample_reset;
 	emu->sflist = snd_sf_new(&sf_cb, emu->memhdr);
 	if (emu->sflist == NULL)
 		return -ENOMEM;
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index b38a4e231790f..47137cca50b8c 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -485,6 +485,15 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
 	struct snd_sf_zone *prev, *next, *p;
 	int removed = 0;
 
+	/* stop voices before freeing the zones they might refer to */
+	for (p = sf->zones; p; p = p->next) {
+		if (!p->mapped && p->bank == bank && p->instr == instr) {
+			if (sflist->callback.sample_reset)
+				sflist->callback.sample_reset(sflist->callback.private_data);
+			break;
+		}
+	}
+
 	prev = NULL;
 	for (p = sf->zones; p; p = next) {
 		next = p->next;
-- 
2.53.0



