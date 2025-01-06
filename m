Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3615914900B;
	Mon,  6 Jan 2025 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177338; cv=none; b=j5WQeOlbM2jsblKwLtV1vFSwfdiZgIM/4L9CD2fx6qipMv4v+tynPVjotbV68E6/jDiNfPHM6eCN54FirOmdoBJuT8itBOrFFzbRap4B/guvVNg9COqbj153zVqwdACG2jt15xIqUJ1bgWYPddeH6jxya8n44F8eroVOgEbQ3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177338; c=relaxed/simple;
	bh=K6kPso4fdN1noJQauV7oXJp58bBjR+8vtT6v+nPG0sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzMkco2LsBPpwAIDMW82i54a6s3jysZyFAvrmefj28GxS5GiT03ydkbnRbUC/97fFNt+K0hu45d1PLX5gUpz3Blwk4gpPBVB0C+zaIOfO1OU40zDkLEw5kBE9vE17NpfFfZlAh3qFTpuEVLkp/8ZhiFSWFwuPO7oY2D3EUFhjlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AZQR+mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AZQR+mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E92C4CED2;
	Mon,  6 Jan 2025 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177338;
	bh=K6kPso4fdN1noJQauV7oXJp58bBjR+8vtT6v+nPG0sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AZQR+mxfU4Tm4X01J3+U+31k03LXNgkcN6fPaWvTaMDeHSMpWPU5qMzjBOe7BFvZ
	 yXeI7y6CvpiVU1voya47I7WixYBkUMbpk7rd0sSZ2v2RzwTI5qHNL8RFiuw2P0b+67
	 La7fYngjUTIfFPnkDUnTfa72zudrC/Fed9Gwa8G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/222] ALSA: ump: Use guard() for locking
Date: Mon,  6 Jan 2025 16:14:53 +0100
Message-ID: <20250106151153.966653985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 631896f7eaaf8cf8c639b065d3c9fbaa66da5d32 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-2-tiwai@suse.de
Stable-dep-of: 3978d53df723 ("ALSA: ump: Don't open legacy substream for an inactive group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 83856b2f88b8..ada2625ce78f 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1076,13 +1076,11 @@ static int snd_ump_legacy_open(struct snd_rawmidi_substream *substream)
 	struct snd_ump_endpoint *ump = substream->rmidi->private_data;
 	int dir = substream->stream;
 	int group = ump->legacy_mapping[substream->number];
-	int err = 0;
+	int err;
 
-	mutex_lock(&ump->open_mutex);
-	if (ump->legacy_substreams[dir][group]) {
-		err = -EBUSY;
-		goto unlock;
-	}
+	guard(mutex)(&ump->open_mutex);
+	if (ump->legacy_substreams[dir][group])
+		return -EBUSY;
 	if (dir == SNDRV_RAWMIDI_STREAM_OUTPUT) {
 		if (!ump->legacy_out_opens) {
 			err = snd_rawmidi_kernel_open(&ump->core, 0,
@@ -1090,17 +1088,14 @@ static int snd_ump_legacy_open(struct snd_rawmidi_substream *substream)
 						      SNDRV_RAWMIDI_LFLG_APPEND,
 						      &ump->legacy_out_rfile);
 			if (err < 0)
-				goto unlock;
+				return err;
 		}
 		ump->legacy_out_opens++;
 		snd_ump_convert_reset(&ump->out_cvts[group]);
 	}
-	spin_lock_irq(&ump->legacy_locks[dir]);
+	guard(spinlock_irq)(&ump->legacy_locks[dir]);
 	ump->legacy_substreams[dir][group] = substream;
-	spin_unlock_irq(&ump->legacy_locks[dir]);
- unlock:
-	mutex_unlock(&ump->open_mutex);
-	return err;
+	return 0;
 }
 
 static int snd_ump_legacy_close(struct snd_rawmidi_substream *substream)
@@ -1109,15 +1104,13 @@ static int snd_ump_legacy_close(struct snd_rawmidi_substream *substream)
 	int dir = substream->stream;
 	int group = ump->legacy_mapping[substream->number];
 
-	mutex_lock(&ump->open_mutex);
-	spin_lock_irq(&ump->legacy_locks[dir]);
-	ump->legacy_substreams[dir][group] = NULL;
-	spin_unlock_irq(&ump->legacy_locks[dir]);
+	guard(mutex)(&ump->open_mutex);
+	scoped_guard(spinlock_irq, &ump->legacy_locks[dir])
+		ump->legacy_substreams[dir][group] = NULL;
 	if (dir == SNDRV_RAWMIDI_STREAM_OUTPUT) {
 		if (!--ump->legacy_out_opens)
 			snd_rawmidi_kernel_release(&ump->legacy_out_rfile);
 	}
-	mutex_unlock(&ump->open_mutex);
 	return 0;
 }
 
@@ -1169,12 +1162,11 @@ static int process_legacy_output(struct snd_ump_endpoint *ump,
 	const int dir = SNDRV_RAWMIDI_STREAM_OUTPUT;
 	unsigned char c;
 	int group, size = 0;
-	unsigned long flags;
 
 	if (!ump->out_cvts || !ump->legacy_out_opens)
 		return 0;
 
-	spin_lock_irqsave(&ump->legacy_locks[dir], flags);
+	guard(spinlock_irqsave)(&ump->legacy_locks[dir]);
 	for (group = 0; group < SNDRV_UMP_MAX_GROUPS; group++) {
 		substream = ump->legacy_substreams[dir][group];
 		if (!substream)
@@ -1190,7 +1182,6 @@ static int process_legacy_output(struct snd_ump_endpoint *ump,
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&ump->legacy_locks[dir], flags);
 	return size;
 }
 
@@ -1200,18 +1191,16 @@ static void process_legacy_input(struct snd_ump_endpoint *ump, const u32 *src,
 	struct snd_rawmidi_substream *substream;
 	unsigned char buf[16];
 	unsigned char group;
-	unsigned long flags;
 	const int dir = SNDRV_RAWMIDI_STREAM_INPUT;
 	int size;
 
 	size = snd_ump_convert_from_ump(src, buf, &group);
 	if (size <= 0)
 		return;
-	spin_lock_irqsave(&ump->legacy_locks[dir], flags);
+	guard(spinlock_irqsave)(&ump->legacy_locks[dir]);
 	substream = ump->legacy_substreams[dir][group];
 	if (substream)
 		snd_rawmidi_receive(substream, buf, size);
-	spin_unlock_irqrestore(&ump->legacy_locks[dir], flags);
 }
 
 /* Fill ump->legacy_mapping[] for groups to be used for legacy rawmidi */
-- 
2.39.5



