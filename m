Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F781D041D;
	Wed,  2 Oct 2024 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876319; cv=none; b=CKMemNCevH5FI6Q7VbpArY3aaIvNiL2AVGWdHjU0u5+tEpM941mh12UcumcNluSNHOp8Oh1+LqPyH6L2nXv3DvfKCvbPhO7vP6uCAYsL72MZawRY2fAlgXISYdp3yENGZlXXq7kPqFHqKVWapsw8OCltG79//3HPEVDIm9pvIks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876319; c=relaxed/simple;
	bh=qSjdl1b9YeUDcOHRI1jS9riNL0ao87js5HVGDq1NKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpA6amSZgD2Wq5MocAxkCDzIkDBkivJLCYKZTBLwAIoIakcftsor30AWdhHbKbnJ4N1eG6/88P0oSrwOS5OvWq8mD6D92kZn/qXY7i36hX463/HcNbO99GI779PqG8YN+A3D2Gbwyw8Vag/Jc1F9Kf7hHfBZ10oxayu4WdODMl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yffi1whw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yffi1whw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E54C4CEC5;
	Wed,  2 Oct 2024 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876319;
	bh=qSjdl1b9YeUDcOHRI1jS9riNL0ao87js5HVGDq1NKpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yffi1whwSE5fByYSLfiJMtKJfBDSgPvhkKhMnSKhcCuwlCEMYsFtBu0PrSkc0NxBc
	 suXM7iM1CHQmxfsiPG4Y/GusBKW7z5Sa98QJ5H9IWeO/ULupgGOZU1W5kkkdKCFaLq
	 xipYkdrCFR8F6aSTW48XG6oMGePKd0cvbwXf+pfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 404/695] RDMA/erdma: Return QP state in erdma_query_qp
Date: Wed,  2 Oct 2024 14:56:42 +0200
Message-ID: <20241002125838.582372271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit e77127ff6416b17e0b3e630ac46ee5c9a6570f57 ]

Fix qp_state and cur_qp_state to return correct values in
struct ib_qp_attr.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Link: https://patch.msgid.link/20240902112920.58749-4-chengyou@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 25 ++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index d7e1cbf9f5c26..7f6e3eaca3bbf 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1544,11 +1544,31 @@ int erdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 	return ret;
 }
 
+static enum ib_qp_state query_qp_state(struct erdma_qp *qp)
+{
+	switch (qp->attrs.state) {
+	case ERDMA_QP_STATE_IDLE:
+		return IB_QPS_INIT;
+	case ERDMA_QP_STATE_RTR:
+		return IB_QPS_RTR;
+	case ERDMA_QP_STATE_RTS:
+		return IB_QPS_RTS;
+	case ERDMA_QP_STATE_CLOSING:
+		return IB_QPS_ERR;
+	case ERDMA_QP_STATE_TERMINATE:
+		return IB_QPS_ERR;
+	case ERDMA_QP_STATE_ERROR:
+		return IB_QPS_ERR;
+	default:
+		return IB_QPS_ERR;
+	}
+}
+
 int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		   int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
 {
-	struct erdma_qp *qp;
 	struct erdma_dev *dev;
+	struct erdma_qp *qp;
 
 	if (ibqp && qp_attr && qp_init_attr) {
 		qp = to_eqp(ibqp);
@@ -1575,6 +1595,9 @@ int erdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	qp_init_attr->cap = qp_attr->cap;
 
+	qp_attr->qp_state = query_qp_state(qp);
+	qp_attr->cur_qp_state = query_qp_state(qp);
+
 	return 0;
 }
 
-- 
2.43.0



