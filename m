Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BD015ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A432DC433C7;
	Tue, 25 Jul 2023 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282896;
	bh=EuYZDRqvaRDTXZe54PnMnFdlT0OO8E4mdcFCHt03pfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmfU7JJdXplDjGr01hSa76Bgz+tU10BawjR1xM8YgVNb7c9EI9wy6aEr8AmSEKSdJ
	 oljOTLMpIKFbprCb/m0xYq0MC5Mdk5Xu1KZRNwnB3DiH0NxTdUr7a3AwZqOfFzNRqo
	 komwQ3o47/hYynxgjcO8K3xeNFCFUjuA1uFdwE3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Henriksson <andreas@fatal.se>,
	Fabio Estevam <festevam@denx.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 037/183] ASoC: fsl_sai: Revert "ASoC: fsl_sai: Enable MCTL_MCLK_EN bit for master mode"
Date: Tue, 25 Jul 2023 12:44:25 +0200
Message-ID: <20230725104509.275093624@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

commit 86867aca7330e4fbcfa2a117e20b48bbb6c758a9 upstream.

This reverts commit ff87d619ac180444db297f043962a5c325ded47b.

Andreas reports that on an i.MX8MP-based system where MCLK needs to be
used as an input, the MCLK pin is actually an output, despite not having
the 'fsl,sai-mclk-direction-output' property present in the devicetree.

This is caused by commit ff87d619ac18 ("ASoC: fsl_sai: Enable
MCTL_MCLK_EN bit for master mode") that sets FSL_SAI_MCTL_MCLK_EN
unconditionally for imx8mm/8mn/8mp/93, causing the MCLK to always
be configured as output.

FSL_SAI_MCTL_MCLK_EN corresponds to the MOE (MCLK Output Enable) bit
of register MCR and the drivers sets it when the
'fsl,sai-mclk-direction-output' devicetree property is present.

Revert the commit to allow SAI to use MCLK as input as well.

Cc: stable@vger.kernel.org
Fixes: ff87d619ac18 ("ASoC: fsl_sai: Enable MCTL_MCLK_EN bit for master mode")
Reported-by: Andreas Henriksson <andreas@fatal.se>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230706221827.1938990-1-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 5e09f634c61b..54b4bf3744c6 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -507,12 +507,6 @@ static int fsl_sai_set_bclk(struct snd_soc_dai *dai, bool tx, u32 freq)
 				   savediv / 2 - 1);
 	}
 
-	if (sai->soc_data->max_register >= FSL_SAI_MCTL) {
-		/* SAI is in master mode at this point, so enable MCLK */
-		regmap_update_bits(sai->regmap, FSL_SAI_MCTL,
-				   FSL_SAI_MCTL_MCLK_EN, FSL_SAI_MCTL_MCLK_EN);
-	}
-
 	return 0;
 }
 
-- 
2.41.0



