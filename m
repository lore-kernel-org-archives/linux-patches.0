Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA9F345CCE;
	Sat, 12 Sep 2026 08:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203551; cv=none; b=pCHW//p3J+RTXl4dvstyrStsm3Jax6+6IDmVMN4/J2v6LMRTjehXMCezfKzZkxRq09ayDl3CIQsAq/BSbIxbEnrLbStwl0zlSgdAtVqauHx6SswuNG+y4my486++NiYihDVN9AtU5L7RCmxK4oTQX7MPFE/Q87HyUo3DXcKRSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203551; c=relaxed/simple;
	bh=uxmMcNZte/8VeC1G6AZlAipnlT57bQ5Z68jeLuC1eyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqq27M+PzlxIs4Yru5gc5x4CKY8mf9jlK3htKfqemdTbLVL2OBfpzfD6FUxC3RAZ63cxUvFrTiU1W0OqLVwy4ivJ7R66iGDhtix2xLhT5mHvSZyEhye4Kcu9Nael4zKmQUvxNRRD6tWtTeCytNGJM6SwrmYg6gGnVS6wUjq4hsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xatDQR3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xatDQR3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B861F000FF;
	Sat, 12 Sep 2026 08:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203550;
	bh=gxyS++B9vwIu5ey2c/Tlu5B2yPF25NsYr4uMbUwSZ0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xatDQR3eQYrfpCtGWnNiBTKjsWg6SnA+f0qJYSrVrIIodWnGr2meHqW9M546704AQ
	 IaHQLmP+bPbRX63W05UiyipdnCroxR2QuRAkrP2UrTj00TOBPZTovoxRw6sAMQA099
	 Z92zTlul2DzhRZIo+o/ksuboGAdR/uBoyGujXQ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1432/1815] ALSA: seq: midi: Optimize event_input locking with RCU
Date: Sat, 12 Sep 2026 08:53:02 +0200
Message-ID: <20260912065722.635016256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2eb12199c92f9..c2f89aee1914b 100644
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



