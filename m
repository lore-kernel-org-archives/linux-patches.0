Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1B342539;
	Thu, 17 Sep 2026 15:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659160; cv=none; b=h329TZT1u/zuAOpJxWvf2txTiHfP+v6jrdCxQeYl3pcS9pV8SKu2C4DgRh3YnYdqT2ODW9EEkSL6K60dJ8ic4goYSqlm0A0lApL6f4JC0Z3jO9seXGPeNTqeIusWXpAxeyh7Mj2/EJ31GdhiHzq1+d+s2nr9ZTEspzrdZt4STpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659160; c=relaxed/simple;
	bh=Fogme+bCWMnU4xwFp5XR1+Bph/g3nchK3yE8YRM4kBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaKZsvy8KkT27Gidtuqfq+hLAXxAafYkfpN3NvCSyDuWviAx0W511OTk18ZCowxjpTZFn6Lsk237eZH4W3hN/44qcHGXUIG7r5h3UZV+7+iS2u+sQ84YCib2UjcgIYN/iV3eLM6xt8hVab2jZB471dbYdl+pxdEprFdslpJLp60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZMyp7eF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZMyp7eF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D431F000FF;
	Thu, 17 Sep 2026 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659152;
	bh=xuaUNATa+lnwx0HBvYTgigjbmVgx0NbRhVCUuQIQRFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZMyp7eFTmUxwwv8hpCpTlIXGkhNGgEojqr7jgtLPeN0ahVNf1+bhcxlvJuvZ6gm+
	 GlAI4/t8xSaOIIPtidhnXoUN+lOkRZGNZGwzVZTn4YTfMKXpgWGOnZc/OM07Ax5ax3
	 QRGpdvqBuNHAG261jfWJqNrndAQ48dovZrjsxjVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 159/733] ASoC: cs35l56: Request IRQ in cs35l56_common_probe()
Date: Thu, 17 Sep 2026 16:07:47 +0100
Message-ID: <20260917151355.031425652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 888162dabf64128603b12ac2d23236cf2086b7ef ]

Call cs35l56_irq_request() in cs35l56_common_probe() instead of calling
it afterwards in the probe() for each bus type.

Calling cs35l56_irq_request() in each bus probe() is a legacy of dealing
with the oddities of the SoundWire framework. It's no longer serving any
useful purpose to do it outside of the main cs35l56_common_probe().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260810104045.60701-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1d80a4792f1d ("ASoC: cs35l56: Fix probe deadlock waiting for SoundWire enumeration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-i2c.c | 10 +---------
 sound/soc/codecs/cs35l56-sdw.c |  6 +-----
 sound/soc/codecs/cs35l56-spi.c | 10 +---------
 sound/soc/codecs/cs35l56.c     | 12 ++++++++++--
 sound/soc/codecs/cs35l56.h     |  2 +-
 5 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-i2c.c b/sound/soc/codecs/cs35l56-i2c.c
index 4f6ddf1c5a3f6..5e69ddbe342a1 100644
--- a/sound/soc/codecs/cs35l56-i2c.c
+++ b/sound/soc/codecs/cs35l56-i2c.c
@@ -51,15 +51,7 @@ static int cs35l56_i2c_probe(struct i2c_client *client)
 		return dev_err_probe(cs35l56->base.dev, ret, "Failed to allocate register map\n");
 	}
 
-	ret = cs35l56_common_probe(cs35l56);
-	if (ret != 0)
-		return ret;
-
-	ret = cs35l56_irq_request(&cs35l56->base, client->irq);
-	if (ret < 0)
-		cs35l56_remove(cs35l56);
-
-	return ret;
+	return cs35l56_common_probe(cs35l56, client->irq);
 }
 
 static void cs35l56_i2c_remove(struct i2c_client *client)
diff --git a/sound/soc/codecs/cs35l56-sdw.c b/sound/soc/codecs/cs35l56-sdw.c
index 0a55b93b96f96..a3812ab4c0227 100644
--- a/sound/soc/codecs/cs35l56-sdw.c
+++ b/sound/soc/codecs/cs35l56-sdw.c
@@ -483,11 +483,7 @@ static int cs35l56_sdw_probe(struct sdw_slave *peripheral, const struct sdw_devi
 	/* Start in cache-only until device is enumerated */
 	regcache_cache_only(cs35l56->base.regmap, true);
 
-	ret = cs35l56_common_probe(cs35l56);
-	if (ret != 0)
-		return ret;
-
-	return 0;
+	return cs35l56_common_probe(cs35l56, -EINVAL);
 }
 
 static void cs35l56_sdw_remove(struct sdw_slave *peripheral)
diff --git a/sound/soc/codecs/cs35l56-spi.c b/sound/soc/codecs/cs35l56-spi.c
index b1eb924a5b6cc..21b18da9e73d1 100644
--- a/sound/soc/codecs/cs35l56-spi.c
+++ b/sound/soc/codecs/cs35l56-spi.c
@@ -40,15 +40,7 @@ static int cs35l56_spi_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = cs35l56_common_probe(cs35l56);
-	if (ret != 0)
-		return ret;
-
-	ret = cs35l56_irq_request(&cs35l56->base, spi->irq);
-	if (ret < 0)
-		cs35l56_remove(cs35l56);
-
-	return ret;
+	return cs35l56_common_probe(cs35l56, spi->irq);
 }
 
 static void cs35l56_spi_remove(struct spi_device *spi)
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 063ef7a70de03..a6364cdb15926 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1941,7 +1941,7 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 	return ret;
 }
 
-int cs35l56_common_probe(struct cs35l56_private *cs35l56)
+int cs35l56_common_probe(struct cs35l56_private *cs35l56, int irq)
 {
 	int ret;
 
@@ -2018,16 +2018,24 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
 			goto err_remove_wm_adsp;
 	}
 
+	ret = cs35l56_irq_request(&cs35l56->base, irq);
+	if (ret)
+		goto err_remove_wm_adsp;
+
 	ret = snd_soc_register_component(cs35l56->base.dev,
 					 &soc_component_dev_cs35l56,
 					 cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
 	if (ret < 0) {
 		dev_err_probe(cs35l56->base.dev, ret, "Register codec failed\n");
-		goto err_remove_wm_adsp;
+		goto err_free_irq;
 	}
 
 	return 0;
 
+err_free_irq:
+	if (cs35l56->base.irq)
+		devm_free_irq(cs35l56->base.dev, cs35l56->base.irq, &cs35l56->base);
+
 err_remove_wm_adsp:
 	wm_adsp2_remove(&cs35l56->dsp);
 
diff --git a/sound/soc/codecs/cs35l56.h b/sound/soc/codecs/cs35l56.h
index 9acd2e7e17c93..1ddee9ab6a876 100644
--- a/sound/soc/codecs/cs35l56.h
+++ b/sound/soc/codecs/cs35l56.h
@@ -78,7 +78,7 @@ int cs35l56_system_resume_early(struct device *dev);
 int cs35l56_system_resume(struct device *dev);
 irqreturn_t cs35l56_irq(int irq, void *data);
 int cs35l56_irq_request(struct cs35l56_base *cs35l56_base, int irq);
-int cs35l56_common_probe(struct cs35l56_private *cs35l56);
+int cs35l56_common_probe(struct cs35l56_private *cs35l56, int irq);
 int cs35l56_init(struct cs35l56_private *cs35l56);
 void cs35l56_remove(struct cs35l56_private *cs35l56);
 
-- 
2.53.0



