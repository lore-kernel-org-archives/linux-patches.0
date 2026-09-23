Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6223253B340;
	Wed, 23 Sep 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174633; cv=none; b=boPCDKMLvsQTBjx4BMqFSfibdBuBJ6TuPl+gwIjdjlOWNmeD0EqeEMYf4SApAqCXZxiBa0u89GgSuyfhr4Vpra1JIO/8ZTm0YfRLJBZ3YWeRFgyCJ2t+gmAJmb4rcZ805ODqYQxEutmAs/EOJbWungwqOPZ+zbNHbpIMw08YINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174633; c=relaxed/simple;
	bh=7KuT7Zta8hwwvMRcGepiqiWECabebYId+t/014qFjN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9JPdWWY+PzRe1peqrWS78Y8nk1BPalGHPex7Na4V0iz6JSe5wlV2M2YdEPDQzqsyIRStssPV/U5VPA1qMQIWu/xlvI0HMJhN//95s6YSnD/VyQ0x+5eheCvGwzkDD6lWQi7xMZtBhItkM22ug8qVKq0cqs42sxWypiSUxwyuTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6lOSZPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6lOSZPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C9B1F00899;
	Wed, 23 Sep 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174630;
	bh=Yz54uKGUQoAPyxb2DsCUeCFwYAHlM6LO6WZaWUm8Aog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6lOSZPsLQRS6poEnw3/vjOGytI1Q3wvNeJvWcNvQSjDLHnZdAsa2FiHCyYPtIJ/P
	 72XAdBEsqF3tzNQmfqDBiT+3B98ZuyjGeRjdcvo56cES1TOySDO6OgJnUqN4HLMWQh
	 x7iB3zoDdVqZC/Y1g50O0jjnW17NgZnrXXUGqseA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/398] ASoC: sdw_utils: Add codec_conf for every DAI
Date: Wed, 23 Sep 2026 16:04:03 +0200
Message-ID: <20260923140647.814280884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 26ee34d2f5c7fba968fcc2f1fd94110e1c1660db ]

The assumption so far is that all the DAI links for a given audio part
would be on the same device. However, as SDCA implements each audio
function on a separate auxiliary driver this will no longer be true.
This means it is necessary to add additional codec_conf structures to
get the prefix for an audio part to apply to all the auxiliary drivers
that make up that part.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251127163426.2500633-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0b7d55d3a912 ("ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c |  9 ++++++---
 sound/soc/intel/boards/sof_sdw.c        |  9 ++++++---
 sound/soc/sdw_utils/soc_sdw_utils.c     | 19 ++++++++++---------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 09387accd1269..b8a509bbf99a6 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -399,6 +399,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	struct snd_soc_dai_link *dai_links;
 	int num_devs = 0;
 	int num_ends = 0;
+	int num_confs;
 	int num_links;
 	int be_id = 0;
 	int ret;
@@ -409,6 +410,8 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 		return ret;
 	}
 
+	num_confs = num_ends;
+
 	/* One per DAI link, worst case is a DAI link for every endpoint */
 	soc_dais = kcalloc(num_ends, sizeof(*soc_dais), GFP_KERNEL);
 	if (!soc_dais)
@@ -419,7 +422,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	if (!soc_ends)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, soc_dais, soc_ends, &num_devs);
+	ret = asoc_sdw_parse_sdw_endpoints(card, soc_dais, soc_ends, &num_confs);
 	if (ret < 0)
 		return ret;
 
@@ -431,7 +434,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 
 	dev_dbg(dev, "sdw %d, dmic %d", sdw_be_num, dmic_num);
 
-	codec_conf = devm_kcalloc(dev, num_devs, sizeof(*codec_conf), GFP_KERNEL);
+	codec_conf = devm_kcalloc(dev, num_confs, sizeof(*codec_conf), GFP_KERNEL);
 	if (!codec_conf)
 		return -ENOMEM;
 
@@ -442,7 +445,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 		return -ENOMEM;
 
 	card->codec_conf = codec_conf;
-	card->num_configs = num_devs;
+	card->num_configs = num_confs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
 
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index ffa6e2ad73f75..4c2d6a5ede3ff 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1168,6 +1168,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	struct asoc_sdw_dailink *sof_dais;
 	int num_devs = 0;
 	int num_ends = 0;
+	int num_confs;
 	struct snd_soc_dai_link *dai_links;
 	int num_links;
 	int be_id = 0;
@@ -1181,6 +1182,8 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		return ret;
 	}
 
+	num_confs = num_ends;
+
 	/*
 	 * One per DAI link, worst case is a DAI link for every endpoint, also
 	 * add one additional to act as a terminator such that code can iterate
@@ -1197,7 +1200,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		goto err_dai;
 	}
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_dais, sof_ends, &num_devs);
+	ret = asoc_sdw_parse_sdw_endpoints(card, sof_dais, sof_ends, &num_confs);
 	if (ret < 0)
 		goto err_end;
 
@@ -1245,7 +1248,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		sdw_be_num, ssp_num, dmic_num,
 		intel_ctx->hdmi.idisp_codec ? hdmi_num : 0, bt_num);
 
-	codec_conf = devm_kcalloc(dev, num_devs, sizeof(*codec_conf), GFP_KERNEL);
+	codec_conf = devm_kcalloc(dev, num_confs, sizeof(*codec_conf), GFP_KERNEL);
 	if (!codec_conf) {
 		ret = -ENOMEM;
 		goto err_end;
@@ -1260,7 +1263,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	}
 
 	card->codec_conf = codec_conf;
-	card->num_configs = num_devs;
+	card->num_configs = num_confs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
 
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 2c5c370503675..9dac810ccc611 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1387,15 +1387,6 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 
 			ctx->ignore_internal_dmic |= codec_info->ignore_internal_dmic;
 
-			codec_name = asoc_sdw_get_codec_name(dev, codec_info, adr_link, i);
-			if (!codec_name)
-				return -ENOMEM;
-
-			dev_dbg(dev, "Adding prefix %s for %s\n",
-				adr_dev->name_prefix, codec_name);
-
-			soc_end->name_prefix = adr_dev->name_prefix;
-
 			if (codec_info->count_sidecar && codec_info->add_sidecar) {
 				ret = codec_info->count_sidecar(card, &num_dais, num_devs);
 				if (ret)
@@ -1483,6 +1474,16 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 				num_link_dailinks += !!list_empty(&soc_dai->endpoints);
 				list_add_tail(&soc_end->list, &soc_dai->endpoints);
 
+				codec_name = asoc_sdw_get_codec_name(dev, codec_info,
+								     adr_link, i);
+				if (!codec_name)
+					return -ENOMEM;
+
+				dev_dbg(dev, "Adding prefix %s for %s\n",
+					adr_dev->name_prefix, codec_name);
+
+				soc_end->name_prefix = adr_dev->name_prefix;
+
 				soc_end->link_mask = adr_link->mask;
 				soc_end->codec_name = codec_name;
 				soc_end->codec_info = codec_info;
-- 
2.53.0



