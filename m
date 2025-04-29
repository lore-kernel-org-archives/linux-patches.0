Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC6252296;
	Tue, 29 Apr 2025 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947789; cv=none; b=nX+ibOzmZTtT8b8gbNPR08lD/qXt9WGYNfgDfB+qOFVR30tiRnW8N9Uqa90L9LPd29YPbDAQ7icbYsnt/HAYnXdHcwKAbKc/jN0c83bwUvX4i0Du6GXOZBlBJdsXAM7JgXyev3vyUoUzCPtmwej9sia8HEWBeLyjoM2eQZDDPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947789; c=relaxed/simple;
	bh=+eZMwLJyKhZad2pnAncK8XSEHLbZRr6kRnTjpB64S8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDhJfZLtZGR4HYb5h8uEomr6BNX2ViRyicFzFhyCiSL1WtdxBm2cqoUGAy2Gasat+JSTL2X1EvlZvUT3ILwvRd0TA8tkYhl90jAF5OTa8iIn3A5rFUp6XD+5/T7hFP9ktGehfy/TssAO/gryK4I4DkfXWH0Pdr7Rj5i4TL4QchY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxy7aUwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxy7aUwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8BBC4CEEE;
	Tue, 29 Apr 2025 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947789;
	bh=+eZMwLJyKhZad2pnAncK8XSEHLbZRr6kRnTjpB64S8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxy7aUwnmPZErTo6t2EgB/sVMUgbl6r9ukXq6EGlH2u2Ihkho5ZxXE4xxUNNXwk+w
	 HcsrSlbLWOO5T0piWUulr1+2GmjAJdbx/D9mz7GQSROpgev+C+IWMQ+JxkxA8CVsc9
	 julYblTeuxTMHXvexq77j+RyCtlPcNnb4BrWRqog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo-Cun Chen <bc-bocun.chen@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/280] net: ethernet: mtk_eth_soc: net: revise NETSYSv3 hardware configuration
Date: Tue, 29 Apr 2025 18:40:14 +0200
Message-ID: <20250429161118.099874333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d408dcda76d79..223aee1af4430 100644
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



