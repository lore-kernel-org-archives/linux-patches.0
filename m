Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83B39EF12;
	Wed, 23 Sep 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174429; cv=none; b=W1Y7o/S7wF/oDJoIwFqpVBVeNsA9FycTQPvC04hzDY7eqUVwkxWxG64rfSbAsSVvP84Duo1uFSqYe1Rm4BIrJim03lVo349cCOttXsQNb1GRGeM8SeF8+I+YneMPzQD860ZvWSnQ0eebdcXq8Bgk3w4/t+MEg69OvedxWmNmlxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174429; c=relaxed/simple;
	bh=doOgkExQTeKR+Aw/WbGqWYUOoyieVQI3UPDrcOedMNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2Vi+qVR1Nz3fIhGCJywiaWdZkR7x4ywFk/zPNrR7BsfR857s4dgpjsNXw4sRENXFocBBkA5w4AqY6qe84LG41+hJNDKBX1QO+JGK3DpN9QhtbpQr/aaoi8yp2z8sz1Nv1unVEyTy4/z3SkCfxxf011kp4cv4g9vidlgpKFVMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RETztg5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RETztg5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A9D1F000FF;
	Wed, 23 Sep 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174428;
	bh=RNt4Mr+APMLCLX+c6rcQQwv1VqZoxkMLOyxAO9Err5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RETztg5sEQOWJY9voLQrF3VNrgai7cX3zaZn0Xb0bnbisVBqwjzt1l/hLRimUvGi4
	 oFUl/ChsadA4+axAMFM4sPhGjerlLT+MSHdzSDczd8IAjyxBKuJMM+PxK2e0wS5x5L
	 cTPvEXzn8n267CYjoEIFhqzykoDzK1KiKgUQXEXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/398] ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params
Date: Wed, 23 Sep 2026 16:03:06 +0200
Message-ID: <20260923140646.345919241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index ebd766e00bac6..b6e35cfe50b7c 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1075,7 +1075,9 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		goto out;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		unsigned int tdm_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
+		unsigned int ch_mask = snd_soc_dai_tdm_mask_get(codec_dai, substream->stream);
+		struct snd_soc_dai_link_ch_map *ch_maps;
+		int j;
 
 		/*
 		 * Skip CODECs which don't support the current stream type,
@@ -1097,9 +1099,15 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
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



