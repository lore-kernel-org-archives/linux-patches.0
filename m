Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE781D0B8D;
	Wed,  2 Oct 2024 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877669; cv=none; b=XdKw4AHdPBB49Nef31G3yaiAQ8zrKL7WJwb/jqOHTW5ZVruDjJog71VKILXSFB9/YgxYAyjaSpkdKZqiC0VXQMjs0+NCBjjteHOdyQKqweLdfezOeDdgJUEWB548ChN7jSUYGuykLWSKxPV14xipDHplaXYOxEd18ju7ffEGOf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877669; c=relaxed/simple;
	bh=Z2VPMAz5TP+5Gw6dsZEVV1aMqKjma+n3zzUGX9vEUvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP66FU/jdvaaBPuncNd2nIMh1ieyvht2HUpURIdj1hckGuApIko4QcnHAV4ADxr+SeZO2jMQG7cDKK5dGH+ftog/z2FApSeaFHBbT46owW5x8GcLVUGn+4DhFQ3/Ri2OX/d2yPD/LGDPco6Zg1oqU3jEMYeH/g0fZDuiS3bXQNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dloqfzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dloqfzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9535EC4CEC2;
	Wed,  2 Oct 2024 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877669;
	bh=Z2VPMAz5TP+5Gw6dsZEVV1aMqKjma+n3zzUGX9vEUvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dloqfzAma7UibVAqYyWFVaqvVeRGKiaZDXXBf0f1MvTsGaHvtfoJb/Od1mSWpz0N
	 YNNMI+uEFKoPHH3Ipe9NiDrO7+ojOoesHUTFLEx4Mn2V30B4xH/BZ+d/RVyJIvPSf7
	 TP+Xz5o9TO67f3VrJGOCfk6bJuO4GbRXoZbdBYmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tangbin <tangbin@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 153/634] ASoC: loongson: fix error release
Date: Wed,  2 Oct 2024 14:54:13 +0200
Message-ID: <20241002125817.149255541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: tangbin <tangbin@cmss.chinamobile.com>

[ Upstream commit 97688a9c5b1fd2b826c682cdfa36d411a5c99828 ]

In function loongson_card_parse_of(), when get device_node
'codec' failed, the function of_node_put(codec) should not
be invoked, thus fix error release.

Fixes: d24028606e76 ("ASoC: loongson: Add Loongson ASoC Sound Card Support")
Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
Link: https://patch.msgid.link/20240903090620.6276-1-tangbin@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/loongson/loongson_card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index fae5e9312bf08..2c8dbdba27c5f 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -127,8 +127,8 @@ static int loongson_card_parse_of(struct loongson_card_data *data)
 	codec = of_get_child_by_name(dev->of_node, "codec");
 	if (!codec) {
 		dev_err(dev, "audio-codec property missing or invalid\n");
-		ret = -EINVAL;
-		goto err;
+		of_node_put(cpu);
+		return -EINVAL;
 	}
 
 	for (i = 0; i < card->num_links; i++) {
-- 
2.43.0



