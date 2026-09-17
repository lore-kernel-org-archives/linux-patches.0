Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9585187DE;
	Thu, 17 Sep 2026 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665815; cv=none; b=bAdxyofr0ZC0frJgqzrcBkAoT/ilenHG2QH4FbxMASZCQZ+e4jZLug7ayn6x78BTwLzV/oKKM6wyyF2/htfXUWH/66y8Pvwh3yEE3GJ2LhvwhioBGmi9Qc+kfbeXL+CD0kB+ziCdAP5+bObIfTSLfjFN8vA/zp9PMgln/CtHugY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665815; c=relaxed/simple;
	bh=2ziL+ZG7q6TeedtRDyLig/8T6359yPrDRWc32hn2cLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOoVLLaonh8OJCewdRh/alge62rNjFuo3ZhZV2TaaXNn/VoHJyKOl9v96hHroSYpcYfeFmsZj/H7CPBs2udYwzR1jODCJOVzvnASfCj1i1sSuUbTYtjJj36r0m1/JdCE8rtSmkrFwiRcaAmqGBbBmxsMqxA3kdagX24jhT2f7/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG66lMHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG66lMHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF281F000FF;
	Thu, 17 Sep 2026 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665813;
	bh=2Nu0+e8AUHiuQedhZoCCNJnasGpgtv7YeFe+yTXQ2SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YG66lMHHjrhiK1Z5S6d24QD95VrEcdF8mepleTMhEDcc7Y0/bykmXSadbQeSn66vl
	 lb8J6+CQ4NyoL5wCPEmXEpFdu2M9v0CGIYSfprrmV0ycXVPk2V+evpjPhDnOTlhbyO
	 OxXPGQBuOi4oQOAFRNUNwKpPA74Fr+/ahOOPJnng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0830/1250] iommu/riscv: Add command queue lock
Date: Thu, 17 Sep 2026 16:10:25 +0100
Message-ID: <20260917151614.438173952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit d5bcf9ccaa357396089bbfa47fc82b093f109b1e ]

Add a raw spinlock to the RISC-V IOMMU queue state so command queue
publishing can be serialized by a later change.

Fixes: 856c0cfe5c5f ("iommu/riscv: Command and fault queue support")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 1 +
 drivers/iommu/riscv/iommu.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index de286563bd44e..d5611dcc162a8 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1687,6 +1687,7 @@ int riscv_iommu_init(struct riscv_iommu_device *iommu)
 	int rc;
 
 	RISCV_IOMMU_QUEUE_INIT(&iommu->cmdq, CQ);
+	raw_spin_lock_init(&iommu->cmdq.lock);
 	RISCV_IOMMU_QUEUE_INIT(&iommu->fltq, FQ);
 
 	rc = riscv_iommu_init_check(iommu);
diff --git a/drivers/iommu/riscv/iommu.h b/drivers/iommu/riscv/iommu.h
index 46df79dd54957..5676001548cc7 100644
--- a/drivers/iommu/riscv/iommu.h
+++ b/drivers/iommu/riscv/iommu.h
@@ -12,6 +12,7 @@
 #define _RISCV_IOMMU_H_
 
 #include <linux/iommu.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/iopoll.h>
 
@@ -23,6 +24,7 @@ struct riscv_iommu_queue {
 	atomic_t prod;				/* unbounded producer allocation index */
 	atomic_t head;				/* unbounded shadow ring buffer consumer index */
 	atomic_t tail;				/* unbounded shadow ring buffer producer index */
+	raw_spinlock_t lock;			/* serialize queue publishing */
 	unsigned int mask;			/* index mask, queue length - 1 */
 	unsigned int irq;			/* allocated interrupt number */
 	struct riscv_iommu_device *iommu;	/* iommu device handling the queue when active */
-- 
2.53.0



