Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049394;
	b=PsX13GWtgWh4MQZ2UrwJzfthY4rLI29eL+v66xn0/KzwhjKB7h4Eknw73YVlybaTfq5E
	 TsgkYUun3Tq7kOKepqVoHJ5xWEnMn/PdlcF7LTz3xG2ATEBj1KWOGyaWh8kCqjTNnYfjD
	 7aIyDT4HuVMqNjcdMyfPZTV/AhduUZlMtRjRWRaZ3iLdzgI1Mr7CYF/OQnTJk7v9EmBNv
	 WKMXTxQ9U97YnjhREMCoWVtaCUsKXAnqxSJE7zEF3qiLuBSqtAdL9jeX0FgU+BAbGOjg9
	 e1pNTJpY/1bv1m5qjpaH7uqG+oGc6M5zqG2ll1pytL55xnXFGJiB8xYrBj8O9aBdKow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1Ceb8Y3q5BYNABrqTasiitheaNmSe6xNw8TuxIrTRg=;
	b=BxGvy9cCwyyU+bEJcXqSEyu2NVDJXSN2iKZULSZdbbtxXMUBkcBj3HEdjfWLmyX7fBul
	 uV2UXK3osF3LFwxGmPGl9oY6XxmcdyF61Unn6h2YWaHA8+TxtKp+o4fzTiaAUZ+Cw6Hyb
	 7nanpg9cHC01QDjhcRhnzR9GypzOOTu9qbRjAWNn1FyVET5BDqdWkRqNU059rm7iKnyrM
	 XWtvtFHJtNLbmsIH8crRWZG34pZwnGMvcIbIN1T2DwAX4FpCjN4qjXOP023MIC7TvHWqL
	 mp47Tdu6yb5mJwfnnD8Xt7HIgOGOcgtSe6FVXDSoeX4x8zkCjVf5xnMX2IUCs0hrGsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ3o7I3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7635606A31C;
	Thu, 19 Nov 2026 00:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ3o7I3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DF81F000C4;
	Thu, 19 Nov 2026 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049394;
	bh=N1Ceb8Y3q5BYNABrqTasiitheaNmSe6xNw8TuxIrTRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ3o7I3VljvDmWqiMxzCGSqnWCYKWoSTrI7cqGnRMrcxLEDBBsJl5RxveWXHIbOYb
	 HnC+zwYav+l1rjQoeRKzQQrGhBZu8mtNgwJsMNHHmjtdnrtcFJ7RqkZq2ydpCoZrUS
	 rBSohaBpEohUk8ttpe77jUJclLhT9vZ8hIwZ5dC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2336/2857] ALSA: caiaq: Fix races at MIDI URB and trigger accesses
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150325.644922141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 52b1213e2a086f2828500ab9c8bac45b213429bb ]

URB completion and rawmidi trigger callbacks can race with each other,
which may put the state inconsistent, causing double submissions, etc.

Guard both with a new spinlock for avoiding the races.

Fixes: f3f80a9205da ("ALSA: caiaq - Fix Oops with MIDI")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 1 +
 sound/usb/caiaq/device.h | 3 ++-
 sound/usb/caiaq/midi.c   | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 0f056d155a47b..dc0c26f281fa6 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -448,6 +448,7 @@ static int create_card(struct usb_device *usb_dev,
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&cdev->spinlock);
+	spin_lock_init(&cdev->midi_lock);
 	mutex_init(&cdev->ep1_out_mutex);
 
 	*cardp = card;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index bef5fd31dedd4..e1ec0bfdbb99a 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -74,7 +74,8 @@ struct snd_usb_caiaqdev {
 	unsigned char midi_out_buf[EP1_BUFSIZE];
 
 	struct caiaq_device_spec spec;
-	spinlock_t spinlock;
+	spinlock_t spinlock;	/* for PCM audio */
+	spinlock_t midi_lock;	/* midi_x_stream, midi_out_active */
 	wait_queue_head_t ep1_wait_queue;
 	wait_queue_head_t prepare_wait_queue;
 	int spec_received, audio_parm_answer;
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 18529484c8dcc..b7d7d24937a74 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -79,6 +79,7 @@ static void snd_usb_caiaq_midi_output_trigger(struct snd_rawmidi_substream *subs
 {
 	struct snd_usb_caiaqdev *cdev = substream->rmidi->private_data;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	if (up) {
 		cdev->midi_out_substream = substream;
 		if (!cdev->midi_out_active)
@@ -151,6 +152,7 @@ void snd_usb_caiaq_midi_output_done(struct urb* urb)
 {
 	struct snd_usb_caiaqdev *cdev = urb->context;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	cdev->midi_out_active = 0;
 	if (urb->status != 0)
 		return;
-- 
2.53.0



