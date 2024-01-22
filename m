Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A1512DDB8;
	Tue, 23 Jan 2024 00:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968982; cv=none; b=QF82b9wSU/sRJU5ThkNVlfBCUtOQMUvz1TAOUcHV8wYiinRRWE+HpZCXmQpJM1/3EFBC2QwB68bsDxdQghNcR4kTGOkq7o4GY2qK/Dabm7pu3DRnvjiFkNRvf/E6PHnmjCkKkK93FYRkkTZ6QKxX0poJSmAsaknEaDVPVl4njBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968982; c=relaxed/simple;
	bh=z1MzaqgzMuWR+TRJc7Kfzf1aAc2AHvRPgJxd6jfeGug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR3ObV2XtdtrgBRTN6BNNerTBJXsHkuTuvDiEFRblMTIr7tY4ePxVSnigje09Gft/xPmOi6QN7cViq4I17EE/spJxgIr9q4OqD+5BKVfYFodKOFA6Rk1qD/MQAfLE4jujINEbptV7lqXIeuVVGS9NKNnVhnQBDJQmY3ENeeJ/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWJyQNFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWJyQNFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7CC433F1;
	Tue, 23 Jan 2024 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968982;
	bh=z1MzaqgzMuWR+TRJc7Kfzf1aAc2AHvRPgJxd6jfeGug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWJyQNFfBFlfuylYRLiDzcwxddpjFpEqhtiEbgvlEbmoVZoLc/29xYfNLBMPvmysw
	 1+J9SYcKNH56p/9/gcjGns+LZij/Y/pGY161yj/0c+SWwv5LnXHn8VAbC48+/+ew6W
	 T9fRS4JU7CwkAAfXfdrzW4dE8DtrWQRsenqLb2DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <liam.howlett@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.4 140/194] binder: fix use-after-free in shinkers callback
Date: Mon, 22 Jan 2024 15:57:50 -0800
Message-ID: <20240122235725.239958227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 3f489c2067c5824528212b0fc18b28d51332d906 upstream.

The mmap read lock is used during the shrinker's callback, which means
that using alloc->vma pointer isn't safe as it can race with munmap().
As of commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
munmap") the mmap lock is downgraded after the vma has been isolated.

I was able to reproduce this issue by manually adding some delays and
triggering page reclaiming through the shrinker's debug sysfs. The
following KASAN report confirms the UAF:

  ==================================================================
  BUG: KASAN: slab-use-after-free in zap_page_range_single+0x470/0x4b8
  Read of size 8 at addr ffff356ed50e50f0 by task bash/478

  CPU: 1 PID: 478 Comm: bash Not tainted 6.6.0-rc5-00055-g1c8b86a3799f-dirty #70
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   zap_page_range_single+0x470/0x4b8
   binder_alloc_free_page+0x608/0xadc
   __list_lru_walk_one+0x130/0x3b0
   list_lru_walk_node+0xc4/0x22c
   binder_shrink_scan+0x108/0x1dc
   shrinker_debugfs_scan_write+0x2b4/0x500
   full_proxy_write+0xd4/0x140
   vfs_write+0x1ac/0x758
   ksys_write+0xf0/0x1dc
   __arm64_sys_write+0x6c/0x9c

  Allocated by task 492:
   kmem_cache_alloc+0x130/0x368
   vm_area_alloc+0x2c/0x190
   mmap_region+0x258/0x18bc
   do_mmap+0x694/0xa60
   vm_mmap_pgoff+0x170/0x29c
   ksys_mmap_pgoff+0x290/0x3a0
   __arm64_sys_mmap+0xcc/0x144

  Freed by task 491:
   kmem_cache_free+0x17c/0x3c8
   vm_area_free_rcu_cb+0x74/0x98
   rcu_core+0xa38/0x26d4
   rcu_core_si+0x10/0x1c
   __do_softirq+0x2fc/0xd24

  Last potentially related work creation:
   __call_rcu_common.constprop.0+0x6c/0xba0
   call_rcu+0x10/0x1c
   vm_area_free+0x18/0x24
   remove_vma+0xe4/0x118
   do_vmi_align_munmap.isra.0+0x718/0xb5c
   do_vmi_munmap+0xdc/0x1fc
   __vm_munmap+0x10c/0x278
   __arm64_sys_munmap+0x58/0x7c

Fix this issue by performing instead a vma_lookup() which will fail to
find the vma that was isolated before the mmap lock downgrade. Note that
this option has better performance than upgrading to a mmap write lock
which would increase contention. Plus, mmap_write_trylock() has been
recently removed anyway.

Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Cc: stable@vger.kernel.org
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-3-cmllamas@google.com
[cmllamas: use find_vma() instead of vma_lookup() as commit ce6d42f2e4a2
 is missing in v5.4. This only works because we check the vma against
 our cached alloc->vma pointer. Also, unlock via up_read() instead of
 mmap_read_unlock() as commit d8ed45c5dcd4 is also missing in v5.4.]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -954,7 +954,9 @@ enum lru_status binder_alloc_free_page(s
 		goto err_mmget;
 	if (!down_read_trylock(&mm->mmap_sem))
 		goto err_down_read_mmap_sem_failed;
-	vma = binder_alloc_get_vma(alloc);
+	vma = find_vma(mm, page_addr);
+	if (vma && vma != binder_alloc_get_vma(alloc))
+		goto err_invalid_vma;
 
 	list_lru_isolate(lru, item);
 	spin_unlock(lock);
@@ -980,6 +982,8 @@ enum lru_status binder_alloc_free_page(s
 	mutex_unlock(&alloc->mutex);
 	return LRU_REMOVED_RETRY;
 
+err_invalid_vma:
+	up_read(&mm->mmap_sem);
 err_down_read_mmap_sem_failed:
 	mmput_async(mm);
 err_mmget:


