Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EFEBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7799AC433D2;
	Tue,  7 Mar 2023 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215355;
	bh=dmk8ctA26QGVn98XBKw/tEUazLQl+TOqjm4yW1Ftkpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvHMrnBRuXM+id0l4C/AqKxf24ta/qlFw5vHTi/PBjxvNQmXBqV32IjOaS092l6zq
	 9KLVT4K+a4GIRDCe7ENFIB3ASixB0XNJuMUEAA3mhjJWxsibl8RocErIUsqOljQEai
	 U9XOKhKo0RtGx9C1j0uf7hIkd/PCd2pCyGrSGT4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/567] ASoC: codecs: rx-macro: move clk provider to managed variants
Date: Tue,  7 Mar 2023 17:59:31 +0100
Message-Id: <20230307165916.124837291@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 70a5e96bad592145ba25365689a2d7d8dedb3bd9 ]

move clk provider registration to managed api variants, this should help
with some code tidyup.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220224111718.6264-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e7621434378c ("ASoC: codecs: lpass: fix incorrect mclk rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 3c4f1fb219a44..f3e5755a49a1d 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3479,10 +3479,9 @@ static const struct clk_ops swclk_gate_ops = {
 
 };
 
-static struct clk *rx_macro_register_mclk_output(struct rx_macro *rx)
+static int rx_macro_register_mclk_output(struct rx_macro *rx)
 {
 	struct device *dev = rx->dev;
-	struct device_node *np = dev->of_node;
 	const char *parent_clk_name = NULL;
 	const char *clk_name = "lpass-rx-mclk";
 	struct clk_hw *hw;
@@ -3498,13 +3497,11 @@ static struct clk *rx_macro_register_mclk_output(struct rx_macro *rx)
 	init.num_parents = 1;
 	rx->hw.init = &init;
 	hw = &rx->hw;
-	ret = clk_hw_register(rx->dev, hw);
+	ret = devm_clk_hw_register(rx->dev, hw);
 	if (ret)
-		return ERR_PTR(ret);
-
-	of_clk_add_provider(np, of_clk_src_simple_get, hw->clk);
+		return ret;
 
-	return NULL;
+	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
 static const struct snd_soc_component_driver rx_macro_component_drv = {
@@ -3562,22 +3559,26 @@ static int rx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	rx_macro_register_mclk_output(rx);
+	ret = rx_macro_register_mclk_output(rx);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev, &rx_macro_component_drv,
 					      rx_macro_dai,
 					      ARRAY_SIZE(rx_macro_dai));
 	if (ret)
-		clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
+		goto err;
 
 	return ret;
+err:
+	clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
+	return ret;
 }
 
 static int rx_macro_remove(struct platform_device *pdev)
 {
 	struct rx_macro *rx = dev_get_drvdata(&pdev->dev);
 
-	of_clk_del_provider(pdev->dev.of_node);
 	clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
 	return 0;
 }
-- 
2.39.2



