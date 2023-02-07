Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1F528E7
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51CFC433D2;
	Tue,  7 Feb 2023 12:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774714;
	bh=kzUS0FtuoAG5+oYBaLM27DVU3NOUt+8fQjfGm3/jNNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6zzxVITdL8j1Zv47RpjaUuoEIFD2+29zyQoI22qNjBUXZ/jCftx8lQ6LIXOXH7wo
	 P8PjtA6p8y+yPyMQWUv+aI5WxpsQUI1I1fNwKir/yavfan0xVHT9LyaSF4hYMnjj0r
	 ANOhOjAOKZEesH+BtT0eYAVz08de/uGYEBlfojc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/208] ASoC: Intel: sof_es8336: Drop reference count of ACPI device after use
Date: Tue,  7 Feb 2023 13:54:24 +0100
Message-Id: <20230207125634.801832550@linuxfoundation.org>
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

[ Upstream commit 64e57b2195725c1ae2246a8a2ce224abb60620ac ]

Theoretically the device might gone if its reference count drops to 0.
This might be the case when we try to find the first physical node of
the ACPI device. We need to keep reference to it until we get a result
of the above mentioned call. Refactor the code to drop the reference
count at the correct place.

While at it, move to acpi_dev_put() as symmetrical call to the
acpi_dev_get_first_match_dev().

Fixes: a164137ce91a ("ASoC: Intel: add machine driver for SOF+ES8336")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230112112852.67714-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 773e5d1d87d4..894b6610b9e2 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -681,7 +681,6 @@ static int sof_es8336_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(codec_name, sizeof(codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		dai_links[0].codecs->name = codec_name;
 
 		/* also fixup codec dai name if relevant */
@@ -692,16 +691,19 @@ static int sof_es8336_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	ret = snd_soc_fixup_dai_links_platform_name(&sof_es8336_card,
-						    mach->mach_params.platform);
-	if (ret)
-		return ret;
-
 	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 	priv->codec_dev = get_device(codec_dev);
 
+	ret = snd_soc_fixup_dai_links_platform_name(&sof_es8336_card,
+						    mach->mach_params.platform);
+	if (ret) {
+		put_device(codec_dev);
+		return ret;
+	}
+
 	if (quirk & SOF_ES8336_JD_INVERTED)
 		props[cnt++] = PROPERTY_ENTRY_BOOL("everest,jack-detect-inverted");
 
-- 
2.39.0



