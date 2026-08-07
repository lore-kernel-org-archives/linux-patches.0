Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29CB3DBD4E;
	Fri,  7 Aug 2026 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114079; cv=none; b=mMgT68GlyE9gQ29SBvaazHbmijCJKyPCkgsFfRHUiFsKIJzq+GRk+YsKhtMVMxao5xlenMDP59R4kTrlJymPBrBjpCDavQmb5t1yCYqU7qIIaxWHPCvTWEol5tS6Vj3Un8Y/v0D5I0A1mKQssCox+BsG2Ja3QwdfM+56eTNr+MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114079; c=relaxed/simple;
	bh=xJ+XJcLR+pyirJNnykpuDH5LdKVthwn3lE+SzYfs/sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LftjLKmB1OP9EsoiYEVLuNRDe4yTfmpSVNhwF+VB6TSSEfq/BSuH5O/DutsM/2yvjfl7fpx9RcvK0kyE65CZsWcmJ3uYAAjGaXFSsWZ8X5xjNNkEwPV96y23OlBXTUumWzkHPrF5zB1RIjbJXy14N9LmKKYrFeCU08kEZSg1zcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgqtADzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgqtADzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDCC1F000E9;
	Fri,  7 Aug 2026 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114076;
	bh=skl13YoowjPo9CmYnHeVzlHQv37g7o02yYflOa/RlJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgqtADzG/4Ji9SYY5v3rE2c2fRpSpRZuu2MmBlQZ04Kd05iKJAt5kdm9fOnSIUWlZ
	 8Wgo8Q/ADpB4ubMFiPQhI6fI0FLxx2sSd6RalMCdkcJe3tVpZIh/ZRUuF54Km8lR55
	 qqSvLCoeRKAa5tqse3IEQHYgBTIa8jVgGa2umitM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangfeng Cai <caixiangfeng@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Baoquan He <baoquan.he@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Shuah Khan <shuah@kernel.org>,
	Wei Yang <richard.weiyang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 137/337] mm/hugetlb: fix list corruption in allocate_file_region_entries()
Date: Fri,  7 Aug 2026 16:35:40 +0200
Message-ID: <20260807143421.504549252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Xiangfeng Cai <caixiangfeng@bytedance.com>

commit dd9623f58ec702a07b2d67179d6fcea79c52231a upstream.

allocate_file_region_entries() tops up resv->region_cache with freshly
allocated file_region descriptors.  The allocation uses GFP_KERNEL, so
resv->lock is dropped around it: the new entries are gathered on a
stack-local list head, allocated_regions, and spliced into
resv->region_cache once the lock is re-acquired.

The splice used list_splice(), which moves the entries but does not
re-initialize the source head, so allocated_regions is left pointing at an
entry that now lives on resv->region_cache.  The top-up runs in a while
loop that re-checks the cache deficit after re-acquiring the lock.  For a
shared mapping the resv_map is shared by every mapper of the hugetlbfs
inode, so a concurrent region_chg()/region_add()/region_del() on the same
resv_map can consume cache entries during the unlocked window and force a
second iteration.  That iteration calls list_add() on the stale head and
corrupts the list; with CONFIG_DEBUG_LIST the __list_add_valid() check
trips:

  list_add corruption. next->prev should be prev (ffffc900011ff7f8),
  but was ffff88814c281460. (next=ffff88814c545640).
  kernel BUG at lib/list_debug.c:31!
   allocate_file_region_entries+0x191/0x420
   region_chg+0x267/0x300
   hugetlb_reserve_pages+0x387/0xc80
   hugetlbfs_file_mmap+0x2ce/0x3f0
   mmap_region+0x1348/0x1a80
   do_mmap+0x85e/0xb90
   vm_mmap_pgoff+0x18c/0x330
   ksys_mmap_pgoff+0x2a1/0x3e0
   do_syscall_64+0xd7/0x420

Without CONFIG_DEBUG_LIST the bad list_add() silently links a kernel-stack
address into resv->region_cache, leading to later use-after-free.

This was observed as a real host panic on a dense KVM host where a QEMU
guest-RAM hugetlbfs file was mapped MAP_SHARED by both QEMU and a separate
SPDK/DPDK vhost-user target, generating concurrent region_* traffic on one
shared resv_map.

Use list_splice_init() so the source head is re-initialized empty after
each splice, making the retry loop safe.

Link: https://lore.kernel.org/20260713171456.300518-2-caixiangfeng@bytedance.com
Fixes: d3ec7b6e09e5 ("mm/hugetlb: use list_splice to merge two list at once")
Signed-off-by: Xiangfeng Cai <caixiangfeng@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -676,7 +676,7 @@ static int allocate_file_region_entries(
 
 		spin_lock(&resv->lock);
 
-		list_splice(&allocated_regions, &resv->region_cache);
+		list_splice_init(&allocated_regions, &resv->region_cache);
 		resv->region_cache_count += to_allocate;
 	}
 


