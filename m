Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FB138F62E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302171; cv=none; b=gHvEbr0ZTexG+fllLk3bXoj6ISdvq+zbszEgnkOF6dxCUZ0n4HAQ0CEYRKmpES8ExoLbE3HZv+7ew4z69q9zaBn0WDzJoyyGHHwF9jftVX6Dcmhrk10+5o+hkbjeE5DWuqYTq79hQGcudh70BbAqxkAchMDqXaUmTq/p6AHA4IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302171; c=relaxed/simple;
	bh=1Mmf4q3j7XjeDHYAYRXgy55/xrJnMfYGQLew+AVFIzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwGD44/U+762VhLDe2IHuYaan1p6oVVO1KzC0CSLMJBoOLDfFXSn1gdQbVymbAq8yB0TuzkUeD7JAgKgLS54oQPAzM/bL5L4vgx+a2Wpv5ZhqBDokxzY5nYDQA9zut0jpyusRLKNcF4ekcqRQW+09lbQkkkndEQNrQdOauPua5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFZMrXjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFZMrXjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0D1C116D0;
	Sat, 28 Feb 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302171;
	bh=1Mmf4q3j7XjeDHYAYRXgy55/xrJnMfYGQLew+AVFIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFZMrXjhYzQx257Y3+pRyKkAk9e9RTTxIVzbr2xp0hj3W3E2Q+rU8HWPMl7tDlc3E
	 RivebyfpBs2CIIOzKC/kM1mATUhaEHQeamFQ5zm+qR/ZKlOIX3NXPv9v5uUtkfCOD3
	 fBa2WTpdETlvFNSg4QHHKKigYzZkwbFtuTNbH5CjT55DN4kCcRPtxUDgdz7gAlmJU/
	 3zfmqeOE0QdS4bHg3ltmnxa5kn+oIH/InPg6NFQZMIuprCo/MbS1WC1CKABkxcw2Pl
	 Z7GgAhRvPXlXBoCWFe9+glGpG+iJGRzAcFOLzINHThAEIlk4JpmuVj/dyBnK0LlAW3
	 J7mhtCFS8oVFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/283] RDMA/hns: Notify ULP of remaining soft-WCs during reset
Date: Sat, 28 Feb 2026 13:05:11 -0500
Message-ID: <20260228180709.1583486-169-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 0789f929900d85b80b343c5f04f8b9444e991384 ]

During a reset, software-generated WCs cannot be reported via
interrupts. This may cause the ULP to miss some WCs.

To avoid this, add check in the CQ arm process: if a hardware reset
has occurred and there are still unreported soft-WCs, notify the ULP
to handle the remaining WCs, thereby preventing any loss of completions.

Fixes: 626903e9355b ("RDMA/hns: Add support for reporting wc as software mode")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2d4b751fc709d..b50529a652741 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3588,6 +3588,23 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 		     HNS_ROCE_V2_CQ_DEFAULT_INTERVAL);
 }
 
+static bool left_sw_wc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
+{
+	struct hns_roce_qp *hr_qp;
+
+	list_for_each_entry(hr_qp, &hr_cq->sq_list, sq_node) {
+		if (hr_qp->sq.head != hr_qp->sq.tail)
+			return true;
+	}
+
+	list_for_each_entry(hr_qp, &hr_cq->rq_list, rq_node) {
+		if (hr_qp->rq.head != hr_qp->rq.tail)
+			return true;
+	}
+
+	return false;
+}
+
 static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 				     enum ib_cq_notify_flags flags)
 {
@@ -3596,6 +3613,12 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 	struct hns_roce_v2_db cq_db = {};
 	u32 notify_flag;
 
+	if (hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN) {
+		if ((flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+		    left_sw_wc(hr_dev, hr_cq))
+			return 1;
+		return 0;
+	}
 	/*
 	 * flags = 0, then notify_flag : next
 	 * flags = 1, then notify flag : solocited
-- 
2.51.0

