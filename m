Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA61D8DEA;
	Tue, 15 Oct 2024 11:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993527; cv=none; b=JcbjsImvQTGkGp3xyOKaYQkaro4J59ZDgsagVHSVCSfZi0bp50Qr1mhZPPH1M2t9j6RNEgXdvSKn6bbnP8KkapeI5nh6yzsIycWFlyhbyBrZ1T91DR8BX7VTCIhRTx4rtOQPuGZ5seIkcU1Rt0q0hEXgzFaJkuHbrHJMag11do0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993527; c=relaxed/simple;
	bh=4diWSHqsgXwSHirKRDU8UR/FwrY73b1tiac7pHj9rUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKOBRCOtqWIP2ySJH/RCUsPw85Ma/mkPDWXWL0z27ae5fP3kGnFeqfs7nBWFj2ffg4ARzCid3tWbLQJ7Rbs3X4f2hST6mSqG+0FRW1h5xPg/tQec1pHtNV9fj9uXDMzMrPoEWb2LCPzWstUQckylx6ibFtqi+kU3zJZNrfCVFhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAt5mhuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAt5mhuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBF7C4CEC6;
	Tue, 15 Oct 2024 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993527;
	bh=4diWSHqsgXwSHirKRDU8UR/FwrY73b1tiac7pHj9rUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAt5mhucyD9PTqYsca1vaEv17eL3/yIEVooDH01r6v9qQm7G9xAjaN7HWwJq6HJhH
	 tRuFl4dBg6qJgfdnHj4h1Z7AffoW08Txj0Ol4IFmo5xXjGCcrshNUkmCon6eG3kJ5e
	 sqrrXhT/POkHfT0N3+UcZL9sgM9ZwHSD2mL2IfWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/691] ALSA: usb-audio: Define macros for quirk table entries
Date: Tue, 15 Oct 2024 13:26:26 +0200
Message-ID: <20241015112457.725153335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0c3ad39b791c2ecf718afcaca30e5ceafa939d5c ]

Many entries in the USB-audio quirk tables have relatively complex
expressions.  For improving the readability, introduce a few macros.
Those are applied in the following patch.

Link: https://patch.msgid.link/20240814134844.2726-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 77 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 7a15cc260f741..dd98b4e13edac 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -35,6 +35,83 @@
 	.bInterfaceClass = USB_CLASS_AUDIO, \
 	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL
 
+/* Quirk .driver_info, followed by the definition of the quirk entry;
+ * put like QUIRK_DRIVER_INFO { ... } in each entry of the quirk table
+ */
+#define QUIRK_DRIVER_INFO \
+	.driver_info = (unsigned long)&(const struct snd_usb_audio_quirk)
+
+/*
+ * Macros for quirk data entries
+ */
+
+/* Quirk data entry for ignoring the interface */
+#define QUIRK_DATA_IGNORE(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_IGNORE_INTERFACE
+/* Quirk data entry for a standard audio interface */
+#define QUIRK_DATA_STANDARD_AUDIO(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_AUDIO_STANDARD_INTERFACE
+/* Quirk data entry for a standard MIDI interface */
+#define QUIRK_DATA_STANDARD_MIDI(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_MIDI_STANDARD_INTERFACE
+/* Quirk data entry for a standard mixer interface */
+#define QUIRK_DATA_STANDARD_MIXER(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_AUDIO_STANDARD_MIXER
+
+/* Quirk data entry for Yamaha MIDI */
+#define QUIRK_DATA_MIDI_YAMAHA(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_MIDI_YAMAHA
+/* Quirk data entry for Edirol UAxx */
+#define QUIRK_DATA_EDIROL_UAXX(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_AUDIO_EDIROL_UAXX
+/* Quirk data entry for raw bytes interface */
+#define QUIRK_DATA_RAW_BYTES(_ifno) \
+	.ifnum = (_ifno), .type = QUIRK_MIDI_RAW_BYTES
+
+/* Quirk composite array terminator */
+#define QUIRK_COMPOSITE_END	{ .ifnum = -1 }
+
+/* Quirk data entry for composite quirks;
+ * followed by the quirk array that is terminated with QUIRK_COMPOSITE_END
+ * e.g. QUIRK_DATA_COMPOSITE { { quirk1 }, { quirk2 },..., QUIRK_COMPOSITE_END }
+ */
+#define QUIRK_DATA_COMPOSITE \
+	.ifnum = QUIRK_ANY_INTERFACE, \
+	.type = QUIRK_COMPOSITE, \
+	.data = &(const struct snd_usb_audio_quirk[])
+
+/* Quirk data entry for a fixed audio endpoint;
+ * followed by audioformat definition
+ * e.g. QUIRK_DATA_AUDIOFORMAT(n) { .formats = xxx, ... }
+ */
+#define QUIRK_DATA_AUDIOFORMAT(_ifno)	    \
+	.ifnum = (_ifno),		    \
+	.type = QUIRK_AUDIO_FIXED_ENDPOINT, \
+	.data = &(const struct audioformat)
+
+/* Quirk data entry for a fixed MIDI endpoint;
+ * followed by snd_usb_midi_endpoint_info definition
+ * e.g. QUIRK_DATA_MIDI_FIXED_ENDPOINT(n) { .out_cables = x, .in_cables = y }
+ */
+#define QUIRK_DATA_MIDI_FIXED_ENDPOINT(_ifno) \
+	.ifnum = (_ifno),		      \
+	.type = QUIRK_MIDI_FIXED_ENDPOINT,    \
+	.data = &(const struct snd_usb_midi_endpoint_info)
+/* Quirk data entry for a MIDIMAN MIDI endpoint */
+#define QUIRK_DATA_MIDI_MIDIMAN(_ifno) \
+	.ifnum = (_ifno),	       \
+	.type = QUIRK_MIDI_MIDIMAN,    \
+	.data = &(const struct snd_usb_midi_endpoint_info)
+/* Quirk data entry for a EMAGIC MIDI endpoint */
+#define QUIRK_DATA_MIDI_EMAGIC(_ifno) \
+	.ifnum = (_ifno),	      \
+	.type = QUIRK_MIDI_EMAGIC,    \
+	.data = &(const struct snd_usb_midi_endpoint_info)
+
+/*
+ * Here we go... the quirk table definition begins:
+ */
+
 /* FTDI devices */
 {
 	USB_DEVICE(0x0403, 0xb8d8),
-- 
2.43.0



