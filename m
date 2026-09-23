Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE9418368;
	Wed, 23 Sep 2026 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173300; cv=none; b=W39WnXlP1I7Qyr9eRKnJWOofwUjK/JF+s+KseW2JEASmo3m676h7/DnW/gFPUTHanSXEzp0sA6JB8mFsFqVMW5R1dugTF4//sh2omV8YplkgkRcgJGGGJCx+tLvNmHFBCMgb5KyDUu/IX0Sq5H2FJH9jf0X/WhGbkFF3xXGivRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173300; c=relaxed/simple;
	bh=B/euxaoyNZ9vmyffjVerOhRxF1Lgbg81VEpg7CqoHwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqECEm5atqcRSxoi1YMYUzun9swRxoYCJqnhpCqqrTFysOGFqwDMRKZfPoBUpS/RBGvJaLe3snNLTO/ISLu8iigYvoeNSRW/k/zHPjSRpnXQj1+f8NPu61bW4LxHqa5zy8+8Q56w0iEoipstrejxjLwsminsVOmdjLI3cNTJcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmrv+u0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmrv+u0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49021F000FF;
	Wed, 23 Sep 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173299;
	bh=FAhgnbUrLvldDxy5NSuTg+0cow8RvQUg8Ksy+oOX9h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmrv+u0Q+4A0UkwrOclaDq6Wj/cQ7cuOQn7sUrwIdjhFVu3ljZJAaqDmQ9fQMaazK
	 WjQw6e2IdYiJ9odtV5lsGr5QAMqZ29gRhmn8kYrluYqZEn24/zQBVEHekDxgqih21z
	 PQKKDl/wB76qPRYrZgh3ZYMCvJQCu5OpsDlR0kaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 203/438] ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver
Date: Wed, 23 Sep 2026 16:03:44 +0200
Message-ID: <20260923140650.025009708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 0b7d55d3a91200f2b1ed710f525a944b0a7d6369 ]

num_devs was used both as the endpoint count and as the output for
asoc_sdw_parse_sdw_endpoints(), which overwrites it with the codec
configuration count. Introduce a separate num_confs variable to hold
the codec conf count so the two values remain distinct across
codec_conf allocation and card->num_configs assignment.

Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260910161728.1452808-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 5d0818ca918a0..f58ef8953dbc2 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -286,6 +286,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	int num_devs = 0;
 	int num_ends = 0;
 	int num_aux = 0;
+	int num_confs;
 	int num_links;
 	int be_id = 0;
 	int ret;
@@ -296,6 +297,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		return ret;
 	}
 
+	num_confs = num_ends;
 	/* One per DAI link, worst case is a DAI link for every endpoint */
 	struct asoc_sdw_dailink *sof_dais __free(kfree) =
 		kzalloc_objs(*sof_dais, num_ends);
@@ -312,7 +314,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	if (!sof_aux)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, sof_aux, sof_dais, sof_ends, &num_devs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, sof_aux, sof_dais, sof_ends, &num_confs);
 	if (ret < 0)
 		return ret;
 
@@ -324,7 +326,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 
 	dev_dbg(dev, "sdw %d, dmic %d", sdw_be_num, dmic_num);
 
-	codec_conf = devm_kcalloc(dev, num_devs, sizeof(*codec_conf), GFP_KERNEL);
+	codec_conf = devm_kcalloc(dev, num_confs, sizeof(*codec_conf), GFP_KERNEL);
 	if (!codec_conf)
 		return -ENOMEM;
 
@@ -335,7 +337,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		return -ENOMEM;
 
 	card->codec_conf = codec_conf;
-	card->num_configs = num_devs;
+	card->num_configs = num_confs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
 	card->aux_dev = sof_aux;
-- 
2.53.0



