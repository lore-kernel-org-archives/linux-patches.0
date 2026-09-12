Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA11F47D463;
	Sat, 12 Sep 2026 12:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216121; cv=none; b=YYwSAiBap9oPDp30yDc5JbGF4jJ57C7OQBkJypCbl3m3x9uN8ft/P2Ial/lLPvPfewLjP81Mbdk4rIhx+5S93KMzfSE8uJbCfeoR0zzAqYfDPMkE1Rzu0GleVDi8RY9JgntlO3GfI4K9fYTL74+l6Fig6wZnqFIBNSaxxwYcM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216121; c=relaxed/simple;
	bh=DvGDwBG4RqA4sOXKoZ2YXGMwyoYQzd9oa/aMb/RvjPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlx9jhLYGkBXWPVhJ9oa0PnK+e3zoysAFZ4Gfzx/jxXJ/94YQrZ7/D/IcHWrmx8jp4/AghE2SeOmexWNFOw+0hfl9IDxDqgD+994jSeXk0xmObVwmk4Ib3C3LiNpYtWsQEz0SgGZfgt+sMTrvourGEk/UplvgFhzAXl46Ix01hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUVuw6nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUVuw6nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97641F00893;
	Sat, 12 Sep 2026 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216119;
	bh=jL7gGDiXlsQ/+vs0J5LYU/E540zeEqgzAvhDYa4peQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUVuw6nnx9tvci+/jzpTRFnUXJDVHehBG+Zofz1fnNLa8vJ/qWjhC7+QITqZm4bTN
	 sx0RCdQ5/i0KHaEO+IaGWn/0IW9i/qyZbGbhuoiMDJBcyHOwssSkbxRgrvMBTVu670
	 1ZjlWRSZ40qfGaac4SQPN8bpwP1oc74BWGKPx6FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0672/1376] RDMA/erdma: Add the query_qp command to the cmdq
Date: Sat, 12 Sep 2026 08:51:38 +0200
Message-ID: <20260912065622.524398430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Boshi Yu <boshiyu@linux.alibaba.com>

[ Upstream commit 1cccbd3eec3d6370ddf9a003c1a1baeb8c155b3b ]

Certian QP attributes, such as sq_draining, can only be obtained
by querying the hardware on the erdma RoCEv2 device. To address this,
we add the query_qp command to the cmdq and parse the response to
retrieve corresponding QP attributes.

Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20241211020930.68833-8-boshiyu@linux.alibaba.com
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 652befcba956 ("RDMA/erdma: complete object teardown when the destroy command fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_hw.h    | 12 +++++
 drivers/infiniband/hw/erdma/erdma_verbs.c | 58 +++++++++++++++++++----
 2 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_hw.h b/drivers/infiniband/hw/erdma/erdma_hw.h
index 3b0f7fc4ff312..809e77dde271a 100644
--- a/drivers/infiniband/hw/erdma/erdma_hw.h
+++ b/drivers/infiniband/hw/erdma/erdma_hw.h
@@ -154,6 +154,7 @@ enum CMDQ_RDMA_OPCODE {
 	CMDQ_OPCODE_SET_GID = 14,
 	CMDQ_OPCODE_CREATE_AH = 15,
 	CMDQ_OPCODE_DESTROY_AH = 16,
+	CMDQ_OPCODE_QUERY_QP = 17,
 };
 
 enum CMDQ_COMMON_OPCODE {
@@ -362,6 +363,17 @@ struct erdma_cmdq_mod_qp_req_rocev2 {
 	struct erdma_av_cfg av_cfg;
 };
 
+/* query qp response mask */
+#define ERDMA_CMD_QUERY_QP_RESP_SQ_PSN_MASK GENMASK_ULL(23, 0)
+#define ERDMA_CMD_QUERY_QP_RESP_RQ_PSN_MASK GENMASK_ULL(47, 24)
+#define ERDMA_CMD_QUERY_QP_RESP_QP_STATE_MASK GENMASK_ULL(55, 48)
+#define ERDMA_CMD_QUERY_QP_RESP_SQ_DRAINING_MASK GENMASK_ULL(56, 56)
+
+struct erdma_cmdq_query_qp_req_rocev2 {
+	u64 hdr;
+	u32 qpn;
+};
+
 /* create qp cfg0 */
 #define ERDMA_CMD_CREATE_QP_SQ_DEPTH_MASK GENMASK(31, 20)
 #define ERDMA_CMD_CREATE_QP_QPN_MASK GENMASK(19, 0)
diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 707ca315bdfcc..3f2d2941e3103 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1566,6 +1566,19 @@ static void erdma_attr_to_av(const struct rdma_ah_attr *ah_attr,
 		av->ntype = ERDMA_NETWORK_TYPE_IPV6;
 }
 
+static void erdma_av_to_attr(struct erdma_av *av, struct rdma_ah_attr *ah_attr)
+{
+	ah_attr->type = RDMA_AH_ATTR_TYPE_ROCE;
+
+	rdma_ah_set_sl(ah_attr, av->sl);
+	rdma_ah_set_port_num(ah_attr, av->port);
+	rdma_ah_set_ah_flags(ah_attr, IB_AH_GRH);
+
+	rdma_ah_set_grh(ah_attr, NULL, av->flow_label, av->sgid_index,
+			av->hop_limit, av->traffic_class);
+	rdma_ah_set_dgid_raw(ah_attr, av->dgid);
+}
+
 static int ib_qps_to_erdma_qps[ERDMA_PROTO_COUNT][IB_QPS_ERR + 1] = {
 	[ERDMA_PROTO_IWARP] = {
 		[IB_QPS_RESET] = ERDMA_QPS_IWARP_IDLE,
@@ -1767,8 +1780,11 @@ static enum ib_qp_state query_qp_state(struct erdma_qp *qp)
 int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		   int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
 {
+	struct erdma_cmdq_query_qp_req_rocev2 req;
 	struct erdma_dev *dev;
 	struct erdma_qp *qp;
+	u64 resp;
+	int ret;
 
 	if (ibqp && qp_attr && qp_init_attr) {
 		qp = to_eqp(ibqp);
@@ -1795,8 +1811,37 @@ int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	qp_init_attr->cap = qp_attr->cap;
 
-	qp_attr->qp_state = query_qp_state(qp);
-	qp_attr->cur_qp_state = query_qp_state(qp);
+	if (erdma_device_rocev2(dev)) {
+		/* Query hardware to get some attributes */
+		erdma_cmdq_build_reqhdr(&req.hdr, CMDQ_SUBMOD_RDMA,
+					CMDQ_OPCODE_QUERY_QP);
+		req.qpn = QP_ID(qp);
+
+		ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), &resp,
+					  NULL);
+		if (ret)
+			return ret;
+
+		qp_attr->sq_psn =
+			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_SQ_PSN_MASK, resp);
+		qp_attr->rq_psn =
+			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_RQ_PSN_MASK, resp);
+		qp_attr->qp_state = rocev2_to_ib_qps(
+			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_QP_STATE_MASK, resp));
+		qp_attr->cur_qp_state = qp_attr->qp_state;
+		qp_attr->sq_draining = FIELD_GET(
+			ERDMA_CMD_QUERY_QP_RESP_SQ_DRAINING_MASK, resp);
+
+		qp_attr->pkey_index = 0;
+		qp_attr->dest_qp_num = qp->attrs.rocev2.dst_qpn;
+
+		if (qp->ibqp.qp_type == IB_QPT_RC)
+			erdma_av_to_attr(&qp->attrs.rocev2.av,
+					 &qp_attr->ah_attr);
+	} else {
+		qp_attr->qp_state = query_qp_state(qp);
+		qp_attr->cur_qp_state = qp_attr->qp_state;
+	}
 
 	return 0;
 }
@@ -2188,14 +2233,7 @@ int erdma_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 	struct erdma_ah *ah = to_eah(ibah);
 
 	memset(ah_attr, 0, sizeof(*ah_attr));
-
-	ah_attr->type = RDMA_AH_ATTR_TYPE_ROCE;
-	rdma_ah_set_sl(ah_attr, ah->av.sl);
-	rdma_ah_set_port_num(ah_attr, ah->av.port);
-	rdma_ah_set_ah_flags(ah_attr, IB_AH_GRH);
-	rdma_ah_set_grh(ah_attr, NULL, ah->av.flow_label, ah->av.sgid_index,
-			ah->av.hop_limit, ah->av.traffic_class);
-	rdma_ah_set_dgid_raw(ah_attr, ah->av.dgid);
+	erdma_av_to_attr(&ah->av, ah_attr);
 
 	return 0;
 }
-- 
2.53.0



