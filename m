Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D0747791;
	Mon,  8 Jan 2024 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6jTjezk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C42C433D9;
	Mon,  8 Jan 2024 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726600;
	bh=N4+O3EbR2jFmOE+f8rqg72ntkdRGeUujTK++HjIJoUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6jTjezk+pR1GmeItEzc9MH+dPIOkIFFClhbBXSlX+7eZyYqLWlP6iG2h44bcITPL
	 DvzE7iqSw4/FEhqCZulBCu+Bt87D1RGjs4h/JfjNwegJ2L/Pn3Ibjkni1HxeyKIT95
	 g3omM/aT/xA6YoPL7//FGSWvVa1QUjodg2G6s40Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 002/124] ALSA: hda/tas2781: do not use regcache
Date: Mon,  8 Jan 2024 16:07:08 +0100
Message-ID: <20240108150603.073423720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit 6dad45f4d28977bd1948973107cf325d431e5b7e upstream.

There are two problems with using regcache in this module.

The amplifier has 3 addressing levels (BOOK, PAGE, REG). The firmware
contains blocks that must be written to BOOK 0x8C. The regcache doesn't
know anything about BOOK, so regcache_sync writes invalid values to the
actual BOOK.

The module handles 2 or more separate amplifiers. The amplifiers have
different register values, and the module uses only one regmap/regcache
for all the amplifiers. The regcache_sync only writes the last amplifier
used.

The module successfully restores all the written register values (RC
profile, program, configuration, calibration) without regcache.

Remove regcache functions and set regmap cache_type to REGCACHE_NONE.

Link: https://lore.kernel.org/r/21a183b5a08cb23b193af78d4b1114cc59419272.1701906455.git.soyer@irl.hu/

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Acked-by: Mark Brown <broonie@kernel.org>
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/491aeed0e2eecc3b704ec856f815db21bad3ba0e.1703202126.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c   |   17 +----------------
 sound/soc/codecs/tas2781-comlib.c |    2 +-
 2 files changed, 2 insertions(+), 17 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -717,8 +717,6 @@ static int tas2781_runtime_suspend(struc
 		tas_priv->tasdevice[i].cur_conf = -1;
 	}
 
-	regcache_cache_only(tas_priv->regmap, true);
-	regcache_mark_dirty(tas_priv->regmap);
 
 	mutex_unlock(&tas_priv->codec_lock);
 
@@ -730,20 +728,11 @@ static int tas2781_runtime_resume(struct
 	struct tasdevice_priv *tas_priv = dev_get_drvdata(dev);
 	unsigned long calib_data_sz =
 		tas_priv->ndev * TASDEVICE_SPEAKER_CALIBRATION_SIZE;
-	int ret;
 
 	dev_dbg(tas_priv->dev, "Runtime Resume\n");
 
 	mutex_lock(&tas_priv->codec_lock);
 
-	regcache_cache_only(tas_priv->regmap, false);
-	ret = regcache_sync(tas_priv->regmap);
-	if (ret) {
-		dev_err(tas_priv->dev,
-			"Failed to restore register cache: %d\n", ret);
-		goto out;
-	}
-
 	tasdevice_prmg_load(tas_priv, tas_priv->cur_prog);
 
 	/* If calibrated data occurs error, dsp will still works with default
@@ -752,10 +741,9 @@ static int tas2781_runtime_resume(struct
 	if (tas_priv->cali_data.total_sz > calib_data_sz)
 		tas2781_apply_calib(tas_priv);
 
-out:
 	mutex_unlock(&tas_priv->codec_lock);
 
-	return ret;
+	return 0;
 }
 
 static int tas2781_system_suspend(struct device *dev)
@@ -770,10 +758,7 @@ static int tas2781_system_suspend(struct
 		return ret;
 
 	/* Shutdown chip before system suspend */
-	regcache_cache_only(tas_priv->regmap, false);
 	tasdevice_tuning_switch(tas_priv, 1);
-	regcache_cache_only(tas_priv->regmap, true);
-	regcache_mark_dirty(tas_priv->regmap);
 
 	/*
 	 * Reset GPIO may be shared, so cannot reset here.
--- a/sound/soc/codecs/tas2781-comlib.c
+++ b/sound/soc/codecs/tas2781-comlib.c
@@ -39,7 +39,7 @@ static const struct regmap_range_cfg tas
 static const struct regmap_config tasdevice_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.cache_type = REGCACHE_RBTREE,
+	.cache_type = REGCACHE_NONE,
 	.ranges = tasdevice_ranges,
 	.num_ranges = ARRAY_SIZE(tasdevice_ranges),
 	.max_register = 256 * 128,


