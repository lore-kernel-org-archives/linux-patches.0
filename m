Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074D234403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301831; cv=none; b=lceoA5obHOlFpS0b2znRUt1W46kzxOVJZi5r8vIgN8ailYoIieaIM9150+a6HgiE1VmfJStR/ETvg9IcG814xpELC5r8mTc98b+40paYz5l0TKrQ09URspzt12fb4Ktn931lHIjFh5Ldh5QPIpCLPaQB4r1khGiSBC/j3k1AHck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301831; c=relaxed/simple;
	bh=oZwJQqHqtx6WR6wApXTxcCV/2TBU2W0BFC61IMEwgW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V368oR2ZzLNvZPIGa0v8K8xJXeAZdJ+F9BN7XKYVWzdruHLLnEiDdrbsJVQMWrqBFB53PNeshCHR/H+afS0V3ghVcP8Tr7bsR00NN3FIPjrSxL0dDMyoREr1vtRMgd7MwBImAxzQj12lguJYxrtFNcFrrc+xsQmPj/UVYeO1kFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROgkZ0Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROgkZ0Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CEBC19425;
	Sat, 28 Feb 2026 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301830;
	bh=oZwJQqHqtx6WR6wApXTxcCV/2TBU2W0BFC61IMEwgW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROgkZ0LvgdSaY/yc0rh/ModmvFcN7zfZoNlZNkNy5jQBM1bbmTXv8MxJ7wHmRjpb9
	 O5gDpWml9GnsvXuWE1l+JmNx4sgw8KmIaINCuPr44dnnPI4zoBvysPv/jL5jFJzVBy
	 PMR608bgB6f+3TWp600DPzz4/w4lh7DaHt+/SIUk+qI2ildcQoezErhV5n6NzmA+bp
	 89SBLcdLS8uoLgJtMoq5rFEaykE3Cl0zeuZx/Xfpzqvm7TN67JxGdsy/evUvA6EZ/9
	 Ur/WODKMBnixRv8kskAXH9AZ7DSCWcA5P3/EqtrF3C0I/Zqu/e6EzdcpqgOMlaTNFF
	 8M68bR0Q5ODXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/385] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Sat, 28 Feb 2026 12:57:49 -0500
Message-ID: <20260228180011.1568201-247-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index f9356cb89497b..82895859c90db 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6899,7 +6899,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 
 	INIT_WORK(&hr_dev->ecc_work, fmea_ram_ecc_work);
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "failed to create irq workqueue.\n");
 		ret = -ENOMEM;
-- 
2.51.0

