Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D1C8E6;
	Mon, 22 Sep 2025 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569624; cv=none; b=BhHFQc30ZcwmaQguI6HOxpPeBIcr4KjoaX1KyJ2Z084yvCij+fiffx429cMcQSD6fwkTkXYnpKlA02AvPTYJVSD+KlkjZhSvTVM8phfLb1qt+u5+YmrFT3BM9lULssFMTZaC/T+jjjOlWmxRhYK0VWgwSvLobJDtID6F7rp2r18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569624; c=relaxed/simple;
	bh=8q5AYCovZ+61sPXu2691z2GYdzoshjz9aTbM/Pk+azU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXhcjv+TJgaJgN7jEc3iyg2utqndi+iQq+Q/Our0qE/RhQguedD3AM/N7o2vsfbuvwSdZVKIU0g0IkFInBS4V5LjRLfyxrTntgv3YPFCJzkepqNk7q08CzJJ1jGwHG6W9x0BXFTLzRD5wMTeeKlm6VieEMUPCLlbTIjFaB8KHbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dtu9qdJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dtu9qdJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9942C4CEF7;
	Mon, 22 Sep 2025 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569624;
	bh=8q5AYCovZ+61sPXu2691z2GYdzoshjz9aTbM/Pk+azU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dtu9qdJFKLj1Rd5QOMIzxUJotfJ5ddPYEL0hDtcaidCmn7aLLVofVJvDqMBrsx+Us
	 yacYTrBqe6VQAMdHeyujkdcOgoK0LvTCe5x4ishJ/7mL0/w/qX/cs8rOIQBYI/LfRW
	 pmjLJn5yAjHQZxCqGwptkGxWzxt3CpgteP67pHMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/61] ASoC: q6apm-lpass-dai: close graph on prepare errors
Date: Mon, 22 Sep 2025 21:29:51 +0200
Message-ID: <20250922192405.235183679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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
Stable-dep-of: 68f27f7c7708 ("ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -109,14 +109,17 @@ static void q6apm_lpass_dai_shutdown(str
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
@@ -131,8 +134,10 @@ static int q6apm_lpass_dai_prepare(struc
 		q6apm_graph_stop(dai_data->graph[dai->id]);
 		dai_data->is_port_started[dai->id] = false;
 
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			q6apm_graph_close(dai_data->graph[dai->id]);
+			dai_data->graph[dai->id] = NULL;
+		}
 	}
 
 	/**
@@ -151,26 +156,29 @@ static int q6apm_lpass_dai_prepare(struc
 
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


