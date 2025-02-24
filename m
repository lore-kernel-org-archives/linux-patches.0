Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D8E19CC08;
	Mon, 24 Feb 2025 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408979; cv=none; b=jLeWaZ326SQPRPtwvG5i+c2L43weXP6y2hnMId1hX6bhSsqQMX+enInW5n2G+HhcCXTYZSnjKsc/4aI34Ndj8dT6rmcziH87o1vNyHYN79bKIg5i9ipItHRJjmj2+gLNEmoQrf37ZBdNWTzvrWZJSuZL6fVW4MSGwhp+Q/b4a0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408979; c=relaxed/simple;
	bh=YLbiMDuVDWEN0eIweYSCRSWm7pOp8Y5LcAHe0fGxaSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dadNTN0BsX2AM2WD2UgOjB7od4LSHDtWu+e6OnDKZMvkdFcGefzAbYwrX9MY3OwhAFgm8F4P8L2/4Nzrw94gfAgy3m46ffONhcSC68r4R+O7LWDZgqloEZ7iZ7GSKdBaFsd/4kdK/M4NGNwoM3yUWwKfMBjy9ZTWG0Ts8m/50+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICAlpLph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICAlpLph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292EFC4CEE8;
	Mon, 24 Feb 2025 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408979;
	bh=YLbiMDuVDWEN0eIweYSCRSWm7pOp8Y5LcAHe0fGxaSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICAlpLph/yByTPjSbdH5PqkAZegTN9MinsZCySYtoYddGLVAHw8lw5oSSL/69gW8j
	 iSMOrodVyRTROc+8D500TOUxITPXXKssSS6hNrAFXi6n814VG8nrWO+d+ElVJPjL2Z
	 0AN/lJRXcJo9Kc2h8U1JH17f+FR7LCq0+00ZDGPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/138] ALSA: hda/cirrus: Correct the full scale volume set logic
Date: Mon, 24 Feb 2025 15:34:19 +0100
Message-ID: <20250224142605.615553842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

[ Upstream commit 08b613b9e2ba431db3bd15cb68ca72472a50ef5c ]

This patch corrects the full-scale volume setting logic. On certain
platforms, the full-scale volume bit is required. The current logic
mistakenly sets this bit and incorrectly clears reserved bit 0, causing
the headphone output to be muted.

Fixes: 342b6b610ae2 ("ALSA: hda/cs8409: Fix Full Scale Volume setting for all variants")
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Link: https://patch.msgid.link/20250214210736.30814-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_cs8409-tables.c |  6 +++---
 sound/pci/hda/patch_cs8409.c        | 20 +++++++++++---------
 sound/pci/hda/patch_cs8409.h        |  5 +++--
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/patch_cs8409-tables.c b/sound/pci/hda/patch_cs8409-tables.c
index 759f48038273d..621f947e38174 100644
--- a/sound/pci/hda/patch_cs8409-tables.c
+++ b/sound/pci/hda/patch_cs8409-tables.c
@@ -121,7 +121,7 @@ static const struct cs8409_i2c_param cs42l42_init_reg_seq[] = {
 	{ CS42L42_MIXER_CHA_VOL, 0x3F },
 	{ CS42L42_MIXER_CHB_VOL, 0x3F },
 	{ CS42L42_MIXER_ADC_VOL, 0x3f },
-	{ CS42L42_HP_CTL, 0x03 },
+	{ CS42L42_HP_CTL, 0x0D },
 	{ CS42L42_MIC_DET_CTL1, 0xB6 },
 	{ CS42L42_TIPSENSE_CTL, 0xC2 },
 	{ CS42L42_HS_CLAMP_DISABLE, 0x01 },
@@ -315,7 +315,7 @@ static const struct cs8409_i2c_param dolphin_c0_init_reg_seq[] = {
 	{ CS42L42_ASP_TX_SZ_EN, 0x01 },
 	{ CS42L42_PWR_CTL1, 0x0A },
 	{ CS42L42_PWR_CTL2, 0x84 },
-	{ CS42L42_HP_CTL, 0x03 },
+	{ CS42L42_HP_CTL, 0x0D },
 	{ CS42L42_MIXER_CHA_VOL, 0x3F },
 	{ CS42L42_MIXER_CHB_VOL, 0x3F },
 	{ CS42L42_MIXER_ADC_VOL, 0x3f },
@@ -371,7 +371,7 @@ static const struct cs8409_i2c_param dolphin_c1_init_reg_seq[] = {
 	{ CS42L42_ASP_TX_SZ_EN, 0x00 },
 	{ CS42L42_PWR_CTL1, 0x0E },
 	{ CS42L42_PWR_CTL2, 0x84 },
-	{ CS42L42_HP_CTL, 0x01 },
+	{ CS42L42_HP_CTL, 0x0D },
 	{ CS42L42_MIXER_CHA_VOL, 0x3F },
 	{ CS42L42_MIXER_CHB_VOL, 0x3F },
 	{ CS42L42_MIXER_ADC_VOL, 0x3f },
diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index 614327218634c..b760332a4e357 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -876,7 +876,7 @@ static void cs42l42_resume(struct sub_codec *cs42l42)
 		{ CS42L42_DET_INT_STATUS2, 0x00 },
 		{ CS42L42_TSRS_PLUG_STATUS, 0x00 },
 	};
-	int fsv_old, fsv_new;
+	unsigned int fsv;
 
 	/* Bring CS42L42 out of Reset */
 	spec->gpio_data = snd_hda_codec_read(codec, CS8409_PIN_AFG, 0, AC_VERB_GET_GPIO_DATA, 0);
@@ -893,13 +893,15 @@ static void cs42l42_resume(struct sub_codec *cs42l42)
 	/* Clear interrupts, by reading interrupt status registers */
 	cs8409_i2c_bulk_read(cs42l42, irq_regs, ARRAY_SIZE(irq_regs));
 
-	fsv_old = cs8409_i2c_read(cs42l42, CS42L42_HP_CTL);
-	if (cs42l42->full_scale_vol == CS42L42_FULL_SCALE_VOL_0DB)
-		fsv_new = fsv_old & ~CS42L42_FULL_SCALE_VOL_MASK;
-	else
-		fsv_new = fsv_old & CS42L42_FULL_SCALE_VOL_MASK;
-	if (fsv_new != fsv_old)
-		cs8409_i2c_write(cs42l42, CS42L42_HP_CTL, fsv_new);
+	fsv = cs8409_i2c_read(cs42l42, CS42L42_HP_CTL);
+	if (cs42l42->full_scale_vol) {
+		// Set the full scale volume bit
+		fsv |= CS42L42_FULL_SCALE_VOL_MASK;
+		cs8409_i2c_write(cs42l42, CS42L42_HP_CTL, fsv);
+	}
+	// Unmute analog channels A and B
+	fsv = (fsv & ~CS42L42_ANA_MUTE_AB);
+	cs8409_i2c_write(cs42l42, CS42L42_HP_CTL, fsv);
 
 	/* we have to explicitly allow unsol event handling even during the
 	 * resume phase so that the jack event is processed properly
@@ -920,7 +922,7 @@ static void cs42l42_suspend(struct sub_codec *cs42l42)
 		{ CS42L42_MIXER_CHA_VOL, 0x3F },
 		{ CS42L42_MIXER_ADC_VOL, 0x3F },
 		{ CS42L42_MIXER_CHB_VOL, 0x3F },
-		{ CS42L42_HP_CTL, 0x0F },
+		{ CS42L42_HP_CTL, 0x0D },
 		{ CS42L42_ASP_RX_DAI0_EN, 0x00 },
 		{ CS42L42_ASP_CLK_CFG, 0x00 },
 		{ CS42L42_PWR_CTL1, 0xFE },
diff --git a/sound/pci/hda/patch_cs8409.h b/sound/pci/hda/patch_cs8409.h
index 5e48115caf096..14645d25e70fd 100644
--- a/sound/pci/hda/patch_cs8409.h
+++ b/sound/pci/hda/patch_cs8409.h
@@ -230,9 +230,10 @@ enum cs8409_coefficient_index_registers {
 #define CS42L42_PDN_TIMEOUT_US			(250000)
 #define CS42L42_PDN_SLEEP_US			(2000)
 #define CS42L42_INIT_TIMEOUT_MS			(45)
+#define CS42L42_ANA_MUTE_AB			(0x0C)
 #define CS42L42_FULL_SCALE_VOL_MASK		(2)
-#define CS42L42_FULL_SCALE_VOL_0DB		(1)
-#define CS42L42_FULL_SCALE_VOL_MINUS6DB		(0)
+#define CS42L42_FULL_SCALE_VOL_0DB		(0)
+#define CS42L42_FULL_SCALE_VOL_MINUS6DB		(1)
 
 /* Dell BULLSEYE / WARLOCK / CYBORG Specific Definitions */
 
-- 
2.39.5



