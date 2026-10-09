Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC24E2F16;
	Fri,  9 Oct 2026 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555343; cv=none; b=hVjqmvo6V3zIv/vuE4IzEU81ITVGg7aysuo4GRgBzRbmyjUbDoWG+oypk3OFr/jQTfMSW3dh/EZ7q5vlNYsXX/eNtkRfUAvndLVzbv9bB//7B/3O2NM4x4fTNHlIGaqZDrvE2nHVtTTDE1nmQoVs6Wtzgf4dLCUqAIZCX+bcrUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555343; c=relaxed/simple;
	bh=vWPivKxU03hln8YZeBtbOZ1hjoJsh/2LGyFTM9Wpvm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NViNYzAFEehwQ/MegO815uXOrakCM78uhsk3+MNVszEWt0a6tlPTd4u4AketL9L80G4JoSQyHUDjw9KWqBSwDJgdgqGqj1hNdvV0EMoEh4ip2qcPUHX1CZJC2bjLbF+H0qFUIt35E2xK8VKYSplCYf8rh751tA6RL16a+9QOOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwGIV+1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwGIV+1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67F51F0089A;
	Fri,  9 Oct 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555333;
	bh=J2vL7Hl0fZ/eOlGUS5viQKMaVWc4XCQy28altWKna0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwGIV+1vt/KJ4y02CKbOEzWnXBk2T/PMQF9Gw0Yr9+sE9wIwfkRCdMpWE3m137R2u
	 r0CXvADBPAE8OKY3pfIwJrwM0cAfp+T65ATBH+MyDc9T9hYdhYIhqcb6bAFvWEo1SF
	 JxbKjEtgztqUU2P20afQYi6CdBqZBYTK8dlFeAdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/403] ASoC: sdw_utils: Set snd_soc_dai_link_ch_map.codec_ch_mask for capture
Date: Fri,  9 Oct 2026 16:06:12 +0200
Message-ID: <20261009140952.383604718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 290845e151cd4e307cc1f25319583aaceb4eeb30 ]

In asoc_sdw_hw_params() set the codec_ch_mask member of struct
snd_soc_dai_link_ch_map for capture streams. ASoC will then pass the
correct number of channels to each codec hw_params(). This prevents
trying to enable more channels on the codec DP than have been allocated
bitslots in the SoundWire frame, which would cause bus clash errors.

In theory codec_ch_mask could also be set for playback streams, but for
those the CPU is the only sender so there is no risk of bus clash.
For playback streams codec_ch_mask is set to 0 to preserve the existing
behavior and avoid introducing bugs.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260910114500.1586637-5-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index fd0092eb79245..03cb4a8c79b4a 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -943,7 +943,7 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai_link_ch_map *ch_maps;
 	int ch = params_channels(params);
-	unsigned int ch_mask;
+	unsigned int cpu_ch_mask, codec_ch_mask;
 	int num_codecs;
 	int step;
 	int i;
@@ -953,8 +953,9 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 
 	/* Identical data will be sent to all codecs in playback */
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		ch_mask = GENMASK(ch - 1, 0);
+		cpu_ch_mask = GENMASK(ch - 1, 0);
 		step = 0;
+		codec_ch_mask = 0;
 	} else {
 		num_codecs = rtd->dai_link->num_codecs;
 
@@ -964,17 +965,24 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 			return -EINVAL;
 		}
 
-		ch_mask = GENMASK(ch / num_codecs - 1, 0);
-		step = hweight_long(ch_mask);
+		cpu_ch_mask = GENMASK(ch / num_codecs - 1, 0);
+		step = hweight_long(cpu_ch_mask);
+		codec_ch_mask = cpu_ch_mask;
 	}
 
 	/*
 	 * The captured data will be combined from each cpu DAI if the dai
 	 * link has more than one codec DAIs. Set codec channel mask and
 	 * ASoC will set the corresponding channel numbers for each cpu dai.
+	 *
+	 * sdw_stream_add_slave() assigns different payload offsets to each
+	 * codec in a capture stream, so that the same channels on each
+	 * codec map to different channels on the CPU.
 	 */
-	for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
-		ch_maps->cpu_ch_mask = ch_mask << (i * step);
+	for_each_link_ch_maps(rtd->dai_link, i, ch_maps) {
+		ch_maps->cpu_ch_mask = cpu_ch_mask << (i * step);
+		ch_maps->codec_ch_mask = codec_ch_mask;
+	}
 
 	return 0;
 }
-- 
2.53.0



