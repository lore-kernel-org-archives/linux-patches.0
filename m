Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E538423F;
	Tue, 10 Mar 2026 11:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140783; cv=none; b=k6eP5WOsjSJGpUOT+Ro61ivI44lEpP9oUKBrb3r8KHLZCwvCVErtm97YXcMycrwbcPUHCAyl/9W2v0uDGZkHfSIOgQXdgO9+oGwPJErsG1KBNtX4Y+HBAETNQkGiEdS9AwYPQlYw6uNCEfHZqQ38FOdx6YEMOO6I0lHCvKK3uoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140783; c=relaxed/simple;
	bh=2k5y1HAa1PaMWQgjg+U4667qe592Sfxw/kWHRDbZ2mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj/BMm8waB7316Vre0Yi/WW7aGbi84l7nizeuv+HzDZMBM5opQ934S+C9Ij69Tr3l1sdXqkdfDZptM2P4OZdAZij8pm4bi3v04Q19llsGcAGO484HTHh59sYZULAInYb/ITQ2HvDSx7666G0b5EFS8c3qjbe7hyXG6CrcwsOy8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWKpuXyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWKpuXyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF48FC2BC86;
	Tue, 10 Mar 2026 11:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140783;
	bh=2k5y1HAa1PaMWQgjg+U4667qe592Sfxw/kWHRDbZ2mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWKpuXylAcXYpFo5mj3gptOhMBI4Cp5Q+VYojvFQzHX+4737+/SwRZZ9qWmBRrt2Z
	 ljqMYr4iwpe9Fx0zybjrRMsWg0keMrhosyEOmeKt9vKD2lLH/wTdtxPXUobbiLGS9o
	 m75UCv0QQf2Os4nq5ikglSzt5E9ThhH706eBW8BazZmKghT2BHmzxN3QBJOq6u2M6j
	 OY1FOCj0qZsEDzLUj4qMqKa30cZuW+Q2DOnH7hKTQwdYT1lBWPNlXkAEobC7qa901T
	 OwL5AKa1PCS9LiVVyd+kVzcJuZCd7kDd3Xu//24gYB+nwqUVLv0E3g++PjD0eCdtA+
	 72JeN/xfj4DIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 018/311] ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP
Date: Tue, 10 Mar 2026 07:01:05 -0400
Message-ID: <e3e8b63400252d85386ec54ee0b60b77f883b25a.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 38c322068a26a01d7ff64da92179e68cdde9860b ]

Add a quirk flag to skip the usb_set_interface(),
snd_usb_init_pitch(), and snd_usb_init_sample_rate() calls in
__snd_usb_parse_audio_interface(). These are redundant with
snd_usb_endpoint_prepare() at stream-open time.

Enable the quirk for Focusrite devices, as init_sample_rate(rate_max)
sets 192kHz during probing, which disables the internal mixer and Air
and Safe modes.

Fixes: 16f1f838442d ("Revert "ALSA: usb-audio: Drop superfluous interface setup at parsing"")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/65a7909b15f9feb76c2a6f4f8814c240ddc50737.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c   | 3 ++-
 sound/usb/stream.c   | 3 +++
 sound/usb/usbaudio.h | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9cc5165510182..a89ea2233180a 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2422,7 +2422,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   0),
+		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
@@ -2504,6 +2504,7 @@ static const char *const snd_usb_audio_quirk_flag_names[] = {
 	QUIRK_STRING_ENTRY(MIC_RES_384),
 	QUIRK_STRING_ENTRY(MIXER_PLAYBACK_MIN_MUTE),
 	QUIRK_STRING_ENTRY(MIXER_CAPTURE_MIN_MUTE),
+	QUIRK_STRING_ENTRY(SKIP_IFACE_SETUP),
 	NULL
 };
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index ec7d756d78d17..421e94b233e17 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -1259,6 +1259,9 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 			set_iface_first = true;
 
 		/* try to set the interface... */
+		if (chip->quirk_flags & QUIRK_FLAG_SKIP_IFACE_SETUP)
+			continue;
+
 		usb_set_interface(chip->dev, iface_no, 0);
 		if (set_iface_first)
 			usb_set_interface(chip->dev, iface_no, altno);
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 79978cae9799c..085530cf62d92 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -224,6 +224,10 @@ extern bool snd_usb_skip_validation;
  *  playback value represents muted state instead of minimum audible volume
  * QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE
  *  Similar to QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE, but for capture streams
+ * QUIRK_FLAG_SKIP_IFACE_SETUP
+ *  Skip the probe-time interface setup (usb_set_interface,
+ *  init_pitch, init_sample_rate); redundant with
+ *  snd_usb_endpoint_prepare() at stream-open time
  */
 
 enum {
@@ -253,6 +257,7 @@ enum {
 	QUIRK_TYPE_MIC_RES_384			= 23,
 	QUIRK_TYPE_MIXER_PLAYBACK_MIN_MUTE	= 24,
 	QUIRK_TYPE_MIXER_CAPTURE_MIN_MUTE	= 25,
+	QUIRK_TYPE_SKIP_IFACE_SETUP		= 26,
 /* Please also edit snd_usb_audio_quirk_flag_names */
 };
 
@@ -284,5 +289,6 @@ enum {
 #define QUIRK_FLAG_MIC_RES_384			QUIRK_FLAG(MIC_RES_384)
 #define QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE	QUIRK_FLAG(MIXER_PLAYBACK_MIN_MUTE)
 #define QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE	QUIRK_FLAG(MIXER_CAPTURE_MIN_MUTE)
+#define QUIRK_FLAG_SKIP_IFACE_SETUP		QUIRK_FLAG(SKIP_IFACE_SETUP)
 
 #endif /* __USBAUDIO_H */
-- 
2.51.0

