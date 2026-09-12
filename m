Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475BE26ED46;
	Sat, 12 Sep 2026 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240817; cv=none; b=P+5IIL5WTZLHif1xs/t5TGH8L3yMbyidSm3S9vdHFyyNjndbIsYGuAWSN8dZ+K326eIt35XHUx0vzFNRMhnJvagmredezRMM0xShLgRROOzxhtbTbat6pXh1O48TL55HNZlDea5tAQEme6i81syrydI7ZoKV+r12swQbEi02WL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240817; c=relaxed/simple;
	bh=lDUf+l6oeju+v1MHQv8hrJOrGCsSxFkUtFwPj76YsMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKgeZ4Y/xhW2WYx1dnUH5uQncTrcIkhO5VpFqB89cBElUcuhOEQ5EZSZVVZ4eep5SWalU+1CUJEjL8233w6GaxZs+CyLAyDLsKDYUrKZteuioOupL1GmdXSXHuNfdDqjloRgdsNFjjzvLd0PsZr5pjLI9ZBTgy+h9LIU59Mp8KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lH5z67R9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lH5z67R9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04AE1F000FF;
	Sat, 12 Sep 2026 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240815;
	bh=yKodGsI5L1dhOzpPrVvy3sl+XCTvRMwPgzoSHyS6B7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH5z67R9liTr5X1LdD5LtJvM3KBHF/pex0jvYjF2AS94ZmpLCtfTePkEPt8/GauDH
	 7c26xuBvAWJPfEL84zGlWuN8yOuMfseSdF1GN4QHGMOkN4gWdB87EhUZu9POyP7K/X
	 NZmVC9LDmel3+0uPJqb5yQFUOQYUhvataw3UGjiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f8f3acdee1ec7a7ef7b@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/798] ALSA: aloop: Fix racy access at PCM trigger
Date: Sat, 12 Sep 2026 08:53:50 +0200
Message-ID: <20260912065517.012001172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Karl Mehltretter: open-coded spin_lock_irqsave() instead of scoped_guard();
  used snd_pcm_running() instead of cruntime->state; dropped the access-mode
  comparison and notification (462494565c27, e299a9fd433f, cdac6e1f7164);
  kept the stop_count handling from the e5c33cdc6f40 backport. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 99 ++++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 40 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 314ced32efbbc..3901f52164933 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -323,56 +323,75 @@ static int loopback_snd_timer_close_cable(struct loopback_pcm *dpcm)
 
 static int loopback_check_format(struct loopback_cable *cable, int stream)
 {
+	struct loopback_pcm *dpcm_play, *dpcm_capt;
 	struct snd_pcm_runtime *runtime, *cruntime;
 	struct loopback_setup *setup;
 	struct snd_card *card;
-	int check;
+	unsigned long flags;
+	bool stop_capture = false;
+	int check, err = 0;
+
+	spin_lock_irqsave(&cable->lock, flags);
+	dpcm_play = cable->streams[SNDRV_PCM_STREAM_PLAYBACK];
+	dpcm_capt = cable->streams[SNDRV_PCM_STREAM_CAPTURE];
 
 	if (cable->valid != CABLE_VALID_BOTH) {
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
+		if (stream == SNDRV_PCM_STREAM_CAPTURE || !dpcm_play)
+			goto unlock;
 	} else {
-		/* close must not free the peer runtime below */
-		atomic_inc(&cable->stop_count);
-		snd_pcm_stop(cable->streams[SNDRV_PCM_STREAM_CAPTURE]->
-					substream, SNDRV_PCM_STATE_DRAINING);
-		if (atomic_dec_and_test(&cable->stop_count))
-			wake_up(&cable->stop_wait);
-	      __notify:
-		runtime = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->
-							substream->runtime;
-		setup = get_setup(cable->streams[SNDRV_PCM_STREAM_PLAYBACK]);
-		card = cable->streams[SNDRV_PCM_STREAM_PLAYBACK]->loopback->card;
-		if (setup->format != runtime->format) {
-			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
-							&setup->format_id);
-			setup->format = runtime->format;
+		if (!dpcm_play || !dpcm_capt) {
+			err = -EIO;
+			goto unlock;
 		}
-		if (setup->rate != runtime->rate) {
-			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
-							&setup->rate_id);
-			setup->rate = runtime->rate;
+		runtime = dpcm_play->substream->runtime;
+		cruntime = dpcm_capt->substream->runtime;
+		if (!runtime || !cruntime) {
+			err = -EIO;
+			goto unlock;
 		}
-		if (setup->channels != runtime->channels) {
-			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
-							&setup->channels_id);
-			setup->channels = runtime->channels;
+		check = runtime->format != cruntime->format ||
+			runtime->rate != cruntime->rate ||
+			runtime->channels != cruntime->channels;
+		if (!check)
+			goto unlock;
+		if (stream == SNDRV_PCM_STREAM_CAPTURE) {
+			err = -EIO;
+			goto unlock;
+		} else if (snd_pcm_running(dpcm_capt->substream)) {
+			/* close must not free the peer runtime below */
+			atomic_inc(&cable->stop_count);
+			stop_capture = true;
 		}
 	}
-	return 0;
+
+	setup = get_setup(dpcm_play);
+	card = dpcm_play->loopback->card;
+	runtime = dpcm_play->substream->runtime;
+	if (setup->format != runtime->format) {
+		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
+			       &setup->format_id);
+		setup->format = runtime->format;
+	}
+	if (setup->rate != runtime->rate) {
+		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
+			       &setup->rate_id);
+		setup->rate = runtime->rate;
+	}
+	if (setup->channels != runtime->channels) {
+		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
+			       &setup->channels_id);
+		setup->channels = runtime->channels;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&cable->lock, flags);
+	if (stop_capture) {
+		snd_pcm_stop(dpcm_capt->substream, SNDRV_PCM_STATE_DRAINING);
+		if (atomic_dec_and_test(&cable->stop_count))
+			wake_up(&cable->stop_wait);
+	}
+
+	return err;
 }
 
 static void loopback_active_notify(struct loopback_pcm *dpcm)
-- 
2.53.0



