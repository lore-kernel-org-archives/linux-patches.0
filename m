Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F42F2F3632;
	Fri, 21 Nov 2025 13:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731535; cv=none; b=jw2gqUMLXOCWQcWX8v+O8SMk2bvrRV2pjesHylglzhbZcJOY2+X38OPWIBYoi7v6Krod+KOdEdvw+0YBA/iV42+TIGsV1LXSIjXpgMuH6BCEcKtKT7YVOrydhdEwZJ1IRGx53uVaZsQx9TP8kKpja9I58wCrmqPdU5gH4BnDDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731535; c=relaxed/simple;
	bh=OaAs1zhBiFYjK6ymR03zV7UnUDuDrQ+ITafEhptLKYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnXQIzSGRrytlhHRMMe8o/aaXzzJ55LkeOxBc1yZECw6CF37exdSwec1dTi1qxt1Hiz0GRN+SMX2hGxnFU93PTdMMP4WeGIsqfCHQKpFsMwYnypMF/55R8qolq3UNqcwTZyg58PcRYg1JNBsMwu0k7qkLhHggaJBMgRfP0IoUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPRaZQX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPRaZQX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0656C4CEFB;
	Fri, 21 Nov 2025 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731535;
	bh=OaAs1zhBiFYjK6ymR03zV7UnUDuDrQ+ITafEhptLKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPRaZQX24J7JyKpWJotP+/0TPoWsmNtPqYrx3Qo7QcmDxD0VdUQJYmSpzx3EBiOzj
	 khZi1oCDca3hzd0Y6iztVlUBre0MIhnWx6+zoYE+sLnqhiTbqa8vy5JPGhQ75VzFUG
	 2nEpKSFlkG+2JgjUTsSg2aYgjl+yTqGwITu7w0a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 242/247] ASoC: da7213: Use component driver suspend/resume
Date: Fri, 21 Nov 2025 14:13:09 +0100
Message-ID: <20251121130203.423558660@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 249d96b492efb7a773296ab2c62179918301c146 ]

Since snd_soc_suspend() is invoked through snd_soc_pm_ops->suspend(),
and snd_soc_pm_ops is associated with the soc_driver (defined in
sound/soc/soc-core.c), and there is no parent-child relationship between
the soc_driver and the DA7213 codec driver, the power management subsystem
does not enforce a specific suspend/resume order between the DA7213 driver
and the soc_driver.

Because of this, the different codec component functionalities, called from
snd_soc_resume() to reconfigure various functions, can race with the
DA7213 struct dev_pm_ops::resume function, leading to misapplied
configuration. This occasionally results in clipped sound.

Fix this by dropping the struct dev_pm_ops::{suspend, resume} and use
instead struct snd_soc_component_driver::{suspend, resume}. This ensures
the proper configuration sequence is handled by the ASoC subsystem.

Cc: stable@vger.kernel.org
Fixes: 431e040065c8 ("ASoC: da7213: Add suspend to RAM support")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20251104114914.2060603-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7213.c |   69 +++++++++++++++++++++++++++++-----------------
 sound/soc/codecs/da7213.h |    1 
 2 files changed, 45 insertions(+), 25 deletions(-)

--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -2124,11 +2124,50 @@ static int da7213_probe(struct snd_soc_c
 	return 0;
 }
 
+static int da7213_runtime_suspend(struct device *dev)
+{
+	struct da7213_priv *da7213 = dev_get_drvdata(dev);
+
+	regcache_cache_only(da7213->regmap, true);
+	regcache_mark_dirty(da7213->regmap);
+	regulator_bulk_disable(DA7213_NUM_SUPPLIES, da7213->supplies);
+
+	return 0;
+}
+
+static int da7213_runtime_resume(struct device *dev)
+{
+	struct da7213_priv *da7213 = dev_get_drvdata(dev);
+	int ret;
+
+	ret = regulator_bulk_enable(DA7213_NUM_SUPPLIES, da7213->supplies);
+	if (ret < 0)
+		return ret;
+	regcache_cache_only(da7213->regmap, false);
+	return regcache_sync(da7213->regmap);
+}
+
+static int da7213_suspend(struct snd_soc_component *component)
+{
+	struct da7213_priv *da7213 = snd_soc_component_get_drvdata(component);
+
+	return da7213_runtime_suspend(da7213->dev);
+}
+
+static int da7213_resume(struct snd_soc_component *component)
+{
+	struct da7213_priv *da7213 = snd_soc_component_get_drvdata(component);
+
+	return da7213_runtime_resume(da7213->dev);
+}
+
 static const struct snd_soc_component_driver soc_component_dev_da7213 = {
 	.probe			= da7213_probe,
 	.set_bias_level		= da7213_set_bias_level,
 	.controls		= da7213_snd_controls,
 	.num_controls		= ARRAY_SIZE(da7213_snd_controls),
+	.suspend		= da7213_suspend,
+	.resume			= da7213_resume,
 	.dapm_widgets		= da7213_dapm_widgets,
 	.num_dapm_widgets	= ARRAY_SIZE(da7213_dapm_widgets),
 	.dapm_routes		= da7213_audio_map,
@@ -2175,6 +2214,8 @@ static int da7213_i2c_probe(struct i2c_c
 	if (!da7213->fin_min_rate)
 		return -EINVAL;
 
+	da7213->dev = &i2c->dev;
+
 	i2c_set_clientdata(i2c, da7213);
 
 	/* Get required supplies */
@@ -2224,31 +2265,9 @@ static void da7213_i2c_remove(struct i2c
 	pm_runtime_disable(&i2c->dev);
 }
 
-static int da7213_runtime_suspend(struct device *dev)
-{
-	struct da7213_priv *da7213 = dev_get_drvdata(dev);
-
-	regcache_cache_only(da7213->regmap, true);
-	regcache_mark_dirty(da7213->regmap);
-	regulator_bulk_disable(DA7213_NUM_SUPPLIES, da7213->supplies);
-
-	return 0;
-}
-
-static int da7213_runtime_resume(struct device *dev)
-{
-	struct da7213_priv *da7213 = dev_get_drvdata(dev);
-	int ret;
-
-	ret = regulator_bulk_enable(DA7213_NUM_SUPPLIES, da7213->supplies);
-	if (ret < 0)
-		return ret;
-	regcache_cache_only(da7213->regmap, false);
-	return regcache_sync(da7213->regmap);
-}
-
-static DEFINE_RUNTIME_DEV_PM_OPS(da7213_pm, da7213_runtime_suspend,
-				 da7213_runtime_resume, NULL);
+static const struct dev_pm_ops da7213_pm = {
+	RUNTIME_PM_OPS(da7213_runtime_suspend, da7213_runtime_resume, NULL)
+};
 
 static const struct i2c_device_id da7213_i2c_id[] = {
 	{ "da7213" },
--- a/sound/soc/codecs/da7213.h
+++ b/sound/soc/codecs/da7213.h
@@ -595,6 +595,7 @@ enum da7213_supplies {
 /* Codec private data */
 struct da7213_priv {
 	struct regmap *regmap;
+	struct device *dev;
 	struct mutex ctrl_lock;
 	struct regulator_bulk_data supplies[DA7213_NUM_SUPPLIES];
 	struct clk *mclk;


