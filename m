Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5D12B176;
	Tue, 30 Apr 2024 10:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474741; cv=none; b=RCpLLXf+QxzHVgrgGAs9pLdrhmPG2DvkuIzHFThD+CY6dzfovdRP5A3Jy2LP4+x8nP20aQBz8IuYoIumsQA/QCb1WMvufaLA+NLeT7N3TIb4RrOviXKuK15Qy6k1lJ3/R0dy4m1IhJcceLAwguA4fGcirTketkNmwbOzvyvnU0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474741; c=relaxed/simple;
	bh=45hEi5ZyC/YoKiDb+icHRi+a/QiNyAyjnafkwSp/EcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dp7LYzWm2s4oua0uXyS9v9zudILYk0PtERb40+7AEzFTka8A8navml1yVGBBfCCw5tX0qEcZNLN9Hs0d+/dQ6imXDlvgdUfOdK7SIVWBX4WajGv5Wzj7AxMock7Ii+4VLIzhBXQhHX8tkt5gXoFF9hg9ooLP1TZZooPt5HQyks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jaOtRUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jaOtRUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7D8C2BBFC;
	Tue, 30 Apr 2024 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474741;
	bh=45hEi5ZyC/YoKiDb+icHRi+a/QiNyAyjnafkwSp/EcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jaOtRUddLcR5+0AYYoVnXpDTMNbqesfwZfGCuLAyZL5VF+fELBVq/RRLvgbxVuLN
	 F19v69rT8GykJljWDSg/xAE0hOtVXpOtttUUH2KL2w5g4Ts6wZv7/BaBmErdI8lZPG
	 qjSCrV72hcEa1oh0cY4t3SiFkHuWPSYuxZ7JPYHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/138] iommu/vt-d: Allocate local memory for page request queue
Date: Tue, 30 Apr 2024 12:38:26 +0200
Message-ID: <20240430103050.051305218@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit a34f3e20ddff02c4f12df2c0635367394e64c63d ]

The page request queue is per IOMMU, its allocation should be made
NUMA-aware for performance reasons.

Fixes: a222a7f0bb6c ("iommu/vt-d: Implement page request handling")
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20240403214007.985600-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index aabf56272b86d..02e3183a4c67e 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -33,7 +33,7 @@ int intel_svm_enable_prq(struct intel_iommu *iommu)
 	struct page *pages;
 	int irq, ret;
 
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_KERNEL | __GFP_ZERO, PRQ_ORDER);
 	if (!pages) {
 		pr_warn("IOMMU: %s: Failed to allocate page request queue\n",
 			iommu->name);
-- 
2.43.0



