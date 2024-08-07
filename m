Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5928F81AB1;
	Wed,  7 Aug 2024 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043474; cv=none; b=GMhijgy1ZJIUcLH5tH6WJ6Ik9ChOAwPSoONaGs5D+6els50Ae+lxQ9VSya7ahafIZVpuQ9bdfeG7ET6KD4PLL98unUG42cZoMnd4DV8VoGtNH3X8unrbM++Sw2KZ8rJDC2Lg70i4y/kTTLgl2jkrPl/xgnlaj1arqOoVK4h7UGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043474; c=relaxed/simple;
	bh=xhNjBEjg8I7IBYYaMx3QDgYXL7BDL6cY94utN7/H1bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt/CCLaj79ICa5GX457sZY+Zc5IJIMXhHILSvqg4zDuSVCp/CmlNEaiglxHUsuyGp30W76T/fbc8oY+LFjsvrdem02lXiAKM3pwvgehtBHUzGIVyikcOLU0Ufc6KMZgfLCEBTVjAizjKLLdo0k71M5Lw5wpbku84S0f5wK7sXUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Olz/4v0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Olz/4v0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E102DC32781;
	Wed,  7 Aug 2024 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043474;
	bh=xhNjBEjg8I7IBYYaMx3QDgYXL7BDL6cY94utN7/H1bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Olz/4v0eOsgWqWY5aLoOyenNWK1mxOX7q7qWc72ysRan4TepaRgk/BMxmiMRuOeiV
	 xW/A4OO7fTv59wgh3U2KBno1n9kz1ow8X64AEGADIwSgfwhQs2P+uUQhFv8gwYEAio
	 Ok/+Z6yUT7CK3SZydC3bVBtJ5tuYP2WJeVqi7kLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edmund Raile <edmund.raile@protonmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 104/121] Revert "ALSA: firewire-lib: obsolete workqueue for period update"
Date: Wed,  7 Aug 2024 17:00:36 +0200
Message-ID: <20240807150022.799748507@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1912,6 +1926,7 @@ static void amdtp_stream_stop(struct amd
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


