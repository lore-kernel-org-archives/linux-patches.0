Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A93ED3B2;
	Tue, 21 Jul 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649377; cv=none; b=fBntQIwlJigET5lXbtTa1HbeL/kOw0RXH24fHN7tVybTvyLlmYgaqMQQbAloAgL19LYAG/yRsyy4wS+Jj1EdQlTcgDKwO4hRSmagh/9aFIo0czdP/WqYXXDZ2nvdjqL417qNBYAywD2VyI+DZZwJGqWtGRPL+5v0Am6jAuPdXAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649377; c=relaxed/simple;
	bh=TsgrqgdpiU9rYiWZ3FqjXno4cyUxeerMlvG3RfWVjow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXKjIiT2mHkRbOxSRCwVZeEY1O9EKJZ5Bw7ANnAjkb35M0OZFNog6sT7H/L/qmF8s8So6ROh8qZdxhTFRi9msaX41f/re68cDW9KDi1RYT+Fjg/2i1xGbsvHlgQJigmdy9rYmq2HLwaoh1LNzRtzL/k8d7crTF8XPwwr2HkOou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAhCPFZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAhCPFZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4441F000E9;
	Tue, 21 Jul 2026 15:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649376;
	bh=9I/Bw+gvFBYqT4SPYuBz1rlYYv0ZAQi/1V7hhLAeT5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAhCPFZcIXfvDTJlGDqsBNQ8MauzA2WazbHs2Uj+Q55BkxLcIxZ7zbQ32JqxKp8md
	 1qjaotjWLs+ibbb9UsZgEx2erHnoY2cZQK63uOJDflKwmn/n3LxP4oFmy3l/MQH7X4
	 JZpv8AJ5/zTAHTwiMMxSfa1GHvM8IUD4iKqYHHPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0556/2077] ASoC: amd: acp-sdw-legacy: Bound DAI link iteration
Date: Tue, 21 Jul 2026 17:03:49 +0200
Message-ID: <20260721152605.930049171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit d49ecdf327cc91062d2f80996a163cf65fda1e60 ]

create_sdw_dailinks() walks soc_dais until it finds an entry with
initialised cleared, but soc_dais is allocated with exactly num_ends
entries. If all entries are initialised, the loop reads past the end of
the array.

This was reported by KASAN:

  BUG: KASAN: slab-out-of-bounds in mc_probe+0x26b3/0x2774 [snd_acp_sdw_legacy_mach]
  Read of size 1

Pass the allocated entry count to create_sdw_dailinks() and stop before
reading past the array.

Fixes: 2981d9b0789c ("ASoC: amd: acp: add soundwire machine driver for legacy stack")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://patch.msgid.link/20260528082110.915549-1-aaron.ma@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 09b475c83c4966..e8b6819cc4b459 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -303,13 +303,14 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 static int create_sdw_dailinks(struct snd_soc_card *card,
 			       struct snd_soc_dai_link **dai_links, int *be_id,
-			       struct asoc_sdw_dailink *soc_dais,
+			       struct asoc_sdw_dailink *soc_dais, int num_dais,
 			       struct snd_soc_codec_conf **codec_conf)
 {
 	struct device *dev = card->dev;
 	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	struct amd_mc_ctx *amd_ctx = (struct amd_mc_ctx *)ctx->private;
 	struct snd_soc_dai_link_component *sdw_platform_component;
+	int i;
 	int ret;
 
 	sdw_platform_component = devm_kzalloc(dev, sizeof(struct snd_soc_dai_link_component),
@@ -329,7 +330,7 @@ static int create_sdw_dailinks(struct snd_soc_card *card,
 	}
 
 	/* generate DAI links by each sdw link */
-	while (soc_dais->initialised) {
+	for (i = 0; i < num_dais && soc_dais->initialised; i++) {
 		int current_be_id = 0;
 
 		ret = create_sdw_dailink(card, soc_dais, dai_links,
@@ -463,7 +464,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	/* SDW */
 	if (sdw_be_num) {
 		ret = create_sdw_dailinks(card, &dai_links, &be_id,
-					  soc_dais, &codec_conf);
+					  soc_dais, num_ends, &codec_conf);
 		if (ret)
 			return ret;
 	}
-- 
2.53.0



