Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E7A33066F;
	Mon, 29 Dec 2025 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025087; cv=none; b=ZpDo4XXa0LODg4mFsnn6G60Q8pzBIlI3jjKhOiWbUFxt1Yw1LErRWVJj5DGGnL1iAYHQcCSJ5ZhAGWYRqz2FkNhrWZv5kyZtvAsEhfH0rI0Z9MLvUNaCHIU9lKkiOKfPsnbzMRDiXYH4Nw4c1BI1qGrDCR7w6rDyRiDbnSAFNso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025087; c=relaxed/simple;
	bh=e7W4AE9nPanKLe0tHL1KcHJ8cQLv29SKA5u8ddqlmEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFvOYnay2lQ2weYNZjyec64c0WSlCHHWRyOymvieUXEzucnY4GUY7I0KfZfWppEXSp1jfX93AXMNEU3+kYkYVQWs3y/yNzKHqWOuhL65BwV93uzfnaYKFnDNH8n5Y4q056v3rseGBnkYkOynU/zuVxG+RNkNSNdRNGXN7GkZdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tltuH+2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tltuH+2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988DEC116C6;
	Mon, 29 Dec 2025 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025087;
	bh=e7W4AE9nPanKLe0tHL1KcHJ8cQLv29SKA5u8ddqlmEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tltuH+2iauQK/+taZ8NN0uS4GH2amRNUK8/gj4UFG8LLZ4s+rp0Dua/isgbaAEYOL
	 arMkm5H6U+Fk7axY2hdWQtLjMPsMKEoxhub4GAVkBWDem9Lk4Mv56JZLG77BYjh9Bm
	 3nF2nFEJ89+UxPbICwXUe2zvgT1e2dPXL1DNfSEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	kernel test robot <lkp@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/430] iommufd/selftest: Make it clearer to gcc that the access is not out of bounds
Date: Mon, 29 Dec 2025 17:08:10 +0100
Message-ID: <20251229160727.600439802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5b244b077c0b0e76573fbb9542cf038e42368901 ]

GCC gets a bit confused and reports:

   In function '_test_cmd_get_hw_info',
       inlined from 'iommufd_ioas_get_hw_info' at iommufd.c:779:3,
       inlined from 'wrapper_iommufd_ioas_get_hw_info' at iommufd.c:752:1:
>> iommufd_utils.h:804:37: warning: array subscript 'struct iommu_test_hw_info[0]' is partly outside array bounds of 'struct iommu_test_hw_info_buffer_smaller[1]' [-Warray-bounds=]
     804 |                         assert(!info->flags);
         |                                 ~~~~^~~~~~~
   iommufd.c: In function 'wrapper_iommufd_ioas_get_hw_info':
   iommufd.c:761:11: note: object 'buffer_smaller' of size 4
     761 |         } buffer_smaller;
         |           ^~~~~~~~~~~~~~

While it is true that "struct iommu_test_hw_info[0]" is partly out of
bounds of the input pointer, it is not true that info->flags is out of
bounds. Unclear why it warns on this.

Reuse an existing properly sized stack buffer and pass a truncated length
instead to test the same thing.

Fixes: af4fde93c319 ("iommufd/selftest: Add coverage for IOMMU_GET_HW_INFO ioctl")
Link: https://patch.msgid.link/r/0-v1-63a2cffb09da+4486-iommufd_gcc_bounds_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512032344.kaAcKFIM-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index bb4d33dde3c89..1f52140d9d9ee 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -758,9 +758,6 @@ TEST_F(iommufd_ioas, get_hw_info)
 		struct iommu_test_hw_info info;
 		uint64_t trailing_bytes;
 	} buffer_larger;
-	struct iommu_test_hw_info_buffer_smaller {
-		__u32 flags;
-	} buffer_smaller;
 
 	if (self->device_id) {
 		uint8_t max_pasid = 0;
@@ -792,8 +789,9 @@ TEST_F(iommufd_ioas, get_hw_info)
 		 * the fields within the size range still gets updated.
 		 */
 		test_cmd_get_hw_info(self->device_id,
-				     IOMMU_HW_INFO_TYPE_DEFAULT,
-				     &buffer_smaller, sizeof(buffer_smaller));
+				     IOMMU_HW_INFO_TYPE_DEFAULT, &buffer_exact,
+				     offsetofend(struct iommu_test_hw_info,
+						 flags));
 		test_cmd_get_hw_info_pasid(self->device_id, &max_pasid);
 		ASSERT_EQ(0, max_pasid);
 		if (variant->pasid_capable) {
-- 
2.51.0



