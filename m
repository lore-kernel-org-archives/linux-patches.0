Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CF88F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044DAC433C7;
	Sun, 16 Jul 2023 20:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537888;
	bh=96v5UnXev6154ikau+g+2DZOKnNm0Z2/OeNFYiDq3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b40AYm59iCtY7ePIqqawKhJ1dH3gyKqWAxUj3tFxcUxkyARtJFF282vC6zlOkZPVt
	 HLkDV9kM5TIwO+DvaOyc/le/dcahBbMBISRran2uInjVm0YZyDPpK1hv+w35txnv5e
	 o8y6eGYlTWz0iT4omQpL6UORBbu0xSWZTpcWZpkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 257/800] ASoC: Intel: sof_sdw: start set codec init function with an adr index
Date: Sun, 16 Jul 2023 21:41:50 +0200
Message-ID: <20230716194955.066375958@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit f0c8d83ab1a3532ebeb1a89acb649be01657aed8 ]

Currently, set_codec_init_func always start with link->adr_d[0] because
we assumed all adr_d on the same link are the same devices. The
assumption is no longer valid when different devices on the same sdw link
are supported.

Fixes: c8db7b50128b ("ASoC: Intel: sof_sdw: support different devices on the same sdw link")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com
Link: https://lore.kernel.org/r/20230512173305.65399-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index a33b7678bc3b8..5fa204897a52b 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -902,17 +902,20 @@ static int create_codec_dai_name(struct device *dev,
 static int set_codec_init_func(struct snd_soc_card *card,
 			       const struct snd_soc_acpi_link_adr *link,
 			       struct snd_soc_dai_link *dai_links,
-			       bool playback, int group_id)
+			       bool playback, int group_id, int adr_index)
 {
-	int i;
+	int i = adr_index;
 
 	do {
 		/*
 		 * Initialize the codec. If codec is part of an aggregated
 		 * group (group_id>0), initialize all codecs belonging to
 		 * same group.
+		 * The first link should start with link->adr_d[adr_index]
+		 * because that is the device that we want to initialize and
+		 * we should end immediately if it is not aggregated (group_id=0)
 		 */
-		for (i = 0; i < link->num_adr; i++) {
+		for ( ; i < link->num_adr; i++) {
 			int codec_index;
 
 			codec_index = find_codec_info_part(link->adr_d[i].adr);
@@ -928,9 +931,12 @@ static int set_codec_init_func(struct snd_soc_card *card,
 						dai_links,
 						&codec_info_list[codec_index],
 						playback);
+			if (!group_id)
+				return 0;
 		}
+		i = 0;
 		link++;
-	} while (link->mask && group_id);
+	} while (link->mask);
 
 	return 0;
 }
@@ -1180,7 +1186,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		dai_links[*link_index].nonatomic = true;
 
 		ret = set_codec_init_func(card, link, dai_links + (*link_index)++,
-					  playback, group_id);
+					  playback, group_id, adr_index);
 		if (ret < 0) {
 			dev_err(dev, "failed to init codec %d", codec_index);
 			return ret;
-- 
2.39.2



