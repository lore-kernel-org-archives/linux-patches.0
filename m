Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC7144C97;
	Sun,  1 Sep 2024 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207998; cv=none; b=Wkhv3e6/UvXaftJc820eYCT9Xfl3zQ+OQ3RFh9Kh0bHgxTbhMwj7yAVub2o9M9pXm8FrxmarOaM2rGxCOxL3A6vievxAJKvRjF4wPOSXvsH4kEpXKn2o4Ldg+44ukDwBDbA3S5eILd6B75woeJj4KnLsVf5/8Hb4nd/V1zyPeB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207998; c=relaxed/simple;
	bh=YCkIsjJ/o0HWhCxFvQEfLAMKAj7+KTJodoKvsLj9XeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWntUgcaKYx533BivQbqAmK5d7lNWuQJ4GTv1kteQY97vZpV05mBgOTMv/6s47U2xq2C93139dk5e96VkEkoHmDwyZvXMcxaxLkpAKVzHE6Ufp0kjXxyQkSNPiRtNA2v2U9VgUPUmNMHVBQ2IV3jIZzjhlGY35BIDylVbTlRjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTtUjB8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTtUjB8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9094C4CEC3;
	Sun,  1 Sep 2024 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207998;
	bh=YCkIsjJ/o0HWhCxFvQEfLAMKAj7+KTJodoKvsLj9XeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTtUjB8Mv+qOHMhR/gqQ1Z7PfgAP+dW8jC7qYmJWi/Xfg+tKqwH1dGU/tmINjygZQ
	 vccA/vioSO9HFCbasVAXyuhQ9L6+2evOwZjQCnI79TH33Ry3P+NVNbO0XEGCXOxQq+
	 2NNGaD9VbYhAQblZ5Tx6h7YCRPmR3nPdP1T6JixM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 43/93] iommufd: Do not allow creating areas without READ or WRITE
Date: Sun,  1 Sep 2024 18:16:30 +0200
Message-ID: <20240901160808.984117479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 996dc53ac289b81957aa70d62ccadc6986d26a87 upstream.

This results in passing 0 or just IOMMU_CACHE to iommu_map(). Most of
the page table formats don't like this:

  amdv1 - -EINVAL
  armv7s - returns 0, doesn't update mapped
  arm-lpae - returns 0 doesn't update mapped
  dart - returns 0, doesn't update mapped
  VT-D - returns -EINVAL

Unfortunately the three formats that return 0 cause serious problems:

 - Returning ret = but not uppdating mapped from domain->map_pages()
   causes an infinite loop in __iommu_map()

 - Not writing ioptes means that VFIO/iommufd have no way to recover them
   and we will have memory leaks and worse during unmap

Since almost nothing can support this, and it is a useless thing to do,
block it early in iommufd.

Cc: stable@kernel.org
Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/1-v1-1211e1294c27+4b1-iommu_no_prot_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/ioas.c            |    8 ++++++++
 tools/testing/selftests/iommu/iommufd.c |    6 +++---
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -213,6 +213,10 @@ int iommufd_ioas_map(struct iommufd_ucmd
 	if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX)
 		return -EOVERFLOW;
 
+	if (!(cmd->flags &
+	      (IOMMU_IOAS_MAP_WRITEABLE | IOMMU_IOAS_MAP_READABLE)))
+		return -EINVAL;
+
 	ioas = iommufd_get_ioas(ucmd->ictx, cmd->ioas_id);
 	if (IS_ERR(ioas))
 		return PTR_ERR(ioas);
@@ -253,6 +257,10 @@ int iommufd_ioas_copy(struct iommufd_ucm
 	    cmd->dst_iova >= ULONG_MAX)
 		return -EOVERFLOW;
 
+	if (!(cmd->flags &
+	      (IOMMU_IOAS_MAP_WRITEABLE | IOMMU_IOAS_MAP_READABLE)))
+		return -EINVAL;
+
 	src_ioas = iommufd_get_ioas(ucmd->ictx, cmd->src_ioas_id);
 	if (IS_ERR(src_ioas))
 		return PTR_ERR(src_ioas);
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -531,7 +531,7 @@ TEST_F(iommufd_ioas, copy_area)
 {
 	struct iommu_ioas_copy copy_cmd = {
 		.size = sizeof(copy_cmd),
-		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE,
 		.dst_ioas_id = self->ioas_id,
 		.src_ioas_id = self->ioas_id,
 		.length = PAGE_SIZE,
@@ -1024,7 +1024,7 @@ TEST_F(iommufd_ioas, copy_sweep)
 {
 	struct iommu_ioas_copy copy_cmd = {
 		.size = sizeof(copy_cmd),
-		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE,
 		.src_ioas_id = self->ioas_id,
 		.dst_iova = MOCK_APERTURE_START,
 		.length = MOCK_PAGE_SIZE,
@@ -1314,7 +1314,7 @@ TEST_F(iommufd_mock_domain, user_copy)
 	};
 	struct iommu_ioas_copy copy_cmd = {
 		.size = sizeof(copy_cmd),
-		.flags = IOMMU_IOAS_MAP_FIXED_IOVA,
+		.flags = IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE,
 		.dst_ioas_id = self->ioas_id,
 		.dst_iova = MOCK_APERTURE_START,
 		.length = BUFFER_SIZE,


