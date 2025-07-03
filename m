Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D82D9492;
	Thu,  3 Jul 2025 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555551; cv=none; b=prsXnt4vk1VqvheMCK79yshd8ZamBrlnBsWa4nHcE1Lyk2TqfGjYCAvNYXbPXnNjsZ8SGdnG/9IYRJW98Et5Rt7UADm46WDx2ArXnOYNbkufXIijGYGjdPIhGokYL44R/t90PNZPCDCu2n6xThJ6sjQGflDwZOr+g8IBtQvDrpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555551; c=relaxed/simple;
	bh=cX0KSZyTcOiRLCEYgicyzgv2AflSElmUOcBo4hDELP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5/V33q5cGIJjAQ4wdUW69ZwSSEKTikRkyaZDBw+LfOYrrTUC1Ic4k0rhDLsfepXNPl9AwWtiRSMUMszmjT2WG22E01JPRtxGFQ0W0oIVQyzZSx928mVa2TWN10jXvctJNSK4e0kj2az5S6twh+JmsrCR5Yq+Dw0k2pNfFpO20E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0cBZfjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0cBZfjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E45C4CEE3;
	Thu,  3 Jul 2025 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555551;
	bh=cX0KSZyTcOiRLCEYgicyzgv2AflSElmUOcBo4hDELP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0cBZfjK7J9gHNkP5p4x5zyaBLfvIgtLEKUXn3y83VnzwSoqkA0FGHxf3iIFpbUbb
	 5UB5HvbkJMpE2jgZR6ZXjk7HEqE/jRz3ekXKmIR3cQn3GN5ZGbkZ9fo4PBUeb7MKu9
	 YcLpPFnrZ2Mm7kEiJOg4Wp0IbmMeuLkNsNhIqQYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/139] ASoC: codecs: wcd9335: Handle nicer probe deferral and simplify with dev_err_probe()
Date: Thu,  3 Jul 2025 16:41:52 +0200
Message-ID: <20250703143943.088145209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a05b553e6472f..6e172be34ac91 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5036,22 +5036,16 @@ static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
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
@@ -5060,10 +5054,8 @@ static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
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
@@ -5163,10 +5155,8 @@ static int wcd9335_slim_probe(struct slim_device *slim)
 
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



