Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1345317141;
	Mon, 13 Apr 2026 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098735; cv=none; b=dtHi8ZKFSi/fbdtNsQSR2l6pYt4jBfYR2jMulBJgxjIL9GYjPV/+SNfStNCzyX+qjaC5IpgfuT9ATdCp37pkUG2p5BMw4gIC9BYTdI+OqHBlH1wx8xsVKMPhgsK5AQZuzw8o5FNrY7wYF6alWvJ1Tils66o7ziwZ5DXawU0xIbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098735; c=relaxed/simple;
	bh=NlZwtqDok6SdB+0JWkY+CEvBU5O4HTxaHapQXI5eKS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr34r1fq+LfikQeXAHy6CzNN3rhMUHcs4Vv41gh3sbTMP7ttsAmX1DfVnAFSeEgyPWDEuET6lYoy8Q/9LXQeuLiv/rtl23y5ol6iIO8EDOdY9XzKeNEtKiFUlUjffLwaNdZ43ZVrbcSz6aRY6FGiYtK59cPMlrm94ByNTpJFsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6sY4TGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6sY4TGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F7AC2BCB3;
	Mon, 13 Apr 2026 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098735;
	bh=NlZwtqDok6SdB+0JWkY+CEvBU5O4HTxaHapQXI5eKS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6sY4TGjfakav5YECY0tvsfn07l0W3jBupi+86MxWsdmSojnUn1DqJsGzh1RdKimh
	 5/pe4lN2ny3mgnv0jmQSEqBf91rnwexCVzLz4tUc9x7r+BUfFuPXlm/sgjsE3hYUQm
	 VS1RXuTBDZrxCXGzG+bLSD1OxtE77ZOxyBUpEMl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/491] ASoC: soc-core: move snd_soc_runtime_set_dai_fmt() to upside
Date: Mon, 13 Apr 2026 17:55:12 +0200
Message-ID: <20260413155821.555359112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 4d1a98b5f1abaad0ba7177fdb389a9f78584bc3a ]

This patch moves snd_soc_runtime_set_dai_fmt() to upside.
This is prepare to support snd_soc_runtime_get_dai_fmt().

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87im34nc9r.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 95bc5c225513 ("ASoC: soc-core: flush delayed work before removing DAIs and widgets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 124 +++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 8620e415f6fce..71219ceea3934 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1055,6 +1055,68 @@ int snd_soc_add_pcm_runtime(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_add_pcm_runtime);
 
+/**
+ * snd_soc_runtime_set_dai_fmt() - Change DAI link format for a ASoC runtime
+ * @rtd: The runtime for which the DAI link format should be changed
+ * @dai_fmt: The new DAI link format
+ *
+ * This function updates the DAI link format for all DAIs connected to the DAI
+ * link for the specified runtime.
+ *
+ * Note: For setups with a static format set the dai_fmt field in the
+ * corresponding snd_dai_link struct instead of using this function.
+ *
+ * Returns 0 on success, otherwise a negative error code.
+ */
+int snd_soc_runtime_set_dai_fmt(struct snd_soc_pcm_runtime *rtd,
+				unsigned int dai_fmt)
+{
+	struct snd_soc_dai *cpu_dai;
+	struct snd_soc_dai *codec_dai;
+	unsigned int inv_dai_fmt;
+	unsigned int i;
+	int ret;
+
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		ret = snd_soc_dai_set_fmt(codec_dai, dai_fmt);
+		if (ret != 0 && ret != -ENOTSUPP)
+			return ret;
+	}
+
+	/*
+	 * Flip the polarity for the "CPU" end of a CODEC<->CODEC link
+	 * the component which has non_legacy_dai_naming is Codec
+	 */
+	inv_dai_fmt = dai_fmt & ~SND_SOC_DAIFMT_MASTER_MASK;
+	switch (dai_fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		inv_dai_fmt |= SND_SOC_DAIFMT_CBS_CFS;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		inv_dai_fmt |= SND_SOC_DAIFMT_CBS_CFM;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		inv_dai_fmt |= SND_SOC_DAIFMT_CBM_CFS;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		inv_dai_fmt |= SND_SOC_DAIFMT_CBM_CFM;
+		break;
+	}
+	for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+		unsigned int fmt = dai_fmt;
+
+		if (cpu_dai->component->driver->non_legacy_dai_naming)
+			fmt = inv_dai_fmt;
+
+		ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
+		if (ret != 0 && ret != -ENOTSUPP)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_runtime_set_dai_fmt);
+
 static int soc_init_pcm_runtime(struct snd_soc_card *card,
 				struct snd_soc_pcm_runtime *rtd)
 {
@@ -1404,68 +1466,6 @@ static void soc_remove_aux_devices(struct snd_soc_card *card)
 	}
 }
 
-/**
- * snd_soc_runtime_set_dai_fmt() - Change DAI link format for a ASoC runtime
- * @rtd: The runtime for which the DAI link format should be changed
- * @dai_fmt: The new DAI link format
- *
- * This function updates the DAI link format for all DAIs connected to the DAI
- * link for the specified runtime.
- *
- * Note: For setups with a static format set the dai_fmt field in the
- * corresponding snd_dai_link struct instead of using this function.
- *
- * Returns 0 on success, otherwise a negative error code.
- */
-int snd_soc_runtime_set_dai_fmt(struct snd_soc_pcm_runtime *rtd,
-	unsigned int dai_fmt)
-{
-	struct snd_soc_dai *cpu_dai;
-	struct snd_soc_dai *codec_dai;
-	unsigned int inv_dai_fmt;
-	unsigned int i;
-	int ret;
-
-	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		ret = snd_soc_dai_set_fmt(codec_dai, dai_fmt);
-		if (ret != 0 && ret != -ENOTSUPP)
-			return ret;
-	}
-
-	/*
-	 * Flip the polarity for the "CPU" end of a CODEC<->CODEC link
-	 * the component which has non_legacy_dai_naming is Codec
-	 */
-	inv_dai_fmt = dai_fmt & ~SND_SOC_DAIFMT_MASTER_MASK;
-	switch (dai_fmt & SND_SOC_DAIFMT_MASTER_MASK) {
-	case SND_SOC_DAIFMT_CBM_CFM:
-		inv_dai_fmt |= SND_SOC_DAIFMT_CBS_CFS;
-		break;
-	case SND_SOC_DAIFMT_CBM_CFS:
-		inv_dai_fmt |= SND_SOC_DAIFMT_CBS_CFM;
-		break;
-	case SND_SOC_DAIFMT_CBS_CFM:
-		inv_dai_fmt |= SND_SOC_DAIFMT_CBM_CFS;
-		break;
-	case SND_SOC_DAIFMT_CBS_CFS:
-		inv_dai_fmt |= SND_SOC_DAIFMT_CBM_CFM;
-		break;
-	}
-	for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
-		unsigned int fmt = dai_fmt;
-
-		if (cpu_dai->component->driver->non_legacy_dai_naming)
-			fmt = inv_dai_fmt;
-
-		ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
-		if (ret != 0 && ret != -ENOTSUPP)
-			return ret;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(snd_soc_runtime_set_dai_fmt);
-
 #ifdef CONFIG_DMI
 /*
  * If a DMI filed contain strings in this blacklist (e.g.
-- 
2.51.0



