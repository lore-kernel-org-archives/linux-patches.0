Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D994E4C3A;
	Fri,  9 Oct 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556929; cv=none; b=ZDXyfirIx3t6jUmobdviZD+zY7iQ0Dk6Bt9KhQoq7UpCUuIopnXuUp/05J4sYIitBb42zKaDyUHuusvBFyiRe7an9YeHQAFweL9xqsT6f8mxHN5p2Yk7fsEIkGMIBR3xdninyFm4ly4xS4gOt6tKajcpk8WWtOILIfh6lyhTYTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556929; c=relaxed/simple;
	bh=prVpvr9nU+gwLvESPhJ662FAYtxwQC63InZZBmeEsSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txEe1Q6d/AmeNOyXq0NH5lZtcZD2hH+YcRn4W5ENQ9rcdtuMOaVD8Pc+PmXH7jSDKy0EW7pQ0HRiIwvNj2Arj6re7t0VA8hBF4UrXEp8v5uFlLo+dh4MK/t8LUlMKiGoqL+Y1IsZoghA48IOK1tESvO8h7LnzOxyO29vuuvCL/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQ7FuhhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQ7FuhhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A111F000FF;
	Fri,  9 Oct 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556928;
	bh=GCTeJeFdeA0ez6FioiPd87HVRvVWzvP/VdVmLXxmyKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ7FuhhO5aX/NtGvt4cV0BJXzU1RGlEpQk38rnAbbu3/hejY/dQ3eWvwXIgzlHHpD
	 ckWTfHPY7dGNm+t+++a7uNjETVSrZ5cItLf8feVee9Y0IGEDdz7+dysBErC5d5IcJ8
	 hgzJxjwCeuzGOHmAAEfryTfZFKRsXj/dHM1ttYX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 265/428] ASoC: codecs: rt1017-sdca-sdw: fix uninitialized stream_config->type
Date: Fri,  9 Oct 2026 16:10:02 +0200
Message-ID: <20261009140951.918256657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -15,6 +15,7 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
+#include <sound/sdw.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
 
@@ -573,11 +574,10 @@ static int rt1017_sdca_pcm_hw_params(str
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
@@ -591,28 +591,17 @@ static int rt1017_sdca_pcm_hw_params(str
 
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


