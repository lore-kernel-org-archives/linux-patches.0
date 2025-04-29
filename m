Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F5724BD02;
	Tue, 29 Apr 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945835; cv=none; b=R9l6sEfE5v8t22w5oUF9wMlpsDX54H9vY1K+nC7lifpwebxFIZDScUEOBBa7iGl6bF4WNjCbTLDfw3ch9oVA3kcrRTbO09AmYgKYM3/HVDsCaMCRdPv+pYqj+62yMLY3fyuPMLbKablv+UeAgEuTrrq2UfPtW1IQX3u79MaGtFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945835; c=relaxed/simple;
	bh=vMQh3/5ybEkYvW+tvtXCfURYs2KAgl5v2ysAogpGIfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcEm4N+cffcK6kPUpBcjoOo+fT6uqmBfup6DfWuF2Kyx5x0eVbcNnuew5t0e3VqccXiJvLndXLMapTfDFQB/gMedJPC0lT/b9elUVugpqyg/PtGClXa2NFW1jrQW4fSI3Wh2IXg0QGfki2XLzQG8BymSQp6806+hrYm4hl2fopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtWgCROl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtWgCROl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEA6C4CEE3;
	Tue, 29 Apr 2025 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945835;
	bh=vMQh3/5ybEkYvW+tvtXCfURYs2KAgl5v2ysAogpGIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtWgCROliBUg/XxkNkRVaGOmNLHvHtTKekIYPlShwNKhBIH2qtl1GIShP1nBsoDoM
	 8cL8RAfmTHQ7p7LcvmKIdl95reDzte2zp4QWHNRTmIDou05utj4g0rE/B0Gvtq7vQG
	 IgpphDKgMPnjrsWe0TKBH3OUHtJhs1bo4bGgo+4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 066/311] net: ethernet: mtk_eth_soc: net: revise NETSYSv3 hardware configuration
Date: Tue, 29 Apr 2025 18:38:23 +0200
Message-ID: <20250429161123.744029524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo-Cun Chen <bc-bocun.chen@mediatek.com>

[ Upstream commit 491ef1117c56476f199b481f8c68820fe4c3a7c2 ]

Change hardware configuration for the NETSYSv3.
 - Enable PSE dummy page mechanism for the GDM1/2/3
 - Enable PSE drop mechanism when the WDMA Rx ring full
 - Enable PSE no-drop mechanism for packets from the WDMA Tx
 - Correct PSE free drop threshold
 - Correct PSE CDMA high threshold

Fixes: 1953f134a1a8b ("net: ethernet: mtk_eth_soc: add NETSYS_V3 version support")
Signed-off-by: Bo-Cun Chen <bc-bocun.chen@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/b71f8fd9d4bb69c646c4d558f9331dd965068606.1744907886.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 24 +++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 10 ++++++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 0cd1ecacfd29f..477b8732b8609 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3997,11 +3997,27 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
 	if (mtk_is_netsys_v3_or_greater(eth)) {
-		/* PSE should not drop port1, port8 and port9 packets */
-		mtk_w32(eth, 0x00000302, PSE_DROP_CFG);
+		/* PSE dummy page mechanism */
+		mtk_w32(eth, PSE_DUMMY_WORK_GDM(1) | PSE_DUMMY_WORK_GDM(2) |
+			PSE_DUMMY_WORK_GDM(3) | DUMMY_PAGE_THR, PSE_DUMY_REQ);
+
+		/* PSE free buffer drop threshold */
+		mtk_w32(eth, 0x00600009, PSE_IQ_REV(8));
+
+		/* PSE should not drop port8, port9 and port13 packets from
+		 * WDMA Tx
+		 */
+		mtk_w32(eth, 0x00002300, PSE_DROP_CFG);
+
+		/* PSE should drop packets to port8, port9 and port13 on WDMA Rx
+		 * ring full
+		 */
+		mtk_w32(eth, 0x00002300, PSE_PPE_DROP(0));
+		mtk_w32(eth, 0x00002300, PSE_PPE_DROP(1));
+		mtk_w32(eth, 0x00002300, PSE_PPE_DROP(2));
 
 		/* GDM and CDM Threshold */
-		mtk_w32(eth, 0x00000707, MTK_CDMW0_THRES);
+		mtk_w32(eth, 0x08000707, MTK_CDMW0_THRES);
 		mtk_w32(eth, 0x00000077, MTK_CDMW1_THRES);
 
 		/* Disable GDM1 RX CRC stripping */
@@ -4018,7 +4034,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 		mtk_w32(eth, 0x00000300, PSE_DROP_CFG);
 
 		/* PSE should drop packets to port 8/9 on WDMA Rx ring full */
-		mtk_w32(eth, 0x00000300, PSE_PPE0_DROP);
+		mtk_w32(eth, 0x00000300, PSE_PPE_DROP(0));
 
 		/* PSE Free Queue Flow Control  */
 		mtk_w32(eth, 0x01fa01f4, PSE_FQFC_CFG2);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 8d7b6818d8601..0570623e569d5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -151,7 +151,15 @@
 #define PSE_FQFC_CFG1		0x100
 #define PSE_FQFC_CFG2		0x104
 #define PSE_DROP_CFG		0x108
-#define PSE_PPE0_DROP		0x110
+#define PSE_PPE_DROP(x)		(0x110 + ((x) * 0x4))
+
+/* PSE Last FreeQ Page Request Control */
+#define PSE_DUMY_REQ		0x10C
+/* PSE_DUMY_REQ is not a typo but actually called like that also in
+ * MediaTek's datasheet
+ */
+#define PSE_DUMMY_WORK_GDM(x)	BIT(16 + (x))
+#define DUMMY_PAGE_THR		0x1
 
 /* PSE Input Queue Reservation Register*/
 #define PSE_IQ_REV(x)		(0x140 + (((x) - 1) << 2))
-- 
2.39.5



