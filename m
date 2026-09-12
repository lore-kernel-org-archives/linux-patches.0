Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26A47DD57;
	Sat, 12 Sep 2026 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219696; cv=none; b=D5VKlTLWCEnX6EG+Trk+8UuCXcUtj4NWWdbpsOLxKa7MQqvVsSY7uY4WrEaxXJLOo6ZpuVSkBgz5w06ayMvThb6xhABSzQafHr0DE7a/r9sLzbKVRfAQtLaqZGuJLMXXh2i098gt/XK3Hpq4UJ4FTnGD/6iu9e4XT6FmdkhKq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219696; c=relaxed/simple;
	bh=d9Uq8R0qJuMvPJIQfeV62IWWzgjxcF2dG466aLBUK3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLXdUbUg1nUDrbDxGe9u+iVT9tNXFCSsT97BCX9oSR1KFs2bP2GLlW5fYUXy8VD8nj1IiWNf2+e3F7IY/vMzCmI2SZUKSCaVP4moajaXrs7o30LZKP7O+Kpu28uU1rbVvHFeSzv6tKnjSVSkPEsX6MK+hY+8nWmSge6Lt17JrB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvzX9OZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvzX9OZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A22E1F000FF;
	Sat, 12 Sep 2026 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219695;
	bh=AxLsdCVgMhlgMONsU4t/6V9GJROKDcx9sPsoUW56Xlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvzX9OZr0fT4rN2YZFXrHwwbomdT3Vw29h7siqyl2h0DmS5tK0z1fMcvyDAz9Ciq1
	 eSBjynXCp053n4rpGMv/4sjl218g42ajbxkSuMzThkpHoJymsiqeAaD84JpMmFi+MB
	 1h+I5edn1spa3GXEYFIWb3wVqeXjB0AN0wgypxAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f8f3acdee1ec7a7ef7b@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0006/1424] ALSA: aloop: Fix racy access at PCM trigger
Date: Sat, 12 Sep 2026 08:40:38 +0200
Message-ID: <20260912065607.431382832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 826af7fa62e347464b1b4e0ba2fe19a92438084f ]

The PCM trigger callback of aloop driver tries to check the PCM state
and stop the stream of the tied substream in the corresponding cable.
Since both check and stop operations are performed outside the cable
lock, this may result in UAF when a program attempts to trigger
frequently while opening/closing the tied stream, as spotted by
fuzzers.

For addressing the UAF, this patch changes two things:
- It covers the most of code in loopback_check_format() with
  cable->lock spinlock, and add the proper NULL checks.  This avoids
  already some racy accesses.
- In addition, now we try to check the state of the capture PCM stream
  that may be stopped in this function, which was the major pain point
  leading to UAF.

Reported-by: syzbot+5f8f3acdee1ec7a7ef7b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/69783ba1.050a0220.c9109.0011.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260203141003.116584-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Karl Mehltretter: dropped the access-mode comparison and notification
  (462494565c27, e299a9fd433f, cdac6e1f7164). ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 58 +++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index a38e602b4fc60..67bbadcec02b0 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -319,35 +319,41 @@ static int loopback_snd_timer_close_cable(struct loopback_pcm *dpcm)
 
 static int loopback_check_format(struct loopback_cable *cable, int stream)
 {
+	struct loopback_pcm *dpcm_play, *dpcm_capt;
 	struct snd_pcm_runtime *runtime, *cruntime;
 	struct loopback_setup *setup;
 	struct snd_card *card;
+	bool stop_capture = false;
 	int check;
 
-	if (cable->valid != CABLE_VALID_BOTH) {
-		if (stream == SNDRV_PCM_STREAM_PLAYBACK)
-			goto __notify;
-		return 0;
-	}
-	runtime = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->
-							substream->runtime;
-	cruntime = cable->streams[SNDRV_PCM_STREAM_CAPTURE]->
-							substream->runtime;
-	check = runtime->format != cruntime->format ||
-		runtime->rate != cruntime->rate ||
-		runtime->channels != cruntime->channels;
-	if (!check)
-		return 0;
-	if (stream == SNDRV_PCM_STREAM_CAPTURE) {
-		return -EIO;
-	} else {
-		snd_pcm_stop(cable->streams[SNDRV_PCM_STREAM_CAPTURE]->
-					substream, SNDRV_PCM_STATE_DRAINING);
-	      __notify:
-		runtime = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->
-							substream->runtime;
-		setup = get_setup(cable->streams[SNDRV_PCM_STREAM_PLAYBACK]);
-		card = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->loopback->card;
+	scoped_guard(spinlock_irqsave, &cable->lock) {
+		dpcm_play = cable->streams[SNDRV_PCM_STREAM_PLAYBACK];
+		dpcm_capt = cable->streams[SNDRV_PCM_STREAM_CAPTURE];
+
+		if (cable->valid != CABLE_VALID_BOTH) {
+			if (stream == SNDRV_PCM_STREAM_CAPTURE || !dpcm_play)
+				return 0;
+		} else {
+			if (!dpcm_play || !dpcm_capt)
+				return -EIO;
+			runtime = dpcm_play->substream->runtime;
+			cruntime = dpcm_capt->substream->runtime;
+			if (!runtime || !cruntime)
+				return -EIO;
+			check = runtime->format != cruntime->format ||
+				runtime->rate != cruntime->rate ||
+				runtime->channels != cruntime->channels;
+			if (!check)
+				return 0;
+			if (stream == SNDRV_PCM_STREAM_CAPTURE)
+				return -EIO;
+			else if (cruntime->state == SNDRV_PCM_STATE_RUNNING)
+				stop_capture = true;
+		}
+
+		setup = get_setup(dpcm_play);
+		card = dpcm_play->loopback->card;
+		runtime = dpcm_play->substream->runtime;
 		if (setup->format != runtime->format) {
 			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
 							&setup->format_id);
@@ -364,6 +370,10 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 			setup->channels = runtime->channels;
 		}
 	}
+
+	if (stop_capture)
+		snd_pcm_stop(dpcm_capt->substream, SNDRV_PCM_STATE_DRAINING);
+
 	return 0;
 }
 
-- 
2.53.0



