Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC484ABBCC;
	Thu, 17 Sep 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669016; cv=none; b=GkUASGo9x/XCbeviPXUR6BNqSuOX4APAkiWFgMXapl8+Yp8g6Jb2AZgjML8GOnIrseBBaVZOifklIqtCjUFNIWDV6Sv46ERHWJvoAFPT0u8f0ZrikeutN50lVTwpDQ0e3Jbs8DE9GpsK18LDJDNVWI0afDjtl7U10wQ4aoIWYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669016; c=relaxed/simple;
	bh=ERAEDcH2OfxM4Bzb9lT2HJWQU2f+HuCysdAp3TqGmr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCUve+5YR3Whw6UiP9TO04TydI+7jFeGPHsvKnxAGGn9vibBfNy7arRWWF0L+6/YBwrLOCYSksDSCVCDPcbNGWbOkZtYEGw9g56ypMqQIbC3rNz6x1HfxFOROT5Ng6aTSamsuEqimQMW/TbvGj6eC/ICif16sNSArNAQKbUG6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e40TbNPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e40TbNPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51151F000FF;
	Thu, 17 Sep 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669015;
	bh=Aq8wNKAtDIDe2uBTpUN7vT44A98tS48IRmSuqsSZSYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e40TbNPHgGS/Co2GK15W5OngM09bRcs1ltn+6FaWTICl06yMoS6gSE4FrSLQQpEV4
	 ej20gdhW7HioGuN207gVo12E963RxufJ2burWWxU+7fzySJCzfaQ32hhd8my5QtO+C
	 75ht3L3Tq7QeK6/3yVOux5IECKnOB1c/m8QpWhY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0616/1102] ASoC: ux500: Allow repeated MSP prepare calls
Date: Thu, 17 Sep 2026 16:09:19 +0100
Message-ID: <20260917151555.522236308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit dc1a1b1e22066f01bb86a9b11ee998d4dc72db66 ]

ALSA can call the DAI prepare callback again after an XRUN without
first shutting down the stream. The MSP open helper rejects the second
call with -EBUSY because the direction remains configured.

Track successful playback and capture configurations at the DAI layer.
Make repeated prepare calls no-ops and only close directions which were
successfully prepared.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-8-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 28 +++++++++++++++++++++-------
 sound/soc/ux500/ux500_msp_dai.h |  1 +
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index c1e5850e9ca92..897dee4d222e3 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -388,15 +388,21 @@ static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
 	int ret;
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
 	bool is_playback = (substream->stream == SNDRV_PCM_STREAM_PLAYBACK);
+	unsigned int configured = is_playback ? PLAYBACK_CONFIGURED :
+		CAPTURE_CONFIGURED;
+	unsigned int dir = is_playback ? MSP_DIR_TX : MSP_DIR_RX;
 
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter.\n", __func__, dai->id,
 		snd_pcm_stream_str(substream));
 
-	if (ux500_msp_i2s_close(drvdata->msp,
-				is_playback ? MSP_DIR_TX : MSP_DIR_RX)) {
-		dev_err(dai->dev,
-			"%s: Error: MSP %d (%s): Unable to close i2s.\n",
-			__func__, dai->id, snd_pcm_stream_str(substream));
+	if (drvdata->configured & configured) {
+		if (ux500_msp_i2s_close(drvdata->msp, dir)) {
+			dev_err(dai->dev,
+				"%s: Error: MSP %d (%s): Unable to close i2s.\n",
+				__func__, dai->id,
+				snd_pcm_stream_str(substream));
+		}
+		drvdata->configured &= ~configured;
 	}
 
 	/* Disable and unprepare clocks */
@@ -414,14 +420,20 @@ static void ux500_msp_dai_shutdown(struct snd_pcm_substream *substream,
 static int ux500_msp_dai_prepare(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
-	int ret = 0;
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct ux500_msp_config msp_config;
+	bool is_playback = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
+	unsigned int configured = is_playback ? PLAYBACK_CONFIGURED :
+		CAPTURE_CONFIGURED;
+	int ret;
 
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter (rate = %d).\n", __func__,
 		dai->id, snd_pcm_stream_str(substream), runtime->rate);
 
+	if (drvdata->configured & configured)
+		return 0;
+
 	ret = setup_msp_config(substream, dai, &msp_config);
 	if (ret)
 		return ret;
@@ -433,7 +445,9 @@ static int ux500_msp_dai_prepare(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	return ret;
+	drvdata->configured |= configured;
+
+	return 0;
 }
 
 static int ux500_msp_dai_hw_params(struct snd_pcm_substream *substream,
diff --git a/sound/soc/ux500/ux500_msp_dai.h b/sound/soc/ux500/ux500_msp_dai.h
index ad4ce69bfbf5c..aae582030d959 100644
--- a/sound/soc/ux500/ux500_msp_dai.h
+++ b/sound/soc/ux500/ux500_msp_dai.h
@@ -36,6 +36,7 @@ struct ux500_msp_i2s_drvdata {
 	struct ux500_msp *msp;
 	struct regulator *reg_vape;
 	unsigned int fmt;
+	unsigned int configured;
 	unsigned int tx_mask;
 	unsigned int rx_mask;
 	int slots;
-- 
2.53.0



