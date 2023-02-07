Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC52C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1365BC4339B;
	Tue,  7 Feb 2023 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775358;
	bh=5D327pcS2I9uFQqWg4T6pJWYemhv87+ZU1CE2Ttdj3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVATXNoHaARRWoe5G0q6xC2jUMKW5lhHzUR1hyhpGpegq4YEE5vyr9wOzoccBUKWa
	 SyLJp/UKcsbYWX5ultPSAk0VrZdGOOzrUINVI5f/Kt3URREX2GFCkly99iiFDRun6k
	 pMvx6urCIVROIhtew79HqyKBs1PDhTZCu+6zLoJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/120] ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use
Date: Tue,  7 Feb 2023 13:56:17 +0100
Message-Id: <20230207125619.009664032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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

[ Upstream commit 721858823d7cdc8f2a897579b040e935989f6f02 ]

Theoretically the device might gone if its reference count drops to 0.
This might be the case when we try to find the first physical node of
the ACPI device. We need to keep reference to it until we get a result
of the above mentioned call. Refactor the code to drop the reference
count at the correct place.

While at it, move to acpi_dev_put() as symmetrical call to the
acpi_dev_get_first_match_dev().

Fixes: 02c0a3b3047f ("ASoC: Intel: bytcr_rt5651: add MCLK, quirks and cleanups")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230112112852.67714-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5651.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 31219874c2ae..93cec4d91627 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -930,7 +930,6 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(byt_rt5651_codec_name, sizeof(byt_rt5651_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_rt5651_dais[dai_index].codecs->name = byt_rt5651_codec_name;
 	} else {
 		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
@@ -938,6 +937,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	}
 
 	codec_dev = acpi_get_first_physical_node(adev);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 	priv->codec_dev = get_device(codec_dev);
-- 
2.39.0



