Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98E1CF5FB;
	Wed,  2 Oct 2024 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880014; cv=none; b=X5g+lwmbCSgb/DkLV5Uw54Sj+OGNilWj3S4ruM7sMI71LYMyZinSAdZfHuPY4Y/EN8FztCInjnIoqrSAFkRWz2320YDJv1HWzTyiT1Dz8G1PDgEI9JjpO5Zo9IzGSo1ZdObUY3yN4RJajLnk/RbvxoZkHtfuMew/F2NGhMxpLKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880014; c=relaxed/simple;
	bh=05bzBse2JurtSvf4GuttQBi1Ib8ejb0Bi8xUkUmmJo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7UQ0+vyD5l9Xl1dMEIPuTOIYUtSw9Cl+x4z22mDBn3Z9T4xfMwcA+pGA1c9jBTmNLfBfGXGZQYJ+SCH43MjwbOlaAIMIrGTlDvqM+UT7eplKTGZcrYCvKN6UZW2Xw6RF0K/kmFuJKFRL8EVDFne1LHtQwfy0sB6pPFM6Zb3RP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5unszj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5unszj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7CEC4CEC5;
	Wed,  2 Oct 2024 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880014;
	bh=05bzBse2JurtSvf4GuttQBi1Ib8ejb0Bi8xUkUmmJo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5unszj5exDMpzLdBPb7tEVFkXdvAJ+lQlSK3BqNA4KsBbOHE4jBcEgg1K1YHDdKz
	 QbwrjnL3HTEXY/sMa6hV5ZjIS39mg86hpmx78CwzNICfNY6CSx2N0kV8/OvIflrqS8
	 qlID+VcDPqVaxmN4y3bouQyBKSu0ZNcma5LrywTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/538] RDMA/hns: Dont modify rq next block addr in HIP09 QPC
Date: Wed,  2 Oct 2024 14:59:14 +0200
Message-ID: <20241002125804.858331856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a49280e2df8ca..8f93aacde4936 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4391,12 +4391,14 @@ static int config_qp_rq_buf(struct hns_roce_dev *hr_dev,
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



