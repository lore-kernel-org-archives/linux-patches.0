Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207231D0488;
	Wed,  2 Oct 2024 13:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876270; cv=none; b=q/Ynx4ZKKpA9Km2axQRzbW5MlacN+IeuJNjvlF4RdwaBEYbTVjVaBAknUvxEfRQbcnW/4BJrsBQ5dRxqPS/cG5STKBlW6E5ZiRixscrP7bCW7eWUkbCLGXVFs+RIqMNFOH53/S/odYoBMcPCHTF/Fwfur8Q/NxvPLqJbhB3Dq1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876270; c=relaxed/simple;
	bh=UgJT96ktfJgaTO8p/DA7v5khD3bOnuilpZMi2u0v+tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcVpoFuq4AjgZA8AYrKAzJRRpi/Yd74KGEDPvY1sSFdxTrnYA1F0A+jPWIjQz+jlhAlMX/0Du/ku3IKYJnXcZapSA4nwgq97zXZrDnYkvd+HeV2OXWlyGvLsZ90l4DBwA4d824nHs4Ofau7s1hKHpeIuBuhLR9M1sj4nAGQOlXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+cfHWnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+cfHWnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB78C4CECD;
	Wed,  2 Oct 2024 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876269;
	bh=UgJT96ktfJgaTO8p/DA7v5khD3bOnuilpZMi2u0v+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+cfHWnbUA6hObgYH9eEh9IzogttnLBqYr0iqdLBuat9GXuTeN3HhBExLVR3xYAYD
	 f9pOdzujIXYygA9oZzDqRQEhp5wXR5F1rri4rAXzZPqtqz6GBCchuo4WLqRm0R3xJi
	 tV1BBNwxhcSJKS7E5pQjH/Kkhi3OeBhEjNc49hwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 385/695] iommufd/selftest: Fix buffer read overrrun in the dirty test
Date: Wed,  2 Oct 2024 14:56:23 +0200
Message-ID: <20241002125837.825351414@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 79ea4a496ab5c970a3a793d863ed8893b1af107c ]

test_bit() is used to read the memory storing the bitmap, however
test_bit() always uses a unsigned long 8 byte access.

If the bitmap is not an aligned size of 64 bits this will now trigger a
KASAN warning reading past the end of the buffer.

Properly round the buffer allocation to an unsigned long size. Continue to
copy_from_user() using a byte granularity.

Fixes: 9560393b830b ("iommufd/selftest: Fix iommufd_test_dirty() to handle <u8 bitmaps")
Link: https://patch.msgid.link/r/0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 222cfc11ebfd0..4a279b8f02cb7 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -1342,7 +1342,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 			      unsigned long page_size, void __user *uptr,
 			      u32 flags)
 {
-	unsigned long bitmap_size, i, max;
+	unsigned long i, max;
 	struct iommu_test_cmd *cmd = ucmd->cmd;
 	struct iommufd_hw_pagetable *hwpt;
 	struct mock_iommu_domain *mock;
@@ -1363,15 +1363,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	}
 
 	max = length / page_size;
-	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
-
-	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
+	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
+		       GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
 		rc = -ENOMEM;
 		goto out_put;
 	}
 
-	if (copy_from_user(tmp, uptr, bitmap_size)) {
+	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
 		rc = -EFAULT;
 		goto out_free;
 	}
-- 
2.43.0



