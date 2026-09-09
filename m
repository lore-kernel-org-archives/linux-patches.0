Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5EA56329B;
	Wed,  9 Sep 2026 13:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962233; cv=none; b=GlVvOCHGGb5hbStkYgbEr6tBS3SPpA5yQUCVBjmrZRrVwj7glbSnpLxXeOSM8Suef2j/YJDc41D0CTodHGNx91j+Yd1j2ZiSaNLbPpSIaGK++p9iue7FMJrWrUzFUp0ENzngrsvfS2/IvDt6tcTY0kdN3+X+XeD9c0cMBLghjSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962233; c=relaxed/simple;
	bh=HL4nS1wbau0+kpAaZ3Udkx8vYeinrHQ6OnXefpEsaPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cgapH8GRzsBadAlp8+yuG/TQEY+UPZ7zxw2Y/jQxfQtMSmYIrmIScr8ae/Bbnb302fiQjqJNkUWzz+EX0JCSgyIC2RHcUZqqzj6k+VR3mukmRlO02Gv7Lv2WF1lMVw9Lm6TVC3qiOSnM3lRlqAZtGJ4m3cmhARtxQRBkhOg8drk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkxiQMkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkxiQMkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AAA1F00A3E;
	Wed,  9 Sep 2026 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962231;
	bh=cPQ1mAzjJny565upjFFT7q0FhtPa5SLbF0omGoUvrKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkxiQMkAmpyIMTo8zr7D+pPODthhlSYKQjQNuZuTYlfi5W1QIIRMMTgBJe4AliRdY
	 7P8V/jMD9UmrUecnhFI763JafZABVRVsFy6JP/9tiXoPnu5lC9DmmjKXcE+Y+cpJf5
	 n3Xti5Ob1s2Nm23DycK7dBkQpJ+EG2Q4gSg1D2so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 220/556] ASoC: adau1761: sort the register default table
Date: Wed,  9 Sep 2026 15:38:20 +0200
Message-ID: <20260909134238.142195001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit cc606b6c2328b4864885db6afcad7e78c0ac7a73 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

The table lists the ADAU1761 specific registers (0x4008 and up) before
the block shared with the ADAU1381/ADAU1781, which starts at
ADAU17X1_CLOCK_CONTROL (0x4000), so bsearch() descends into the wrong
half and 28 of the 52 entries are unreachable.
regcache_reg_needs_sync() then cannot compare them against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: dab464b60b24 ("ASoC: Add ADAU1361/ADAU1761 audio CODEC support")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260805122713.11376-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/adau1761.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/sound/soc/codecs/adau1761.c
+++ b/sound/soc/codecs/adau1761.c
@@ -68,23 +68,33 @@
 #define ADAU1761_FIRMWARE "adau1761.bin"
 
 static const struct reg_default adau1761_reg_defaults[] = {
-	{ ADAU1761_DEJITTER,			0x03 },
+	{ ADAU17X1_CLOCK_CONTROL,		0x00 },
+	{ ADAU17X1_PLL_CONTROL,			0x00 },
 	{ ADAU1761_DIGMIC_JACKDETECT,		0x00 },
+	{ ADAU17X1_REC_POWER_MGMT,		0x00 },
 	{ ADAU1761_REC_MIXER_LEFT0,		0x00 },
 	{ ADAU1761_REC_MIXER_LEFT1,		0x00 },
 	{ ADAU1761_REC_MIXER_RIGHT0,		0x00 },
 	{ ADAU1761_REC_MIXER_RIGHT1,		0x00 },
 	{ ADAU1761_LEFT_DIFF_INPUT_VOL,		0x00 },
+	{ ADAU1761_RIGHT_DIFF_INPUT_VOL,	0x00 },
+	{ ADAU17X1_MICBIAS,			0x00 },
 	{ ADAU1761_ALC_CTRL0,			0x00 },
 	{ ADAU1761_ALC_CTRL1,			0x00 },
 	{ ADAU1761_ALC_CTRL2,			0x00 },
 	{ ADAU1761_ALC_CTRL3,			0x00 },
-	{ ADAU1761_RIGHT_DIFF_INPUT_VOL,	0x00 },
-	{ ADAU1761_PLAY_LR_MIXER_LEFT,		0x00 },
+	{ ADAU17X1_SERIAL_PORT0,		0x00 },
+	{ ADAU17X1_SERIAL_PORT1,		0x00 },
+	{ ADAU17X1_CONVERTER0,			0x00 },
+	{ ADAU17X1_CONVERTER1,			0x00 },
+	{ ADAU17X1_ADC_CONTROL,			0x00 },
+	{ ADAU17X1_LEFT_INPUT_DIGITAL_VOL,	0x00 },
+	{ ADAU17X1_RIGHT_INPUT_DIGITAL_VOL,	0x00 },
 	{ ADAU1761_PLAY_MIXER_LEFT0,		0x00 },
 	{ ADAU1761_PLAY_MIXER_LEFT1,		0x00 },
 	{ ADAU1761_PLAY_MIXER_RIGHT0,		0x00 },
 	{ ADAU1761_PLAY_MIXER_RIGHT1,		0x00 },
+	{ ADAU1761_PLAY_LR_MIXER_LEFT,		0x00 },
 	{ ADAU1761_PLAY_LR_MIXER_RIGHT,		0x00 },
 	{ ADAU1761_PLAY_MIXER_MONO,		0x00 },
 	{ ADAU1761_PLAY_HP_LEFT_VOL,		0x00 },
@@ -93,20 +103,6 @@ static const struct reg_default adau1761
 	{ ADAU1761_PLAY_LINE_RIGHT_VOL,		0x00 },
 	{ ADAU1761_PLAY_MONO_OUTPUT_VOL,	0x00 },
 	{ ADAU1761_POP_CLICK_SUPPRESS,		0x00 },
-	{ ADAU1761_JACK_DETECT_PIN,		0x00 },
-	{ ADAU1761_CLK_ENABLE0,			0x00 },
-	{ ADAU1761_CLK_ENABLE1,			0x00 },
-	{ ADAU17X1_CLOCK_CONTROL,		0x00 },
-	{ ADAU17X1_PLL_CONTROL,			0x00 },
-	{ ADAU17X1_REC_POWER_MGMT,		0x00 },
-	{ ADAU17X1_MICBIAS,			0x00 },
-	{ ADAU17X1_SERIAL_PORT0,		0x00 },
-	{ ADAU17X1_SERIAL_PORT1,		0x00 },
-	{ ADAU17X1_CONVERTER0,			0x00 },
-	{ ADAU17X1_CONVERTER1,			0x00 },
-	{ ADAU17X1_LEFT_INPUT_DIGITAL_VOL,	0x00 },
-	{ ADAU17X1_RIGHT_INPUT_DIGITAL_VOL,	0x00 },
-	{ ADAU17X1_ADC_CONTROL,			0x00 },
 	{ ADAU17X1_PLAY_POWER_MGMT,		0x00 },
 	{ ADAU17X1_DAC_CONTROL0,		0x00 },
 	{ ADAU17X1_DAC_CONTROL1,		0x00 },
@@ -114,12 +110,16 @@ static const struct reg_default adau1761
 	{ ADAU17X1_SERIAL_PORT_PAD,		0xaa },
 	{ ADAU17X1_CONTROL_PORT_PAD0,		0xaa },
 	{ ADAU17X1_CONTROL_PORT_PAD1,		0x00 },
+	{ ADAU1761_JACK_DETECT_PIN,		0x00 },
+	{ ADAU1761_DEJITTER,			0x03 },
 	{ ADAU17X1_DSP_SAMPLING_RATE,		0x01 },
 	{ ADAU17X1_SERIAL_INPUT_ROUTE,		0x00 },
 	{ ADAU17X1_SERIAL_OUTPUT_ROUTE,		0x00 },
 	{ ADAU17X1_DSP_ENABLE,			0x00 },
 	{ ADAU17X1_DSP_RUN,			0x00 },
 	{ ADAU17X1_SERIAL_SAMPLING_RATE,	0x00 },
+	{ ADAU1761_CLK_ENABLE0,			0x00 },
+	{ ADAU1761_CLK_ENABLE1,			0x00 },
 };
 
 static const DECLARE_TLV_DB_SCALE(adau1761_sing_in_tlv, -1500, 300, 1);


