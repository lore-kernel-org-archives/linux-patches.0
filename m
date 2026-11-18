Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025955;
	b=qmg0XqXNleCNNwMqSmVjYfq4n03CVF3nL8/F93OoszPVR+O6uQGfgYUTztX0oDlhY3pD
	 6cWWIagKdgYKn8Ux5gOJzP7EEA9iqGxGmSgkcsWEOoDNiEVNEiYp/8DsLZ/a8wx9FFPCO
	 ZffC+LszmCFwmJl21CgDTF9HlBQpkDcnjbpRAqdWa2Gbvw61LYzW7/Z/CB6ygVprLQVmH
	 C/FJBQAvrq6dRnTYrl1ib8T2oTYEdW0IIaW8uQXE0+up1+sKPfdPpaGukOGcTX4iVEafs
	 JgtV1y8S1VA2l6cwIWivCX107vm34Vw8zOEu0iUvpwTdtEAXIsOyvh4DCTWA1yBqrRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1hzzBAu8ZJAkOsQLENV2RinW6eeMfP4vgGK4+p8gAzU=;
	b=r0PdzAI2DpsLh5nC7jZ30XQS5+KOoo0PblP65JnJeVlnHkRd0YYS7AvElOs/zRtygmE3
	 0wu0SBu8Nl5/faF1zkP95x4hahbDgPLGkbk9sNEaWntyfDFwVjDjr79FOUp7PM4EuV+Ph
	 wbSot0Tv/oyMzUzvTX2UX2ml4IQTgN+G4zwww2+TttwgAkVcctvu5eclc1Qk4+DmmvXYR
	 SAxTLIIFlMKf2yPvSvayEyJJYT3WnJCpxM0MJOYIcYUl60onGLrICjvZztCJuQIzG3sS7
	 hMSnf4eGOelrOoMeNfvXs7hmg+08YuTz6Z/4APFHPV2DCyTkrKRL6qAaduBF6lKjzmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4N7BOa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2109606A32C;
	Wed, 18 Nov 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4N7BOa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07DF1F000C4;
	Wed, 18 Nov 2026 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025955;
	bh=1hzzBAu8ZJAkOsQLENV2RinW6eeMfP4vgGK4+p8gAzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4N7BOa5clwC9SaFdrG7TPg0U7ghmEzyMz8aLcPMf4UTHvZQwfXQuthbw1AeE1Trd
	 8ZRH02S9OA3kPSrZOiAAQmPogZnQ5cMVAFg362GmqAQ50IyJ3yfunqyck8jxWAVa3R
	 tR/LG559YEdp3Gd5gkOz75IdfkTWCc9HxZPREJt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1263/2151] ALSA: info: Fix memory leak at card removal
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150208.155321654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit a3e8eec7692eac706ba0934fa18453e46acd1a08 ]

The fix for potential deadlock at disconnection by the commit
c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
clears card->proc_root pointer at snd_info_card_disconnect(), in order
just to be sure.  But this leads to a memory leak of card->proc_root
content that should have been released at a later call of
snd_info_card_free().

For addressing the memory leak, simply drop the card->proc_root
clearance at snd_info_card_disconnect().

Since card->proc_root might be still looked at in
snd_info_card_id_change() that may be running concurrently during the
connection procedure, add a sanity check there, too.

Fixes: c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261006174002.703431-1-tiwai%40suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index 1f5b8a3d9e3b6..ce5caf28f041b 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -528,6 +528,8 @@ int snd_info_card_register(struct snd_card *card)
 void snd_info_card_id_change(struct snd_card *card)
 {
 	guard(mutex)(&info_mutex);
+	if (card->shutdown)
+		return;
 	if (card->proc_root_link) {
 		proc_remove(card->proc_root_link);
 		card->proc_root_link = NULL;
@@ -555,7 +557,6 @@ void snd_info_card_disconnect(struct snd_card *card)
 	if (card->proc_root)
 		snd_info_clear_entries(card->proc_root);
 	card->proc_root_link = NULL;
-	card->proc_root = NULL;
 }
 
 /*
-- 
2.53.0



