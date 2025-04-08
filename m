Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B52135CD;
	Tue,  8 Apr 2025 11:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110719; cv=none; b=ZW65tg26HIFCxtIVlSZUJFBNbFuvZNWtZon7EHNH1zdknhl1VXGEhhHivUdiwBSkNuZFd/pILy9YIaGy4m2wf8Fe6j8fMnwstqu5cdRTSGZMFjgjZKOPtadxxJjMhorJ+kKt/iW1f0MLPphODN/51NhuyOp8MUmMbMA+NecW4Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110719; c=relaxed/simple;
	bh=mzd5gZR9Aah8b9xAj3TBPI4wZ4LHCg7MncETzJ+Cat8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfB+jFWivWBxILt0RDFaTG5jBbofP9aYkAgD4pgJyHrbi1izVNjhrzjTMd5rROY/5HZOEYwuuyhr11QOcM4ZVfYAuu6Kbzu8miSlor/2J+PdfnwJe4u/EO1QaqyQ9+XL0nVdddAGQWTkuMuHa9EhgtePdhLNBHJnoX8ikwjIyrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh54D2Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh54D2Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B98C4CEE5;
	Tue,  8 Apr 2025 11:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110719;
	bh=mzd5gZR9Aah8b9xAj3TBPI4wZ4LHCg7MncETzJ+Cat8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh54D2YiqG4vfOQb8o1cfhViHFjJkmykjDO/3FD1SsUSkI++LfA9WF8U0b3fQ/ceA
	 kTv3c5rIOe4TKT2+HpOrY1zMhnGGv4VG9mnlyVv6Bzj+DOUspkKoXDiDWaYrFNQ6Qq
	 Ol8UhXxIk+uJmnApsiGV6Eguk2cbUW0U95lD2FnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Zhao <haifeng.zhao@linux.intel.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 166/731] iommu/vt-d: Fix system hang on reboot -f
Date: Tue,  8 Apr 2025 12:41:03 +0200
Message-ID: <20250408104918.137294355@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit 9ce7603ad3cbae64003087de57834e8c5c856a20 ]

We found that executing the command ./a.out &;reboot -f (where a.out is a
program that only executes a while(1) infinite loop) can probabilistically
cause the system to hang in the intel_iommu_shutdown() function, rendering
it unresponsive. Through analysis, we identified that the factors
contributing to this issue are as follows:

1. The reboot -f command does not prompt the kernel to notify the
application layer to perform cleanup actions, allowing the application to
continue running.

2. When the kernel reaches the intel_iommu_shutdown() function, only the
BSP (Bootstrap Processor) CPU is operational in the system.

3. During the execution of intel_iommu_shutdown(), the function down_write
(&dmar_global_lock) causes the process to sleep and be scheduled out.

4. At this point, though the processor's interrupt flag is not cleared,
 allowing interrupts to be accepted. However, only legacy devices and NMI
(Non-Maskable Interrupt) interrupts could come in, as other interrupts
routing have already been disabled. If no legacy or NMI interrupts occur
at this stage, the scheduler will not be able to run.

5. If the application got scheduled at this time is executing a while(1)-
type loop, it will be unable to be preempted, leading to an infinite loop
and causing the system to become unresponsive.

To resolve this issue, the intel_iommu_shutdown() function should not
execute down_write(), which can potentially cause the process to be
scheduled out. Furthermore, since only the BSP is running during the later
stages of the reboot, there is no need for protection against parallel
access to the DMAR (DMA Remapping) unit. Therefore, the following lines
could be removed:

down_write(&dmar_global_lock);
up_write(&dmar_global_lock);

After testing, the issue has been resolved.

Fixes: 6c3a44ed3c55 ("iommu/vt-d: Turn off translations at shutdown")
Co-developed-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
Signed-off-by: Ethan Zhao <haifeng.zhao@linux.intel.com>
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://lore.kernel.org/r/20250303062421.17929-1-cuiyunhui@bytedance.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index bf1f0c8143483..25d31f8c129a6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2871,16 +2871,19 @@ void intel_iommu_shutdown(void)
 	if (no_iommu || dmar_disabled)
 		return;
 
-	down_write(&dmar_global_lock);
+	/*
+	 * All other CPUs were brought down, hotplug interrupts were disabled,
+	 * no lock and RCU checking needed anymore
+	 */
+	list_for_each_entry(drhd, &dmar_drhd_units, list) {
+		iommu = drhd->iommu;
 
-	/* Disable PMRs explicitly here. */
-	for_each_iommu(iommu, drhd)
+		/* Disable PMRs explicitly here. */
 		iommu_disable_protect_mem_regions(iommu);
 
-	/* Make sure the IOMMUs are switched off */
-	intel_disable_iommus();
-
-	up_write(&dmar_global_lock);
+		/* Make sure the IOMMUs are switched off */
+		iommu_disable_translation(iommu);
+	}
 }
 
 static struct intel_iommu *dev_to_intel_iommu(struct device *dev)
-- 
2.39.5



