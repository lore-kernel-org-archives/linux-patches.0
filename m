Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A40143894;
	Sun,  1 Sep 2024 16:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208021; cv=none; b=Q/sQgGL5Ft7IXD7GwoVszktnloG72IyKL/MrR0ns5bPzJbfQm95GN90+laWPZt/fs+g0a+CxqzdFg4Gn6uVIDWTXxaTN6M9FECMH75ea7ILcenw1kgjUlpwr1Q4qFJRioK1ULcTuk8GooeLQb9KbAoBmTkP6rI3OEWl3c2F8iVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208021; c=relaxed/simple;
	bh=1medUTK2MkYqEruxAINJHSNTPsjyxKauy2ABJsYPjvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPWayRZ/rQDHU/SDUoIe9dwv+D5SrE8FeNK1K1NcJxbMNKOd6PCy4QQTY9R4V6xCpfxM22OSkd5RNWSP2DfW5Jffh7oNEo1MT+lOVnKMjL/zUTa/SLp3hTXk2XlTTRX3eNweEXi0cKmgLY9G+2rveGWDty6lQ9n5FPbuanRpGfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOx6qJ5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOx6qJ5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7ADC4CEC3;
	Sun,  1 Sep 2024 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208020;
	bh=1medUTK2MkYqEruxAINJHSNTPsjyxKauy2ABJsYPjvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOx6qJ5+v4OEAcaGjm+GurMto5zQqMeC9R651o3jUqK4xdBq2NrP2LYZgS+Fte8B1
	 dsH/xVEorkvj+4YI6/79WZ7/jwZv8IFTFopTaPPCdy3bkc2UVdpSeORAu+cRQhtzFa
	 2LpVpwEWgCwOK2gYPLum9+kG9nsOFh/Svz0LxF8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/93] dmaengine: dw: Add peripheral bus width verification
Date: Sun,  1 Sep 2024 18:16:36 +0200
Message-ID: <20240901160809.208180923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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
index 5f7d690e3dbae..11e269a31a092 100644
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
@@ -780,10 +781,43 @@ bool dw_dma_filter(struct dma_chan *chan, void *param)
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
 
@@ -792,6 +826,10 @@ static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
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



