Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D644C10EF;
	Thu, 17 Sep 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659234; cv=none; b=TJw1bIiq/EdB42UiSX/7UqruflEs2/92wspc/AtrUL8yP+CAjmzp5MbwL5inhZuUSGn8CyH+c7RuLFQ6oxfSaMywalKuewqnbFnwJd8LVQULgjbpfGwHSN3V3wGx/pp/oBNLFmtuE83Uqs6NGrOpcZK6vkHzJIhY+UgEFHrWFu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659234; c=relaxed/simple;
	bh=eF2t85mOjtz/DtquUwrljgVl9cErsIVDuVDo1Nj/MeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF/VsqwZhkip+jCw6dKhLAbx5VNyFuqGg4DVJRYN2Hbyjk1KAA4DdzHD45gMxzp7cNBHAnUj1L0SvljKEp+mpayGmpYpLFzU43T5RXqb+fekU9d6CMW6/jVwKKM1mvY9+sizSfy0yLIEeT/NObCXwci3YM5GXfDw+nJvTrbYHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLnJdfmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLnJdfmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB5E1F000FF;
	Thu, 17 Sep 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659230;
	bh=vsnLS7RROXt4Bj65dc4AOJEV+uViEiCU2c3CDFzU/Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLnJdfmq9FhS/U+SbhQP5NhGdgHD3Q6rLMgS5KevLcfFfNDMJ6GDQCTL19pV+I5B2
	 QRm941v73YlFSkbeU+xJyK7c0J/HrSgdV0Gq1yZl5D9BA1cixZxX7jdRoWpeGQSsBj
	 dkwCvUH87r+ABLOrzI8yCAml00WA7pemwhPm+0LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 187/733] ASoC: ux500: Allow repeated MSP prepare calls
Date: Thu, 17 Sep 2026 16:08:15 +0100
Message-ID: <20260917151355.798282549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5b4b3126637e4..37c48cc70394e 100644
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



