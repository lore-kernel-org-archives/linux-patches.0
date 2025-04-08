Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE01281525;
	Tue,  8 Apr 2025 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116907; cv=none; b=PGe7jOWoOcbfPnzHlyIZorQVtB079npmuOQ4J+Ga+r4PZsZQDBxh0PvIFExtFTiOs7SACg/UKKRkRmER4KrNxwyzvhXu0u5cw5VqrBA4vKo8mQ+kPM/JYI3VevwbOdXTxLGRb2nH1eO3p1hfLZwBNDqs5ZD94/wnHnVE6GlgwkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116907; c=relaxed/simple;
	bh=WCAVAOmB3HytLqnrvg0mHI54fjYnsjIDjL2TzL463g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3bAiZ8JGmCw5bNFzGGGXkcEjEZ0ft08D6VYft1+tApHECE4VKyff+BTeJCf9GPSI1ojXzdOkMJsoivfjCrlbbtPqpUqS52dBfR13s/EXQErX+PEYRUjrrUmKHjIEENVP0NqGfwCGwPh8L54AYAxo3mi8ftGZ2lAUQnEC3t7RIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLRu1z1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLRu1z1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8FDC4CEE5;
	Tue,  8 Apr 2025 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116907;
	bh=WCAVAOmB3HytLqnrvg0mHI54fjYnsjIDjL2TzL463g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLRu1z1UkujmnZjxmAmnLIqzureM0uXg5E8cdIYsEVkQAmJU8IYmor7YhdV+ff63H
	 vWRTquFGqvhKUtupkYUZ3fME++S0jyRB7yEnHFVKefLi6c4+7LgENkIfkIqeyBrqN3
	 KwBc6zGPs8uYa46oj3DixbJNOErM/dKIPDGcKxTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/423] ASoC: codecs: rt5665: Fix some error handling paths in rt5665_probe()
Date: Tue,  8 Apr 2025 12:50:40 +0200
Message-ID: <20250408104853.121311064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1ebd4944266e86a7ce274f197847f5a6399651e8 ]

Should an error occur after a successful regulator_bulk_enable() call,
regulator_bulk_disable() should be called, as already done in the remove
function.

Instead of adding an error handling path in the probe, switch from
devm_regulator_bulk_get() to devm_regulator_bulk_get_enable() and
simplify the remove function and some other places accordingly.

Finally, add a missing const when defining rt5665_supply_names to please
checkpatch and constify a few bytes.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/e3c2aa1b2fdfa646752d94f4af968630c0d58248.1742629525.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 47df14ba52784..4f0236b34a2d9 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -31,9 +31,7 @@
 #include "rl6231.h"
 #include "rt5665.h"
 
-#define RT5665_NUM_SUPPLIES 3
-
-static const char *rt5665_supply_names[RT5665_NUM_SUPPLIES] = {
+static const char * const rt5665_supply_names[] = {
 	"AVDD",
 	"MICVDD",
 	"VBAT",
@@ -46,7 +44,6 @@ struct rt5665_priv {
 	struct gpio_desc *gpiod_ldo1_en;
 	struct gpio_desc *gpiod_reset;
 	struct snd_soc_jack *hs_jack;
-	struct regulator_bulk_data supplies[RT5665_NUM_SUPPLIES];
 	struct delayed_work jack_detect_work;
 	struct delayed_work calibrate_work;
 	struct delayed_work jd_check_work;
@@ -4471,8 +4468,6 @@ static void rt5665_remove(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regmap_write(rt5665->regmap, RT5665_RESET, 0);
-
-	regulator_bulk_disable(ARRAY_SIZE(rt5665->supplies), rt5665->supplies);
 }
 
 #ifdef CONFIG_PM
@@ -4758,7 +4753,7 @@ static int rt5665_i2c_probe(struct i2c_client *i2c)
 {
 	struct rt5665_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct rt5665_priv *rt5665;
-	int i, ret;
+	int ret;
 	unsigned int val;
 
 	rt5665 = devm_kzalloc(&i2c->dev, sizeof(struct rt5665_priv),
@@ -4774,24 +4769,13 @@ static int rt5665_i2c_probe(struct i2c_client *i2c)
 	else
 		rt5665_parse_dt(rt5665, &i2c->dev);
 
-	for (i = 0; i < ARRAY_SIZE(rt5665->supplies); i++)
-		rt5665->supplies[i].supply = rt5665_supply_names[i];
-
-	ret = devm_regulator_bulk_get(&i2c->dev, ARRAY_SIZE(rt5665->supplies),
-				      rt5665->supplies);
+	ret = devm_regulator_bulk_get_enable(&i2c->dev, ARRAY_SIZE(rt5665_supply_names),
+					     rt5665_supply_names);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to request supplies: %d\n", ret);
 		return ret;
 	}
 
-	ret = regulator_bulk_enable(ARRAY_SIZE(rt5665->supplies),
-				    rt5665->supplies);
-	if (ret != 0) {
-		dev_err(&i2c->dev, "Failed to enable supplies: %d\n", ret);
-		return ret;
-	}
-
-
 	rt5665->gpiod_ldo1_en = devm_gpiod_get_optional(&i2c->dev,
 							"realtek,ldo1-en",
 							GPIOD_OUT_HIGH);
-- 
2.39.5



