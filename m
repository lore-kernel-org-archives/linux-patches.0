Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BE82488;
	Wed,  7 Aug 2024 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043094; cv=none; b=Any1kDkwiPxavjj41sDbutiZfU9AbDMQ4r5eBFljDwvvNJFtKFTX9Ankp6QdgiL3HbDorNwGKcEWJYO71yOWHgSyVW2XkHgOjJ5dixVAnjoRkArIxhWqAkDFSmW78Jpv7GqUPtBRu28Z3CaDuj/inh4zz2HIgc9wG9f1I/k9xDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043094; c=relaxed/simple;
	bh=6Lz6kNgxhSc8QCGCf14yaU613RKBDNuhv+gH2IZuCCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b152eylcJK6OwzPeVTkzIahtFiU3RgtssmZ/uWhtucOIER6bQbjCth0NWikr1cbcVD6b1ZaQyrQExAmQ4pE+LRbtnezUAbFVKGefFiRXVfEt04zNMaKz5F0ZJoB6ZxlgDIWX4D6pHWtSYmhQh9+CvOss3aQsqqchDBdGrtVlzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzXxSHWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzXxSHWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E420C32781;
	Wed,  7 Aug 2024 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043094;
	bh=6Lz6kNgxhSc8QCGCf14yaU613RKBDNuhv+gH2IZuCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzXxSHWknHXpNHyzQUKpTyjZX45qnooNL0LqkuFYXV+3T35yDS4tRvN0uRwZnnx0j
	 j5uHcDW09BDDFih5etHRHWnJ5MawWwtTgppEjcIuVKdC+8/SZ2c8fV9quCKkY1Fu4U
	 O+L6qGfIN44uB0IKQu/j5kzISxt7cPI+gzb2LCQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edmund Raile <edmund.raile@protonmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 088/123] Revert "ALSA: firewire-lib: obsolete workqueue for period update"
Date: Wed,  7 Aug 2024 17:00:07 +0200
Message-ID: <20240807150023.655422429@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edmund Raile <edmund.raile@protonmail.com>

commit 6ccf9984d6be3c2f804087b736db05c2ec42664b upstream.

prepare resolution of AB/BA deadlock competition for substream lock:
restore workqueue previously used for process context:

revert commit b5b519965c4c ("ALSA: firewire-lib: obsolete workqueue
for period update")

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/kwryofzdmjvzkuw6j3clftsxmoolynljztxqwg76hzeo4simnl@jn3eo7pe642q/
Signed-off-by: Edmund Raile <edmund.raile@protonmail.com>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240730195318.869840-2-edmund.raile@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |   15 +++++++++++++++
 sound/firewire/amdtp-stream.h |    1 +
 2 files changed, 16 insertions(+)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -77,6 +77,8 @@
 // overrun. Actual device can skip more, then this module stops the packet streaming.
 #define IR_JUMBO_PAYLOAD_MAX_SKIP_CYCLES	5
 
+static void pcm_period_work(struct work_struct *work);
+
 /**
  * amdtp_stream_init - initialize an AMDTP stream structure
  * @s: the AMDTP stream to initialize
@@ -105,6 +107,7 @@ int amdtp_stream_init(struct amdtp_strea
 	s->flags = flags;
 	s->context = ERR_PTR(-1);
 	mutex_init(&s->mutex);
+	INIT_WORK(&s->period_work, pcm_period_work);
 	s->packet_index = 0;
 
 	init_waitqueue_head(&s->ready_wait);
@@ -347,6 +350,7 @@ EXPORT_SYMBOL(amdtp_stream_get_max_paylo
  */
 void amdtp_stream_pcm_prepare(struct amdtp_stream *s)
 {
+	cancel_work_sync(&s->period_work);
 	s->pcm_buffer_pointer = 0;
 	s->pcm_period_pointer = 0;
 }
@@ -624,6 +628,16 @@ static void update_pcm_pointers(struct a
 	}
 }
 
+static void pcm_period_work(struct work_struct *work)
+{
+	struct amdtp_stream *s = container_of(work, struct amdtp_stream,
+					      period_work);
+	struct snd_pcm_substream *pcm = READ_ONCE(s->pcm);
+
+	if (pcm)
+		snd_pcm_period_elapsed(pcm);
+}
+
 static int queue_packet(struct amdtp_stream *s, struct fw_iso_packet *params,
 			bool sched_irq)
 {
@@ -1909,6 +1923,7 @@ static void amdtp_stream_stop(struct amd
 		return;
 	}
 
+	cancel_work_sync(&s->period_work);
 	fw_iso_context_stop(s->context);
 	fw_iso_context_destroy(s->context);
 	s->context = ERR_PTR(-1);
--- a/sound/firewire/amdtp-stream.h
+++ b/sound/firewire/amdtp-stream.h
@@ -191,6 +191,7 @@ struct amdtp_stream {
 
 	/* For a PCM substream processing. */
 	struct snd_pcm_substream *pcm;
+	struct work_struct period_work;
 	snd_pcm_uframes_t pcm_buffer_pointer;
 	unsigned int pcm_period_pointer;
 	unsigned int pcm_frame_multiplier;


