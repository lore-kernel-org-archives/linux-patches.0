Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F138D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302171; cv=none; b=XuPraW7SPK/xCObSafPEBWdXT1nvm1/c87xBl40EU0irQtajSkweYvV+DX8ViwVpIjObr5g3Pya1odHEbvJ3LptIsjfjFKCOhW58f7rd8TEabGLLfIqzUdEaKXpsygSgArnviv6iYrnfKAjOvCUx81UzC/8x7Max7CmnJIiXak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302171; c=relaxed/simple;
	bh=J54/ZwKQozrQf11eVW692bsgNOOSVamBOxUQ+nLO8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYmfuaFvheqBNVUVxN6MxCUbQCaYapK8wApz1LdZJ9Q/quOKhp5rtkrcoEgUkgusW8UnhfYMDKNqS6m8/cogKHIlxFfEPGSw5TCJ+tt4ZSPpSvHfbl09N4ZIazP27vr2AU0160NQFuNst8kNXukcQk2v02ynAphhkgGvg0iDPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uvkm/cHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uvkm/cHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA52C19423;
	Sat, 28 Feb 2026 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302170;
	bh=J54/ZwKQozrQf11eVW692bsgNOOSVamBOxUQ+nLO8U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uvkm/cHfMtZwGFs9J2+bdbbYdqZgdQZ6HfzuCCCmjorjHhoxZTt0+7Ugx6jtu1Or/
	 WFqQjcvVOxmMo4iWjP3ksVALQk/+z/TT4egF1g86r9uvhIsc4bLmJllWdhhfl8aQA1
	 YT5k4dRCLXUrg+L/QOmJNMYjsBvbjIruH63Ts2eWXA0SbMxlRONIe04VjuCwkUr+Vp
	 7IjBGBJmY2NW0UpfVk5tLnfyJ/QWXnTIPRcI0e6hytfN13iqycDLHZ2KoLaDpaOOwJ
	 2u4lrLgVvN+L0vOOl4wmxXnrs9l31G8FJnnhCwz1nVLhWjgzH5qClDoyAktXF2VV4X
	 ibyV+pDxrskug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/283] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Sat, 28 Feb 2026 13:05:10 -0500
Message-ID: <20260228180709.1583486-168-sashal@kernel.org>
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
index f1d4494c7d008..2d4b751fc709d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6604,7 +6604,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 
 	INIT_WORK(&hr_dev->ecc_work, fmea_ram_ecc_work);
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "failed to create irq workqueue.\n");
 		ret = -ENOMEM;
-- 
2.51.0

