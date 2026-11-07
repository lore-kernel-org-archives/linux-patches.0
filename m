Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063464;
	b=KjVJ/qzqWpCT87LVP7ONvvswm0uOhhBspFixQ8PjY4/MqVJh6X7aHCgnTCJk+lXSPAjQ
	 3ubLDXcTWdhPj+kk7qPYXV/m1ZsbWlXmxzCKVwzJubB4rRwHeJ2PIDm5ykq67NAl2I7R9
	 W4PRbAxGUJQ8olfOop6ZsK8ige9V7LKCeCgmrp7ywRhvHm5hT6NQPDEIuUq5Qk2eiOzX3
	 B8qix6ti8NmSSMSLa1gtYS8dwpEcVTk6p8+gJyPY3IJ98T/zQpUWICi1g14freZx2ZxDx
	 DcROasgDoCAZtbL8WlBuionxOV/h+UpufjrBp+BD9/TkpuqovdIWJboSnH8CYDsiI3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ca3P+TE8TPPWL4SesXJagcwmzn1asuSz4GmboRJ2MI=;
	b=n0BqubAsPHV799KODWGQa710lSUP1cI5AckrRbiUX52npTzeyu9cUut3PLOLZBQNl+8b
	 WaXRhv6H0ypuU9RpVS7DGEfH9cwjFHKtk3QF6xHiIxPemV2/OlrBgcUg1RD9tNIYKCfb1
	 jd2CZBsHXtp0E8vuTcha8T8obpD62G6mhodTa2jWRax451id0p7ucusWD+F+X1Jy0Naxq
	 GkaamWSWwyw6zMgOoIEinbduwkt1OD2OT0Ga53OShMyyCzuIaXDvsxFKiif7t8xB+x0d9
	 WZ65FbL5oQL1FWQqpOjMzTWKL3IFxmjFclxR1rS3abP0hask0bc8htApOdxxGW1BJzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=linUp5sr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70460A6F53;
	Sat,  7 Nov 2026 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=linUp5sr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3720C1F008A5;
	Sat,  7 Nov 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063463;
	bh=+ca3P+TE8TPPWL4SesXJagcwmzn1asuSz4GmboRJ2MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=linUp5sr2jRd84G7Ar0AZF1kvyiTDaFHezDI4S0tDkGN0/VF4aqJhEyeeKceL3crW
	 0SinSLynPlqrB7Wg4YPZdTf5KMpkh1PS1FG8e67Ysskrz90A0k4yIjBdPwhUn/mfpK
	 H4Chw4OKAk4+DMvzLAWJRDMUpljvOGCkL2N52lF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 618/869] ALSA: seq: oss: Skip events until fully initialized
Date: Sat,  7 Nov 2026 08:55:00 -0500
Message-ID: <20261107134913.995839970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 935cf3df0b30f..571186db4fa59 100644
--- a/sound/core/seq/oss/seq_oss_device.h
+++ b/sound/core/seq/oss/seq_oss_device.h
@@ -72,6 +72,7 @@ struct seq_oss_devinfo {
 	int cseq;	/* sequencer client number */
 	int port;	/* sequencer port number */
 	int queue;	/* sequencer queue number */
+	bool initialized;
 
 	struct snd_seq_addr addr;	/* address of this device */
 
diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 122735862044d..20f4c5ce763cc 100644
--- a/sound/core/seq/oss/seq_oss_event.c
+++ b/sound/core/seq/oss/seq_oss_event.c
@@ -425,6 +425,9 @@ snd_seq_oss_event_input(struct snd_seq_event *ev, int direct, void *private_data
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private_data;
 	union evrec *rec;
 
+	if (!dp || !smp_load_acquire(&dp->initialized))
+		return 0; /* ignored */
+
 	if (ev->type != SNDRV_SEQ_EVENT_ECHO)
 		return snd_seq_oss_midi_input(ev, direct, private_data);
 
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 973f057eb731f..102c9358ce481 100644
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



