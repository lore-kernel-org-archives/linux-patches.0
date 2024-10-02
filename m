Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E191D0E2C;
	Wed,  2 Oct 2024 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878555; cv=none; b=oQLfc/juac8zjAqKoooce2HEck5M+/Hw3W0IFdr5A1KJv9SvpR0WITWbuAKOEqMNQbPA73Yr96XPDmCZnAlS3TRVwOBqJII2UMxtYmgj2njR9qW5fE0fkAwK7IOquTwGvOieko8c9ieZj5c5QSF+zLSOhAcPl3cAVhOcoiy/IjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878555; c=relaxed/simple;
	bh=fg1tqtm9gFt4z3bNaPNXewnQEfuO94d97ozBpdZhw0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ev5OOmT+4o5AQpI+uCD+Pz46Ioy66ARr6fYzVTSpHNX67ReEnZpqpr5ZuBC/UdZihecB87s3NGeD+I1t+fRtZiziZhjGj+ljKkyEMRfHDF+iXugrgEss4afiuuhBrSMLodlJQrG2ANGlkvrScPVz765lHJw0zd3owbvREn7k71U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdosGf0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdosGf0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE0FC4CEC2;
	Wed,  2 Oct 2024 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878554;
	bh=fg1tqtm9gFt4z3bNaPNXewnQEfuO94d97ozBpdZhw0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdosGf0bGSowMLjmxEMvz83gX3aed19iyd+HP1m+zTZthAkJ/86WBVkF8zgBJx4aW
	 lY2DrSZzgzpaM1K0eQa41UWBBROlLRPEZlPLM0WHBzUVWNv5deKevRXBbncxzomAuE
	 biuZy4luV6d/G80bPlO4+KpBFU3m/7Qg8e39FKEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	syzbot <syzkaller@googlegroups.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 454/634] mm: migrate: annotate data-race in migrate_folio_unmap()
Date: Wed,  2 Oct 2024 14:59:14 +0200
Message-ID: <20241002125829.023603895@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 8001070cfbec5cd4ea00b8b48ea51df91122f265 upstream.

I found a report from syzbot [1]

This report shows that the value can be changed, but in reality, the
value of __folio_set_movable() cannot be changed because it holds the
folio refcount.

Therefore, it is appropriate to add an annotate to make KCSAN
ignore that data-race.

[1]

==================================================================
BUG: KCSAN: data-race in __filemap_remove_folio / migrate_pages_batch

write to 0xffffea0004b81dd8 of 8 bytes by task 6348 on cpu 0:
 page_cache_delete mm/filemap.c:153 [inline]
 __filemap_remove_folio+0x1ac/0x2c0 mm/filemap.c:233
 filemap_remove_folio+0x6b/0x1f0 mm/filemap.c:265
 truncate_inode_folio+0x42/0x50 mm/truncate.c:178
 shmem_undo_range+0x25b/0xa70 mm/shmem.c:1028
 shmem_truncate_range mm/shmem.c:1144 [inline]
 shmem_evict_inode+0x14d/0x530 mm/shmem.c:1272
 evict+0x2f0/0x580 fs/inode.c:731
 iput_final fs/inode.c:1883 [inline]
 iput+0x42a/0x5b0 fs/inode.c:1909
 dentry_unlink_inode+0x24f/0x260 fs/dcache.c:412
 __dentry_kill+0x18b/0x4c0 fs/dcache.c:615
 dput+0x5c/0xd0 fs/dcache.c:857
 __fput+0x3fb/0x6d0 fs/file_table.c:439
 ____fput+0x1c/0x30 fs/file_table.c:459
 task_work_run+0x13a/0x1a0 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xbe/0x130 kernel/entry/common.c:218
 do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffffea0004b81dd8 of 8 bytes by task 6342 on cpu 1:
 __folio_test_movable include/linux/page-flags.h:699 [inline]
 migrate_folio_unmap mm/migrate.c:1199 [inline]
 migrate_pages_batch+0x24c/0x1940 mm/migrate.c:1797
 migrate_pages_sync mm/migrate.c:1963 [inline]
 migrate_pages+0xff1/0x1820 mm/migrate.c:2072
 do_mbind mm/mempolicy.c:1390 [inline]
 kernel_mbind mm/mempolicy.c:1533 [inline]
 __do_sys_mbind mm/mempolicy.c:1607 [inline]
 __se_sys_mbind+0xf76/0x1160 mm/mempolicy.c:1603
 __x64_sys_mbind+0x78/0x90 mm/mempolicy.c:1603
 x64_sys_call+0x2b4d/0x2d60 arch/x86/include/generated/asm/syscalls_64.h:238
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0xffff888127601078 -> 0x0000000000000000

Link: https://lkml.kernel.org/r/20240924130053.107490-1-aha310510@gmail.com
Fixes: 7e2a5e5ab217 ("mm: migrate: use __folio_test_movable()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1129,7 +1129,7 @@ static int migrate_folio_unmap(new_folio
 	int rc = -EAGAIN;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
-	bool is_lru = !__folio_test_movable(src);
+	bool is_lru = data_race(!__folio_test_movable(src));
 	bool locked = false;
 	bool dst_locked = false;
 


