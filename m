Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C88347BDB;
	Tue,  6 Jan 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719875; cv=none; b=NMUhD5kD94rkKbqXQ1uV01O72RzUSDypIOsHzXtRWTppADJ4GI4Fr6mqlNW1pV7xYDlE3xt/7QHj0WW3K9FS7nESIcjGygqDaORwimLlRndhls9Sjp7V9hI0E7JiCk5BzwW8qvw/KDyOcjoY3qkIB6B0p5gzbk1kHQ7GCoWfJYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719875; c=relaxed/simple;
	bh=/GPSNfdcuExJ/uFPYidE+1WOSQdGr7ezVM0B5FSe0lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW/o9AUoY3FAX2Xu1QufI7lylOgl8MvASrIBXsGof1hZajLA3Zo14UxtURsvEb48P77NtdHGvbL+jYdlgf/qH/p0RlPXHNbORHE6TuQ5ubnc1IuvrwfTcTfM1auJ/aVeBGaz7LEqJ3Vhqr6jzWU9hn8UpPX0tWsnuCp/bXSNbR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWd6e6O1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWd6e6O1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCDCC116C6;
	Tue,  6 Jan 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719875;
	bh=/GPSNfdcuExJ/uFPYidE+1WOSQdGr7ezVM0B5FSe0lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWd6e6O1dE/W3k3v54OxXIxdT+EI8NLdjOYUp81Yr0W/0JqzOzBr2ExjkHGEhw9IC
	 p4jvo6dHnZ5PTId3ROb3yzCIBv1sneTzqSTBp7LbOpqza+89Mp//sDlS4J00YLcLlk
	 GH1+8sfK6gkFVEXysN/gD5HOMVjh2nH7oT5CzD0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	kernel test robot <lkp@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/567] iommufd/selftest: Make it clearer to gcc that the access is not out of bounds
Date: Tue,  6 Jan 2026 17:57:27 +0100
Message-ID: <20260106170453.742022942@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b678b24f5a142..6f99268365338 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -606,9 +606,6 @@ TEST_F(iommufd_ioas, get_hw_info)
 		struct iommu_test_hw_info info;
 		uint64_t trailing_bytes;
 	} buffer_larger;
-	struct iommu_test_hw_info_buffer_smaller {
-		__u32 flags;
-	} buffer_smaller;
 
 	if (self->device_id) {
 		uint8_t max_pasid = 0;
@@ -640,8 +637,9 @@ TEST_F(iommufd_ioas, get_hw_info)
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



