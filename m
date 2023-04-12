Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356E62F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAA6C433EF;
	Wed, 12 Apr 2023 08:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289216;
	bh=KPtMdFvcLXeqApTHAa/m2nsp4q+5zyw3rFRDHD7Ep6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkZCXyoeeJQxoIuNWUloq4pFcQ/8tscc6pPIaZzI0BhRWuus/sDEJajCdxWb5pmFW
	 n1EsQBGs7qEVl89QAn4LmA15gtI4gNyks5HdY24slMrbD0U8MoTLiZXldOACdIzE4x
	 Qhn8l9MAaGlTurIyz7pde26y4kHdisDb7yxaCc7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 015/173] ASoC: codecs: lpass: fix the order or clks turn off during suspend
Date: Wed, 12 Apr 2023 10:32:21 +0200
Message-Id: <20230412082838.719057987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

[ Upstream commit a4a3203426f4b67535d6442ddc5dca8878a0678f ]

The order in which clocks are stopped matters as some of the clock
like NPL are derived from MCLK.

Without this patch, Dragonboard RB5 DSP would crash with below error:
 qcom_q6v5_pas 17300000.remoteproc: fatal error received:
 ABT_dal.c:278:ABTimeout: AHB Bus hang is detected,
 Number of bus hang detected := 2 , addr0 = 0x3370000 , addr1 = 0x0!!!

Turn off  fsgen first, followed by npl and then finally mclk, which is exactly
the opposite order of enable sequence.

Fixes: 1dc3459009c3 ("ASoC: codecs: lpass: register mclk after runtime pm")
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Link: https://lore.kernel.org/r/20230323110125.23790-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-tx-macro.c  | 4 ++--
 sound/soc/codecs/lpass-wsa-macro.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 8621cfabcf5b6..1639f3b66facb 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3667,9 +3667,9 @@ static int __maybe_unused rx_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(rx->regmap, true);
 	regcache_mark_dirty(rx->regmap);
 
-	clk_disable_unprepare(rx->mclk);
-	clk_disable_unprepare(rx->npl);
 	clk_disable_unprepare(rx->fsgen);
+	clk_disable_unprepare(rx->npl);
+	clk_disable_unprepare(rx->mclk);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 8facdb922f076..9f33289ce2174 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2093,9 +2093,9 @@ static int __maybe_unused tx_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(tx->regmap, true);
 	regcache_mark_dirty(tx->regmap);
 
-	clk_disable_unprepare(tx->mclk);
-	clk_disable_unprepare(tx->npl);
 	clk_disable_unprepare(tx->fsgen);
+	clk_disable_unprepare(tx->npl);
+	clk_disable_unprepare(tx->mclk);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index c0b86d69c72e3..01149b20b4c93 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2504,9 +2504,9 @@ static int __maybe_unused wsa_macro_runtime_suspend(struct device *dev)
 	regcache_cache_only(wsa->regmap, true);
 	regcache_mark_dirty(wsa->regmap);
 
-	clk_disable_unprepare(wsa->mclk);
-	clk_disable_unprepare(wsa->npl);
 	clk_disable_unprepare(wsa->fsgen);
+	clk_disable_unprepare(wsa->npl);
+	clk_disable_unprepare(wsa->mclk);
 
 	return 0;
 }
-- 
2.39.2



