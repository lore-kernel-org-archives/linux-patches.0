Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21319F9D4;
	Tue, 14 May 2024 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687830; cv=none; b=Kc0qPtVichFRjWot9zO6QR/RKbm0jr/eoP32vtsa4ONQcOUPMDFwVEAlP9hMG1CI8mUilf6PpubnS3SOIxhAhdpZGsg6a8Pc8HoLQnoydCBDerZ3mN4CkKY63+lW7OBv3d31DG80wXJCzkfW3+Ssv/HYYxYI51pYvfQep0bDn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687830; c=relaxed/simple;
	bh=w+ZIuG/rQvzt+qsRl4G9cn5Cy9XUhFMoJtkSYCfoxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXl4+dlfi+TRMYpS3ESe26+zIMTaJItTVmdaWp/VVQcv2XrEREosYRH9lerg8vVc9raWDnGDE3GpzTFXZUGjMG0zNfx7luKlpHeWwWqIjpoxTjpPNXLuy4w7YWrVGOZT0KMIm2dk25Yvh1JBKzM8DsGAmhjm0MhzFUPscs88mc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=by14rWC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="by14rWC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADA2C2BD10;
	Tue, 14 May 2024 11:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687830;
	bh=w+ZIuG/rQvzt+qsRl4G9cn5Cy9XUhFMoJtkSYCfoxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=by14rWC54+l4QpjIL9XPOmjSv2WZZt3QmubHxADCQJVvAXACzhhrkjGjTHjMAvuS4
	 giuOFfNUZgG9lumVELwfSVQGhHjUr9G/syxx5f/y/STf4wl4+YEKMr4gv1cp/OhP7o
	 nswpxwhh9Q0LFWJSN/ueVPxww+usMrJzgxzyp5vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/168] net: hns3: refactor function hclge_mbx_handler()
Date: Tue, 14 May 2024 12:20:18 +0200
Message-ID: <20240514101011.214469100@linuxfoundation.org>
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

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit 09431ed8de874881e2d5d430042d718ae074d371 ]

Currently, the function hclge_mbx_handler() has too many switch-case
statements, it makes this function too long. To improve code readability,
refactor this function and use lookup table instead.

Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 669554c512d2 ("net: hns3: direct return when receive a unknown mailbox message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  11 +
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 415 ++++++++++++------
 2 files changed, 284 insertions(+), 142 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 09a2a7c9fca43..debbaa1822aa0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -212,6 +212,17 @@ struct hclgevf_mbx_arq_ring {
 	__le16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
+struct hclge_dev;
+
+#define HCLGE_MBX_OPCODE_MAX 256
+struct hclge_mbx_ops_param {
+	struct hclge_vport *vport;
+	struct hclge_mbx_vf_to_pf_cmd *req;
+	struct hclge_respond_to_vf_msg *resp_msg;
+};
+
+typedef int (*hclge_mbx_ops_fn)(struct hclge_mbx_ops_param *param);
+
 #define hclge_mbx_ring_ptr_move_crq(crq) \
 	(crq->next_to_use = (crq->next_to_use + 1) % crq->desc_num)
 #define hclge_mbx_tail_ptr_move_arq(arq) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 839555bf4bc49..39848bcd77c75 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -774,17 +774,284 @@ static void hclge_handle_vf_tbl(struct hclge_vport *vport,
 	}
 }
 
+static int
+hclge_mbx_map_ring_to_vector_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_map_unmap_ring_to_vf_vector(param->vport, true,
+						 param->req);
+}
+
+static int
+hclge_mbx_unmap_ring_to_vector_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_map_unmap_ring_to_vf_vector(param->vport, false,
+						 param->req);
+}
+
+static int
+hclge_mbx_get_ring_vector_map_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_get_vf_ring_vector_map(param->vport, param->req,
+					   param->resp_msg);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"PF fail(%d) to get VF ring vector map\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_set_promisc_mode_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_set_vf_promisc_mode(param->vport, param->req);
+	return 0;
+}
+
+static int hclge_mbx_set_unicast_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_set_vf_uc_mac_addr(param->vport, param->req);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"PF fail(%d) to set VF UC MAC Addr\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_set_multicast_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_set_vf_mc_mac_addr(param->vport, param->req);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"PF fail(%d) to set VF MC MAC Addr\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_set_vlan_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_set_vf_vlan_cfg(param->vport, param->req, param->resp_msg);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"PF failed(%d) to config VF's VLAN\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_set_alive_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_set_vf_alive(param->vport, param->req);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"PF failed(%d) to set VF's ALIVE\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_get_qinfo_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_vf_queue_info(param->vport, param->resp_msg);
+	return 0;
+}
+
+static int hclge_mbx_get_qdepth_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_vf_queue_depth(param->vport, param->resp_msg);
+	return 0;
+}
+
+static int hclge_mbx_get_basic_info_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_basic_info(param->vport, param->resp_msg);
+	return 0;
+}
+
+static int hclge_mbx_get_link_status_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_push_vf_link_status(param->vport);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"failed to inform link stat to VF, ret = %d\n",
+			ret);
+	return ret;
+}
+
+static int hclge_mbx_queue_reset_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_mbx_reset_vf_queue(param->vport, param->req,
+					param->resp_msg);
+}
+
+static int hclge_mbx_reset_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_reset_vf(param->vport);
+}
+
+static int hclge_mbx_keep_alive_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_vf_keep_alive(param->vport);
+	return 0;
+}
+
+static int hclge_mbx_set_mtu_handler(struct hclge_mbx_ops_param *param)
+{
+	int ret;
+
+	ret = hclge_set_vf_mtu(param->vport, param->req);
+	if (ret)
+		dev_err(&param->vport->back->pdev->dev,
+			"VF fail(%d) to set mtu\n", ret);
+	return ret;
+}
+
+static int hclge_mbx_get_qid_in_pf_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_get_queue_id_in_pf(param->vport, param->req,
+					param->resp_msg);
+}
+
+static int hclge_mbx_get_rss_key_handler(struct hclge_mbx_ops_param *param)
+{
+	return hclge_get_rss_key(param->vport, param->req, param->resp_msg);
+}
+
+static int hclge_mbx_get_link_mode_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_link_mode(param->vport, param->req);
+	return 0;
+}
+
+static int
+hclge_mbx_get_vf_flr_status_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_rm_vport_all_mac_table(param->vport, false,
+				     HCLGE_MAC_ADDR_UC);
+	hclge_rm_vport_all_mac_table(param->vport, false,
+				     HCLGE_MAC_ADDR_MC);
+	hclge_rm_vport_all_vlan_table(param->vport, false);
+	return 0;
+}
+
+static int hclge_mbx_vf_uninit_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_rm_vport_all_mac_table(param->vport, true,
+				     HCLGE_MAC_ADDR_UC);
+	hclge_rm_vport_all_mac_table(param->vport, true,
+				     HCLGE_MAC_ADDR_MC);
+	hclge_rm_vport_all_vlan_table(param->vport, true);
+	return 0;
+}
+
+static int hclge_mbx_get_media_type_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_vf_media_type(param->vport, param->resp_msg);
+	return 0;
+}
+
+static int hclge_mbx_push_link_status_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_handle_link_change_event(param->vport->back, param->req);
+	return 0;
+}
+
+static int hclge_mbx_get_mac_addr_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_get_vf_mac_addr(param->vport, param->resp_msg);
+	return 0;
+}
+
+static int hclge_mbx_ncsi_error_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_handle_ncsi_error(param->vport->back);
+	return 0;
+}
+
+static int hclge_mbx_handle_vf_tbl_handler(struct hclge_mbx_ops_param *param)
+{
+	hclge_handle_vf_tbl(param->vport, param->req);
+	return 0;
+}
+
+static const hclge_mbx_ops_fn hclge_mbx_ops_list[HCLGE_MBX_OPCODE_MAX] = {
+	[HCLGE_MBX_RESET]   = hclge_mbx_reset_handler,
+	[HCLGE_MBX_SET_UNICAST] = hclge_mbx_set_unicast_handler,
+	[HCLGE_MBX_SET_MULTICAST] = hclge_mbx_set_multicast_handler,
+	[HCLGE_MBX_SET_VLAN] = hclge_mbx_set_vlan_handler,
+	[HCLGE_MBX_MAP_RING_TO_VECTOR] = hclge_mbx_map_ring_to_vector_handler,
+	[HCLGE_MBX_UNMAP_RING_TO_VECTOR] = hclge_mbx_unmap_ring_to_vector_handler,
+	[HCLGE_MBX_SET_PROMISC_MODE] = hclge_mbx_set_promisc_mode_handler,
+	[HCLGE_MBX_GET_QINFO] = hclge_mbx_get_qinfo_handler,
+	[HCLGE_MBX_GET_QDEPTH] = hclge_mbx_get_qdepth_handler,
+	[HCLGE_MBX_GET_BASIC_INFO] = hclge_mbx_get_basic_info_handler,
+	[HCLGE_MBX_GET_RSS_KEY] = hclge_mbx_get_rss_key_handler,
+	[HCLGE_MBX_GET_MAC_ADDR] = hclge_mbx_get_mac_addr_handler,
+	[HCLGE_MBX_GET_LINK_STATUS] = hclge_mbx_get_link_status_handler,
+	[HCLGE_MBX_QUEUE_RESET] = hclge_mbx_queue_reset_handler,
+	[HCLGE_MBX_KEEP_ALIVE] = hclge_mbx_keep_alive_handler,
+	[HCLGE_MBX_SET_ALIVE] = hclge_mbx_set_alive_handler,
+	[HCLGE_MBX_SET_MTU] = hclge_mbx_set_mtu_handler,
+	[HCLGE_MBX_GET_QID_IN_PF] = hclge_mbx_get_qid_in_pf_handler,
+	[HCLGE_MBX_GET_LINK_MODE] = hclge_mbx_get_link_mode_handler,
+	[HCLGE_MBX_GET_MEDIA_TYPE] = hclge_mbx_get_media_type_handler,
+	[HCLGE_MBX_VF_UNINIT] = hclge_mbx_vf_uninit_handler,
+	[HCLGE_MBX_HANDLE_VF_TBL] = hclge_mbx_handle_vf_tbl_handler,
+	[HCLGE_MBX_GET_RING_VECTOR_MAP] = hclge_mbx_get_ring_vector_map_handler,
+	[HCLGE_MBX_GET_VF_FLR_STATUS] = hclge_mbx_get_vf_flr_status_handler,
+	[HCLGE_MBX_PUSH_LINK_STATUS] = hclge_mbx_push_link_status_handler,
+	[HCLGE_MBX_NCSI_ERROR] = hclge_mbx_ncsi_error_handler,
+};
+
+static void hclge_mbx_request_handling(struct hclge_mbx_ops_param *param)
+{
+	hclge_mbx_ops_fn cmd_func = NULL;
+	struct hclge_dev *hdev;
+	int ret = 0;
+
+	hdev = param->vport->back;
+	cmd_func = hclge_mbx_ops_list[param->req->msg.code];
+	if (cmd_func)
+		ret = cmd_func(param);
+	else
+		dev_err(&hdev->pdev->dev,
+			"un-supported mailbox message, code = %u\n",
+			param->req->msg.code);
+
+	/* PF driver should not reply IMP */
+	if (hnae3_get_bit(param->req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
+	    param->req->msg.code < HCLGE_MBX_GET_VF_FLR_STATUS) {
+		param->resp_msg->status = ret;
+		if (time_is_before_jiffies(hdev->last_mbx_scheduled +
+					   HCLGE_MBX_SCHED_TIMEOUT))
+			dev_warn(&hdev->pdev->dev,
+				 "resp vport%u mbx(%u,%u) late\n",
+				 param->req->mbx_src_vfid,
+				 param->req->msg.code,
+				 param->req->msg.subcode);
+
+		hclge_gen_resp_to_vf(param->vport, param->req, param->resp_msg);
+	}
+}
+
 void hclge_mbx_handler(struct hclge_dev *hdev)
 {
 	struct hclge_cmq_ring *crq = &hdev->hw.cmq.crq;
 	struct hclge_respond_to_vf_msg resp_msg;
 	struct hclge_mbx_vf_to_pf_cmd *req;
-	struct hclge_vport *vport;
+	struct hclge_mbx_ops_param param;
 	struct hclge_desc *desc;
-	bool is_del = false;
 	unsigned int flag;
-	int ret = 0;
 
+	param.resp_msg = &resp_msg;
 	/* handle all the mailbox requests in the queue */
 	while (!hclge_cmd_crq_empty(&hdev->hw)) {
 		if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state)) {
@@ -808,152 +1075,16 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			continue;
 		}
 
-		vport = &hdev->vport[req->mbx_src_vfid];
-
 		trace_hclge_pf_mbx_get(hdev, req);
 
 		/* clear the resp_msg before processing every mailbox message */
 		memset(&resp_msg, 0, sizeof(resp_msg));
-
-		switch (req->msg.code) {
-		case HCLGE_MBX_MAP_RING_TO_VECTOR:
-			ret = hclge_map_unmap_ring_to_vf_vector(vport, true,
-								req);
-			break;
-		case HCLGE_MBX_UNMAP_RING_TO_VECTOR:
-			ret = hclge_map_unmap_ring_to_vf_vector(vport, false,
-								req);
-			break;
-		case HCLGE_MBX_GET_RING_VECTOR_MAP:
-			ret = hclge_get_vf_ring_vector_map(vport, req,
-							   &resp_msg);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to get VF ring vector map\n",
-					ret);
-			break;
-		case HCLGE_MBX_SET_PROMISC_MODE:
-			hclge_set_vf_promisc_mode(vport, req);
-			break;
-		case HCLGE_MBX_SET_UNICAST:
-			ret = hclge_set_vf_uc_mac_addr(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to set VF UC MAC Addr\n",
-					ret);
-			break;
-		case HCLGE_MBX_SET_MULTICAST:
-			ret = hclge_set_vf_mc_mac_addr(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to set VF MC MAC Addr\n",
-					ret);
-			break;
-		case HCLGE_MBX_SET_VLAN:
-			ret = hclge_set_vf_vlan_cfg(vport, req, &resp_msg);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to config VF's VLAN\n",
-					ret);
-			break;
-		case HCLGE_MBX_SET_ALIVE:
-			ret = hclge_set_vf_alive(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"PF failed(%d) to set VF's ALIVE\n",
-					ret);
-			break;
-		case HCLGE_MBX_GET_QINFO:
-			hclge_get_vf_queue_info(vport, &resp_msg);
-			break;
-		case HCLGE_MBX_GET_QDEPTH:
-			hclge_get_vf_queue_depth(vport, &resp_msg);
-			break;
-		case HCLGE_MBX_GET_BASIC_INFO:
-			hclge_get_basic_info(vport, &resp_msg);
-			break;
-		case HCLGE_MBX_GET_LINK_STATUS:
-			ret = hclge_push_vf_link_status(vport);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"failed to inform link stat to VF, ret = %d\n",
-					ret);
-			break;
-		case HCLGE_MBX_QUEUE_RESET:
-			ret = hclge_mbx_reset_vf_queue(vport, req, &resp_msg);
-			break;
-		case HCLGE_MBX_RESET:
-			ret = hclge_reset_vf(vport);
-			break;
-		case HCLGE_MBX_KEEP_ALIVE:
-			hclge_vf_keep_alive(vport);
-			break;
-		case HCLGE_MBX_SET_MTU:
-			ret = hclge_set_vf_mtu(vport, req);
-			if (ret)
-				dev_err(&hdev->pdev->dev,
-					"VF fail(%d) to set mtu\n", ret);
-			break;
-		case HCLGE_MBX_GET_QID_IN_PF:
-			ret = hclge_get_queue_id_in_pf(vport, req, &resp_msg);
-			break;
-		case HCLGE_MBX_GET_RSS_KEY:
-			ret = hclge_get_rss_key(vport, req, &resp_msg);
-			break;
-		case HCLGE_MBX_GET_LINK_MODE:
-			hclge_get_link_mode(vport, req);
-			break;
-		case HCLGE_MBX_GET_VF_FLR_STATUS:
-		case HCLGE_MBX_VF_UNINIT:
-			is_del = req->msg.code == HCLGE_MBX_VF_UNINIT;
-			hclge_rm_vport_all_mac_table(vport, is_del,
-						     HCLGE_MAC_ADDR_UC);
-			hclge_rm_vport_all_mac_table(vport, is_del,
-						     HCLGE_MAC_ADDR_MC);
-			hclge_rm_vport_all_vlan_table(vport, is_del);
-			break;
-		case HCLGE_MBX_GET_MEDIA_TYPE:
-			hclge_get_vf_media_type(vport, &resp_msg);
-			break;
-		case HCLGE_MBX_PUSH_LINK_STATUS:
-			hclge_handle_link_change_event(hdev, req);
-			break;
-		case HCLGE_MBX_GET_MAC_ADDR:
-			hclge_get_vf_mac_addr(vport, &resp_msg);
-			break;
-		case HCLGE_MBX_NCSI_ERROR:
-			hclge_handle_ncsi_error(hdev);
-			break;
-		case HCLGE_MBX_HANDLE_VF_TBL:
-			hclge_handle_vf_tbl(vport, req);
-			break;
-		default:
-			dev_err(&hdev->pdev->dev,
-				"un-supported mailbox message, code = %u\n",
-				req->msg.code);
-			break;
-		}
-
-		/* PF driver should not reply IMP */
-		if (hnae3_get_bit(req->mbx_need_resp, HCLGE_MBX_NEED_RESP_B) &&
-		    req->msg.code < HCLGE_MBX_GET_VF_FLR_STATUS) {
-			resp_msg.status = ret;
-			if (time_is_before_jiffies(hdev->last_mbx_scheduled +
-						   HCLGE_MBX_SCHED_TIMEOUT))
-				dev_warn(&hdev->pdev->dev,
-					 "resp vport%u mbx(%u,%u) late\n",
-					 req->mbx_src_vfid,
-					 req->msg.code,
-					 req->msg.subcode);
-
-			hclge_gen_resp_to_vf(vport, req, &resp_msg);
-		}
+		param.vport = &hdev->vport[req->mbx_src_vfid];
+		param.req = req;
+		hclge_mbx_request_handling(&param);
 
 		crq->desc[crq->next_to_use].flag = 0;
 		hclge_mbx_ring_ptr_move_crq(crq);
-
-		/* reinitialize ret after complete the mbx message processing */
-		ret = 0;
 	}
 
 	/* Write back CMDQ_RQ header pointer, M7 need this pointer */
-- 
2.43.0



