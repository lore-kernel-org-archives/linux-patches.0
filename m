Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE2834D385;
	Thu, 30 Jul 2026 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422743; cv=none; b=RXVHdOGsGwvmZFBJv4iDFI7++vvr0ERq6XPJaRJcA6o7tUaNrqfQbkTTNE+HD3xhVy9GU+KpGv5MBPib3ZrQ657e5EOdgl20lCVMu5ZArTHVj3y6+upqeB8oBYckMmFozOc3/Bchf7QVOW4nc/4wpfUIctFXjxMuIh3xc3ea8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422743; c=relaxed/simple;
	bh=HDbtFz3Qlk9J65nXEmQ5DwxY4l5mttRqqmWpEPIHNVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMYjCYpMBO0Gg5omlKSHw2F3jXn4V2gTWiM7hHX5awnSItoQqQBkO3HFExUO7ZDZnGhVdcRIsL29f5PP6j6quTLRchu6G5bDxNAUEg9MF6jHX4z8//e4ShdBMeOmbP6MMFM9oawbMPX1iPWgMfsOQ7DLBYvdXa99PqvlL0zqhq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7etCBm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7etCBm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ECE1F000E9;
	Thu, 30 Jul 2026 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422741;
	bh=PFYWE8d4/ycxHM3UPelCK75aXX7VQfLBXgRwbTkw8YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7etCBm8WQcYA2E6yquJ+ATE2FRz4VfKm7NKbCgSW9OFVZRafJOOAmoSMZQ/qSD5n
	 LYBfFTzeEvlxD6do9JXs/dZp5aXfumMR5SzOp0LGM2b6DESfjNyJ3RShM9CVeHgum0
	 EhM/eep6AdqMmMKLHvqbzSJcgfqq6m2iCkYS+V8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kaplan <alexander.kaplan@sms-medipool.de>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 540/744] ALSA: hda: codecs: hdmi: disable keep-alive before audio format change
Date: Thu, 30 Jul 2026 16:13:33 +0200
Message-ID: <20260730141455.753134297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit a3d6d3cedfe87bbd5a677d52b22ac20d28e59cf8 upstream.

When a keep-alive (KAE) silent stream is active on an Intel HDMI/DP
codec, opening a real PCM stream reprograms the converter format and the
audio infoframe in snd_hda_hdmi_generic_pcm_prepare(). Part of that
reprogramming - the converter channel count and the channel mapping in
snd_hda_hdmi_setup_audio_infoframe() - is not safe to do while a
keep-alive stream is active. This is most visible when switching to a
multichannel PCM configuration, where the active channel count actually
changes. In that case the newly opened PCM stream plays no sound.

Add an optional hdmi_ops .prepare hook, called at the start of the
PCM prepare sequence (before the format and infoframe are touched), and
implement it for HSW+ to release keep-alive. Keep-alive is then
re-enabled as before once the new stream has been set up, in the
setup_stream op.

Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Reported-by: Alexander Kaplan <alexander.kaplan@sms-medipool.de>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8412
Tested-by: Alexander Kaplan <alexander.kaplan@sms-medipool.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20260715180610.1371243-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/hdmi/hdmi.c       |    3 +++
 sound/hda/codecs/hdmi/hdmi_local.h |    9 +++++++++
 sound/hda/codecs/hdmi/intelhdmi.c  |   36 ++++++++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 6 deletions(-)

--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -1688,6 +1688,9 @@ int snd_hda_hdmi_generic_pcm_prepare(str
 		per_pin->channels = substream->runtime->channels;
 		per_pin->setup = true;
 
+		if (spec->ops.prepare)
+			spec->ops.prepare(codec, per_pin);
+
 		if (get_wcaps(codec, cvt_nid) & AC_WCAP_STRIPE) {
 			stripe = snd_hdac_get_stream_stripe_ctl(&codec->bus->core,
 								substream);
--- a/sound/hda/codecs/hdmi/hdmi_local.h
+++ b/sound/hda/codecs/hdmi/hdmi_local.h
@@ -74,6 +74,15 @@ struct hdmi_ops {
 			    hda_nid_t pin_nid, int dev_id, u32 stream_tag,
 			    int format);
 
+	/*
+	 * Optional hook invoked at the beginning of the PCM prepare
+	 * sequence, before the audio infoframe and stream format are
+	 * (re)programmed. Used to disable keep-alive / silent stream so
+	 * that the format change is not done while keep-alive is active.
+	 */
+	void (*prepare)(struct hda_codec *codec,
+			struct hdmi_spec_per_pin *per_pin);
+
 	void (*pin_cvt_fixup)(struct hda_codec *codec,
 			      struct hdmi_spec_per_pin *per_pin,
 			      hda_nid_t cvt_nid);
--- a/sound/hda/codecs/hdmi/intelhdmi.c
+++ b/sound/hda/codecs/hdmi/intelhdmi.c
@@ -418,6 +418,28 @@ static void intel_not_share_assigned_cvt
 		intel_not_share_assigned_cvt(codec, pin_nid, dev_id, mux_idx);
 }
 
+/*
+ * prepare ops override for HSW+
+ *
+ * Disable keep-alive before the converter format and audio infoframe are
+ * reprogrammed by the PCM prepare sequence. Changing the audio format (e.g.
+ * the channel count when switching to multichannel PCM) while a keep-alive
+ * stream is active is not safe, so release keep-alive here, early in the
+ * sequence. It is re-enabled once the new stream has been set up, in
+ * i915_hsw_setup_stream().
+ */
+static void i915_hsw_prepare(struct hda_codec *codec,
+			     struct hdmi_spec_per_pin *per_pin)
+{
+	struct hdmi_spec *spec = codec->spec;
+
+	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin->silent_stream) {
+		silent_stream_set_kae(codec, per_pin, false);
+		/* wait for pending transfers in codec to clear */
+		usleep_range(100, 200);
+	}
+}
+
 /* setup_stream ops override for HSW+ */
 static int i915_hsw_setup_stream(struct hda_codec *codec, hda_nid_t cvt_nid,
 				 hda_nid_t pin_nid, int dev_id, u32 stream_tag,
@@ -435,15 +457,16 @@ static int i915_hsw_setup_stream(struct
 
 	haswell_verify_D0(codec, cvt_nid, pin_nid);
 
-	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin && per_pin->silent_stream) {
-		silent_stream_set_kae(codec, per_pin, false);
-		/* wait for pending transfers in codec to clear */
-		usleep_range(100, 200);
-	}
-
 	res = snd_hda_hdmi_setup_stream(codec, cvt_nid, pin_nid, dev_id,
 					stream_tag, format);
 
+	/*
+	 * Keep-alive was disabled in i915_hsw_prepare(), re-enable it now.
+	 * The pin lookup above resolves to the same per_pin that prepare
+	 * used (pin_nid comes from that per_pin), so this stays balanced; a
+	 * NULL per_pin only occurs on a lookup failure that also implies no
+	 * active keep-alive stream to restore.
+	 */
 	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin && per_pin->silent_stream) {
 		usleep_range(100, 200);
 		silent_stream_set_kae(codec, per_pin, true);
@@ -607,6 +630,7 @@ static int intel_hsw_common_init(struct
 	codec->depop_delay = 0;
 	codec->auto_runtime_pm = 1;
 
+	spec->ops.prepare = i915_hsw_prepare;
 	spec->ops.setup_stream = i915_hsw_setup_stream;
 	spec->ops.pin_cvt_fixup = i915_pin_cvt_fixup;
 	spec->ops.silent_stream = i915_set_silent_stream;


