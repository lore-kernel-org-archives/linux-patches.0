Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D848820D;
	Mon, 31 Aug 2026 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184997; cv=none; b=HW0tjYxcJ/D6qZvhpoqCwImngbXYkz3mT+c6EezqwHdLmtWOiJ5T/7mWZW6IqdsATzAyTaFHpyT47A4Hs+jlrTgsUqwXnk+Re2HGVantSDfo7Lra2bxB+ApeaHHayHxOCIFPyn47aZsg1+52VKeEX+HwebKtf7qjEDTZPLEgAX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184997; c=relaxed/simple;
	bh=zxIHIuacRhoVsyZ6Anyw+3FE+qS6pf/psODUIyiQUbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaI1ELj0aF/x/4f8n4KKRHWTQJ5msZqLUxCPqEFJ4k6zU8iBgSf9YfdIeAWmQ0yCXKdVknrmmEieZp0NOqVa8tAXmPArkhRs4az5fgul0OnpGEhHX1cx3vUgX+Xf4wGJ2v7+e4nyIpYjwvuIpUQwqjA8VYvTOLYPs9FZItJS11w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FEmqcuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FEmqcuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AA61F000E9;
	Mon, 31 Aug 2026 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184996;
	bh=ShXh5Lvwf0AsZeRDVmuRut6tsQt5PxL3pbyH+omuHM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FEmqcuZJXLNsJj1FEwn9Zk3Rtwk6a6KiMSYwyPwvI/fneax08A1DzYvQwvL6Dlff
	 Xj1hlTt0MlrlfQYPISooSVkWFmuvbkMhz0q8d4Q4eHoNQ/zFtDQDZYmLrWrTx1+TUW
	 zcfZPptv6OLOXJW3syhccO75KCqxj5gtySH0ZhkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/69] ALSA: pcm: fix wait_time calculations
Date: Mon, 31 Aug 2026 15:34:51 +0200
Message-ID: <20260831133359.368274943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_lib.c    | 11 +++++------
 sound/core/pcm_native.c |  8 ++++----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index f319e4298b874..38671c4737f51 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1877,15 +1877,14 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
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
@@ -1933,8 +1932,8 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
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
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 94e3e3ba6a33a..831633edb77b6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2170,12 +2170,12 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
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
 
@@ -2198,7 +2198,7 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 				result = -ESTRPIPE;
 			else {
 				dev_dbg(substream->pcm->card->dev,
-					"playback drain error (DMA or IRQ trouble?)\n");
+					"playback drain timeout (DMA or IRQ trouble?)\n");
 				snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
 				result = -EIO;
 			}
-- 
2.53.0



