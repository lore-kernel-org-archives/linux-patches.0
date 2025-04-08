Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD98265626;
	Tue,  8 Apr 2025 12:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113917; cv=none; b=pNlhu7roSWlKh5VRrPPUjNMMNGiJftfpfJWeBYlJyS33LUaNP8uOMWXpqMZFsJ2NO6qIWZxzHhup8LRjllWXLvYu/KwkQrXeFGu32KNNYkRCtxJ9SddQq8qV5opt7QBUPsF0Yj99jIo7GGrAXXvavfXIGtHETozpOEqDQqvfxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113917; c=relaxed/simple;
	bh=NLWUNH7jFTHbAjnbehFVIik2FxEQkf0aVnxoPWySAVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F15XdJTXYKs5GfEfNvT5VrIJg5cY3vJxI9ijmmUUUDKr5P2cqjVFNDfDIVQc/+VOS/r0I+ApjIRCKwXe0D8r103vfcLzwhXTRWfi+IveFAGvecs4Ze4h+07s1zyk823773EQ3XBD+LslttXYjRsdREpYHqdlfCJhnG2uNUr9jN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJjOmE1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJjOmE1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202BDC4CEE5;
	Tue,  8 Apr 2025 12:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113916;
	bh=NLWUNH7jFTHbAjnbehFVIik2FxEQkf0aVnxoPWySAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJjOmE1hxmXGj5aAxLVzAlmDqMqpJwiGFWsju3f3yibPEY9AUiP3nJu+V4nrfyKRV
	 uLHo/csV/wVDEa3sqT6/dGXwnrlQ+syKpdntHma0YxCDvdim/uy+MqCp6UZjr0Mtd9
	 CDGGNuv/fAS2vQTkYJwObCE4UfghMtbkhnD+Chvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 066/154] ALSA: usb-audio: Add quirk for Plantronics headsets to fix control names
Date: Tue,  8 Apr 2025 12:50:07 +0200
Message-ID: <20250408104817.410986382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Junge <linuxhid@cosmicgizmosystems.com>

commit 486f6205c233da1baa309bde5f634eb1f8319a33 upstream.

Many Poly/Plantronics headset families name the feature, input,
and/or output units in a such a way to produce control names
that are not recognized by user space. As such, the volume and
mute events do not get routed to the headset's audio controls.

As an example from a product family:

The microphone mute control is named
Headset Microphone Capture Switch
and the headset volume control is named
Headset Earphone Playback Volume

The quirk fixes these to become
Headset Capture Switch
Headset Playback Volume

Signed-off-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2531,6 +2531,52 @@ static void snd_dragonfly_quirk_db_scale
 	}
 }
 
+/*
+ * Some Plantronics headsets have control names that don't meet ALSA naming
+ * standards. This function fixes nonstandard source names. By the time
+ * this function is called the control name should look like one of these:
+ * "source names Playback Volume"
+ * "source names Playback Switch"
+ * "source names Capture Volume"
+ * "source names Capture Switch"
+ * If any of the trigger words are found in the name then the name will
+ * be changed to:
+ * "Headset Playback Volume"
+ * "Headset Playback Switch"
+ * "Headset Capture Volume"
+ * "Headset Capture Switch"
+ * depending on the current suffix.
+ */
+static void snd_fix_plt_name(struct snd_usb_audio *chip,
+			     struct snd_ctl_elem_id *id)
+{
+	/* no variant of "Sidetone" should be added to this list */
+	static const char * const trigger[] = {
+		"Earphone", "Microphone", "Receive", "Transmit"
+	};
+	static const char * const suffix[] = {
+		" Playback Volume", " Playback Switch",
+		" Capture Volume", " Capture Switch"
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(trigger); i++)
+		if (strstr(id->name, trigger[i]))
+			goto triggered;
+	usb_audio_dbg(chip, "no change in %s\n", id->name);
+	return;
+
+triggered:
+	for (i = 0; i < ARRAY_SIZE(suffix); i++)
+		if (strstr(id->name, suffix[i])) {
+			usb_audio_dbg(chip, "fixing kctl name %s\n", id->name);
+			snprintf(id->name, sizeof(id->name), "Headset%s",
+				 suffix[i]);
+			return;
+		}
+	usb_audio_dbg(chip, "something wrong in kctl name %s\n", id->name);
+}
+
 void snd_usb_mixer_fu_apply_quirk(struct usb_mixer_interface *mixer,
 				  struct usb_mixer_elem_info *cval, int unitid,
 				  struct snd_kcontrol *kctl)
@@ -2548,5 +2594,10 @@ void snd_usb_mixer_fu_apply_quirk(struct
 			cval->min_mute = 1;
 		break;
 	}
+
+	/* ALSA-ify some Plantronics headset control names */
+	if (USB_ID_VENDOR(mixer->chip->usb_id) == 0x047f &&
+	    (cval->control == UAC_FU_MUTE || cval->control == UAC_FU_VOLUME))
+		snd_fix_plt_name(mixer->chip, &kctl->id);
 }
 


