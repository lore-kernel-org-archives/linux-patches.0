Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FE363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA13C433D2;
	Mon, 20 Feb 2023 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900637;
	bh=plXSimIl+wT6B2nWvdMBdPTWIBvPIGCCMXZ6XphE0js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVC5tFzIWOp/EDzDbAAxKE8vsTrrwBZQycOTxXFnaxBA8H05MeDsVgVRo7oxzPQdV
	 0Sk5Uet3B9PSXhy5yfmbE7czts/+WA++3P2s8IOyV46cGnfaMPBryCYUnIqcr9/lj6
	 9rjRGBBTYg6hFxhQpfLlGJNayht/NEg+lOaeePW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/156] ASoC: Intel: bytcr_rt5651: Drop reference count of ACPI device after use
Date: Mon, 20 Feb 2023 14:34:07 +0100
Message-Id: <20230220133602.634918355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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
index 921c09cdb480..0c1c8628b991 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -919,7 +919,6 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 	if (adev) {
 		snprintf(byt_rt5651_codec_name, sizeof(byt_rt5651_codec_name),
 			 "i2c-%s", acpi_dev_name(adev));
-		put_device(&adev->dev);
 		byt_rt5651_dais[dai_index].codecs->name = byt_rt5651_codec_name;
 	} else {
 		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", mach->id);
@@ -928,6 +927,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 
 	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL,
 					    byt_rt5651_codec_name);
+	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
 
-- 
2.39.0



