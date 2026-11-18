Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038512;
	b=jOOa6IWIJajGiAP+Ci7FNcdtj8qOUZnWPHF8NPUYLj0L0TQX86oZ7a07/Lm7HN/qAg3t
	 g3jaufab3Xdz7AR1yCumo+rZMDDN+YdhOEZB86nfO+U12aslkXTIa09qTVg3L4TT0o/ot
	 whgXmM8kacECZDP6LzTz2JFCwsoys1v7KRW0HtF9sskoRTffLkAaqCBOmJpwSX96reLXh
	 WIM+RUDS+GNIPzHGopACE8cfvYC9x/f5ehMLEsZiQZRLBhs3md/qFQCruEfpk6y1WdVHG
	 0NFKQAcGPYkL81G/Ut1C8hrBkHefiwnthPUpv7FK3Sn31OY1inbpcpXN9DfzvB69Jcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=magrnoyNKnSqw8YRVx0JlGOiOpE8HjuKs+BoHVuo0lk=;
	b=LMZKoeNRg8KFx8GarcmrNiOhHmIeTl44Vt+4Cf0L6uqDCe9GMAQs/Zu5CfQslPwKrqoU
	 nrimzsmthoOmV+u1ofaKdJviEc7RQXTpdnqYzJw8oQk6uhBTRY0jT8YqarauEqW4yDu8b
	 aoptIPw54y0NVJ7jVGVFp9yR1K5gr5h6mvzq/TJAcpMgdu2SCBYWDrTQHjjoIHJnjJVkB
	 rAF+1/533PXhP+lPKeOaNmo3Ogdz9m6UaiCMqU9YFEgX7HAJpsSl9CrYGEAUeqa5IkClG
	 IxlnZkKDhSIffEHqytl/HPtImDYWCVlyCuxmZwOOowsMHm4y+si0GFPzmbxMFCMDkhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJn040wg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958DA606A335;
	Wed, 18 Nov 2026 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJn040wg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4161F000CD;
	Wed, 18 Nov 2026 21:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038512;
	bh=magrnoyNKnSqw8YRVx0JlGOiOpE8HjuKs+BoHVuo0lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJn040wgxSRD3N+v/fGURBwT1ZSGK85+WM4PupZENr86yWLt5RmOF7QIn6T747pwG
	 BDsLvIoolWAbqQrrZ9kGH6D+S1TJL5GiRQ61ymnUtHBCVSMV7qLXiHyyL/1JShyHz/
	 tVLoo+FYwk7YfT0GMHp7F+H77kgu2KvHKe2scK6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1768/3318] ALSA: emux: Stop voices before freeing zones in all cases
Date: Wed, 18 Nov 2026 15:39:50 +0100
Message-ID: <20261118150414.894353312@linuxfoundation.org>
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
index 7966590f2edbc..97b930f0fd041 100644
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
index 152a85013ba8e..e6d282668771d 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -470,6 +470,15 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
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



