Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4201175A98;
	Sat, 28 Feb 2026 17:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301401; cv=none; b=XRE6HnMTtd6nIXj2cBPLisc7EpBW57hANUhwsEetDjWi3MZcKuFCPor793ncHFBW8R8DXURSI2a+LDBgSrh+e68tehzE8i6PXW4UaIN6cNK3cQ4yZXToGfb/3al814TQmKWZrGdLA9MVE7MbE8tp2CfsX378fXbCWhNESejx3eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301401; c=relaxed/simple;
	bh=WuxCK1wydY82CCy7fyUfGoYlroN8zPTI2IvEl3U21/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxCmvbngkgJV0JE/nk/TajitbU6HMEEk3aqXmXkKyym/N86oOylsb2OoMiRlFfxMZ2AqguG6XOwetz1ndDZ1MHefQ//TQfh4nRbswzaGG2cbnVesxs/tvcG67TZHkRXNC70X0tVAG4ZY0REFWEPhAjp0istEoMdgNQk6fMsZ15g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0/VsDup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0/VsDup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C121C116D0;
	Sat, 28 Feb 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301400;
	bh=WuxCK1wydY82CCy7fyUfGoYlroN8zPTI2IvEl3U21/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0/VsDupwehHSJcaI0aurojltDr3EBR/nZq2gJvoX+Uj9wV2SSfQ37aTXdB5Sp/0o
	 CNMC52mRkktsMbe11JRl7G24nNitKelPMBqnUw9n1snCN3bav9C3qHQ80dcAwmHF24
	 lYn4aRuByCiN676XHKmVZHvUJdQB7yd0kzJwUzrbXot+hZJElDzIIWCdmZN0LcjjOD
	 M7sqD58z3jgYZKMKIfZnlqazeovKGf4OhF6o5NutDP6D/GPTJRISkepnrDsx5vf2WG
	 aOos0X43u4P+2dFhgnhU8wPVQGjqugqyODQDUz31WDm157FhcZ1P87X5RMnr7r5aHH
	 C9JECzH5SmGrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yi Liu <yi.l.liu@intel.com>,
	stable@vger.kernel.org,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 589/752] iommu/vt-d: Flush piotlb for SVM and Nested domain
Date: Sat, 28 Feb 2026 12:45:00 -0500
Message-ID: <20260228174750.1542406-589-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 04b1b069f151e793767755f58b51670bff00cbc1 ]

Besides the paging domains that use FS, SVM and Nested domains need to
use piotlb invalidation descriptor as well.

Fixes: b33125296b50 ("iommu/vt-d: Create unique domain ops for each stage")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20251223065824.6164-1-yi.l.liu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/cache.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 265e7290256b5..385ae5cfb30d4 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -363,6 +363,13 @@ static void qi_batch_add_pasid_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16
 	qi_batch_increment_index(iommu, batch);
 }
 
+static bool intel_domain_use_piotlb(struct dmar_domain *domain)
+{
+	return domain->domain.type == IOMMU_DOMAIN_SVA ||
+			domain->domain.type == IOMMU_DOMAIN_NESTED ||
+			intel_domain_is_fs_paging(domain);
+}
+
 static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *tag,
 				  unsigned long addr, unsigned long pages,
 				  unsigned long mask, int ih)
@@ -370,7 +377,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 	struct intel_iommu *iommu = tag->iommu;
 	u64 type = DMA_TLB_PSI_FLUSH;
 
-	if (intel_domain_is_fs_paging(domain)) {
+	if (intel_domain_use_piotlb(domain)) {
 		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid, addr,
 				    pages, ih, domain->qi_batch);
 		return;
-- 
2.51.0

