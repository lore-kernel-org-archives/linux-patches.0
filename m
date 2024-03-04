Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845D12C689;
	Mon,  4 Mar 2024 21:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587847; cv=none; b=rrEXrTWZvxXy4jlDE7g98tfuq5TkYD/iU7WBrg9fiTjoOYnnuHScIJS9sKoE/gIiuZlahItqq3NtVmCDR8H7RYGY8KSKRqMQhcX/+ibtJxCtT5KytDZv55A/fcbzegIEgt4KW7VoajO0NU4Crm95IcXczovqhdT3SmAeV1hyWLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587847; c=relaxed/simple;
	bh=vdB0fV+p/1hTRQd8AZHHT0oh1VUav2IVbXy7xP/TbQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i++wcPU9GfQWOtcyzGU4AgtfS/6TIo7G+MZSDUQQPP21Ih1/97zgwTME2Py2BGJ1EVpAGysVFuP9gyZJRaE5NKEOn3AC/6WG3ojVnSa5YYOe9Ciq6anV3lf9OPnNUxMIdxOFsayC0MnCXqkHilxy11P6rks0tluNiD2Wq5WBWJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0lyR8Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0lyR8Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCC3C433F1;
	Mon,  4 Mar 2024 21:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587847;
	bh=vdB0fV+p/1hTRQd8AZHHT0oh1VUav2IVbXy7xP/TbQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0lyR8KayjgF7NsI48xOxVSxbC+WqAymJCzt8mT33s34iZPFL4H1ZszsNVgi+H/Wh
	 VG1wMNSJuiUSQiekj57140Lda+spS2XqPcBZYPfbnD3obCm9fT5GFKShGDmN+KVV3u
	 yafhJYIAr1aqnb4qOXRhd43g3eJFnU2vN9AOWeIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 6.7 112/162] iommufd: Fix protection fault in iommufd_test_syz_conv_iova
Date: Mon,  4 Mar 2024 21:22:57 +0000
Message-ID: <20240304211555.361490466@linuxfoundation.org>
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

commit cf7c2789822db8b5efa34f5ebcf1621bc0008d48 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/selftest.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -48,8 +48,8 @@ enum {
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
@@ -73,6 +73,21 @@ static unsigned long iommufd_test_syz_co
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
@@ -85,7 +100,7 @@ void iommufd_test_syz_conv_iova_id(struc
 	ioas = iommufd_get_ioas(ucmd->ictx, ioas_id);
 	if (IS_ERR(ioas))
 		return;
-	*iova = iommufd_test_syz_conv_iova(&ioas->iopt, iova);
+	*iova = __iommufd_test_syz_conv_iova(&ioas->iopt, iova);
 	iommufd_put_object(ucmd->ictx, &ioas->obj);
 }
 
@@ -1045,7 +1060,7 @@ static int iommufd_test_access_pages(str
 	}
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
-		iova = iommufd_test_syz_conv_iova(&staccess->access->ioas->iopt,
+		iova = iommufd_test_syz_conv_iova(staccess->access,
 					&cmd->access_pages.iova);
 
 	npages = (ALIGN(iova + length, PAGE_SIZE) -
@@ -1147,8 +1162,8 @@ static int iommufd_test_access_rw(struct
 	}
 
 	if (flags & MOCK_FLAGS_ACCESS_SYZ)
-		iova = iommufd_test_syz_conv_iova(&staccess->access->ioas->iopt,
-					&cmd->access_rw.iova);
+		iova = iommufd_test_syz_conv_iova(staccess->access,
+				&cmd->access_rw.iova);
 
 	rc = iommufd_access_rw(staccess->access, iova, tmp, length, flags);
 	if (rc)


