Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAC347ACF9;
	Sat, 12 Sep 2026 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216126; cv=none; b=NHX2JLqliNBkAVWYHMTmItiAqVQUcp1VJ5WHKcrb9AgwWp63DZMU8lRQSmGZ00PN+BaSvsKfYzQburAFFnY/X1JQIN3Mx0yUoj/DkdM7KQftEf4qx3imZq8VuvFISA+tWA1eSqGyV5NUCnwG7Jz+ge/o+2MsOIc/P7TWNNPQO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216126; c=relaxed/simple;
	bh=Bk+Dj2aEjNgBrARRUxzcnHamrtZYSHLTXoXP1nqdyUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJqAwZKGoAvI88fQ8E/mTG1L8jeq5AhPL+ze3J3NfzzXZv/bowRvDIDdtOvxWH/x71InQAXFIMU7y5DsjoeQ4y9jgGFaDglzd2pbxpNOjzRK36/ZkB8lMBNkG+cr61ZT+H05W1Rq12jU6g899/Gn75Egch4GoFeEi+3cNNoL0u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2Bavq7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2Bavq7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C221F000FF;
	Sat, 12 Sep 2026 12:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216124;
	bh=mBHU6net3+bRKmzScNXzh+sxHo8Itgk+gAJBBjY/How=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2Bavq7yzJRQzPVyDJPNg5MPaZg184ZnhcHZ0k/moJ4IlvSrnIizO3ro203IpOEM5
	 axoZojXv1GGQUiZOdR++khQ7y7XESuLZf0SgFm5LkBFotVM04qI2DdM+/UKK+6jOrk
	 BHnIGVRK1DmgloyposFNJX7KT0s3xV75UOx/U2vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0673/1376] RDMA/erdma: Fix incorrect response returned from query_qp
Date: Sat, 12 Sep 2026 08:51:39 +0200
Message-ID: <20260912065622.546320335@linuxfoundation.org>
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

[ Upstream commit 3761e0ad79c137d61baf5f1518e4795f35fe8159 ]

The erdma_post_cmd_wait() function returns the cmdq response
only when both resp0 and resp1 are not NULL.

Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20241226084141.74823-3-boshiyu@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 652befcba956 ("RDMA/erdma: complete object teardown when the destroy command fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 3f2d2941e3103..2e5d6e721952b 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1783,7 +1783,7 @@ int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	struct erdma_cmdq_query_qp_req_rocev2 req;
 	struct erdma_dev *dev;
 	struct erdma_qp *qp;
-	u64 resp;
+	u64 resp0, resp1;
 	int ret;
 
 	if (ibqp && qp_attr && qp_init_attr) {
@@ -1817,20 +1817,20 @@ int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 					CMDQ_OPCODE_QUERY_QP);
 		req.qpn = QP_ID(qp);
 
-		ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), &resp,
-					  NULL);
+		ret = erdma_post_cmd_wait(&dev->cmdq, &req, sizeof(req), &resp0,
+					  &resp1);
 		if (ret)
 			return ret;
 
 		qp_attr->sq_psn =
-			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_SQ_PSN_MASK, resp);
+			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_SQ_PSN_MASK, resp0);
 		qp_attr->rq_psn =
-			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_RQ_PSN_MASK, resp);
-		qp_attr->qp_state = rocev2_to_ib_qps(
-			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_QP_STATE_MASK, resp));
+			FIELD_GET(ERDMA_CMD_QUERY_QP_RESP_RQ_PSN_MASK, resp0);
+		qp_attr->qp_state = rocev2_to_ib_qps(FIELD_GET(
+			ERDMA_CMD_QUERY_QP_RESP_QP_STATE_MASK, resp0));
 		qp_attr->cur_qp_state = qp_attr->qp_state;
 		qp_attr->sq_draining = FIELD_GET(
-			ERDMA_CMD_QUERY_QP_RESP_SQ_DRAINING_MASK, resp);
+			ERDMA_CMD_QUERY_QP_RESP_SQ_DRAINING_MASK, resp0);
 
 		qp_attr->pkey_index = 0;
 		qp_attr->dest_qp_num = qp->attrs.rocev2.dst_qpn;
-- 
2.53.0



