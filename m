Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22799BA36
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A682C433C0;
	Mon, 26 Jun 2023 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804439;
	bh=qM1zyWhIcnuGdrWVUOFioXZD/zskQZe1GJXMqbI3dQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpxtZkl1sayadIny21lL6AQ/+XGp4tsNRofcX/FgN1o449JEKuoL1WcWgwHehwHOY
	 ruIQXZIKnlV493hcRkf14cDgRWKqhLizvIO5bg56VVZ0Nneh5O8kzBATuPkhvjfG6r
	 +x4Ys8Lrvu9Tyr0ZD9sch/WNWCPNmlLZdk43Pa/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/170] ASoC: fsl_sai: Enable BCI bit if SAI works on synchronous mode with BYP asserted
Date: Mon, 26 Jun 2023 20:12:06 +0200
Message-ID: <20230626180807.510546553@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 32cf0046a652116d6a216d575f3049a9ff9dd80d ]

There's an issue on SAI synchronous mode that TX/RX side can't get BCLK
from RX/TX it sync with if BYP bit is asserted. It's a workaround to
fix it that enable SION of IOMUX pad control and assert BCI.

For example if TX sync with RX which means both TX and RX are using clk
form RX and BYP=1. TX can get BCLK only if the following two conditions
are valid:
1. SION of RX BCLK IOMUX pad is set to 1
2. BCI of TX is set to 1

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230530103012.3448838-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 11 +++++++++--
 sound/soc/fsl/fsl_sai.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 6d88af5b287fe..b33104715c7ba 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -491,14 +491,21 @@ static int fsl_sai_set_bclk(struct snd_soc_dai *dai, bool tx, u32 freq)
 	regmap_update_bits(sai->regmap, reg, FSL_SAI_CR2_MSEL_MASK,
 			   FSL_SAI_CR2_MSEL(sai->mclk_id[tx]));
 
-	if (savediv == 1)
+	if (savediv == 1) {
 		regmap_update_bits(sai->regmap, reg,
 				   FSL_SAI_CR2_DIV_MASK | FSL_SAI_CR2_BYP,
 				   FSL_SAI_CR2_BYP);
-	else
+		if (fsl_sai_dir_is_synced(sai, adir))
+			regmap_update_bits(sai->regmap, FSL_SAI_xCR2(tx, ofs),
+					   FSL_SAI_CR2_BCI, FSL_SAI_CR2_BCI);
+		else
+			regmap_update_bits(sai->regmap, FSL_SAI_xCR2(tx, ofs),
+					   FSL_SAI_CR2_BCI, 0);
+	} else {
 		regmap_update_bits(sai->regmap, reg,
 				   FSL_SAI_CR2_DIV_MASK | FSL_SAI_CR2_BYP,
 				   savediv / 2 - 1);
+	}
 
 	if (sai->soc_data->max_register >= FSL_SAI_MCTL) {
 		/* SAI is in master mode at this point, so enable MCLK */
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 697f6690068c8..c5423f81e4560 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -116,6 +116,7 @@
 
 /* SAI Transmit and Receive Configuration 2 Register */
 #define FSL_SAI_CR2_SYNC	BIT(30)
+#define FSL_SAI_CR2_BCI		BIT(28)
 #define FSL_SAI_CR2_MSEL_MASK	(0x3 << 26)
 #define FSL_SAI_CR2_MSEL_BUS	0
 #define FSL_SAI_CR2_MSEL_MCLK1	BIT(26)
-- 
2.39.2



