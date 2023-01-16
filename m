Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366B96FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E55C433EF;
	Mon, 16 Jan 2023 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887961;
	bh=bxw1oKcwkRxyvO3XZk6huDZQylbjJgHOQQQsf3rKCLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpGW4hSsQM7dc7J6LePU+jhLGyiBnDwLmOReSZrUhawbuzYkU2mcM/mn6uOz+KmOw
	 JZsO6WIijClujv9cicZH78e/a/EVNEIJCil/GdcQynjfTAQ8AufcTBMO8NT64H3brS
	 HcIe71X82jSxH9556BtKO4qH3001T32pwyMspNOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 347/521] ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()
Date: Mon, 16 Jan 2023 16:50:09 +0100
Message-Id: <20230116154902.661674774@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 3327d721114c109ba0575f86f8fda3b525404054 ]

The node returned by of_parse_phandle() with refcount incremented,
of_node_put() needs be called when finish using it. So add it in the
error path in mt8173_rt5650_rt5514_dev_probe().

Fixes: 0d1d7a664288 ("ASoC: mediatek: Refine mt8173 driver and change config option")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1670234664-24246-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
index cdb394071037..9f8d2a00a1cd 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c
@@ -199,14 +199,16 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 	if (!mt8173_rt5650_rt5514_codecs[0].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	mt8173_rt5650_rt5514_codecs[1].of_node =
 		of_parse_phandle(pdev->dev.of_node, "mediatek,audio-codec", 1);
 	if (!mt8173_rt5650_rt5514_codecs[1].of_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	mt8173_rt5650_rt5514_codec_conf[0].of_node =
 		mt8173_rt5650_rt5514_codecs[1].of_node;
@@ -218,6 +220,7 @@ static int mt8173_rt5650_rt5514_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+out:
 	of_node_put(platform_node);
 	return ret;
 }
-- 
2.35.1



