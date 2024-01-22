Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD9A7A725;
	Tue, 23 Jan 2024 02:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975560; cv=none; b=tFiJ16FNPYGFn1PEsN2DdDrpt/TNXNWxUSUZzeI7hY1nYdjkOg++ZaOgDN+SLaxQcaAFzM4b/pNI+H+ffyTqfSzAP/XkFyf/icvmwYnvkphzHA5cUHlbvDHbwHaeWHxeKKilsuUq0sCBJG2Im6ip0FWsxssDMSzd7OpQ8GtOISU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975560; c=relaxed/simple;
	bh=dgXOa+MZXnRGQujr/R/zWTMZMmtKUOGrSGojCnxt/KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJn23EmM2kGPQu8zDOii0Xt6gBULHmCq3nMfW2RUX9a/kX4QzP38gnBJX2QKa/rbNSDoWol2Vs1NHrFsT5mlRdDHcghdIHKucrM05jmNdmuF764GTZgf4wDLGni2FL1o0TH2JEkQVmM2ozYHVbsZRzKdTxmuwahjqHwFxTqU52g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3qfOUk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3qfOUk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF4C43399;
	Tue, 23 Jan 2024 02:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975560;
	bh=dgXOa+MZXnRGQujr/R/zWTMZMmtKUOGrSGojCnxt/KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3qfOUk+soBhK54Ys5PIxe3E7UH38PdMs/fKhcKXFtXeliLWh0GqAehlV6RZyCXv0
	 a+W7XT9ql73Lvx7Vb3wAu+xfjiIHEfBdwYR62jUBZN9hnYa0uUKMap8fKrygR11nUg
	 XBa4BlgYb2yTXfnrmC9YwPmRG8wuy5P3/ZgcSx0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 510/583] usb: xhci-mtk: fix a short packet issue of gen1 isoc-in transfer
Date: Mon, 22 Jan 2024 15:59:21 -0800
Message-ID: <20240122235827.668625056@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 017dbfc05c31284150819890b4cc86a699cbdb71 ]

For Gen1 isoc-in transfer, host still send out unexpected ACK after device
finish the burst with a short packet, this will cause an exception on the
connected device, such as, a usb 4k camera.
It can be fixed by setting rxfifo depth less than 4k bytes, prefer to use
3k here, the side-effect is that may cause performance drop about 10%,
including bulk transfer.

Fixes: 926d60ae64a6 ("usb: xhci-mtk: modify the SOF/ITP interval for mt8195")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20240104061640.7335-2-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk.c | 40 +++++++++++++++++++++++++++++++++++--
 drivers/usb/host/xhci-mtk.h |  2 ++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index bbdf1b0b7be1..3252e3d2d79c 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -7,6 +7,7 @@
  *  Chunfeng Yun <chunfeng.yun@mediatek.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/dma-mapping.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
@@ -73,6 +74,9 @@
 #define FRMCNT_LEV1_RANG	(0x12b << 8)
 #define FRMCNT_LEV1_RANG_MASK	GENMASK(19, 8)
 
+#define HSCH_CFG1		0x960
+#define SCH3_RXFIFO_DEPTH_MASK	GENMASK(21, 20)
+
 #define SS_GEN2_EOF_CFG		0x990
 #define SSG2EOF_OFFSET		0x3c
 
@@ -114,6 +118,8 @@
 #define SSC_IP_SLEEP_EN	BIT(4)
 #define SSC_SPM_INT_EN		BIT(1)
 
+#define SCH_FIFO_TO_KB(x)	((x) >> 10)
+
 enum ssusb_uwk_vers {
 	SSUSB_UWK_V1 = 1,
 	SSUSB_UWK_V2,
@@ -165,6 +171,35 @@ static void xhci_mtk_set_frame_interval(struct xhci_hcd_mtk *mtk)
 	writel(value, hcd->regs + SS_GEN2_EOF_CFG);
 }
 
+/*
+ * workaround: usb3.2 gen1 isoc rx hw issue
+ * host send out unexpected ACK afer device fininsh a burst transfer with
+ * a short packet.
+ */
+static void xhci_mtk_rxfifo_depth_set(struct xhci_hcd_mtk *mtk)
+{
+	struct usb_hcd *hcd = mtk->hcd;
+	u32 value;
+
+	if (!mtk->rxfifo_depth)
+		return;
+
+	value = readl(hcd->regs + HSCH_CFG1);
+	value &= ~SCH3_RXFIFO_DEPTH_MASK;
+	value |= FIELD_PREP(SCH3_RXFIFO_DEPTH_MASK,
+			    SCH_FIFO_TO_KB(mtk->rxfifo_depth) - 1);
+	writel(value, hcd->regs + HSCH_CFG1);
+}
+
+static void xhci_mtk_init_quirk(struct xhci_hcd_mtk *mtk)
+{
+	/* workaround only for mt8195 */
+	xhci_mtk_set_frame_interval(mtk);
+
+	/* workaround for SoCs using SSUSB about before IPM v1.6.0 */
+	xhci_mtk_rxfifo_depth_set(mtk);
+}
+
 static int xhci_mtk_host_enable(struct xhci_hcd_mtk *mtk)
 {
 	struct mu3c_ippc_regs __iomem *ippc = mtk->ippc_regs;
@@ -448,8 +483,7 @@ static int xhci_mtk_setup(struct usb_hcd *hcd)
 		if (ret)
 			return ret;
 
-		/* workaround only for mt8195 */
-		xhci_mtk_set_frame_interval(mtk);
+		xhci_mtk_init_quirk(mtk);
 	}
 
 	ret = xhci_gen_setup(hcd, xhci_mtk_quirks);
@@ -527,6 +561,8 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	of_property_read_u32(node, "mediatek,u2p-dis-msk",
 			     &mtk->u2p_dis_msk);
 
+	of_property_read_u32(node, "rx-fifo-depth", &mtk->rxfifo_depth);
+
 	ret = usb_wakeup_of_property_parse(mtk, node);
 	if (ret) {
 		dev_err(dev, "failed to parse uwk property\n");
diff --git a/drivers/usb/host/xhci-mtk.h b/drivers/usb/host/xhci-mtk.h
index faaaf05e36ce..ac042077db8c 100644
--- a/drivers/usb/host/xhci-mtk.h
+++ b/drivers/usb/host/xhci-mtk.h
@@ -160,6 +160,8 @@ struct xhci_hcd_mtk {
 	struct regmap *uwk;
 	u32 uwk_reg_base;
 	u32 uwk_vers;
+	/* quirk */
+	u32 rxfifo_depth;
 };
 
 static inline struct xhci_hcd_mtk *hcd_to_mtk(struct usb_hcd *hcd)
-- 
2.43.0



