Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0D915DBAB;
	Mon, 29 Jan 2024 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548429; cv=none; b=nAfLGEEmB/fgQ1BcPzaz3z0HnT0bv3swByduUBQohdLJszo3ad3VAmh8GtXFivg6ugyhQv1kqH22wbz/mjJ1nOypgkpgCcUsvwHAiA6Cs5pP/9hE1Z1DbEDkucLr3JQmsSusgW2FhKc4WSC7D4fNKXZPkINd1xZQ7tXKGSRSBbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548429; c=relaxed/simple;
	bh=3vCyG0Ve4XrLTojZ7BiYvA3BZKBxGaRriT2gJ2vLaGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/dvK0Dr1ehjUZxVhAKzSjUNVbETUHE9HpPAaT2fRqetBNZqlsAdbP8ayZZhlLNLvjrrWES8VeWxoOTO0sbNxMPKDf61wH4YhyawbVVGigUt/Rp3pGcvnwHwnqCWAPzBLQlW52NF/Ulhw9vDb98wuCJQp7buwkmUTeZ//RewUok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pm1u23FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pm1u23FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42741C43390;
	Mon, 29 Jan 2024 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548429;
	bh=3vCyG0Ve4XrLTojZ7BiYvA3BZKBxGaRriT2gJ2vLaGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pm1u23FU0HFQZA4F8MbfKPa67magzMFxHsFCogzXGcIfIXbHhros3zdDRlwBY4UkF
	 E+YL9D3zCB1JdLieiqyvDyfDaCihjoiD864BQWx4Sar5WrE/L0psQ9CM87IhkKBGPC
	 b8CHfHwcP/w/g6AohvSKavE8bOi0Kmioykdqa1AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/331] soundwire: fix initializing sysfs for same devices on different buses
Date: Mon, 29 Jan 2024 09:01:11 -0800
Message-ID: <20240129170015.172772323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8a8a9ac8a4972ee69d3dd3d1ae43963ae39cee18 ]

If same devices with same device IDs are present on different soundwire
buses, the probe fails due to conflicting device names and sysfs
entries:

  sysfs: cannot create duplicate filename '/bus/soundwire/devices/sdw:0:0217:0204:00:0'

The link ID is 0 for both devices, so they should be differentiated by
the controller ID. Add the controller ID so, the device names and sysfs entries look
like:

  sdw:1:0:0217:0204:00:0 -> ../../../devices/platform/soc@0/6ab0000.soundwire-controller/sdw-master-1-0/sdw:1:0:0217:0204:00:0
  sdw:3:0:0217:0204:00:0 -> ../../../devices/platform/soc@0/6b10000.soundwire-controller/sdw-master-3-0/sdw:3:0:0217:0204:00:0

[PLB changes: use bus->controller_id instead of bus->id]

Fixes: 7c3cd189b86d ("soundwire: Add Master registration")
Cc: stable@vger.kernel.org
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Co-developed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Mark Brown <broonie@kernel.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231017160933.12624-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c        | 12 ++++++------
 sound/soc/intel/boards/sof_sdw.c |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index c1c1a2ac293a..060c2982e26b 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -39,14 +39,14 @@ int sdw_slave_add(struct sdw_bus *bus,
 	slave->dev.fwnode = fwnode;
 
 	if (id->unique_id == SDW_IGNORED_UNIQUE_ID) {
-		/* name shall be sdw:link:mfg:part:class */
-		dev_set_name(&slave->dev, "sdw:%01x:%04x:%04x:%02x",
-			     bus->link_id, id->mfg_id, id->part_id,
+		/* name shall be sdw:ctrl:link:mfg:part:class */
+		dev_set_name(&slave->dev, "sdw:%01x:%01x:%04x:%04x:%02x",
+			     bus->controller_id, bus->link_id, id->mfg_id, id->part_id,
 			     id->class_id);
 	} else {
-		/* name shall be sdw:link:mfg:part:class:unique */
-		dev_set_name(&slave->dev, "sdw:%01x:%04x:%04x:%02x:%01x",
-			     bus->link_id, id->mfg_id, id->part_id,
+		/* name shall be sdw:ctrl:link:mfg:part:class:unique */
+		dev_set_name(&slave->dev, "sdw:%01x:%01x:%04x:%04x:%02x:%01x",
+			     bus->controller_id, bus->link_id, id->mfg_id, id->part_id,
 			     id->class_id, id->unique_id);
 	}
 
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 24e966a2ac2b..9ed572141fe5 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1197,11 +1197,11 @@ static int fill_sdw_codec_dlc(struct device *dev,
 	else if (is_unique_device(adr_link, sdw_version, mfg_id, part_id,
 				  class_id, adr_index))
 		codec->name = devm_kasprintf(dev, GFP_KERNEL,
-					     "sdw:%01x:%04x:%04x:%02x", link_id,
+					     "sdw:0:%01x:%04x:%04x:%02x", link_id,
 					     mfg_id, part_id, class_id);
 	else
 		codec->name = devm_kasprintf(dev, GFP_KERNEL,
-					     "sdw:%01x:%04x:%04x:%02x:%01x", link_id,
+					     "sdw:0:%01x:%04x:%04x:%02x:%01x", link_id,
 					     mfg_id, part_id, class_id, unique_id);
 
 	if (!codec->name)
-- 
2.43.0



