Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFFA569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BF2C4339B;
	Sun, 28 May 2023 19:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301942;
	bh=4//Y7+dpT+GRQBIZh6cnRXFAwNVw15gmbuB7XmdHAjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0hCbzr5xNoa3Os4MzOg4JxbVUAgTvWmw2HPEekTizhiWjAH3itq3BFMOwP5jeX8L
	 OR3KR61cxfb+VSAWbyzt5gZh/Owiv5/IzvTwD9V3QeZzAvFGpDlMessiusOQ6v2s4K
	 bNMaPfT5EZmCH+LnpYT8f8ViMt/0+M4+xxm0vEGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/161] net: hns3: fix sending pfc frames after reset issue
Date: Sun, 28 May 2023 20:09:54 +0100
Message-Id: <20230528190839.385501179@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit f14db07064727dd3bc0906c77a6d2759c1bbb395 ]

To prevent the system from abnormally sending PFC frames after an
abnormal reset. The hns3 driver notifies the firmware to disable pfc
before reset.

Fixes: 35d93a30040c ("net: hns3: adjust the process of PF reset")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  4 ++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  5 +++++
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d58abdfdb9b7b..08277c3cf2806 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6688,12 +6688,15 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	/* If it is not PF reset or FLR, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
 	 */
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) &&
-	    hdev->reset_type != HNAE3_FUNC_RESET &&
-	    hdev->reset_type != HNAE3_FLR_RESET) {
-		hclge_mac_stop_phy(hdev);
-		hclge_update_link_status(hdev);
-		return;
+	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state)) {
+		hclge_pfc_pause_en_cfg(hdev, HCLGE_PFC_TX_RX_DISABLE,
+				       HCLGE_PFC_DISABLE);
+		if (hdev->reset_type != HNAE3_FUNC_RESET &&
+		    hdev->reset_type != HNAE3_FLR_RESET) {
+			hclge_mac_stop_phy(hdev);
+			hclge_update_link_status(hdev);
+			return;
+		}
 	}
 
 	for (i = 0; i < handle->kinfo.num_tqps; i++)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 8448607742a6b..2183e700f9d96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -170,8 +170,8 @@ int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx)
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
-static int hclge_pfc_pause_en_cfg(struct hclge_dev *hdev, u8 tx_rx_bitmap,
-				  u8 pfc_bitmap)
+int hclge_pfc_pause_en_cfg(struct hclge_dev *hdev, u8 tx_rx_bitmap,
+			   u8 pfc_bitmap)
 {
 	struct hclge_desc desc;
 	struct hclge_pfc_en_cmd *pfc = (struct hclge_pfc_en_cmd *)desc.data;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 260f22d19d81a..406084bb23072 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -109,6 +109,9 @@ struct hclge_bp_to_qs_map_cmd {
 	u32 rsvd1;
 };
 
+#define HCLGE_PFC_DISABLE	0
+#define HCLGE_PFC_TX_RX_DISABLE	0
+
 struct hclge_pfc_en_cmd {
 	u8 tx_rx_en_bitmap;
 	u8 pri_en_bitmap;
@@ -150,6 +153,8 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc);
 void hclge_tm_pfc_info_update(struct hclge_dev *hdev);
 int hclge_tm_dwrr_cfg(struct hclge_dev *hdev);
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init);
+int hclge_pfc_pause_en_cfg(struct hclge_dev *hdev, u8 tx_rx_bitmap,
+			   u8 pfc_bitmap);
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx);
 int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 int hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
-- 
2.39.2



