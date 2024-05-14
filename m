Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98326F9D4;
	Tue, 14 May 2024 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687856; cv=none; b=G+p19e+BlLGejbfYtOrQoRSn6iN1GkCVFPe3qjZ64BK7qKXGOUVFmsech06km9gaNBYbpRXcdBUZQYgh71tLwYch/1gaWaSGv/X88WrHxlus9m6wVFa/awemJyVkuoo/z2gcwRiSEvnr7aP0gyUWcfE5fmGlxOvS9xsnwdNriTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687856; c=relaxed/simple;
	bh=E3hpyKScuW4h6hrO4TZ8eCoXmAYGWX72TX7lI4vBoHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6llK8stEZnLPPFCjANcx+w94cCA3yKZloD0IaLUyKlcu+eavsCPtbBjZTIpuR0OSmlXc/8Vk9Lnc7sVVN3zMtO5jfpZWrRoKDtEq6rXOAhwqu8WqtLAn4w0/1bH0As60DgEPk6fPWOxxeoRNPo/qZLQwDNcfFTNiXuC8bjFB+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prMcN2zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prMcN2zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0664C2BD10;
	Tue, 14 May 2024 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687856;
	bh=E3hpyKScuW4h6hrO4TZ8eCoXmAYGWX72TX7lI4vBoHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prMcN2zwSHGvoRkQTXPG6GguzfR5vXW/rHqEJSLuNiBjcgs/UACzD4UMiSbyO6TGQ
	 ug8muDysxwVfa4C9Sp3zsf8d03Rs+FRPs3k3LcqaBFCzUZIRd23D4eY1yWnFUR/mYj
	 zu6/8Iz8KR6a+ORtAFHabKJo1gu5+Q/bm0FQInt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/168] net: hns3: split function hclge_init_vlan_config()
Date: Tue, 14 May 2024 12:20:26 +0200
Message-ID: <20240514101011.515137175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit b60f9d2ec479966383c7f2cdf3b1a3a66c25f212 ]

Currently the function hclge_init_vlan_config() is a bit long.
Split it to several small functions, to simplify code and
improve code readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f5db7a3b65c8 ("net: hns3: fix port vlan filter not disabled issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 97 +++++++++++--------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4b0027a41f3cd..6a346165d5881 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10102,67 +10102,80 @@ static int hclge_set_vlan_protocol_type(struct hclge_dev *hdev)
 	return status;
 }
 
-static int hclge_init_vlan_config(struct hclge_dev *hdev)
+static int hclge_init_vlan_filter(struct hclge_dev *hdev)
 {
-#define HCLGE_DEF_VLAN_TYPE		0x8100
-
-	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	struct hclge_vport *vport;
 	int ret;
 	int i;
 
-	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		/* for revision 0x21, vf vlan filter is per function */
-		for (i = 0; i < hdev->num_alloc_vport; i++) {
-			vport = &hdev->vport[i];
-			ret = hclge_set_vlan_filter_ctrl(hdev,
-							 HCLGE_FILTER_TYPE_VF,
-							 HCLGE_FILTER_FE_EGRESS,
-							 true,
-							 vport->vport_id);
-			if (ret)
-				return ret;
-			vport->cur_vlan_fltr_en = true;
-		}
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
+		return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
+						  HCLGE_FILTER_FE_EGRESS_V1_B,
+						  true, 0);
 
-		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
-						 HCLGE_FILTER_FE_INGRESS, true,
-						 0);
-		if (ret)
-			return ret;
-	} else {
+	/* for revision 0x21, vf vlan filter is per function */
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
 		ret = hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
-						 HCLGE_FILTER_FE_EGRESS_V1_B,
-						 true, 0);
+						 HCLGE_FILTER_FE_EGRESS, true,
+						 vport->vport_id);
 		if (ret)
 			return ret;
+		vport->cur_vlan_fltr_en = true;
 	}
 
-	hdev->vlan_type_cfg.rx_in_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_in_sec_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_ot_fst_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.rx_ot_sec_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.tx_ot_vlan_type = HCLGE_DEF_VLAN_TYPE;
-	hdev->vlan_type_cfg.tx_in_vlan_type = HCLGE_DEF_VLAN_TYPE;
+	return hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
+					  HCLGE_FILTER_FE_INGRESS, true, 0);
+}
 
-	ret = hclge_set_vlan_protocol_type(hdev);
-	if (ret)
-		return ret;
+static int hclge_init_vlan_type(struct hclge_dev *hdev)
+{
+	hdev->vlan_type_cfg.rx_in_fst_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_in_sec_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_ot_fst_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.rx_ot_sec_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.tx_ot_vlan_type = ETH_P_8021Q;
+	hdev->vlan_type_cfg.tx_in_vlan_type = ETH_P_8021Q;
 
-	for (i = 0; i < hdev->num_alloc_vport; i++) {
-		u16 vlan_tag;
-		u8 qos;
+	return hclge_set_vlan_protocol_type(hdev);
+}
 
+static int hclge_init_vport_vlan_offload(struct hclge_dev *hdev)
+{
+	struct hclge_port_base_vlan_config *cfg;
+	struct hclge_vport *vport;
+	int ret;
+	int i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
 		vport = &hdev->vport[i];
-		vlan_tag = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
-		qos = vport->port_base_vlan_cfg.vlan_info.qos;
+		cfg = &vport->port_base_vlan_cfg;
 
-		ret = hclge_vlan_offload_cfg(vport,
-					     vport->port_base_vlan_cfg.state,
-					     vlan_tag, qos);
+		ret = hclge_vlan_offload_cfg(vport, cfg->state,
+					     cfg->vlan_info.vlan_tag,
+					     cfg->vlan_info.qos);
 		if (ret)
 			return ret;
 	}
+	return 0;
+}
+
+static int hclge_init_vlan_config(struct hclge_dev *hdev)
+{
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
+	int ret;
+
+	ret = hclge_init_vlan_filter(hdev);
+	if (ret)
+		return ret;
+
+	ret = hclge_init_vlan_type(hdev);
+	if (ret)
+		return ret;
+
+	ret = hclge_init_vport_vlan_offload(hdev);
+	if (ret)
+		return ret;
 
 	return hclge_set_vlan_filter(handle, htons(ETH_P_8021Q), 0, false);
 }
-- 
2.43.0



