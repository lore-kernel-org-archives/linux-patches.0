Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2075258CF7;
	Tue,  8 Jul 2025 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993841; cv=none; b=OCtWArV1ai9i3AsLY9h/EKm1LVCaU5YLtL7Yu/8zb8sec/FRSbcbEc3U1h4mGCPu7Buoaxn0zph5V/tnTCYTQlrbcWisgGsZkacaK07uFPlXRpdci7YalkAoA5aD/AaVpqFGHBgDPthtum4RhdImpewIIVW+C6PO9qtNbRTB89c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993841; c=relaxed/simple;
	bh=rtQ1wFpOvGXGtmt5//L473Y877xaMgzS9RZHrUOY3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIqcNKKY1EfndlL6Uj6gMKgdk1ZceSr67DDUxUtHFqi107jLn1vHo6tl0A9RKtC4o5jva3W0MuaIx1eF9P/QjDYOWaC/x8KSQViFa6+8oWK//ZPVcntZ3udaLRJSm/GhN5ynoB9M3AijYAtCHi2O9a5WwcHQrYnzEd2bQfemDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq0aeucC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq0aeucC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77DC4CEED;
	Tue,  8 Jul 2025 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993840;
	bh=rtQ1wFpOvGXGtmt5//L473Y877xaMgzS9RZHrUOY3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jq0aeucCF6kBbPMvLFhzJY/4H+nIv3S/Zgv6nT7t3YIU2F+Lcc2q2wwxwCZ2zIcjU
	 PqMESDDbBnbQSuXzYr6LDyMgbqD0FknWf2kMxRYI2up/tReExCWRdc3NYZj3TnniXj
	 WKHhAEv2pi9VrccAFyPPaLPddm4NaPFA+s8asgfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/160] ASoC: codecs: wcd9335: Handle nicer probe deferral and simplify with dev_err_probe()
Date: Tue,  8 Jul 2025 18:21:12 +0200
Message-ID: <20250708162232.500413467@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 4a03b5dbad466c902d522f3405daa4e5d80578c5 ]

wcd9335_parse_dt() function is called only from probe(), so printing
errors on resource acquisition is discouraged, because it can pollute
dmesg.  Use dev_err_probe() to fix this and also make the code a bit
simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://msgid.link/r/20240612-asoc-wcd9xxx-wide-cleanups-v1-4-0d15885b2a06@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9079db287fc3 ("ASoC: codecs: wcd9335: Fix missing free of regulator supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 075ed20e9fad8..dc4ce2c3f2188 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5028,22 +5028,16 @@ static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
 	int ret;
 
 	wcd->reset_gpio = of_get_named_gpio(np,	"reset-gpios", 0);
-	if (wcd->reset_gpio < 0) {
-		dev_err(dev, "Reset GPIO missing from DT\n");
-		return wcd->reset_gpio;
-	}
+	if (wcd->reset_gpio < 0)
+		return dev_err_probe(dev, wcd->reset_gpio, "Reset GPIO missing from DT\n");
 
 	wcd->mclk = devm_clk_get(dev, "mclk");
-	if (IS_ERR(wcd->mclk)) {
-		dev_err(dev, "mclk not found\n");
-		return PTR_ERR(wcd->mclk);
-	}
+	if (IS_ERR(wcd->mclk))
+		return dev_err_probe(dev, PTR_ERR(wcd->mclk), "mclk not found\n");
 
 	wcd->native_clk = devm_clk_get(dev, "slimbus");
-	if (IS_ERR(wcd->native_clk)) {
-		dev_err(dev, "slimbus clock not found\n");
-		return PTR_ERR(wcd->native_clk);
-	}
+	if (IS_ERR(wcd->native_clk))
+		return dev_err_probe(dev, PTR_ERR(wcd->native_clk), "slimbus clock not found\n");
 
 	wcd->supplies[0].supply = "vdd-buck";
 	wcd->supplies[1].supply = "vdd-buck-sido";
@@ -5052,10 +5046,8 @@ static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
 	wcd->supplies[4].supply = "vdd-io";
 
 	ret = regulator_bulk_get(dev, WCD9335_MAX_SUPPLY, wcd->supplies);
-	if (ret) {
-		dev_err(dev, "Failed to get supplies: err = %d\n", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to get supplies\n");
 
 	return 0;
 }
@@ -5158,10 +5150,8 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 
 	wcd->dev = dev;
 	ret = wcd9335_parse_dt(wcd);
-	if (ret) {
-		dev_err(dev, "Error parsing DT: %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	ret = wcd9335_power_on_reset(wcd);
 	if (ret)
-- 
2.39.5



