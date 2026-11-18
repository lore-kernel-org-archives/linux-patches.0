Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036674;
	b=QD0aCwTV+r331aqO29yNoo66Sm0lErL7RCXSuYYJ7QSIET81RxaJlNQbYQhgPO3Ly7uY
	 yEFHwij4ZoMw0BwJnP6BpNuP3dDyhkATcsZxje4uqhbt6nJyh8F0yCbEsIZBrUKX0iiEa
	 5b0MQCfKqmc1xY36/UOtuCEAzzYk3RoJtdBrPijoAuO2Z1Xn54J/HZ9/3M/bKf4YLN3yx
	 32oA89ScGs1nC+YzXzqnim0BZ5RjeLjenfzsnXzFZkTaCEUxoucQp/shMKtCqvNatK15y
	 ybMCPSRiJ90/Zz8qaP4b+gJLhuTglEMcIUqK5OiL6gDLNH7fBk/e0PySHuELqAL4bXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Ne/vo4KXZ5P2xl4m1YhMEZy/O+kCi4Oe3sl1xrb+AQ=;
	b=Cxw+L8d/zMnxdQWHRU6uKDKh+tcR8qQKIHTbH3cf65dgzFu5adRNmOqWRtr20AYEeYT7
	 0kVVomzNt7ktxl83dZ6as9O0pmF/FVL0ZCs+qHcqRxTc4Yaecgsz2KggghCFEPOj7qhhl
	 rnykqxHS7nibwQ1oSl8y22ld+9e36kY7qO6j/SmZCg/I/N8BoSvOmhwvZYrQi3xd6NiDV
	 roVsTPncFeoc11libTJe3q6+UurA7vai/hYL2sMjH1J5CoapqLmNxLZ7Ypbd1Z3tHPXCt
	 m2hhd803zqJDHldoN1a97OvrGGWP1IIzz2Pxjz74UBmVYLTe1Pi3hd980ZmnaG7YvCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1EJhrg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6639606A320;
	Wed, 18 Nov 2026 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1EJhrg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38261F000C4;
	Wed, 18 Nov 2026 21:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036674;
	bh=2Ne/vo4KXZ5P2xl4m1YhMEZy/O+kCi4Oe3sl1xrb+AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1EJhrg6awhHd5T0pNie3GlZTRGI4spyoG6Ws4hVH2YYBxAMFwFuCJRnh6he43nFL
	 nriV/ro/e9CVRNB3FdL5JsllykLq/kZf720R9n2zKa+CL+2HQ7Ev0OBm40F0hXdYqd
	 ZVhdrLqKQiz1/XB8v5M0uV+a0kyO4guhcA2IdQbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1143/3318] ALSA: seq: oss: Skip events until fully initialized
Date: Wed, 18 Nov 2026 15:29:25 +0100
Message-ID: <20261118150354.361654170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c2c4fb9b7537..f0d7bb0e11a94 100644
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
index 42d4e7535a820..e0e5e2853754d 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -263,6 +263,7 @@ snd_seq_oss_open(struct file *file, int level)
 
 	client_table[dp->index] = dp;
 	num_clients++;
+	smp_store_release(&dp->initialized, true);
 
 	return 0;
 
@@ -408,6 +409,7 @@ snd_seq_oss_release(struct seq_oss_devinfo *dp)
 
 	client_table[dp->index] = NULL;
 	num_clients--;
+	smp_store_release(&dp->initialized, false);
 
 	snd_seq_oss_reset(dp);
 
-- 
2.53.0



