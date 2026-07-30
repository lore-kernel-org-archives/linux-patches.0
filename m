Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C80C3AA187;
	Thu, 30 Jul 2026 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424804; cv=none; b=Qf/TOjxrPXrGXb9HrEZDPQF2XLQpOGuu0U8p1snODUFlQX74YwtxITYoVF87OYdjcGP2G3HJlTTBB5woJbmsOV0QJnI5NzJjclzBRKQPqITVO0BNnIFP20DTL/k0U0AFfLQIW5H0kBEr/YKs0r9pGckjG18pX6shjasYN3gq7D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424804; c=relaxed/simple;
	bh=shBnyx25938dUKuftzOgMHeTUttPgFkfpJZsLRKwAdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JanqXk++AHjAIAIkQ5j2zqibNTrYlgPG2CTH20+7NCIiJXmf9o9eghAwkdG0/0FeLr5oyNsICzfK43L1ATsZJaHKV8CjFNez93Ik/OHc/uJtYV9dNSFZVhnZf+ptWwdr4J/3uz2FNd9nUOavt3oSyx4pekwDBEvyPzEJTSpAE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSAaGPRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSAaGPRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00F81F000E9;
	Thu, 30 Jul 2026 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424803;
	bh=Ree9FNp8xZ0ikf5+OTxblm4WgcrE8yySS70SEGugxx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSAaGPRjHkOzPvtJ/+GNxlhGvo9234xSSVFZ72+5+4NLaG5E7bVcP4wI/82tgIXwz
	 LpOvG7z42htJhxowS7kJecJOwT24ABQvdxlFhuYa8t7vcFg4g1HUQvM3pbjHC+abom
	 Lw+qWSow6xWsCeqTPaNOwvO9Gv+ax0uS2SydY4Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 522/675] ASoC: fsl: imx-card: Skip sysclk reset for active DAIs in shutdown
Date: Thu, 30 Jul 2026 16:14:12 +0200
Message-ID: <20260730141456.233799733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Chancel Liu <chancel.liu@nxp.com>

commit 9f86aea992568c2b4db78c80ff9508af9e050ff7 upstream.

In a full-duplex setup, when one direction (playback or capture) is
closed while the other is still running, imx_aif_shutdown() was
unconditionally calling snd_soc_dai_set_sysclk() with rate=0 for all
cpu/codec DAIs, which would disable the clock still needed by the
active stream.

Add snd_soc_dai_active() checks before clearing sysclk so that only
truly inactive DAIs have their clocks reset.

Fixes: 2260bc6ea8bd ("ASoC: imx-card: Add WM8524 support")
Cc: stable@vger.kernel.org
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://patch.msgid.link/20260710031333.3491445-1-chancel.liu@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/imx-card.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index a4518fefad69..43438af1e1c6 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -496,11 +496,15 @@ static void imx_aif_shutdown(struct snd_pcm_substream *substream)
 	struct snd_soc_dai *codec_dai;
 	int i;
 
-	for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-		snd_soc_dai_set_sysclk(cpu_dai, 0, 0, SND_SOC_CLOCK_OUT);
+	for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+		if (!snd_soc_dai_active(cpu_dai))
+			snd_soc_dai_set_sysclk(cpu_dai, 0, 0, SND_SOC_CLOCK_OUT);
+	}
 
-	for_each_rtd_codec_dais(rtd, i, codec_dai)
-		snd_soc_dai_set_sysclk(codec_dai, 0, 0, SND_SOC_CLOCK_IN);
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		if (!snd_soc_dai_active(codec_dai))
+			snd_soc_dai_set_sysclk(codec_dai, 0, 0, SND_SOC_CLOCK_IN);
+	}
 }
 
 static const struct snd_soc_ops imx_aif_ops = {
-- 
2.55.0



