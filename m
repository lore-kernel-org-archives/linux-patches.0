Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4CF18B0A;
	Wed, 25 Feb 2026 01:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983356; cv=none; b=DTuf9A/Dd7PWv7x4/7dz84C/xjTqc04uWefAPmkdjSiZ54gMDpJVZS5+gDaK3NhQd7QKPUS1rnnH5CRBQKl+e/+FEJYLr6gVc1PMbvlnSzF8X1pWZsVdSV3q3apI3RPt3uBILfAkBKtIZJSqdQyirojoS51BHpgm0T5vXrswsac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983356; c=relaxed/simple;
	bh=aV71Fs4t4YyS0GqfkXkmzqk2SdLJ9kg8ju3t7IpZbBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrRfgPOPKhIpmi5V7B3jB16GCaeXqSuWoVo13hvVwbsR+znK5pRqWgN5Bta0nwDJRZM88fHfgc13xuAAcGabFnKCL8IAqDgsrD3bGYQrO64ljqcmSKGbYUrz3xiUj0v71hrDLhwD+KYLiyg8Aq705pcW1sC/QAx28HOMAKmzv6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqVVQmfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqVVQmfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3A0C116D0;
	Wed, 25 Feb 2026 01:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983356;
	bh=aV71Fs4t4YyS0GqfkXkmzqk2SdLJ9kg8ju3t7IpZbBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqVVQmfL3xJIDYL6wkLHFTDlWgpG7D5sQ2T31LpzgKb9pOxMnbomY4Ca6lX0o/Jkh
	 h6bQbqCXWFtV8U7LWdfGEkwvLUm9VOtAYexf1W98CzJ9dH6a6IVnaGpSx0FWLFBH6B
	 hXtoUropwaYR1Ue4HR5ou91soTa5UHcBXRO8cZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 441/781] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Tue, 24 Feb 2026 17:19:10 -0800
Message-ID: <20260225012410.516562687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit c0a26bbd3f99b7b03f072e3409aff4e6ec8af6f6 ]

When sunrpc is used, if a reset triggered, our wq may lead the
following trace:

workqueue: WQ_MEM_RECLAIM xprtiod:xprt_rdma_connect_worker [rpcrdma]
is flushing !WQ_MEM_RECLAIM hns_roce_irq_workq:flush_work_handle
[hns_roce_hw_v2]
WARNING: CPU: 0 PID: 8250 at kernel/workqueue.c:2644 check_flush_dependency+0xe0/0x144
Call trace:
  check_flush_dependency+0xe0/0x144
  start_flush_work.constprop.0+0x1d0/0x2f0
  __flush_work.isra.0+0x40/0xb0
  flush_work+0x14/0x30
  hns_roce_v2_destroy_qp+0xac/0x1e0 [hns_roce_hw_v2]
  ib_destroy_qp_user+0x9c/0x2b4
  rdma_destroy_qp+0x34/0xb0
  rpcrdma_ep_destroy+0x28/0xcc [rpcrdma]
  rpcrdma_ep_put+0x74/0xb4 [rpcrdma]
  rpcrdma_xprt_disconnect+0x1d8/0x260 [rpcrdma]
  xprt_rdma_connect_worker+0xc0/0x120 [rpcrdma]
  process_one_work+0x1cc/0x4d0
  worker_thread+0x154/0x414
  kthread+0x104/0x144
  ret_from_fork+0x10/0x18

Since QP destruction frees memory, this wq should have the WQ_MEM_RECLAIM.

Fixes: ffd541d45726 ("RDMA/hns: Add the workqueue framework for flush cqe handler")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2d6ae89e525b8..f95442798ddb3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6956,7 +6956,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 
 	INIT_WORK(&hr_dev->ecc_work, fmea_ram_ecc_work);
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "failed to create irq workqueue.\n");
 		ret = -ENOMEM;
-- 
2.51.0



