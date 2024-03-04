Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101B2C689;
	Mon,  4 Mar 2024 21:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587845; cv=none; b=MQnu7x1ebgtuuo8HtFguG2h+IZ6hrv2W6vztmZPB4cejmeQCQ3oIu8Ak+IMY9Qx3fXKJSoRCK0hglfPGcjPha9EZjZiH33Up2eqxXysrKvA1YcZZdF5qK7Lge/IW/KGtBVVo3IiyiEDicPNnESXPdub4LUpszlKXA2lEE6e+4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587845; c=relaxed/simple;
	bh=9FD+0731GuDdT2jTuz/IpoTvooUPvDI8DvjQeviEhUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeLM6KjSNUZp+xuei+KjOzb+S1o7Ju1aH2wqmJNIrWy+b17RtU+Eul/j/JGRjL7U24+oA/gstG3gOSLQJaQVn4kFZKmjsd0e5VwvbuU8jx5k0C8c/243iLMMi7akkCAO0VnA8mwEz5rUoZIypFJAGm0rFL/bMB5rJOTfV2DKy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+drpqgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+drpqgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6C1C433F1;
	Mon,  4 Mar 2024 21:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587844;
	bh=9FD+0731GuDdT2jTuz/IpoTvooUPvDI8DvjQeviEhUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+drpqgkqSvK4l6zV6/FKATU2xwz+dz8dpRkwTqutfraHJpqWDNy6uPjgMrQjxAxY
	 fofM/NeSn8tddMYbN9r5qgSXpSi/Z7ycoT0GRCEhVBXZrqrc9SzZE+Tr+GETfe0Xcg
	 Y9CPEQmCoKqyjzVMXzumN5S83khrlpL/NLmhUVis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 6.7 111/162] iommufd: Fix iopt_access_list_id overwrite bug
Date: Mon,  4 Mar 2024 21:22:56 +0000
Message-ID: <20240304211555.331925520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit aeb004c0cd6958e910123a1607634401009c9539 upstream.

Syzkaller reported the following WARN_ON:
  WARNING: CPU: 1 PID: 4738 at drivers/iommu/iommufd/io_pagetable.c:1360

  Call Trace:
   iommufd_access_change_ioas+0x2fe/0x4e0
   iommufd_access_destroy_object+0x50/0xb0
   iommufd_object_remove+0x2a3/0x490
   iommufd_object_destroy_user
   iommufd_access_destroy+0x71/0xb0
   iommufd_test_staccess_release+0x89/0xd0
   __fput+0x272/0xb50
   __fput_sync+0x4b/0x60
   __do_sys_close
   __se_sys_close
   __x64_sys_close+0x8b/0x110
   do_syscall_x64

The mismatch between the access pointer in the list and the passed-in
pointer is resulting from an overwrite of access->iopt_access_list_id, in
iopt_add_access(). Called from iommufd_access_change_ioas() when
xa_alloc() succeeds but iopt_calculate_iova_alignment() fails.

Add a new_id in iopt_add_access() and only update iopt_access_list_id when
returning successfully.

Cc: stable@vger.kernel.org
Fixes: 9227da7816dd ("iommufd: Add iommufd_access_change_ioas(_id) helpers")
Link: https://lore.kernel.org/r/2dda7acb25b8562ec5f1310de828ef5da9ef509c.1708636627.git.nicolinc@nvidia.com
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/io_pagetable.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -1330,20 +1330,23 @@ out_unlock:
 
 int iopt_add_access(struct io_pagetable *iopt, struct iommufd_access *access)
 {
+	u32 new_id;
 	int rc;
 
 	down_write(&iopt->domains_rwsem);
 	down_write(&iopt->iova_rwsem);
-	rc = xa_alloc(&iopt->access_list, &access->iopt_access_list_id, access,
-		      xa_limit_16b, GFP_KERNEL_ACCOUNT);
+	rc = xa_alloc(&iopt->access_list, &new_id, access, xa_limit_16b,
+		      GFP_KERNEL_ACCOUNT);
+
 	if (rc)
 		goto out_unlock;
 
 	rc = iopt_calculate_iova_alignment(iopt);
 	if (rc) {
-		xa_erase(&iopt->access_list, access->iopt_access_list_id);
+		xa_erase(&iopt->access_list, new_id);
 		goto out_unlock;
 	}
+	access->iopt_access_list_id = new_id;
 
 out_unlock:
 	up_write(&iopt->iova_rwsem);


