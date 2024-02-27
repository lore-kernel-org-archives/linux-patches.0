Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968F4145346;
	Tue, 27 Feb 2024 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041717; cv=none; b=tJ6WshUHu9i8pv5gYLXu7v9oFueOhxzj+Zen+OvtMbSLzd5VmVQz9G1hagAYCYKilFO0VBRyzVJ751znTt6fwPffRsuN80K73J2jt/ikkpH19bMvH/N/wBW/Ohs91e7DVdcaD4/lAsASWyMu5yzEXeAFpxdMiYGF6gEKOGhLRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041717; c=relaxed/simple;
	bh=rWvtO3wuQP1Diy2XrOL5+B1U4HwED07pS7O2hp6f6MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdxYsqWaEOtAMDN2rm67gHFS1a/cxYJHKPL1uoGqcZWRag6UW1SupUkwOlm8VuvpEoSIx4den5FdXtNMFKwZ7Q1To/sxkqRQSKPE0ch/ihGQpI/EaTB+JpJEFnHRYKKS+Gl3AZLutaRttLQQUQPPWFZ2xtw8z1qcAMWXSEYSCOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXqLtf0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXqLtf0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E00C433F1;
	Tue, 27 Feb 2024 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041717;
	bh=rWvtO3wuQP1Diy2XrOL5+B1U4HwED07pS7O2hp6f6MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXqLtf0rdIZq9/u7wrWAXgaQrZSZkOqkK5FkueUYdYWS0mSZgB0VmGBnKl6RcDTsV
	 uht6Z/03bYZYUbiCJNoHXYoG/nepuwB9kcylMqBAYfUawcYpKtwyjay4io3KRZ+A8N
	 s0dcbeOyhSS8osTPPtrwGcv8VvRPAsi2yxI/SmlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/299] ALSA: usb-audio: Check presence of valid altsetting control
Date: Tue, 27 Feb 2024 14:22:37 +0100
Message-ID: <20240227131627.463849124@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit 346f59d1e8ed0eed41c80e1acb657e484c308e6a ]

Many devices with a single alternate setting do not have a Valid
Alternate Setting Control and validation performed by
validate_sample_rate_table_v2v3() doesn't work on them and is not
really needed. So check the presense of control before sending
altsetting validation requests.

MOTU Microbook IIc is suffering the most without this check. It
takes up to 40 seconds to bootup due to how slow it switches
sampling rates:

[ 2659.164824] usb 3-2: New USB device found, idVendor=07fd, idProduct=0004, bcdDevice= 0.60
[ 2659.164827] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 2659.164829] usb 3-2: Product: MicroBook IIc
[ 2659.164830] usb 3-2: Manufacturer: MOTU
[ 2659.166204] usb 3-2: Found last interface = 3
[ 2679.322298] usb 3-2: No valid sample rate available for 1:1, assuming a firmware bug
[ 2679.322306] usb 3-2: 1:1: add audio endpoint 0x3
[ 2679.322321] usb 3-2: Creating new data endpoint #3
[ 2679.322552] usb 3-2: 1:1 Set sample rate 96000, clock 1
[ 2684.362250] usb 3-2: 2:1: cannot get freq (v2/v3): err -110
[ 2694.444700] usb 3-2: No valid sample rate available for 2:1, assuming a firmware bug
[ 2694.444707] usb 3-2: 2:1: add audio endpoint 0x84
[ 2694.444721] usb 3-2: Creating new data endpoint #84
[ 2699.482103] usb 3-2: 2:1 Set sample rate 96000, clock 1

Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20240129121254.3454481-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index ab5fed9f55b60..3b45d0ee76938 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -470,9 +470,11 @@ static int validate_sample_rate_table_v2v3(struct snd_usb_audio *chip,
 					   int clock)
 {
 	struct usb_device *dev = chip->dev;
+	struct usb_host_interface *alts;
 	unsigned int *table;
 	unsigned int nr_rates;
 	int i, err;
+	u32 bmControls;
 
 	/* performing the rate verification may lead to unexpected USB bus
 	 * behavior afterwards by some unknown reason.  Do this only for the
@@ -481,6 +483,24 @@ static int validate_sample_rate_table_v2v3(struct snd_usb_audio *chip,
 	if (!(chip->quirk_flags & QUIRK_FLAG_VALIDATE_RATES))
 		return 0; /* don't perform the validation as default */
 
+	alts = snd_usb_get_host_interface(chip, fp->iface, fp->altsetting);
+	if (!alts)
+		return 0;
+
+	if (fp->protocol == UAC_VERSION_3) {
+		struct uac3_as_header_descriptor *as = snd_usb_find_csint_desc(
+				alts->extra, alts->extralen, NULL, UAC_AS_GENERAL);
+		bmControls = le32_to_cpu(as->bmControls);
+	} else {
+		struct uac2_as_header_descriptor *as = snd_usb_find_csint_desc(
+				alts->extra, alts->extralen, NULL, UAC_AS_GENERAL);
+		bmControls = as->bmControls;
+	}
+
+	if (!uac_v2v3_control_is_readable(bmControls,
+				UAC2_AS_VAL_ALT_SETTINGS))
+		return 0;
+
 	table = kcalloc(fp->nr_rates, sizeof(*table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
-- 
2.43.0



