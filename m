Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC99415F23;
	Tue, 21 Jul 2026 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665797; cv=none; b=eeEdtCg6cRpLIXeXnUPxDEMt/21AGnnxDFleaGTV2e6skcSEJhxUEMRQo7sVkAKuOkPfdWyRhzKlXnAwtLj7Qr8noqGnLDSSosBJjQRY/JBmpcy0P/O87Ez55nbOiFI4Wp2aXQkKF1047DKuEXMzhXQKXWpO8TNjKkrTaAvJNR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665797; c=relaxed/simple;
	bh=kWwvDbMQuEtuM0TmNZmk9ukzeawcgXhPrPtV+TVJYyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMlwLMz5STt7pmSIyJcA+BzGkiJSpBNX9w+lwPacRKD+62sogqb+EzR0OEG19j5oZsF8MO/TswVP4XEINCcJ7P8ITo/IzB60DP1Yygw5z9/4ajIV6+LM56CLsXCqvBMkqA9QXkKu5vWPxOH70KGVBqK1+n3hOiswgSFIwLsmTk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK/aGeoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK/aGeoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E12A1F000E9;
	Tue, 21 Jul 2026 20:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665795;
	bh=/pNRTsyszRgy5Yr9+AqbpEDnxkPq8rtz4A2s2wHrIi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pK/aGeoDIfKzx4XA7bGyqFOp185tMhMf8egcvQctlYMF9D62hbcfSeRmgQsG6cLK6
	 f0HZBNYYwQW9IAeIeZE7dh3LjSY/n9Z0zwHe7Y3R2bfckJio3Gxj85slz4enJ1rcPZ
	 j1Nfq/kBQd3GkiAzU42Xdgq88VFagx/QKpXn03mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0439/1266] ALSA: seq: midi: Serialize output teardown with event_input
Date: Tue, 21 Jul 2026 17:14:36 +0200
Message-ID: <20260721152451.663287293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit ef7607ab1c8adc6258fb1b27d08e26aecdc18a58 ]

event_process_midi() borrows msynth->output_rfile.output and then
passes the substream to dump_midi() and snd_rawmidi_kernel_write()
without synchronizing with the output open/close transition.
midisynth_use() also publishes output_rfile before
snd_rawmidi_output_params() has finished.

The last midisynth_unuse() can therefore release the same rawmidi file
and free substream->runtime before snd_rawmidi_kernel_write1() takes
its runtime buffer reference. That leaves the event_input path using a
stale substream or runtime and can end in a NULL-deref or use-after-free.

Fix this with two pieces of synchronization. Keep a short IRQ-safe
spinlock only for publishing or clearing output_rfile and for pairing
the output snapshot with an snd_use_lock_t reference. Once
event_process_midi() has taken that in-flight reference, it drops the
spinlock before calling snd_seq_dump_var_event(), dump_midi(), or
snd_rawmidi_kernel_write(). midisynth_unuse() now detaches the visible
rawmidi file under the same spinlock, waits for the in-flight writers
to drain, and only then drains and releases the saved file.
midisynth_use() likewise opens into a local snd_rawmidi_file and
publishes it only after snd_rawmidi_output_params() succeeds.

The buggy scenario involves two paths, with each column showing the
order within that path:

event_input path:                     last unuse path:
1. event_process_midi() snapshots    1. midisynth_unuse() starts
   output_rfile.output.                 tearing down output_rfile.
2. dump_midi() reaches               2. snd_rawmidi_kernel_release()
   snd_rawmidi_kernel_write()           closes the output file.
   before runtime is pinned.         3. close_substream() frees
3. The callback keeps using             substream->runtime.
   the borrowed substream.

Validation reproduced this kernel report:
KASAN null-ptr-deref in snd_rawmidi_kernel_write1+0x56/0x360
RIP: 0033:0x7fde7dd0837f
RIP: 0010:snd_rawmidi_kernel_write1+0x56/0x360

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Link: https://patch.msgid.link/20260527062948.3614025-1-rollkingzzc@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_midi.c | 55 +++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 78dcb0ea155827..c8a7c39747113d 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -24,6 +24,7 @@ Possible options for midisynth module:
 #include <sound/seq_device.h>
 #include <sound/seq_midi_event.h>
 #include <sound/initval.h>
+#include "seq_lock.h"
 
 MODULE_AUTHOR("Frank van de Pol <fvdpol@coil.demon.nl>, Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Advanced Linux Sound Architecture sequencer MIDI synth.");
@@ -42,6 +43,8 @@ struct seq_midisynth {
 	int device;
 	int subdevice;
 	struct snd_rawmidi_file input_rfile;
+	spinlock_t output_lock;		/* protects output_rfile publication */
+	snd_use_lock_t output_use_lock;	/* in-flight event_input users */
 	struct snd_rawmidi_file output_rfile;
 	int seq_client;
 	int seq_port;
@@ -125,31 +128,42 @@ static int event_process_midi(struct snd_seq_event *ev, int direct,
 	struct seq_midisynth *msynth = private_data;
 	unsigned char msg[10];	/* buffer for constructing midi messages */
 	struct snd_rawmidi_substream *substream;
+	int err = 0;
 	int len;
 
 	if (snd_BUG_ON(!msynth))
 		return -EINVAL;
-	substream = msynth->output_rfile.output;
-	if (substream == NULL)
-		return -ENODEV;
+
+	scoped_guard(spinlock_irqsave, &msynth->output_lock) {
+		substream = msynth->output_rfile.output;
+		if (!substream)
+			return -ENODEV;
+		snd_use_lock_use(&msynth->output_use_lock);
+	}
+
 	if (ev->type == SNDRV_SEQ_EVENT_SYSEX) {	/* special case, to save space */
 		if ((ev->flags & SNDRV_SEQ_EVENT_LENGTH_MASK) != SNDRV_SEQ_EVENT_LENGTH_VARIABLE) {
 			/* invalid event */
 			pr_debug("ALSA: seq_midi: invalid sysex event flags = 0x%x\n", ev->flags);
-			return 0;
+			goto out;
 		}
 		snd_seq_dump_var_event(ev, __dump_midi, substream);
 		snd_midi_event_reset_decode(msynth->parser);
 	} else {
-		if (msynth->parser == NULL)
-			return -EIO;
+		if (!msynth->parser) {
+			err = -EIO;
+			goto out;
+		}
 		len = snd_midi_event_decode(msynth->parser, msg, sizeof(msg), ev);
 		if (len < 0)
-			return 0;
+			goto out;
 		if (dump_midi(substream, msg, len) < 0)
 			snd_midi_event_reset_decode(msynth->parser);
 	}
-	return 0;
+
+out:
+	snd_use_lock_free(&msynth->output_use_lock);
+	return err;
 }
 
 
@@ -163,6 +177,8 @@ static int snd_seq_midisynth_new(struct seq_midisynth *msynth,
 	msynth->card = card;
 	msynth->device = device;
 	msynth->subdevice = subdevice;
+	spin_lock_init(&msynth->output_lock);
+	snd_use_lock_init(&msynth->output_use_lock);
 	return 0;
 }
 
@@ -215,12 +231,13 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 {
 	int err;
 	struct seq_midisynth *msynth = private_data;
+	struct snd_rawmidi_file rfile = {};
 	struct snd_rawmidi_params params;
 
 	/* open midi port */
 	err = snd_rawmidi_kernel_open(msynth->rmidi, msynth->subdevice,
 				      SNDRV_RAWMIDI_LFLG_OUTPUT,
-				      &msynth->output_rfile);
+				      &rfile);
 	if (err < 0) {
 		pr_debug("ALSA: seq_midi: midi output open failed!!!\n");
 		return err;
@@ -229,12 +246,14 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 	params.avail_min = 1;
 	params.buffer_size = output_buffer_size;
 	params.no_active_sensing = 1;
-	err = snd_rawmidi_output_params(msynth->output_rfile.output, &params);
+	err = snd_rawmidi_output_params(rfile.output, &params);
 	if (err < 0) {
-		snd_rawmidi_kernel_release(&msynth->output_rfile);
+		snd_rawmidi_kernel_release(&rfile);
 		return err;
 	}
 	snd_midi_event_reset_decode(msynth->parser);
+	scoped_guard(spinlock_irqsave, &msynth->output_lock)
+		msynth->output_rfile = rfile;
 	return 0;
 }
 
@@ -242,11 +261,19 @@ static int midisynth_use(void *private_data, struct snd_seq_port_subscribe *info
 static int midisynth_unuse(void *private_data, struct snd_seq_port_subscribe *info)
 {
 	struct seq_midisynth *msynth = private_data;
+	struct snd_rawmidi_file rfile = {};
 
-	if (snd_BUG_ON(!msynth->output_rfile.output))
+	scoped_guard(spinlock_irqsave, &msynth->output_lock) {
+		rfile = msynth->output_rfile;
+		msynth->output_rfile = (struct snd_rawmidi_file){};
+	}
+
+	if (snd_BUG_ON(!rfile.output))
 		return -EINVAL;
-	snd_rawmidi_drain_output(msynth->output_rfile.output);
-	return snd_rawmidi_kernel_release(&msynth->output_rfile);
+
+	snd_use_lock_sync(&msynth->output_use_lock);
+	snd_rawmidi_drain_output(rfile.output);
+	return snd_rawmidi_kernel_release(&rfile);
 }
 
 /* delete given midi synth port */
-- 
2.53.0



