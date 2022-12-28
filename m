Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AC31868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE73C433EF;
	Wed, 28 Dec 2022 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242084;
	bh=jEH0DtBZ7SLsx7+/AwXGRtDpeoy4TDVY/gGNFM5ErOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G28CC8ysg/Nw/jRkzrzaoSSB4IFLmOlDlrzPZWFutCVziX7EuabJMy8SJOgnqMwzj
	 Lq+gw7qcpgMkiM41lksxjpaxtlahkQaWSBarNTQymPy9UwcNnCTuaYa/naPVP/PJBk
	 qZ/u0RfY+FtSCdeLUKyELR01HAMTameE12e5M2+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0324/1146] ASoC: codecs: wsa883x: Use proper shutdown GPIO polarity
Date: Wed, 28 Dec 2022 15:31:03 +0100
Message-Id: <20221228144338.959607920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ec5dba73f7ba10797904cf18092d2e6975a22147 ]

The shutdown GPIO is active low (SD_N), but this depends on actual board
layout.  Linux drivers should only care about logical state, where high
(1) means shutdown and low (0) means do not shutdown.

Invert the GPIO to match logical value.

Fixes: 43b8c7dc85a1 ("ASoC: codecs: add wsa883x amplifier support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221110133512.478831-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index c7b10bbfba7e..77a7dd3cf495 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1392,7 +1392,7 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	}
 
 	wsa883x->sd_n = devm_gpiod_get_optional(&pdev->dev, "powerdown",
-						GPIOD_FLAGS_BIT_NONEXCLUSIVE);
+						GPIOD_FLAGS_BIT_NONEXCLUSIVE | GPIOD_OUT_HIGH);
 	if (IS_ERR(wsa883x->sd_n)) {
 		dev_err(&pdev->dev, "Shutdown Control GPIO not found\n");
 		ret = PTR_ERR(wsa883x->sd_n);
@@ -1411,7 +1411,7 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
 	pdev->prop.scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY;
-	gpiod_direction_output(wsa883x->sd_n, 1);
+	gpiod_direction_output(wsa883x->sd_n, 0);
 
 	wsa883x->regmap = devm_regmap_init_sdw(pdev, &wsa883x_regmap_config);
 	if (IS_ERR(wsa883x->regmap)) {
-- 
2.35.1



