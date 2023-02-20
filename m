Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A61763BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959C8C433EF;
	Mon, 20 Feb 2023 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901615;
	bh=npg+BFZju7fovTkF5Hj3mPtZhpkF8qKdQYJImuQ7JXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTQhuote2OPyxHCrXCYa7BebpGEj1e8kkAfwhkYlpbfbzkNquMJJmnBRgTo2T5hjE
	 EB9DzNVSRXgltukCCWnzME9YrTEgR+sTF0GXalLSJmO1Lj5CaHjbwnrM3aPWVmArGZ
	 SQwweYmkR/IRngMJexOI2ivz6eMoGmZemgsNKqlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 085/118] net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk
Date: Mon, 20 Feb 2023 14:36:41 +0100
Message-Id: <20230220133603.807852300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 0ed577e7e8e508c24e22ba07713ecc4903e147c3 upstream.

In TI's AM62x/AM64x SoCs, successful teardown of RX DMA Channel raises an
interrupt. The process of servicing this interrupt involves flushing all
pending RX DMA descriptors and clearing the teardown completion marker
(TDCM). The am65_cpsw_nuss_rx_packets() function invoked from the RX
NAPI callback services the interrupt. Thus, it is necessary to wait for
this handler to run, drain all packets and clear TDCM, before calling
napi_disable() in am65_cpsw_nuss_common_stop() function post channel
teardown. If napi_disable() executes before ensuring that TDCM is
cleared, the TDCM remains set when the interfaces are down, resulting in
an interrupt storm when the interfaces are brought up again.

Since the interrupt raised to indicate the RX DMA Channel teardown is
specific to the AM62x and AM64x SoCs, add a quirk for it.

Fixes: 4f7cce272403 ("net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g")
Co-developed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230209084432.189222-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |   12 +++++++++++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |    1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -500,7 +500,15 @@ static int am65_cpsw_nuss_common_stop(st
 		k3_udma_glue_disable_tx_chn(common->tx_chns[i].tx_chn);
 	}
 
+	reinit_completion(&common->tdown_complete);
 	k3_udma_glue_tdown_rx_chn(common->rx_chns.rx_chn, true);
+
+	if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ) {
+		i = wait_for_completion_timeout(&common->tdown_complete, msecs_to_jiffies(1000));
+		if (!i)
+			dev_err(common->dev, "rx teardown timeout\n");
+	}
+
 	napi_disable(&common->napi_rx);
 
 	for (i = 0; i < AM65_CPSW_MAX_RX_FLOWS; i++)
@@ -704,6 +712,8 @@ static int am65_cpsw_nuss_rx_packets(str
 
 	if (cppi5_desc_is_tdcm(desc_dma)) {
 		dev_dbg(dev, "%s RX tdown flow: %u\n", __func__, flow_idx);
+		if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ)
+			complete(&common->tdown_complete);
 		return 0;
 	}
 
@@ -2634,7 +2644,7 @@ static const struct am65_cpsw_pdata j721
 };
 
 static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
-	.quirks = 0,
+	.quirks = AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
 };
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -86,6 +86,7 @@ struct am65_cpsw_rx_chn {
 };
 
 #define AM65_CPSW_QUIRK_I2027_NO_TX_CSUM BIT(0)
+#define AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ BIT(1)
 
 struct am65_cpsw_pdata {
 	u32	quirks;


