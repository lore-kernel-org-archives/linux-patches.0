Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE702031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ud8h24Xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDAC433C8;
	Tue, 31 Oct 2023 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771806;
	bh=R3sdS7W0ZifFc3WbzqmXi/msWWGOoBXpkr71S7wPD2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ud8h24XtLRZY0Sl/qyFldEazROixfhL1+Ho1SvDQxmHy0O6YCVQzMyzC7YElBrdbE
	 2tt+16yYv1AF8Ighf3pIJ0gz5axrbWWfkMNqdNg0+gMKAtQDrOTs0/4koy4VLeADba
	 tyZ/j0OaWMSKlegBy+IOPiDzn0GwAtnoInrrS0Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/86] ASoC: codecs: wcd938x: Simplify with dev_err_probe
Date: Tue, 31 Oct 2023 18:00:31 +0100
Message-ID: <20231031165918.807473528@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 60ba2fda5280528e70fa26b44e36d1530f6d1d7e ]

Replace dev_err() in probe() path with dev_err_probe() to:
1. Make code a bit simpler and easier to read,
2. Do not print messages on deferred probe.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230418074630.8681-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 69a026a2357e ("ASoC: codecs: wcd938x: fix regulator leaks on probe errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 73d7c92e87242..f0aa44198f4c5 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -3302,18 +3302,15 @@ static int wcd938x_populate_dt_data(struct wcd938x_priv *wcd938x, struct device
 	int ret;
 
 	wcd938x->reset_gpio = of_get_named_gpio(dev->of_node, "reset-gpios", 0);
-	if (wcd938x->reset_gpio < 0) {
-		dev_err(dev, "Failed to get reset gpio: err = %d\n",
-			wcd938x->reset_gpio);
-		return wcd938x->reset_gpio;
-	}
+	if (wcd938x->reset_gpio < 0)
+		return dev_err_probe(dev, wcd938x->reset_gpio,
+				     "Failed to get reset gpio\n");
 
 	wcd938x->us_euro_gpio = devm_gpiod_get_optional(dev, "us-euro",
 						GPIOD_OUT_LOW);
-	if (IS_ERR(wcd938x->us_euro_gpio)) {
-		dev_err(dev, "us-euro swap Control GPIO not found\n");
-		return PTR_ERR(wcd938x->us_euro_gpio);
-	}
+	if (IS_ERR(wcd938x->us_euro_gpio))
+		return dev_err_probe(dev, PTR_ERR(wcd938x->us_euro_gpio),
+				     "us-euro swap Control GPIO not found\n");
 
 	cfg->swap_gnd_mic = wcd938x_swap_gnd_mic;
 
@@ -3323,16 +3320,12 @@ static int wcd938x_populate_dt_data(struct wcd938x_priv *wcd938x, struct device
 	wcd938x->supplies[3].supply = "vdd-mic-bias";
 
 	ret = regulator_bulk_get(dev, WCD938X_MAX_SUPPLY, wcd938x->supplies);
-	if (ret) {
-		dev_err(dev, "Failed to get supplies: err = %d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to get supplies\n");
 
 	ret = regulator_bulk_enable(WCD938X_MAX_SUPPLY, wcd938x->supplies);
-	if (ret) {
-		dev_err(dev, "Failed to enable supplies: err = %d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to enable supplies\n");
 
 	wcd938x_dt_parse_micbias_info(dev, wcd938x);
 
-- 
2.42.0



