Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286181875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4CDC433D2;
	Wed, 28 Dec 2022 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243182;
	bh=7MuFL4O8KP8oYqaGjW6bWPPRmqJvZHFqGFfzm8wktPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyDouBnQNq2UkhR9WY2+Ls3/nJhlgTeAjxxMEDAUNBvlo8v4N/EwgRTR1D8SP8//r
	 BBkHi2cD8O4xyiT8vgtcfpzCqJSFp3HF2HIe3VBUX3ZtsfstXMlyS4lkXm4yYu7+r8
	 e5rUdMhniSUIQukHa4iNqCG/auT1wikg0U9CxDRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 692/731] ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max98357_dev_probe()
Date: Wed, 28 Dec 2022 15:43:19 +0100
Message-Id: <20221228144316.522834684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 38eef3be38ab895959c442702864212cc3beb96c ]

The node returned by of_parse_phandle() with refcount incremented,
of_node_put() needs be called when finish using it. So add it in the
error path in mt8183_mt6358_ts3a227_max98357_dev_probe().

Fixes: 11c0269017b2 ("ASoC: Mediatek: MT8183: Add machine driver with TS3A227")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Link: https://lore.kernel.org/r/1670234188-23596-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
index a56c1e87d564..4dab1ee69ec0 100644
--- a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
@@ -647,8 +647,10 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 	}
 
 	card = (struct snd_soc_card *)of_device_get_match_data(&pdev->dev);
-	if (!card)
+	if (!card) {
+		of_node_put(platform_node);
 		return -EINVAL;
+	}
 	card->dev = &pdev->dev;
 
 	ec_codec = of_parse_phandle(pdev->dev.of_node, "mediatek,ec-codec", 0);
@@ -737,8 +739,10 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	snd_soc_card_set_drvdata(card, priv);
 
@@ -746,7 +750,8 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->pinctrl)) {
 		dev_err(&pdev->dev, "%s devm_pinctrl_get failed\n",
 			__func__);
-		return PTR_ERR(priv->pinctrl);
+		ret = PTR_ERR(priv->pinctrl);
+		goto out;
 	}
 
 	for (i = 0; i < PIN_STATE_MAX; i++) {
@@ -779,6 +784,7 @@ mt8183_mt6358_ts3a227_max98357_dev_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 
+out:
 	of_node_put(platform_node);
 	of_node_put(ec_codec);
 	of_node_put(hdmi_codec);
-- 
2.35.1



