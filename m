Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED12FBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B14C433EF;
	Tue,  7 Mar 2023 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215358;
	bh=F5KvaQX4ilsiGqGDHP6QMCOgZQpYR9z5RaeFL1m+nBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCh+8nw3nfcbq3oyq0THMTTHsXWE4j9ulUQFdL1/fF4v655zLhmdfucRyk/ruMnhv
	 4aMS7KDl5hUJ/xZ+eYIbrqZPit6YD6LVJygFm2XjAZMLoL6Jg7kzBdGDX0g8OQUUad
	 btpMQyjMrcM/5YfISZiN4sVc2sKHhBBo948/M4hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/567] ASoC: codecs: tx-macro: move clk provider to managed variants
Date: Tue,  7 Mar 2023 17:59:32 +0100
Message-Id: <20230307165916.173280807@linuxfoundation.org>
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

[ Upstream commit db8665a3e904f579840417f9414415c4dd54ac84 ]

move clk provider registration to managed api variants, this should help
with some code tidyup.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220224111718.6264-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e7621434378c ("ASoC: codecs: lpass: fix incorrect mclk rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 8d1126802ddfa..4192f91612e16 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1745,10 +1745,9 @@ static const struct clk_ops swclk_gate_ops = {
 
 };
 
-static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
+static int tx_macro_register_mclk_output(struct tx_macro *tx)
 {
 	struct device *dev = tx->dev;
-	struct device_node *np = dev->of_node;
 	const char *parent_clk_name = NULL;
 	const char *clk_name = "lpass-tx-mclk";
 	struct clk_hw *hw;
@@ -1764,13 +1763,11 @@ static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
 	init.num_parents = 1;
 	tx->hw.init = &init;
 	hw = &tx->hw;
-	ret = clk_hw_register(tx->dev, hw);
+	ret = devm_clk_hw_register(dev, hw);
 	if (ret)
-		return ERR_PTR(ret);
-
-	of_clk_add_provider(np, of_clk_src_simple_get, hw->clk);
+		return ret;
 
-	return NULL;
+	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
@@ -1828,7 +1825,9 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	tx_macro_register_mclk_output(tx);
+	ret = tx_macro_register_mclk_output(tx);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
@@ -1846,8 +1845,6 @@ static int tx_macro_remove(struct platform_device *pdev)
 {
 	struct tx_macro *tx = dev_get_drvdata(&pdev->dev);
 
-	of_clk_del_provider(pdev->dev.of_node);
-
 	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
 
 	return 0;
-- 
2.39.2



