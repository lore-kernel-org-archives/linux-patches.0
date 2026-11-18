Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047192;
	b=VpnPFAaIJusi2/w44/kpKYSEkds+P+muDqgcHkfdsahyWOkqwIDtFyU6xs4MsOfSj0qj
	 90DrB43iXfjXNqKrPoWxxx/D6edN/oMuY4IjVoJK5XDWpkLGXX+FG8wk6hSMc7MDR/IMd
	 KflLqGz9BMAc6uR+Q8IiFl+smlxr5jOPVMBvTwZvpqdO8XJyEzGrjVk5inAtJFVBn7HJ5
	 MaaEfVdst9xDwb6YUvrq6Wjyc95TFhw/EaCKc2trYomItipkDuFwHu4Ad4HY6wrD1K6Ur
	 0+ceAPcO/m8rRPDCxqk7IZOjR2+chtSPUShFF/EChhD4MYyMI6zWN/fEJAR+PX4pi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQeC1jTcNBEt/A3RHYMPR1ECydI+iu4A5j3MxixiKew=;
	b=oBdQuvFAs+NxNdXsUpptoeEowJB+R5m75HXrtMPx0vYC7z6NiZXa5rrT8u6yd9B8nNiC
	 zgNgyA5xneGtRnUBSW7E/XCEG79ersqHK6dUO2kXGMH/RceugMDvaGQ4Q1LtSGS0tPyvP
	 RFNBTSGHldxX6LZiDRo9QAoTaVNMdY1L1M5w9Uaj1wRz79pIx8SQNnWo9rr91tGtbevW5
	 4JKUOnvb5gry3zGfhLvDAi6dt4WDRX5RyYQqL+ZpdctOEcAU6QkkdYP6jROohMVxDl1T9
	 wtYqsuvUs0H7npP8sUBgUV+Z38QolDb0s3y5ME4e9824/ob/PGRfq5iS5TzZUrIFl2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwVT6o8b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93518606A33D;
	Thu, 19 Nov 2026 00:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TwVT6o8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B377C1F000C4;
	Thu, 19 Nov 2026 00:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047192;
	bh=JQeC1jTcNBEt/A3RHYMPR1ECydI+iu4A5j3MxixiKew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwVT6o8bcZ+a5RZN3BIJ5ShKN24ZhCu3nSrJYcOG0zN7Me4Kw2dFJxRHa/43uuV3X
	 isrINxHXF5kReSNxm2wXxBbh2a5mvljouT57vUCRZFEWH5T34DJjiwAcJXYKRw325/
	 eaH8OvdsVP/MJD/lI69TIrGQ/vFmDtlMJo4FgtAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1511/2857] ALSA: emux: Stop voices before freeing zones in all cases
Date: Wed, 18 Nov 2026 15:42:25 +0100
Message-ID: <20261118150255.737028736@linuxfoundation.org>
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
index a02f952d74ba2..1b9f69efc2161 100644
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



