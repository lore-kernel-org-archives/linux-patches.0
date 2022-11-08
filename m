Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909115CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C159C433C1;
	Tue,  8 Nov 2022 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667914901;
	bh=DEteDXpvLLB2FE0vAQOpY2PZ/VUybrPqdiRvxeIr7vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usp13eQYvAmI23E7uDJrXyV4wfj4UEe1FK1oYMOoLLSbq55EH/h38ES/pJN6jlzjx
	 1bECSXBX2UbdY2vGBrQXMfXieFuO6HMDXTJtOb6Nchg+LstJP9qr82nmW7zYpderDf
	 2RpfQXJ+hDLLdspNaV5qV1sJYM+w08ESUPTpXdug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Veness <john-linux@pelago.org.uk>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 22/30] ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices
Date: Tue,  8 Nov 2022 14:39:10 +0100
Message-Id: <20221108133327.556253655@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Veness <john-linux@pelago.org.uk>

commit 6e2c9105e0b743c92a157389d40f00b81bdd09fe upstream.

Treat the claimed 96kHz 1ch in the descriptors as 48kHz 2ch, so that
the audio stream doesn't sound mono. Also fix initial stream
alignment, so that left and right channels are in the correct order.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Link: https://lore.kernel.org/r/20220624140757.28758-1-john-linux@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/quirks.c       |    1 
 2 files changed, 59 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3334,6 +3334,64 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 },
 
 /*
+ * MacroSilicon MS2100/MS2106 based AV capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_AUDIO_ALIGN_TRANSFER, which makes one wonder if
+ * they pretend to be 96kHz mono as a workaround for stereo being broken
+ * by that...
+ *
+ * They also have an issue with initial stream alignment that causes the
+ * channels to be swapped and out of phase, which is dealt with in quirks.c.
+ */
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x534d,
+	.idProduct = 0x0021,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MacroSilicon",
+		.product_name = "MS210x",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_ALIGN_TRANSFER,
+			},
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 2,
+					.iface = 3,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 48000,
+					.rate_max = 48000,
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
+/*
  * MacroSilicon MS2109 based HDMI capture cards
  *
  * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1129,6 +1129,7 @@ void snd_usb_set_format_quirk(struct snd
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;


