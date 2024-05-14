Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887A154903;
	Tue, 14 May 2024 11:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684638; cv=none; b=E4HwFEhu2sJkWD0/zyWagaIfJsHqzQQH6+NMZ4ifT6sXsjStzuWn8XoJ1ZcaZtYdNzVbYG+7lb6tTzqjM6PFGZBISuiU8G0E7e0WY+1ofCb5SwKOQLGg1qUmeSILugdBjgDr5SFb1Q+JdJC3EGSdmgdZJBfANjqfoEtih2UM+BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684638; c=relaxed/simple;
	bh=w943OfC6go48wRb8h+A9Vlq7fnB3tAAVXKCATcMe7Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JphRBlZqVxrdt5jF6S+lALLRa+KN/WqZrMKkYggzqrTwEwClerbkXIVXAvISqsHxx1FY/cxJW3ZU+tdn2wkNE43Qn+1BUPS8h+xFzFtknO5/NEJCQrVdN44Iy+Og7eMusezBnQ9MEdjsdtK2QqiUgdBrwzmcsje+/AjF9JE6Dz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erCkFVAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erCkFVAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91602C2BD10;
	Tue, 14 May 2024 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684638;
	bh=w943OfC6go48wRb8h+A9Vlq7fnB3tAAVXKCATcMe7Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erCkFVAVvReG+olFVO7a6ZzNz/Jyy8JCtQk9Aa8le5EQ2o7CTCwJqf+GsVXIDaLJ7
	 TGZvil1laBJTShSgrN6/MGxUVedGRZD9qxg9mNNK4Ui3tNMOrNycF31yl4c1kyirje
	 lz7phrdfJO2/cTR6/jsuYILa0ovncZOVvDu1/u/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/301] ASoC: meson: axg-tdm-interface: manage formatters in trigger
Date: Tue, 14 May 2024 12:15:39 +0200
Message-ID: <20240514101034.810204516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



