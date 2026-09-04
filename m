Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A748415F0B;
	Fri,  4 Sep 2026 05:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499837; cv=none; b=HzmiZvOwjKo7yHahSDUlZjZAbB0huP2mYRt3r4un862cr/YAnyEVNrxtHeLzDfIN/UpuiSfVTeNB1X0iT5E3qX9INciUz1TRCVjLXQf4o2lO57+zqVwS+JPJAwU3vDxH9q22xzq6fAoKN0kKD+xjAgo4OOWLbTPdKkZe62tWT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499837; c=relaxed/simple;
	bh=A3aC8zgLJXWyJLzAfOtxGXJTOdln1Z5cPvkuXvDb7Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5lEyA8dFxOcUZHu2ABBSxzKOsDQoSPI/HBmSF/TSR20/Z5wKHg7pmQyNG+bsTAu7MbeF1dOKL0B48F5idUHM/1VroSuAma0/qGFH7Y/38tlOm6gq2FFQmtL6CNI/7RSprFgS8uZsNeApitSI9m7zP3pCKIB8vUOkP2OAa0nSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RiXMzkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RiXMzkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D0F1F00A3D;
	Fri,  4 Sep 2026 05:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499836;
	bh=Cgn/b4Pg42aD5c6HPDPKyD9ohvjP9Wn6/mjQGtpcLfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RiXMzkQ4CsvIXQ/YVtB25Hn18WzzhSvfjHQWbEpX0nJ4FvvXy5yJKLeuBKJkCokE
	 mO08urm3/R7TZHmAmM6mXyNrOV6BVsZe+3s8Pw/QdNrRMtYr0jICCxVv7ziAb+d2T4
	 IgvAO4KRIKvOqysUNqN2KoieKiNBFrFrXQeB2mtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 541/713] iommu/arm-smmu-v3: Add HAFT support for SVA
Date: Fri,  4 Sep 2026 06:58:29 +0200
Message-ID: <20260904045815.946694334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit f99d3b4bb095c4966cf58154077e8bb69ee4827f upstream.

Since table access flags cannot be software-managed, if process
pagetables are using HAFT then SVA must require the SMMU to support and
enable it too, otherwise page aging is liable to get out of whack.

For unbinding, we can't disable HAFT atomically with HA as might be
desired, but luckily we can get away with just not disabling HA either.

Cc: stable@vger.kernel.org
Fixes: 62df5870ebf7 ("arm64: Enable ARCH_HAS_NONLEAF_PMD_YOUNG")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |   24 ++++++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |    9 ++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |    3 +++
 3 files changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -92,16 +92,6 @@ void arm_smmu_make_sva_cd(struct arm_smm
 
 		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
 					      CTXDESC_CD_1_TTB0_MASK);
-
-		/*
-		 * Enable Hardware Access and Dirty updates (DBM) if supported.
-		 * This is safe to enable by default, as PTE_WRITE and PTE_DBM
-		 * share the same bit.
-		 */
-		if (master->smmu->features & ARM_SMMU_FEAT_HA)
-			target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HA);
-		if (master->smmu->features & ARM_SMMU_FEAT_HD)
-			target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HD);
 	} else {
 		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
 
@@ -114,6 +104,17 @@ void arm_smmu_make_sva_cd(struct arm_smm
 			target->data[0] &=
 				cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
 	}
+	/*
+	 * Enable Hardware Access and Dirty updates (DBM) if supported. This is
+	 * safe to enable by default, as PTE_WRITE and PTE_DBM share the same bit,
+	 * while the EPD0 config can't get as far as fetching any PTEs anyway.
+	 */
+	if (master->smmu->features & ARM_SMMU_FEAT_HA)
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HA);
+	if (master->smmu->features & ARM_SMMU_FEAT_HD)
+		target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_HD);
+	if (master->smmu->features & ARM_SMMU_FEAT_HAFT && system_supports_haft())
+		target->data[1] |= cpu_to_le64(CTXDESC_CD_1_HAFT);
 
 	/*
 	 * MAIR value is pretty much constant and global, so we can just get it
@@ -211,6 +212,9 @@ bool arm_smmu_sva_supported(struct arm_s
 	if (system_supports_bbml2_noabort())
 		feat_mask |= ARM_SMMU_FEAT_BBML2;
 
+	if (system_supports_haft())
+		feat_mask |= ARM_SMMU_FEAT_HAFT;
+
 	if ((smmu->features & feat_mask) != feat_mask)
 		return false;
 
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4921,10 +4921,14 @@ static void arm_smmu_device_iidr_probe(s
 
 static void arm_smmu_get_httu(struct arm_smmu_device *smmu, u32 reg)
 {
-	u32 fw_features = smmu->features & (ARM_SMMU_FEAT_HA | ARM_SMMU_FEAT_HD);
+	u32 fw_features = smmu->features & (ARM_SMMU_FEAT_HA | ARM_SMMU_FEAT_HD |
+					    ARM_SMMU_FEAT_HAFT);
 	u32 hw_features = 0;
 
 	switch (FIELD_GET(IDR0_HTTU, reg)) {
+	case IDR0_HTTU_ACCESS_DIRTY_HAFT:
+		hw_features |= ARM_SMMU_FEAT_HAFT;
+		fallthrough;
 	case IDR0_HTTU_ACCESS_DIRTY:
 		hw_features |= ARM_SMMU_FEAT_HD;
 		fallthrough;
@@ -5256,6 +5260,9 @@ static int arm_smmu_device_acpi_probe(st
 		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
 
 	switch (FIELD_GET(ACPI_IORT_SMMU_V3_HTTU_OVERRIDE, iort_smmu->flags)) {
+	case IDR0_HTTU_ACCESS_DIRTY_HAFT:
+		smmu->features |= ARM_SMMU_FEAT_HAFT;
+		fallthrough;
 	case IDR0_HTTU_ACCESS_DIRTY:
 		smmu->features |= ARM_SMMU_FEAT_HD;
 		fallthrough;
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -40,6 +40,7 @@ struct arm_vsmmu;
 #define IDR0_HTTU			GENMASK(7, 6)
 #define IDR0_HTTU_ACCESS		1
 #define IDR0_HTTU_ACCESS_DIRTY		2
+#define IDR0_HTTU_ACCESS_DIRTY_HAFT	3
 #define IDR0_COHACC			(1 << 4)
 #define IDR0_TTF			GENMASK(3, 2)
 #define IDR0_TTF_AARCH64		2
@@ -369,6 +370,7 @@ static inline unsigned int arm_smmu_cdta
 #define CTXDESC_CD_0_ASET		(1UL << 47)
 #define CTXDESC_CD_0_ASID		GENMASK_ULL(63, 48)
 
+#define CTXDESC_CD_1_HAFT		(1UL << 3)
 #define CTXDESC_CD_1_TTB0_MASK		GENMASK_ULL(51, 4)
 
 /*
@@ -922,6 +924,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_HD		(1 << 22)
 #define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 #define ARM_SMMU_FEAT_BBML2		(1 << 24)
+#define ARM_SMMU_FEAT_HAFT		(1 << 25)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)


