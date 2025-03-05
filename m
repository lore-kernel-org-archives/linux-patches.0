Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FDC250BFB;
	Wed,  5 Mar 2025 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197124; cv=none; b=P+f4XyqF3694H87zMWZsoIpPG/HYICUlgUYtMuR4WP7nMaM3I+oeA91TPBxz/KUerycNHGY1/ExumP6R2Mein1lmXS+pxVXnyzRd6i2jN4PZVlw4oRlkoE9jXZtBVH+IttdlS9f22N5RrN8HFMFRCmgfJTxeCtcpy5k7q8h5H0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197124; c=relaxed/simple;
	bh=/+h51MR3ZrsMOh5s2yxLb+Un6C/VngYuoJi1xg6UA90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTBWeQvOdQvupEPGYQxi660HOFFnYCKca7FWw2Y3FUwcXmHF7gQyCFW8RCG90aI4ADkT3updMm8nLjExw+a8fmKTEF6DB+E8U+GYmqyv7T6E07kt01pfpjHD+nhElFAjREita7tMG4p7HvfPhqPKmIlFyXQFc1wjyznIw1nmY4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2/GQvKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2/GQvKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15943C4CED1;
	Wed,  5 Mar 2025 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197123;
	bh=/+h51MR3ZrsMOh5s2yxLb+Un6C/VngYuoJi1xg6UA90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2/GQvKA8hgILixPjrzGUnD1sDZvdffXUsmzgizk5L9MAz4Q9JL5otOKA3BEBG4UL
	 aTYns2ylk46KDz2TGbWz/36BCICiSh3h0cAoBO+ANzkTXaKE1895+DsKhqt6cc6Udf
	 XWFUdllfmg+xvoEmMjiH2ILxQXuYe4Yt37xe6qYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/176] ALSA: hda/cirrus: Correct the full scale volume set logic
Date: Wed,  5 Mar 2025 18:46:57 +0100
Message-ID: <20250305174507.393168118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b288874e401e5..b2e1856ab8918 100644
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
index 892223d9e64ab..b003ac1990ba8 100644
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
@@ -921,7 +923,7 @@ static void cs42l42_suspend(struct sub_codec *cs42l42)
 		{ CS42L42_MIXER_CHA_VOL, 0x3F },
 		{ CS42L42_MIXER_ADC_VOL, 0x3F },
 		{ CS42L42_MIXER_CHB_VOL, 0x3F },
-		{ CS42L42_HP_CTL, 0x0F },
+		{ CS42L42_HP_CTL, 0x0D },
 		{ CS42L42_ASP_RX_DAI0_EN, 0x00 },
 		{ CS42L42_ASP_CLK_CFG, 0x00 },
 		{ CS42L42_PWR_CTL1, 0xFE },
diff --git a/sound/pci/hda/patch_cs8409.h b/sound/pci/hda/patch_cs8409.h
index 937e9387abdc7..bca81d49f201a 100644
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



