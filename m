Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D683161BF;
	Mon, 13 Apr 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099055; cv=none; b=oZr9K+xwcGzyuJaRdxZKBV42gE1IQ9oYBIXe0a9+r1ziUDKcJz3UK2UGilSqG9oA/rfNyZnxTZLwvTy7dOHUbgw4s6upPNUiJhIcOLJAmEcMCeKwoj1cjFZdbfIsaEaAA7dg3Dz6o6Cx/3ZSeVXK/YZi1nAR3Cxfmd5alfqCo/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099055; c=relaxed/simple;
	bh=X8b0uLa9YbDJrQ/+1jawC2CQJD55BU2ERI9TapxLQRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6FuKytW3wTGFQOgokjxRYrAfC8sfDUlnze2L6r/epAPmkRTQJD819cplcDE7aUi8rQKY63PjpEs6ZlgfXN0mS006yT0M0/PnxtWLa5WJi/Md22Z+X5WjGA22UbGrpWAScxinv1pXxlwT7KGK4OGkg44WgJwGZzPlfnlJitYPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRHzB9Ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRHzB9Ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED3DC2BCAF;
	Mon, 13 Apr 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099055;
	bh=X8b0uLa9YbDJrQ/+1jawC2CQJD55BU2ERI9TapxLQRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRHzB9KeMQKozZaZrBbj/BQI++oA7J+/vZo5MN3FWkZfkmHxE+BCvxTjJrCb8OHVX
	 cBaWJBzqVa+220G7gdJ5FfBhdY9d4Brwsdli1HMlM9/4tePCNzsNpuxOkyLxiYuyqM
	 h9L+wHTfTOQNsoHMs2Dk805HPYtTzpJJld9cRcvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/491] ALSA: pcm: fix wait_time calculations
Date: Mon, 13 Apr 2026 17:57:18 +0200
Message-ID: <20260413155826.295516873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -1843,15 +1843,14 @@ static int wait_for_avail(struct snd_pcm
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
@@ -1899,8 +1898,8 @@ static int wait_for_avail(struct snd_pcm
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
@@ -2155,12 +2155,12 @@ static int snd_pcm_drain(struct snd_pcm_
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
 
@@ -2183,7 +2183,7 @@ static int snd_pcm_drain(struct snd_pcm_
 				result = -ESTRPIPE;
 			else {
 				dev_dbg(substream->pcm->card->dev,
-					"playback drain error (DMA or IRQ trouble?)\n");
+					"playback drain timeout (DMA or IRQ trouble?)\n");
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
 				result = -EIO;
 			}


