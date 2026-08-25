Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BC8392C21;
	Tue, 25 Aug 2026 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665771; cv=none; b=ZxaNUOZfp124OtyoMmeJfc3z8MHxsWwSTyDwFAgimbBpZCH7Q3CNT5Rjd6ndOIoxHEwEX1WtkYPd6DeXNKqZfXoQd1rxmFclGwup0OtGYRuL6QXyyV8ui1bYQmnxs+FyUpCx2j7g/Rj9yWcfCdDzSd+k2upy0B0pVzROvARPp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665771; c=relaxed/simple;
	bh=rwOuXY3lEjUW4AfPhE3dD1ao3C8VZA+vp0KAjmOOu98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVQAE8T0JFdv7h47geCp/goX0V5xfm7KZDeXn4rO5nrsEw3Ms84ZiMmdBNE2++OTsg3gOEch763WV0IOIjYTS7DNWkFJBUbck571kaJ9LSeM7J4MxadjLx8L2QUntJ9xwc0d+r3lSkG+NrONJOa3areqae5Mpd7Mio6kN1zdpq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPuI2OxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPuI2OxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31361F000E9;
	Tue, 25 Aug 2026 13:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665769;
	bh=Kh90AJEF79hgClqGUIzJNsOaMnJjEBBe6Z7+pyvZBOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPuI2OxAgKchiDuHqyNXS7VSPL8RFTEvDnpMa2vZ2pLElRXK4fIf5yO4hVIJ47sD+
	 c64LvO2cNJ6n+WVe8gsVxlROjF7J8JU4/iS+clb44lJ4s4EXqSWKHBPsENgogSJ0kA
	 AEkErhZwl5O4uEBGD78X54k6FpjIu3hhz7BYnuvI=
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
Subject: [PATCH 6.6 58/87] ASoC: SOF: Relocate and rework functionality for PCM stream freeing
Date: Tue, 25 Aug 2026 15:26:21 +0200
Message-ID: <20260825132544.108411432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-topology.c |   20 ++----------
 sound/soc/sof/ipc4-topology.c |   18 -----------
 sound/soc/sof/pcm.c           |   65 ++++++++++++++++++++++++++++++++++++++++++
 sound/soc/sof/sof-audio.c     |   36 -----------------------
 sound/soc/sof/sof-audio.h     |    3 -
 5 files changed, 71 insertions(+), 71 deletions(-)

--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2295,28 +2295,16 @@ static int sof_ipc3_set_up_all_pipelines
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
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2951,9 +2951,6 @@ static int sof_ipc4_dai_get_clk(struct s
 
 static int sof_ipc4_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verify)
 {
-	struct snd_sof_pcm *spcm;
-	int dir, ret;
-
 	/*
 	 * This function is called during system suspend, we need to make sure
 	 * that all streams have been freed up.
@@ -2965,21 +2962,8 @@ static int sof_ipc4_tear_down_all_pipeli
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
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -191,6 +191,71 @@ static int sof_pcm_hw_params(struct snd_
 	return 0;
 }
 
+static int sof_pcm_stream_free(struct snd_sof_dev *sdev,
+			       struct snd_pcm_substream *substream,
+			       struct snd_sof_pcm *spcm, int dir,
+			       bool free_widget_list)
+{
+	const struct sof_ipc_pcm_ops *pcm_ops = sof_ipc_get_ops(sdev, pcm);
+	int ret;
+
+	if (spcm->prepared[substream->stream]) {
+		/* stop DMA first if needed */
+		if (pcm_ops && pcm_ops->platform_stop_during_hw_free)
+			snd_sof_pcm_platform_trigger(sdev, substream,
+						     SNDRV_PCM_TRIGGER_STOP);
+
+		/* Send PCM_FREE IPC to reset pipeline */
+		if (pcm_ops && pcm_ops->hw_free) {
+			ret = pcm_ops->hw_free(sdev->component, substream);
+			if (ret < 0)
+				return ret;
+		}
+
+		spcm->prepared[substream->stream] = false;
+	}
+
+	/* reset the DMA */
+	ret = snd_sof_pcm_platform_hw_free(sdev, substream);
+	if (ret < 0)
+		return ret;
+
+	/* free widget list */
+	if (free_widget_list) {
+		ret = sof_widget_list_free(sdev, spcm, dir);
+		if (ret < 0)
+			dev_err(sdev->dev, "failed to free widgets during suspend\n");
+	}
+
+	return ret;
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
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -831,42 +831,6 @@ bool snd_sof_stream_suspend_ignored(stru
 	return false;
 }
 
-int sof_pcm_stream_free(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream,
-			struct snd_sof_pcm *spcm, int dir, bool free_widget_list)
-{
-	const struct sof_ipc_pcm_ops *pcm_ops = sof_ipc_get_ops(sdev, pcm);
-	int ret;
-
-	if (spcm->prepared[substream->stream]) {
-		/* stop DMA first if needed */
-		if (pcm_ops && pcm_ops->platform_stop_during_hw_free)
-			snd_sof_pcm_platform_trigger(sdev, substream, SNDRV_PCM_TRIGGER_STOP);
-
-		/* Send PCM_FREE IPC to reset pipeline */
-		if (pcm_ops && pcm_ops->hw_free) {
-			ret = pcm_ops->hw_free(sdev->component, substream);
-			if (ret < 0)
-				return ret;
-		}
-
-		spcm->prepared[substream->stream] = false;
-	}
-
-	/* reset the DMA */
-	ret = snd_sof_pcm_platform_hw_free(sdev, substream);
-	if (ret < 0)
-		return ret;
-
-	/* free widget list */
-	if (free_widget_list) {
-		ret = sof_widget_list_free(sdev, spcm, dir);
-		if (ret < 0)
-			dev_err(sdev->dev, "failed to free widgets during suspend\n");
-	}
-
-	return ret;
-}
-
 /*
  * Generic object lookup APIs.
  */
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -633,8 +633,7 @@ int sof_widget_list_setup(struct snd_sof
 int sof_widget_list_free(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
 int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
 			 struct snd_sof_pcm *spcm);
-int sof_pcm_stream_free(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream,
-			struct snd_sof_pcm *spcm, int dir, bool free_widget_list);
+int sof_pcm_free_all_streams(struct snd_sof_dev *sdev);
 int get_token_u32(void *elem, void *object, u32 offset);
 int get_token_u16(void *elem, void *object, u32 offset);
 int get_token_comp_format(void *elem, void *object, u32 offset);


