Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E85BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FA2C433EF;
	Tue,  7 Mar 2023 18:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215368;
	bh=+m9FO2g0m6GrRirooKZpmamPyWhi20OsxPQ738dd7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywdO+BTzxrNtGuQS6nMjV1xTnKfyu8DXOHzZYn2zmQmp/ETqBX1B9ZDvTVYDesjQA
	 RoyTPjw6tfO2x/IbRWVhJS7EylIalXtjo9apZAyn8vKkRKmARfveXPiJvXBsmXXPHF
	 9JiSxePAXsF0ji6WMK6Ven85KuEJ/qof7z6qupN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/567] ASoC: codecs: lpass: fix incorrect mclk rate
Date: Tue,  7 Mar 2023 17:59:35 +0100
Message-Id: <20230307165916.321930444@linuxfoundation.org>
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

[ Upstream commit e7621434378c40b62ef858c14ae6415fb6469a8e ]

For some reason we ended up with incorrect mclk rate which should be
1920000 instead of 96000, So far we were getting lucky as the same clk
is set to 192000 by wsa and va macro. This issue is discovered when there
is no wsa macro active and only rx or tx path is tested.
Fix this by setting correct rate.

Fixes: c39667ddcfc5 ("ASoC: codecs: lpass-tx-macro: add support for lpass tx macro")
Fixes: af3d54b99764 ("ASoC: codecs: lpass-rx-macro: add support for lpass rx macro")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-7-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 4 ++--
 sound/soc/codecs/lpass-tx-macro.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 213ededb6f9ee..72a0db09c7131 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -363,7 +363,7 @@
 #define CDC_RX_DSD1_CFG2			(0x0F8C)
 #define RX_MAX_OFFSET				(0x0F8C)
 
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 #define RX_MACRO_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 |\
 			SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000 |\
@@ -3565,7 +3565,7 @@ static int rx_macro_probe(struct platform_device *pdev)
 
 	/* set MCLK and NPL rates */
 	clk_set_rate(rx->mclk, MCLK_FREQ);
-	clk_set_rate(rx->npl, 2 * MCLK_FREQ);
+	clk_set_rate(rx->npl, MCLK_FREQ);
 
 	ret = clk_prepare_enable(rx->macro);
 	if (ret)
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index d604e2b0109b0..2b7ba78551fab 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -200,7 +200,7 @@
 #define TX_MACRO_AMIC_UNMUTE_DELAY_MS	100
 #define TX_MACRO_DMIC_HPF_DELAY_MS	300
 #define TX_MACRO_AMIC_HPF_DELAY_MS	300
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 enum {
 	TX_MACRO_AIF_INVALID = 0,
@@ -1832,7 +1832,7 @@ static int tx_macro_probe(struct platform_device *pdev)
 
 	/* set MCLK and NPL rates */
 	clk_set_rate(tx->mclk, MCLK_FREQ);
-	clk_set_rate(tx->npl, 2 * MCLK_FREQ);
+	clk_set_rate(tx->npl, MCLK_FREQ);
 
 	ret = clk_prepare_enable(tx->macro);
 	if (ret)
-- 
2.39.2



