Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCBF3DAAA5;
	Thu, 17 Sep 2026 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667456; cv=none; b=OmDPfDQT05lEWAk2qoFMmaQostygQ19kh+Gc0zbM1iHEQVBirR2MJY24spS5mPlB9GeWG5sPF6qaBdNjCOqiBEIfdF+prbjWEc3c+VEV8CNgOo6b1mQ9LjtYz9RBw34Cz3GXiuDZy4f9ASlfvM07sxt3miImmMxV1se8ZX7sUWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667456; c=relaxed/simple;
	bh=ZbQbLDHSCSHH3cw9IcTck+I7aTXx8RyxFst0OjXSmOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTXf5zubggiwZ7YMEP+kH2cFfwZ9zxRdjqBWPacQGzozqeUAHdUAlYwN7B0l0gfac6+7BDo4F5sA/D6jlwqhErybWS6PJChYNTo/zneSf+AE6xgD+6Imu6ce61Cg972edzdAV/qum9/NlchbG4yz6UWXNSF4ey7SZh2/WbezBH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycKch34Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycKch34Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628321F000FF;
	Thu, 17 Sep 2026 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667452;
	bh=hTY3AIYyvkrCH9NJ+dV1M7ZD83ikrnb8SW7BGC4lGdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycKch34Y/8kwHD/MMpugyQ2XRpxmIuYEY/oRYFtiSx/MLcXm2AimN4G3DMPOP1hM5
	 7XmeSjDC4ENDq4ZKrSEHjp62t3e0TPIQVK91qSrQLXc1rKJX6+AFeciAhDepGgzVt2
	 cpv5/IkVf5a+V7Qpa6ZIFw5kFJaN/fymCvRe3IVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0099/1102] iommu: arm-smmu-qcom: Ensure smmu is powered up in set_ttbr0_cfg
Date: Thu, 17 Sep 2026 16:00:42 +0100
Message-ID: <20260917151541.978995102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 8a0aab012b52b5c044ca3bec523e91f95dd40765 ]

arm_smmu_write_context_bank() assumes it is being called with RPM
active, but it turns out that is not guaranteed in the path from
qcom_adreno_smmu_set_ttbr0_cfg(), so it's possible for the register
writes to get lost when configuring the context bank while the GPU is
idle, leading to page faults later.
Add the RPM calls here to make sure the SMMU is active before we touch
it.

Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index a5378c5949991..22586e986d8b3 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -142,6 +142,7 @@ static int qcom_adreno_smmu_set_ttbr0_cfg(const void *cookie,
 	struct io_pgtable *pgtable = io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops);
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 	struct arm_smmu_cb *cb = &smmu_domain->smmu->cbs[cfg->cbndx];
+	int ret;
 
 	/* The domain must have split pagetables already enabled */
 	if (cb->tcr[0] & ARM_SMMU_TCR_EPD1)
@@ -171,8 +172,16 @@ static int qcom_adreno_smmu_set_ttbr0_cfg(const void *cookie,
 		cb->ttbr[0] |= FIELD_PREP(ARM_SMMU_TTBRn_ASID, cb->cfg->asid);
 	}
 
+	ret = pm_runtime_resume_and_get(smmu_domain->smmu->dev);
+	if (ret < 0) {
+		dev_err(smmu_domain->smmu->dev, "failed to get runtime PM: %d\n", ret);
+		return -ENODEV;
+	}
+
 	arm_smmu_write_context_bank(smmu_domain->smmu, cb->cfg->cbndx);
 
+	pm_runtime_put_autosuspend(smmu_domain->smmu->dev);
+
 	return 0;
 }
 
-- 
2.53.0



