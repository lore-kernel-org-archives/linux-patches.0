Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE68189B94;
	Tue, 30 Jul 2024 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357501; cv=none; b=M4YeRBN4C7Jy8UgZiV+B0ypJUmb6L3QkcYr7R91W3Yxv0bWr38f1WMkvoRSeNNq4LrjG9laO5xcNEqevFJoUgyFXKXxyTypQ5/TvPfn+2g9QNNxSEcMw0yGyPQUqc05Gj8MJH0OxuDjERj9r9WSqRsMuOICeuncESxo+9cj+IEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357501; c=relaxed/simple;
	bh=cID4yMtkbDdXi/VOQ9NWc0er+YMtGpJSteihIyDvxHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFpmEHI89wF4Rpe4Kl2iKaD6250+P8NaS6ptVMkJmwsj1AzKfuPLi7cs2Kf9vyCf4pRW4prCP1/5LdFAxKse2JdAxt6K9IJScWANUCjqagKD9WEXPMIt/5OKjTAIZRTSWHlbr6XsHWI/iLXsPmrqmryX3YCW51Em4EYLr2cVuaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNVZZqRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNVZZqRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D51C4AF0F;
	Tue, 30 Jul 2024 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357501;
	bh=cID4yMtkbDdXi/VOQ9NWc0er+YMtGpJSteihIyDvxHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNVZZqRD0vDAxCinLdkOoIke/kGUt5Oj/+mJHFquB6UATKquNYpGt3ArbfJOVJ96p
	 yYG6Wi7A6OSNmo8v9u72Li9CHBMiXeLHa99NV8wREWMtXv9nit4aI+MVMKXLC6dbbW
	 jfD2VfgVWqVhBvaDb0xk3OqJP5t5gRzyPsOD3OOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/568] ASoc: tas2781: Enable RCA-based playback without DSP firmware download
Date: Tue, 30 Jul 2024 17:46:08 +0200
Message-ID: <20240730151650.079492151@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 9f774c757e3fb2ac32dc4377e8f21f3364a8df81 ]

In only loading RCA (Reconfigurable Architecture) binary case, no DSP
program will be working inside tas2563/tas2781, that is dsp-bypass mode,
do not support speaker protection, or audio acoustic algorithms in this
mode.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240614133646.910-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781-dsp.h       | 11 +++++++--
 sound/soc/codecs/tas2781-fmwlib.c | 18 ++++++++++----
 sound/soc/codecs/tas2781-i2c.c    | 39 ++++++++++++++++++++-----------
 3 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/include/sound/tas2781-dsp.h b/include/sound/tas2781-dsp.h
index 4ef0f5c6fe6c0..af3319dab230a 100644
--- a/include/sound/tas2781-dsp.h
+++ b/include/sound/tas2781-dsp.h
@@ -112,10 +112,17 @@ struct tasdevice_fw {
 	struct device *dev;
 };
 
-enum tasdevice_dsp_fw_state {
-	TASDEVICE_DSP_FW_NONE = 0,
+enum tasdevice_fw_state {
+	/* Driver in startup mode, not load any firmware. */
 	TASDEVICE_DSP_FW_PENDING,
+	/* DSP firmware in the system, but parsing error. */
 	TASDEVICE_DSP_FW_FAIL,
+	/*
+	 * Only RCA (Reconfigurable Architecture) firmware load
+	 * successfully.
+	 */
+	TASDEVICE_RCA_FW_OK,
+	/* Both RCA and DSP firmware load successfully. */
 	TASDEVICE_DSP_FW_ALL_OK,
 };
 
diff --git a/sound/soc/codecs/tas2781-fmwlib.c b/sound/soc/codecs/tas2781-fmwlib.c
index c6c47297a4fe7..32ff4fb14998e 100644
--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2354,14 +2354,21 @@ void tasdevice_tuning_switch(void *context, int state)
 	struct tasdevice_fw *tas_fmw = tas_priv->fmw;
 	int profile_cfg_id = tas_priv->rcabin.profile_cfg_id;
 
-	if (tas_priv->fw_state == TASDEVICE_DSP_FW_FAIL) {
-		dev_err(tas_priv->dev, "DSP bin file not loaded\n");
+	/*
+	 * Only RCA-based Playback can still work with no dsp program running
+	 * inside the chip.
+	 */
+	switch (tas_priv->fw_state) {
+	case TASDEVICE_RCA_FW_OK:
+	case TASDEVICE_DSP_FW_ALL_OK:
+		break;
+	default:
 		return;
 	}
 
 	if (state == 0) {
-		if (tas_priv->cur_prog < tas_fmw->nr_programs) {
-			/*dsp mode or tuning mode*/
+		if (tas_fmw && tas_priv->cur_prog < tas_fmw->nr_programs) {
+			/* dsp mode or tuning mode */
 			profile_cfg_id = tas_priv->rcabin.profile_cfg_id;
 			tasdevice_select_tuningprm_cfg(tas_priv,
 				tas_priv->cur_prog, tas_priv->cur_conf,
@@ -2370,9 +2377,10 @@ void tasdevice_tuning_switch(void *context, int state)
 
 		tasdevice_select_cfg_blk(tas_priv, profile_cfg_id,
 			TASDEVICE_BIN_BLK_PRE_POWER_UP);
-	} else
+	} else {
 		tasdevice_select_cfg_blk(tas_priv, profile_cfg_id,
 			TASDEVICE_BIN_BLK_PRE_SHUTDOWN);
+	}
 }
 EXPORT_SYMBOL_NS_GPL(tasdevice_tuning_switch,
 	SND_SOC_TAS2781_FMWLIB);
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 7327e9dcc8c02..a9d179e307739 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -378,23 +378,37 @@ static void tasdevice_fw_ready(const struct firmware *fmw,
 	mutex_lock(&tas_priv->codec_lock);
 
 	ret = tasdevice_rca_parser(tas_priv, fmw);
-	if (ret)
+	if (ret) {
+		tasdevice_config_info_remove(tas_priv);
 		goto out;
+	}
 	tasdevice_create_control(tas_priv);
 
 	tasdevice_dsp_remove(tas_priv);
 	tasdevice_calbin_remove(tas_priv);
-	tas_priv->fw_state = TASDEVICE_DSP_FW_PENDING;
+	/*
+	 * The baseline is the RCA-only case, and then the code attempts to
+	 * load DSP firmware but in case of failures just keep going, i.e.
+	 * failing to load DSP firmware is NOT an error.
+	 */
+	tas_priv->fw_state = TASDEVICE_RCA_FW_OK;
 	scnprintf(tas_priv->coef_binaryname, 64, "%s_coef.bin",
 		tas_priv->dev_name);
 	ret = tasdevice_dsp_parser(tas_priv);
 	if (ret) {
 		dev_err(tas_priv->dev, "dspfw load %s error\n",
 			tas_priv->coef_binaryname);
-		tas_priv->fw_state = TASDEVICE_DSP_FW_FAIL;
 		goto out;
 	}
-	tasdevice_dsp_create_ctrls(tas_priv);
+
+	/*
+	 * If no dsp-related kcontrol created, the dsp resource will be freed.
+	 */
+	ret = tasdevice_dsp_create_ctrls(tas_priv);
+	if (ret) {
+		dev_err(tas_priv->dev, "dsp controls error\n");
+		goto out;
+	}
 
 	tas_priv->fw_state = TASDEVICE_DSP_FW_ALL_OK;
 
@@ -415,9 +429,8 @@ static void tasdevice_fw_ready(const struct firmware *fmw,
 	tasdevice_prmg_load(tas_priv, 0);
 	tas_priv->cur_prog = 0;
 out:
-	if (tas_priv->fw_state == TASDEVICE_DSP_FW_FAIL) {
-		/*If DSP FW fail, kcontrol won't be created */
-		tasdevice_config_info_remove(tas_priv);
+	if (tas_priv->fw_state == TASDEVICE_RCA_FW_OK) {
+		/* If DSP FW fail, DSP kcontrol won't be created. */
 		tasdevice_dsp_remove(tas_priv);
 	}
 	mutex_unlock(&tas_priv->codec_lock);
@@ -464,14 +477,14 @@ static int tasdevice_startup(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_component *codec = dai->component;
 	struct tasdevice_priv *tas_priv = snd_soc_component_get_drvdata(codec);
-	int ret = 0;
 
-	if (tas_priv->fw_state != TASDEVICE_DSP_FW_ALL_OK) {
-		dev_err(tas_priv->dev, "DSP bin file not loaded\n");
-		ret = -EINVAL;
+	switch (tas_priv->fw_state) {
+	case TASDEVICE_RCA_FW_OK:
+	case TASDEVICE_DSP_FW_ALL_OK:
+		return 0;
+	default:
+		return -EINVAL;
 	}
-
-	return ret;
 }
 
 static int tasdevice_hw_params(struct snd_pcm_substream *substream,
-- 
2.43.0



