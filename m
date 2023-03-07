Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FAABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA2CC433D2;
	Tue,  7 Mar 2023 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212952;
	bh=+kcsqaMX+gi+FIq0V5brIxF2J6mu4X5y6jf8toCIXpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krSVShjR4/xgr4M9ZWN70gxEs5xitB9LT+KtgaXyMVeVttxekn3O2L2WUFsvus8qE
	 4rPKK3Pcm7/Gmcf78Xzef0ehUxdbKelJr/U9z9i6ScXs1u9h6enueUf3z/caIxsA3b
	 7XcYSdCHhNfz3Y9JFsBHkbD5OXfCvDLsgnIhS88E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 351/885] ASoC: qcom: q6apm-lpass-dai: unprepare stream if its already prepared
Date: Tue,  7 Mar 2023 17:54:45 +0100
Message-Id: <20230307170017.509092783@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c2ac3aec474da0455df79c4a182f19687bc98d1d ]

prepare callback can be called multiple times, so unprepare the stream
if its already prepared.

Without this DSP is not happy to setting the params on a already
prepared graph.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
index ce9e5646d8f3a..23d23bc6fbaa7 100644
--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -127,6 +127,11 @@ static int q6apm_lpass_dai_prepare(struct snd_pcm_substream *substream, struct s
 	int graph_id = dai->id;
 	int rc;
 
+	if (dai_data->is_port_started[dai->id]) {
+		q6apm_graph_stop(dai_data->graph[dai->id]);
+		dai_data->is_port_started[dai->id] = false;
+	}
+
 	/**
 	 * It is recommend to load DSP with source graph first and then sink
 	 * graph, so sequence for playback and capture will be different
-- 
2.39.2



