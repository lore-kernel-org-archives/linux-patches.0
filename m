Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82EE23BD1A;
	Fri, 21 Nov 2025 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733186; cv=none; b=b1i0st2LM8XKsK53nXro2m6bMeTgG0ZyRCQ0ypnfkcjQ9ReA9gBqQtz/HBZaDQLI7D5RNwlO0dnfZYXYSA0UxDUxfcAsCMVsuTuV0HJTQExmJRQLe2BEGbjMZt52SsfyO2cMV5gRgTHLKX3pxPsplEBqeR9EXStCsYYtkjHSkJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733186; c=relaxed/simple;
	bh=loSl2tPm8DpNcnXkq87Bnq2p0Pt83BcZIj62PLvAO90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCTaDjNfL05BbblqyiU2PzFlDh/5LoHeEe7E6PN5nIdaralM3CatICDjxMgCgDaeycByq2XHs1o7Ogz+7IDmNgkgggc1KBw1MpLeWiTeaazQoakOAGPaiD71K/1+B5HIr86OS1wxMk02cF4WVPsW3Q3ibBzUJZleVKZo0C9sAP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSWenWR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSWenWR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33120C4CEF1;
	Fri, 21 Nov 2025 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733186;
	bh=loSl2tPm8DpNcnXkq87Bnq2p0Pt83BcZIj62PLvAO90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSWenWR3Njc7zAIYKDnoGqX/a8Yb0+JYwaQJc6DGQiHynukkXm5IzLbQdU8bM2aU3
	 hxp9nlrOE1VBoTomdbudDNcPTBZJw/x74eASvKNfzALKqCM/6WitUCgRAqVBLyBDtE
	 ckphzhsI40NXEcI2XQ6b6wxWOCyVgG9EbFkAgNyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 380/529] iommufd: Make vfio_compats unmap succeed if the range is already empty
Date: Fri, 21 Nov 2025 14:11:19 +0100
Message-ID: <20251121130244.545148533@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit afb47765f9235181fddc61c8633b5a8cfae29fd2 ]

iommufd returns ENOENT when attempting to unmap a range that is already
empty, while vfio type1 returns success. Fix vfio_compat to match.

Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://patch.msgid.link/r/0-v1-76be45eff0be+5d-iommufd_unmap_compat_jgg@nvidia.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Alex Mastro <amastro@fb.com>
Reported-by: Alex Mastro <amastro@fb.com>
Closes: https://lore.kernel.org/r/aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c    | 12 +++---------
 drivers/iommu/iommufd/ioas.c            |  4 ++++
 tools/testing/selftests/iommu/iommufd.c |  2 ++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index f058405c5fbb6..6bd37343061e0 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -488,7 +488,8 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 	struct iopt_area *area;
 	unsigned long unmapped_bytes = 0;
 	unsigned int tries = 0;
-	int rc = -ENOENT;
+	/* If there are no mapped entries then success */
+	int rc = 0;
 
 	/*
 	 * The domains_rwsem must be held in read mode any time any area->pages
@@ -552,8 +553,6 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 
 		down_write(&iopt->iova_rwsem);
 	}
-	if (unmapped_bytes)
-		rc = 0;
 
 out_unlock_iova:
 	up_write(&iopt->iova_rwsem);
@@ -590,13 +589,8 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped)
 {
-	int rc;
-
-	rc = iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
 	/* If the IOVAs are empty then unmap all succeeds */
-	if (rc == -ENOENT)
-		return 0;
-	return rc;
+	return iopt_unmap_iova_range(iopt, 0, ULONG_MAX, unmapped);
 }
 
 /* The caller must always free all the nodes in the allowed_iova rb_root. */
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 0407e2b758ef4..18bbbeef5cccd 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -317,6 +317,10 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 				     &unmapped);
 		if (rc)
 			goto out_put;
+		if (!unmapped) {
+			rc = -ENOENT;
+			goto out_put;
+		}
 	}
 
 	cmd->length = unmapped;
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 890a81f4ff618..67fcc99fbd6d3 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1728,6 +1728,8 @@ TEST_F(vfio_compat_mock_domain, map)
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
 	ASSERT_EQ(BUFFER_SIZE, unmap_cmd.size);
+	/* Unmap of empty is success */
+	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_UNMAP_DMA, &unmap_cmd));
 
 	/* UNMAP_FLAG_ALL requres 0 iova/size */
 	ASSERT_EQ(0, ioctl(self->fd, VFIO_IOMMU_MAP_DMA, &map_cmd));
-- 
2.51.0



