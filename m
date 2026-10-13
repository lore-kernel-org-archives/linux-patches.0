Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D0332EB1;
	Tue, 13 Oct 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894648; cv=none; b=NscKkvC6VRk9CqLaFlMlGw3I+sCdRHZR+dj/FS6SuXwhcCtMKFU5NPSn7Ft6ZinhngMDdyB/mbvhIY0XQmzAW21bdimOcPDBvaB39203kJq2LQfJKBL8155z3bbirFW6ocqrPtW3mkV+AIaaphZQC9aWy5TOcXI8p2J63EhIdoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894648; c=relaxed/simple;
	bh=KkYj+mK/qyY8mz/k/jA+BlzZvFnFtWXh8SieJDaKQvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rq4xn7cpp7hC5T/TtMYhPzhyiyLT/PrqVCxVB7p51znwVvZz7yIAV4XWaaoUvtiVzSkaLlZ+6YeZIPw5uHi4GcVOghlRaLAXkzkowe0L/BriY+wsjN4rTvdtVb5np2M4SL3Isfkt/V2nyOIHZqVBmUtlXO13EJne0g1I2mxpR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NA6iltZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NA6iltZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0123F1F00893;
	Tue, 13 Oct 2026 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894647;
	bh=Yrg/+ldMVJlCzw5h44ClmmfamrLMhRyq3pqBGEBIuoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NA6iltZoy/wdkhftrNgq8CIZ8XAanJQV9geirUPxePM82wxCvrriWz9X4ReGJ1zgZ
	 ZvKwAfkNcyP0Gw4zBeBs3nMZgnMfLWSzYvaq7Y/lMlUKsAp99N6KSaYFlZl87hKD2v
	 3aXhw8SKwGj4edjGFL0AsNgHzhux+06NJEcRuJ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/497] ASoC: sdw_utils: Set snd_soc_dai_link_ch_map.codec_ch_mask for capture
Date: Tue, 13 Oct 2026 13:32:57 +0200
Message-ID: <20261013112908.124067724@linuxfoundation.org>
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
index 70a7abede618f..44b132bc10439 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -764,7 +764,7 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai_link_ch_map *ch_maps;
 	int ch = params_channels(params);
-	unsigned int ch_mask;
+	unsigned int cpu_ch_mask, codec_ch_mask;
 	int num_codecs;
 	int step;
 	int i;
@@ -774,8 +774,9 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 
 	/* Identical data will be sent to all codecs in playback */
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		ch_mask = GENMASK(ch - 1, 0);
+		cpu_ch_mask = GENMASK(ch - 1, 0);
 		step = 0;
+		codec_ch_mask = 0;
 	} else {
 		num_codecs = rtd->dai_link->num_codecs;
 
@@ -785,17 +786,24 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
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



