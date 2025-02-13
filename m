Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9122F14A605;
	Thu, 13 Feb 2025 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459710; cv=none; b=b3x9cNZUWlUd7pBEiAuXK0PE+FiiBUhFETRtsxipGhYJ5hxswedq87mL0k9UDXw/g1dTKVcAaiuzgml7N2lRMUsRp6tf7S8gGuN6bRZAz8qaHrNYkea+WERZZxdITAErwGYuAjwfQKvpbbnCLGYHhEnXhkdd4epVvmh53fPJe6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459710; c=relaxed/simple;
	bh=MtpgyGppXRL3aC0RYWxIc14A3cTfy/KIYyM7LntrWTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjQJte2VKdGpue5nTFULLwbweEm9GtpQD8JPFGaZtNdTyBxSVmnk+OMkRbXznTGM/S9DKzKK02GsQnrB415TRclH0JCfxdGFln4U09ClaOY7Bz9rt8Nw/Zhm1VXF9JPhoDLKQ6nu9mImYotBjGVc5AoZrVLESqCqrXe4tUUHkoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKqGOMJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKqGOMJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023BCC4CEE4;
	Thu, 13 Feb 2025 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459710;
	bh=MtpgyGppXRL3aC0RYWxIc14A3cTfy/KIYyM7LntrWTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKqGOMJMtG0tdg31rt1wNSbQcvF7edIKEWJqDc7ikC6+Cdw5DLgf7NPkfxdZ1W8+v
	 ycCNI+BEj6YmkiO5THVy/Gwiavfq2bUpeyC7sKD8JPR1KGdeMucDljnT+mywsaixIu
	 rHvhCdIRDrPvm8KJnF0lnB3AZi5UdhBaT79pKuT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 6.13 340/443] iommufd: Fix struct iommu_hwpt_pgfault init and padding
Date: Thu, 13 Feb 2025 15:28:25 +0100
Message-ID: <20250213142453.743345320@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit e721f619e3ec9bae08bf419c3944cf1e6966c821 upstream.

The iommu_hwpt_pgfault is used to report IO page fault data to userspace,
but iommufd_fault_fops_read was never zeroing its padding. This leaks the
content of the kernel stack memory to userspace.

Also, the iommufd uAPI requires explicit padding and use of __aligned_u64
to ensure ABI compatibility's with 32 bit.

pahole result, before:
struct iommu_hwpt_pgfault {
        __u32     flags;                /*     0     4 */
        __u32     dev_id;               /*     4     4 */
        __u32     pasid;                /*     8     4 */
        __u32     grpid;                /*    12     4 */
        __u32     perm;                 /*    16     4 */

        /* XXX 4 bytes hole, try to pack */

        __u64     addr;                 /*    24     8 */
        __u32     length;               /*    32     4 */
        __u32     cookie;               /*    36     4 */

        /* size: 40, cachelines: 1, members: 8 */
        /* sum members: 36, holes: 1, sum holes: 4 */
        /* last cacheline: 40 bytes */
};

pahole result, after:
struct iommu_hwpt_pgfault {
        __u32      flags;                /*     0     4 */
        __u32      dev_id;               /*     4     4 */
        __u32      pasid;                /*     8     4 */
        __u32      grpid;                /*    12     4 */
        __u32      perm;                 /*    16     4 */
        __u32      __reserved;           /*    20     4 */
        __u64      addr __attribute__((__aligned__(8))); /*    24     8 */
        __u32      length;               /*    32     4 */
        __u32      cookie;               /*    36     4 */

        /* size: 40, cachelines: 1, members: 9 */
        /* forced alignments: 1 */
        /* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));

Fixes: c714f15860fc ("iommufd: Add fault and response message definitions")
Link: https://patch.msgid.link/r/20250120195051.2450-1-nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/fault.c |    2 +-
 include/uapi/linux/iommufd.h  |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -247,7 +247,7 @@ static ssize_t iommufd_fault_fops_read(s
 {
 	size_t fault_size = sizeof(struct iommu_hwpt_pgfault);
 	struct iommufd_fault *fault = filep->private_data;
-	struct iommu_hwpt_pgfault data;
+	struct iommu_hwpt_pgfault data = {};
 	struct iommufd_device *idev;
 	struct iopf_group *group;
 	struct iopf_fault *iopf;
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -868,6 +868,7 @@ enum iommu_hwpt_pgfault_perm {
  * @pasid: Process Address Space ID
  * @grpid: Page Request Group Index
  * @perm: Combination of enum iommu_hwpt_pgfault_perm
+ * @__reserved: Must be 0.
  * @addr: Fault address
  * @length: a hint of how much data the requestor is expecting to fetch. For
  *          example, if the PRI initiator knows it is going to do a 10MB
@@ -883,7 +884,8 @@ struct iommu_hwpt_pgfault {
 	__u32 pasid;
 	__u32 grpid;
 	__u32 perm;
-	__u64 addr;
+	__u32 __reserved;
+	__aligned_u64 addr;
 	__u32 length;
 	__u32 cookie;
 };


