Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934CF415F23;
	Tue, 21 Jul 2026 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669681; cv=none; b=r2nH/4Xg8QkK8wqlxSdysXe1y3D0cs4qm0QiZ3r/8J45/WlI/uGXTN3vQOXIFRRzl66Ese/GyZImXoMjcMtGySu8m/4tGezQDqjvaguTfhs4ryOJIniyME2ZEAmzO8Y7K0pDtAJH/yWzky90+K50/T/F729SidAi0LsIlP/NFiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669681; c=relaxed/simple;
	bh=C9NREAG3hKkN+t4xUzREGoPM4h3a6JmmO8qpsZxXCu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL7DII6DmiLu7KmvOwarOeQtkYBUgT8eu+OFEI1zU33CvTory/evFxTWOb8MolJe9DTxnTQK2OpnCb2XxZRRxXqIIO5W5TMeHoRi86lYsJ6VvPuILiQMv/TapbswTMI3e5FE5sWmDnSjzEVa92vowHaOpw864Vc9E9eOPG8MZb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKR8eYP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKR8eYP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA2F1F00A3A;
	Tue, 21 Jul 2026 21:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669679;
	bh=yKjbhUvNQvuhl0TTss4UGmUNv9lr3sXjKYyFCZFKrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKR8eYP6lSupEej65RGpXxAM5lG3TyiHdJ6h/9p3uxrTXCFQ9Nl29koVi5eBXdPuN
	 jLkv/nXec7v5MPyM7bz5dGczGususZoRfa/Yp9fiOKQxM9Svicrq6Wf1mPcdCbXAE/
	 M6puH19Gn1rBygQqF3CYG2ZCXxE+02aPDYNaLVOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0645/1067] ASoC: fsl_asrc_dma: fix eDMA maxburst misalignment with channel count
Date: Tue, 21 Jul 2026 17:20:46 +0200
Message-ID: <20260721152439.022243420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit cf6f56990ea21172e085f0588e5bbf2089ce8f58 ]

The back-end consumes data in units of the number of channels. When the
maxburst value is not evenly divisible by the channel count, the DMA
transfer length does not align with the FIFO frame boundary, causing
wrong data to be copied and audible noise at the end of the stream.

This is specific to eDMA: eDMA only responds to DMA requests from the
back-end, whereas SDMA handles requests from both the front-end and the
back-end and is not affected.

For eDMA, when the back-end maxburst is not evenly divisible by the
channel count, align it to the nearest valid boundary:
- If maxburst >= channel count, override to the channel count so each
  transfer corresponds to exactly one audio frame.
- If maxburst < channel count, override to 1 to avoid partial-frame
  transfers.

Retain the original maxburst for SDMA or when it already aligns with
the channel count.

Fixes: c05f10f28ef6 ("ASoC: fsl_asrc: Add support for imx8qm & imx8qxp")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260625102416.424911-1-shengjiu.wang@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc_dma.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/soc/fsl/fsl_asrc_dma.c b/sound/soc/fsl/fsl_asrc_dma.c
index 05a7d1588d204b..91dd85153e83e1 100644
--- a/sound/soc/fsl/fsl_asrc_dma.c
+++ b/sound/soc/fsl/fsl_asrc_dma.c
@@ -275,6 +275,26 @@ static int fsl_asrc_dma_hw_params(struct snd_soc_component *component,
 	config_be.dst_addr_width = buswidth;
 	config_be.dst_maxburst = dma_params_be->maxburst;
 
+	/*
+	 * For eDMA, the back-end may report a maxburst size that is not evenly
+	 * divisible by the channel count. This causes the DMA transfer length
+	 * to misalign with the FIFO boundary, resulting in wrong data and
+	 * audible noise. Align maxburst to the nearest valid boundary:
+	 * - If maxburst >= channel count, override to the channel count so
+	 *   each transfer equals exactly one audio frame.
+	 * - If maxburst < channel count, override to 1 to avoid partial-frame
+	 *   transfers.
+	 */
+	if (asrc->use_edma && (dma_params_be->maxburst % params_channels(params))) {
+		if (dma_params_be->maxburst >= params_channels(params)) {
+			config_be.src_maxburst = params_channels(params);
+			config_be.dst_maxburst = params_channels(params);
+		} else {
+			config_be.src_maxburst = 1;
+			config_be.dst_maxburst = 1;
+		}
+	}
+
 	memset(&audio_config, 0, sizeof(audio_config));
 	config_be.peripheral_config = &audio_config;
 	config_be.peripheral_size  = sizeof(audio_config);
-- 
2.53.0



