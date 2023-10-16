Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E196241F8
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTCzcwgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D287BC433C9;
	Mon, 16 Oct 2023 14:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466353;
	bh=XrAwI/Bex/jiECJ4YHhe8sh0reOM0I4ljHuepVzvhKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTCzcwgpC4wgTgu2wuE1rubzQWce0Y6LIAYy14JZNbsUdx/itoab4LUlJle0tS+iz
	 BwDP5KWsN32GyEMru5YoiaYPw5S+4+STWzfBZDnv11jahqHP0odcNyzNXVCfSvHPCv
	 dmaONbr8vI0GXXXWINNjJAgTBMBb6790L7DysoMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 035/191] ASoC: fsl_sai: Dont disable bitclock for i.MX8MP
Date: Mon, 16 Oct 2023 10:40:20 +0200
Message-ID: <20231016084016.217158764@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 197c53c8ecb34f2cd5922f4bdcffa8f701a134eb upstream.

On i.MX8MP, the BCE and TERE bit are binding with mclk
enablement, if BCE and TERE are cleared the MCLK also be
disabled on output pin, that cause the external codec (wm8960)
in wrong state.

Codec (wm8960) is using the mclk to generate PLL clock,
if mclk is disabled before disabling PLL, the codec (wm8960)
won't generate bclk and frameclk when sysclk switch to
MCLK source in next test case.

The test case:
$aplay -r44100 test1.wav (PLL source)
$aplay -r48000 test2.wav (MCLK source)
aplay: pcm_write:2127: write error: Input/output error

Fixes: 269f399dc19f ("ASoC: fsl_sai: Disable bit clock with transmitter")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1695116533-23287-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_sai.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -710,10 +710,15 @@ static void fsl_sai_config_disable(struc
 {
 	unsigned int ofs = sai->soc_data->reg_offset;
 	bool tx = dir == TX;
-	u32 xcsr, count = 100;
+	u32 xcsr, count = 100, mask;
+
+	if (sai->soc_data->mclk_with_tere && sai->mclk_direction_output)
+		mask = FSL_SAI_CSR_TERE;
+	else
+		mask = FSL_SAI_CSR_TERE | FSL_SAI_CSR_BCE;
 
 	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs),
-			   FSL_SAI_CSR_TERE | FSL_SAI_CSR_BCE, 0);
+			   mask, 0);
 
 	/* TERE will remain set till the end of current frame */
 	do {


