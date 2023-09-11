Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407E31170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF481C433C8;
	Mon, 11 Sep 2023 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442551;
	bh=twLWHwO1JdhLLSdLeoclNqEAzHDBJPSpe840DUzpBNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SztfTxhu4Tec7CkTT4na8p6mfJpQ983mHPuYvhbrZ53OchV7SQm2U137gln7JAbIT
	 1FPYOnmOAfdKVEqffSRTeFKuAGZ5MfKLp344c6IXZW4+TzaYFgQnwHTyUOk3OsEY+7
	 lAudaTIHwBlpornKot64P88+sNaslk7QXxYj/XPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 019/737] net: hns3: add tm flush when setting tm
Date: Mon, 11 Sep 2023 15:37:58 +0200
Message-ID: <20230911134650.880719836@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit 6d2336120aa6e1a8a64fa5d6ee5c3f3d0809fe9b ]

When the tm module is configured with traffic, traffic
may be abnormal. This patch fixes this problem.
Before the tm module is configured, traffic processing
should be stopped. After the tm module is configured,
traffic processing is enabled.

Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  4 +++
 .../hns3/hns3_common/hclge_comm_cmd.c         |  1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |  2 ++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  3 ++
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 34 ++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 31 ++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  4 +++
 7 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 06f29e80104c0..6df84184173d1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -102,6 +102,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_FEC_STATS_B,
 	HNAE3_DEV_SUPPORT_LANE_NUM_B,
 	HNAE3_DEV_SUPPORT_WOL_B,
+	HNAE3_DEV_SUPPORT_TM_FLUSH_B,
 };
 
 #define hnae3_ae_dev_fd_supported(ae_dev) \
@@ -173,6 +174,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_wol_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_WOL_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_tm_flush_supported(hdev) \
+	test_bit(HNAE3_DEV_SUPPORT_TM_FLUSH_B, (hdev)->ae_dev->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index 16ba98ff2c9b1..dcecb23daac6e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -156,6 +156,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
 	{HCLGE_COMM_CAP_LANE_NUM_B, HNAE3_DEV_SUPPORT_LANE_NUM_B},
 	{HCLGE_COMM_CAP_WOL_B, HNAE3_DEV_SUPPORT_WOL_B},
+	{HCLGE_COMM_CAP_TM_FLUSH_B, HNAE3_DEV_SUPPORT_TM_FLUSH_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 18f1b4bf362da..2b7197ce0ae8f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -153,6 +153,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_TM_INTERNAL_STS	= 0x0850,
 	HCLGE_OPC_TM_INTERNAL_CNT	= 0x0851,
 	HCLGE_OPC_TM_INTERNAL_STS_1	= 0x0852,
+	HCLGE_OPC_TM_FLUSH		= 0x0872,
 
 	/* Packet buffer allocate commands */
 	HCLGE_OPC_TX_BUFF_ALLOC		= 0x0901,
@@ -349,6 +350,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_FEC_STATS_B = 25,
 	HCLGE_COMM_CAP_LANE_NUM_B = 27,
 	HCLGE_COMM_CAP_WOL_B = 28,
+	HCLGE_COMM_CAP_TM_FLUSH_B = 31,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 207b2e3f3fc2b..dce158d4aeef6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -411,6 +411,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support wake on lan",
 		.cap_bit = HNAE3_DEV_SUPPORT_WOL_B,
+	}, {
+		.name = "support tm flush",
+		.cap_bit = HNAE3_DEV_SUPPORT_TM_FLUSH_B,
 	}
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 09362823140d5..fad5a5ff3cda5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -227,6 +227,10 @@ static int hclge_notify_down_uinit(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
+	ret = hclge_tm_flush_cfg(hdev, true);
+	if (ret)
+		return ret;
+
 	return hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
 }
 
@@ -238,6 +242,10 @@ static int hclge_notify_init_up(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
+	ret = hclge_tm_flush_cfg(hdev, false);
+	if (ret)
+		return ret;
+
 	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 }
 
@@ -324,6 +332,7 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	struct net_device *netdev = h->kinfo.netdev;
 	struct hclge_dev *hdev = vport->back;
 	u8 i, j, pfc_map, *prio_tc;
+	int last_bad_ret = 0;
 	int ret;
 
 	if (!(hdev->dcbx_cap & DCB_CAP_DCBX_VER_IEEE))
@@ -361,13 +370,28 @@ static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	if (ret)
 		return ret;
 
-	ret = hclge_buffer_alloc(hdev);
-	if (ret) {
-		hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+	ret = hclge_tm_flush_cfg(hdev, true);
+	if (ret)
 		return ret;
-	}
 
-	return hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+	/* No matter whether the following operations are performed
+	 * successfully or not, disabling the tm flush and notify
+	 * the network status to up are necessary.
+	 * Do not return immediately.
+	 */
+	ret = hclge_buffer_alloc(hdev);
+	if (ret)
+		last_bad_ret = ret;
+
+	ret = hclge_tm_flush_cfg(hdev, false);
+	if (ret)
+		last_bad_ret = ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_UP_CLIENT);
+	if (ret)
+		last_bad_ret = ret;
+
+	return last_bad_ret;
 }
 
 static int hclge_ieee_setapp(struct hnae3_handle *h, struct dcb_app *app)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 150f146fa24fb..de509e5751a7c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1485,7 +1485,11 @@ int hclge_tm_schd_setup_hw(struct hclge_dev *hdev)
 		return ret;
 
 	/* Cfg schd mode for each level schd */
-	return hclge_tm_schd_mode_hw(hdev);
+	ret = hclge_tm_schd_mode_hw(hdev);
+	if (ret)
+		return ret;
+
+	return hclge_tm_flush_cfg(hdev, false);
 }
 
 static int hclge_pause_param_setup_hw(struct hclge_dev *hdev)
@@ -2114,3 +2118,28 @@ int hclge_tm_get_port_shaper(struct hclge_dev *hdev,
 
 	return 0;
 }
+
+int hclge_tm_flush_cfg(struct hclge_dev *hdev, bool enable)
+{
+	struct hclge_desc desc;
+	int ret;
+
+	if (!hnae3_ae_dev_tm_flush_supported(hdev))
+		return 0;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_FLUSH, false);
+
+	desc.data[0] = cpu_to_le32(enable ? HCLGE_TM_FLUSH_EN_MSK : 0);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to config tm flush, ret = %d\n", ret);
+		return ret;
+	}
+
+	if (enable)
+		msleep(HCLGE_TM_FLUSH_TIME_MS);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index dd6f1fd486cf2..45dcfef3f90cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -33,6 +33,9 @@ enum hclge_opcode_type;
 #define HCLGE_DSCP_MAP_TC_BD_NUM	2
 #define HCLGE_DSCP_TC_SHIFT(n)		(((n) & 1) * 4)
 
+#define HCLGE_TM_FLUSH_TIME_MS	10
+#define HCLGE_TM_FLUSH_EN_MSK	BIT(0)
+
 struct hclge_pg_to_pri_link_cmd {
 	u8 pg_id;
 	u8 rsvd1[3];
@@ -272,4 +275,5 @@ int hclge_tm_get_port_shaper(struct hclge_dev *hdev,
 			     struct hclge_tm_shaper_para *para);
 int hclge_up_to_tc_map(struct hclge_dev *hdev);
 int hclge_dscp_to_tc_map(struct hclge_dev *hdev);
+int hclge_tm_flush_cfg(struct hclge_dev *hdev, bool enable);
 #endif
-- 
2.40.1



