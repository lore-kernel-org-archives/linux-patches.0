Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8A93AC17;
	Sat, 12 Sep 2026 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225475; cv=none; b=jY14FPHwkanUIuIR2qCEkk0QX+0OFqiOdqEKbofl3a06Tb75k5fUCz+bEM/jxnVZEINSB2PtnZP/f43/vrnxMNzNg67I/zLegJJP3+CboPle1gTdUY9xr3JzdRE1QLm0WFWHOhNLf0lJeP/po87T1lLD+U7NPZ14SO7ySXTE+dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225475; c=relaxed/simple;
	bh=31+rV+bvyO1sF53RR+JtjJOrYRVemzdbx+C+9lvoAl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6IFvTs/h8WuoiGH0V5CIWWMz8DrXYq+fmbaubRtsPZYyD+UAt08XNR2CWdtyGJ0cD5Abs0dWarJn0ITGB5tKajHRfTbDyYeTDFVP71Id4Kb7g+PFZvkm0STDxZ8KE+liwYai6A5rxMSkI38t5vYWcTM0v+NRFyG3oVuN0fAeP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG290JJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG290JJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6961C1F000FF;
	Sat, 12 Sep 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225473;
	bh=Ocgff8qqx7jVHix1cPXAlWdv/8mUsgcx/BAeS7tpuAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tG290JJJVq7hsKfHkiYXgboxc1ah4JkjVgQy41rv/Ho7S5yYHbhRrt8us7cYBcSpa
	 OTy1Z7H+WM3ltt54coAQCENw3F19TvljVosRwgVpVsR4yLVuCVVoENKoGJT8E5BPdQ
	 qodIWdAcS7cscHoir2ZwCZPAs4Idv4b2tfocgE8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1205/1424] ALSA: seq: midi: Optimize event_input locking with RCU
Date: Sat, 12 Sep 2026 09:00:37 +0200
Message-ID: <20260912065634.270004961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4cc25cdd3cffa475edb8dec8199b3227038ebcfb ]

The recent fix for serializing the output teardown introduced a
spinlock invocation at every MIDI output event via event_process_midi.
Since this is a hot path, let's do performance optimization with RCU.

The new output_substream __rcu pointer is published via
rcu_assign_pointer() in midisynth_use() after output_rfile is set, and
cleared in midisynth_unuse() before the resource teardown.
event_process_midi() reads it under rcu_read_lock() and bumps
output_use_lock inside that section, which is necessary to close the
window between the pointer dereference and the refcount increment.

midisynth_unuse() calls synchronize_rcu() before snd_use_lock_sync():
this guarantees that any reader who obtained a non-NULL pointer has
already called atomic_inc (output_use_lock), so the subsequent
snd_use_lock_sync() sees the correct in-flight count.

Fixes: ef7607ab1c8a ("ALSA: seq: midi: Serialize output teardown with event_input")
Link: https://patch.msgid.link/20260813144224.753399-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_midi.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index c8a7c39747113..50e39b34f5ac5 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -43,8 +43,8 @@ struct seq_midisynth {
 	int device;
 	int subdevice;
 	struct snd_rawmidi_file input_rfile;
-	spinlock_t output_lock;		/* protects output_rfile publication */
 	snd_use_lock_t output_use_lock;	/* in-flight event_input users */
+	struct snd_rawmidi_substream __rcu *output_substream;
 	struct snd_rawmidi_file output_rfile;
 	int seq_client;
 	int seq_port;
@@ -134,8 +134,8 @@ static int event_process_midi(struct snd_seq_event *ev, int direct,
 	if (snd_BUG_ON(!msynth))
 		return -EINVAL;
 
-	scoped_guard(spinlock_irqsave, &msynth->output_lock) {
-		substream = msynth->output_rfile.output;
+	scoped_guard(rcu) {
+		substream = rcu_dereference(msynth->output_substream);
 		if (!substream)
 			return -ENODEV;
 		snd_use_lock_use(&msynth->output_use_lock);
@@ -177,7 +177,6 @@ static int snd_seq_midisynth_new(struct seq_midisynth *msynth,
 	msynth->card = card;
 	msynth->device = device;
 	msynth->subdevice = subdevice;
-	spin_lock_init(&msynth->output_lock);
 	snd_use_lock_init(&msynth->output_use_lock);
 	return 0;
 }
@@ -252,8 +251,8 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 		return err;
 	}
 	snd_midi_event_reset_decode(msynth->parser);
-	scoped_guard(spinlock_irqsave, &msynth->output_lock)
-		msynth->output_rfile = rfile;
+	msynth->output_rfile = rfile;
+	rcu_assign_pointer(msynth->output_substream, rfile.output);
 	return 0;
 }
 
@@ -261,17 +260,16 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 static int midisynth_unuse(void *private_data, struct snd_seq_port_subscribe *info)
 {
 	struct seq_midisynth *msynth = private_data;
-	struct snd_rawmidi_file rfile = {};
+	struct snd_rawmidi_file rfile;
 
-	scoped_guard(spinlock_irqsave, &msynth->output_lock) {
-		rfile = msynth->output_rfile;
-		msynth->output_rfile = (struct snd_rawmidi_file){};
-	}
+	rcu_assign_pointer(msynth->output_substream, NULL);
+	synchronize_rcu();
+	snd_use_lock_sync(&msynth->output_use_lock);
+	rfile = msynth->output_rfile;
+	msynth->output_rfile = (struct snd_rawmidi_file){};
 
 	if (snd_BUG_ON(!rfile.output))
 		return -EINVAL;
-
-	snd_use_lock_sync(&msynth->output_use_lock);
 	snd_rawmidi_drain_output(rfile.output);
 	return snd_rawmidi_kernel_release(&rfile);
 }
-- 
2.53.0



