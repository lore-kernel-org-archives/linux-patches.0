Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF17359A70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302401; cv=none; b=dxlilMv3BFEyNcpuEjSoeB5V6/HnBlGdSUA4kjUlex+qM4RFx9x6r4WVs/PINsxIVIQqae+//vSy+Pqwm3QSFM+xO9/sVSjc3LS7eAhq0nwn/IZihDzhdqd2bPJZWLagIf55r787x31iahAmpVndov3qWPVnUXTUXPOX8Tpza+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302401; c=relaxed/simple;
	bh=yf7XSGNEhry8SYoGFfX+bOQ0h1KDhhJLh2pM2GqSH1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqIK8f0feNF3cBmC/4kv1p3ATuEl+YzZI3uiLFxJFiA3l8aRUozz8IpsFVuttyriOpNmMwcnN1uYEZknZXIJBAXo/e0K7MrWe9hbq6FaGJo6D8Yn/r73DhHKKwQOj6N0FccIxxfK/W+kCqfTU8GvYMo84a35xdwv9G4sO3R5OIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mr4wDO7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mr4wDO7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D96C116D0;
	Sat, 28 Feb 2026 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302401;
	bh=yf7XSGNEhry8SYoGFfX+bOQ0h1KDhhJLh2pM2GqSH1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr4wDO7woVQEF6dxcT/2x0yF2oVC0rHK4rUrQiuRWvpDzLZPv0q/i82t/BkxkftKS
	 nV9hHH8YwH/fgOatCXnIYNpdDEREPGU8ADKv4ztWZDJt+mNbpLI6CYb84Qj2FbDoZR
	 +JVf0uLP4ykCB0k9iozGU3hghqYYSRDfJu0Tc7ZUVEGc80QcExuzP+vL64j4NANwP3
	 LxAsoZ+ypci/BfKV5AxGp7mXjylaqgaknvc4rS302oTCWRW6Uz+Y1de+WXEpZ1QyPu
	 BAmd5qV98Tw+SryPu9BzTcFnj9mSP0Qy7LhEHIQe5u/vKKhtNH53N+yuH6Po6INRbX
	 1YwEu0O1GS88g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/232] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Sat, 28 Feb 2026 13:09:45 -0500
Message-ID: <20260228181127.1592657-132-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 5fdab366fb32d..c9aa4c8e05371 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6743,7 +6743,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 
 	INIT_WORK(&hr_dev->ecc_work, fmea_ram_ecc_work);
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "failed to create irq workqueue.\n");
 		ret = -ENOMEM;
-- 
2.51.0

