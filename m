Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF281D3634;
	Tue,  8 Oct 2024 13:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394182; cv=none; b=fUvRKGDYaJO2oop6d+C0GQ/ysOuAsux9xUdLeJGHt2eim+xpufco9JTWpYSAjyBaEwN2LKIgssMoI1nGCE1iWzmP2Vd8APEDW2JFf5rZ0i+YQpIXonVzaOebMQfmNUbqfnhpWPtD9BeIPkED1BqGCpJA+/6fVgvw1gv2srsm1DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394182; c=relaxed/simple;
	bh=IIQQEujb4W7lF3JEkwzoxuBIBTX6tlvV97cl29/b8DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRBcDHEKwPEY3TNR1V9/dMd5v1cxSDK2yDXjz5Sy64QDHwOas2DDxpWghq2trESZhx/bV0cc4TZhnayOLzSJJhj7va7+xYYXX7WpT7PWfSqd/eHZx/0CJL2aYGLD+2p639zbDKyecHPAkJ8DTLlJ1bcOZN9WztX+sXXgR33A8Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr4ijmt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr4ijmt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0153FC4CEC7;
	Tue,  8 Oct 2024 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394182;
	bh=IIQQEujb4W7lF3JEkwzoxuBIBTX6tlvV97cl29/b8DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yr4ijmt1YUUHbuKMqGf4TSx32OlZk6WXURscgqDWIkfumoFSU9RKGAYWQhwsLAHpj
	 lIOViu27AGgipWnMSWEHFIkJpMuheUGiDRceZOn+Ban+jkCxK6y5szQ1tRFAMSg5Q2
	 af1PZtT0pc7xw/gmRb/4saj3XXXT1UtYI1wf8b0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 6.6 372/386] iommufd: Fix protection fault in iommufd_test_syz_conv_iova
Date: Tue,  8 Oct 2024 14:10:17 +0200
Message-ID: <20241008115644.025083174@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit cf7c2789822db8b5efa34f5ebcf1621bc0008d48 ]

Syzkaller reported the following bug:

  general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN
  KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
  Call Trace:
   lock_acquire
   lock_acquire+0x1ce/0x4f0
   down_read+0x93/0x4a0
   iommufd_test_syz_conv_iova+0x56/0x1f0
   iommufd_test_access_rw.isra.0+0x2ec/0x390
   iommufd_test+0x1058/0x1e30
   iommufd_fops_ioctl+0x381/0x510
   vfs_ioctl
   __do_sys_ioctl
   __se_sys_ioctl
   __x64_sys_ioctl+0x170/0x1e0
   do_syscall_x64
   do_syscall_64+0x71/0x140

This is because the new iommufd_access_change_ioas() sets access->ioas to
NULL during its process, so the lock might be gone in a concurrent racing
context.

Fix this by doing the same access->ioas sanity as iommufd_access_rw() and
iommufd_access_pin_pages() functions do.

Cc: stable@vger.kernel.org
Fixes: 9227da7816dd ("iommufd: Add iommufd_access_change_ioas(_id) helpers")
Link: https://lore.kernel.org/r/3f1932acaf1dd494d404c04364d73ce8f57f3e5e.1708636627.git.nicolinc@nvidia.com
Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
(cherry picked from commit cf7c2789822db8b5efa34f5ebcf1621bc0008d48)
[Harshit: CVE-2024-26785; Resolve conflicts due to missing commit:
 bd7a282650b8 ("iommufd: Add iommufd_ctx to iommufd_put_object()") in
 6.6.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/selftest.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -44,8 +44,8 @@ enum {
  * In syzkaller mode the 64 bit IOVA is converted into an nth area and offset
  * value. This has a much smaller randomization space and syzkaller can hit it.
  */
-static unsigned long iommufd_test_syz_conv_iova(struct io_pagetable *iopt,
-						u64 *iova)
+static unsigned long __iommufd_test_syz_conv_iova(struct io_pagetable *iopt,
+						  u64 *iova)
 {
 	struct syz_layout {
 		__u32 nth_area;
@@ -69,6 +69,21 @@ static unsigned long iommufd_test_syz_co
 	return 0;
 }
 
+static unsigned long iommufd_test_syz_conv_iova(struct iommufd_access *access,
+						u64 *iova)
+{
+	unsigned long ret;
+
+	mutex_lock(&access->ioas_lock);
+	if (!access->ioas) {
+		mutex_unlock(&access->ioas_lock);
+		return 0;
+	}
+	ret = __iommufd_test_syz_conv_iova(&access->ioas->iopt, iova);
+	mutex_unlock(&access->ioas_lock);
+	return ret;
+}
+
 void iommufd_test_syz_conv_iova_id(struct iommufd_ucmd *ucmd,
 				   unsigned int ioas_id, u64 *iova, u32 *flags)
 {
@@ -81,7 +96,7 @@ void iommufd_test_syz_conv_iova_id(struc
 	ioas = iommufd_get_ioas(ucmd->ictx, ioas_id);
 	if (IS_ERR(ioas))
 		return;
-	*iova = iommufd_test_syz_conv_iova(&ioas->iopt, iova);
+	*iova = __iommufd_test_syz_conv_iova(&ioas->iopt, iova);
 	iommufd_put_object(&ioas->obj);
 }
 
@@ -852,7 +867,7 @@ static int iommufd_test_access_pages(str
 	}
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
-		iova = iommufd_test_syz_conv_iova(&staccess->access->ioas->iopt,
+		iova = iommufd_test_syz_conv_iova(staccess->access,
 					&cmd->access_pages.iova);
 
 	npages = (ALIGN(iova + length, PAGE_SIZE) -
@@ -954,8 +969,8 @@ static int iommufd_test_access_rw(struct
 	}
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
-		iova = iommufd_test_syz_conv_iova(&staccess->access->ioas->iopt,
-					&cmd->access_rw.iova);
+		iova = iommufd_test_syz_conv_iova(staccess->access,
+				&cmd->access_rw.iova);
 
 	rc = iommufd_access_rw(staccess->access, iova, tmp, length, flags);
 	if (rc)


