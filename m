Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8283E3AEF5C;
	Mon, 23 Mar 2026 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282972; cv=none; b=E5jcab2stspN5g1Z2o2IpI4VT4/vmKvjYSCDKmsnsvgS6oSXFTMg+klHZuGK7yxI7k6EUBBTs1RpPk62NV8Yeb4cUCAy1QjNG9FxmlB5TqDKJkYtVZbRRzdpNKEDKieEQj48RWDMrMvE4W6ciBtX/QEZes2J0tKKobBUuC7Abtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282972; c=relaxed/simple;
	bh=2Lol6uKFcFLIUY/CVnW8F0+zXfoblw2T3gZ6NtmBllo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1AVPxi8RZk6HJgFY0aHZMtfoduYCeRnH/TW0jcyE/ZXlwuPWsrOByZWsaN7clG3vz7+TpiIeo4rXe9EMOxPuKrcMQ6XF0PK+NzAg/KDHFEF6iBNOjVhcaghbmiZzGqEXUr3JVhh82XXYGFl3RXF6TRx5y9pFu8kn/PrEAlPv3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkVuhlrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkVuhlrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED96C4CEF7;
	Mon, 23 Mar 2026 16:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282972;
	bh=2Lol6uKFcFLIUY/CVnW8F0+zXfoblw2T3gZ6NtmBllo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkVuhlrWg2zGfDDqEJYSjJQeTNHANGiJ622yUxkEde48SrOj29g1LxULoc62kaQT3
	 cuZKC3XkKY59USZS0u4OUQJrLJ9U9heyJ0GE3JIAOXSVowi6Bh+YpwrXOSNlDrgb9i
	 rDjNkYaBLDzoZbOA3b6Pzi3m7iYPaClHhNKpVRGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 327/481] ALSA: pcm: fix wait_time calculations
Date: Mon, 23 Mar 2026 14:45:09 +0100
Message-ID: <20260323134533.074024119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 3ed2b549b39f57239aad50a255ece353997183fd ]

... in wait_for_avail() and snd_pcm_drain().

t was calculated in seconds, so it would be pretty much always zero, to
be subsequently de-facto ignored due to being max(t, 10)'d. And then it
(i.e., 10) would be treated as secs, which doesn't seem right.

However, fixing it to properly calculate msecs would potentially cause
timeouts when using twice the period size for the default timeout (which
seems reasonable to me), so instead use the buffer size plus 10 percent
to be on the safe side ... but that still seems insufficient, presumably
because the hardware typically needs a moment to fire up. To compensate
for this, we up the minimal timeout to 100ms, which is still two orders
of magnitude less than the bogus minimum.

substream->wait_time was also misinterpreted as jiffies, despite being
documented as being in msecs. Only the soc/sof driver sets it - to 500,
which looks very much like msecs were intended.

Speaking of which, shouldn't snd_pcm_drain() also use substream->
wait_time?

As a drive-by, make the debug messages on timeout less confusing.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Link: https://lore.kernel.org/r/20230405201219.2197774-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 9b1dbd69ba6f ("ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_lib.c    |   11 +++++------
 sound/core/pcm_native.c |    8 ++++----
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1878,15 +1878,14 @@ static int wait_for_avail(struct snd_pcm
 		if (substream->wait_time) {
 			wait_time = substream->wait_time;
 		} else {
-			wait_time = 10;
+			wait_time = 100;
 
 			if (runtime->rate) {
-				long t = runtime->period_size * 2 /
-					 runtime->rate;
+				long t = runtime->buffer_size * 1100 / runtime->rate;
 				wait_time = max(t, wait_time);
 			}
-			wait_time = msecs_to_jiffies(wait_time * 1000);
 		}
+		wait_time = msecs_to_jiffies(wait_time);
 	}
 
 	for (;;) {
@@ -1934,8 +1933,8 @@ static int wait_for_avail(struct snd_pcm
 		}
 		if (!tout) {
 			pcm_dbg(substream->pcm,
-				"%s write error (DMA or IRQ trouble?)\n",
-				is_playback ? "playback" : "capture");
+				"%s timeout (DMA or IRQ trouble?)\n",
+				is_playback ? "playback write" : "capture read");
 			err = -EIO;
 			break;
 		}
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2172,12 +2172,12 @@ static int snd_pcm_drain(struct snd_pcm_
 		if (runtime->no_period_wakeup)
 			tout = MAX_SCHEDULE_TIMEOUT;
 		else {
-			tout = 10;
+			tout = 100;
 			if (runtime->rate) {
-				long t = runtime->period_size * 2 / runtime->rate;
+				long t = runtime->buffer_size * 1100 / runtime->rate;
 				tout = max(t, tout);
 			}
-			tout = msecs_to_jiffies(tout * 1000);
+			tout = msecs_to_jiffies(tout);
 		}
 		tout = schedule_timeout(tout);
 
@@ -2200,7 +2200,7 @@ static int snd_pcm_drain(struct snd_pcm_
 				result = -ESTRPIPE;
 			else {
 				dev_dbg(substream->pcm->card->dev,
-					"playback drain error (DMA or IRQ trouble?)\n");
+					"playback drain timeout (DMA or IRQ trouble?)\n");
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
 				result = -EIO;
 			}


