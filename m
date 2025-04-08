Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46ED26A0A8;
	Tue,  8 Apr 2025 12:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113655; cv=none; b=eY/u9Oijilv/cibUcnVkBOlL/HW8dosOHwyyPdP9Z7TaGt0t3J9SVBYwkO2gZEqW8YU9aX4vVPQdQIu2va4H3cnawOpfW5Hy1MavLfBwsDle+j+v/+1Wkwol5WX0YPblR4GdTqOq4m0D9Xcm9H97shXU+Fo58ZxVmGuvoCNu5xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113655; c=relaxed/simple;
	bh=gVEK7Qpr2Xd59IaP9ANU/Geg2Cug4meAq3VVzlZvCyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vC7ou7pfNG0R/PkYZDHfoIMol61N7iRNccmwURHqd5LmBbPzscGgtxBaWualT9SmvOzjX2wymqg76JfWvp/mvIP9jcBAxCD30tdYVFH/1mOWYpYZgQUfjnKu5fcwOi5EVSo2nZ9kQiRuU0roW7cEt+pBz4fvCkxf8USNneYePMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH9965Ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH9965Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB26C4CEE5;
	Tue,  8 Apr 2025 12:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113655;
	bh=gVEK7Qpr2Xd59IaP9ANU/Geg2Cug4meAq3VVzlZvCyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH9965Ig8fL84BZYLCiCU4AKrRVfMBi1PUeiicWcqcAJhlFPyFlTJnVBSdTVHjL+l
	 Ja1fENSKD0a9XD4sJ6nYpEiDkukntJE05VDk+PxlpEE2FZrcoMFRtw/1aTSVdEes6e
	 gSWbdUugDWXI0IO6afj/7QQ8fvdk4cUeYST22P2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/268] ASoC: codecs: rt5665: Fix some error handling paths in rt5665_probe()
Date: Tue,  8 Apr 2025 12:50:12 +0200
Message-ID: <20250408104833.976343369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index a39de4a7df002..532d1d6958af3 100644
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



