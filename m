Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FED421255;
	Fri,  4 Sep 2026 06:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502717; cv=none; b=iaP4nNh02KVLkneS3u1N5i0crwA5wMDr1W4QpgU1OjEZFhAzQ59DNH3GL7iaEa+17/MFLLjZEkvT29jI/flztXwoIJtLUD7WlATbMurBeVzHw5RN70UvmVFYVQTlYSdQwYOqf6IpsQe7PvOzC5B1H/nGGDDhOe72qTxUDKOIbrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502717; c=relaxed/simple;
	bh=FyI9uzvkufTwQC7e9enxPOYYgDWQcHiq6m9XXF5twAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm4eLq7V/bPYk108WBBAg8puWvs0VESMZgSIoa4FITKt7/el5dFsv/6p84YsfLTXHizzCKYoRWmpS3fYhzvBz3vMMHahTu/hMM+REDyiwZNvl7x7vibAcezj0mAJy4skkQZWmxqNrOQHbpZ/dSTrAd3FQetvEbi1MMwLfxDri8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4I5VZWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4I5VZWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9AB1F00A3D;
	Fri,  4 Sep 2026 06:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502716;
	bh=V0rKv5bOq0CCKvlgT0tbqf8Gd4pQ0C6kVvNy+/Rqcw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4I5VZWMVREAx0M+cmsyF6B4b6G65p2h52pN5PNa9+/FDIVrYYnURwCUhHJQJXw4v
	 zsXinvxERkuHmrCIiTyCcS20IaRF+BQA3KLNoEyhAoPv1BwWKTXha4lQ+FK4G+3dlU
	 +Wze/0PVC4YHE3rgRkmmmMnxwr1vfx9XKgij/m6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 304/403] iommu/arm-smmu-v3: Manage teardown with devm
Date: Fri,  4 Sep 2026 07:01:47 +0200
Message-ID: <20260904045741.756891186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shameer Kolothum <skolothumtho@nvidia.com>

commit 2bd22a0d40503a65d243b011de146603c8ce1cbc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   56 ++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 16 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3619,6 +3619,20 @@ int arm_smmu_cmdq_init(struct arm_smmu_d
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
@@ -3646,6 +3660,11 @@ static int arm_smmu_init_queues(struct a
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
@@ -3724,7 +3743,8 @@ static int arm_smmu_init_strtab(struct a
 
 	ida_init(&smmu->vmid_map);
 
-	return 0;
+	return devm_add_action_or_reset(smmu->dev, arm_smmu_destroy_vmid_map,
+					&smmu->vmid_map);
 }
 
 static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
@@ -3937,6 +3957,13 @@ static int arm_smmu_device_disable(struc
 	return ret;
 }
 
+static void arm_smmu_disable_action(void *data)
+{
+	struct arm_smmu_device *smmu = data;
+
+	arm_smmu_device_disable(smmu);
+}
+
 static void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -4646,7 +4673,7 @@ static int arm_smmu_device_probe(struct
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
-		goto err_free_iopf;
+		return ret;
 
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
@@ -4656,30 +4683,30 @@ static int arm_smmu_device_probe(struct
 
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu);
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
@@ -4688,9 +4715,6 @@ static void arm_smmu_device_remove(struc
 
 	iommu_device_unregister(&smmu->iommu);
 	iommu_device_sysfs_remove(&smmu->iommu);
-	arm_smmu_device_disable(smmu);
-	iopf_queue_free(smmu->evtq.iopf);
-	ida_destroy(&smmu->vmid_map);
 }
 
 static void arm_smmu_device_shutdown(struct platform_device *pdev)


