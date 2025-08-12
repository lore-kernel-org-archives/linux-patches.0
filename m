Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8722FA0FD;
	Tue, 12 Aug 2025 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024428; cv=none; b=P81Xk/WbXINAjEkcf9cAurromFm9D+bItesQXK7v3ptJLajlJt6eJnavneUxJSQBkL1TPAP+9xoQmt/RHyBn9aY0BDmXL4sCBmPmoYhk4HsskWCcRCrBBOj1NaK0RFI4TKFa7WVt4dkKCD1NCLJX2ada/uMmiFJtmmmK16Inz5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024428; c=relaxed/simple;
	bh=waOojJD76f/luOL9xcVHMbwDSMcYs7yHRep1x3EFLXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+o+RsqO9myJyrhJ3dhXfDQMe3FUJnqLlZ1Jz1SU69CkzlQI12aHog6fzepyxfZEg4catB75CCAM6JMtSPCMWkmnV+fx697R1LHaXq+fdBVTqQA0dXvP+0G/KLBdOMsBOYclYK1ab0gn3dqqzNliyHc6tm/oeetG2CosD8AwRU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9ei1Y5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9ei1Y5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A63C4CEF0;
	Tue, 12 Aug 2025 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024428;
	bh=waOojJD76f/luOL9xcVHMbwDSMcYs7yHRep1x3EFLXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9ei1Y5rPq5PsoWe2vFkKt9im+KgpfaZC56FuQN1SRr/VoHOj0Mi0l2QCb4CyUMTL
	 hqqyMyvxJNtTacOeAfy2IgHNrDgIl7/9rqm8TCC76Z5nE79RWEPgFOwzYI5B4lI+qg
	 JKkCsHs3saOQ70YSkFgvrdkVcTwtOHfvVCOl1jkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 370/627] RDMA/hns: Get message length of ack_req from FW
Date: Tue, 12 Aug 2025 19:31:05 +0200
Message-ID: <20250812173433.385578267@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 2c2ec0106c0f1f12d4eefd11de318ac47557a750 ]

ACK_REQ_FREQ indicates the number of packets (after MTU fragmentation)
HW sends before setting an ACK request. When MTU is greater than or
equal to 1024, the current ACK_REQ_FREQ value causes HW to request an
ACK for every MTU fragment. The processing of a large number of ACKs
severely impacts HW performance when sending large size payloads.

Get message length of ack_req from FW so that we can adjust this
parameter according to different situations. There are several
constraints for ACK_REQ_FREQ:

1. mtu * (2 ^ ACK_REQ_FREQ) should not be too large, otherwise it may
   cause some unexpected retries when sending large payload.

2. ACK_REQ_FREQ should be larger than or equal to LP_PKTN_INI.

3. ACK_REQ_FREQ must be equal to LP_PKTN_INI when using LDCP
   or HC3 congestion control algorithm.

Fixes: 56518a603fd2 ("RDMA/hns: Modify the value of long message loopback slice")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 45 ++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  8 +++-
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1dcc9cbb4678..254fd4d6ea9f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -856,6 +856,7 @@ struct hns_roce_caps {
 	u16		default_ceq_arm_st;
 	u8		cong_cap;
 	enum hns_roce_cong_type default_cong_type;
+	u32             max_ack_req_msg_len;
 };
 
 enum hns_roce_device_state {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2b04e25c6b09..246642859159 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2196,31 +2196,36 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 
 static int hns_roce_query_caps(struct hns_roce_dev *hr_dev)
 {
-	struct hns_roce_cmq_desc desc[HNS_ROCE_QUERY_PF_CAPS_CMD_NUM];
+	struct hns_roce_cmq_desc desc[HNS_ROCE_QUERY_PF_CAPS_CMD_NUM] = {};
 	struct hns_roce_caps *caps = &hr_dev->caps;
 	struct hns_roce_query_pf_caps_a *resp_a;
 	struct hns_roce_query_pf_caps_b *resp_b;
 	struct hns_roce_query_pf_caps_c *resp_c;
 	struct hns_roce_query_pf_caps_d *resp_d;
 	struct hns_roce_query_pf_caps_e *resp_e;
+	struct hns_roce_query_pf_caps_f *resp_f;
 	enum hns_roce_opcode_type cmd;
 	int ctx_hop_num;
 	int pbl_hop_num;
+	int cmd_num;
 	int ret;
 	int i;
 
 	cmd = hr_dev->is_vf ? HNS_ROCE_OPC_QUERY_VF_CAPS_NUM :
 	      HNS_ROCE_OPC_QUERY_PF_CAPS_NUM;
+	cmd_num = hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08 ?
+		  HNS_ROCE_QUERY_PF_CAPS_CMD_NUM_HIP08 :
+		  HNS_ROCE_QUERY_PF_CAPS_CMD_NUM;
 
-	for (i = 0; i < HNS_ROCE_QUERY_PF_CAPS_CMD_NUM; i++) {
+	for (i = 0; i < cmd_num - 1; i++) {
 		hns_roce_cmq_setup_basic_desc(&desc[i], cmd, true);
-		if (i < (HNS_ROCE_QUERY_PF_CAPS_CMD_NUM - 1))
-			desc[i].flag |= cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
-		else
-			desc[i].flag &= ~cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
+		desc[i].flag |= cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
 	}
 
-	ret = hns_roce_cmq_send(hr_dev, desc, HNS_ROCE_QUERY_PF_CAPS_CMD_NUM);
+	hns_roce_cmq_setup_basic_desc(&desc[cmd_num - 1], cmd, true);
+	desc[cmd_num - 1].flag &= ~cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
+
+	ret = hns_roce_cmq_send(hr_dev, desc, cmd_num);
 	if (ret)
 		return ret;
 
@@ -2229,6 +2234,7 @@ static int hns_roce_query_caps(struct hns_roce_dev *hr_dev)
 	resp_c = (struct hns_roce_query_pf_caps_c *)desc[2].data;
 	resp_d = (struct hns_roce_query_pf_caps_d *)desc[3].data;
 	resp_e = (struct hns_roce_query_pf_caps_e *)desc[4].data;
+	resp_f = (struct hns_roce_query_pf_caps_f *)desc[5].data;
 
 	caps->local_ca_ack_delay = resp_a->local_ca_ack_delay;
 	caps->max_sq_sg = le16_to_cpu(resp_a->max_sq_sg);
@@ -2293,6 +2299,8 @@ static int hns_roce_query_caps(struct hns_roce_dev *hr_dev)
 	caps->reserved_srqs = hr_reg_read(resp_e, PF_CAPS_E_RSV_SRQS);
 	caps->reserved_lkey = hr_reg_read(resp_e, PF_CAPS_E_RSV_LKEYS);
 
+	caps->max_ack_req_msg_len = le32_to_cpu(resp_f->max_ack_req_msg_len);
+
 	caps->qpc_hop_num = ctx_hop_num;
 	caps->sccc_hop_num = ctx_hop_num;
 	caps->srqc_hop_num = ctx_hop_num;
@@ -4573,7 +4581,9 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	dma_addr_t trrl_ba;
 	dma_addr_t irrl_ba;
 	enum ib_mtu ib_mtu;
+	u8 ack_req_freq;
 	const u8 *smac;
+	int lp_msg_len;
 	u8 lp_pktn_ini;
 	u64 *mtts;
 	u8 *dmac;
@@ -4656,7 +4666,8 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		return -EINVAL;
 #define MIN_LP_MSG_LEN 1024
 	/* mtu * (2 ^ lp_pktn_ini) should be in the range of 1024 to mtu */
-	lp_pktn_ini = ilog2(max(mtu, MIN_LP_MSG_LEN) / mtu);
+	lp_msg_len = max(mtu, MIN_LP_MSG_LEN);
+	lp_pktn_ini = ilog2(lp_msg_len / mtu);
 
 	if (attr_mask & IB_QP_PATH_MTU) {
 		hr_reg_write(context, QPC_MTU, ib_mtu);
@@ -4666,8 +4677,22 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 	hr_reg_write(context, QPC_LP_PKTN_INI, lp_pktn_ini);
 	hr_reg_clear(qpc_mask, QPC_LP_PKTN_INI);
 
-	/* ACK_REQ_FREQ should be larger than or equal to LP_PKTN_INI */
-	hr_reg_write(context, QPC_ACK_REQ_FREQ, lp_pktn_ini);
+	/*
+	 * There are several constraints for ACK_REQ_FREQ:
+	 * 1. mtu * (2 ^ ACK_REQ_FREQ) should not be too large, otherwise
+	 *    it may cause some unexpected retries when sending large
+	 *    payload.
+	 * 2. ACK_REQ_FREQ should be larger than or equal to LP_PKTN_INI.
+	 * 3. ACK_REQ_FREQ must be equal to LP_PKTN_INI when using LDCP
+	 *    or HC3 congestion control algorithm.
+	 */
+	if (hr_qp->cong_type == CONG_TYPE_LDCP ||
+	    hr_qp->cong_type == CONG_TYPE_HC3 ||
+	    hr_dev->caps.max_ack_req_msg_len < lp_msg_len)
+		ack_req_freq = lp_pktn_ini;
+	else
+		ack_req_freq = ilog2(hr_dev->caps.max_ack_req_msg_len / mtu);
+	hr_reg_write(context, QPC_ACK_REQ_FREQ, ack_req_freq);
 	hr_reg_clear(qpc_mask, QPC_ACK_REQ_FREQ);
 
 	hr_reg_clear(qpc_mask, QPC_RX_REQ_PSN_ERR);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index bc7466830eaf..1c2660305d27 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1168,7 +1168,8 @@ struct hns_roce_cfg_gmv_tb_b {
 #define GMV_TB_B_SMAC_H GMV_TB_B_FIELD_LOC(47, 32)
 #define GMV_TB_B_SGID_IDX GMV_TB_B_FIELD_LOC(71, 64)
 
-#define HNS_ROCE_QUERY_PF_CAPS_CMD_NUM 5
+#define HNS_ROCE_QUERY_PF_CAPS_CMD_NUM_HIP08 5
+#define HNS_ROCE_QUERY_PF_CAPS_CMD_NUM 6
 struct hns_roce_query_pf_caps_a {
 	u8 number_ports;
 	u8 local_ca_ack_delay;
@@ -1280,6 +1281,11 @@ struct hns_roce_query_pf_caps_e {
 	__le16 aeq_period;
 };
 
+struct hns_roce_query_pf_caps_f {
+	__le32 max_ack_req_msg_len;
+	__le32 rsv[5];
+};
+
 #define PF_CAPS_E_FIELD_LOC(h, l) \
 	FIELD_LOC(struct hns_roce_query_pf_caps_e, h, l)
 
-- 
2.39.5



