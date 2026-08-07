Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3733DEFE;
	Fri,  7 Aug 2026 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116542; cv=none; b=k1/ojd5cQ1zVqaIemLsUxUoK7nSb+n+3IOt4oiKqwhX0xv1ohTZrG1NqophuBX37P57MnaOdc+1f7bch4KYR6yfMw1ay48xVt0HXq2CsHL7aehpHgMUgU66TvYxMEqCHinrdfMGNIr1IRfM8euBP2nyKXragudgI8XKuOkYtyV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116542; c=relaxed/simple;
	bh=lsst7jXRymPGWymnavfEjfw1LVk7DwpNY2JociBSBwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgeR5ENSvLUE9J+YkLERIByM9ifEdgWtw0KevppdZ/v2BxS39XVcgwL55RkEAl5CKkhq5w2fzof/w4PNdC4i2ovqhVugKj3v0pcaXrmE66tcX/z6K8BwR6ckts6v0oNyfn7W3VlmfiDuMLzDfTu/e9/PeOi4h+IpaEiiYjTi/OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVXCX76t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVXCX76t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A771F000E9;
	Fri,  7 Aug 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116539;
	bh=aX81Lv9k0MpOoDYEZkNn2ByHn2ldur+A+a2Iut9vsHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVXCX76tf237cmPib6tXb7EV8v9uR/Ddz4bQ2aG2ghr1yg73EIkk42fe11wsD4L3X
	 OF5IWr2eb7JbYqIkXpGdoa6odUJO2GgaDMbe5oOcumSG6YLHcY1l28B8UDpwoAgejb
	 zkZ4Kj6BM+nvEr6kyZ1nK3esxJLKU2w4DJVSD9AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kaplan <alexander.kaplan@sms-medipool.de>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/261] ALSA: hda: codecs: hdmi: disable keep-alive before audio format change
Date: Fri,  7 Aug 2026 16:40:16 +0200
Message-ID: <20260807143421.009851909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit a3d6d3cedfe87bbd5a677d52b22ac20d28e59cf8 ]

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
[ adapted three hunks from the post-6.12 split files (hdmi.c/hdmi_local.h/intelhdmi.c) back into the monolithic sound/pci/hda/patch_hdmi.c, with the prepare hook un-indented one level since 6.12 uses plain mutex_lock() instead of scoped_guard() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   48 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -111,6 +111,15 @@ struct hdmi_ops {
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
@@ -2134,6 +2143,9 @@ static int generic_hdmi_playback_pcm_pre
 	per_pin->channels = substream->runtime->channels;
 	per_pin->setup = true;
 
+	if (spec->ops.prepare)
+		spec->ops.prepare(codec, per_pin);
+
 	if (get_wcaps(codec, cvt_nid) & AC_WCAP_STRIPE) {
 		stripe = snd_hdac_get_stream_stripe_ctl(&codec->bus->core,
 							substream);
@@ -2905,6 +2917,28 @@ static void register_i915_notifier(struc
 	codec->relaxed_resume = 1;
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
@@ -2922,15 +2956,16 @@ static int i915_hsw_setup_stream(struct
 
 	haswell_verify_D0(codec, cvt_nid, pin_nid);
 
-	if (spec->silent_stream_type == SILENT_STREAM_KAE && per_pin && per_pin->silent_stream) {
-		silent_stream_set_kae(codec, per_pin, false);
-		/* wait for pending transfers in codec to clear */
-		usleep_range(100, 200);
-	}
-
 	res = hdmi_setup_stream(codec, cvt_nid, pin_nid, dev_id,
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
@@ -3106,6 +3141,7 @@ static int intel_hsw_common_init(struct
 	codec->depop_delay = 0;
 	codec->auto_runtime_pm = 1;
 
+	spec->ops.prepare = i915_hsw_prepare;
 	spec->ops.setup_stream = i915_hsw_setup_stream;
 	spec->ops.pin_cvt_fixup = i915_pin_cvt_fixup;
 


