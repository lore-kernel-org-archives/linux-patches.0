Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7262F2D;
	Tue, 27 Feb 2024 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041250; cv=none; b=iUG9I5uQthH5yMDs2Q0YoPYvxoIcLLB2JIe73Aw11t/5aVuymiVf1cRg4o4cr0OS6i4Cm3RnHCuHDDEXxfIiZ2WbofSq56mD2knKJCaS/cl36nh14DE7c4yrgvE/laoMaum6TteKBZWQjah7TWyz6fR7/Phwt01YZEQsxE3np2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041250; c=relaxed/simple;
	bh=lpT6iyfr3Kn79r/yD2UDfNU8GPs5nOPYMun5RW4xpcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwsR+OTA3qD/T7ZFRkZLoVHl1eZIyODTzyp/if0701HBKjQwxCUqE7rjbvrLaNlAx1jHGUwxuaFPytD4iY/CzafO1ZMBkzm1m2De+Ec00O/+ysaOS1hLHQU3eAvZdxd3OyYEPzQDlsvNZ8WESHPR/Z4c3++z1Qoz7AJKLkwDgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCjm+p7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCjm+p7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB1BC433F1;
	Tue, 27 Feb 2024 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041250;
	bh=lpT6iyfr3Kn79r/yD2UDfNU8GPs5nOPYMun5RW4xpcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCjm+p7mVL8WMgtn2jQW+gOkDd2ZuKrZN2sN/ve8lLcPy0Fy2lhAFsGzIAR98Hhae
	 EfNL+00RX8TV6ZBrVCe4gkpJltRnNJj2BDWFHYXe1RgyTJ8G4MUDbhvfwA21rkfg7l
	 hkwa4ZZAOoFZbFjHKdxVVX2XPCKApStjmB0rJlbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 245/334] iommufd/iova_bitmap: Switch iova_bitmap::bitmap to an u8 array
Date: Tue, 27 Feb 2024 14:21:43 +0100
Message-ID: <20240227131638.793641871@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit d18411ec305728c6371806c4fb09be07016aad0b ]

iova_bitmap_mapped_length() don't deal correctly with the small bitmaps
(< 2M bitmaps) when the starting address isn't u64 aligned, leading to
skipping a tiny part of the IOVA range. This is materialized as not
marking data dirty that should otherwise have been.

Fix that by using a u8 * in the internal state of IOVA bitmap. Most of the
data structures use the type of the bitmap to adjust its indexes, thus
changing the type of the bitmap decreases the granularity of the bitmap
indexes.

Fixes: b058ea3ab5af ("vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries")
Link: https://lore.kernel.org/r/20240202133415.23819-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index a3606b4c22292..9d42ab51a6bb3 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -100,7 +100,7 @@ struct iova_bitmap {
 	struct iova_bitmap_map mapped;
 
 	/* userspace address of the bitmap */
-	u64 __user *bitmap;
+	u8 __user *bitmap;
 
 	/* u64 index that @mapped points to */
 	unsigned long mapped_base_index;
@@ -162,7 +162,7 @@ static int iova_bitmap_get(struct iova_bitmap *bitmap)
 {
 	struct iova_bitmap_map *mapped = &bitmap->mapped;
 	unsigned long npages;
-	u64 __user *addr;
+	u8 __user *addr;
 	long ret;
 
 	/*
@@ -247,7 +247,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 
 	mapped = &bitmap->mapped;
 	mapped->pgshift = __ffs(page_size);
-	bitmap->bitmap = data;
+	bitmap->bitmap = (u8 __user *)data;
 	bitmap->mapped_total_index =
 		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
 	bitmap->iova = iova;
@@ -304,7 +304,7 @@ static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-			  bytes / sizeof(*bitmap->bitmap));
+			  DIV_ROUND_UP(bytes, sizeof(*bitmap->bitmap)));
 
 	return remaining;
 }
-- 
2.43.0



