Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FB52F2708;
	Thu,  3 Jul 2025 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555559; cv=none; b=WB4aJYtxFlQt42MPoyMtFDSlz6rSRDZOnNs7gS2WM+zcfcKSDuNN4NEWp40MXLEN/NZi0B9xEH3bTp0ZoEIxzA6aAm+vmisqY6VbOzgJJ2x3dSUaSWH21Pq3UYd1rQwfi0+8RUA4fgkgCQSylRfF8sxjaztZ1tAl/ihDTsYkvTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555559; c=relaxed/simple;
	bh=sqM8OWnDokIZpEqLo/O+YYBIACoXQtWkqvNXf14rPKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmcNfiWPWZFpxirmiwtMjLNizx9ouqax4JzQbrjn5EzquCEZtkhA9+8nGpo2VEliSx2jkGcj5zyz/ugpQrLABNMNbZgPVBNrm3NUb8bkDeOydOuzUPsxSeCASr2+F08/YfIbk1B5m0dAQODJCa14o0siY12dq1qs7ZzofbzO+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgJTYC+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgJTYC+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D04C4CEE3;
	Thu,  3 Jul 2025 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555557;
	bh=sqM8OWnDokIZpEqLo/O+YYBIACoXQtWkqvNXf14rPKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgJTYC+sUdGwrnlj1btb/nAEdKI5fMdciiXYI7T1R7xmTpExQL+tn5fuk4Y3t5TI3
	 o9LZxjLZUHT/3PEVHUMvM6Wjr2uVyjjHTz9Q5GZciXnrwoH0rw1i4PiDzKidtiyqZQ
	 w95geEFRNEwRQ3/3R7B0+tDH3sPPorJNegbqSACU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/139] ASoC: codecs: wcd9335: Fix missing free of regulator supplies
Date: Thu,  3 Jul 2025 16:41:54 +0200
Message-ID: <20250703143943.162949379@linuxfoundation.org>
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

[ Upstream commit 9079db287fc3e38e040b0edeb0a25770bb679c8e ]

Driver gets and enables all regulator supplies in probe path
(wcd9335_parse_dt() and wcd9335_power_on_reset()), but does not cleanup
in final error paths and in unbind (missing remove() callback).  This
leads to leaked memory and unbalanced regulator enable count during
probe errors or unbind.

Fix this by converting entire code into devm_regulator_bulk_get_enable()
which also greatly simplifies the code.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250526-b4-b4-asoc-wcd9395-vdd-px-fixes-v1-1-0b8a2993b7d3@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 15f263087bb8a..8d5d186fd5802 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -330,7 +330,6 @@ struct wcd9335_codec {
 
 	int intr1;
 	struct gpio_desc *reset_gpio;
-	struct regulator_bulk_data supplies[WCD9335_MAX_SUPPLY];
 
 	unsigned int rx_port_value[WCD9335_RX_MAX];
 	unsigned int tx_port_value[WCD9335_TX_MAX];
@@ -357,6 +356,10 @@ struct wcd9335_irq {
 	char *name;
 };
 
+static const char * const wcd9335_supplies[] = {
+	"vdd-buck", "vdd-buck-sido", "vdd-tx", "vdd-rx", "vdd-io",
+};
+
 static const struct wcd9335_slim_ch wcd9335_tx_chs[WCD9335_TX_MAX] = {
 	WCD9335_SLIM_TX_CH(0),
 	WCD9335_SLIM_TX_CH(1),
@@ -5046,30 +5049,16 @@ static int wcd9335_parse_dt(struct wcd9335_codec *wcd)
 	if (IS_ERR(wcd->native_clk))
 		return dev_err_probe(dev, PTR_ERR(wcd->native_clk), "slimbus clock not found\n");
 
-	wcd->supplies[0].supply = "vdd-buck";
-	wcd->supplies[1].supply = "vdd-buck-sido";
-	wcd->supplies[2].supply = "vdd-tx";
-	wcd->supplies[3].supply = "vdd-rx";
-	wcd->supplies[4].supply = "vdd-io";
-
-	ret = regulator_bulk_get(dev, WCD9335_MAX_SUPPLY, wcd->supplies);
+	ret = devm_regulator_bulk_get_enable(dev, ARRAY_SIZE(wcd9335_supplies),
+					     wcd9335_supplies);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to get supplies\n");
+		return dev_err_probe(dev, ret, "Failed to get and enable supplies\n");
 
 	return 0;
 }
 
 static int wcd9335_power_on_reset(struct wcd9335_codec *wcd)
 {
-	struct device *dev = wcd->dev;
-	int ret;
-
-	ret = regulator_bulk_enable(WCD9335_MAX_SUPPLY, wcd->supplies);
-	if (ret) {
-		dev_err(dev, "Failed to get supplies: err = %d\n", ret);
-		return ret;
-	}
-
 	/*
 	 * For WCD9335, it takes about 600us for the Vout_A and
 	 * Vout_D to be ready after BUCK_SIDO is powered up.
-- 
2.39.5



