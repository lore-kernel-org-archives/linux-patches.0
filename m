Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966F521D3C0;
	Tue, 26 Aug 2025 11:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208843; cv=none; b=EgwKKYnRtJX0PamScpOXHi171vjql8tkxcfs9WYLeSV2P+nakpwWvd5Chn5/UGgyfiKVq8sK7bH8sY0vvYffMp+uQxSRg93cQTvioIxWgKFsWCei8XUPhYtebeZZ99K3W1GtC/OrXsAL2oH9tMxYmmyPXeNAlNFZPRGCys5WW+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208843; c=relaxed/simple;
	bh=uBK1usGmC4ly7g9G3EAzi/2SVFAHcpY4dj0i0PMvzIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL2y1ApYHSf93kKleKzPH1PNg3Lss+LlbR2tIq2pmhZym9c7vprg2twosJnOfpZ3Jsbh4ZyLHmOy05Gz36ooZw6yho+PEXjb1NsPFCDaON023dnQty+5+OLK5XhdNDgodzAZMnw8YNlTJPUizrEpO6/g1FQx2h/nKEm962x+sag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeGplWQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeGplWQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21DEC4CEF4;
	Tue, 26 Aug 2025 11:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208843;
	bh=uBK1usGmC4ly7g9G3EAzi/2SVFAHcpY4dj0i0PMvzIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeGplWQSeyW8iqn3sL46PoJxuiLzRbo0YO45jIs/v8hgEHKfdTXK3umwPObK2BCTY
	 QMaVbDeBTBe1AnkKmOVze2r++OUPCavcNe9btru3nScsV2BubwJvaxvnBWZYnSHrKf
	 8fJjf07ZmBfBJ5+qX3FIMYioXG1PwDs5fsNxTkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/322] RDMA/hns: Fix querying wrong SCC context for DIP algorithm
Date: Tue, 26 Aug 2025 13:11:21 +0200
Message-ID: <20250826110922.499346343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53fe0ef3883d..a7b3e4248ebb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5498,7 +5498,7 @@ static int hns_roce_v2_query_srqc(struct hns_roce_dev *hr_dev, u32 srqn,
 	return ret;
 }
 
-static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 qpn,
+static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 sccn,
 				  void *buffer)
 {
 	struct hns_roce_v2_scc_context *context;
@@ -5510,7 +5510,7 @@ static int hns_roce_v2_query_sccc(struct hns_roce_dev *hr_dev, u32 qpn,
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



