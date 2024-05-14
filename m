Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA3EF9D4;
	Tue, 14 May 2024 11:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687827; cv=none; b=nCpuJPJjeewTEz+jjdFL2QkU3wcdrqSdqXVnVW5vB0bbnedYLgBm7ROTgN6qESoYQUs9ng/K2sEfdj2Kd8Qpy3wwI1IowxI9aFj8QaO071DVDsPOIpp0Ch7zkXSWamQBVuOM6Syq4BahK0I6Zk0i5ZP2GFdKNT2jQO6daGY7t90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687827; c=relaxed/simple;
	bh=cXA699AnF75g0Pb+CNMxZqYu/jN8qsL2M5mXfGc6bJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0hfJE47//1/s7/LipJMCtoUzjm37YHKw8d7Y5xwCZE/xzigFGWz+0l+Aadn3FG2sSioT7ShLRNj3SQqvNIgcoRwWIaGgHhJ7gLRm0l5M+J0SNyOHgWhtd9ozdU6xkHUy/O8bx1E9wwxUAtSm26wsYAJ4ssu40jcn+4sHzHLi8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWB3bcTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWB3bcTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD8C2BD10;
	Tue, 14 May 2024 11:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687827;
	bh=cXA699AnF75g0Pb+CNMxZqYu/jN8qsL2M5mXfGc6bJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWB3bcTMLnej8JmKfMfw7J5FJgYaoNBFYMKpizcrACaaoeuh3TqZ0zIAJkDVG9tkf
	 GUac7KB7b81pnRbUZ7VRSWRF5EKSpGztFNvleUbKXK2aB7CKGaNwLsbqjXLr44Y3fC
	 TYuUTrIZr4vU6K6f9HZJGwk3qdlCesDoDGwQ/vD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/168] net: hns3: add query vf ring and vector map relation
Date: Tue, 14 May 2024 12:20:17 +0200
Message-ID: <20240514101011.176259525@linuxfoundation.org>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit a1aed456e3261c0096e36618db9aa61d5974ad16 ]

This patch adds a new mailbox opcode to query map relation between
vf ring and vector.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 669554c512d2 ("net: hns3: direct return when receive a unknown mailbox message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  1 +
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 83 +++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index e1ba0ae055b02..09a2a7c9fca43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -46,6 +46,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 	HCLGE_MBX_VF_UNINIT,            /* (VF -> PF) vf is unintializing */
 	HCLGE_MBX_HANDLE_VF_TBL,	/* (VF -> PF) store/clear hw table */
+	HCLGE_MBX_GET_RING_VECTOR_MAP,	/* (VF -> PF) get ring-to-vector map */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index ab6df4c1ea0f6..839555bf4bc49 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -250,6 +250,81 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
 	return ret;
 }
 
+static int hclge_query_ring_vector_map(struct hclge_vport *vport,
+				       struct hnae3_ring_chain_node *ring_chain,
+				       struct hclge_desc *desc)
+{
+	struct hclge_ctrl_vector_chain_cmd *req =
+		(struct hclge_ctrl_vector_chain_cmd *)desc->data;
+	struct hclge_dev *hdev = vport->back;
+	u16 tqp_type_and_id;
+	int status;
+
+	hclge_cmd_setup_basic_desc(desc, HCLGE_OPC_ADD_RING_TO_VECTOR, true);
+
+	tqp_type_and_id = le16_to_cpu(req->tqp_type_and_id[0]);
+	hnae3_set_field(tqp_type_and_id, HCLGE_INT_TYPE_M, HCLGE_INT_TYPE_S,
+			hnae3_get_bit(ring_chain->flag, HNAE3_RING_TYPE_B));
+	hnae3_set_field(tqp_type_and_id, HCLGE_TQP_ID_M, HCLGE_TQP_ID_S,
+			ring_chain->tqp_index);
+	req->tqp_type_and_id[0] = cpu_to_le16(tqp_type_and_id);
+	req->vfid = vport->vport_id;
+
+	status = hclge_cmd_send(&hdev->hw, desc, 1);
+	if (status)
+		dev_err(&hdev->pdev->dev,
+			"Get VF ring vector map info fail, status is %d.\n",
+			status);
+
+	return status;
+}
+
+static int hclge_get_vf_ring_vector_map(struct hclge_vport *vport,
+					struct hclge_mbx_vf_to_pf_cmd *req,
+					struct hclge_respond_to_vf_msg *resp)
+{
+#define HCLGE_LIMIT_RING_NUM			1
+#define HCLGE_RING_TYPE_OFFSET			0
+#define HCLGE_TQP_INDEX_OFFSET			1
+#define HCLGE_INT_GL_INDEX_OFFSET		2
+#define HCLGE_VECTOR_ID_OFFSET			3
+#define HCLGE_RING_VECTOR_MAP_INFO_LEN		4
+	struct hnae3_ring_chain_node ring_chain;
+	struct hclge_desc desc;
+	struct hclge_ctrl_vector_chain_cmd *data =
+		(struct hclge_ctrl_vector_chain_cmd *)desc.data;
+	u16 tqp_type_and_id;
+	u8 int_gl_index;
+	int ret;
+
+	req->msg.ring_num = HCLGE_LIMIT_RING_NUM;
+
+	memset(&ring_chain, 0, sizeof(ring_chain));
+	ret = hclge_get_ring_chain_from_mbx(req, &ring_chain, vport);
+	if (ret)
+		return ret;
+
+	ret = hclge_query_ring_vector_map(vport, &ring_chain, &desc);
+	if (ret) {
+		hclge_free_vector_ring_chain(&ring_chain);
+		return ret;
+	}
+
+	tqp_type_and_id = le16_to_cpu(data->tqp_type_and_id[0]);
+	int_gl_index = hnae3_get_field(tqp_type_and_id,
+				       HCLGE_INT_GL_IDX_M, HCLGE_INT_GL_IDX_S);
+
+	resp->data[HCLGE_RING_TYPE_OFFSET] = req->msg.param[0].ring_type;
+	resp->data[HCLGE_TQP_INDEX_OFFSET] = req->msg.param[0].tqp_index;
+	resp->data[HCLGE_INT_GL_INDEX_OFFSET] = int_gl_index;
+	resp->data[HCLGE_VECTOR_ID_OFFSET] = data->int_vector_id_l;
+	resp->len = HCLGE_RING_VECTOR_MAP_INFO_LEN;
+
+	hclge_free_vector_ring_chain(&ring_chain);
+
+	return ret;
+}
+
 static void hclge_set_vf_promisc_mode(struct hclge_vport *vport,
 				      struct hclge_mbx_vf_to_pf_cmd *req)
 {
@@ -749,6 +824,14 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			ret = hclge_map_unmap_ring_to_vf_vector(vport, false,
 								req);
 			break;
+		case HCLGE_MBX_GET_RING_VECTOR_MAP:
+			ret = hclge_get_vf_ring_vector_map(vport, req,
+							   &resp_msg);
+			if (ret)
+				dev_err(&hdev->pdev->dev,
+					"PF fail(%d) to get VF ring vector map\n",
+					ret);
+			break;
 		case HCLGE_MBX_SET_PROMISC_MODE:
 			hclge_set_vf_promisc_mode(vport, req);
 			break;
-- 
2.43.0



