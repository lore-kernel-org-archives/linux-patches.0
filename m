Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E778B61;
	Tue, 27 Feb 2024 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042633; cv=none; b=RdgUUGFFTlU2BQlJsEGmoUR0QOnyBmX6wFhk7x8EyDstOmSCswZ/JXb29S/eakBuEl52ipxXEeqS4VxdALDisIk4VO9vqNyje5YjLOLOKjSZ7u/OvBxrtRtB1MqqKPJDhG7sn7jS3s2ib31x/WT2sX5+ZGDd+hsCvBjsnweQnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042633; c=relaxed/simple;
	bh=YisPQyRG20T8Jh3Ah1CQC69CIuF3OrSMEo1sMrSmvps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7ge7zV05kSHiwvqac2sFo1gfhTd46boiVf1fzF3mt6EkXZN8NaoQNZRkNht+vuMtZorQBFRtoJA/gduSSdTv8heE7nkz1YWCEvGwEo1nVJXrWWlBFgYgfD51bNc+vZ9ICnhTpdxpQOr1Uvo76BLM/NKPG1xlUrtGRt6nSSsMv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHTubced; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHTubced"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7353DC433F1;
	Tue, 27 Feb 2024 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042632;
	bh=YisPQyRG20T8Jh3Ah1CQC69CIuF3OrSMEo1sMrSmvps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHTubcedmlx24w9jzW8LR6wpIoYwthbG4VowUIQruooR5mWrfablw0uKHgVboQp1+
	 wvA9GhrdzOqIU6ufYj0arLIRI/dDNJaAlukuYkd4vruqEhqhK+9AL+GXMnEwttTtQD
	 uAqnaQ1Fg6zcx/44GRndjii1duZ86r9ZJk6ENyY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/245] ALSA: usb-audio: Check presence of valid altsetting control
Date: Tue, 27 Feb 2024 14:23:44 +0100
Message-ID: <20240227131616.293867068@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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



