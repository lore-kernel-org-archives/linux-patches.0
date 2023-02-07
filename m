Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8005428E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9AEC433EF;
	Tue,  7 Feb 2023 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774756;
	bh=m3dnG01hAlRo7i8z166q/hFjAJ+w3k6yiFn/cXPbDI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKk5bC132Dui+mfeCmHeZCNfxe+jQW7USkWctgAohFPaA9BqF3yZRuMtvWB+2pzPu
	 JGRTJJE5D4qMPMxxdbtLPE9IhFfDoWKYvbo2944pV4EiDt3T8PwgQSsYGMwWso3RvD
	 RKvCqvLhV7A587nlVAsbJ35TUNzb5kOiz5vW0IOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/208] ASoC: Intel: bytcr_rt5640: Drop reference count of ACPI device after use
Date: Tue,  7 Feb 2023 13:54:22 +0100
Message-Id: <20230207125634.718142207@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cbf87bcf46e399e9a5288430d940efbad3551c68 ]

Theoretically the device might gone if its reference count drops to 0.
This might be the case when we try to find the first physical node of
the ACPI device. We need to keep reference to it until we get a result
of the above mentioned call. Refactor the code to drop the reference
count at the correct place.

While at it, move to acpi_dev_put() as symmetrical call to the
acpi_dev_get_first_match_dev().

Fixes: a232b96dcece ("ASoC: Intel: bytcr_rt5640: use HID translation util")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230112112852.67714-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index ddd2625bed90..4f46f52c38e4 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1626,13 +1626,18 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(byt_rt5640_codec_name, sizeof(byt_rt5640_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_rt5640_dais[dai_index].codecs->name = byt_rt5640_codec_name;
 	} else {
 		dev_err(dev, "Error cannot find '%s' dev\n", mach->id);
 		return -ENXIO;
 	}
 
+	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
+	if (!codec_dev)
+		return -EPROBE_DEFER;
+	priv->codec_dev = get_device(codec_dev);
+
 	/*
 	 * swap SSP0 if bytcr is detected
 	 * (will be overridden if DMI quirk is detected)
@@ -1707,11 +1712,6 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		byt_rt5640_quirk = quirk_override;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
-	if (!codec_dev)
-		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
-
 	if (byt_rt5640_quirk & BYT_RT5640_JD_HP_ELITEP_1000G2) {
 		acpi_dev_add_driver_gpios(ACPI_COMPANION(priv->codec_dev),
 					  byt_rt5640_hp_elitepad_1000g2_gpios);
-- 
2.39.0



