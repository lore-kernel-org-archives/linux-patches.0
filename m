Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145C26AC1;
	Sun,  1 Sep 2024 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210458; cv=none; b=PgV5dCrCWxtLjomiASp1H0dZaAYROwJ6gOcmd/z4Ry0gO0TJZndasMCRcPh5btmGJHkvQPrlcurtVX61mQnHPh7kphyxdY5qL/jhRgIE7qjH67E6HbYI2QUunw0Kyq1ursi1+j/4+F2sl1pnOIf/oMmE5tmdTOohZH1VTdt96n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210458; c=relaxed/simple;
	bh=NuOZpH0tYzm5P5vzfPHWZu8Ws6mOomvoUu34uVm8hr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvNL+3gEGGSwc2XQ9IL3+8JLnzVmUm9IH0ymNAfssOJSs+zBS4JPAqOLZpP+cMoTZqPwEJspXZaM+GRFPKXPKthcRqdes/ERQkgojWc3EDfi/SLW2U+NbE05yQhJXW1/rQm5Yvnp3VwwKV12EgJ/4UTl+Fyp7MpmdrTWIPznas0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imQd66rY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imQd66rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6292FC4CEC3;
	Sun,  1 Sep 2024 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210457;
	bh=NuOZpH0tYzm5P5vzfPHWZu8Ws6mOomvoUu34uVm8hr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imQd66rYQ90iHulkTAPeXv5eGj6hYd6qs5bNi8pF0cCMzVxe+QxwzD57ET1d8WwAe
	 iz+jahPcLZtNEuREIDKBVbgxkQI/e/c4ovg/rQPWFDMxQvYWGEJ3i2YvovcV/T8N8H
	 z+GgP4pROwgocK5kmrPwLsGl7uQT4r2kdIRPlcZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/215] dmaengine: dw: Add peripheral bus width verification
Date: Sun,  1 Sep 2024 18:18:27 +0200
Message-ID: <20240901160830.727072645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit b336268dde75cb09bd795cb24893d52152a9191f ]

Currently the src_addr_width and dst_addr_width fields of the
dma_slave_config structure are mapped to the CTLx.SRC_TR_WIDTH and
CTLx.DST_TR_WIDTH fields of the peripheral bus side in order to have the
properly aligned data passed to the target device. It's done just by
converting the passed peripheral bus width to the encoded value using the
__ffs() function. This implementation has several problematic sides:

1. __ffs() is undefined if no bit exist in the passed value. Thus if the
specified addr-width is DMA_SLAVE_BUSWIDTH_UNDEFINED, __ffs() may return
unexpected value depending on the platform-specific implementation.

2. DW AHB DMA-engine permits having the power-of-2 transfer width limited
by the DMAH_Mk_HDATA_WIDTH IP-core synthesize parameter. Specifying
bus-width out of that constraints scope will definitely cause unexpected
result since the destination reg will be only partly touched than the
client driver implied.

Let's fix all of that by adding the peripheral bus width verification
method and calling it in dwc_config() which is supposed to be executed
before preparing any transfer. The new method will make sure that the
passed source or destination address width is valid and if undefined then
the driver will just fallback to the 1-byte width transfer.

Fixes: 029a40e97d0d ("dmaengine: dw: provide DMA capabilities")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20240802075100.6475-2-fancer.lancer@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/core.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 7ab83fe601ede..128c194d65b6d 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -783,10 +784,43 @@ bool dw_dma_filter(struct dma_chan *chan, void *param)
 }
 EXPORT_SYMBOL_GPL(dw_dma_filter);
 
+static int dwc_verify_p_buswidth(struct dma_chan *chan)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	u32 reg_width, max_width;
+
+	if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
+		reg_width = dwc->dma_sconfig.dst_addr_width;
+	else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
+		reg_width = dwc->dma_sconfig.src_addr_width;
+	else /* DMA_MEM_TO_MEM */
+		return 0;
+
+	max_width = dw->pdata->data_width[dwc->dws.p_master];
+
+	/* Fall-back to 1-byte transfer width if undefined */
+	if (reg_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
+		reg_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	else if (!is_power_of_2(reg_width) || reg_width > max_width)
+		return -EINVAL;
+	else /* bus width is valid */
+		return 0;
+
+	/* Update undefined addr width value */
+	if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
+		dwc->dma_sconfig.dst_addr_width = reg_width;
+	else /* DMA_DEV_TO_MEM */
+		dwc->dma_sconfig.src_addr_width = reg_width;
+
+	return 0;
+}
+
 static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 	struct dw_dma *dw = to_dw_dma(chan->device);
+	int ret;
 
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
 
@@ -795,6 +829,10 @@ static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	dwc->dma_sconfig.dst_maxburst =
 		clamp(dwc->dma_sconfig.dst_maxburst, 0U, dwc->max_burst);
 
+	ret = dwc_verify_p_buswidth(chan);
+	if (ret)
+		return ret;
+
 	dw->encode_maxburst(dwc, &dwc->dma_sconfig.src_maxburst);
 	dw->encode_maxburst(dwc, &dwc->dma_sconfig.dst_maxburst);
 
-- 
2.43.0



