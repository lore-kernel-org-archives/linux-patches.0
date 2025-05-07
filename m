Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833ED288CB0;
	Wed,  7 May 2025 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643369; cv=none; b=f6L8Oz4TJVNO/HBLlOHWh+OEvm2vIwM8xUitamGBNhjYUmU9mX9CMbY4t+hYyjZGAWfTK+4eMqdvkDyrrcDtViMHtgkrZx7aknuHTyGdUFbhBwCuJ4cSQUsysOHI7DV0IHqiI98iq/XdSvhTlaKGbQtowP8BoCczUqnxOhFozHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643369; c=relaxed/simple;
	bh=HNRh4j7OXKFoyxrcn34cgTdWtBgzMy6QtM7iKz+PUx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBDkCcQpOeBMngenrrV/IQI4smLMJ601aKA5rJ7ie9B9gp1jVBSTPBNBhvJBzFuPtE1PFVrBJYMIaC0+uXu78IbpoauvAnRse85ur6DaNzZvq8yDXxW+lvaxl7aMfBbqP3or8Q5pFuMcNDp10YT4yENBpe1EWjUDY22HjRM1LSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jinaMU0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jinaMU0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1415C4CEE2;
	Wed,  7 May 2025 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643369;
	bh=HNRh4j7OXKFoyxrcn34cgTdWtBgzMy6QtM7iKz+PUx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jinaMU0Te/B1a4UIuLPPQH1W/vvwl6v8i+C0ScozDnjCiw0yCgxhiIzHwCTxx8G32
	 2vCtFCWo5iIqjfSPqjURfcZB+gM1iBG9Ds+oAztpNH1p1gfc+osA3i3rzYe/kTyxUn
	 8BfSK9fbTtT+SHooKgujU2K3VVsQ2/v07wF8fdm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/55] net: hns3: store rx VLAN tag offload state for VF
Date: Wed,  7 May 2025 20:39:38 +0200
Message-ID: <20250507183800.532295617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit ef2383d078edcbe3055032436b16cdf206f26de2 ]

The VF driver missed to store the rx VLAN tag strip state when
user change the rx VLAN tag offload state. And it will default
to enable the rx vlan tag strip when re-init VF device after
reset. So if user disable rx VLAN tag offload, and trig reset,
then the HW will still strip the VLAN tag from packet nad fill
into RX BD, but the VF driver will ignore it for rx VLAN tag
offload disabled. It may cause the rx VLAN tag dropped.

Fixes: b2641e2ad456 ("net: hns3: Add support of hardware rx-vlan-offload to HNS3 VF driver")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250430093052.2400464-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 25 ++++++++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7bb01eafba745..628d5c5ad75de 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1761,9 +1761,8 @@ static void hclgevf_sync_vlan_filter(struct hclgevf_dev *hdev)
 	rtnl_unlock();
 }
 
-static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
+static int hclgevf_en_hw_strip_rxvtag_cmd(struct hclgevf_dev *hdev, bool enable)
 {
-	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_vf_to_pf_msg send_msg;
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_VLAN,
@@ -1772,6 +1771,19 @@ static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
+static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	int ret;
+
+	ret = hclgevf_en_hw_strip_rxvtag_cmd(hdev, enable);
+	if (ret)
+		return ret;
+
+	hdev->rxvtag_strip_en = enable;
+	return 0;
+}
+
 static int hclgevf_reset_tqp(struct hnae3_handle *handle)
 {
 #define HCLGEVF_RESET_ALL_QUEUE_DONE	1U
@@ -2684,12 +2696,13 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 	return hclgevf_set_rss_tc_mode(hdev, rss_cfg->rss_size);
 }
 
-static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
+static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev,
+				    bool rxvtag_strip_en)
 {
 	struct hnae3_handle *nic = &hdev->nic;
 	int ret;
 
-	ret = hclgevf_en_hw_strip_rxvtag(nic, true);
+	ret = hclgevf_en_hw_strip_rxvtag(nic, rxvtag_strip_en);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to enable rx vlan offload, ret = %d\n", ret);
@@ -3359,7 +3372,7 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		return ret;
 
-	ret = hclgevf_init_vlan_config(hdev);
+	ret = hclgevf_init_vlan_config(hdev, hdev->rxvtag_strip_en);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed(%d) to initialize VLAN config\n", ret);
@@ -3472,7 +3485,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
-	ret = hclgevf_init_vlan_config(hdev);
+	ret = hclgevf_init_vlan_config(hdev, true);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed(%d) to initialize VLAN config\n", ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 2b216ac96914c..a6468fe2ec326 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -315,6 +315,7 @@ struct hclgevf_dev {
 	int *vector_irq;
 
 	bool gro_en;
+	bool rxvtag_strip_en;
 
 	unsigned long vlan_del_fail_bmap[BITS_TO_LONGS(VLAN_N_VID)];
 
-- 
2.39.5



