Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AE5449B23;
	Wed, 23 Sep 2026 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173040; cv=none; b=ZK9zmgpKMpdNFI58hRffS1lfkpyW2KE3I49XDn+fSuPkdpE0KiE3mFS86JNNLuJTsNAkaNkbge/Sb4Itek9NY/Ck3kMzpFhaOFBnaSNZYBTAcOiyNKfPKnvkd3aaUFS/NpDZpRBaDZcGvEjAYAZCtxdoXmKPdFhPqRrnyYKMVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173040; c=relaxed/simple;
	bh=mA9ztZe3XuS7SnhR51sT3OccO/LCl+oMJYxaelOsRWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNASRB+QBQkeVc4IkpXSQANwwt8XdgrsIw+sh6oCHPapb6a404g81lW/uduKLOkgEQxlWfY3LKXbzy3D/SdcyZukF/gqId4B1h6ry4GMKSSUP8Rm/SE9WREICQzcEKieMmCW1sMonBS51jlzHbtg5ZJCRy4dOfFKRABSeFRPx9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REaXYqZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REaXYqZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8271F000FF;
	Wed, 23 Sep 2026 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173039;
	bh=Ggc7h4JmAAX0QhaNWKrzmro+n8tQSIwLajzIlhTXlTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REaXYqZJSNWNGCUT0pQhLUFHOkIzi+6rwLtm3BHIr7TEgzumqORe/z/0lVJdRm4BK
	 yy77eBzfTADGGtH1LvB2fLkK6fCRSqrFNrZ+wotW81UUHG/jcf6ZzEw2S4TlmNUUPZ
	 o5qz7IjviyZ1b4kLUWlrrO6MmcCsm5LKL1k4zT50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 133/438] ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params
Date: Wed, 23 Sep 2026 16:02:34 +0200
Message-ID: <20260923140648.228139111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 6b382bdfe26a2232091bf743e454e6794295783e ]

In __soc_pcm_hw_params() if there is a snd_soc_dai_link_ch_map with
non-zero codec_ch_mask, use that channel mask to restrict which channels
are enabled on the codec. But only if there isn't a TDM mask.

It is possible that a snd_soc_dai_link_ch_map could include the same codec
multiple times on different CPUs so the for_each_rtd_ch_maps() loop
accumulates the channel masks for all entries of that codec.

If a TDM mask was also set, it takes priority and is used instead of any
possible snd_soc_dai_link_ch_map entries. (They cannot be ANDed together
because the bit positions are indicating different things: TDM is a bit
for each TDM slot, codec_ch_mask is a bit for each codec channel.)

This fixes a problem of incorrect TX channels enabled on the codec when
multiple codecs are aggregated on a single capture link. For example:

- Two CPUs with six 4-channel codecs.
- The machine driver chooses to assign one channel from each codec to
  one channel on the CPU
- But the codec hw_params() would be passed a channel count of 6, which
  (a) is more channels than the codec has and (b) allows enabling channels
  that should not be driving the audio bus.

Fixes: ac950278b087 ("ASoC: add N cpus to M codecs dai link support")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260910114500.1586637-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index cb64ced211494..3137c091bdb88 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1206,7 +1206,9 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		goto out;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		unsigned int tdm_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
+		unsigned int ch_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
+		struct snd_soc_dai_link_ch_map *ch_maps;
+		int j;
 
 		/*
 		 * Skip CODECs which don't support the current stream type,
@@ -1228,9 +1230,15 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		/* copy params for each codec */
 		tmp_params = *params;
 
-		/* fixup params based on TDM slot masks */
-		if (tdm_mask)
-			soc_pcm_codec_params_fixup(&tmp_params, tdm_mask);
+		/* fixup params based on TDM or ch_map masks */
+		if (!ch_mask) {
+			for_each_rtd_ch_maps(rtd, j, ch_maps)
+				if (ch_maps->codec == i)
+					ch_mask |= ch_maps->codec_ch_mask;
+		}
+
+		if (ch_mask)
+			soc_pcm_codec_params_fixup(&tmp_params, ch_mask);
 
 		ret = snd_soc_dai_hw_params(codec_dai, substream,
 					    &tmp_params);
-- 
2.53.0



