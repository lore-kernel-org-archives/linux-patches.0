Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4948F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8F4C433C8;
	Sun, 16 Jul 2023 20:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538389;
	bh=WcLJCicovqLz7fsNGF97zdeRf48S0laKYSo1kJL+d5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umxAbQDXg0ftuv2lylw6vmg84cxD4ozDf9d4zSCmvIwpuRu32TfFgXvjRztCHPBoc
	 /18HIlDkQp3qYHqdkEbz37CyTyIoB5XbZEYVmcuQPbVIQkuh1/63/YvWndO2iajR5S
	 DROWQekkkZ2Sij02BYSbk4wiCDHJurB0us7C/5Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	syzbot+6c8d756f238a75fc3eb8@syzkaller.appspotmail.com,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 434/800] iommufd: Call iopt_area_contig_done() under the lock
Date: Sun, 16 Jul 2023 21:44:47 +0200
Message-ID: <20230716194959.165327518@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit dbe245cdf5189e88d680379ed13901356628b650 ]

The iter internally holds a pointer to the area and
iopt_area_contig_done() will dereference it. The pointer is not valid
outside the iova_rwsem.

syzkaller reports:

  BUG: KASAN: slab-use-after-free in iommufd_access_unpin_pages+0x363/0x370
  Read of size 8 at addr ffff888022286e20 by task syz-executor669/5771

  CPU: 0 PID: 5771 Comm: syz-executor669 Not tainted 6.4.0-rc5-syzkaller-00313-g4c605260bc60 #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
  Call Trace:
   <TASK>
   dump_stack_lvl+0xd9/0x150
   print_address_description.constprop.0+0x2c/0x3c0
   kasan_report+0x11c/0x130
   iommufd_access_unpin_pages+0x363/0x370
   iommufd_test_access_unmap+0x24b/0x390
   iommufd_access_notify_unmap+0x24c/0x3a0
   iopt_unmap_iova_range+0x4c4/0x5f0
   iopt_unmap_all+0x27/0x50
   iommufd_ioas_unmap+0x3d0/0x490
   iommufd_fops_ioctl+0x317/0x4b0
   __x64_sys_ioctl+0x197/0x210
   do_syscall_64+0x39/0xb0
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7fec1dae3b19
  Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007fec1da74308 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007fec1db6b438 RCX: 00007fec1dae3b19
  RDX: 0000000020000100 RSI: 0000000000003b86 RDI: 0000000000000003
  RBP: 00007fec1db6b430 R08: 00007fec1da74700 R09: 0000000000000000
  R10: 00007fec1da74700 R11: 0000000000000246 R12: 00007fec1db6b43c
  R13: 00007fec1db39074 R14: 6d6f692f7665642f R15: 0000000000022000
   </TASK>

  Allocated by task 5770:
   kasan_save_stack+0x22/0x40
   kasan_set_track+0x25/0x30
   __kasan_kmalloc+0xa2/0xb0
   iopt_alloc_area_pages+0x94/0x560
   iopt_map_user_pages+0x205/0x4e0
   iommufd_ioas_map+0x329/0x5f0
   iommufd_fops_ioctl+0x317/0x4b0
   __x64_sys_ioctl+0x197/0x210
   do_syscall_64+0x39/0xb0
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

  Freed by task 5770:
   kasan_save_stack+0x22/0x40
   kasan_set_track+0x25/0x30
   kasan_save_free_info+0x2e/0x40
   ____kasan_slab_free+0x160/0x1c0
   slab_free_freelist_hook+0x8b/0x1c0
   __kmem_cache_free+0xaf/0x2d0
   iopt_unmap_iova_range+0x288/0x5f0
   iopt_unmap_all+0x27/0x50
   iommufd_ioas_unmap+0x3d0/0x490
   iommufd_fops_ioctl+0x317/0x4b0
   __x64_sys_ioctl+0x197/0x210
   do_syscall_64+0x39/0xb0
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

The parallel unmap free'd iter->area the instant the lock was released.

Fixes: 51fe6141f0f6 ("iommufd: Data structure to provide IOVA to PFN mapping")
Link: https://lore.kernel.org/r/2-v2-9a03761d445d+54-iommufd_syz2_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reported-by: syzbot+6c8d756f238a75fc3eb8@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/000000000000905eba05fe38e9f2@google.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4f9b2142274ce..29d05663d4d17 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -553,8 +553,8 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
 			iopt_area_iova_to_index(
 				area,
 				min(last_iova, iopt_area_last_iova(area))));
-	up_read(&iopt->iova_rwsem);
 	WARN_ON(!iopt_area_contig_done(&iter));
+	up_read(&iopt->iova_rwsem);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_access_unpin_pages, IOMMUFD);
 
-- 
2.39.2



