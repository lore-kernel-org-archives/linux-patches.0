Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEB044C6F;
	Thu, 13 Jun 2024 12:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280723; cv=none; b=MeE93u0mIvkzDgj25M/So0BC+ZLfgD3YC/Fn0ZwEqAq7jF+aJ+cNgabycmfjGf2JEbshroA/ymsJqmP5fTSzGGMhxgix+U6jCDpKe1nJwbr88wjsXlXjtt3L5eh2hBMHM0l6ut9kzgLhVH4MLBiEW1ZJVBLzPSMlfngI8uUKXLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280723; c=relaxed/simple;
	bh=1kVrurtiSbIUVu8ATiXw6GHLsnZuLHvXUUTKImPw9Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8uzp/BpcHoSLvTKfdnp5kQZCZS0bniWmNzGlwdXlfJhqtZT7boUTBcX8B82YLa5aYfkfvPdq599AMGk5G+8OiQlEdlkOHgnnv411XetWd3yQ4ounMymFoQZk96usMjRoo9XiUpuOJ2amM0rS7UFICjrmqX+TP6ea+20QjvscRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFi3JMGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFi3JMGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56310C2BBFC;
	Thu, 13 Jun 2024 12:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280723;
	bh=1kVrurtiSbIUVu8ATiXw6GHLsnZuLHvXUUTKImPw9Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFi3JMGEoTfuJID1QjGvHK+eMvhTTyFTwZKCoNq5dCwFL4ge2vFbxunrDuc7QegoJ
	 1DQ4eK6bH90Wwdb/3Ntv+TFrrF3T9JUGFrWBDJ+Fs55pergmmBct/JDY3JaS+WwRYy
	 dGLReWXO7Xp2DkRzTdcag0P68efIKTJb9z7HdtRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/317] ASoC: rt5645: Fix the electric noise due to the CBJ contacts floating
Date: Thu, 13 Jun 2024 13:30:31 +0200
Message-ID: <20240613113248.054416684@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 103abab975087e1f01b76fcb54c91dbb65dbc249 ]

The codec leaves tie combo jack's sleeve/ring2 to floating status
default. It would cause electric noise while connecting the active
speaker jack during boot or shutdown.
This patch requests a gpio to control the additional jack circuit
to tie the contacts to the ground or floating.

Signed-off-by: Derek Fang <derek.fang@realtek.com>

Link: https://msgid.link/r/20240408091057.14165-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 5db63ef33f1a2..ac403827a2290 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -414,6 +414,7 @@ struct rt5645_priv {
 	struct regmap *regmap;
 	struct i2c_client *i2c;
 	struct gpio_desc *gpiod_hp_det;
+	struct gpio_desc *gpiod_cbj_sleeve;
 	struct snd_soc_jack *hp_jack;
 	struct snd_soc_jack *mic_jack;
 	struct snd_soc_jack *btn_jack;
@@ -3169,6 +3170,9 @@ static int rt5645_jack_detect(struct snd_soc_component *component, int jack_inse
 		regmap_update_bits(rt5645->regmap, RT5645_IN1_CTRL2,
 			RT5645_CBJ_MN_JD, 0);
 
+		if (rt5645->gpiod_cbj_sleeve)
+			gpiod_set_value(rt5645->gpiod_cbj_sleeve, 1);
+
 		msleep(600);
 		regmap_read(rt5645->regmap, RT5645_IN1_CTRL3, &val);
 		val &= 0x7;
@@ -3185,6 +3189,8 @@ static int rt5645_jack_detect(struct snd_soc_component *component, int jack_inse
 			snd_soc_dapm_disable_pin(dapm, "Mic Det Power");
 			snd_soc_dapm_sync(dapm);
 			rt5645->jack_type = SND_JACK_HEADPHONE;
+			if (rt5645->gpiod_cbj_sleeve)
+				gpiod_set_value(rt5645->gpiod_cbj_sleeve, 0);
 		}
 		if (rt5645->pdata.level_trigger_irq)
 			regmap_update_bits(rt5645->regmap, RT5645_IRQ_CTRL2,
@@ -3210,6 +3216,9 @@ static int rt5645_jack_detect(struct snd_soc_component *component, int jack_inse
 		if (rt5645->pdata.level_trigger_irq)
 			regmap_update_bits(rt5645->regmap, RT5645_IRQ_CTRL2,
 				RT5645_JD_1_1_MASK, RT5645_JD_1_1_INV);
+
+		if (rt5645->gpiod_cbj_sleeve)
+			gpiod_set_value(rt5645->gpiod_cbj_sleeve, 0);
 	}
 
 	return rt5645->jack_type;
@@ -3882,6 +3891,16 @@ static int rt5645_i2c_probe(struct i2c_client *i2c,
 			return ret;
 	}
 
+	rt5645->gpiod_cbj_sleeve = devm_gpiod_get_optional(&i2c->dev, "cbj-sleeve",
+							   GPIOD_OUT_LOW);
+
+	if (IS_ERR(rt5645->gpiod_cbj_sleeve)) {
+		ret = PTR_ERR(rt5645->gpiod_cbj_sleeve);
+		dev_info(&i2c->dev, "failed to initialize gpiod, ret=%d\n", ret);
+		if (ret != -ENOENT)
+			return ret;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(rt5645->supplies); i++)
 		rt5645->supplies[i].supply = rt5645_supply_names[i];
 
@@ -4125,6 +4144,9 @@ static int rt5645_i2c_remove(struct i2c_client *i2c)
 	cancel_delayed_work_sync(&rt5645->jack_detect_work);
 	cancel_delayed_work_sync(&rt5645->rcclock_work);
 
+	if (rt5645->gpiod_cbj_sleeve)
+		gpiod_set_value(rt5645->gpiod_cbj_sleeve, 0);
+
 	regulator_bulk_disable(ARRAY_SIZE(rt5645->supplies), rt5645->supplies);
 
 	return 0;
@@ -4142,6 +4164,9 @@ static void rt5645_i2c_shutdown(struct i2c_client *i2c)
 		0);
 	msleep(20);
 	regmap_write(rt5645->regmap, RT5645_RESET, 0);
+
+	if (rt5645->gpiod_cbj_sleeve)
+		gpiod_set_value(rt5645->gpiod_cbj_sleeve, 0);
 }
 
 static struct i2c_driver rt5645_i2c_driver = {
-- 
2.43.0



