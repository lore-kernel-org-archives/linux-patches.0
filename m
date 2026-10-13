Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F080536B906;
	Tue, 13 Oct 2026 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895145; cv=none; b=dO+f/9yVbifpU96DgIenDXarcV2/w56VQuMh2bh5S+OzLsW/ItdoU3IhqBCaFhj9XTFnZDKUtUb2xsaB5dpHyf5OJ9AO11UtsRld+CbFj/KpjQWcpOqGhn8tPtt8fGNbIboY/+X2d6kO3s2G9Lb6Xz5MyCT0p+WzESav3DYQ7rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895145; c=relaxed/simple;
	bh=U0qexg/UcEPoF8x+ywBece6/Fjs/ML7Tg58N2pPCeVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhQZG7EcwCee+4t8z0HF130+QSzg6Z+gCgTC2YK3jKCJe9gJ1pWf3JTNuz4Qn98TgZU5IbFmnVJ/SkyzYHLm1sp8GqzFaLnZ8eYs/QwQUWaWrA+ZelPWeagC36HrCDE9ZyBXCex0XC1429oZWhxGOWhZ6aVsedJgMhKyu/h7wx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hy5hDh1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy5hDh1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C41F000FF;
	Tue, 13 Oct 2026 12:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895143;
	bh=zkx/tGMfD+5qIg8Y+pMp0EMxeBMxZPqwHCcH9NcCncw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hy5hDh1F22gVO94bYHsFtQAfgYlhc1oOs7Dui6EZ6KuNYd+DvRK1yFgBLBKPX0EXZ
	 8RVdzLrTsWqE2Vr4LYsHGmFwAT7CcaK6PQctsM4qVp7Ev+4MWKowIzxMD7RJeHrduT
	 KgW5FFwW8fovKyWTUqkBkztDKfwVCYiWDPXkITeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 174/497] ASoC: codecs: rt1017-sdca-sdw: fix uninitialized stream_config->type
Date: Tue, 13 Oct 2026 13:35:41 +0200
Message-ID: <20261013112912.020392590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


