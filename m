Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41779341ADD;
	Wed, 30 Sep 2026 19:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796223; cv=none; b=j3HUGoAKkiuswt8DJc6JW0BWHuY4Ewc8OXczw0luvKu28Djt2pcjLYpz3xlJ7T6yBHYJLJ/sdFCOtxmjWJOVyOxWDyTmTjrXyzKuczOaavAIzv5U3bmNLR+1pMDLJdSz2VbuIhXMe2sQcQweHllHCdIdmnTuKZvsM17246AmYc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796223; c=relaxed/simple;
	bh=ROL1DgdlD+sc0S8v3MmcB1+rCTddZTIYNwQO3+bp3nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuTo5mvmYtT/BsGBz2DuwWScmlfBI8CKdFCTPvx9wUpIJYWqUBsXgPSiUKLl9dBaqaTLpRIINbNgyD7anaPqypiNdY4DSpkLfaxf6NcWGHMDJWayztgcH+Wljl0RDILep9VHu8CCVsYi0/rUEDAXV19ObIYMhWfRnp9GBgXncqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jr7uEamq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jr7uEamq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADCD1F000FF;
	Wed, 30 Sep 2026 19:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796222;
	bh=L3sp4d8t0/j67+QQDMuyyrXzFyd3J6rIRf1OLvEIEEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jr7uEamqIOcmA9WGjOrisDopFdEG35eGFxENUPtwLW8FAkJ479FPuvzmwHP4MB9IV
	 hO4h46WLPd4h69tgPhVNbvljtITMSW4zRGxgAPrw3SANYVbkM3e5VLJeICIJ21NFGi
	 HPhNdJqnP2yAfpSF0ivG3NHPljK80UTwZEuxmlqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0836/1193] ASoC: codecs: rt712-sdca-dmic: fix uninitialized stream_config->type
Date: Wed, 30 Sep 2026 17:25:20 +0200
Message-ID: <20260930152452.817543429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 03a5699a0a04309c597683967aaaf25d1e555ea2 upstream.

stream_config is not initialized before being passed to
sdw_stream_add_slave().  The type field may contain garbage and is
later copied to stream->type by sdw_config_stream().

Zero-initialize stream_config so type defaults to SDW_STREAM_PCM.

While at it, use snd_sdw_params_to_config() helper instead of
open-coding the same logic.

Fixes: 63a511284c9e ("ASoC: rt712-sdca: Add RT712 SDCA driver for Mic topology")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260914104712.379574-1-yijiangshan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt712-sdca-dmic.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/sound/soc/codecs/rt712-sdca-dmic.c
+++ b/sound/soc/codecs/rt712-sdca-dmic.c
@@ -14,6 +14,7 @@
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
+#include <sound/sdw.h>
 #include <sound/tlv.h>
 #include "rt712-sdca.h"
 #include "rt712-sdca-dmic.h"
@@ -640,10 +641,10 @@ static int rt712_sdca_dmic_hw_params(str
 {
 	struct snd_soc_component *component = dai->component;
 	struct rt712_sdca_dmic_priv *rt712 = snd_soc_component_get_drvdata(component);
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
 	struct sdw_stream_runtime *sdw_stream;
-	int retval, num_channels;
+	int retval;
 	unsigned int sampling_rate;
 
 	dev_dbg(dai->dev, "%s %s", __func__, dai->name);
@@ -655,13 +656,8 @@ static int rt712_sdca_dmic_hw_params(str
 	if (!rt712->slave)
 		return -EINVAL;
 
-	stream_config.frame_rate = params_rate(params);
-	stream_config.ch_count = params_channels(params);
-	stream_config.bps = snd_pcm_format_width(params_format(params));
-	stream_config.direction = SDW_DATA_DIR_TX;
-
-	num_channels = params_channels(params);
-	port_config.ch_mask = GENMASK(num_channels - 1, 0);
+	/* SoundWire specific configuration */
+	snd_sdw_params_to_config(substream, params, &stream_config, &port_config);
 	port_config.num = 2;
 
 	retval = sdw_stream_add_slave(rt712->slave, &stream_config,


