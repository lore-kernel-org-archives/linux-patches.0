Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA615475F;
	Sat, 12 Sep 2026 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225481; cv=none; b=fysqOoUNVbzpZTUH9KfivoSUfB0NQWTYwiovilfn1PQFm27VDvtqVeizkDxRrCv8Y6I3+T+JyMMxpaksfygQ1qXygfVZh5nsqjbcrxbj+m1FgEfWTXC07lZB26QuNaW3i3rGdXzvCII6yQX9vkeGun96bqHJz748LX/Ych6/GSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225481; c=relaxed/simple;
	bh=gDbcp2e4OnXq7qz/5v/CoBOxqzmq9X+amsVwT80LvHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nuyy4hck/V39OpVJrpBH/PVAhpqKRNDSNdJg4UThMNDr+mWdUsJczZkrG5mIsPRaIFI+ANFS1bXZHlOsNS6OER0VqEZbliFlWvGCz9E7Khcw0Akgv3GAi+pYXxp+uxaaimvWmJoeK4/kLMJfckvwFckFOUKWACy5bPKcseexa3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo2UKA2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo2UKA2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29761F000FF;
	Sat, 12 Sep 2026 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225478;
	bh=b7+yeuAURf1NQyzIXFpVTWrbYWyHhwqtE63Nh8pU8m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mo2UKA2hnoZ6riiDldxBw9/0MjyVqn+AeENYACjO5bM8M2HcAnvIxWLpCx0J6iRQv
	 Ffzc2u3knQUDLRGw2u4z2mszg3y8uKA2/YTLGyM0IAO5+j0A4BrvwwMj9gPSNzz3pm
	 f6959iXL2Y91e+lZKIzKTz/YPSgX/4MUdAy40qv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1206/1424] ALSA: seq: midi: Serialize input teardown with event_input
Date: Sat, 12 Sep 2026 09:00:38 +0200
Message-ID: <20260912065634.292808449@linuxfoundation.org>
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
index 50e39b34f5ac5..2006313dc9255 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -42,6 +42,8 @@ struct seq_midisynth {
 	struct snd_rawmidi *rmidi;
 	int device;
 	int subdevice;
+	struct snd_rawmidi_substream __rcu *input_substream;
+	snd_use_lock_t input_use_lock;	/* in-flight event_input users */
 	struct snd_rawmidi_file input_rfile;
 	snd_use_lock_t output_use_lock;	/* in-flight event_input users */
 	struct snd_rawmidi_substream __rcu *output_substream;
@@ -76,6 +78,14 @@ static void snd_midi_input_event(struct snd_rawmidi_substream *substream)
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
@@ -95,6 +105,8 @@ static void snd_midi_input_event(struct snd_rawmidi_substream *substream)
 			memset(&ev, 0, sizeof(ev));
 		}
 	}
+
+	snd_use_lock_free(&msynth->input_use_lock);
 }
 
 static int dump_midi(struct snd_rawmidi_substream *substream, const char *buf, int count)
@@ -177,6 +189,7 @@ static int snd_seq_midisynth_new(struct seq_midisynth *msynth,
 	msynth->card = card;
 	msynth->device = device;
 	msynth->subdevice = subdevice;
+	snd_use_lock_init(&msynth->input_use_lock);
 	snd_use_lock_init(&msynth->output_use_lock);
 	return 0;
 }
@@ -187,28 +200,31 @@ static int midisynth_subscribe(void *private_data, struct snd_seq_port_subscribe
 	int err;
 	struct seq_midisynth *msynth = private_data;
 	struct snd_rawmidi_runtime *runtime;
+	struct snd_rawmidi_file rfile = {};
 	struct snd_rawmidi_params params;
 
 	/* open midi port */
 	err = snd_rawmidi_kernel_open(msynth->rmidi, msynth->subdevice,
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



