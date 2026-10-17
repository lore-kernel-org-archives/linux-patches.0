Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468AE18D62A;
	Sat, 17 Oct 2026 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260319; cv=none; b=Iv0S0NW8LFEzcpzRO6MFEotIEjh65uTrRWCleFCOIihbBhNfG1kQoVmYO0t/fbJLtFg77zEJTS18CrBRf8ikabjnkY+prfnJBBAT80FLjomcA2N5RIvVGT+1oiTeMJ/Omzb8opODzMOBBQCLEfGgT37Qwim/uFOW3S9Z179Lkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260319; c=relaxed/simple;
	bh=97ElIcv96l+No5kqcq1D7MQJcUNoavrFl+GI9WuSXzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEVxuJB0K+VB5mwkm64O5nKPfD1IKx8yIB+BAE+sZDtsZ+DXN1ccrkgFXTEfashFbYIMWGQCyXrnWPkV8Xb53huiCo++7ayzpGr1iG1Y7uEL+lXm7e9jtIXPEEV9k/m9rxRk5GHaYLjXV9JLrNHa5lWLQKt3Y0AauQGBDMhJ3AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWbaXM/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWbaXM/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998DA1F000C4;
	Sat, 17 Oct 2026 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260318;
	bh=XqJGLGwhKmQmwevtTxcniCLyfKlXaN94v36iEwhjn3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWbaXM/c3BK4c8BkN2ixf6IkIbm7sMvNPv7ZuoieqLYIwO8Ps+SDG3COxjXZCRZny
	 9TyTnL4nWa54Turz8vISd89f19nVAVMmiEL4yjn2Cd8XW/Py+a6zV0Uiuyw/j5dRx4
	 jz9geieLJ1OAh8y8XFHRT3AdU/YFlXjnRNGxXgdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1506/1674] iommu/arm-smmu-v3: Manage teardown with devm
Date: Sat, 17 Oct 2026 18:02:58 +0200
Message-ID: <20261017160509.789264792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shameer Kolothum <skolothumtho@nvidia.com>

[ Upstream commit 2bd22a0d40503a65d243b011de146603c8ce1cbc ]

arm_smmu_device_remove() manually frees the IOPF queue, destroys the
vmid_map and disables the device, while the IRQs and queues are devm
managed. devm unwinds only after remove() returns, so the cleanup runs
in the wrong order. The IOPF queue is freed before the event-queue IRQ
whose handler uses it.

Manage all of it with devm so the unwind order is correct. Free the IOPF
queue and vmid_map via devm actions, and disable the device from one
registered after arm_smmu_device_reset().

This is also a prerequisite for fixing a Tegra241 CMDQV CMD_SYNC
use-after-free in the subsequent patch.

Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 56 +++++++++++++++------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 70e5d7cda0c98..6f83556dda4d6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2962,6 +2962,20 @@ static int arm_smmu_cmdq_init(struct arm_smmu_device *smmu)
 	return 0;
 }
 
+static void arm_smmu_free_iopf_action(void *data)
+{
+	struct iopf_queue *queue = data;
+
+	iopf_queue_free(queue);
+}
+
+static void arm_smmu_destroy_vmid_map(void *data)
+{
+	struct ida *ida = data;
+
+	ida_destroy(ida);
+}
+
 static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 {
 	int ret;
@@ -2989,6 +3003,11 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 		smmu->evtq.iopf = iopf_queue_alloc(dev_name(smmu->dev));
 		if (!smmu->evtq.iopf)
 			return -ENOMEM;
+		ret = devm_add_action_or_reset(smmu->dev,
+					       arm_smmu_free_iopf_action,
+					       smmu->evtq.iopf);
+		if (ret)
+			return ret;
 	}
 
 	/* priq */
@@ -3105,7 +3124,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 
 	ida_init(&smmu->vmid_map);
 
-	return 0;
+	return devm_add_action_or_reset(smmu->dev, arm_smmu_destroy_vmid_map,
+					&smmu->vmid_map);
 }
 
 static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
@@ -3311,6 +3331,13 @@ static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
 	return ret;
 }
 
+static void arm_smmu_disable_action(void *data)
+{
+	struct arm_smmu_device *smmu = data;
+
+	arm_smmu_device_disable(smmu);
+}
+
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 {
 	int ret;
@@ -3892,7 +3919,7 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
-		goto err_free_iopf;
+		return ret;
 
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
@@ -3902,30 +3929,30 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu, bypass);
+	if (ret) {
+		arm_smmu_device_disable(smmu);
+		return ret;
+	}
+
+	/* Register last so it unwinds first, while the CMDQ is still up. */
+	ret = devm_add_action_or_reset(smmu->dev, arm_smmu_disable_action, smmu);
 	if (ret)
-		goto err_disable;
+		return ret;
 
 	/* And we're up. Go go go! */
 	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
 				     "smmu3.%pa", &ioaddr);
 	if (ret)
-		goto err_disable;
+		return ret;
 
 	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_free_sysfs;
+		iommu_device_sysfs_remove(&smmu->iommu);
+		return ret;
 	}
 
 	return 0;
-
-err_free_sysfs:
-	iommu_device_sysfs_remove(&smmu->iommu);
-err_disable:
-	arm_smmu_device_disable(smmu);
-err_free_iopf:
-	iopf_queue_free(smmu->evtq.iopf);
-	return ret;
 }
 
 static void arm_smmu_device_remove(struct platform_device *pdev)
@@ -3934,9 +3961,6 @@ static void arm_smmu_device_remove(struct platform_device *pdev)
 
 	iommu_device_unregister(&smmu->iommu);
 	iommu_device_sysfs_remove(&smmu->iommu);
-	arm_smmu_device_disable(smmu);
-	iopf_queue_free(smmu->evtq.iopf);
-	ida_destroy(&smmu->vmid_map);
 }
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)
-- 
2.53.0



