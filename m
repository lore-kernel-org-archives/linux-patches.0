Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A3C267386;
	Tue, 26 Aug 2025 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207898; cv=none; b=pnDIWljWdOJK7Kao92btCBf4iI4F5ImYsESkcsw2Xk6dU0vitkRJYd6SlNhgI+MWqJxsO4gFDWs3rCn+JNCy1ZRcjKtkHnCbkzEWQUYZXHd2R3uW/tzF9xP+GckFzZ9AZGKxPqB+vCtj3T/jonVVeeXVU9IQCPLlH/F8PbpQnvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207898; c=relaxed/simple;
	bh=XVIMPjdD8jr81rdaEhtIHKDOE783h5+vcMhgYaE6Jro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LS9JGfaLxDYLv1c9rQCizrkf20x8HRbQ6kjdlXW94k8tvy7raFmQStyept5hxnhvqgpRPTW+fAJK1dkkLkA9/XrnOdFfcyUHZl0WMrvb38RKSc71oMf5TX5LS49Yz1O+MI3xN5A6/ZilH74BNztEo50GvpEAkZI0CJc0zUAZxl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IET2KPtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IET2KPtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA07C4CEF4;
	Tue, 26 Aug 2025 11:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207897;
	bh=XVIMPjdD8jr81rdaEhtIHKDOE783h5+vcMhgYaE6Jro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IET2KPtZljWbV/eYFVll/Ykz3DNzZvnQtToPn2g1OCV2QqvlTRjd4IuCeDfNAEg8z
	 bQR4a9dC0PbPPnjjLmA9DgM/hYOVzLuLTsWB255Rn+BOr4nKV3snAZncHm5JG3RqYf
	 fUBsV+hNxQ5D6LS5dIqyE5teGkkwIslQEzz9kPRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 360/457] RDMA/hns: Fix querying wrong SCC context for DIP algorithm
Date: Tue, 26 Aug 2025 13:10:44 +0200
Message-ID: <20250826110946.209422878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 085a1b42e52750769a3fa29d4da6c05ab56f18f8 ]

When using DIP algorithm, all QPs establishing connections with
the same destination IP share the same SCC, which is indexed by
dip_idx, but dip_idx isn't necessarily equal to qpn. Therefore,
dip_idx should be used to query SCC context instead of qpn.

Fixes: 124a9fbe43aa ("RDMA/hns: Append SCC context to the raw dump of QPC")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250726075345.846957-1-huangjunxian6@hisilicon.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    | 4 ++--
 drivers/infiniband/hw/hns/hns_roce_restrack.c | 9 ++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b30dce00f240..256757f0ff65 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5514,7 +5514,7 @@ static int hns_roce_v2_query_srqc(struct hns_roce_dev *hr_dev, u32 srqn,
 	return ret;
 }
 
-static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 qpn,
+static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 sccn,
 				  void *buffer)
 {
 	struct hns_roce_v2_scc_context *context;
@@ -5526,7 +5526,7 @@ static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 qpn,
 		return PTR_ERR(mailbox);
 
 	ret = hns_roce_cmd_mbox(hr_dev, 0, mailbox->dma, HNS_ROCE_CMD_QUERY_SCCC,
-				qpn);
+				sccn);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index f637b73b946e..230187dda6a0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -100,6 +100,7 @@ int hns_roce_fill_res_qp_entry_raw(struct sk_buff *msg, struct ib_qp *ib_qp)
 		struct hns_roce_v2_qp_context qpc;
 		struct hns_roce_v2_scc_context sccc;
 	} context = {};
+	u32 sccn = hr_qp->qpn;
 	int ret;
 
 	if (!hr_dev->hw->query_qpc)
@@ -116,7 +117,13 @@ int hns_roce_fill_res_qp_entry_raw(struct sk_buff *msg, struct ib_qp *ib_qp)
 	    !hr_dev->hw->query_sccc)
 		goto out;
 
-	ret = hr_dev->hw->query_sccc(hr_dev, hr_qp->qpn, &context.sccc);
+	if (hr_qp->cong_type == CONG_TYPE_DIP) {
+		if (!hr_qp->dip)
+			goto out;
+		sccn = hr_qp->dip->dip_idx;
+	}
+
+	ret = hr_dev->hw->query_sccc(hr_dev, sccn, &context.sccc);
 	if (ret)
 		ibdev_warn_ratelimited(&hr_dev->ib_dev,
 				       "failed to query SCCC, ret = %d.\n",
-- 
2.50.1



