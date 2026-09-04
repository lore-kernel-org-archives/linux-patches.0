Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28333B95FA;
	Fri,  4 Sep 2026 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499929; cv=none; b=h6eHP1cAVwV0gtC5uzGs1ky+reIrd83Fq7IvQYmBdCTUE4v08REsxOPBl7HgRqUNUgzWEWw8ePe86LWKs/oltncQGQE8GELMctlHPm0i9eHtaAUresYsUTl+6SaTodrNZ58ycY0tSDnU5iVfekezYk0hBremRhigh0ISqLyx1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499929; c=relaxed/simple;
	bh=09bFYUyXFOzlC+Y9CgO42bUt8X+9x8+HlyGKJFOLp98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H76FDLOnr1mqEOh2lSLsXpofOXQAam4G7H7+gibjA7NQHodaEZpL2joNT9+7Npjd2iYC1TQmsUPViUrDlS3cBI8o6Ro5mCOrvgUJKShe7hYO004AJohyzCcXU/Nb4mpG0Brxd3ssVxwbcQnJgnAG9pD1G/IBGBJrVcrimN/snDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l3mRsz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l3mRsz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A76B1F00A3D;
	Fri,  4 Sep 2026 05:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499927;
	bh=RxYy9VFQl/+3+R8TVpUrhjbfSxVu7w8+HNCjm1rJCrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1l3mRsz4/t7Hq+hqygBpoMSgkCPsbFsKFMKMotVA7Bvi4e2txPNFjb2qFq2fKWp1T
	 kiw2XSYlNKItkYAFt0kiLfwa2/R6eeEM0p9MvyCuXWy9EeA0kF+mhDsWGYOoTA44DB
	 9M7wkjClE/OAG8H/f72obpsHufUZzTwE6mI5YSOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 546/713] iommupt: Return zero for invalid iova_to_phys() ranges
Date: Fri,  4 Sep 2026 06:58:34 +0200
Message-ID: <20260904045816.055936486@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 41cdc2a3d41b505c1dff9e6c1ab4c76d4cc1f995 upstream.

DOMAIN_NS(iova_to_phys) returns a phys_addr_t and follows the IOMMU
iova_to_phys() convention of returning 0 when there is no valid
translation.

make_range() returns a negative errno if the input IOVA cannot be
represented by this page table format. Returning that errno directly
casts it to phys_addr_t. Callers treat zero as no translation and use
non-zero values as physical addresses, so this can make them consume a
bogus physical address instead of seeing a failed translation.

Match the page-table walk failure path and return 0 for range validation
failures too.

Fixes: 9d4c274cd7d5 ("iommupt: Add iova_to_phys op")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/generic_pt/iommu_pt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -224,7 +224,7 @@ phys_addr_t DOMAIN_NS(iova_to_phys)(stru
 
 	ret = make_range(common_from_iommu(iommu_table), &range, iova, 1);
 	if (ret)
-		return ret;
+		return 0;
 
 	ret = pt_walk_range(&range, __iova_to_phys, &res);
 	/* PHYS_ADDR_MAX would be a better error code */


