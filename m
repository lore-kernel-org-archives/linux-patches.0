Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0446B1E6DCF;
	Thu, 30 Jan 2025 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247166; cv=none; b=MUdx16NvQLiZ6JAhA79fv0iwyf3tfZt+Gj5fGUpB6MSQbydM4V2fDO86iixcbLPFw1z8uHoZRBosIXeuXnhI5TrszXm6OH4cwi/Uealvg0Y3Xqnjh9r9DcUKAN3MpkMrZLkHbKcfitIeO67bEDuKmAGcdpxqq1eK9nx+ulCwwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247166; c=relaxed/simple;
	bh=ORTrMVxZCiCoNax+e/6yAsyF5HwUx/i+AE7pbq8wfBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1tO7mQR3o0yfHjpjSFNEhkA16lj+kfweqZqNVlSVizHr+WGw0Es52xuofa60UjBkM/caqUQ/h1jkEGhZ992YmBps4qp3ALRR26C3Be6OPvGUmEeyWg/XSsboHwcPkpgHVfwBOBRp/HI+xQmLpai0zXVMdMvCIdKuuyymY4lAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpNlrHpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpNlrHpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C01FC4CED2;
	Thu, 30 Jan 2025 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247165;
	bh=ORTrMVxZCiCoNax+e/6yAsyF5HwUx/i+AE7pbq8wfBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpNlrHpoibGMxtUJRpBNSR+XIqpkKVmEd7Q9rfe8n2AtWJTesAhCfdPEWeH+v+Fuf
	 hQurjE4gzHFx10kocTw06P7KNvVh0eLUDMnI6xVvr/h0FVl+8uqV5ZzK073vgwFK2E
	 RWuQ1UyVcP2i5HhljcZnTpVp+ZaZZ8dnuFrq1RWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 105/133] RDMA/hns: Fix deadlock on SRQ async events.
Date: Thu, 30 Jan 2025 15:01:34 +0100
Message-ID: <20250130140146.767195010@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

commit b46494b6f9c19f141114a57729e198698f40af37 upstream.

xa_lock for SRQ table may be required in AEQ. Use xa_store_irq()/
xa_erase_irq() to avoid deadlock.

Fixes: 81fce6291d99 ("RDMA/hns: Add SRQ asynchronous event support")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c |    1 +
 drivers/infiniband/hw/hns/hns_roce_srq.c  |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,6 +37,7 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
+#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include <rdma/hns-abi.h>
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -120,7 +120,7 @@ static int alloc_srqc(struct hns_roce_de
 		goto err_out;
 	}
 
-	ret = xa_err(xa_store(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
+	ret = xa_err(xa_store_irq(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
 	if (ret) {
 		ibdev_err(ibdev, "failed to store SRQC, ret = %d.\n", ret);
 		goto err_put;
@@ -149,7 +149,7 @@ static int alloc_srqc(struct hns_roce_de
 	return ret;
 
 err_xa:
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 
 err_put:
 	hns_roce_table_put(hr_dev, &srq_table->table, srq->srqn);
@@ -169,7 +169,7 @@ static void free_srqc(struct hns_roce_de
 		dev_err(hr_dev->dev, "DESTROY_SRQ failed (%d) for SRQN %06lx\n",
 			ret, srq->srqn);
 
-	xa_erase(&srq_table->xa, srq->srqn);
+	xa_erase_irq(&srq_table->xa, srq->srqn);
 
 	if (atomic_dec_and_test(&srq->refcount))
 		complete(&srq->free);


