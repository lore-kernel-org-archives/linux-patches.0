Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2673123AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDECC433EF;
	Wed, 28 Dec 2022 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246684;
	bh=e1R0atgY+TKRwEJiLJwhtP27rBDBejXz4aDMOMqGQFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9vVHXgpPVoSOdzZu35ed/S5uVYm2BPf5uJyFoWY6gPz3R/g3J2474GdrPtlMNpUV
	 0a9JvQp+b4Yud0WrCdAbgqqEUGfcd9C3x7SRI2EXytf6v5q7JBOK6tIKoz2ZaWgVPU
	 b8ot6iRBv8vVMssHFh3nQOuHSPHgKqSvJP30772g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Carl Hetherington <lists@carlh.net>
Subject: [PATCH 6.1 1098/1146] ALSA: usb-audio: Workaround for XRUN at prepare
Date: Wed, 28 Dec 2022 15:43:57 +0100
Message-Id: <20221228144359.992612508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 198dde085ecc0138e4f0b0b69d18a0c870f2dea6 upstream.

Under certain situations (typically in the implicit feedback mode),
USB-audio driver starts a playback stream already at PCM prepare call
even before the actual PCM trigger-START call.  For implicit feedback
mode, this effectively starts two streams for data and sync
endpoints, and if a coupled sync stream gets XRUN at this point, it
results in an error -EPIPE.

The problem is that currently we return -EPIPE error as is from the
prepare.  Then application tries to recover again via the prepare
call, but it'll fail again because the sync-stop is missing.  The
sync-stop is missing because it's an internal trigger call (hence the
PCM core isn't involved).

Since we'll need to re-issue the prepare in anyway when trapped into
this pitfall, this patch attempts to address it in a bit different
way; namely, the driver tries to prepare once again after syncing the
stop manually by itself -- so applications don't see the internal
error.  At the second failure, we report the error as is, but this
shouldn't happen in normal situations.

Reported-and-tested-by: Carl Hetherington <lists@carlh.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/b4e71631-4a94-613-27b2-fb595792630@carlh.net
Link: https://lore.kernel.org/r/20221205132124.11585-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -604,6 +604,7 @@ static int snd_usb_pcm_prepare(struct sn
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_usb_substream *subs = runtime->private_data;
 	struct snd_usb_audio *chip = subs->stream->chip;
+	int retry = 0;
 	int ret;
 
 	ret = snd_usb_lock_shutdown(chip);
@@ -614,6 +615,7 @@ static int snd_usb_pcm_prepare(struct sn
 		goto unlock;
 	}
 
+ again:
 	if (subs->sync_endpoint) {
 		ret = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
 		if (ret < 0)
@@ -638,9 +640,16 @@ static int snd_usb_pcm_prepare(struct sn
 
 	subs->lowlatency_playback = lowlatency_playback_available(runtime, subs);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
-	    !subs->lowlatency_playback)
+	    !subs->lowlatency_playback) {
 		ret = start_endpoints(subs);
-
+		/* if XRUN happens at starting streams (possibly with implicit
+		 * fb case), restart again, but only try once.
+		 */
+		if (ret == -EPIPE && !retry++) {
+			sync_pending_stops(subs);
+			goto again;
+		}
+	}
  unlock:
 	snd_usb_unlock_shutdown(chip);
 	return ret;


