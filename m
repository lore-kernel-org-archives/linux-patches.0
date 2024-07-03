Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60945172BCD;
	Wed,  3 Jul 2024 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003902; cv=none; b=ZtV0auJ1IqjJlj2kgvoVlK2wWZbWx0M21NahtLsbxJPYttb+ibAa/NzBvG5hubAIsiT9orABV2a9t2i8S7W1A0ioILln8cQqQRGZsEU2TqVCEIN98ysTijRRyMntp67Q5fFxirr8zrCOKNkLMBKlKTLW0dsrh7OE4hniVshxyag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003902; c=relaxed/simple;
	bh=E2+JhFJ6O1+0ptFu9R/OeSRYCDPIDS8frp6xnZlJVes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=part3DT8JqwmY7XcOTXFP/aRyWz+aktS04NmAy+++mlKS/xsL8DLlkR3lBno6bvyHH5iywV5F7WbgT2UfFchgoy7bOioNKZOhnemD0u7dYh+cjXd9OxBHOWD6Pzw643DnTVsXXaniw+nIgsLioxqfIugt1w3rOvPrcooLuvE5Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX5eA+t0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX5eA+t0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCABC2BD10;
	Wed,  3 Jul 2024 10:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003902;
	bh=E2+JhFJ6O1+0ptFu9R/OeSRYCDPIDS8frp6xnZlJVes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX5eA+t0NT42Xm9RjMNR3bFykLxbtguf9IdpJH2SqMEJgm1/lUSnH1pkP2V6mA+Wq
	 Mhi/pzbAEvJkfCGBitTgtKPs+aXAt8Fc+cBcCD57LOxIjF11AbPpo2EWJtUze8/KPO
	 9Z7wZFYKt6bSV9WoMp3Y/IijCYVgKGapn4wFwmic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/189] ASoC: ti: davinci-mcasp: Remove legacy dma_request parsing
Date: Wed,  3 Jul 2024 12:38:08 +0200
Message-ID: <20240703102842.532430500@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit db8793a39b293d5a8983e1713a70a76cb039c2fe ]

The legacy dma_request (which was holding the DMA request number) is no
longer in use for a long time.
All legacy platforms has been converted to dma_slave_map.

Remove it along with the DT parsing to get tx_dma_channel and
rx_dma_channel.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201106072551.689-3-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d18ca8635db2 ("ASoC: ti: davinci-mcasp: Fix race condition during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 57 ++----------------------------------
 1 file changed, 3 insertions(+), 54 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 7860382a17a28..e2e272d653480 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -93,7 +93,6 @@ struct davinci_mcasp {
 	u8	bclk_div;
 	int	streams;
 	u32	irq_request[2];
-	int	dma_request[2];
 
 	int	sysclk_freq;
 	bool	bclk_master;
@@ -1730,7 +1729,6 @@ static struct davinci_mcasp_pdata *davinci_mcasp_set_pdata_from_of(
 	struct davinci_mcasp_pdata *pdata = NULL;
 	const struct of_device_id *match =
 			of_match_device(mcasp_dt_ids, &pdev->dev);
-	struct of_phandle_args dma_spec;
 
 	const u32 *of_serial_dir32;
 	u32 val;
@@ -1785,31 +1783,6 @@ static struct davinci_mcasp_pdata *davinci_mcasp_set_pdata_from_of(
 		pdata->serial_dir = of_serial_dir;
 	}
 
-	ret = of_property_match_string(np, "dma-names", "tx");
-	if (ret < 0)
-		goto nodata;
-
-	ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells", ret,
-					 &dma_spec);
-	if (ret < 0)
-		goto nodata;
-
-	pdata->tx_dma_channel = dma_spec.args[0];
-
-	/* RX is not valid in DIT mode */
-	if (pdata->op_mode != DAVINCI_MCASP_DIT_MODE) {
-		ret = of_property_match_string(np, "dma-names", "rx");
-		if (ret < 0)
-			goto nodata;
-
-		ret = of_parse_phandle_with_args(np, "dmas", "#dma-cells", ret,
-						 &dma_spec);
-		if (ret < 0)
-			goto nodata;
-
-		pdata->rx_dma_channel = dma_spec.args[0];
-	}
-
 	ret = of_property_read_u32(np, "tx-num-evt", &val);
 	if (ret >= 0)
 		pdata->txnumevt = val;
@@ -2099,11 +2072,10 @@ static void davinci_mcasp_get_dt_params(struct davinci_mcasp *mcasp)
 static int davinci_mcasp_probe(struct platform_device *pdev)
 {
 	struct snd_dmaengine_dai_dma_data *dma_data;
-	struct resource *mem, *res, *dat;
+	struct resource *mem, *dat;
 	struct davinci_mcasp_pdata *pdata;
 	struct davinci_mcasp *mcasp;
 	char *irq_name;
-	int *dma;
 	int irq;
 	int ret;
 
@@ -2238,45 +2210,22 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 		mcasp->dat_port = true;
 
 	dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_PLAYBACK];
+	dma_data->filter_data = "tx";
 	if (dat)
 		dma_data->addr = dat->start;
 	else
 		dma_data->addr = mem->start + davinci_mcasp_txdma_offset(pdata);
 
-	dma = &mcasp->dma_request[SNDRV_PCM_STREAM_PLAYBACK];
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (res)
-		*dma = res->start;
-	else
-		*dma = pdata->tx_dma_channel;
-
-	/* dmaengine filter data for DT and non-DT boot */
-	if (pdev->dev.of_node)
-		dma_data->filter_data = "tx";
-	else
-		dma_data->filter_data = dma;
 
 	/* RX is not valid in DIT mode */
 	if (mcasp->op_mode != DAVINCI_MCASP_DIT_MODE) {
 		dma_data = &mcasp->dma_data[SNDRV_PCM_STREAM_CAPTURE];
+		dma_data->filter_data = "rx";
 		if (dat)
 			dma_data->addr = dat->start;
 		else
 			dma_data->addr =
 				mem->start + davinci_mcasp_rxdma_offset(pdata);
-
-		dma = &mcasp->dma_request[SNDRV_PCM_STREAM_CAPTURE];
-		res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-		if (res)
-			*dma = res->start;
-		else
-			*dma = pdata->rx_dma_channel;
-
-		/* dmaengine filter data for DT and non-DT boot */
-		if (pdev->dev.of_node)
-			dma_data->filter_data = "rx";
-		else
-			dma_data->filter_data = dma;
 	}
 
 	if (mcasp->version < MCASP_VERSION_3) {
-- 
2.43.0



