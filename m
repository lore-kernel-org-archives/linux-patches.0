Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810C2FDC4F;
	Tue, 12 Aug 2025 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025299; cv=none; b=JZrv+XT9J6rRw5AYNcPmCAOMbg8XlzzTJaq7lA1F0ch3ud/ET4jpRX9CzX9rqlEkvha7Cu4NpMwvrLcZ4q7nHhAy7qqkng0tkqWz8ojnoFq1D1erQYLtw/MlTC9FrrWxUxNcDDgDGabYvziTluO7a7AD/soEwPtFGmlfWHkc/Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025299; c=relaxed/simple;
	bh=8D58WCDbPZKHv1mBOILaA+TF3UBArd7ThEjzqVvo5Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km+sAqCtAv8si5MomxS213nXKpKqpfi8SKvAmcSY98U8KdgYOrGcJGV/So6ZjvXPBLdwYKy45lYkONjUfDhZdCBWlMUl4EgXrQynngTVxiFzPnR/z0EShJZ+ADKT73SZ97NiGJTmagizYm3xclEs3RPPiprJ1OvlSBPMPakPnfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKnjLvUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKnjLvUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF2C4CEF7;
	Tue, 12 Aug 2025 19:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025298;
	bh=8D58WCDbPZKHv1mBOILaA+TF3UBArd7ThEjzqVvo5Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKnjLvUNbuGSb1TMUPCWL8UCEENdoXQc9gYrd1auKEP5+OnXnr4eWeD2UIVuq7xbF
	 zoxdACbstms99OivizxZXJDFoIfmZ0K+XvyTrcQvJ2bPAGMX9zbIHt2AZ5xNiS1Xh6
	 cHTjTkyBEF+BUj4ATUcjDNgz+DndBDKjSzIjCfSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 627/627] mm: fix a UAF when vma->mm is freed after vma->vm_refcnt got dropped
Date: Tue, 12 Aug 2025 19:35:22 +0200
Message-ID: <20250812173455.732520503@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 9bbffee67ffd16360179327b57f3b1245579ef08 upstream.

By inducing delays in the right places, Jann Horn created a reproducer for
a hard to hit UAF issue that became possible after VMAs were allowed to be
recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.

Race description is borrowed from Jann's discovery report:
lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
rcu_read_lock().  At that point, the VMA may be concurrently freed, and it
can be recycled by another process.  vma_start_read() then increments the
vma->vm_refcnt (if it is in an acceptable range), and if this succeeds,
vma_start_read() can return a recycled VMA.

In this scenario where the VMA has been recycled, lock_vma_under_rcu()
will then detect the mismatching ->vm_mm pointer and drop the VMA through
vma_end_read(), which calls vma_refcount_put().  vma_refcount_put() drops
the refcount and then calls rcuwait_wake_up() using a copy of vma->vm_mm.
This is wrong: It implicitly assumes that the caller is keeping the VMA's
mm alive, but in this scenario the caller has no relation to the VMA's mm,
so the rcuwait_wake_up() can cause UAF.

The diagram depicting the race:
T1         T2         T3
==         ==         ==
lock_vma_under_rcu
  mas_walk
          <VMA gets removed from mm>
                      mmap
                        <the same VMA is reallocated>
  vma_start_read
    __refcount_inc_not_zero_limited_acquire
                      munmap
                        __vma_enter_locked
                          refcount_add_not_zero
  vma_end_read
    vma_refcount_put
      __refcount_dec_and_test
                          rcuwait_wait_event
                            <finish operation>
      rcuwait_wake_up [UAF]

Note that rcuwait_wait_event() in T3 does not block because refcount was
already dropped by T1.  At this point T3 can exit and free the mm causing
UAF in T1.

To avoid this we move vma->vm_mm verification into vma_start_read() and
grab vma->vm_mm to stabilize it before vma_refcount_put() operation.

[surenb@google.com: v3]
  Link: https://lkml.kernel.org/r/20250729145709.2731370-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250728175355.2282375-1-surenb@google.com
Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmap_lock.h |   30 ++++++++++++++++++++++++++++++
 mm/mmap_lock.c            |    3 +--
 2 files changed, 31 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwai
 #include <linux/tracepoint-defs.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched/mm.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
@@ -154,6 +155,10 @@ static inline void vma_refcount_put(stru
  * reused and attached to a different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
+ *
+ * WARNING! The vma passed to this function cannot be used if the function
+ * fails to lock it because in certain cases RCU lock is dropped and then
+ * reacquired. Once RCU lock is dropped the vma can be concurently freed.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
@@ -183,6 +188,31 @@ static inline struct vm_area_struct *vma
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+
+	/*
+	 * If vma got attached to another mm from under us, that mm is not
+	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
+	 * releasing vma->vm_refcnt.
+	 */
+	if (unlikely(vma->vm_mm != mm)) {
+		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+		struct mm_struct *other_mm = vma->vm_mm;
+
+		/*
+		 * __mmdrop() is a heavy operation and we don't need RCU
+		 * protection here. Release RCU lock during these operations.
+		 * We reinstate the RCU read lock as the caller expects it to
+		 * be held when this function returns even on error.
+		 */
+		rcu_read_unlock();
+		mmgrab(other_mm);
+		vma_refcount_put(vma);
+		mmdrop(other_mm);
+		rcu_read_lock();
+		return NULL;
+	}
+
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -164,8 +164,7 @@ retry:
 	 */
 
 	/* Check if the vma we locked is the right one. */
-	if (unlikely(vma->vm_mm != mm ||
-		     address < vma->vm_start || address >= vma->vm_end))
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();


