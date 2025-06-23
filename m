Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FB8253924;
	Mon, 23 Jun 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685319; cv=none; b=QxFixTGvePS6Cx57TvJpwnJlsF4cCLp7sh6N1bQYZ9ghsu48LMkBdBfZKJ73WMuPUq5QRt4e2g4gBmBdg+7E7pa3itoKnJwk8QLJfIWLPbc+QzezDCrok6Q/ZJ0xdviJLumMAYP2cnbstQZjdb9a11x+PdBRN0gnGHLMFVHL8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685319; c=relaxed/simple;
	bh=mjGGlkENAGm5h/ga3F7Bu4mFALDCenkJKp9F/Sr0O74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCYbxd6i48PGrwheQI8AxWiue7YOLPl51ODVoQkdA1uPNJ4IGiBgWwC5YHN3G4sZnMrDzqqGvF52ZrKXgPeLmYrtYJ9eMFV7ct++tkYvYwACJmD0igSrCjwQ25aEOoZ4tjI5O9LYmQMnqEM4YUyOlej8OmZJSY2PX9N92hlW/Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d22oJwXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d22oJwXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4869DC4CEEA;
	Mon, 23 Jun 2025 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685318;
	bh=mjGGlkENAGm5h/ga3F7Bu4mFALDCenkJKp9F/Sr0O74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d22oJwXtNGvazU7dmyPZkNMcTCGzM8DsQPTggSAUXZOpmfC/N7d1Aly7gdLYeW60C
	 zQU6iCLn30MIDqNdYJ+EHiq0M2SKzZUIoZnVm3O5P1VQBqECVlq4yZcZj2kh1RM9lx
	 d0Brt2NAiO5xBoEU+k6OEEXUgBBb+uVmcMOhHJvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/355] pinctrl: at91: Fix possible out-of-boundary access
Date: Mon, 23 Jun 2025 15:04:06 +0200
Message-ID: <20250623130628.183014206@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 762ef7d1e6eefad9896560bfcb9bcf7f1b6df9c1 ]

at91_gpio_probe() doesn't check that given OF alias is not available or
something went wrong when trying to get it. This might have consequences
when accessing gpio_chips array with that value as an index. Note, that
BUG() can be compiled out and hence won't actually perform the required
checks.

Fixes: 6732ae5cb47c ("ARM: at91: add pinctrl support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/r/202505052343.UHF1Zo93-lkp@intel.com/
Link: https://lore.kernel.org/20250508200807.1384558-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-at91.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index bb9348f14b1ba..3b299f4e2c930 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1820,12 +1820,16 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	struct at91_gpio_chip *at91_chip = NULL;
 	struct gpio_chip *chip;
 	struct pinctrl_gpio_range *range;
+	int alias_idx;
 	int ret = 0;
 	int irq, i;
-	int alias_idx = of_alias_get_id(np, "gpio");
 	uint32_t ngpio;
 	char **names;
 
+	alias_idx = of_alias_get_id(np, "gpio");
+	if (alias_idx < 0)
+		return alias_idx;
+
 	BUG_ON(alias_idx >= ARRAY_SIZE(gpio_chips));
 	if (gpio_chips[alias_idx]) {
 		ret = -EBUSY;
-- 
2.39.5



rd-utils.c
index 3ae2a212a2e38..355f7ec8943c2 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1119,12 +1119,16 @@ int graph_util_parse_dai(struct simple_util_priv *priv, struct device_node *ep,
 	args.np = ep;
 	dai = snd_soc_get_dai_via_args(&args);
 	if (dai) {
+		const char *dai_name = snd_soc_dai_name_get(dai);
+		const struct of_phandle_args *dai_args = snd_soc_copy_dai_args(dev, &args);
+
 		ret = -ENOMEM;
+		if (!dai_args)
+			goto err;
+
 		dlc->of_node  = node;
-		dlc->dai_name = snd_soc_dai_name_get(dai);
-		dlc->dai_args = snd_soc_copy_dai_args(dev, &args);
-		if (!dlc->dai_args)
-			goto end;
+		dlc->dai_name = dai_name;
+		dlc->dai_args = dai_args;
 
 		goto parse_dai_end;
 	}
@@ -1154,16 +1158,17 @@ int graph_util_parse_dai(struct simple_util_priv *priv, struct device_node *ep,
 	 *    if he unbinded CPU or Codec.
 	 */
 	ret = snd_soc_get_dlc(&args, dlc);
-	if (ret < 0) {
-		of_node_put(node);
-		goto end;
-	}
+	if (ret < 0)
+		goto err;
 
 parse_dai_end:
 	if (is_single_link)
 		*is_single_link = of_graph_get_endpoint_count(node) == 1;
 	ret = 0;
-end:
+err:
+	if (ret < 0)
+		of_node_put(node);
+
 	return simple_ret(priv, ret);
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_dai);
-- 
2.39.5



