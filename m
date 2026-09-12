Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA213783B0;
	Sat, 12 Sep 2026 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231455; cv=none; b=K+HVfMJAMCdS+g7AzDp9XKo3jwE5nGs47/sb7cfQJULuAfhYdV/6o6RPnfBnU/VWWftg4IsqndddktkeardW9Ol4XLgWi2rDWeAwV3sn8X15569Jzc0KsWbD4TPy/d4fmEaWxkFyocFJziU+N+hJQ2y8lTDo5/63+yrEM9LroYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231455; c=relaxed/simple;
	bh=5WhsIL7GzMzxEQMFpeWEO4spYLgqnI/xtb9wHPboMj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnTuePKwF2okgwYDA51/+UVyHdhqW99mEDPiFxKwIzf+mga+YibBNJFMybFo2Phi+ZYCzYA00x2FM7P+vhepvOPSEwQNhDuhWcko/mrOib15AEkbFeQfjA2mAWRfHqu30tVMTPeGDD0wqMI7GMiNpUBN9NrZYgfR/7b66f/RZXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIBW+Lvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIBW+Lvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F071F000FF;
	Sat, 12 Sep 2026 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231453;
	bh=MOYuPJTvSlruSfh8X4r/j6W93se60QavK7MpIDikP0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIBW+LvvrKNzyBSbVC9YYFG37Jl/41SOFV3xsb5e+3AUpJ3q+5iZBrN68H2HdQDiO
	 l9P3OHFrv6dceVmv1B99KiXcqO8k8pXJU5oxTsp8CeP30y6G2UU9XYkLUhrDA0HuZd
	 pC8NmSVCvc4jn2+plBaXM9+63Kpar2hsTyZJM4Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1001/1191] ALSA: seq: midi: Optimize event_input locking with RCU
Date: Sat, 12 Sep 2026 09:02:09 +0200
Message-ID: <20260912065610.680404425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a687d8284161d..4c68afb5e364a 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -42,8 +42,8 @@ struct seq_midisynth {
 	int device;
 	int subdevice;
 	struct snd_rawmidi_file input_rfile;
-	spinlock_t output_lock;		/* protects output_rfile publication */
 	snd_use_lock_t output_use_lock;	/* in-flight event_input users */
+	struct snd_rawmidi_substream __rcu *output_substream;
 	struct snd_rawmidi_file output_rfile;
 	int seq_client;
 	int seq_port;
@@ -133,8 +133,8 @@ static int event_process_midi(struct snd_seq_event *ev, int direct,
 	if (snd_BUG_ON(!msynth))
 		return -EINVAL;
 
-	scoped_guard(spinlock_irqsave, &msynth->output_lock) {
-		substream = msynth->output_rfile.output;
+	scoped_guard(rcu) {
+		substream = rcu_dereference(msynth->output_substream);
 		if (!substream)
 			return -ENODEV;
 		snd_use_lock_use(&msynth->output_use_lock);
@@ -176,7 +176,6 @@ static int snd_seq_midisynth_new(struct seq_midisynth *msynth,
 	msynth->card = card;
 	msynth->device = device;
 	msynth->subdevice = subdevice;
-	spin_lock_init(&msynth->output_lock);
 	snd_use_lock_init(&msynth->output_use_lock);
 	return 0;
 }
@@ -253,8 +252,8 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 		return err;
 	}
 	snd_midi_event_reset_decode(msynth->parser);
-	scoped_guard(spinlock_irqsave, &msynth->output_lock)
-		msynth->output_rfile = rfile;
+	msynth->output_rfile = rfile;
+	rcu_assign_pointer(msynth->output_substream, rfile.output);
 	return 0;
 }
 
@@ -262,17 +261,16 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
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



