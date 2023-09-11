Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3867A11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE99AC433C7;
	Mon, 11 Sep 2023 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443060;
	bh=d62qw2irOJ3zLRYiFFUx3zZgyxOWQ8ayuuibD/OsYxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU37nY1mTkD37hP4AMzvk5rOnEkayv5sFJQuj4SdLDp5hEqfaqzUXgt67UrD4Ir0W
	 6JXniUIeuHzyExEZoRLHWo4yNhEUBAIpTQgO6q9gAJWA9Y8V5dQ9ZsGxsms5GiSZuL
	 tYcwPZDFLFqIikPa5rvHs54ec/FJXUZSnx6pfvbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 214/737] net: hns3: fix wrong rpu tln reg issue
Date: Mon, 11 Sep 2023 15:41:13 +0200
Message-ID: <20230911134656.568322013@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 36122201eeaefd78547def9681aa5d83b5a00b6a ]

In the original RPU query command, the status register values of
multiple RPU tunnels are accumulated by default, which is unreasonable.
This patch Fix it by querying the specified tunnel ID.
The tunnel number of the device can be obtained from firmware
during initialization.

Fixes: ddb54554fa51 ("net: hns3: add DFX registers information for ethtool -d")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  2 +
 .../hisilicon/hns3/hns3pf/hclge_regs.c        | 66 ++++++++++++++++++-
 4 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 6df84184173d1..e9c108128bb3b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -382,6 +382,7 @@ struct hnae3_dev_specs {
 	u16 umv_size;
 	u16 mc_mac_size;
 	u32 mac_stats_num;
+	u8 tnl_num;
 };
 
 struct hnae3_client_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 91c173f40701a..d5cfdc4c082d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -826,7 +826,9 @@ struct hclge_dev_specs_1_cmd {
 	u8 rsv0[2];
 	__le16 umv_size;
 	__le16 mc_mac_size;
-	u8 rsv1[12];
+	u8 rsv1[6];
+	u8 tnl_num;
+	u8 rsv2[5];
 };
 
 /* mac speed type defined in firmware command */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cd41e7cb65306..0d56dc2e9960e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1327,6 +1327,7 @@ static void hclge_set_default_dev_specs(struct hclge_dev *hdev)
 	ae_dev->dev_specs.max_frm_size = HCLGE_MAC_MAX_FRAME;
 	ae_dev->dev_specs.max_qset_num = HCLGE_MAX_QSET_NUM;
 	ae_dev->dev_specs.umv_size = HCLGE_DEFAULT_UMV_SPACE_PER_PF;
+	ae_dev->dev_specs.tnl_num = 0;
 }
 
 static void hclge_parse_dev_specs(struct hclge_dev *hdev,
@@ -1350,6 +1351,7 @@ static void hclge_parse_dev_specs(struct hclge_dev *hdev,
 	ae_dev->dev_specs.max_frm_size = le16_to_cpu(req1->max_frm_size);
 	ae_dev->dev_specs.umv_size = le16_to_cpu(req1->umv_size);
 	ae_dev->dev_specs.mc_mac_size = le16_to_cpu(req1->mc_mac_size);
+	ae_dev->dev_specs.tnl_num = req1->tnl_num;
 }
 
 static void hclge_check_dev_specs(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
index 734e5f757b9c5..43c1c18fa81f8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_regs.c
@@ -125,6 +125,7 @@ enum hclge_reg_tag {
 	HCLGE_REG_TAG_DFX_RCB,
 	HCLGE_REG_TAG_DFX_TQP,
 	HCLGE_REG_TAG_DFX_SSU_2,
+	HCLGE_REG_TAG_RPU_TNL,
 };
 
 #pragma pack(4)
@@ -147,6 +148,8 @@ struct hclge_reg_header {
 #define HCLGE_REG_HEADER_SPACE	(sizeof(struct hclge_reg_header) / sizeof(u32))
 #define HCLGE_REG_MAGIC_NUMBER	0x686e733372656773 /* meaning is hns3regs */
 
+#define HCLGE_REG_RPU_TNL_ID_0	1
+
 static u32 hclge_reg_get_header(void *data)
 {
 	struct hclge_reg_header *header = data;
@@ -342,6 +345,28 @@ static int hclge_dfx_reg_cmd_send(struct hclge_dev *hdev,
 	return ret;
 }
 
+/* tnl_id = 0 means get sum of all tnl reg's value */
+static int hclge_dfx_reg_rpu_tnl_cmd_send(struct hclge_dev *hdev, u32 tnl_id,
+					  struct hclge_desc *desc, int bd_num)
+{
+	int i, ret;
+
+	for (i = 0; i < bd_num; i++) {
+		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_DFX_RPU_REG_0,
+					   true);
+		if (i != bd_num - 1)
+			desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	}
+
+	desc[0].data[0] = cpu_to_le32(tnl_id);
+	ret = hclge_cmd_send(&hdev->hw, desc, bd_num);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to query dfx rpu tnl reg, ret = %d\n",
+			ret);
+	return ret;
+}
+
 static int hclge_dfx_reg_fetch_data(struct hclge_desc *desc_src, int bd_num,
 				    void *data)
 {
@@ -363,6 +388,7 @@ static int hclge_dfx_reg_fetch_data(struct hclge_desc *desc_src, int bd_num,
 static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int data_len_per_desc;
 	int *bd_num_list;
 	int ret;
@@ -384,11 +410,41 @@ static int hclge_get_dfx_reg_len(struct hclge_dev *hdev, int *len)
 	for (i = 0; i < dfx_reg_type_num; i++)
 		*len += bd_num_list[i] * data_len_per_desc + HCLGE_REG_TLV_SIZE;
 
+	/**
+	 * the num of dfx_rpu_0 is reused by each dfx_rpu_tnl
+	 * HCLGE_DFX_BD_OFFSET is starting at 1, but the array subscript is
+	 * starting at 0, so offset need '- 1'.
+	 */
+	*len += (bd_num_list[HCLGE_DFX_RPU_0_BD_OFFSET - 1] * data_len_per_desc +
+		 HCLGE_REG_TLV_SIZE) * ae_dev->dev_specs.tnl_num;
+
 out:
 	kfree(bd_num_list);
 	return ret;
 }
 
+static int hclge_get_dfx_rpu_tnl_reg(struct hclge_dev *hdev, u32 *reg,
+				     struct hclge_desc *desc_src,
+				     int bd_num)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	int ret = 0;
+	u8 i;
+
+	for (i = HCLGE_REG_RPU_TNL_ID_0; i <= ae_dev->dev_specs.tnl_num; i++) {
+		ret = hclge_dfx_reg_rpu_tnl_cmd_send(hdev, i, desc_src, bd_num);
+		if (ret)
+			break;
+
+		reg += hclge_reg_get_tlv(HCLGE_REG_TAG_RPU_TNL,
+					 ARRAY_SIZE(desc_src->data) * bd_num,
+					 reg);
+		reg += hclge_dfx_reg_fetch_data(desc_src, bd_num, reg);
+	}
+
+	return ret;
+}
+
 static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 {
 	u32 dfx_reg_type_num = ARRAY_SIZE(hclge_dfx_bd_offset_list);
@@ -428,7 +484,7 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 		if (ret) {
 			dev_err(&hdev->pdev->dev,
 				"Get dfx reg fail, status is %d.\n", ret);
-			break;
+			goto free;
 		}
 
 		reg += hclge_reg_get_tlv(HCLGE_REG_TAG_DFX_BIOS_COMMON + i,
@@ -437,6 +493,14 @@ static int hclge_get_dfx_reg(struct hclge_dev *hdev, void *data)
 		reg += hclge_dfx_reg_fetch_data(desc_src, bd_num, reg);
 	}
 
+	/**
+	 * HCLGE_DFX_BD_OFFSET is starting at 1, but the array subscript is
+	 * starting at 0, so offset need '- 1'.
+	 */
+	bd_num = bd_num_list[HCLGE_DFX_RPU_0_BD_OFFSET - 1];
+	ret = hclge_get_dfx_rpu_tnl_reg(hdev, reg, desc_src, bd_num);
+
+free:
 	kfree(desc_src);
 out:
 	kfree(bd_num_list);
-- 
2.40.1



