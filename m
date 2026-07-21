Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864CC46A606;
	Tue, 21 Jul 2026 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648883; cv=none; b=BPsPLDxgdhAU4TiV/HvDJF3jXYT7aO5Q5GELB2Ccj/1NPlhp445i7mGLWv99jH9+UTzXvyIeWeKocjdHjuhkhM5c6XrzhZrMW/HQZW8QRWKjDozmrmWTtSlT9b80aRgE1VhH3PagyM51/Wqnhdp8Y8uyConv96cSj49+kh9q/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648883; c=relaxed/simple;
	bh=XMBQ5jjowgPnH9c55KfYMbtP7XxFmHCbt17GFi9iWEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDasCe3XsKTFxsDdedyHVj4/Gqkh+it+7M70qdIdSEb7ozpf5bpe0OQlqHPExiCr4XcjskEIv2uYReNv//Ux+DuIjxHjJ1bWLN1K/xEZUncTKgZ7KDHQ4K0xiVu3SCzCHAmqpfgsyPEVKAtGkpXp80bAcOxC45WFAJe7+jfZAlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=groXO1LE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="groXO1LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53EE1F00A3A;
	Tue, 21 Jul 2026 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648881;
	bh=o6IZiZePkecdeQ59NDz1Mctry95aBqe/mtn3TYU8yRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=groXO1LEgI2aJOcZz6ThwmAK4zfk7D+IT9WRLGnWD44Tkf1WIWZC6VSB5ef1fbynR
	 ryB0rL2y28uHTzM8DA8cNV2KODFc5kDCPTDib6ptd/6t5RFQK5naNXiMPDmBQjMNK6
	 EZFaOz+zLuoJR+Qaf1duXNp65cv/JVStnPI9W+/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0323/2077] ALSA: xen-front: Connect event channel after stream prepare
Date: Tue, 21 Jul 2026 16:59:56 +0200
Message-ID: <20260721152600.295926651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 3624f0bd4af15a820b1bd88b489980fa9fd61b7a ]

The request channel must be connected from ALSA .open(), because hw-rule
queries and the stream open request use it. The event channel is
different: XENSND_EVT_CUR_POS handling uses ALSA runtime buffer and
period geometry, and the corresponding Xen stream parameters are not
submitted to the backend until .prepare() sends XENSND_OP_OPEN.

Currently .open() connects both channels. A backend current-position
event, or a stale event queued for an earlier stream instance, can
therefore reach xen_snd_front_alsa_handle_cur_pos() before
runtime->buffer_size and runtime->period_size are valid.

Add a per-channel connection helper, connect only the request channel in
.open(), connect the event channel after a successful stream prepare,
and disconnect it before stream close/free. Re-check the event-channel
state after taking ring_io_lock so disconnecting the event channel
synchronizes against a threaded IRQ that passed the initial lockless
state test. Keep defensive runtime geometry checks in the position
handler.

Fixes: 1cee559351a7 ("ALSA: xen-front: Implement ALSA virtual sound driver")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260526-alsa-xen-event-channel-fixes-v1-2-91d3a6a50778@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/xen/xen_snd_front_alsa.c    | 17 ++++++++++++-----
 sound/xen/xen_snd_front_evtchnl.c | 20 +++++++++++++-------
 sound/xen/xen_snd_front_evtchnl.h |  2 ++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/sound/xen/xen_snd_front_alsa.c b/sound/xen/xen_snd_front_alsa.c
index dc626480123acd..a6dd196f73d662 100644
--- a/sound/xen/xen_snd_front_alsa.c
+++ b/sound/xen/xen_snd_front_alsa.c
@@ -378,7 +378,7 @@ static int alsa_open(struct snd_pcm_substream *substream)
 
 	stream_clear(stream);
 
-	xen_snd_front_evtchnl_pair_set_connected(stream->evt_pair, true);
+	xen_snd_front_evtchnl_set_connected(&stream->evt_pair->req, true);
 
 	ret = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_FORMAT,
 				  alsa_hw_rule, stream,
@@ -498,6 +498,8 @@ static int alsa_hw_free(struct snd_pcm_substream *substream)
 	struct xen_snd_front_pcm_stream_info *stream = stream_get(substream);
 	int ret;
 
+	xen_snd_front_evtchnl_set_connected(&stream->evt_pair->evt, false);
+
 	ret = xen_snd_front_stream_close(&stream->evt_pair->req);
 	stream_free(stream);
 	return ret;
@@ -532,6 +534,7 @@ static int alsa_prepare(struct snd_pcm_substream *substream)
 			return ret;
 
 		stream->is_open = true;
+		xen_snd_front_evtchnl_set_connected(&stream->evt_pair->evt, true);
 	}
 
 	return 0;
@@ -571,20 +574,24 @@ void xen_snd_front_alsa_handle_cur_pos(struct xen_snd_front_evtchnl *evtchnl,
 {
 	struct snd_pcm_substream *substream = evtchnl->u.evt.substream;
 	struct xen_snd_front_pcm_stream_info *stream = stream_get(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
 	snd_pcm_uframes_t delta, new_hw_ptr, cur_frame;
 
-	cur_frame = bytes_to_frames(substream->runtime, pos_bytes);
+	if (!runtime->buffer_size || !runtime->period_size)
+		return;
+
+	cur_frame = bytes_to_frames(runtime, pos_bytes);
 
 	delta = cur_frame - stream->be_cur_frame;
 	stream->be_cur_frame = cur_frame;
 
 	new_hw_ptr = (snd_pcm_uframes_t)atomic_read(&stream->hw_ptr);
-	new_hw_ptr = (new_hw_ptr + delta) % substream->runtime->buffer_size;
+	new_hw_ptr = (new_hw_ptr + delta) % runtime->buffer_size;
 	atomic_set(&stream->hw_ptr, (int)new_hw_ptr);
 
 	stream->out_frames += delta;
-	if (stream->out_frames > substream->runtime->period_size) {
-		stream->out_frames %= substream->runtime->period_size;
+	if (stream->out_frames > runtime->period_size) {
+		stream->out_frames %= runtime->period_size;
 		snd_pcm_period_elapsed(substream);
 	}
 }
diff --git a/sound/xen/xen_snd_front_evtchnl.c b/sound/xen/xen_snd_front_evtchnl.c
index 09e4c1d0563632..17a30452c0cca3 100644
--- a/sound/xen/xen_snd_front_evtchnl.c
+++ b/sound/xen/xen_snd_front_evtchnl.c
@@ -94,6 +94,9 @@ static irqreturn_t evtchnl_interrupt_evt(int irq, void *dev_id)
 
 	guard(mutex)(&channel->ring_io_lock);
 
+	if (unlikely(channel->state != EVTCHNL_STATE_CONNECTED))
+		return IRQ_HANDLED;
+
 	prod = page->in_prod;
 	/* Ensure we see ring contents up to prod. */
 	virt_rmb();
@@ -430,8 +433,8 @@ int xen_snd_front_evtchnl_publish_all(struct xen_snd_front_info *front_info)
 	return ret;
 }
 
-void xen_snd_front_evtchnl_pair_set_connected(struct xen_snd_front_evtchnl_pair *evt_pair,
-					      bool is_connected)
+void xen_snd_front_evtchnl_set_connected(struct xen_snd_front_evtchnl *channel,
+					 bool is_connected)
 {
 	enum xen_snd_front_evtchnl_state state;
 
@@ -440,13 +443,16 @@ void xen_snd_front_evtchnl_pair_set_connected(struct xen_snd_front_evtchnl_pair
 	else
 		state = EVTCHNL_STATE_DISCONNECTED;
 
-	scoped_guard(mutex, &evt_pair->req.ring_io_lock) {
-		evt_pair->req.state = state;
+	scoped_guard(mutex, &channel->ring_io_lock) {
+		channel->state = state;
 	}
+}
 
-	scoped_guard(mutex, &evt_pair->evt.ring_io_lock) {
-		evt_pair->evt.state = state;
-	}
+void xen_snd_front_evtchnl_pair_set_connected(struct xen_snd_front_evtchnl_pair *evt_pair,
+					      bool is_connected)
+{
+	xen_snd_front_evtchnl_set_connected(&evt_pair->req, is_connected);
+	xen_snd_front_evtchnl_set_connected(&evt_pair->evt, is_connected);
 }
 
 void xen_snd_front_evtchnl_pair_clear(struct xen_snd_front_evtchnl_pair *evt_pair)
diff --git a/sound/xen/xen_snd_front_evtchnl.h b/sound/xen/xen_snd_front_evtchnl.h
index 8400261ac46601..f6ebdb09c0298c 100644
--- a/sound/xen/xen_snd_front_evtchnl.h
+++ b/sound/xen/xen_snd_front_evtchnl.h
@@ -77,6 +77,8 @@ void xen_snd_front_evtchnl_free_all(struct xen_snd_front_info *front_info);
 int xen_snd_front_evtchnl_publish_all(struct xen_snd_front_info *front_info);
 
 void xen_snd_front_evtchnl_flush(struct xen_snd_front_evtchnl *evtchnl);
+void xen_snd_front_evtchnl_set_connected(struct xen_snd_front_evtchnl *channel,
+					 bool is_connected);
 
 void xen_snd_front_evtchnl_pair_set_connected(struct xen_snd_front_evtchnl_pair *evt_pair,
 					      bool is_connected);
-- 
2.53.0



