Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7DC78281;
	Wed,  7 Aug 2024 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043314; cv=none; b=JQqQlwfALpn2g07BopORSU+AmCUAT/HAMRztkhFK1RI+P/5Ztbz2/TL1wy4ImGyK6NxeADxY+zUIj09jJ8N042E39u/nAbzyGn6gFjWrRfERYj/EViVb3WgDY9qcnDFOlact8yP6sgKT6g8M2YIywq8GaHnm80tRujjLpQvrqDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043314; c=relaxed/simple;
	bh=7X9EjELYERI2z/GHNPeWOWw8lZKSAuXFXE1BQGtynVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccuut+gbydtatSkWocnxXzn2M8cYS6tTlCOZHmqLr8BGZm32vj+OHq+6HKhnJEmtoIXrkuQzvhYXH25ktotCG6jR06FpH+/ACp+JwWiiDMlYwl/DyX3NHFO4EOQrkPgazLsq6Iw5EhnWe0aFb9PgQ8vhJVIxYz2rdlTRkifbmNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f4WHHc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f4WHHc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F114C32781;
	Wed,  7 Aug 2024 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043314;
	bh=7X9EjELYERI2z/GHNPeWOWw8lZKSAuXFXE1BQGtynVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f4WHHc+FMFK/zwqwl+fQ0PQV/6YJTlQTIEMTjInKtJI3rygq7oaNQMoj9y2XhCZ+
	 U7LcjmNkRK8lv7Obn/rkGdSLQ+ytT8sJ3+X5ZFBMNbOHez2kAvEsT9uIqhe0Pmhn9u
	 411njvzlOrEruQz7p3XTsC7+2hAc8KONN6lCuVBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/121] dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM
Date: Wed,  7 Aug 2024 16:59:37 +0200
Message-ID: <20240807150020.870668379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit 8ddad558997002ce67980e30c9e8dfaa696e163b ]

Fix the issue where MEM_TO_MEM fail on i.MX8QM due to the requirement
that both source and destination addresses need pass through the IOMMU.
Typically, peripheral FIFO addresses bypass the IOMMU, necessitating
only one of the source or destination to go through it.

Set "is_remote" to true to ensure both source and destination
addresses pass through the IOMMU.

iMX8 Spec define "Local" and "Remote" bus as below.
Local bus: bypass IOMMU to directly access other peripheral register,
such as FIFO.
Remote bus: go through IOMMU to access system memory.

The test fail log as follow:
[ 66.268506] dmatest: dma0chan0-copy0: result #1: 'test timed out' with src_off=0x100 dst_off=0x80 len=0x3ec0 (0)
[ 66.278785] dmatest: dma0chan0-copy0: summary 1 tests, 1 failures 0.32 iops 4 KB/s (0)

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joy Zou <joy.zou@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240510030959.703663-1-joy.zou@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-common.c | 3 +++
 drivers/dma/fsl-edma-common.h | 1 +
 drivers/dma/fsl-edma-main.c   | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index a1ac404977fd8..53fdfd32a7e77 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -747,6 +747,8 @@ struct dma_async_tx_descriptor *fsl_edma_prep_memcpy(struct dma_chan *chan,
 	fsl_desc->iscyclic = false;
 
 	fsl_chan->is_sw = true;
+	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_MEM_REMOTE)
+		fsl_chan->is_remote = true;
 
 	/* To match with copy_align and max_seg_size so 1 tcd is enough */
 	fsl_edma_fill_tcd(fsl_chan, fsl_desc->tcd[0].vtcd, dma_src, dma_dst,
@@ -825,6 +827,7 @@ void fsl_edma_free_chan_resources(struct dma_chan *chan)
 	fsl_chan->tcd_pool = NULL;
 	fsl_chan->is_sw = false;
 	fsl_chan->srcid = 0;
+	fsl_chan->is_remote = false;
 	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_HAS_CHCLK)
 		clk_disable_unprepare(fsl_chan->clk);
 }
diff --git a/drivers/dma/fsl-edma-common.h b/drivers/dma/fsl-edma-common.h
index 20e29a42fcd8d..6028389de408b 100644
--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -178,6 +178,7 @@ struct fsl_edma_desc {
 #define FSL_EDMA_DRV_HAS_PD		BIT(5)
 #define FSL_EDMA_DRV_HAS_CHCLK		BIT(6)
 #define FSL_EDMA_DRV_HAS_CHMUX		BIT(7)
+#define FSL_EDMA_DRV_MEM_REMOTE		BIT(8)
 /* control and status register is in tcd address space, edma3 reg layout */
 #define FSL_EDMA_DRV_SPLIT_REG		BIT(9)
 #define FSL_EDMA_DRV_BUS_8BYTE		BIT(10)
diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index c96b893d2ac35..8a0ae90548997 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -340,7 +340,7 @@ static struct fsl_edma_drvdata imx7ulp_data = {
 };
 
 static struct fsl_edma_drvdata imx8qm_data = {
-	.flags = FSL_EDMA_DRV_HAS_PD | FSL_EDMA_DRV_EDMA3,
+	.flags = FSL_EDMA_DRV_HAS_PD | FSL_EDMA_DRV_EDMA3 | FSL_EDMA_DRV_MEM_REMOTE,
 	.chreg_space_sz = 0x10000,
 	.chreg_off = 0x10000,
 	.setup_irq = fsl_edma3_irq_init,
-- 
2.43.0



