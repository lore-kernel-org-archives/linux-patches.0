Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FF582B80;
	Wed,  9 Sep 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963878; cv=none; b=Wffck+BNIafiZA0quh+ToMvCM+4q4yfeRI+C11PPgHYLP2mYhSrPmSpd18L0TbSART3j2OQXnvB3ClBMF6aCyrVuzbZdlmEXOy6joIPf2pL2e5NE7UnBIs62C1C2hUHxkTWbvOdtPjbUVO10CccGzC9b8WZPE5lmxqGp83PwpMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963878; c=relaxed/simple;
	bh=FYK/l7iJQeQl0sNjkx8nVXI518b5Dn1PbISZnQeez+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOJAKhX+BMRcOade567PvZCKedAoFQbprqIgA5w1eGu281NAhfuBuVcoU1oznDWzGSVcFH3FQlH1hYGEluoGSNwshdnK/gK4CCGA0Du3PEZhAVLJtRfmDZANi8OVT8XabgOPc2HiDOLQY+oJyiZJWDPr59IGzBKr7ja2DC/K3Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Wmcam7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Wmcam7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3671F00A3A;
	Wed,  9 Sep 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963877;
	bh=x6Bk9Pa0qFk2NaDx42Xez1j/8sFlZqX5qlUng0chJuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Wmcam7ibvnzCOwENGCqq+Nonv3ze+a92A66We8xVMfNaGRlXhWxWbVVrJiDV5gu6
	 oPQrGB+x2fxCnA0TVRzUtNkRcdCtO+vwcKn1gK4yXSGtyfCzn+8QWf5pKlQchiFdjZ
	 M9RnnzOKi/VqA8lVy2CL/VKG9e02u0w4TP73gf4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 170/583] ASoC: pcm512x: sort the register default table
Date: Wed,  9 Sep 2026 15:37:35 +0200
Message-ID: <20260909134244.093499252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 767d9ae714e3e9b0ae86237c410fbfca7056570a upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

PCM512x_AUTO_MUTE (page 0, register 59) is listed before
PCM512x_ERROR_DETECT (page 0, register 37) and PCM512x_VCOM_CTRL_2
(page 1, register 9) is listed before the page 0 clocking block, so the
bsearch() descends into the wrong half of the table.  24 of the 45
entries are unreachable, among them every PLL coefficient and clock
divider default.  regcache_reg_needs_sync() then cannot compare them
against their default and reports that a sync is needed, so they are
written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: 5a3af1293194 ("ASoC: pcm512x: Add PCM512x driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pcm512x.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -78,28 +78,10 @@ static const struct reg_default pcm512x_
 	{ PCM512x_POWER,             0x00 },
 	{ PCM512x_MUTE,              0x00 },
 	{ PCM512x_DSP,               0x00 },
-	{ PCM512x_PLL_REF,           0x00 },
-	{ PCM512x_DAC_REF,           0x00 },
-	{ PCM512x_DAC_ROUTING,       0x11 },
-	{ PCM512x_DSP_PROGRAM,       0x01 },
-	{ PCM512x_CLKDET,            0x00 },
-	{ PCM512x_AUTO_MUTE,         0x00 },
-	{ PCM512x_ERROR_DETECT,      0x00 },
-	{ PCM512x_DIGITAL_VOLUME_1,  0x00 },
-	{ PCM512x_DIGITAL_VOLUME_2,  0x30 },
-	{ PCM512x_DIGITAL_VOLUME_3,  0x30 },
-	{ PCM512x_DIGITAL_MUTE_1,    0x22 },
-	{ PCM512x_DIGITAL_MUTE_2,    0x00 },
-	{ PCM512x_DIGITAL_MUTE_3,    0x07 },
-	{ PCM512x_OUTPUT_AMPLITUDE,  0x00 },
-	{ PCM512x_ANALOG_GAIN_CTRL,  0x00 },
-	{ PCM512x_UNDERVOLTAGE_PROT, 0x00 },
-	{ PCM512x_ANALOG_MUTE_CTRL,  0x00 },
-	{ PCM512x_ANALOG_GAIN_BOOST, 0x00 },
-	{ PCM512x_VCOM_CTRL_1,       0x00 },
-	{ PCM512x_VCOM_CTRL_2,       0x01 },
 	{ PCM512x_BCLK_LRCLK_CFG,    0x00 },
 	{ PCM512x_MASTER_MODE,       0x7c },
+	{ PCM512x_PLL_REF,           0x00 },
+	{ PCM512x_DAC_REF,           0x00 },
 	{ PCM512x_GPIO_DACIN,        0x00 },
 	{ PCM512x_GPIO_PLLIN,        0x00 },
 	{ PCM512x_SYNCHRONIZE,       0x10 },
@@ -117,8 +99,26 @@ static const struct reg_default pcm512x_
 	{ PCM512x_FS_SPEED_MODE,     0x00 },
 	{ PCM512x_IDAC_1,            0x01 },
 	{ PCM512x_IDAC_2,            0x00 },
+	{ PCM512x_ERROR_DETECT,      0x00 },
 	{ PCM512x_I2S_1,             0x02 },
 	{ PCM512x_I2S_2,             0x00 },
+	{ PCM512x_DAC_ROUTING,       0x11 },
+	{ PCM512x_DSP_PROGRAM,       0x01 },
+	{ PCM512x_CLKDET,            0x00 },
+	{ PCM512x_AUTO_MUTE,         0x00 },
+	{ PCM512x_DIGITAL_VOLUME_1,  0x00 },
+	{ PCM512x_DIGITAL_VOLUME_2,  0x30 },
+	{ PCM512x_DIGITAL_VOLUME_3,  0x30 },
+	{ PCM512x_DIGITAL_MUTE_1,    0x22 },
+	{ PCM512x_DIGITAL_MUTE_2,    0x00 },
+	{ PCM512x_DIGITAL_MUTE_3,    0x07 },
+	{ PCM512x_OUTPUT_AMPLITUDE,  0x00 },
+	{ PCM512x_ANALOG_GAIN_CTRL,  0x00 },
+	{ PCM512x_UNDERVOLTAGE_PROT, 0x00 },
+	{ PCM512x_ANALOG_MUTE_CTRL,  0x00 },
+	{ PCM512x_ANALOG_GAIN_BOOST, 0x00 },
+	{ PCM512x_VCOM_CTRL_1,       0x00 },
+	{ PCM512x_VCOM_CTRL_2,       0x01 },
 };
 
 static bool pcm512x_readable(struct device *dev, unsigned int reg)


