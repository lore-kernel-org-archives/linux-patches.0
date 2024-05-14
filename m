Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B862612BF3D;
	Tue, 14 May 2024 10:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682469; cv=none; b=aXNd9IJ6UenRYyGfmpA6mAhvn4lH14WOpqbqJgtLksZCpkZhCiY57vQgZwFS0cJxCfkGor8Nv4FcYr8TRkWX3sj3ZjGFpc5MUh1NS2uceW1jQNadWXFgYOv/46LIeAJs+cLKYymWYw5PzoZegZil6l/4igFpBOVSSIuCLGp1/U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682469; c=relaxed/simple;
	bh=n8tZgBmtVuwxsHiGrbqyG871IzFof59eHHhzuP7lG3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHzzTdfTougyo61dkWT7RmJ9ECqQ2ljDkAP8D6Yghvs+uy+3Ukr/LZMGOf0QiwnhSLTvdou7UlsG5GhGrDoZWRMbaH2L71f2zcOEgK5hzHN1iekS39B37+PpdQHPjWT/fxFD5EsEOMn9Sig0zv8AbvMAZFbK7GKlsYLWMz4f2Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j30SzEeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j30SzEeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B34C2BD10;
	Tue, 14 May 2024 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682469;
	bh=n8tZgBmtVuwxsHiGrbqyG871IzFof59eHHhzuP7lG3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j30SzEeFu//g92tu7r4xKzVdmaKeymKWZCD7ahNrU2xrbQBf6zCfyJAiw07yum/bl
	 gIAMbTq83oXRtiVqiN1jeTQDAMFaWWoH7WzAGUbeMKE0KR9I0n+Z4lDxnkNtZQlq66
	 HbEmonUjjCO4L1HdXc5nkTiNwHfmetOPLyPRgsQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/336] ASoC: meson: axg-tdm-interface: manage formatters in trigger
Date: Tue, 14 May 2024 12:14:30 +0200
Message-ID: <20240514101041.098828873@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit f949ed458ad15a00d41b37c745ebadaef171aaae ]

So far, the formatters have been reset/enabled using the .prepare()
callback. This was done in this callback because walking the formatters use
a mutex. A mutex is used because formatter handling require dealing
possibly slow clock operation.

With the support of non-atomic, .trigger() callback may be used which also
allows to properly enable and disable formatters on start but also
pause/resume.

This solve a random shift on TDMIN as well repeated samples on for TDMOUT.

Fixes: d60e4f1e4be5 ("ASoC: meson: add tdm interface driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240426152946.3078805-4-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdm-interface.c | 34 ++++++++++++++++-------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/sound/soc/meson/axg-tdm-interface.c b/sound/soc/meson/axg-tdm-interface.c
index 2cedbce738373..a71790908e178 100644
--- a/sound/soc/meson/axg-tdm-interface.c
+++ b/sound/soc/meson/axg-tdm-interface.c
@@ -349,26 +349,31 @@ static int axg_tdm_iface_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-static int axg_tdm_iface_hw_free(struct snd_pcm_substream *substream,
+static int axg_tdm_iface_trigger(struct snd_pcm_substream *substream,
+				 int cmd,
 				 struct snd_soc_dai *dai)
 {
-	struct axg_tdm_stream *ts = snd_soc_dai_get_dma_data(dai, substream);
+	struct axg_tdm_stream *ts =
+		snd_soc_dai_get_dma_data(dai, substream);
 
-	/* Stop all attached formatters */
-	axg_tdm_stream_stop(ts);
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		axg_tdm_stream_start(ts);
+		break;
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_STOP:
+		axg_tdm_stream_stop(ts);
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
-static int axg_tdm_iface_prepare(struct snd_pcm_substream *substream,
-				 struct snd_soc_dai *dai)
-{
-	struct axg_tdm_stream *ts = snd_soc_dai_get_dma_data(dai, substream);
-
-	/* Force all attached formatters to update */
-	return axg_tdm_stream_reset(ts);
-}
-
 static int axg_tdm_iface_remove_dai(struct snd_soc_dai *dai)
 {
 	int stream;
@@ -412,8 +417,7 @@ static const struct snd_soc_dai_ops axg_tdm_iface_ops = {
 	.set_fmt	= axg_tdm_iface_set_fmt,
 	.startup	= axg_tdm_iface_startup,
 	.hw_params	= axg_tdm_iface_hw_params,
-	.prepare	= axg_tdm_iface_prepare,
-	.hw_free	= axg_tdm_iface_hw_free,
+	.trigger	= axg_tdm_iface_trigger,
 };
 
 /* TDM Backend DAIs */
-- 
2.43.0



