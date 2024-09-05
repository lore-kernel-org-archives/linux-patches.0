Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAE0198A08;
	Thu,  5 Sep 2024 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530020; cv=none; b=jL+X+9Btd//UqJb09aFLj1gO58wkL/BI8BNq4ENfyLN9VL15H+y01ops1qnd3j9RhuemrQpvTRDSnosqahOcvlM7kRAV7sTEG9VSHu9PS6WQKlAL88eN2BvOXheztHacgL2ud9X1qY4a4d7R8LCcAoG/BhwfLCjTcDpPdGmL82o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530020; c=relaxed/simple;
	bh=M3YLr7OJx+4uItK5/62KPI5zYrL6WkICaObG8O2Z7Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsXFQI2QnMrO0cG5TFPbuAAFR5CETPqDVb/xfifapA9/hqhwI74OOaoRpnqzp1y6gu17ILuW5ULAa/1PnZtBkjy5UE705XueSRN45X+Jadm8GANjX9Xc2FpRbNZ5jmtguIMvPm1fWIIM4h6Fyp3M3bNMLTyu4slK8Q3zf4cVVWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow7KiKOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow7KiKOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A979C4CEC4;
	Thu,  5 Sep 2024 09:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530020;
	bh=M3YLr7OJx+4uItK5/62KPI5zYrL6WkICaObG8O2Z7Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow7KiKOMitOcUnLgNGxkdbVukRg3MvnOjNyr1G88vr4ct9cFNrGSF/yYGDRpKQqFD
	 SNF71Gr5Qt+uVYtI/BIXEjR2Io4AXlYJaInmJOdQyLQ+jLhSg1CkCEAPA+DoCARd45
	 1P55F27HhwqYBN7Wychj5hTxbW/gUxt/DthT4BFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/132] ALSA: hda/generic: Add a helper to mute speakers at suspend/shutdown
Date: Thu,  5 Sep 2024 11:39:53 +0200
Message-ID: <20240905093722.483416897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6cd23b26b348fa52c88e1adf9c0e48d68e13f95e ]

Some devices indicate click noises at suspend or shutdown when the
speakers are unmuted.  This patch adds a helper,
snd_hda_gen_shutup_speakers(), to work around it.  The new function is
supposed to be called at suspend or shutdown by the codec driver, and
it mutes the speakers.

The mute status isn't cached, hence the original mute state will be
restored at resume again.

Link: https://patch.msgid.link/20240726142625.2460-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_generic.c | 63 +++++++++++++++++++++++++++++++++++++
 sound/pci/hda/hda_generic.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index bf685d01259d3..d3ed3e21b1979 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4956,6 +4956,69 @@ void snd_hda_gen_stream_pm(struct hda_codec *codec, hda_nid_t nid, bool on)
 }
 EXPORT_SYMBOL_GPL(snd_hda_gen_stream_pm);
 
+/* forcibly mute the speaker output without caching; return true if updated */
+static bool force_mute_output_path(struct hda_codec *codec, hda_nid_t nid)
+{
+	if (!nid)
+		return false;
+	if (!nid_has_mute(codec, nid, HDA_OUTPUT))
+		return false; /* no mute, skip */
+	if (snd_hda_codec_amp_read(codec, nid, 0, HDA_OUTPUT, 0) &
+	    snd_hda_codec_amp_read(codec, nid, 1, HDA_OUTPUT, 0) &
+	    HDA_AMP_MUTE)
+		return false; /* both channels already muted, skip */
+
+	/* direct amp update without caching */
+	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_AMP_GAIN_MUTE,
+			    AC_AMP_SET_OUTPUT | AC_AMP_SET_LEFT |
+			    AC_AMP_SET_RIGHT | HDA_AMP_MUTE);
+	return true;
+}
+
+/**
+ * snd_hda_gen_shutup_speakers - Forcibly mute the speaker outputs
+ * @codec: the HDA codec
+ *
+ * Forcibly mute the speaker outputs, to be called at suspend or shutdown.
+ *
+ * The mute state done by this function isn't cached, hence the original state
+ * will be restored at resume.
+ *
+ * Return true if the mute state has been changed.
+ */
+bool snd_hda_gen_shutup_speakers(struct hda_codec *codec)
+{
+	struct hda_gen_spec *spec = codec->spec;
+	const int *paths;
+	const struct nid_path *path;
+	int i, p, num_paths;
+	bool updated = false;
+
+	/* if already powered off, do nothing */
+	if (!snd_hdac_is_power_on(&codec->core))
+		return false;
+
+	if (spec->autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT) {
+		paths = spec->out_paths;
+		num_paths = spec->autocfg.line_outs;
+	} else {
+		paths = spec->speaker_paths;
+		num_paths = spec->autocfg.speaker_outs;
+	}
+
+	for (i = 0; i < num_paths; i++) {
+		path = snd_hda_get_path_from_idx(codec, paths[i]);
+		if (!path)
+			continue;
+		for (p = 0; p < path->depth; p++)
+			if (force_mute_output_path(codec, path->path[p]))
+				updated = true;
+	}
+
+	return updated;
+}
+EXPORT_SYMBOL_GPL(snd_hda_gen_shutup_speakers);
+
 /**
  * snd_hda_gen_parse_auto_config - Parse the given BIOS configuration and
  * set up the hda_gen_spec
diff --git a/sound/pci/hda/hda_generic.h b/sound/pci/hda/hda_generic.h
index a8eea83676299..aed4381f7a619 100644
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -355,5 +355,6 @@ int snd_hda_gen_add_mute_led_cdev(struct hda_codec *codec,
 int snd_hda_gen_add_micmute_led_cdev(struct hda_codec *codec,
 				     int (*callback)(struct led_classdev *,
 						     enum led_brightness));
+bool snd_hda_gen_shutup_speakers(struct hda_codec *codec);
 
 #endif /* __SOUND_HDA_GENERIC_H */
-- 
2.43.0



