Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790082E11A6;
	Tue, 31 Mar 2026 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976636; cv=none; b=Lb2S+hlTF7r148AAY6Lp8MGRjKv2IThvMzX6V/F9joY4wk1pyDU3wl76R06h2NHwJbOxECANtP41bVxDGiDku144Jen3oOQ3e6rdm+UyhN/5qGGSn6+hL9cOQrGqoU3QMI2On1N68igoOmj6WLTM+ag0/VWDUQwFeDS2SfcDyGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976636; c=relaxed/simple;
	bh=bqObKNGDwopKEeMVBMUmEQYN1QtLMX6SNkr60eC5aXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFcHhEiMznRcFzOC2cOSPHwnLX8CAqGgVd0Mg6ja2GlO/oUGSCRzxV71g0L2izTI/uMF9/UwFfj3TgMIrJOZmZoqNICdtvvDy88Q2YOFy74ZK4siQewk9mW0lWapttIhjlX04tOucHXMmUYQc2/ClzG/QCZ+XRa1fOwj3dEoFZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv+YNRGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv+YNRGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F744C19423;
	Tue, 31 Mar 2026 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976636;
	bh=bqObKNGDwopKEeMVBMUmEQYN1QtLMX6SNkr60eC5aXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv+YNRGiwd+jxHyORCbBGEJDSdS5LhbBPbaRCPtcsLIqtnZwa9TOwJLTEWQmnnRYU
	 cxlZbhwTDP7iu4kaM/7SXyCYj4CHBOIKeUkoJo+Bvg8vi99f/TgA2eK9RG3qs5kyVl
	 9Sq3+LjaM+T6jDdGNK/WiW5aH8lY8yPzwOGUR4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/309] ALSA: hda/realtek: Sequence GPIO2 on Star Labs StarFighter
Date: Tue, 31 Mar 2026 18:20:40 +0200
Message-ID: <20260331161758.518673163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit a6919f2a01f8fbf807b015e5b26aecae7db8117b ]

The initial StarFighter quirk fixed the runtime suspend pop by muting
speakers in the shutup callback before power-down. Further hardware
validation showed that the speaker path is controlled directly by LINE2
EAPD on NID 0x1b together with GPIO2 for the external amplifier.

Replace the shutup-delay workaround with explicit sequencing of those
controls at playback start and stop:
- assert LINE2 EAPD and drive GPIO2 high on PREPARE
- deassert LINE2 EAPD and drive GPIO2 low on CLEANUP

This avoids the runtime suspend pop without a sleep, and also fixes pops
around G3 entry and display-manager start that the original workaround
did not cover.

Fixes: 1cb3c20688fc ("ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter")
Tested-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Link: https://patch.msgid.link/20260315201127.33744-1-sean@starlabs.systems
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 38 ++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 38fe144e6238a..b7d2c6f8f73ce 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1017,12 +1017,30 @@ static int alc269_resume(struct hda_codec *codec)
 	return 0;
 }
 
-#define STARLABS_STARFIGHTER_SHUTUP_DELAY_MS	30
+#define ALC233_STARFIGHTER_SPK_PIN	0x1b
+#define ALC233_STARFIGHTER_GPIO2	0x04
 
-static void starlabs_starfighter_shutup(struct hda_codec *codec)
+static void alc233_starfighter_update_amp(struct hda_codec *codec, bool on)
 {
-	if (snd_hda_gen_shutup_speakers(codec))
-		msleep(STARLABS_STARFIGHTER_SHUTUP_DELAY_MS);
+	snd_hda_codec_write(codec, ALC233_STARFIGHTER_SPK_PIN, 0,
+			    AC_VERB_SET_EAPD_BTLENABLE,
+			    on ? AC_EAPDBTL_EAPD : 0);
+	alc_update_gpio_data(codec, ALC233_STARFIGHTER_GPIO2, on);
+}
+
+static void alc233_starfighter_pcm_hook(struct hda_pcm_stream *hinfo,
+					struct hda_codec *codec,
+					struct snd_pcm_substream *substream,
+					int action)
+{
+	switch (action) {
+	case HDA_GEN_PCM_ACT_PREPARE:
+		alc233_starfighter_update_amp(codec, true);
+		break;
+	case HDA_GEN_PCM_ACT_CLEANUP:
+		alc233_starfighter_update_amp(codec, false);
+		break;
+	}
 }
 
 static void alc233_fixup_starlabs_starfighter(struct hda_codec *codec,
@@ -1031,8 +1049,16 @@ static void alc233_fixup_starlabs_starfighter(struct hda_codec *codec,
 {
 	struct alc_spec *spec = codec->spec;
 
-	if (action == HDA_FIXUP_ACT_PRE_PROBE)
-		spec->shutup = starlabs_starfighter_shutup;
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gpio_mask |= ALC233_STARFIGHTER_GPIO2;
+		spec->gpio_dir |= ALC233_STARFIGHTER_GPIO2;
+		spec->gpio_data &= ~ALC233_STARFIGHTER_GPIO2;
+		break;
+	case HDA_FIXUP_ACT_PROBE:
+		spec->gen.pcm_playback_hook = alc233_starfighter_pcm_hook;
+		break;
+	}
 }
 
 static void alc269_fixup_pincfg_no_hp_to_lineout(struct hda_codec *codec,
-- 
2.53.0



