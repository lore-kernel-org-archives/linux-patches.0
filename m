Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31841A76A1;
	Tue, 30 Jul 2024 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360304; cv=none; b=iFa6swxPVIg82bta0qS4MfQT9Y6HYJ0fS3Y7hUUAsgyrNRjhvh6VhK1K178hny+VMclq8FaOWTMo0zqXX97BD2r7AYw/h2l5UfsfO+4mIxkTiU+UgjP4XyJvKzlmUXHNAEQGyseJh5lc7B7Vv2c5Rk+/cxncntxFxlAR0TirHVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360304; c=relaxed/simple;
	bh=u1DG6u3nCUKT7qlOFfevqpM5zmWeI+I5Ng2rKOURTV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPk2Tvb1c5o2WavIojCy9RYNEgXe/DzdokawHcc+cF1JJ3HNghZjLBad8lyWbcABIzgkIcZ0ZCijfk6F1Bku/2DJlSBIsL/oDHEpXUyM5G30JNj0YOBvfjWzJhM5X+N+S73ZsP7XXncZOWwQ2icU1oaUHIOUBLgX9bgfh1cxDRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujh0m6Tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujh0m6Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E14C4AF16;
	Tue, 30 Jul 2024 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360304;
	bh=u1DG6u3nCUKT7qlOFfevqpM5zmWeI+I5Ng2rKOURTV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujh0m6Tc6H8q5XXnYVO9xKJ881WNtn9WcstydYVpJeA0eL9yikORM5H1hsXW4HG0L
	 HYhzTD7RpO1y+dNAfxeb477gm0b/oAvqz+Li4nPinvst7jc2D15VruiqyKMPjIUwJ2
	 OgFynjFjdavlpMk6OgaZgGI42akaImqK31GbAdb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.10 657/809] dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM
Date: Tue, 30 Jul 2024 17:48:53 +0200
Message-ID: <20240730151750.831946939@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joy Zou <joy.zou@nxp.com>

commit 8ddad558997002ce67980e30c9e8dfaa696e163b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c |    3 +++
 drivers/dma/fsl-edma-common.h |    1 +
 drivers/dma/fsl-edma-main.c   |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -758,6 +758,8 @@ struct dma_async_tx_descriptor *fsl_edma
 	fsl_desc->iscyclic = false;
 
 	fsl_chan->is_sw = true;
+	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_MEM_REMOTE)
+		fsl_chan->is_remote = true;
 
 	/* To match with copy_align and max_seg_size so 1 tcd is enough */
 	fsl_edma_fill_tcd(fsl_chan, fsl_desc->tcd[0].vtcd, dma_src, dma_dst,
@@ -837,6 +839,7 @@ void fsl_edma_free_chan_resources(struct
 	fsl_chan->tcd_pool = NULL;
 	fsl_chan->is_sw = false;
 	fsl_chan->srcid = 0;
+	fsl_chan->is_remote = false;
 	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_HAS_CHCLK)
 		clk_disable_unprepare(fsl_chan->clk);
 }
--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -194,6 +194,7 @@ struct fsl_edma_desc {
 #define FSL_EDMA_DRV_HAS_PD		BIT(5)
 #define FSL_EDMA_DRV_HAS_CHCLK		BIT(6)
 #define FSL_EDMA_DRV_HAS_CHMUX		BIT(7)
+#define FSL_EDMA_DRV_MEM_REMOTE		BIT(8)
 /* control and status register is in tcd address space, edma3 reg layout */
 #define FSL_EDMA_DRV_SPLIT_REG		BIT(9)
 #define FSL_EDMA_DRV_BUS_8BYTE		BIT(10)
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -342,7 +342,7 @@ static struct fsl_edma_drvdata imx7ulp_d
 };
 
 static struct fsl_edma_drvdata imx8qm_data = {
-	.flags = FSL_EDMA_DRV_HAS_PD | FSL_EDMA_DRV_EDMA3,
+	.flags = FSL_EDMA_DRV_HAS_PD | FSL_EDMA_DRV_EDMA3 | FSL_EDMA_DRV_MEM_REMOTE,
 	.chreg_space_sz = 0x10000,
 	.chreg_off = 0x10000,
 	.setup_irq = fsl_edma3_irq_init,


