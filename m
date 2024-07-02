Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39F15218A;
	Tue,  2 Jul 2024 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940320; cv=none; b=hdc4r6oVx70x2Yr9A81reRnHwsVv1Yb/zXTTb4h0K5iO4p7wflV2K3JtEtnebqa5rhY/N3ruo1ttA2290bT9ZQSyDN7jDxxN5b/nbq+c91RRJvtqqbTAkG4Ylt15urdqeZ2wntGjY9iaC+nL9cLs02WYZy8xsp4Fv1+UwPacnyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940320; c=relaxed/simple;
	bh=BpFGrtqNnlqxVF1jDQtIzOZC3Q9jHX6GP0uIcf9KEYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNZ69s85TFuOzCcdlsk8CG1LgF0T0B1gvOF6LKBiBRFDNAYrHCLTqLDOE1OqQzQoVPuMJpt88q5uWuK05AkE9+J2PXpmJ4/wbfzNsfTtw6I1pUQ0d6cZwT0e5Uk1vi5QkkxrsWHdsFhM9v1JLfOthAJhpb6pfYwXpEGr5OvxphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y74Qg//G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y74Qg//G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D251C116B1;
	Tue,  2 Jul 2024 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940320;
	bh=BpFGrtqNnlqxVF1jDQtIzOZC3Q9jHX6GP0uIcf9KEYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y74Qg//G4GWjjZVEE7rxnv+B7YhzDAiUScJbV9wc/r5YvQGABqUrhvtb4ccxe1IZp
	 YW15FDkIK7e4tj9poekPVF+Zv3oivxJDEM2s/FO1IujZr0/ClASecHxgybiVnxOYrb
	 K2Wghin6yj40Vd+TeI/uUAhUh+K4zoHiGCHJjwXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 088/222] iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID
Date: Tue,  2 Jul 2024 19:02:06 +0200
Message-ID: <20240702170247.339561863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit fdc69d39e77f88264ee6e8174ff9aaf0953aecd9 ]

The SVA code is wired to assume that the SVA is programmed onto the
mm->pasid. The current core code always does this, so it is fine.

Add a check for clarity.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/3-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 2cd433a9c8a0f..41b44baef15e8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -569,6 +569,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
 
+	if (mm_get_enqcmd_pasid(mm) != id)
+		return -EINVAL;
+
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
-- 
2.43.0



