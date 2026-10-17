Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491603A6B67;
	Sat, 17 Oct 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254666; cv=none; b=SXPXmRyaB8+QFnfuLSPQQJIC6pqkQqqeo1t4qOKu3Zlvd0wanbE9uFy2kU09pw/4jT5porgM1gDzhuySIIvaZ03qSP7ZXg/Fmx5a3rOGDemmXT5w3tQgT/dncELEPf8RaPkDf1Sp2YGo3WiwBo2/nLRPRn/gwomQdaXPYX9WOeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254666; c=relaxed/simple;
	bh=hhAfdvVmnA4QTWEhvuJgWwwI132lOG0Yy/cTkFuf71Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEzc7hgjgeI7T2SJvHvn94fmspZtzWM9d6rmYYQj/4YH7gJGfbOIr2+8fOpYO9kN+NUFIEsmIxrRuCK7aB+H7bonXIzMFFivyc6dqLxMhkqwYjgGdDE73aSSiyqWOlTClX4t0jEJnPBCbpECTxzMyN+KHEZI28weZ4vqDsfyrNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zS2u5B92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zS2u5B92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655FB1F000C4;
	Sat, 17 Oct 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254664;
	bh=ZVBkxc7ghXlXBi4LAEh6YcqNGRJ+nAVwjB+6phxFdoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zS2u5B92SImHVrhREsJStOhSDQnLmLqkQXtvS0Iccz7NViYKmUcsR47GeFuu2V4Rp
	 xEOB06VnOMJ3Vjk1B5QD5H4tlnopaE4LtCt2dp+v73CD+3yV+oZkHJc/WHPOzzqoIg
	 kGsf4YkEiXlrLcSsG2k6kUppyxFPPYLbE4mZ1/OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/869] ASoC: SOF: Relocate and rework functionality for PCM stream freeing
Date: Sat, 17 Oct 2026 17:56:03 +0200
Message-ID: <20261017160050.496476326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 169ec0a541aac8afb215ab591b0fd53276686014 ]

Move the sof_pcm_stream_free() from sof-audio.c to pcm.c as static function
and add wrapper to free all active stream, which is going to be used in
ipc3/4 topology code (removes duplicated code).

With this change most of the PCM stream related code is located in one
source file for easier lookup and simplified flow.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20250206092828.7569-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 17661c67b206 ("ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 20 ++-------
 sound/soc/sof/ipc4-topology.c | 18 +-------
 sound/soc/sof/pcm.c           | 78 +++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-audio.c     | 49 ----------------------
 sound/soc/sof/sof-audio.h     |  3 +-
 5 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index 19bbae725d838..f449362a2905a 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2386,28 +2386,16 @@ static int sof_ipc3_set_up_all_pipelines(struct snd_sof_dev *sdev, bool verify)
 static int sof_tear_down_left_over_pipelines(struct snd_sof_dev *sdev)
 {
 	struct snd_sof_widget *swidget;
-	struct snd_sof_pcm *spcm;
-	int dir, ret;
+	int ret;
 
 	/*
 	 * free all PCMs and their associated DAPM widgets if their connected DAPM widget
 	 * list is not NULL. This should only be true for paused streams at this point.
 	 * This is equivalent to the handling of FE DAI suspend trigger for running streams.
 	 */
-	list_for_each_entry(spcm, &sdev->pcm_list, list) {
-		for_each_pcm_streams(dir) {
-			struct snd_pcm_substream *substream = spcm->stream[dir].substream;
-
-			if (!substream || !substream->runtime || spcm->stream[dir].suspend_ignored)
-				continue;
-
-			if (spcm->stream[dir].list) {
-				ret = sof_pcm_stream_free(sdev, substream, spcm, dir, true);
-				if (ret < 0)
-					return ret;
-			}
-		}
-	}
+	ret = sof_pcm_free_all_streams(sdev);
+	if (ret)
+		return ret;
 
 	/*
 	 * free any left over DAI widgets. This is equivalent to the handling of suspend trigger
diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index fabd364d33168..6af0cc154f3d7 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -3345,9 +3345,6 @@ static int sof_ipc4_dai_get_param(struct snd_sof_dev *sdev, struct snd_sof_dai *
 
 static int sof_ipc4_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verify)
 {
-	struct snd_sof_pcm *spcm;
-	int dir, ret;
-
 	/*
 	 * This function is called during system suspend, we need to make sure
 	 * that all streams have been freed up.
@@ -3359,21 +3356,8 @@ static int sof_ipc4_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verif
 	 *
 	 * This will also make sure that paused streams handled correctly.
 	 */
-	list_for_each_entry(spcm, &sdev->pcm_list, list) {
-		for_each_pcm_streams(dir) {
-			struct snd_pcm_substream *substream = spcm->stream[dir].substream;
-
-			if (!substream || !substream->runtime || spcm->stream[dir].suspend_ignored)
-				continue;
 
-			if (spcm->stream[dir].list) {
-				ret = sof_pcm_stream_free(sdev, substream, spcm, dir, true);
-				if (ret < 0)
-					return ret;
-			}
-		}
-	}
-	return 0;
+	return sof_pcm_free_all_streams(sdev);
 }
 
 static int sof_ipc4_link_setup(struct snd_sof_dev *sdev, struct snd_soc_dai_link *link)
diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index c5c6353f18cee..61bd690b29fa5 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -191,6 +191,84 @@ static int sof_pcm_hw_params(struct snd_soc_component *component,
 	return 0;
 }
 
+static int sof_pcm_stream_free(struct snd_sof_dev *sdev,
+			       struct snd_pcm_substream *substream,
+			       struct snd_sof_pcm *spcm, int dir,
+			       bool free_widget_list)
+{
+	const struct sof_ipc_pcm_ops *pcm_ops = sof_ipc_get_ops(sdev, pcm);
+	int ret;
+	int err = 0;
+
+	if (spcm->prepared[substream->stream]) {
+		/* stop DMA first if needed */
+		if (pcm_ops && pcm_ops->platform_stop_during_hw_free)
+			snd_sof_pcm_platform_trigger(sdev, substream,
+						     SNDRV_PCM_TRIGGER_STOP);
+
+		/* free PCM in the DSP */
+		if (pcm_ops && pcm_ops->hw_free) {
+			ret = pcm_ops->hw_free(sdev->component, substream);
+			if (ret < 0) {
+				dev_err(sdev->dev, "%s: pcm_ops hw_free failed %d\n",
+					__func__, ret);
+				err = ret;
+			}
+		}
+
+		spcm->prepared[substream->stream] = false;
+		spcm->pending_stop[substream->stream] = false;
+	}
+
+	/* reset the DMA */
+	ret = snd_sof_pcm_platform_hw_free(sdev, substream);
+	if (ret < 0) {
+		dev_err(sdev->dev, "%s: platform hw free failed %d\n",
+			__func__, ret);
+		if (!err)
+			err = ret;
+	}
+
+	/* free widget list */
+	if (free_widget_list) {
+		ret = sof_widget_list_free(sdev, spcm, dir);
+		if (ret < 0) {
+			dev_err(sdev->dev, "%s: sof_widget_list_free failed %d\n",
+				__func__, ret);
+			if (!err)
+				err = ret;
+		}
+	}
+
+	return err;
+}
+
+int sof_pcm_free_all_streams(struct snd_sof_dev *sdev)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_sof_pcm *spcm;
+	int dir, ret;
+
+	list_for_each_entry(spcm, &sdev->pcm_list, list) {
+		for_each_pcm_streams(dir) {
+			substream = spcm->stream[dir].substream;
+
+			if (!substream || !substream->runtime ||
+			    spcm->stream[dir].suspend_ignored)
+				continue;
+
+			if (spcm->stream[dir].list) {
+				ret = sof_pcm_stream_free(sdev, substream, spcm,
+							  dir, true);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int sof_pcm_hw_free(struct snd_soc_component *component,
 			   struct snd_pcm_substream *substream)
 {
diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index f0a4e146d7981..ef7d2f4b31c81 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -828,55 +828,6 @@ bool snd_sof_stream_suspend_ignored(struct snd_sof_dev *sdev)
 	return false;
 }
 
-int sof_pcm_stream_free(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream,
-			struct snd_sof_pcm *spcm, int dir, bool free_widget_list)
-{
-	const struct sof_ipc_pcm_ops *pcm_ops = sof_ipc_get_ops(sdev, pcm);
-	int ret;
-	int err = 0;
-
-	if (spcm->prepared[substream->stream]) {
-		/* stop DMA first if needed */
-		if (pcm_ops && pcm_ops->platform_stop_during_hw_free)
-			snd_sof_pcm_platform_trigger(sdev, substream, SNDRV_PCM_TRIGGER_STOP);
-
-		/* free PCM in the DSP */
-		if (pcm_ops && pcm_ops->hw_free) {
-			ret = pcm_ops->hw_free(sdev->component, substream);
-			if (ret < 0) {
-				dev_err(sdev->dev, "%s: pcm_ops hw_free failed %d\n",
-					__func__, ret);
-				err = ret;
-			}
-		}
-
-		spcm->prepared[substream->stream] = false;
-		spcm->pending_stop[substream->stream] = false;
-	}
-
-	/* reset the DMA */
-	ret = snd_sof_pcm_platform_hw_free(sdev, substream);
-	if (ret < 0) {
-		dev_err(sdev->dev, "%s: platform hw free failed %d\n",
-			__func__, ret);
-		if (!err)
-			err = ret;
-	}
-
-	/* free widget list */
-	if (free_widget_list) {
-		ret = sof_widget_list_free(sdev, spcm, dir);
-		if (ret < 0) {
-			dev_err(sdev->dev, "%s: sof_widget_list_free failed %d\n",
-				__func__, ret);
-			if (!err)
-				err = ret;
-		}
-	}
-
-	return err;
-}
-
 /*
  * Generic object lookup APIs.
  */
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index 01b819dd84984..6d652a202f698 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -648,8 +648,7 @@ int sof_widget_list_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm,
 int sof_widget_list_free(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
 int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
 			 struct snd_sof_pcm *spcm);
-int sof_pcm_stream_free(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream,
-			struct snd_sof_pcm *spcm, int dir, bool free_widget_list);
+int sof_pcm_free_all_streams(struct snd_sof_dev *sdev);
 int get_token_u32(void *elem, void *object, u32 offset);
 int get_token_u16(void *elem, void *object, u32 offset);
 int get_token_comp_format(void *elem, void *object, u32 offset);
-- 
2.53.0



