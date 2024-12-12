Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3F72139B2;
	Thu, 12 Dec 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016124; cv=none; b=KHpM9eS9dYdZoT4hWi7FJDH5cE2ypBi3m5rJ2LWf1T4QWr9WPC14KDtHNlE6WAo/yVEOIDQfYIFZsKyNIMv6Urmh0kGni2BDwp7WEMot9d/cYOF9zr6RrkNDP9/inFjTGZMJ51xdaGkeZNtVss/ctDQW6kMMXxbpyXjJiMs32l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016124; c=relaxed/simple;
	bh=r/veSGrWXRqO8tRbmV4yFAcC+bLpvZ4CA3LwNP5JZVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5idvLria3OFawlJBw/SP1/MRIvtj/EHJab2ARZJbAQvc8gh+EnH3/UvLQ8UIuUDEkUOHsTFx7pt2JIudOyNjAf0FdtdRGX7BBmrwxvGKcY+nwvMpOuSMVw96vw7AjbeH2bQsH9z5KmCi5/WzKQl71uFinOyqWUChPKAVon6eYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/+Gpzk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/+Gpzk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B5AC4CED7;
	Thu, 12 Dec 2024 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016124;
	bh=r/veSGrWXRqO8tRbmV4yFAcC+bLpvZ4CA3LwNP5JZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/+Gpzk/M6QjTyIajxfpux7umPobLsiqHgXX9MUMtxBHJVMH2lsasAwhccGUnQYlt
	 xc5x0cxCiZcHsTL8h3XbN0SGSt0hX3CBZQG2FqXIXHhD3ek1R2JvJKWiPJ+PUKv/jB
	 48SXklaMaymDH2rkEwskoBug8a4EkDtgQ4IgkUKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 140/466] ALSA: usb-audio: Add extra PID for RME Digiface USB
Date: Thu, 12 Dec 2024 15:55:09 +0100
Message-ID: <20241212144312.330536425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asahi Lina <lina@asahilina.net>

commit f09f0397db641f99f6c3e109283d82e3584bfb50 upstream.

It seems there is an alternate version of the hardware with a different
PID. User testing reveals this still works with the same interface as far
as the kernel is concerned, so just add the extra PID. Thanks to Heiko
Engemann for testing with this version.

Due to the way quirks-table.h is structured, that means we have to turn
the entire quirk struct into a macro to avoid duplicating it...

Cc: stable@vger.kernel.org
Signed-off-by: Asahi Lina <lina@asahilina.net>
Link: https://patch.msgid.link/20241202-rme-digiface-usb-id-v1-1-50f730d7a46e@asahilina.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    1 
 sound/usb/quirks-table.h |  341 +++++++++++++++++++++++------------------------
 sound/usb/quirks.c       |    2 
 3 files changed, 176 insertions(+), 168 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -4059,6 +4059,7 @@ int snd_usb_mixer_apply_create_quirk(str
 		err = snd_bbfpro_controls_create(mixer);
 		break;
 	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+	case USB_ID(0x2a39, 0x3fa0): /* RME Digiface USB (alternate) */
 		err = snd_rme_digiface_controls_create(mixer);
 		break;
 	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3616,176 +3616,181 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
-{
-	/* Only claim interface 0 */
-	.match_flags = USB_DEVICE_ID_MATCH_VENDOR |
-		       USB_DEVICE_ID_MATCH_PRODUCT |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_NUMBER,
-	.idVendor = 0x2a39,
-	.idProduct = 0x3f8c,
-	.bInterfaceClass = USB_CLASS_VENDOR_SPEC,
-	.bInterfaceNumber = 0,
-	QUIRK_DRIVER_INFO {
-		QUIRK_DATA_COMPOSITE {
+#define QUIRK_RME_DIGIFACE(pid) \
+{ \
+	/* Only claim interface 0 */ \
+	.match_flags = USB_DEVICE_ID_MATCH_VENDOR | \
+		       USB_DEVICE_ID_MATCH_PRODUCT | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_NUMBER, \
+	.idVendor = 0x2a39, \
+	.idProduct = pid, \
+	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
+	.bInterfaceNumber = 0, \
+	QUIRK_DRIVER_INFO { \
+		QUIRK_DATA_COMPOSITE { \
 			/*
 			 * Three modes depending on sample rate band,
 			 * with different channel counts for in/out
-			 */
-			{ QUIRK_DATA_STANDARD_MIXER(0) },
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 34, // outputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x02,
-					.ep_idx = 1,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_32000 |
-						SNDRV_PCM_RATE_44100 |
-						SNDRV_PCM_RATE_48000,
-					.rate_min = 32000,
-					.rate_max = 48000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						32000, 44100, 48000,
-					},
-					.sync_ep = 0x81,
-					.sync_iface = 0,
-					.sync_altsetting = 1,
-					.sync_ep_idx = 0,
-					.implicit_fb = 1,
-				},
-			},
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 18, // outputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x02,
-					.ep_idx = 1,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_64000 |
-						SNDRV_PCM_RATE_88200 |
-						SNDRV_PCM_RATE_96000,
-					.rate_min = 64000,
-					.rate_max = 96000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						64000, 88200, 96000,
-					},
-					.sync_ep = 0x81,
-					.sync_iface = 0,
-					.sync_altsetting = 1,
-					.sync_ep_idx = 0,
-					.implicit_fb = 1,
-				},
-			},
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 10, // outputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x02,
-					.ep_idx = 1,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_KNOT |
-						SNDRV_PCM_RATE_176400 |
-						SNDRV_PCM_RATE_192000,
-					.rate_min = 128000,
-					.rate_max = 192000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						128000, 176400, 192000,
-					},
-					.sync_ep = 0x81,
-					.sync_iface = 0,
-					.sync_altsetting = 1,
-					.sync_ep_idx = 0,
-					.implicit_fb = 1,
-				},
-			},
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 32, // inputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x81,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_32000 |
-						SNDRV_PCM_RATE_44100 |
-						SNDRV_PCM_RATE_48000,
-					.rate_min = 32000,
-					.rate_max = 48000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						32000, 44100, 48000,
-					}
-				}
-			},
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 16, // inputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x81,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_64000 |
-						SNDRV_PCM_RATE_88200 |
-						SNDRV_PCM_RATE_96000,
-					.rate_min = 64000,
-					.rate_max = 96000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						64000, 88200, 96000,
-					}
-				}
-			},
-			{
-				QUIRK_DATA_AUDIOFORMAT(0) {
-					.formats = SNDRV_PCM_FMTBIT_S32_LE,
-					.channels = 8, // inputs
-					.fmt_bits = 24,
-					.iface = 0,
-					.altsetting = 1,
-					.altset_idx = 1,
-					.endpoint = 0x81,
-					.ep_attr = USB_ENDPOINT_XFER_ISOC |
-						USB_ENDPOINT_SYNC_ASYNC,
-					.rates = SNDRV_PCM_RATE_KNOT |
-						SNDRV_PCM_RATE_176400 |
-						SNDRV_PCM_RATE_192000,
-					.rate_min = 128000,
-					.rate_max = 192000,
-					.nr_rates = 3,
-					.rate_table = (unsigned int[]) {
-						128000, 176400, 192000,
-					}
-				}
-			},
-			QUIRK_COMPOSITE_END
-		}
-	}
-},
+			 */ \
+			{ QUIRK_DATA_STANDARD_MIXER(0) }, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 34, /* outputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x02, \
+					.ep_idx = 1, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_32000 | \
+						SNDRV_PCM_RATE_44100 | \
+						SNDRV_PCM_RATE_48000, \
+					.rate_min = 32000, \
+					.rate_max = 48000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						32000, 44100, 48000, \
+					}, \
+					.sync_ep = 0x81, \
+					.sync_iface = 0, \
+					.sync_altsetting = 1, \
+					.sync_ep_idx = 0, \
+					.implicit_fb = 1, \
+				}, \
+			}, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 18, /* outputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x02, \
+					.ep_idx = 1, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_64000 | \
+						SNDRV_PCM_RATE_88200 | \
+						SNDRV_PCM_RATE_96000, \
+					.rate_min = 64000, \
+					.rate_max = 96000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						64000, 88200, 96000, \
+					}, \
+					.sync_ep = 0x81, \
+					.sync_iface = 0, \
+					.sync_altsetting = 1, \
+					.sync_ep_idx = 0, \
+					.implicit_fb = 1, \
+				}, \
+			}, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 10, /* outputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x02, \
+					.ep_idx = 1, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_KNOT | \
+						SNDRV_PCM_RATE_176400 | \
+						SNDRV_PCM_RATE_192000, \
+					.rate_min = 128000, \
+					.rate_max = 192000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						128000, 176400, 192000, \
+					}, \
+					.sync_ep = 0x81, \
+					.sync_iface = 0, \
+					.sync_altsetting = 1, \
+					.sync_ep_idx = 0, \
+					.implicit_fb = 1, \
+				}, \
+			}, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 32, /* inputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x81, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_32000 | \
+						SNDRV_PCM_RATE_44100 | \
+						SNDRV_PCM_RATE_48000, \
+					.rate_min = 32000, \
+					.rate_max = 48000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						32000, 44100, 48000, \
+					} \
+				} \
+			}, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 16, /* inputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x81, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_64000 | \
+						SNDRV_PCM_RATE_88200 | \
+						SNDRV_PCM_RATE_96000, \
+					.rate_min = 64000, \
+					.rate_max = 96000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						64000, 88200, 96000, \
+					} \
+				} \
+			}, \
+			{ \
+				QUIRK_DATA_AUDIOFORMAT(0) { \
+					.formats = SNDRV_PCM_FMTBIT_S32_LE, \
+					.channels = 8, /* inputs */ \
+					.fmt_bits = 24, \
+					.iface = 0, \
+					.altsetting = 1, \
+					.altset_idx = 1, \
+					.endpoint = 0x81, \
+					.ep_attr = USB_ENDPOINT_XFER_ISOC | \
+						USB_ENDPOINT_SYNC_ASYNC, \
+					.rates = SNDRV_PCM_RATE_KNOT | \
+						SNDRV_PCM_RATE_176400 | \
+						SNDRV_PCM_RATE_192000, \
+					.rate_min = 128000, \
+					.rate_max = 192000, \
+					.nr_rates = 3, \
+					.rate_table = (unsigned int[]) { \
+						128000, 176400, 192000, \
+					} \
+				} \
+			}, \
+			QUIRK_COMPOSITE_END \
+		} \
+	} \
+}
+
+QUIRK_RME_DIGIFACE(0x3f8c),
+QUIRK_RME_DIGIFACE(0x3fa0),
+
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1665,6 +1665,7 @@ int snd_usb_apply_boot_quirk(struct usb_
 			return snd_usb_motu_microbookii_boot_quirk(dev);
 		break;
 	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+	case USB_ID(0x2a39, 0x3fa0): /* RME Digiface USB (alternate) */
 		return snd_usb_rme_digiface_boot_quirk(dev);
 	}
 
@@ -1878,6 +1879,7 @@ void snd_usb_set_format_quirk(struct snd
 		mbox3_set_format_quirk(subs, fmt); /* Digidesign Mbox 3 */
 		break;
 	case USB_ID(0x2a39, 0x3f8c): /* RME Digiface USB */
+	case USB_ID(0x2a39, 0x3fa0): /* RME Digiface USB (alternate) */
 		rme_digiface_set_format_quirk(subs);
 		break;
 	}


