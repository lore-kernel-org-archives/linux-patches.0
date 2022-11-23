Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C031C1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C945C433D6;
	Wed, 23 Nov 2022 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196464;
	bh=XeV12e9wpqOz2i7cJoJEkFNDL6mHHsHjaONBu5UhXbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0UY5SW6BxzQhnh6srzZ7Lqp8oCRqz5HFUJr4Tc2mcKSMVaQeKHZXRqigIVAaS8TE
	 pdoBaorPixaKgWbFwly1sSCrFAT6mTCANEzcjqut5lbqQuLEqOzbLmnw/W31zEMHGk
	 AOvCEglcyUFTk1tGNWyXvA9YRzYEux9BbabW+Kws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 008/314] ASoC: rt5682s: Fix the TDM Tx settings
Date: Wed, 23 Nov 2022 09:47:33 +0100
Message-Id: <20221123084625.865700623@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit d94bf16e920047c9b4ea2b57f7b53b4ff5039d9f ]

Complete the missing and correct the TDM Tx settings.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20221012031320.6980-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 15 +++++++++++++--
 sound/soc/codecs/rt5682s.h |  1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index eb47e7cd485a..95fe993d59cb 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -1932,7 +1932,7 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		unsigned int rx_mask, int slots, int slot_width)
 {
 	struct snd_soc_component *component = dai->component;
-	unsigned int cl, val = 0;
+	unsigned int cl, val = 0, tx_slotnum;
 
 	if (tx_mask || rx_mask)
 		snd_soc_component_update_bits(component,
@@ -1941,6 +1941,16 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 		snd_soc_component_update_bits(component,
 			RT5682S_TDM_ADDA_CTRL_2, RT5682S_TDM_EN, 0);
 
+	/* Tx slot configuration */
+	tx_slotnum = hweight_long(tx_mask);
+	if (tx_slotnum) {
+		if (tx_slotnum > slots) {
+			dev_err(component->dev, "Invalid or oversized Tx slots.\n");
+			return -EINVAL;
+		}
+		val |= (tx_slotnum - 1) << RT5682S_TDM_ADC_DL_SFT;
+	}
+
 	switch (slots) {
 	case 4:
 		val |= RT5682S_TDM_TX_CH_4;
@@ -1961,7 +1971,8 @@ static int rt5682s_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 	}
 
 	snd_soc_component_update_bits(component, RT5682S_TDM_CTRL,
-		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK, val);
+		RT5682S_TDM_TX_CH_MASK | RT5682S_TDM_RX_CH_MASK |
+		RT5682S_TDM_ADC_DL_MASK, val);
 
 	switch (slot_width) {
 	case 8:
diff --git a/sound/soc/codecs/rt5682s.h b/sound/soc/codecs/rt5682s.h
index 7353831c73dd..b660a311b6c2 100644
--- a/sound/soc/codecs/rt5682s.h
+++ b/sound/soc/codecs/rt5682s.h
@@ -899,6 +899,7 @@
 #define RT5682S_TDM_RX_CH_8			(0x3 << 8)
 #define RT5682S_TDM_ADC_LCA_MASK		(0x7 << 4)
 #define RT5682S_TDM_ADC_LCA_SFT			4
+#define RT5682S_TDM_ADC_DL_MASK			(0x3 << 0)
 #define RT5682S_TDM_ADC_DL_SFT			0
 
 /* TDM control 2 (0x007a) */
-- 
2.35.1



