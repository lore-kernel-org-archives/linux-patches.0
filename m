Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404E4156F0;
	Fri,  4 Sep 2026 05:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499901; cv=none; b=qsX1J9OpfkQyB9XoI+hQA4pDZLOLA33aSjBP2Z1E2TTkcnSo3Rwj9cr0nelCqk1ktisj9ZNRw1U3/l0UCaFk52W2VFrae2MFqIncZi7o4apdCubnSQWkZBc2N2XPi+z162jDaAm2iAoo7Qlppyw5hbu5duyJWFHfGyfsv3CZOgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499901; c=relaxed/simple;
	bh=ukGxEIvvMWpHuNoXpMes4VfNmnF0H5oYD/MULj04eU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdJ5Lvkr3bq0uFt7+tIUdac2IUy1kxfZpVax/cKPu88fCp66D0ObwUbZr2eBZuYhNx2h03+phQG/gfMhRMhMyI4XuCYXIQEPxfN5W+rzcMVhSXFJI98rOjAVh6cjLoBC2NAaWi8YCI1F4oGyrxqNCHQ1UHHAbfoJ9eo4ejpuukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1L4rTis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1L4rTis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7A11F00A3D;
	Fri,  4 Sep 2026 05:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499899;
	bh=AuuVn9RQmW8IQybnKiolxSXn+nFoErav0F3IkPbssdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1L4rTisi8mjt3gk0hYmHW3KugBTXjuhW0AylyBmMmgCYDCQxp66lHT7lVM0Wfc1+
	 H+d63ZpFW0FeC7vnbW91hgO0M9psu78M7kgfRn7WvuEWbVq0wpdYBk1J9Ulhq4d+O3
	 BXmAyaKsOUtLEDeVwz2axXWrbn56Lx0ZEb2f4wvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 543/713] iommu: Fix dev_iommu memory leak when device_add fails in iommu_mock_device_add
Date: Fri,  4 Sep 2026 06:58:31 +0200
Message-ID: <20260904045815.990878213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

commit b7b0b3851474883d4aba6ed72da87141204b23e5 upstream.

iommu_mock_device_add() first calls iommu_fwspec_init(), which on
success allocates both dev->iommu (via dev_iommu_get()) and
dev->iommu->fwspec. If the subsequent device_add(dev) call fails,
the error path only calls iommu_fwspec_free(dev), which frees
fwspec but leaves dev->iommu still allocated.

This triggers the following kmemleak report when fuzzing with Syzkaller:

BUG: memory leak
unreferenced object 0xffff888011e0a200 (size 192):
  comm "syz.1.1695", pid 24885, jiffies 4295222527
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 00 00 00 00 ff ff ff ff ff ff ff ff  ................
  backtrace (crc 25df5bb3):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4575 [inline]
    slab_alloc_node mm/slub.c:4899 [inline]
    __kmalloc_cache_noprof+0x47a/0x710 mm/slub.c:5415
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    dev_iommu_get+0x10c/0x1a0 drivers/iommu/iommu.c:408
    iommu_fwspec_init+0x288/0x4d0 drivers/iommu/iommu.c:3087
    iommu_mock_device_add+0x46/0xb0 drivers/iommu/iommu.c:385
    mock_dev_create drivers/iommu/iommufd/selftest.c:1025 [inline]
    iommufd_test_mock_domain drivers/iommu/iommufd/selftest.c:1066 [inline]
    iommufd_test+0x2f8a/0x6190 drivers/iommu/iommufd/selftest.c:2072
    iommufd_fops_ioctl+0x367/0x540 drivers/iommu/iommufd/main.c:533
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:597 [inline]
    __se_sys_ioctl fs/ioctl.c:583 [inline]
    __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by calling dev_iommu_free(dev) instead of iommu_fwspec_free(dev)
in the device_add() failure path. dev_iommu_free() frees both fwspec
and the outer dev_iommu struct and clears dev->iommu.

Link: https://patch.msgid.link/r/76AC62D46B998556+20260711055119.1003477-1-peiyang_he@smail.nju.edu.cn
Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Fixes: 2a918911ed3d ("iommufd: Register iommufd mock devices with fwspec")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -390,7 +390,7 @@ int iommu_mock_device_add(struct device
 
 	rc = device_add(dev);
 	if (rc)
-		iommu_fwspec_free(dev);
+		dev_iommu_free(dev);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iommu_mock_device_add);


