Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836043AAF69;
	Sat, 17 Oct 2026 17:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256602; cv=none; b=O9LM9Kvq7MI3lCGyxVG6rf8aDG+BXzKVT2H9ApvbiuYNZVmWJ6vQX9IErWGXmQ3YnFQjL+ppHC73jtViPhx+S6Fc8FToCTEUcj+4waeCRJRt5yugR42MU94eyC4lZwH+3depib3OUpjoT+yYQgjPgPshXQLJodydQ87lpp+Tqhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256602; c=relaxed/simple;
	bh=j9IxIzZ4/MPA2NmAjFUQPl50GNP88wHM6P2fQaDtty0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPIcdZm01X8D3DOYsGDKbs4tuBlNZ8q5CjlC8pNof2Y3pHSd/Zl8OAR3Ta2tPaUwKzjs58ePAL6kglPf0nKAW3hGevRG4K4uQAJoFxmSBfAjD3MnZP8jfCrpHW6SO+IeZLekOH+eFBEbnqh1c91jfGG0zBkIITiQOup0eWScxcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7oJOwyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7oJOwyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8771F000C4;
	Sat, 17 Oct 2026 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256601;
	bh=hD8OTV20iY7QwnWqoO5yaF5yf79KpDZgIiOKMRqo7vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7oJOwySn8f5A9gA4XU5CerQc6NqyCIc90CumUw2xHdgc/Ph8GBWK712vkeNKQPq5
	 avayPE8zbfMzpovTDxvlFUwV/kvFvRNCgvMXk4d/Se5UHNZuqXVn4vX3SAg5MXPcw6
	 oWPnxjjEW1xyjcseW0hlaD+X1wGQtFP4frN//9RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0289/1674] ASoC: codecs: rt1017-sdca-sdw: fix uninitialized stream_config->type
Date: Sat, 17 Oct 2026 17:42:41 +0200
Message-ID: <20261017160438.532045081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

commit 174d160884199cad97413f33fe1b56027dc0d3e1 upstream.

stream_config is not initialized before being passed to
sdw_stream_add_slave().  The type field may contain garbage and is
later copied to stream->type by sdw_config_stream().

Zero-initialize stream_config so type defaults to SDW_STREAM_PCM.

While at it, use snd_sdw_params_to_config() helper instead of
open-coding the same logic.

Fixes: 2b7aecd58528 ("ASoC: rt1017: Add RT1017 SDCA amplifier driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260914104551.377880-1-yijiangshan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1017-sdca-sdw.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/sound/soc/codecs/rt1017-sdca-sdw.c
+++ b/sound/soc/codecs/rt1017-sdca-sdw.c
@@ -16,6 +16,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
+#include <sound/sdw.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
 
@@ -575,11 +576,10 @@ static int rt1017_sdca_pcm_hw_params(str
 {
 	struct snd_soc_component *component = dai->component;
 	struct rt1017_sdca_priv *rt1017 = snd_soc_component_get_drvdata(component);
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
-	enum sdw_data_direction direction;
 	struct sdw_stream_runtime *sdw_stream;
-	int retval, port, num_channels, ch_mask;
+	int retval, port;
 	unsigned int sampling_rate;
 
 	dev_dbg(dai->dev, "%s %s", __func__, dai->name);
@@ -593,28 +593,17 @@ static int rt1017_sdca_pcm_hw_params(str
 
 	/* SoundWire specific configuration */
 	/* port 1 for playback */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		direction = SDW_DATA_DIR_RX;
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		port = 1;
-	} else {
-		direction = SDW_DATA_DIR_TX;
+	else
 		port = 2;
-	}
-
-	num_channels = params_channels(params);
-	ch_mask = (1 << num_channels) - 1;
-
-	stream_config.frame_rate = params_rate(params);
-	stream_config.ch_count = num_channels;
-	stream_config.bps = snd_pcm_format_width(params_format(params));
-	stream_config.direction = direction;
 
-	port_config.ch_mask = ch_mask;
+	snd_sdw_params_to_config(substream, params, &stream_config, &port_config);
 	port_config.num = port;
 
 	dev_dbg(dai->dev, "frame_rate %d, ch_count %d, bps %d, direction %d, ch_mask %d, port: %d\n",
-		params_rate(params), num_channels, snd_pcm_format_width(params_format(params)),
-		direction, ch_mask, port);
+		stream_config.frame_rate, stream_config.ch_count, stream_config.bps,
+		stream_config.direction, port_config.ch_mask, port);
 
 	retval = sdw_stream_add_slave(rt1017->sdw_slave, &stream_config,
 				&port_config, 1, sdw_stream);


