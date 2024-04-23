Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1B6143895;
	Tue, 23 Apr 2024 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908628; cv=none; b=qlb3LZEuLpxz+IaviE9Sg3s0ew895tvgV16hBMNRFtlOkKqtAgAvuaPIq8V5hynnmTpoZ5laDOgDfvquKNkBgjDVKtFIrD4BVOIva8DrF+Koz3FaLgMlt7bst862exLJDhXH7Dvmfl4oYHwwXluI5fu2+bZfa9bWysPSK34uebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908628; c=relaxed/simple;
	bh=buGKg5zfgxyMAF610jGNHThKyaXYkhv2/4tccCGmMGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOz4sImkQwLi9G8lh3sn2V66HbOUieehw2ZiOPKnM31CFG1Ifh4IzAqlPOsb066VG+aSi1R4E/CcZsaD6kUR6R45CJ3IYjjnTwUUhwdBlvbyHQpr+74R3FGJLJLChk57kF9T8FG378j/d3CqNJ740AGJsDy8dGNGacJM6t9OtTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVcxbhsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVcxbhsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF33C32781;
	Tue, 23 Apr 2024 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908628;
	bh=buGKg5zfgxyMAF610jGNHThKyaXYkhv2/4tccCGmMGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVcxbhsHMIJO7Le2HPAypz9F/2Vc/bRk/5Brcjk1iVJ+zXWiRt8iQQWvpFCM3Jjof
	 uvtCOXo5mFhADqxz2rQ3Cq9/MH86SAITtdIRUAjAtI+Qs17oZrYzaLsfwnMPo9A1Jn
	 nyAHFutyQWSg15apH8ErrmyKRslWRMLZ75d5CWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/158] ALSA: scarlett2: Add Focusrite Clarett+ 2Pre and 4Pre support
Date: Tue, 23 Apr 2024 14:38:38 -0700
Message-ID: <20240423213858.395388676@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit b61a3acada0031e7a4922d1340b4296ab95c260b ]

The Focusrite Clarett+ series uses the same protocol as the Scarlett
Gen 2 and Gen 3 series. This patch adds support for the Clarett+ 2Pre
and Clarett+ 4Pre similarly to the existing 8Pre support by adding
appropriate entries to the scarlett2 driver.

The Clarett 2Pre USB and 4Pre USB presumably use the same protocol as
well, so support for them can easily be added if someone can test.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/ZRL7qjC3tYQllT3H@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c        |  2 +
 sound/usb/mixer_scarlett_gen2.c | 97 ++++++++++++++++++++++++++++++++-
 2 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index b122d7aedb443..3721d59a56809 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3448,6 +3448,8 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x1235, 0x8214): /* Focusrite Scarlett 18i8 3rd Gen */
 	case USB_ID(0x1235, 0x8215): /* Focusrite Scarlett 18i20 3rd Gen */
 	case USB_ID(0x1235, 0x8208): /* Focusrite Clarett 8Pre USB */
+	case USB_ID(0x1235, 0x820a): /* Focusrite Clarett+ 2Pre */
+	case USB_ID(0x1235, 0x820b): /* Focusrite Clarett+ 4Pre */
 	case USB_ID(0x1235, 0x820c): /* Focusrite Clarett+ 8Pre */
 		err = snd_scarlett_gen2_init(mixer);
 		break;
diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 83df5621c98f5..653dc7d8fb47c 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -6,7 +6,7 @@
  *   - 6i6/18i8/18i20 Gen 2
  *   - Solo/2i2/4i4/8i6/18i8/18i20 Gen 3
  *   - Clarett 8Pre USB
- *   - Clarett+ 8Pre
+ *   - Clarett+ 2Pre/4Pre/8Pre
  *
  *   Copyright (c) 2018-2023 by Geoffrey D. Bennett <g at b4.vu>
  *   Copyright (c) 2020-2021 by Vladimir Sadovnikov <sadko4u@gmail.com>
@@ -60,6 +60,10 @@
  * Support for Clarett 8Pre USB added in Sep 2023 (thanks to Philippe
  * Perrot for confirmation).
  *
+ * Support for Clarett+ 4Pre and 2Pre added in Sep 2023 (thanks to
+ * Gregory Rozzo for donating a 4Pre, and David Sherwood and Patrice
+ * Peterson for usbmon output).
+ *
  * This ALSA mixer gives access to (model-dependent):
  *  - input, output, mixer-matrix muxes
  *  - mixer-matrix gain stages
@@ -832,6 +836,95 @@ static const struct scarlett2_device_info s18i20_gen3_info = {
 	} },
 };
 
+static const struct scarlett2_device_info clarett_2pre_info = {
+	.config_set = SCARLETT2_CONFIG_SET_CLARETT,
+	.line_out_hw_vol = 1,
+	.level_input_count = 2,
+	.air_input_count = 2,
+
+	.line_out_descrs = {
+		"Monitor L",
+		"Monitor R",
+		"Headphones L",
+		"Headphones R",
+	},
+
+	.port_count = {
+		[SCARLETT2_PORT_TYPE_NONE]     = {  1,  0 },
+		[SCARLETT2_PORT_TYPE_ANALOGUE] = {  2,  4 },
+		[SCARLETT2_PORT_TYPE_SPDIF]    = {  2,  0 },
+		[SCARLETT2_PORT_TYPE_ADAT]     = {  8,  0 },
+		[SCARLETT2_PORT_TYPE_MIX]      = { 10, 18 },
+		[SCARLETT2_PORT_TYPE_PCM]      = {  4, 12 },
+	},
+
+	.mux_assignment = { {
+		{ SCARLETT2_PORT_TYPE_PCM,      0, 12 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  4 },
+		{ SCARLETT2_PORT_TYPE_MIX,      0, 18 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0,  8 },
+		{ 0,                            0,  0 },
+	}, {
+		{ SCARLETT2_PORT_TYPE_PCM,      0,  8 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  4 },
+		{ SCARLETT2_PORT_TYPE_MIX,      0, 18 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0,  8 },
+		{ 0,                            0,  0 },
+	}, {
+		{ SCARLETT2_PORT_TYPE_PCM,      0,  2 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  4 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0, 26 },
+		{ 0,                            0,  0 },
+	} },
+};
+
+static const struct scarlett2_device_info clarett_4pre_info = {
+	.config_set = SCARLETT2_CONFIG_SET_CLARETT,
+	.line_out_hw_vol = 1,
+	.level_input_count = 2,
+	.air_input_count = 4,
+
+	.line_out_descrs = {
+		"Monitor L",
+		"Monitor R",
+		"Headphones 1 L",
+		"Headphones 1 R",
+		"Headphones 2 L",
+		"Headphones 2 R",
+	},
+
+	.port_count = {
+		[SCARLETT2_PORT_TYPE_NONE]     = {  1,  0 },
+		[SCARLETT2_PORT_TYPE_ANALOGUE] = {  8,  6 },
+		[SCARLETT2_PORT_TYPE_SPDIF]    = {  2,  2 },
+		[SCARLETT2_PORT_TYPE_ADAT]     = {  8,  0 },
+		[SCARLETT2_PORT_TYPE_MIX]      = { 10, 18 },
+		[SCARLETT2_PORT_TYPE_PCM]      = {  8, 18 },
+	},
+
+	.mux_assignment = { {
+		{ SCARLETT2_PORT_TYPE_PCM,      0, 18 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  6 },
+		{ SCARLETT2_PORT_TYPE_SPDIF,    0,  2 },
+		{ SCARLETT2_PORT_TYPE_MIX,      0, 18 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0,  8 },
+		{ 0,                            0,  0 },
+	}, {
+		{ SCARLETT2_PORT_TYPE_PCM,      0, 14 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  6 },
+		{ SCARLETT2_PORT_TYPE_SPDIF,    0,  2 },
+		{ SCARLETT2_PORT_TYPE_MIX,      0, 18 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0,  8 },
+		{ 0,                            0,  0 },
+	}, {
+		{ SCARLETT2_PORT_TYPE_PCM,      0, 12 },
+		{ SCARLETT2_PORT_TYPE_ANALOGUE, 0,  6 },
+		{ SCARLETT2_PORT_TYPE_SPDIF,    0,  2 },
+		{ SCARLETT2_PORT_TYPE_NONE,     0, 24 },
+		{ 0,                            0,  0 },
+	} },
+};
+
 static const struct scarlett2_device_info clarett_8pre_info = {
 	.config_set = SCARLETT2_CONFIG_SET_CLARETT,
 	.line_out_hw_vol = 1,
@@ -907,6 +1000,8 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 
 	/* Supported Clarett USB/Clarett+ devices */
 	{ USB_ID(0x1235, 0x8208), &clarett_8pre_info, "Clarett USB" },
+	{ USB_ID(0x1235, 0x820a), &clarett_2pre_info, "Clarett+" },
+	{ USB_ID(0x1235, 0x820b), &clarett_4pre_info, "Clarett+" },
 	{ USB_ID(0x1235, 0x820c), &clarett_8pre_info, "Clarett+" },
 
 	/* End of list */
-- 
2.43.0



