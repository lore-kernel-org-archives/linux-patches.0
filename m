Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623EA4E323A;
	Thu, 17 Sep 2026 15:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660060; cv=none; b=BvMScDS4yoXDoBHZxiujqL/w+zmWz6yrtQCwJX0U2dclmO6uHa5ohvMrTBp6V5y+m7ETpwBk7kns3Bk+5X3/JhrxWhtVe07/K7ckYnn4cjYPOg9FHiVylDkzJ+V7LOfV85SB4bs2eUVAH9VDpVmK+Wf+I7ia7vIW6iNg64yUv4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660060; c=relaxed/simple;
	bh=86HGwE19lyDd+m2VysZs9pbCWvXj5dv5ApgYVc4wGJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p10q8MfwoWZxNItJJ5eEDSaaaheyDlqfzgzpKaBWVmKJXkF+HfER5jl2Q4pF/yABS3t7AGz3XGxkUYy1yh/uvuiwD6wZ95eczgAd4Ck4iC88xuPUfdD3icQM9agqN3Q4OTe40vjj1H92QRXIhfV5oe2WW8Dd2FgEY1kMTsNdVKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPr0iFIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPr0iFIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27A61F00893;
	Thu, 17 Sep 2026 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660050;
	bh=3lXOu5khfqDlWEw9VR0XGQu7tObzEzdkl9rHmK+0XY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPr0iFISzhfXrqi7GK159oilCme1ANeDru+yOWaXi/C7hT9Q0L/cGulog8oSSCDaB
	 Ln5uoGAKe7FyJhIYnfUOBej4+mnufuScz+QHDYwgMqXa5jBsRsPqT7FDOwF54Xbigo
	 QtpM2Q2eUy1MLQX/0Ibu1OE2N5K475toO+qhXKL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.2 463/733] mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race
Date: Thu, 17 Sep 2026 16:12:51 +0100
Message-ID: <20260917151403.491451234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Harry Yoo (Meta) <harry@kernel.org>

commit 4a724bcf5d703e18957397914d79156fa2cf1174 upstream.

Commit ba7425312607 ("mm, slab: add an optimistic
__slab_try_return_freelist()") incorrectly assumed that nobody has freed
an object to the slab as long as slab->freelist is NULL and cmpxchg
succeeds.

However, as reported by Hyunwoo Kim [1], other CPUs might have freed
an object to the slab, insert the slab to the partial list, then
allocated an object from the slab, and be in the middle of removing
the slab from the list under n->list_lock.

Since __refill_objects_node() puts the slab back on pc.slabs
outside n->list_lock, it might insert the slab into that list while
the slab is concurrently being removed from n->partial.
This led to a list corruption [1]:

  list_add corruption. next->prev should be prev
  (ffff888100000248), but was dead000000000122.
  (next=ffffea000416e410).
  kernel BUG at lib/list_debug.c:29!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
  7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
  RIP: 0010:__list_add_valid_or_report+0x80/0xd0
  ...
  Call Trace:
   alloc_from_new_slab+0x183/0x300
   ___slab_alloc+0x31c/0x890
   __kmalloc_noprof+0x3d4/0x800
   lsm_blob_alloc+0x2d/0x50
   security_msg_msg_alloc+0x26/0x90
   load_msg+0x1aa/0x210
   do_msgsnd+0x91/0x800
   do_syscall_64+0x109/0x5d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  Kernel panic - not syncing: Fatal exception

This is a classic ABA problem where cmpxchg succeeds but the state has
changed since __refill_objects_node() took the freelist from the slab.

As Vlastimil Babka mentioned [2], it should be rare to return more than
one slab (due to the racy read of slab->counters in
get_partial_node_bulk()). Therefore, instead of introducing additional
complexity, acquire and release n->list_lock twice in the worst case.

Return the slab directly to the partial list and hold n->list_lock
across the cmpxchg and add_partial(). This is similar to the initial
version of commit ba7425312607 [3]. This is enough to avoid the race as
the list manipulation is serialized by n->list_lock. While at it,
bring back unlikely() hint now that the condition is unlikely.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/linux-mm/apPa-cGLcyt90l-E@v4bel [1]
Link: https://lore.kernel.org/linux-mm/ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org [2]
Link: https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org [3]
Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Link: https://patch.msgid.link/20260903-slab-fix-aba-v3-1-b44cb6badd54@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5612,10 +5612,12 @@ static noinline void free_to_partial_lis
  *
  * Fail if the slab isn't full anymore due to a concurrent free.
  */
-static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
-				       void *head, int cnt)
+static bool __slab_try_return_freelist(struct kmem_cache *s,
+				       struct kmem_cache_node *n,
+				       struct slab *slab, void *head, int cnt)
 {
 	struct freelist_counters old, new;
+	unsigned long flags;
 
 	old.freelist = slab->freelist;
 	old.counters = slab->counters;
@@ -5627,9 +5629,15 @@ static bool __slab_try_return_freelist(s
 	new.counters = old.counters;
 	new.inuse -= cnt;
 
-	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist")) {
+		spin_unlock_irqrestore(&n->list_lock, flags);
 		return false;
+	}
 
+	add_partial(n, slab, ADD_TO_TAIL);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	return true;
 }
 
@@ -7202,10 +7210,8 @@ __refill_objects_node(struct kmem_cache
 			void *head = object;
 			void *tail;
 
-			if (__slab_try_return_freelist(s, slab, head, count)) {
-				list_add(&slab->slab_list, &pc.slabs);
+			if (__slab_try_return_freelist(s, n, slab, head, count))
 				break;
-			}
 
 			do {
 				tail = object;
@@ -7218,7 +7224,7 @@ __refill_objects_node(struct kmem_cache
 			break;
 	}
 
-	if (!list_empty(&pc.slabs)) {
+	if (unlikely(!list_empty(&pc.slabs))) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry(slab, &pc.slabs, slab_list)


