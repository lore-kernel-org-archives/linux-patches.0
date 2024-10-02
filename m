Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF8916F84F;
	Wed,  2 Oct 2024 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875661; cv=none; b=alxJ2txLtC9HOVDMoJzR4si31WmPs3FigoIFkNwA3aFw+p2QFofKapr+7WdhF2kLys1ynGnywzpEInOLzEPtg4oC7bVHCmuCvrbyhlDZhDXSYPBoBmc3xy6PesC3XgF/ODuXua2Zi9IVVKJ1zFSUwoC+UPAJteMElbaXezcp++c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875661; c=relaxed/simple;
	bh=GKl9UsGJ3Yv4+02QSeTxTyYB1jF8GI0EbNHm9utAMc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roq1yAB6II6EQM84OOA1ZEosdAcHM8jvmQCxsnmtF75RaH1Q+egQ5tY0pSRnaHdOiGKIof3Gl1mTvFbJZk67kBiqyXfLh6uYHw+1XSm/wM74rtyn4Ku6kULnKL+BJgGT4TDuPOF4txYCS/CVIVB2ZXqCjcpIRmL2IIBMgshiJmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMC7c6NN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMC7c6NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A407DC4CECE;
	Wed,  2 Oct 2024 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875661;
	bh=GKl9UsGJ3Yv4+02QSeTxTyYB1jF8GI0EbNHm9utAMc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMC7c6NNlw+/fbsxLvFHh2Ms+uzF6T+zPOSuaY81vqhiPImkrxIOBLst8hwfvSNDp
	 iYbb6O5g0eY7olVp08+EAABg/ws++lSZghbs8NLk9PmtlnIijWV/IJwST7SFP/463k
	 cI8O9yXKCmSIXV36EpAQjkip8hrK1eFJJzfLfgAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 177/695] iommu/arm-smmu-v3: Fix a NULL vs IS_ERR() check
Date: Wed,  2 Oct 2024 14:52:55 +0200
Message-ID: <20241002125829.537918109@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit af048ec9c05178206e845a88bfd3cb2884a43da7 ]

The arm_smmu_domain_alloc() function returns error pointers on error.  It
doesn't return NULL.  Update the error checking to match.

Fixes: 52acd7d8a413 ("iommu/arm-smmu-v3: Add support for domain_alloc_user fn")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/9208cd0d-8105-40df-93e9-bdcdf0d55eec@stanley.mountain
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ed2b106e02dd1..f490385c13605 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3062,8 +3062,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	smmu_domain = arm_smmu_domain_alloc();
-	if (!smmu_domain)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
-- 
2.43.0



