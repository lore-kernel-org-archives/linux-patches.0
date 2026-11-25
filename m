Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624903;
	b=ozedO2L5iw5WPSF7epaK0AYVFOdVn44/ZRKgNuVcTOToeBkz5UNxcg7SQABCW68Vs3Lx
	 v6jPAjU2DWGsWRZZ99avIdvngDn3cMuULnvvBJeGNmBM6g5k8fqYSvNcYLTpiZCyeTQe9
	 efMnvOu2ZKBWxM+mTx4jra0oGFNXbf20ujt0IBjPwjZ4cC37+fg3Wd2PNYHr56JhEnkwR
	 1oqR/C92oa8zFMem1hQxtiEYarVm/Km2e+76I46d2X9oT8tdXHkhiN7toAOTABXLdxd8W
	 20XYITMth6sY47t32xT+0zbn3ij+ZUIgiuAq92qTlDbErja1lQ4M8llMed5yC1BKo2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YXbeFS80jqutf4ODeL+KfqUQJDJ8KGPI9Fa6otFSKU=;
	b=gTxwhpj5nnm7hFJuGG6t8dcIvDjqElVqZIi0qmkckT1r0i0GIVGrlQkMHDXx3Y80+0+C
	 DzR1BS3xUdPwRTrobxfRl2F5rfeS9Yrz2I2W+JKLtWWOJeR+bfp9qbfJA1X+veE7aLau6
	 4GL4NOQx0ocXDv8YiPdh8c2X4L2QFNrS+FEe0ltCQPh2jrhhtBSYKOyfc7/BcXMAzekz3
	 VIDbuX3RlofDsoPpNiaJsxBqwZfNDWQIP0jiYde4FSgYCTz7ALM8G7v5wwsf/o/Zaz6iQ
	 522C3FkHs/7okLRAdv6wEksYNNdBK1w7Rh1ng6HHdExVDBZ+OzsfIIOPCmvokAJbc6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBYHZufh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892CC606A31E;
	Wed, 25 Nov 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MBYHZufh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A862B1F000D3;
	Wed, 25 Nov 2026 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624903;
	bh=9YXbeFS80jqutf4ODeL+KfqUQJDJ8KGPI9Fa6otFSKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBYHZufhau+RFIzBMQSCkLp5M4uNynbaSmH4dM8/5vXiSrG8HscMQGZ/mmalNv9M6
	 oeQEixiSREEwhwM4kdFrmmIfWQYss4R1OecwW2VVbeHjQAv9w5w5sXLxYD6U91b/Lk
	 xCgNeOugCewMVKZOc72X1UmbJe42PmuAXnK20Rb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/816] ASoC: max98090: keep the MIC boost across mic input power-up
Date: Wed, 25 Nov 2026 15:31:31 +0100
Message-ID: <20261125143857.137779333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LiangCheng Wang <zaq14760@gmail.com>

[ Upstream commit 58d51fa6ff1d21e79c3c340bfb3155dfa3025ca3 ]

PA1EN/PA2EN select both the MIC1/MIC2 preamp enable and its gain
(0 = off, 1 = 0 dB, 2 = +20 dB, 3 = +30 dB). "MICn Boost Volume" keeps
the selected gain in max98090->pa1en/pa2en while the input is off, and
max98090_micinput_event() writes it to the field when the "MICn Input"
widget powers up.

The event handler also reads the field back to keep the stored gain in
sync ("Update for volatile"), but it does so on POST_PMU and POST_PMD.
The widget drives PA1EN/PA2EN as a single enable bit, the low bit of
the field, so at both points DAPM has just rewritten it:

  - POST_PMU: DAPM has set the field to 1, so the read-back stores
    0 dB and the handler then restores 0 dB.
  - POST_PMD: DAPM has cleared the low bit, so a +30 dB (3) gain reads
    back as +20 dB (2).

As a result every capture starts at 0 dB: a boost set while the input is
powered down, e.g. restored by alsactl or an audio HAL at boot, never
takes effect, and one changed during capture is lost at the next
power-up.

Read the field back on PRE_PMD instead, while it still holds the active
gain, and only restore the stored gain on POST_PMU.

Tested on i.MX95 with a MAX98090 headset mic on MIC1, running NXP's
6.18.38 vendor kernel (max98090_micinput_event() is the same as in
mainline): with MIC1 Boost Volume set to 2 (+30 dB) before capture,
register 0x10 reads 0x20 (0 dB) during capture without this change and
0x60 (+30 dB) with it, and a boost changed during capture is kept for
the next capture.

Fixes: 685e42154dcf ("ASoC: Replace max98090 Device Driver")
Signed-off-by: LiangCheng Wang <zaq14760@gmail.com>
Link: https://patch.msgid.link/20261111-max98090-mic-boost-v1-1-20b9bd8816db@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 9253707bccde9..8d5a8bfde13b9 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -743,14 +743,6 @@ static int max98090_micinput_event(struct snd_soc_dapm_widget *w,
 	else
 		val = (val & M98090_MIC_PA2EN_MASK) >> M98090_MIC_PA2EN_SHIFT;
 
-	if (val >= 1) {
-		if (w->reg == M98090_REG_MIC1_INPUT_LEVEL) {
-			max98090->pa1en = val - 1; /* Update for volatile */
-		} else {
-			max98090->pa2en = val - 1; /* Update for volatile */
-		}
-	}
-
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
 		/* If turning on, set to most recently selected volume */
@@ -759,6 +751,14 @@ static int max98090_micinput_event(struct snd_soc_dapm_widget *w,
 		else
 			val = max98090->pa2en + 1;
 		break;
+	case SND_SOC_DAPM_PRE_PMD:
+		if (val >= 1) {
+			if (w->reg == M98090_REG_MIC1_INPUT_LEVEL)
+				max98090->pa1en = val - 1;
+			else
+				max98090->pa2en = val - 1;
+		}
+		return 0;
 	case SND_SOC_DAPM_POST_PMD:
 		/* If turning off, turn off */
 		val = 0;
@@ -1108,11 +1108,13 @@ static const struct snd_soc_dapm_widget max98090_dapm_widgets[] = {
 
 	SND_SOC_DAPM_PGA_E("MIC1 Input", M98090_REG_MIC1_INPUT_LEVEL,
 		M98090_MIC_PA1EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
-		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD |
+		SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_PGA_E("MIC2 Input", M98090_REG_MIC2_INPUT_LEVEL,
 		M98090_MIC_PA2EN_SHIFT, 0, NULL, 0, max98090_micinput_event,
-		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_POST_PMD),
+		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD |
+		SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_MIXER("LINEA Mixer", SND_SOC_NOPM, 0, 0,
 		&max98090_linea_mixer_controls[0],
-- 
2.53.0



