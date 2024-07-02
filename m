Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE1BE5A;
	Tue,  2 Jul 2024 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940733; cv=none; b=t3+vVIH5J6U/CCy9AcwZ+kNqVnIqM8Z7K3QtUGSqZ+vvXVHT2UFEQ5w31uuz8MCQ1VjNTsV/voMcR4erSeHvRgN2LsVifq83E2whNr8DgAKYDwZUPD2a7kU8hfTetrNEJHZ8itM0o2AsuffH0q95tO7qIevZcNA88vu5WFjKl+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940733; c=relaxed/simple;
	bh=qEg/JPLpa8wa1dVWdrxRatvcbFAQXlG3mwQ//9L8fXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX9rZzN1rFLdgBmEKv8lvH0j+bJOb8OecVREuVElGnkwj3M89mtJ3r2yml+bpSgj4aBdSfZjTsjiGzeJU2G38JjvAQ9tLfQ6V/BJcoIjw4dwTKjZshpUq9dkq6CkLn1lgljSkGepXewLdHU+41FSB/XObjOPFGu++bfUDKO+Axo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wepS92mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wepS92mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD55C116B1;
	Tue,  2 Jul 2024 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940733;
	bh=qEg/JPLpa8wa1dVWdrxRatvcbFAQXlG3mwQ//9L8fXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wepS92mGQg3QPeMGK50SDzRj7bE1KI0O56PRpiMfkoAerhUwgNE8+4H4NEp2JodwQ
	 2MvRVbNIRLiPq8hebuHlj0x4lHevFkMDjhGjvranrSqqzEH5fTbAQ8P3RCl1Eey6sf
	 PYPNdAmVNCFmAxgcdVY5LybK/eyieqphd9FeB2nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/163] ASoC: q6apm-lpass-dai: close graph on prepare errors
Date: Tue,  2 Jul 2024 19:02:15 +0200
Message-ID: <20240702170233.860817084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit be1fae62cf253a5b67526cee9fbc07689b97c125 ]

There is an issue around with error handling and graph management with
the exising code, none of the error paths close the graph, which result in
leaving the loaded graph in dsp, however the driver thinks otherwise.

This can have a nasty side effect specially when we try to load the same
graph to dsp, dsp returns error which leaves the board with no sound and
requires restart.

Fix this by properly closing the graph when we hit errors between
open and close.

Fixes: 30ad723b93ad ("ASoC: qdsp6: audioreach: add q6apm lpass dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # X13s
Link: https://lore.kernel.org/r/20240613-q6apm-fixes-v1-1-d88953675ab3@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c | 32 +++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
index 7ad604b80e25e..6511f0a08de16 100644
--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -140,14 +140,17 @@ static void q6apm_lpass_dai_shutdown(struct snd_pcm_substream *substream, struct
 	struct q6apm_lpass_dai_data *dai_data = dev_get_drvdata(dai->dev);
 	int rc;
 
-	if (!dai_data->is_port_started[dai->id])
-		return;
-	rc = q6apm_graph_stop(dai_data->graph[dai->id]);
-	if (rc < 0)
-		dev_err(dai->dev, "fail to close APM port (%d)\n", rc);
+	if (dai_data->is_port_started[dai->id]) {
+		rc = q6apm_graph_stop(dai_data->graph[dai->id]);
+		dai_data->is_port_started[dai->id] = false;
+		if (rc < 0)
+			dev_err(dai->dev, "fail to close APM port (%d)\n", rc);
+	}
 
-	q6apm_graph_close(dai_data->graph[dai->id]);
-	dai_data->is_port_started[dai->id] = false;
+	if (dai_data->graph[dai->id]) {
+		q6apm_graph_close(dai_data->graph[dai->id]);
+		dai_data->graph[dai->id] = NULL;
+	}
 }
 
 static int q6apm_lpass_dai_prepare(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
@@ -162,8 +165,10 @@ static int q6apm_lpass_dai_prepare(struct snd_pcm_substream *substream, struct s
 		q6apm_graph_stop(dai_data->graph[dai->id]);
 		dai_data->is_port_started[dai->id] = false;
 
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			q6apm_graph_close(dai_data->graph[dai->id]);
+			dai_data->graph[dai->id] = NULL;
+		}
 	}
 
 	/**
@@ -182,26 +187,29 @@ static int q6apm_lpass_dai_prepare(struct snd_pcm_substream *substream, struct s
 
 	cfg->direction = substream->stream;
 	rc = q6apm_graph_media_format_pcm(dai_data->graph[dai->id], cfg);
-
 	if (rc) {
 		dev_err(dai->dev, "Failed to set media format %d\n", rc);
-		return rc;
+		goto err;
 	}
 
 	rc = q6apm_graph_prepare(dai_data->graph[dai->id]);
 	if (rc) {
 		dev_err(dai->dev, "Failed to prepare Graph %d\n", rc);
-		return rc;
+		goto err;
 	}
 
 	rc = q6apm_graph_start(dai_data->graph[dai->id]);
 	if (rc < 0) {
 		dev_err(dai->dev, "fail to start APM port %x\n", dai->id);
-		return rc;
+		goto err;
 	}
 	dai_data->is_port_started[dai->id] = true;
 
 	return 0;
+err:
+	q6apm_graph_close(dai_data->graph[dai->id]);
+	dai_data->graph[dai->id] = NULL;
+	return rc;
 }
 
 static int q6apm_lpass_dai_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
-- 
2.43.0



