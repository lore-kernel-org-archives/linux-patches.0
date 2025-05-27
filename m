Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5872CCC0;
	Tue, 27 May 2025 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365122; cv=none; b=bCFfaYe3NyNqBI+zM0pwqzLenW+ljxZlxP4lu5i/6BYzfW7jGY/Swan3qFk8lShiVv+TnEh2QmgUrhRhmLUAd4tLSvkYBYc/RAf4QcDmQ6QtIRAOxRTHOxRjuhfBlsnuPfYvJ3gclt8eMwLFAZbK8b+p7zwSmVuBKVpYvIuX6QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365122; c=relaxed/simple;
	bh=GcSKhByWo4w25bY9IdxpioHnvXv1gLFETR6Wrc5QMd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO//8Fl3X7U69zjeoHRNVrhbZLqrbJmEbgqAyNnA9jk2jbL2054v9Yejgy31io0VBuL1Qi62Acof5oW2EEOw3e9QA60Y0iQlOOYQr+O7w3xWWODrfHNwUJEZPC6pscZ0ot5F3nLipK1dbWs1yVYvPinPZa5s+QO9mLt4S1cOfJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMjgrcii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMjgrcii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFF1C4CEED;
	Tue, 27 May 2025 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365121;
	bh=GcSKhByWo4w25bY9IdxpioHnvXv1gLFETR6Wrc5QMd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMjgrciipZdEHN6oD4j8vDpjcQbmFGudKNa9qz93cUXKxJSX6wvr14QFvvMFJuetn
	 FkeJY2NnH1gi5I0vnNqhCv8FKmizphuziF3hB/n4nnzLw2fcrh05OwqinEjwG1q+cq
	 ywqtbJKu9oKSbCGnox/oEoLtBYb4yE3NNLvbUOM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/626] iommufd: Disallow allocating nested parent domain with fault ID
Date: Tue, 27 May 2025 18:22:19 +0200
Message-ID: <20250527162455.013718488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 1062d81086156e42878d701b816d2f368b53a77c ]

Allocating a domain with a fault ID indicates that the domain is faultable.
However, there is a gap for the nested parent domain to support PRI. Some
hardware lacks the capability to distinguish whether PRI occurs at stage 1
or stage 2. This limitation may require software-based page table walking
to resolve. Since no in-tree IOMMU driver currently supports this
functionality, it is disallowed. For more details, refer to the related
discussion at [1].

[1] https://lore.kernel.org/linux-iommu/bd1655c6-8b2f-4cfa-adb1-badc00d01811@intel.com/

Link: https://patch.msgid.link/r/20250226104012.82079-1-yi.l.liu@intel.com
Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 3 +++
 tools/testing/selftests/iommu/iommufd.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index d06bf6e6c19fd..2454627a8b61b 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -122,6 +122,9 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 	if ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
 	    !device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY_TRACKING))
 		return ERR_PTR(-EOPNOTSUPP);
+	if ((flags & IOMMU_HWPT_FAULT_ID_VALID) &&
+	    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
+		return ERR_PTR(-EOPNOTSUPP);
 
 	hwpt_paging = __iommufd_object_alloc(
 		ictx, hwpt_paging, IOMMUFD_OBJ_HWPT_PAGING, common.obj);
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 4927b9add5add..06f252733660a 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -289,6 +289,10 @@ TEST_F(iommufd_ioas, alloc_hwpt_nested)
 				    &test_hwpt_id);
 		test_err_hwpt_alloc(EINVAL, self->device_id, self->device_id, 0,
 				    &test_hwpt_id);
+		test_err_hwpt_alloc(EOPNOTSUPP, self->device_id, self->ioas_id,
+				    IOMMU_HWPT_ALLOC_NEST_PARENT |
+						IOMMU_HWPT_FAULT_ID_VALID,
+				    &test_hwpt_id);
 
 		test_cmd_hwpt_alloc(self->device_id, self->ioas_id,
 				    IOMMU_HWPT_ALLOC_NEST_PARENT,
-- 
2.39.5



