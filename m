Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F918E03D;
	Mon, 28 Oct 2024 06:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098489; cv=none; b=FF4Q/4gcZh9Ptp2uy4xymRlMwhnnVDhDu39qp+iEIGeLjzX7n7+vn4FrAZ8Owca+I/vbWpoFKRQ+evhq5rYqd5RLE3CbTXUfOLHyK1mCuRVQHQjJm2HoCr+dAbrFJbvwfwNuCbWke+cKkupA2waDeX+meq19pXdEXXVzzBLDvbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098489; c=relaxed/simple;
	bh=AG9b5hFO3EJi5ekIWW7AqSXt6cDYPSpCEkhOBaob8GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g16Va536YCsE/gO30rcaf0jvQXclewl064zsaJFKONd3jQGkMDTEAizrSc1C8nW1Co3Er6jwsYc8X0uTszDcN1o4NjS28e9e/3Fi7H7/dGk8FBTprE2GDqjBi7UFU0zmNvzvR/nQWzFoZAtWf4+Pp2jgD5w4RotJOD/AZvW0v8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBAToz+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBAToz+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF38C4CEC3;
	Mon, 28 Oct 2024 06:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098489;
	bh=AG9b5hFO3EJi5ekIWW7AqSXt6cDYPSpCEkhOBaob8GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBAToz+Bz8BvpiaPi2ySbSS4oP+pf4aqxCNrbx/tlf1i4cmxfPYl9pt9cPdLCh2AK
	 D/U3W8Kvb49dyCLncK294FYuOESdQvGyalrkJBpGElMOnSuCSaEX17PGsgBMX+vgdr
	 TLQHGvbNZhPPzXU4LZv608HXVBRLix5oXPq7OlIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Steev Klimaszewski <steev@kali.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 248/261] ASoC: qcom: sc7280: Fix missing Soundwire runtime stream alloc
Date: Mon, 28 Oct 2024 07:26:30 +0100
Message-ID: <20241028062318.328406242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit db7e59e6a39a4d3d54ca8197c796557e6d480b0d upstream.

Commit 15c7fab0e047 ("ASoC: qcom: Move Soundwire runtime stream alloc to
soundcards") moved the allocation of Soundwire stream runtime from the
Qualcomm Soundwire driver to each individual machine sound card driver,
except that it forgot to update SC7280 card.

Just like for other Qualcomm sound cards using Soundwire, the card
driver should allocate and release the runtime.  Otherwise sound
playback will result in a NULL pointer dereference or other effect of
uninitialized memory accesses (which was confirmed on SDM845 having
similar issue).

Cc: stable@vger.kernel.org
Cc: Alexey Klimov <alexey.klimov@linaro.org>
Cc: Steev Klimaszewski <steev@kali.org>
Fixes: 15c7fab0e047 ("ASoC: qcom: Move Soundwire runtime stream alloc to soundcards")
Link: https://lore.kernel.org/r/20241010054109.16938-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241012101108.129476-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/Kconfig  |    1 +
 sound/soc/qcom/sc7280.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/sound/soc/qcom/Kconfig
+++ b/sound/soc/qcom/Kconfig
@@ -208,6 +208,7 @@ config SND_SOC_SC7280
 	tristate "SoC Machine driver for SC7280 boards"
 	depends on I2C && SOUNDWIRE
 	select SND_SOC_QCOM_COMMON
+	select SND_SOC_QCOM_SDW
 	select SND_SOC_LPASS_SC7280
 	select SND_SOC_MAX98357A
 	select SND_SOC_WCD938X_SDW
--- a/sound/soc/qcom/sc7280.c
+++ b/sound/soc/qcom/sc7280.c
@@ -23,6 +23,7 @@
 #include "common.h"
 #include "lpass.h"
 #include "qdsp6/q6afe.h"
+#include "sdw.h"
 
 #define DEFAULT_MCLK_RATE              19200000
 #define RT5682_PLL_FREQ (48000 * 512)
@@ -316,6 +317,7 @@ static void sc7280_snd_shutdown(struct s
 	struct snd_soc_card *card = rtd->card;
 	struct sc7280_snd_data *data = snd_soc_card_get_drvdata(card);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
 	switch (cpu_dai->id) {
 	case MI2S_PRIMARY:
@@ -333,6 +335,9 @@ static void sc7280_snd_shutdown(struct s
 	default:
 		break;
 	}
+
+	data->sruntime[cpu_dai->id] = NULL;
+	sdw_release_stream(sruntime);
 }
 
 static int sc7280_snd_startup(struct snd_pcm_substream *substream)
@@ -347,6 +352,8 @@ static int sc7280_snd_startup(struct snd
 	switch (cpu_dai->id) {
 	case MI2S_PRIMARY:
 		ret = sc7280_rt5682_init(rtd);
+		if (ret)
+			return ret;
 		break;
 	case SECONDARY_MI2S_RX:
 		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
@@ -360,7 +367,8 @@ static int sc7280_snd_startup(struct snd
 	default:
 		break;
 	}
-	return ret;
+
+	return qcom_snd_sdw_startup(substream);
 }
 
 static const struct snd_soc_ops sc7280_ops = {


