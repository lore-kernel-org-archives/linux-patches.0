Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C322AE7A;
	Mon, 18 Aug 2025 13:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525356; cv=none; b=UmGIXfllUy2meB2/2Z4kxxw3F6R/9dqY/gDdg0rg4k4ugKUN8XkgjDQcqAWcPaVJlCgbfd/256EOXZZCCjGAJdqXIzUhkoQ4Kh6hGhPRwO3alDW+Fqwc9KNuaVcXd56cJHDdNkSBpWzsG4/wF+tlQIi3zezTkGVSfQQdolY4Yz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525356; c=relaxed/simple;
	bh=7mV94fo5usNWPJqpAIDWlZgVbfqK5Lf96aQ5M51xiOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx2ncqi2la8mSlkElhvypEZEAWiKrK/ys93o+4ms7wkPY+Yf0+c1tUsCZNnNnySmfVl9MKkv2slSeeQ8xMFUbpD7NY2ZgYl533JZfPIpkaoIqyOMx9DiJn+7GzxfhmMYNrWFZ07xZ5SlKGL/jTlNv9IXpTIZqx3ghMcaCHDkg30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5wHWeUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5wHWeUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBB9C4CEEB;
	Mon, 18 Aug 2025 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525356;
	bh=7mV94fo5usNWPJqpAIDWlZgVbfqK5Lf96aQ5M51xiOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5wHWeUYWEbkFzA7ozGLkF84Hqk4xFvkkEIETWtEau4PoMvFJguUJpnsvI5QRqHyU
	 b2+xBORmLN8SHz8vgE9RyLv0IEbyuhm7xyi2YBGBew1KLilyyEtrtqpG5bKRuOKSNV
	 0KqUs0PX+WPfDtQoeCGhG3EI3gyR6TUF/MwUJiK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srini@kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 204/570] ASoC: qcom: use drvdata instead of component to keep id
Date: Mon, 18 Aug 2025 14:43:11 +0200
Message-ID: <20250818124513.668322557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srini@kernel.org>

[ Upstream commit 8167f4f42572818fa8153be2b03e4c2120846603 ]

Qcom lpass is using component->id to keep DAI ID (A).

(S)	static int lpass_platform_pcmops_open(
				sruct snd_soc_component *component,
				struct snd_pcm_substream *substream)
	{			                          ^^^^^^^^^(B0)
		...
(B1)		struct snd_soc_pcm_runtime *soc_runtime = snd_soc_substream_to_rtd(substream);
(B2)		struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(soc_runtime, 0);
		...
(B3)		unsigned int dai_id = cpu_dai->driver->id;

(A)		component->id = dai_id;
		...
	}

This driver can get dai_id from substream (B0 - B3).
In this driver, below functions get dai_id from component->id (A).

(X)	lpass_platform_pcmops_suspend()
(Y)	lpass_platform_pcmops_resume()
(Z)	lpass_platform_copy()

Here, (Z) can get it from substream (B0 - B3), don't need to use
component->id (A). On suspend/resume (X)(Y), dai_id can only be obtained
from component->id (A), because there is no substream (B0) in function
parameter.

But, component->id (A) itself should not be used for such purpose.
It is intilialized at snd_soc_component_initialize(), and parsed its ID
(= component->id) from device name (a).

	int snd_soc_component_initialize(...)
	{
		...
		if (!component->name) {
(a)			component->name = fmt_single_name(dev, &component->id);
			...                                     ^^^^^^^^^^^^^
		}
		...
	}

Unfortunately, current code is broken to start with.

There are many regmaps that the driver cares about, however its only
managing one (either dp or i2s) in component suspend/resume path.

I2S regmap is mandatory however other regmaps are setup based on flags
like "hdmi_port_enable" and "codec_dma_enable".

Correct thing for suspend/resume path to handle is by checking these
flags, instead of using component->id.

Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Suggested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87a56ouuob.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-platform.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 9946f12254b3..b456e096f138 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -202,7 +202,6 @@ static int lpass_platform_pcmops_open(struct snd_soc_component *component,
 	struct regmap *map;
 	unsigned int dai_id = cpu_dai->driver->id;
 
-	component->id = dai_id;
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -1190,13 +1189,14 @@ static int lpass_platform_pcmops_suspend(struct snd_soc_component *component)
 {
 	struct lpass_data *drvdata = snd_soc_component_get_drvdata(component);
 	struct regmap *map;
-	unsigned int dai_id = component->id;
 
-	if (dai_id == LPASS_DP_RX)
+	if (drvdata->hdmi_port_enable) {
 		map = drvdata->hdmiif_map;
-	else
-		map = drvdata->lpaif_map;
+		regcache_cache_only(map, true);
+		regcache_mark_dirty(map);
+	}
 
+	map = drvdata->lpaif_map;
 	regcache_cache_only(map, true);
 	regcache_mark_dirty(map);
 
@@ -1207,14 +1207,19 @@ static int lpass_platform_pcmops_resume(struct snd_soc_component *component)
 {
 	struct lpass_data *drvdata = snd_soc_component_get_drvdata(component);
 	struct regmap *map;
-	unsigned int dai_id = component->id;
+	int ret;
 
-	if (dai_id == LPASS_DP_RX)
+	if (drvdata->hdmi_port_enable) {
 		map = drvdata->hdmiif_map;
-	else
-		map = drvdata->lpaif_map;
+		regcache_cache_only(map, false);
+		ret = regcache_sync(map);
+		if (ret)
+			return ret;
+	}
 
+	map = drvdata->lpaif_map;
 	regcache_cache_only(map, false);
+
 	return regcache_sync(map);
 }
 
@@ -1224,7 +1229,9 @@ static int lpass_platform_copy(struct snd_soc_component *component,
 			       unsigned long bytes)
 {
 	struct snd_pcm_runtime *rt = substream->runtime;
-	unsigned int dai_id = component->id;
+	struct snd_soc_pcm_runtime *soc_runtime = snd_soc_substream_to_rtd(substream);
+	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(soc_runtime, 0);
+	unsigned int dai_id = cpu_dai->driver->id;
 	int ret = 0;
 
 	void __iomem *dma_buf = (void __iomem *) (rt->dma_area + pos +
-- 
2.39.5



