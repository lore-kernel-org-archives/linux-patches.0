Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF2481AB5;
	Tue, 25 Aug 2026 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664876; cv=none; b=CBOMvTEBbo54BP16p12JJMpcNyoUCxge9eipJCZsNMWZ4hCHhnaILhznPZePv0GomMXk1AKw+aegt/IJqc0Hblcq+0WIPhrB3Sfjt39aZD+AyBpHkUZCxKl0dVQK8oUNCoQpnto4PtF9lL6H/mvuDatErUMjnfTtvNfgMJf339M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664876; c=relaxed/simple;
	bh=Szirko0OctIW3mo+RSn6Df8TMCF4VyuMSw40fJFQklo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lb1DsmrZxkNnXCl+IGIWzpsdU/XMts7vfxQAl+MHF5tIFxQXZuIxsOINHllYHiyxHCyEDWrx4GOGt6IWd5BEGcSIdKvTqYFEuHkOQNIN1TI8eRnLlgEordFB9WW8T+jm1HdCelnEDPjhjvX4xDlUxfa95eCsmjgUEuEvSrAqA94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfFo1IFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfFo1IFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DCA1F000E9;
	Tue, 25 Aug 2026 13:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664874;
	bh=L12Az+p48EvwsGNHZFJVYKcdBxO3KmcBXjmYKnqWbCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfFo1IFWJ4wTz39fC++m1dF5OseEPyKRxBL+hXZh9ocoSsm8tbGucwaKeFaIBXKZm
	 kOodH26be/UR0oqb8PhrqXV3XT4x1dphYVZqalhSUNtB0zO1hzakIvdH7pMo/jy9mZ
	 wx0dDvwaMz1H6EjOTsfb7NFwSr7mLBcRDPvJX608=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.1 007/101] iommu/tegra241-cmdqv: Fix CMD_SYNC use-after-free on teardown
Date: Tue, 25 Aug 2026 15:24:45 +0200
Message-ID: <20260825132542.288692234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shameer Kolothum <skolothumtho@nvidia.com>

commit 9ff145a25c5c8a26b06ef7cf558fb536b18bba6d upstream.

arm_smmu_impl_remove() is registered as a devres action in
arm_smmu_impl_probe(), before arm_smmu_init_queues() allocates
smmu->cmdq.q.base. On a devres unwind, whether a failed probe or an
unbind, the queue is freed first and arm_smmu_impl_remove() then runs
tegra241_cmdqv_remove_vintf(), whose VINTF deinit issues a CMD_SYNC on
the freed memory.

Observed during testing with a QEMU hack that makes the VCMDQ fail to
enable, so the impl reset fails and probe aborts into the devres unwind:

 platform NVDA200C:00: tegra241_cmdqv: VINTF0: VCMDQ0/LVCMDQ0: failed to enable, STATUS=0x00000000
 platform NVDA200C:00: tegra241_cmdqv: VINTF0: VCMDQ0/LVCMDQ0: GERRORN=0x0, GERROR=0x4, CONS=0x0
 platform NVDA200C:00: tegra241_cmdqv: VINTF0: VCMDQ0/LVCMDQ0: uncleared error detected, resetting
 arm-smmu-v3 arm-smmu-v3.0.auto: failed to reset impl
 arm-smmu-v3 arm-smmu-v3.0.auto: probe with driver arm-smmu-v3 failed with error -110
 Unable to handle kernel paging request at virtual address ffff8000891e0098
 ...
 Internal error: Oops: 0000000096000047 [#1] SMP
 ...
 Call trace:
  arm_smmu_cmdq_issue_cmdlist+0x320/0x6fc (P)
  tegra241_vcmdq_hw_deinit+0x98/0x168
  tegra241_vintf_hw_deinit+0x5c/0x1b0
  tegra241_cmdqv_remove_vintf+0x34/0xec
  tegra241_cmdqv_remove+0x40/0x9c
  arm_smmu_impl_remove+0x20/0x30
  devm_action_release+0x14/0x20
  devres_release_all+0xa8/0x110
  device_unbind_cleanup+0x18/0x84
  really_probe+0x1f0/0x29c

Drop the VINTF deinit from tegra241_cmdqv_remove_vintf() so the unwind no
longer touches the freed queue. Quiesce the VINTFs earlier instead. Add a
device_disable() impl op and run it from arm_smmu_disable_action() while
the CMDQ is still up. That handles a live unbind. A failed reset is already
handled because tegra241_vintf_hw_init() deinits the VINTF on its own error
path. tegra241_cmdqv_remove_vintf() is also used by the iommufd viommu
destroy path, so quiesce there too.

Fixes: 4dc0d12474f9 ("iommu/tegra241-cmdqv: Add user-space use support")
Cc: stable@vger.kernel.org
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c    |    2 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h    |    1 +
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c |   15 +++++++++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -5591,6 +5591,8 @@ static void arm_smmu_device_shutdown(str
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
+	if (smmu->impl_ops && smmu->impl_ops->device_disable)
+		smmu->impl_ops->device_disable(smmu);
 	arm_smmu_device_disable(smmu);
 }
 
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -804,6 +804,7 @@ struct arm_smmu_strtab_cfg {
 
 struct arm_smmu_impl_ops {
 	int (*device_reset)(struct arm_smmu_device *smmu);
+	void (*device_disable)(struct arm_smmu_device *smmu);
 	void (*device_remove)(struct arm_smmu_device *smmu);
 	int (*init_structures)(struct arm_smmu_device *smmu);
 	struct arm_smmu_cmdq *(*get_secondary_cmdq)(
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -761,8 +761,6 @@ static void tegra241_cmdqv_remove_vintf(
 	struct tegra241_vintf *vintf = cmdqv->vintfs[idx];
 	u16 lidx;
 
-	tegra241_vintf_hw_deinit(vintf);
-
 	/* Remove LVCMDQ resources */
 	for (lidx = 0; lidx < vintf->cmdqv->num_lvcmdqs_per_vintf; lidx++)
 		if (vintf->lvcmdqs[lidx])
@@ -779,6 +777,17 @@ static void tegra241_cmdqv_remove_vintf(
 	}
 }
 
+static void tegra241_cmdqv_hw_disable(struct arm_smmu_device *smmu)
+{
+	struct tegra241_cmdqv *cmdqv =
+		container_of(smmu, struct tegra241_cmdqv, smmu);
+	u16 idx;
+
+	for (idx = 0; idx < cmdqv->num_vintfs; idx++)
+		if (cmdqv->vintfs[idx])
+			tegra241_vintf_hw_deinit(cmdqv->vintfs[idx]);
+}
+
 static void tegra241_cmdqv_remove(struct arm_smmu_device *smmu)
 {
 	struct tegra241_cmdqv *cmdqv =
@@ -844,6 +853,7 @@ static struct arm_smmu_impl_ops tegra241
 	/* For in-kernel use */
 	.get_secondary_cmdq = tegra241_cmdqv_get_cmdq,
 	.device_reset = tegra241_cmdqv_hw_reset,
+	.device_disable = tegra241_cmdqv_hw_disable,
 	.device_remove = tegra241_cmdqv_remove,
 	/* For user-space use */
 	.hw_info = tegra241_cmdqv_hw_info,
@@ -1152,6 +1162,7 @@ static void tegra241_cmdqv_destroy_vintf
 	if (vintf->mmap_offset)
 		iommufd_viommu_destroy_mmap(&vintf->vsmmu.core,
 					    vintf->mmap_offset);
+	tegra241_vintf_hw_deinit(vintf);
 	tegra241_cmdqv_remove_vintf(vintf->cmdqv, vintf->idx);
 }
 


