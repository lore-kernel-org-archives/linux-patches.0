Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628361DED69;
	Tue,  8 Oct 2024 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391639; cv=none; b=hLuMf5kclHvxtgVuLPlQj9mv/DL8ps+OBmK4TqL11+kxghmwrqzg2jPbs5gaUt3sOC+L4UlLD358yfS8Q7cDkjnnyEBOxG8k8EnSLePF5qvycSLHS3rVuutZUYjKpaOWLaK6NbvtA3KQv68DKv5PDPEDyO8NB92bh0KmKExklig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391639; c=relaxed/simple;
	bh=5brLwsHXqGToYyA7hdsLmq4iqLzvRzdcDLdruM/Flb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8vn2l94N+7aA0DbbaTB++mScMTSIhrQSweUz3okeRrkF34/RitkzqyNgVQD/LWjmRsdFAuH3LkH6FpCbkbWx5ETvNzijdtxZF3N0C+UVcjOULozOnloifZIvIkgwe/MqkiAvItT0nsVBjYX9lDXWqiHvw5AS4tlOy8XpWR+I1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcBvrTrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcBvrTrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA72CC4CECC;
	Tue,  8 Oct 2024 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391639;
	bh=5brLwsHXqGToYyA7hdsLmq4iqLzvRzdcDLdruM/Flb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcBvrTrh0I05NutN5xJBQKcQtUZY3iLclb9P/67G1FB+R4IE6YMeJFSF0ECLe0o3m
	 AGZZcyatx7zJNM0nLZkjHoqw1qlHQcGLpOzK4IlioNC+RfysYBkTPlHogGkixITK8I
	 8mItzw1P6g913h/bC8RwcT7ljjQfxzIOkR1tOQWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyan Nyan <cyan.vtb@gmail.com>,
	Asahi Lina <lina@asahilina.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 171/558] ALSA: usb-audio: Add quirk for RME Digiface USB
Date: Tue,  8 Oct 2024 14:03:21 +0200
Message-ID: <20241008115709.087379013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyan Nyan <cyan.vtb@gmail.com>

[ Upstream commit c032044e9672408c534d64a6df2b1ba14449e948 ]

Add trivial support for audio streaming on the RME Digiface USB. Binds
only to the first interface to allow userspace to directly drive the
complex I/O and matrix mixer controls.

Signed-off-by: Cyan Nyan <cyan.vtb@gmail.com>
[Lina: Added 2x/4x sample rate support & boot/format quirks]
Co-developed-by: Asahi Lina <lina@asahilina.net>
Signed-off-by: Asahi Lina <lina@asahilina.net>
Link: https://patch.msgid.link/20240903-rme-digiface-v2-1-71b06c912e97@asahilina.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 171 ++++++++++++++++++++++++++++++++++++++-
 sound/usb/quirks.c       |  58 +++++++++++++
 2 files changed, 228 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8d22de8bc2a96..631b9ab80f6cd 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3604,6 +3604,175 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
-
+{
+	/* Only claim interface 0 */
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR |
+		       USB_DEVICE_ID_MATCH_PRODUCT |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_NUMBER,
+	.idVendor = 0x2a39,
+	.idProduct = 0x3f8c,
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC,
+	.bInterfaceNumber = 0,
+	QUIRK_DRIVER_INFO {
+		QUIRK_DATA_COMPOSITE {
+			/*
+			 * Three modes depending on sample rate band,
+			 * with different channel counts for in/out
+			 */
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 34, // outputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x02,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_32000 |
+						SNDRV_PCM_RATE_44100 |
+						SNDRV_PCM_RATE_48000,
+					.rate_min = 32000,
+					.rate_max = 48000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						32000, 44100, 48000,
+					},
+					.sync_ep = 0x81,
+					.sync_iface = 0,
+					.sync_altsetting = 1,
+					.sync_ep_idx = 0,
+					.implicit_fb = 1,
+				},
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 18, // outputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x02,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_64000 |
+						SNDRV_PCM_RATE_88200 |
+						SNDRV_PCM_RATE_96000,
+					.rate_min = 64000,
+					.rate_max = 96000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						64000, 88200, 96000,
+					},
+					.sync_ep = 0x81,
+					.sync_iface = 0,
+					.sync_altsetting = 1,
+					.sync_ep_idx = 0,
+					.implicit_fb = 1,
+				},
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 10, // outputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x02,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_KNOT |
+						SNDRV_PCM_RATE_176400 |
+						SNDRV_PCM_RATE_192000,
+					.rate_min = 128000,
+					.rate_max = 192000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						128000, 176400, 192000,
+					},
+					.sync_ep = 0x81,
+					.sync_iface = 0,
+					.sync_altsetting = 1,
+					.sync_ep_idx = 0,
+					.implicit_fb = 1,
+				},
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 32, // inputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_32000 |
+						SNDRV_PCM_RATE_44100 |
+						SNDRV_PCM_RATE_48000,
+					.rate_min = 32000,
+					.rate_max = 48000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						32000, 44100, 48000,
+					}
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 16, // inputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_64000 |
+						SNDRV_PCM_RATE_88200 |
+						SNDRV_PCM_RATE_96000,
+					.rate_min = 64000,
+					.rate_max = 96000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						64000, 88200, 96000,
+					}
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(0) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 8, // inputs
+					.fmt_bits = 24,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_KNOT |
+						SNDRV_PCM_RATE_176400 |
+						SNDRV_PCM_RATE_192000,
+					.rate_min = 128000,
+					.rate_max = 192000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) {
+						128000, 176400, 192000,
+					}
+				}
+			},
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e7b68c67852e9..73da862a012c6 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1389,6 +1389,27 @@ static int snd_usb_motu_m_series_boot_quirk(struct usb_device *dev)
 	return 0;
 }
 
+static int snd_usb_rme_digiface_boot_quirk(struct usb_device *dev)
+{
+	/* Disable mixer, internal clock, all outputs ADAT, 48kHz, TMS off */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			16, 0x40, 0x2410, 0x7fff, NULL, 0);
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+			18, 0x40, 0x0104, 0xffff, NULL, 0);
+
+	/* Disable loopback for all inputs */
+	for (int ch = 0; ch < 32; ch++)
+		snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+				22, 0x40, 0x400, ch, NULL, 0);
+
+	/* Unity gain for all outputs */
+	for (int ch = 0; ch < 34; ch++)
+		snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
+				21, 0x40, 0x9000, 0x100 + ch, NULL, 0);
+
+	return 0;
+}
+
 /*
  * Setup quirks
  */
@@ -1616,6 +1637,8 @@ int snd_usb_apply_boot_quirk(struct usb_device *dev,
 		    get_iface_desc(intf->altsetting)->bInterfaceNumber < 3)
 			return snd_usb_motu_microbookii_boot_quirk(dev);
 		break;
+	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+		return snd_usb_rme_digiface_boot_quirk(dev);
 	}
 
 	return 0;
@@ -1771,6 +1794,38 @@ static void mbox3_set_format_quirk(struct snd_usb_substream *subs,
 		dev_warn(&subs->dev->dev, "MBOX3: Couldn't set the sample rate");
 }
 
+static const int rme_digiface_rate_table[] = {
+	32000, 44100, 48000, 0,
+	64000, 88200, 96000, 0,
+	128000, 176400, 192000, 0,
+};
+
+static int rme_digiface_set_format_quirk(struct snd_usb_substream *subs)
+{
+	unsigned int cur_rate = subs->data_endpoint->cur_rate;
+	u16 val;
+	int speed_mode;
+	int id;
+
+	for (id = 0; id < ARRAY_SIZE(rme_digiface_rate_table); id++) {
+		if (rme_digiface_rate_table[id] == cur_rate)
+			break;
+	}
+
+	if (id >= ARRAY_SIZE(rme_digiface_rate_table))
+		return -EINVAL;
+
+	/* 2, 3, 4 for 1x, 2x, 4x */
+	speed_mode = (id >> 2) + 2;
+	val = (id << 3) | (speed_mode << 12);
+
+	/* Set the sample rate */
+	snd_usb_ctl_msg(subs->stream->chip->dev,
+		usb_sndctrlpipe(subs->stream->chip->dev, 0),
+		16, 0x40, val, 0x7078, NULL, 0);
+	return 0;
+}
+
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 			      const struct audioformat *fmt)
 {
@@ -1795,6 +1850,9 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x0dba, 0x5000):
 		mbox3_set_format_quirk(subs, fmt); /* Digidesign Mbox 3 */
 		break;
+	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+		rme_digiface_set_format_quirk(subs);
+		break;
 	}
 }
 
-- 
2.43.0



