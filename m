Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5D6127E18;
	Tue, 29 Apr 2025 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946464; cv=none; b=ATAylS8sd1TUrVzJTQq71MjvN68tc/EbKtoVJeuFRwyONjIddU/5Q8/WXeOnJ2UuMgAygphKIU2nSj+RldUZjKtT2L0IptPdct9gQ/k6w1L20nQk6/ZHMgZHELsDxPP8TLIJ8Oi7YQxGRESRbIfhryui9xRAMnfgVwlOo8ZvlPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946464; c=relaxed/simple;
	bh=2cKi2XNm0Nh6ojF1afRtys8G8UN5Y+8USri3oFP+tIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qndlHNRv5/YXt6b9aAjsFNB9jNWlpjS5KwE75/0yydQeeN626LO8PauI4Kg8K5zMCLLhSRImO+UCZh1KQA+4wHY9tFm6dZOP+IR3ZIjQovEAUhiUgBczR7tpVTz0FaVTVFVQin05+sx4UeMo11aRNq5VJ7374XIBPOVNa/LWp7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N71mm5VO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N71mm5VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D90CC4CEE3;
	Tue, 29 Apr 2025 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946463;
	bh=2cKi2XNm0Nh6ojF1afRtys8G8UN5Y+8USri3oFP+tIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N71mm5VO+9Tm4h4SysaY+ndMHFrSTYK54+r1vAYAh3V5ipVHZixxGu2x5Ymnqh/U+
	 SbtMDfLUScPV9b/QRX/rnuuUoqdPQH8p7lMOY+ulAKgqP+Axn6hpPwMTLOMKKAS2sx
	 anM3zVmRM2tUerOxjnWgv7V8DFuwk1DQo961JD2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 275/311] ASoC: fsl_asrc_dma: get codec or cpu dai from backend
Date: Tue, 29 Apr 2025 18:41:52 +0200
Message-ID: <20250429161132.282950686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ef5c23ae9ab380fa756f257411024a9b4518d1b9 ]

With audio graph card, original cpu dai is changed to codec device in
backend, so if cpu dai is dummy device in backend, get the codec dai
device, which is the real hardware device connected.

The specific case is ASRC->SAI->AMIX->CODEC.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250319033504.2898605-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_dma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index f501f47242fb0..1bba48318e2dd 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -156,11 +156,24 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 	for_each_dpcm_be(rtd, stream, dpcm) {
 		struct snd_soc_pcm_runtime *be = dpcm->be;
 		struct snd_pcm_substream *substream_be;
-		struct snd_soc_dai *dai = snd_soc_rtd_to_cpu(be, 0);
+		struct snd_soc_dai *dai_cpu = snd_soc_rtd_to_cpu(be, 0);
+		struct snd_soc_dai *dai_codec = snd_soc_rtd_to_codec(be, 0);
+		struct snd_soc_dai *dai;
 
 		if (dpcm->fe != rtd)
 			continue;
 
+		/*
+		 * With audio graph card, original cpu dai is changed to codec
+		 * device in backend, so if cpu dai is dummy device in backend,
+		 * get the codec dai device, which is the real hardware device
+		 * connected.
+		 */
+		if (!snd_soc_dai_is_dummy(dai_cpu))
+			dai = dai_cpu;
+		else
+			dai = dai_codec;
+
 		substream_be = snd_soc_dpcm_get_substream(be, stream);
 		dma_params_be = snd_soc_dai_get_dma_data(dai, substream_be);
 		dev_be = dai->dev;
-- 
2.39.5



