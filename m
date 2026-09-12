Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDBF41169F;
	Sat, 12 Sep 2026 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231460; cv=none; b=Lixlp/fFi2H9o5frfT3S15wlY8iYVrDL338nhVMr9nqaOAVWqJG/lZRWaNLb8a13Vi8xikkqPaFWqr5eszc3TMBonin/mx5tLpsqK01Sn+8CTcSm5165+zA8rT9mUw5Sm+Nrqnlu9nIdPMSMwHU8zaeTKqkcK1wM3YlQ/5UAx1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231460; c=relaxed/simple;
	bh=HipXh1DI/bkw5b6MAB5KG5VuST/ICZL9+Y71e01D89w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR/N0NFrd5JjmjeEe5NArLD7toxweEz9SwRddPVWRV0tl/0v4Aq9if5TFvD7vpanE5YwuEg59uEGmXaJkvI4xpupJjL75EAHa5qjj84HfMsEj6SQrbhD0REjUqzuLAAoizAvP3ETOC79vGLtnbTZBf7IvKQUVjdH7jSMGp++nFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6Qx+Ure; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6Qx+Ure"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1E11F000FF;
	Sat, 12 Sep 2026 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231458;
	bh=9JBi/IXA8k8dACf6xmCRLUrBb+gskSPt8FU25+xHKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6Qx+UrekwguMuueGreFdEeuQuAude1A5+yZ68PhGetzMEaOLAU9kJs5vAaDeXFYP
	 MAmZIg2yx3JynQOPth/QeAm30Uq3OSGtsA+tp3gi+Sct4i2BC1bMGfBdEuNeSDtZT1
	 KkOoJ2ydZ+aJoo5bun6oqPa4C4sleoAOWIYqefPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1002/1191] ALSA: seq: midi: Serialize input teardown with event_input
Date: Sat, 12 Sep 2026 09:02:10 +0200
Message-ID: <20260912065610.701742984@linuxfoundation.org>
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

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 403f7f3ad3808a0096d84cf228fab68dc253fd9d ]

snd_midi_input_event() must not be running while a rawmidi substream is
closing, since this can lead to the trigger state becoming out-of-step
through this sequence in snd_rawmidi_input_trigger():

	snd_rawmidi_input_trigger(up=0)
					snd_midi_input_event()
					 -> snd_rawmidi_kernel_read()
					     -> snd_rawmidi_input_trigger(up=1)
	  -> cancel_work_sync()

which ends with the underlying device being active unexpectedly.

When this is called from close_substream(), further input can re-trigger
the input event leaving it running after rawmidi_release_priv() has set
rfile->rmidi to NULL which leads to:

	Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b0
	Call trace:
	 snd_midi_input_event+0x3c/0x134 [snd_seq_midi] (P)
	 snd_rawmidi_input_event_work+0x1c/0x2c
	 process_one_work+0x150/0x3a4
	 worker_thread+0x190/0x318

Apply a similar approach to commit ef7607ab1c8ad ("ALSA: seq: midi:
Serialize output teardown with event_input") which fixed the same issue
in the output direction, but updated to use RCU following Takashi Iwai's
proposed follow-on patch [1].

With this change in place, midisynth_unsubscribe() clears the input file
so snd_midi_input_event() will not re-trigger the stream and will be
quiesced by the cancel_work_sync() in snd_rawmidi_input_trigger().

[1] https://lore.kernel.org/linux-sound/20260813144224.753399-1-tiwai@suse.de/

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://patch.msgid.link/20260813150810.795393-1-jkeeping@inmusicbrands.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_midi.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 4c68afb5e364a..e65705d4da86f 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -41,6 +41,8 @@ struct seq_midisynth {
 	struct snd_card *card;
 	int device;
 	int subdevice;
+	struct snd_rawmidi_substream __rcu *input_substream;
+	snd_use_lock_t input_use_lock;	/* in-flight event_input users */
 	struct snd_rawmidi_file input_rfile;
 	snd_use_lock_t output_use_lock;	/* in-flight event_input users */
 	struct snd_rawmidi_substream __rcu *output_substream;
@@ -75,6 +77,14 @@ static void snd_midi_input_event(struct snd_rawmidi_substream *substream)
 	msynth = runtime->private_data;
 	if (msynth == NULL)
 		return;
+
+	scoped_guard(rcu) {
+		if (rcu_dereference(msynth->input_substream) != substream)
+			return;
+
+		snd_use_lock_use(&msynth->input_use_lock);
+	}
+
 	memset(&ev, 0, sizeof(ev));
 	while (runtime->avail > 0) {
 		res = snd_rawmidi_kernel_read(substream, buf, sizeof(buf));
@@ -94,6 +104,8 @@ static void snd_midi_input_event(struct snd_rawmidi_substream *substream)
 			memset(&ev, 0, sizeof(ev));
 		}
 	}
+
+	snd_use_lock_free(&msynth->input_use_lock);
 }
 
 static int dump_midi(struct snd_rawmidi_substream *substream, const char *buf, int count)
@@ -176,6 +188,7 @@ static int snd_seq_midisynth_new(struct seq_midisynth *msynth,
 	msynth->card = card;
 	msynth->device = device;
 	msynth->subdevice = subdevice;
+	snd_use_lock_init(&msynth->input_use_lock);
 	snd_use_lock_init(&msynth->output_use_lock);
 	return 0;
 }
@@ -186,29 +199,32 @@ static int midisynth_subscribe(void *private_data, struct snd_seq_port_subscribe
 	int err;
 	struct seq_midisynth *msynth = private_data;
 	struct snd_rawmidi_runtime *runtime;
+	struct snd_rawmidi_file rfile = {};
 	struct snd_rawmidi_params params;
 
 	/* open midi port */
 	err = snd_rawmidi_kernel_open(msynth->card, msynth->device,
 				      msynth->subdevice,
 				      SNDRV_RAWMIDI_LFLG_INPUT,
-				      &msynth->input_rfile);
+				      &rfile);
 	if (err < 0) {
 		pr_debug("ALSA: seq_midi: midi input open failed!!!\n");
 		return err;
 	}
-	runtime = msynth->input_rfile.input->runtime;
+	runtime = rfile.input->runtime;
 	memset(&params, 0, sizeof(params));
 	params.avail_min = 1;
 	params.buffer_size = input_buffer_size;
-	err = snd_rawmidi_input_params(msynth->input_rfile.input, &params);
+	err = snd_rawmidi_input_params(rfile.input, &params);
 	if (err < 0) {
-		snd_rawmidi_kernel_release(&msynth->input_rfile);
+		snd_rawmidi_kernel_release(&rfile);
 		return err;
 	}
 	snd_midi_event_reset_encode(msynth->parser);
 	runtime->event = snd_midi_input_event;
 	runtime->private_data = msynth;
+	msynth->input_rfile = rfile;
+	rcu_assign_pointer(msynth->input_substream, rfile.input);
 	snd_rawmidi_kernel_read(msynth->input_rfile.input, NULL, 0);
 	return 0;
 }
@@ -218,10 +234,19 @@ static int midisynth_unsubscribe(void *private_data, struct snd_seq_port_subscri
 {
 	int err;
 	struct seq_midisynth *msynth = private_data;
+	struct snd_rawmidi_file rfile;
 
-	if (snd_BUG_ON(!msynth->input_rfile.input))
+	rcu_assign_pointer(msynth->input_substream, NULL);
+	synchronize_rcu();
+	snd_use_lock_sync(&msynth->input_use_lock);
+
+	rfile = msynth->input_rfile;
+	msynth->input_rfile = (struct snd_rawmidi_file){};
+
+	if (snd_BUG_ON(!rfile.input))
 		return -EINVAL;
-	err = snd_rawmidi_kernel_release(&msynth->input_rfile);
+
+	err = snd_rawmidi_kernel_release(&rfile);
 	return err;
 }
 
-- 
2.53.0



