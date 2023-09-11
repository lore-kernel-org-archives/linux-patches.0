Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318AD11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E70C433C8;
	Mon, 11 Sep 2023 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444552;
	bh=qSDxznCYNkIyyLxbPhILPCIoKVkIbVGArjbNuDV27ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0NPyK6md5N3mkttvIz2edPM0CbUtAGWHbY1gFkYAU0leJZ6Kcdy2UpeHyLySdSrB
	 iWnk8vf/LwaAmf1HbtLDza+WBoeeGAWS5VgMLb2r8Nmeo9QgefTTzQIqYtpSFq6xyb
	 IM0OQ9SdRwOaUZqPF71vFjGXKD9BipgZ1DkCzExU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/600] ALSA: usb-audio: Add quirk for Microsoft Modern Wireless Headset
Date: Mon, 11 Sep 2023 15:41:06 +0200
Message-ID: <20230911134634.582694418@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3da435063777f8d861ba5a165344e3f75f839357 ]

Microsoft Modern Wireless Headset (appearing on the host as "Microsoft
USB Link") has a playback and a capture mixer volume/switch, but they
are fairly broken.  The descriptor reports wrong dB ranges for
playback, and the capture volume/switch don't influence on the actual
recording at all.  Moreover, there seem instabilities in the
connection, and at best, we should disable the runtime PM.

So this ended up with a quirk entry for:
- Correct the playback dB range;
  I picked up some reasonable values but it's a guess work
- Disable the capture mixer;
  it's completely useless and confuses PA/PW
- Suppress get-sample-rate, apply the delay for message handling,
  and suppress the auto-suspend

The behavior of the wheel control on the headset is somehow flaky,
too, but it's an issue of HID.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1207129
Link: https://lore.kernel.org/r/20230725092057.15115-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 14 ++++++++++++++
 sound/usb/quirks.c     |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index f4bd1e8ae4b6c..23260aa1919d3 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -374,6 +374,15 @@ static const struct usbmix_name_map corsair_virtuoso_map[] = {
 	{ 0 }
 };
 
+/* Microsoft USB Link headset */
+/* a guess work: raw playback volume values are from 2 to 129 */
+static const struct usbmix_dB_map ms_usb_link_dB = { -3225, 0, true };
+static const struct usbmix_name_map ms_usb_link_map[] = {
+	{ 9, NULL, .dB = &ms_usb_link_dB },
+	{ 10, NULL }, /* Headset Capture volume; seems non-working, disabled */
+	{ 0 }   /* terminator */
+};
+
 /* ASUS ROG Zenith II with Realtek ALC1220-VB */
 static const struct usbmix_name_map asus_zenith_ii_map[] = {
 	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
@@ -668,6 +677,11 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x1395, 0x0025),
 		.map = sennheiser_pc8_map,
 	},
+	{
+		/* Microsoft USB Link headset */
+		.id = USB_ID(0x045e, 0x083c),
+		.map = ms_usb_link_map,
+	},
 	{ 0 } /* terminator */
 };
 
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 6cf55b7f7a041..d4a7ffef82194 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2011,6 +2011,9 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x045e, 0x083c, /* MS USB Link headset */
+		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x046d, 0x084c, /* Logitech ConferenceCam Connect */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x046d, 0x0991, /* Logitech QuickCam Pro */
-- 
2.40.1



