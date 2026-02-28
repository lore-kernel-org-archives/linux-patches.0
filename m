Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34339B94A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302584; cv=none; b=hvGvBoXyQLEntn5GfsztcwHLsgmxDrP0UeE/W2qEtxZW/CZaMQvBUA8X+kLr/LK0g2mnOLWHXV92u/rM7LI+WsmjzQnXc/ksh53mdtmu0u4KxSKEMCccqLxu3GiIPEG12BpgBDzq5E0LlDIIwi42SJ/ywmNQRIF7Qg/wpjoGGcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302584; c=relaxed/simple;
	bh=1akuxA7GZsQW7Wey1++G2Ngio2xTxkznj7ixvl43pkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqP19H3h5j2MoAD42fYzHQxFbdSUp7g4QFhFq0CUagwrakJN/lphkIok2eSFlyyeEJr9rBuhqA7VQrkwmbZumz3UtZs0nZ0bQHd7oYSY+9mbn2B66TVA7boKRzNFuihqqd4bAHgCAhfQhmhNHycjGl9cVZb1LvwPW5vrUCLYRxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0HmRnrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0HmRnrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4DEC19423;
	Sat, 28 Feb 2026 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302584;
	bh=1akuxA7GZsQW7Wey1++G2Ngio2xTxkznj7ixvl43pkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0HmRnrOCAtjvldAbRbS8G2G1Urzapmhy8sdETIFIHRUuAlPGIUcjndXOtRIHfSxi
	 e1asiJJ8fcEpb2HhOfSM2j0cKOdi73+hffwzRMkdej6w0CaGFVfZjQSNbgsl03d8WU
	 AKdJkL1eve36JjctfKn6q3TLqYe2UrPHyxCdQ37uSw+DgDDkwcVbWJpuoR2S+IIVrg
	 KgJvUP3RH5DfW7lEnJEyMHCAdq4UN6fnwS4+DoNrPUYJba9BTeANumtuPPH74zHYlf
	 y4YSkTwtMmvlTo2iAXyVnYN7cFzALdgNUgPzh6sX4KHAgAuIUT6BI1ULI7JxsPZCTX
	 K3kUU75+/K3AA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/164] RDMA/hns: Notify ULP of remaining soft-WCs during reset
Date: Sat, 28 Feb 2026 13:13:52 -0500
Message-ID: <20260228181505.1600663-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 8baf6fb2d1fa5..43b661f971882 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3376,6 +3376,23 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
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
@@ -3384,6 +3401,12 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
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

