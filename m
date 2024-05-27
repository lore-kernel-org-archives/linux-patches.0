Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5B9168C4;
	Mon, 27 May 2024 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837585; cv=none; b=L1jIx2MKqlfRNm9Q8SPbceE0kKcirqCdA4X9PUUGQauEY/0HXzp5+Ws0tXizfPKZT/kQBi4ozsOkX5XEPiaPtbJoMMvd5nG3W/qmPc35GyeHXqHAgyvl29Xd8F3e5N5r4WP3dkdDfodCLr0EA3TDQ6waAp2Ip5iuqUPu0pkqRIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837585; c=relaxed/simple;
	bh=gDH7+Sv6sa8hhDpyfZcyrdNubKv7Ws5CttHBv7lnOOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCOvD5DwdgXbEcwiVUoJt+jEEbYVjPwQxk4gDrx2FUdQESe3WB97SoDUctX1qw3Y+H08W2DqXc6lMF57qw5wmsDI3MeiNG5zyh29lJFuX5XNISDe9dtnJnJAvOyS5B1H7Gt6og/6CgQ191MizpYmiBSDBRIdrSRFntSZV1oNnDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZ85fkvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZ85fkvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64F7C2BBFC;
	Mon, 27 May 2024 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837585;
	bh=gDH7+Sv6sa8hhDpyfZcyrdNubKv7Ws5CttHBv7lnOOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZ85fkvWqjTfOCL0UR7A67gXt2xYExxa1+Rc65pCEZTv4uEbs00v0wGVUhTZPQvwX
	 f6RTEx4P24Sam5wZgUe8gGDmtCEgSyfW4CGq6APbvjyMVvZNalF4Bjz9I9v+dKcE3N
	 8PV0XmBYfH4WHfz3sQpItrAZGvj93KTcGaAvqVOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 067/493] ASoC: SOF: ipc4-pcm: Introduce generic sof_ipc4_pcm_stream_priv
Date: Mon, 27 May 2024 20:51:09 +0200
Message-ID: <20240527185631.907215328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 551af3280c16166244425bbb1d73028f3a907e1f ]

Using the sof_ipc4_timestamp_info struct directly as sps->private data
is too restrictive, add a new generic sof_ipc4_pcm_stream_priv struct
containing the time_info to allow new information to be stored in a
generic way.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://msgid.link/r/20240409110036.9411-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 43 ++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 3f8b9443496ce..d07c1b06207a5 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -37,6 +37,22 @@ struct sof_ipc4_timestamp_info {
 	snd_pcm_sframes_t delay;
 };
 
+/**
+ * struct sof_ipc4_pcm_stream_priv - IPC4 specific private data
+ * @time_info: pointer to time info struct if it is supported, otherwise NULL
+ */
+struct sof_ipc4_pcm_stream_priv {
+	struct sof_ipc4_timestamp_info *time_info;
+};
+
+static inline struct sof_ipc4_timestamp_info *
+sof_ipc4_sps_to_time_info(struct snd_sof_pcm_stream *sps)
+{
+	struct sof_ipc4_pcm_stream_priv *stream_priv = sps->private;
+
+	return stream_priv->time_info;
+}
+
 static int sof_ipc4_set_multi_pipeline_state(struct snd_sof_dev *sdev, u32 state,
 					     struct ipc4_pipeline_set_state_data *trigger_list)
 {
@@ -435,7 +451,7 @@ static int sof_ipc4_trigger_pipelines(struct snd_soc_component *component,
 		 * Invalidate the stream_start_offset to make sure that it is
 		 * going to be updated if the stream resumes
 		 */
-		time_info = spcm->stream[substream->stream].private;
+		time_info = sof_ipc4_sps_to_time_info(&spcm->stream[substream->stream]);
 		if (time_info)
 			time_info->stream_start_offset = SOF_IPC4_INVALID_STREAM_POSITION;
 
@@ -689,12 +705,16 @@ static int sof_ipc4_pcm_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 static void sof_ipc4_pcm_free(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm)
 {
 	struct snd_sof_pcm_stream_pipeline_list *pipeline_list;
+	struct sof_ipc4_pcm_stream_priv *stream_priv;
 	int stream;
 
 	for_each_pcm_streams(stream) {
 		pipeline_list = &spcm->stream[stream].pipeline_list;
 		kfree(pipeline_list->pipelines);
 		pipeline_list->pipelines = NULL;
+
+		stream_priv = spcm->stream[stream].private;
+		kfree(stream_priv->time_info);
 		kfree(spcm->stream[stream].private);
 		spcm->stream[stream].private = NULL;
 	}
@@ -704,6 +724,7 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 {
 	struct snd_sof_pcm_stream_pipeline_list *pipeline_list;
 	struct sof_ipc4_fw_data *ipc4_data = sdev->private;
+	struct sof_ipc4_pcm_stream_priv *stream_priv;
 	struct sof_ipc4_timestamp_info *time_info;
 	bool support_info = true;
 	u32 abi_version;
@@ -732,6 +753,14 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 			return -ENOMEM;
 		}
 
+		stream_priv = kzalloc(sizeof(*stream_priv), GFP_KERNEL);
+		if (!stream_priv) {
+			sof_ipc4_pcm_free(sdev, spcm);
+			return -ENOMEM;
+		}
+
+		spcm->stream[stream].private = stream_priv;
+
 		if (!support_info)
 			continue;
 
@@ -741,7 +770,7 @@ static int sof_ipc4_pcm_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm
 			return -ENOMEM;
 		}
 
-		spcm->stream[stream].private = time_info;
+		stream_priv->time_info = time_info;
 	}
 
 	return 0;
@@ -778,7 +807,7 @@ static void sof_ipc4_build_time_info(struct snd_sof_dev *sdev, struct snd_sof_pc
 		return;
 	}
 
-	time_info = sps->private;
+	time_info = sof_ipc4_sps_to_time_info(sps);
 	time_info->host_copier = host_copier;
 	time_info->dai_copier = dai_copier;
 	time_info->llp_offset = offsetof(struct sof_ipc4_fw_registers,
@@ -832,7 +861,7 @@ static int sof_ipc4_pcm_hw_params(struct snd_soc_component *component,
 	if (!spcm)
 		return -EINVAL;
 
-	time_info = spcm->stream[substream->stream].private;
+	time_info = sof_ipc4_sps_to_time_info(&spcm->stream[substream->stream]);
 	/* delay calculation is not supported by current fw_reg ABI */
 	if (!time_info)
 		return 0;
@@ -911,7 +940,7 @@ static int sof_ipc4_pcm_pointer(struct snd_soc_component *component,
 		return -EOPNOTSUPP;
 
 	sps = &spcm->stream[substream->stream];
-	time_info = sps->private;
+	time_info = sof_ipc4_sps_to_time_info(sps);
 	if (!time_info)
 		return -EOPNOTSUPP;
 
@@ -1013,15 +1042,13 @@ static snd_pcm_sframes_t sof_ipc4_pcm_delay(struct snd_soc_component *component,
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct sof_ipc4_timestamp_info *time_info;
-	struct snd_sof_pcm_stream *sps;
 	struct snd_sof_pcm *spcm;
 
 	spcm = snd_sof_find_spcm_dai(component, rtd);
 	if (!spcm)
 		return 0;
 
-	sps = &spcm->stream[substream->stream];
-	time_info = sps->private;
+	time_info = sof_ipc4_sps_to_time_info(&spcm->stream[substream->stream]);
 	/*
 	 * Report the stored delay value calculated in the pointer callback.
 	 * In the unlikely event that the calculation was skipped/aborted, the
-- 
2.43.0



