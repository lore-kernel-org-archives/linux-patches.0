Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F961FDE31;
	Sat, 17 Oct 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256102; cv=none; b=V7ZrEXwnsm4lJm3xxk6nRN4WhGav6ErCUnfO2lhCjLPTYWN0wLkl/U4VQSHaCTwjGS7WEvXjAmn27ELc6CrTPzZ1JQwPb/I55jMbsc+Sr/a+UdNC8DGKrDjvt0eio+/Bx2Ou8fbBVDz5tiRp8GGonEGVJzMo8j1D1fOvXUccIf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256102; c=relaxed/simple;
	bh=QCgczWfGDNpNYx+uFHOhd9z7Rqjhs8oINloZT+3O2V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rse5EngSq76PrK4ApBiX1YalZkETqR8JVobU5Xe2WsXimI76JKqz/2ldQX7p8PlrQIrkAvkv9qJgfpph7LNkJ+Uz977FRWGQloaIsVcnahsPOMKW9YuO0KXis+8TovobAC2FMqGzJyxC9RlZUPl5qkOek8m4qxjkX2uH4dmHUCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aM38YkRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aM38YkRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F391F000C4;
	Sat, 17 Oct 2026 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256101;
	bh=0Fbl7Jd4/yodt9XLYYYtD9roG/QGU6OCqBa4S9bdv7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM38YkRXs8QbFABIfk14IckZPj3LEY87VFUGGVngXIVltVhXZ6KyV7p1pHAH0UNwM
	 j2E7fD02buup+kuFofGcf/ACkhI/jj1MuRi+7bPxGCyNiDnL6tTd3N2bNXDowugo/a
	 N1wfkyYn6IXueqP7Qty0g3THXxFt/zxb+OZKoupY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
	Jann Horn <jannh@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Larry Woodman <lwoodman@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Rik van Riel <riel@surriel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0126/1674] mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
Date: Sat, 17 Oct 2026 17:39:58 +0200
Message-ID: <20261017160434.392371944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit b6ac0b3f6013c168f22cad97e79967accacb08e1 ]

On arm64 server, we find that a task trying to grab the anon_vma lock
triggers hungtask.

INFO: task main:2354726 blocked for more than 120 seconds.
      Tainted: G            E     5.10.0-0021.aarch64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
Call trace:
 __switch_to+0x7c/0xbc
 __schedule+0x3b4/0x8a0
 schedule+0x50/0xe0
 rwsem_down_write_slowpath+0x3cc/0x6cc
 down_write+0x60/0x260
 __anon_vma_prepare+0x6c/0x210
 do_anonymous_page+0x258/0x660
 handle_pte_fault+0x188/0x214
 __handle_mm_fault+0x1b0/0x380
 handle_mm_fault+0xf4/0x284
 do_page_fault+0x19c/0x494
 do_translation_fault+0xcc/0xf8
 do_mem_abort+0x48/0xac
 el0_da+0x44/0x80
 el0_sync_handler+0x88/0xb4
 el0_sync+0x160/0x180

After analyzing the vmcore, we found the anon_vma->root->rwsem.count is
-1.  There is another anon_vma whose anon_vma->root->rwsem.count is 1, the
anon_vma->root->rwsem.owner shows the lock is held, but the stack of the
task shows the task doesn't hold the anon_vma lock.

After adding more debugging info, we found __anon_vma_prepare() reuses
anon_vma and triggers the UAF of anon_vma->root due to missing memory
barrier, leading to locking and unlocking two different anon_vma->root,
thus leading to an anon_vma will never be unlocked, and another anon_vma
couldn't be locked anymore.

This race requires two adjacent VMAs that are not merged but are
anon_vma-compatible (e.g., they differ in VMA_ACCESS_FLAGS that can be
changed by mprotect()).  Two threads fault on each VMA concurrently, both
calling __anon_vma_prepare() with only mmap_lock held for reading.

    THREAD A                             THREAD B
__anon_vma_prepare                __anon_vma_prepare
 find_mergeable_anon_vma() -> NULL
 anon_vma = anon_vma_alloc();
   anon_vma->root = anon_vma;
 // the two stores may be reordered
 vma->anon_vma = anon_vma;
                                   // finds A's anon_vma
                                   anon_vma = find_mergeable_anon_vma(vma);
                                   anon_vma_lock_write(anon_vma);
                                     // may still see the old root
                                     down_write(&anon_vma->root->rwsem);
                                   anon_vma_unlock_write(anon_vma);
                                     // see the new root, never unlock old
                                     up_write(&anon_vma->root->rwsem);

thread A triggers page fault and calls __anon_vma_prepare() to prepare
anon_vma for the faulting vma.  __anon_vma_prepare() allocates and
initializes a new anon_vma, and then publishes it to the vma with a plain
store.  anon_vma_prepare() only requires the mmap_lock to be held for
reading, so two threads can fault on adjacent VMAs at the same time.
While thread A publishes a new anon_vma, thread B could find the anon_vma
via find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.

The store to anon_vma->root in anon_vma_alloc() and the store to
vma->anon_vma can be reordered.  The anon_vma_lock_write() and spin_lock()
only provide acquire semantics, which do not prevent prior stores from
being reordered after them.  The release semantics of the corresponding
spin_unlock() and anon_vma_unlock_write() come too late, the store to
vma->anon_vma is already published before they take effect.  As a result,
thread B can observe the following order:

    vma->anon_vma = anon_vma;
    anon_vma->root = anon_vma;

The anon_vma slab is SLAB_TYPESAFE_BY_RCU, so a newly allocated anon_vma
may reuse memory from a previously freed one.  The constructor
(anon_vma_ctor) does not reset anon_vma->root, and __put_anon_vma()
doesn't clear it either, so the old root value persists until
anon_vma_alloc() overwrites it.  If that store isn't visible, thread B
reads a root that points to the old anon_vma and locks it.

As a result, thread B can call anon_vma_lock_write() with the old root,
and call anon_vma_unlock_write() with the new root, leading to an anon_vma
will never be unlocked, and another anon_vma couldn't be locked anymore
(its count is dropped from 0 to -1 due to wrong unlock).

To fix it, change the plain store `vma->anon_vma = anon_vma` to store
release, so that the fields of anon_vma are visible before anon_vma is
published to vma->anon_vma.

At read side, the load of anon_vma and anon_vma->root have address
dependency.  According to Documentation/memory-barriers.txt and some
investigations, only Alpha needs address-dependency barriers and it has
been handled by READ_ONCE() in reusable_anon_vma().

We reproduced this issue in v5.10 with KSM enabled.  The kernel doesn't
merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA merging for
new VMAs"), so there are many adjacent VMAs that aren't merged but are
compatible for anon_vma.

Without this fix, our production environment could reproduce this issue
about 2-5 times each month.  After adding a smp_mb() before
anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
to this patch, this issue hasn't been reproduced for one month.

Link: https://lore.kernel.org/20260908122924.554373-1-tujinjiang@huawei.com
Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
[ adjusted context for mm/mmap.c and the existing anon_vma_chain_link() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 8 ++++++++
 mm/rmap.c | 6 +++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 8cf23a07ae500..1b7e295128312 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1081,6 +1081,13 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
  * acceptable for merging, so we can do all of this optimistically. But
  * we do that READ_ONCE() to make sure that we never re-load the pointer.
  *
+ * The READ_ONCE() establishes an address dependency between anon_vma and
+ * any access to its fields, which pairs with the assignment to
+ * vma->anon_vma performed with release semantics in __anon_vma_prepare().
+ *
+ * This is especially important as anon_vma's are SLAB_TYPESAFE_BY_RCU so
+ * accessing an uninitialised anon_vma's fields may result in a UAF.
+ *
  * IOW: that the "list_is_singular()" test on the anon_vma_chain only
  * matters for the 'stable anon_vma' case (ie the thing we want to avoid
  * is to return an anon_vma that is "complex" due to having gone through
@@ -1093,6 +1100,7 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old, struct vm_area_struct *a, struct vm_area_struct *b)
 {
 	if (anon_vma_compatible(a, b)) {
+		/* Paired with a memory barrier in __anon_vma_prepare(). */
 		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
 
 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
diff --git a/mm/rmap.c b/mm/rmap.c
index 0a88928c410a0..531d6c813027d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -211,7 +211,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		/*
+		 * Make anon_vma fields visible before anon_vma is published.
+		 * Paired with an address dependency in reusable_anon_vma().
+		 */
+		smp_store_release(&vma->anon_vma, anon_vma);
 		anon_vma_chain_link(vma, avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
-- 
2.53.0



