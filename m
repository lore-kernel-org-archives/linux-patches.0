Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F7B1D0955;
	Wed,  2 Oct 2024 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878411; cv=none; b=OruxGBfkRNQxBDnDaKD5nANnTZS8hgook7EmrUp/SXeQmJQ06UmjX4NxcYQzd51CSZvkGxA8pYiFn0QumVSvEGsk/XuJJQiVhQ4bK78IgeH11sdkr/rTbYGp523Gy0IR4DnaXfXS/4XqwWUyiLxbPYLlPE0MGjHq6IL1K7n3MoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878411; c=relaxed/simple;
	bh=LgjMDVq2A0PROfVpo4emLVq/tk8SSlCUefffEW8KQsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLJf8Gzoef6CqgjHIht4mW8aYnZsXjK0vlUa2VaHVxTIMy+J2Fz2RJD9AcSNUF0Zu1AZ1yVQPJpkX2vo5sn+dEsa5uWkwGCdmRtxzR9pBVQfQeu1vz+09/rRNDd7eoZ98ghHobbn6LRGfr5oFS7kW5uzQYJax6SZvfW+oFQknDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEPaTGX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEPaTGX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F356C4CEC2;
	Wed,  2 Oct 2024 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878411;
	bh=LgjMDVq2A0PROfVpo4emLVq/tk8SSlCUefffEW8KQsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEPaTGX5Aq+rACzVTfl/0b6l9bbFd3YDt+BuBObVwRZccK8LEaNm+7jtsaLLIZeR/
	 1IPXyN7jTJLTTDHv8/62JRU5TPHU5i+i1P2AdOCOF+ia/Tdo+TE+8FDHetrIf6K/Xy
	 N9mAOoinvV4ZLQ9EIKlEwff7dptyGtE6rLHQLdgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 373/634] RDMA/hns: Dont modify rq next block addr in HIP09 QPC
Date: Wed,  2 Oct 2024 14:57:53 +0200
Message-ID: <20241002125825.821718660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6928d264e328e0cb5ee7663003a6e46e4cba0a7e ]

The field 'rq next block addr' in QPC can be updated by driver only
on HIP08. On HIP09 HW updates this field while driver is not allowed.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 621b057fb9daa..a166b476977f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4423,12 +4423,14 @@ static int config_qp_rq_buf(struct hns_roce_dev *hr_dev,
 		     upper_32_bits(to_hr_hw_page_addr(mtts[0])));
 	hr_reg_clear(qpc_mask, QPC_RQ_CUR_BLK_ADDR_H);
 
-	context->rq_nxt_blk_addr = cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
-	qpc_mask->rq_nxt_blk_addr = 0;
-
-	hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
-		     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
-	hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
+		context->rq_nxt_blk_addr =
+				cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
+		qpc_mask->rq_nxt_blk_addr = 0;
+		hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
+			     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
+		hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	}
 
 	return 0;
 }
-- 
2.43.0



