Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063524;
	b=SOlXwWQSxjkJHOlofWoekFk0lPOkFaJHCbF398lOq0scoiQ6CagjVCh7hxSwliM0xPVU
	 YD6dUJL9J+YNZSN1kG8C3IJITl7g3tsyJHWlSlJsyREiXCs3vwImjB3uAixYXibdOEQgW
	 Ctn6IsahB1cMJWHNm75cSc/DmoCDWdfpAz9/FxnHQMT0T2jgiRg+stnvkfPKptW+jaPlo
	 hXl0Eu0QON/oZJhVP5iESzfiB0uyYuMQzHnITnQPy5tsjX2oPYlYrKhcGnFlVmwtJbKsz
	 Dqtwbf9ckCpBKbNc+zqxFkGefz6P0RpMbwgknUwLhhhlERAQXMu6H3lzMlWNuVzLeSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwXk5/pv+nGa/ZmVY8ntn6rZeTGeCntspf9d7kHSbZM=;
	b=TEoB7V3EsoR/S5IjK/RCE83LvIKmF+ewWR2A6tibVquUKvkgxNt2GZ9zMMHlIA4wCD3k
	 WYwUJUqaZZuOTlK9rjzAKT/ADz21zvuM57zDF2trW3wQJGYYCObGYGDcmoqAJJJyhEwn8
	 qKNDr6oR1R9Mpd48AcqFVUyqTHLO7vpC1V4upqGvLGHsdgVUI+hOrpdNpynQoDVJj3clc
	 diE/0vptwN1QHf9uu/JPkanGKcXs7IFzKTnnWmqmEvSy488vKY+yHMO0YjAH2ap7wjgAw
	 gNssxyhdPJkWodzExnxgdq/8IruvP+jhEOc8Cxay1+Qhs25ZyPxZYoCkN1ehvR74vkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVzs2Aev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF2606B8BD;
	Sat,  7 Nov 2026 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVzs2Aev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F47A1F0089F;
	Sat,  7 Nov 2026 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063524;
	bh=qwXk5/pv+nGa/ZmVY8ntn6rZeTGeCntspf9d7kHSbZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVzs2Aev8Uy+e2su55Ut+hXyeHSEgn8C7bZC61ORywirnh+8V90AfowLC4OQXjR66
	 Q2PZaPAZprep10ojdNmKwBaOKQ9gRfkFHmjHW5hALwtmRUezWICU+UyrGEtt/U9ni5
	 sQIxnzMeInBG7Z3yPXvdnQAYyYjwRpGXrIj3gOK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 664/869] ALSA: emux: Stop voices before freeing zones in all cases
Date: Sat,  7 Nov 2026 08:55:46 -0500
Message-ID: <20261107134915.665131624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 30793a131746e..2f8ba39d4a6f6 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -443,6 +443,15 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
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



