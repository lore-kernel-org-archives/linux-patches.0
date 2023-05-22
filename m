Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA9B171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6490C433D2;
	Mon, 22 May 2023 19:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784911;
	bh=d0qDdDGbiLrFmJua8/hH1F3y4GKnKStL7u34TP8zoO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1o4cAoNVo5lb98s30cq2raOTSpOvvGvw8Gj7aJlBpkC9+nQRZ/LsuoeJ0Hk1KB3Q
	 WSxz7Qf/WHQ0Xqo29cr4DJdy3ENeC9ycRgb8C/BgKLIp3OYqQC43LgAV88lBC8V+Sd
	 pCwhK1CggMMDVOIs4ATt9DnX0saaDOErIoepCmY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 242/364] net: hns3: fix sending pfc frames after reset issue
Date: Mon, 22 May 2023 20:09:07 +0100
Message-Id: <20230522190418.750636736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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
index 07ad5f35219e2..50e956d6c3b25 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8053,12 +8053,15 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
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
 
 	hclge_reset_tqp(handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 4a33f65190e2b..922c0da3660c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -171,8 +171,8 @@ int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx)
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
index 68f28a98e380b..dd6f1fd486cf2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -164,6 +164,9 @@ struct hclge_bp_to_qs_map_cmd {
 	u32 rsvd1;
 };
 
+#define HCLGE_PFC_DISABLE	0
+#define HCLGE_PFC_TX_RX_DISABLE	0
+
 struct hclge_pfc_en_cmd {
 	u8 tx_rx_en_bitmap;
 	u8 pri_en_bitmap;
@@ -235,6 +238,8 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc);
 void hclge_tm_pfc_info_update(struct hclge_dev *hdev);
 int hclge_tm_dwrr_cfg(struct hclge_dev *hdev);
 int hclge_tm_init_hw(struct hclge_dev *hdev, bool init);
+int hclge_pfc_pause_en_cfg(struct hclge_dev *hdev, u8 tx_rx_bitmap,
+			   u8 pfc_bitmap);
 int hclge_mac_pause_en_cfg(struct hclge_dev *hdev, bool tx, bool rx);
 int hclge_pause_addr_cfg(struct hclge_dev *hdev, const u8 *mac_addr);
 void hclge_pfc_rx_stats_get(struct hclge_dev *hdev, u64 *stats);
-- 
2.39.2



