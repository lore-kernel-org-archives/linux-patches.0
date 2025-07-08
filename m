Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444C264F9C;
	Tue,  8 Jul 2025 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993293; cv=none; b=Z9+1osgwijCdyhQYIPwvC7QfONUQ2aE74BL75PkW9v+xw1z2HwpxeYlbNwMfl21nGA+DEb8rGTFklO4ISeDzxcIkSAZ83kGOQzvP4vwi2uoZbjiKYCzl25OGLbNQalxlQOJ3dLJgUm64RwbQ2b8E6JURT/0mhLkh47FL3BsoWyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993293; c=relaxed/simple;
	bh=owk8lXGYDE6h8NM3XBUIQsFjMi4bIjjUFDQP6oVBbSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS25JpKYupGaS1R//bcBgGFGU0qJzIDmrkFvQqI6cvjJWOmyjgcGRHXmTxK7Rbd3CTf5514vSjKknExxDHOMicdKFGYi0eP2Pn5aPqP188bVCLi7XxpG1b3hG09jOFLvEe9iItTliqYQgvPMqGc4iq3WzUPvP2f8eU0zdHFPJyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbRGhxGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbRGhxGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3B9C4CEED;
	Tue,  8 Jul 2025 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993292;
	bh=owk8lXGYDE6h8NM3XBUIQsFjMi4bIjjUFDQP6oVBbSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbRGhxGF3EcSQSKg8B/eeewfrbBSY9Hdx+z5RsaE1PsBMbJa6KnHkV/qOtp+tHJY/
	 9W0uW4z0F3XBXqL6mYyX4iVl/cgtyKhwtNLWXeQVOsfCNU0ETouvVdILi7mdby9Mzn
	 hpO/tUjk+2bcvKXoD3cefJ72scOhVFU59Clwlszw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH 6.15 024/178] iommufd/selftest: Fix iommufd_dirty_tracking with large hugepage sizes
Date: Tue,  8 Jul 2025 18:21:01 +0200
Message-ID: <20250708162237.179375328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 818625570558cd91082c9bafd6f2b59b73241a69 upstream.

The hugepage test cases of iommufd_dirty_tracking have the 64MB and 128MB
coverages. Both of them are smaller than the default hugepage size 512MB,
when CONFIG_PAGE_SIZE_64KB=y. However, these test cases have a variant of
using huge pages, which would mmap(MAP_HUGETLB) using these smaller sizes
than the system hugepag size. This results in the kernel aligning up the
smaller size to 512MB. If a memory was located between the upper 64/128MB
size boundary and the hugepage 512MB boundary, it would get wiped out:
https://lore.kernel.org/all/aEoUhPYIAizTLADq@nvidia.com/

Given that this aligning up behavior is well documented, we have no choice
but to allocate a hugepage aligned size to avoid this unintended wipe out.
Instead of relying on the kernel's internal force alignment, pass the same
size to posix_memalign() and map().

Also, fix the FIXTURE_TEARDOWN() misusing munmap() to free the memory from
posix_memalign(), as munmap() doesn't destroy the allocator meta data. So,
call free() instead.

Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Link: https://patch.msgid.link/r/1ea8609ae6d523fdd4d8efb179ddee79c8582cb6.1750787928.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/iommu/iommufd.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2010,6 +2010,7 @@ FIXTURE_VARIANT(iommufd_dirty_tracking)
 
 FIXTURE_SETUP(iommufd_dirty_tracking)
 {
+	size_t mmap_buffer_size;
 	unsigned long size;
 	int mmap_flags;
 	void *vrc;
@@ -2024,22 +2025,33 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 	self->fd = open("/dev/iommu", O_RDWR);
 	ASSERT_NE(-1, self->fd);
 
-	rc = posix_memalign(&self->buffer, HUGEPAGE_SIZE, variant->buffer_size);
-	if (rc || !self->buffer) {
-		SKIP(return, "Skipping buffer_size=%lu due to errno=%d",
-			   variant->buffer_size, rc);
-	}
-
 	mmap_flags = MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED;
+	mmap_buffer_size = variant->buffer_size;
 	if (variant->hugepages) {
 		/*
 		 * MAP_POPULATE will cause the kernel to fail mmap if THPs are
 		 * not available.
 		 */
 		mmap_flags |= MAP_HUGETLB | MAP_POPULATE;
+
+		/*
+		 * Allocation must be aligned to the HUGEPAGE_SIZE, because the
+		 * following mmap() will automatically align the length to be a
+		 * multiple of the underlying huge page size. Failing to do the
+		 * same at this allocation will result in a memory overwrite by
+		 * the mmap().
+		 */
+		if (mmap_buffer_size < HUGEPAGE_SIZE)
+			mmap_buffer_size = HUGEPAGE_SIZE;
+	}
+
+	rc = posix_memalign(&self->buffer, HUGEPAGE_SIZE, mmap_buffer_size);
+	if (rc || !self->buffer) {
+		SKIP(return, "Skipping buffer_size=%lu due to errno=%d",
+			   mmap_buffer_size, rc);
 	}
 	assert((uintptr_t)self->buffer % HUGEPAGE_SIZE == 0);
-	vrc = mmap(self->buffer, variant->buffer_size, PROT_READ | PROT_WRITE,
+	vrc = mmap(self->buffer, mmap_buffer_size, PROT_READ | PROT_WRITE,
 		   mmap_flags, -1, 0);
 	assert(vrc == self->buffer);
 
@@ -2068,8 +2080,8 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 
 FIXTURE_TEARDOWN(iommufd_dirty_tracking)
 {
-	munmap(self->buffer, variant->buffer_size);
-	munmap(self->bitmap, DIV_ROUND_UP(self->bitmap_size, BITS_PER_BYTE));
+	free(self->buffer);
+	free(self->bitmap);
 	teardown_iommufd(self->fd, _metadata);
 }
 


