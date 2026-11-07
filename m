Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062426;
	b=YCfFc/rGKmVdinEfsZzipaLb/N39mbrGyyEX6qX6kkP9DwlkA4vqIzDhn5EZh2S3WkD3
	 hPFhSUv1U2xsVbJEMu+snrk6lFfIYH/BusASR1+Y3nQT4tQJrdapFsaEsaT9/SziRzJGu
	 tAYpfku4gPLjVxallIPeZAhphSeDmH7R+rEA9DCJmrx16vcJGAayE/lTCB3CSL3+rOmBa
	 a1/K0UZTuxHF6rCgbjxXOTkjDyZyopI8d46CAHRiYHV13oMvHobQbrF/EhU+9+YuPGHBV
	 7Wu07g0g83WoWBtrjH5Cui6exIcDrAvWtoX4taR6Pv51OcrJJa+nNM/7e3SSx/WOqQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9q+69flnQ9e570X38U946/eagPcR//FlsaV8K/vmhE=;
	b=YOuWAfJM6HhPrMf/iLErAPqdgT+zLw6dKc83lSfrxhBJMnPMfBGYVnO+B0aYbnb/cCGO
	 /5tQfLICgj3bde6V4ppcbfR/mJWn2L3JYIHcq2ZbLUvJzNhts0jlZoomQrg20mVeRPloJ
	 hZN4lPpq+eOmrgEiILUmhGYtbpKUDYU0j8yr6qJ0LlZS2wkaru8ZpKW/j4sxX665Eckq+
	 cWhvYM9A2mCVy3AY6SDVUlsKm+RSwrVgTdhxPROkb4DH0kjpRc0L/FrMHP/Ej93igk0un
	 MMCUjJT1KQk27Z9s4+kYHN7TnPVj4BAxjPoyTLNj0DB09lDW6DE8KUXCrwPgcowB9Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvP2DtXW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9953C60A261F;
	Sat,  7 Nov 2026 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvP2DtXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450F01F008A2;
	Sat,  7 Nov 2026 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062426;
	bh=F9q+69flnQ9e570X38U946/eagPcR//FlsaV8K/vmhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvP2DtXWKnn8VuTQu78DOXWTUN2zgRjtYnk2UFdmn4Ma20NxEzcmFCzyOb2fN0IwL
	 oHAk4KIQM+Z8wZivHI/FpiV1gzoVJL+bmlUm4siwWRtZZgGCi8V9rtREpQrTfIhNZH
	 oIVtIip+eE4EF2A2/EKxEG7sAHnh6GvsWf/vuQUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1339/1536] ALSA: seq: oss: Skip events until fully initialized
Date: Sat,  7 Nov 2026 08:55:55 -0500
Message-ID: <20261107135035.425512012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 68d4a6ea6cc6091a05836f783bc17d525d266d0b ]

When an OSS sequencer device is opened, it creates a sequencer port,
then further initializes the internal states like a timer instance,
etc.  Since the sequencer port is published, an event can be already
delivered, and this may hit unexpected event handling, which can
eventually cause a NULL dereference (like the timer start/stop event
triggered before the timer initialization).

For avoiding such a race, introduce a simple guard and skips the event
processing until the port is fully initialized.
At releasing the device, in turn, clear this guard, so that any input
events will be discarded during the teardown.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261016161930.482309-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_device.h | 1 +
 sound/core/seq/oss/seq_oss_event.c  | 3 +++
 sound/core/seq/oss/seq_oss_init.c   | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/sound/core/seq/oss/seq_oss_device.h b/sound/core/seq/oss/seq_oss_device.h
index 98dd20b429764..eb1619c96526f 100644
--- a/sound/core/seq/oss/seq_oss_device.h
+++ b/sound/core/seq/oss/seq_oss_device.h
@@ -73,6 +73,7 @@ struct seq_oss_devinfo {
 	int cseq;	/* sequencer client number */
 	int port;	/* sequencer port number */
 	int queue;	/* sequencer queue number */
+	bool initialized;
 
 	struct snd_seq_addr addr;	/* address of this device */
 
diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 4699c084d018e..fa91eb1233de3 100644
--- a/sound/core/seq/oss/seq_oss_event.c
+++ b/sound/core/seq/oss/seq_oss_event.c
@@ -427,6 +427,9 @@ snd_seq_oss_event_input(struct snd_seq_event *ev, int direct, void *private_data
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private_data;
 	union evrec *rec;
 
+	if (!dp || !smp_load_acquire(&dp->initialized))
+		return 0; /* ignored */
+
 	if (ev->type != SNDRV_SEQ_EVENT_ECHO)
 		return snd_seq_oss_midi_input(ev, direct, private_data);
 
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 676246fa02f15..7fb9fce9172e8 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -258,6 +258,7 @@ snd_seq_oss_open(struct file *file, int level)
 
 	client_table[dp->index] = dp;
 	num_clients++;
+	smp_store_release(&dp->initialized, true);
 
 	return 0;
 
@@ -403,6 +404,7 @@ snd_seq_oss_release(struct seq_oss_devinfo *dp)
 
 	client_table[dp->index] = NULL;
 	num_clients--;
+	smp_store_release(&dp->initialized, false);
 
 	snd_seq_oss_reset(dp);
 
-- 
2.53.0



