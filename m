Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D9F2DC321;
	Sat, 12 Sep 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226590; cv=none; b=hQNWWGDQhbxGDWB/tIEf7UQmtZyZsE61Y9LNCHQMkUA8Y0Nl0lBI95AOdDosRXChOfFY67STiCyBBpd2hP/gGIB3/zsalWXDf+AVKj8sZOeYfXqJ1cH4ea7m47WPpOdGSH4VSb2OVlf1mJQNaTcyl49A0eyN3UoJq1lqVtMG33M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226590; c=relaxed/simple;
	bh=bWm0IExk2D2aWn3OMOMPtc+FTWUxJf0AfAqa+iDmXLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvU0ESMFpPqcZo+8RccMOqS4NZ7zfWCbzWLRYtX5oz4+xXSovhNoUZrGyQpiJnFFQ9FJavrbOKR3JAWGwPCQUfWNjDbfMAU8P6Q9hm/f/n5B4CI3DUVDsXszPaYlXwrmh1W5O/9TsFgvJHmuBookfH8y1NLGkrml7zFH8xUvMDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUY+SEQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUY+SEQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7271F000FF;
	Sat, 12 Sep 2026 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226589;
	bh=gn7xOozbq+C4inGiFG3pA1FzDb/8QOj85nVxMvaWcsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUY+SEQ156BUi3NueJUt4KCtSWgXnm/qtFbmDpEWLo/NzanPWSnm3dCwFsazQr1Sm
	 RnnRGOWO3N8D6zZo9uayTTCj83Jn0tQM3wM50Jp+u60pCAsZcWkC7Vcek1jx1M7t5Y
	 4MQfJCtwdi5sbTqUIxPdFEdU2DNpwn8/Dv7DSoQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f8f3acdee1ec7a7ef7b@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0001/1191] ALSA: aloop: Fix racy access at PCM trigger
Date: Sat, 12 Sep 2026 08:45:29 +0200
Message-ID: <20260912065548.130238817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



