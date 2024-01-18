Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DDE1774B;
	Thu, 18 Jan 2024 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575457; cv=none; b=C5YmgPRsaE4JQt4i9FL9dd0BMNq8kwltH0k3MiB0WGGcQBb3lbejQtRdpvnCnrRvxCaOMlti3oQTWHAXmJ0vx97NzVJsHxWE3m4LkFCVrRzQCEKWddYnrTdbkyJkLMdnJQhuL+zlE6k1AG/VDmaQ0PMugzsXt9rkWfqsqWf+Co0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575457; c=relaxed/simple;
	bh=ExwPUDCPJgdJx9j6mIezE9GYK5OScfImQHz6v2xI908=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=ZORgZnM5O3Yvx+zpeKBeFsougVV0324T/K+czGcqtCpS4dv+6zWMwtRD0tdaeDzy7hN/JW/+M8lHXhzgFCu8lOUu7cYJL4Mz7xNiEhE88p19eHAN6UxzNcBhG0FuYpIlgGzZWUNwsey48x5knjARVbiyIlAXosRjU0VqOhRHat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7D+U0vY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7D+U0vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2DBC433F1;
	Thu, 18 Jan 2024 10:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575457;
	bh=ExwPUDCPJgdJx9j6mIezE9GYK5OScfImQHz6v2xI908=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7D+U0vY+GJdY8TsqTuIEsBF4SbtDpg1u2Ql27pX+0flompNi6qQIRqNMSDuw0oOd
	 k6OsIUFyJj718igRuv3q/HvHuPqPocEStEs8iir6dpipwPv4TQsFzNPZ3aZEQofG/l
	 DYjSLOwZI/0rcGzr0FwLsOkgLZvxQbCsbTvlHibA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Howlett <liam.howlett@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.6 140/150] binder: fix use-after-free in shinkers callback
Date: Thu, 18 Jan 2024 11:49:22 +0100
Message-ID: <20240118104326.539020286@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1005,7 +1005,9 @@ enum lru_status binder_alloc_free_page(s
 		goto err_mmget;
 	if (!mmap_read_trylock(mm))
 		goto err_mmap_read_lock_failed;
-	vma = binder_alloc_get_vma(alloc);
+	vma = vma_lookup(mm, page_addr);
+	if (vma && vma != binder_alloc_get_vma(alloc))
+		goto err_invalid_vma;
 
 	list_lru_isolate(lru, item);
 	spin_unlock(lock);
@@ -1031,6 +1033,8 @@ enum lru_status binder_alloc_free_page(s
 	mutex_unlock(&alloc->mutex);
 	return LRU_REMOVED_RETRY;
 
+err_invalid_vma:
+	mmap_read_unlock(mm);
 err_mmap_read_lock_failed:
 	mmput_async(mm);
 err_mmget:


