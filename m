Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217237;
	b=0tSKjEWjUEKfH7kER5QMf+GFrMTGTmi9kqahfcs6JOmoGMKXBigydNee4K/oKvpaFLSj
	 7lV2czJesH//0u9eH+jhlmo6R41L878Lf34tS33jaCpRtIW8YfjLmI/uG4iVgyijrCgMJ
	 YtA8UGrXE+YesWRrxfOfbfMP+iIB/iA1RY06pxzoIpkRwj5yj7ZL3YY/7BWV2B1ekh5uE
	 EU+HwLRdHGtBbMg/GLke8IrBJgH2bP0irCpMSINknz+U+EDTfAVgsoyILP+e9qngyVXA7
	 C3sMLM9BeFX06DMNMl1ONhg40Y6URKGzR824+P7Zry20vbP3yMclFHNkqU8l14kjZqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j9+GIRreMTdNuk9ljPi6e1hvE4qsVqkqLihn2x/5PNM=;
	b=EY7nu4wTXXLxgJoD2vWJju6A9muxixVbMbFsYFYz5WBNV7THGCqDOzZJEQQKEQ7Cr4QX
	 4+N6RL5GtqfcjgK8O8A0DL/fCMbr86GWSM7fpVbQkfxIeEg3sYJ5E4P46F4PFoKUB4xHh
	 qxl/wdI3prUgovEACLU01Li3CZiZLfkVQkhL5HwetX5XOUMKcydqxKcfT7q1yZJq8H0Rm
	 dHNQyhVmgo4kkGpCOro3v8x1pzWVPHkzg5R+Ya19rOLVpVh7Pd7CoQZ95smNbtwWqkQj+
	 gJR63bQl+aPxJIBuQ+bvSC//XS7IGYjzpnRY3T1Va9SJ79E1UXMxwrtHxe4w4p2q+eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS1+n2aP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37187606A31A;
	Wed, 28 Oct 2026 19:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DS1+n2aP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B01F01825;
	Wed, 28 Oct 2026 19:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217236;
	bh=j9+GIRreMTdNuk9ljPi6e1hvE4qsVqkqLihn2x/5PNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DS1+n2aPuifYOq9paynKTdnWDIJxNxCHdzsnkyto/fOyH+UrtwoKmUsmKNjo6iozL
	 5FYuI/7MojvkFy7xoS0Lfz3SvWWplvAmGKkJH8vvL8ouGUN+i70wCSCnKoWRohAVCv
	 bgAeosWLgV9v9dqP9xv6McbzS5B2MiFzndh4VBmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1789/1887] futex: Fix mm reuse handling for FUT_OFF_MMSHARED
Date: Wed, 28 Oct 2026 18:04:45 +0100
Message-ID: <20261028170540.161697220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 3267512ad1c2cc0c7768c5b014dc2cceb398a801 ]

A FUT_OFF_MMSHARED futex is a shared futex that refers to an MM.
It is possible for a process to wait on a shared futex with a different MM
because a FUT_OFF_INODE waiter can be requeued onto a FUT_OFF_MMSHARED
futex by another process.
This can cause FUT_OFF_MMSHARED waiters on a freed MM to consume
wakeups intended for a newly allocated MM at the same address.

Fix it by keying FUT_OFF_MMSHARED using a unique 64-bit per-MM ID.
Leave private futexes as before to avoid influencing the performance of the
hotpath.

(Multi-threaded processes typically implicitly use FUT_OFF_MMSHARED by
setting clear_child_tid such that it points into anonymous memory, which
causes mm_release() in a multi-threaded mm to perform FUTEX_WAKE.)

Fixes: 222993395ed3 ("futex: Remove pointless mmgrap() + mmdrop()")
Closes: https://lore.kernel.org/r/CAG48ez0dLBpc3QtbAhMMVNHwHL94iHh2G+h-=BVFR4dDuzZr1g@mail.gmail.com/
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260929-futex-mmshared-fix-v1-1-262b1ffeb3d0@google.com
Cc: stable@vger.kernel.org
[ sashal: adapted per-MM ID handling to use mm_struct and mm_init() directly because the newer futex infrastructure is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/futex.h    | 14 ++++++++----
 include/linux/mm_types.h |  3 +++
 kernel/fork.c            |  3 +++
 kernel/futex/core.c      | 49 +++++++++++++++++++++-------------------
 4 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index b70df27d7e85c..09f757f14d01f 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -23,26 +23,30 @@ struct task_struct;
  *  01 : Shared futex (PTHREAD_PROCESS_SHARED)
  *	mapped on a file (reference on the underlying inode)
  *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
- *       (but private mapping on an mm, and reference taken on it)
+ *       (but private mapping on an mm)
 */
 
-#define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on inode */
-#define FUT_OFF_MMSHARED 2 /* We set bit 1 if key has a reference on mm */
+#define FUT_OFF_INODE    1 /* We set bit 0 if shared key identifies an inode */
+#define FUT_OFF_MMSHARED 2 /* We set bit 1 if shared key identifies an mm */
 
 union futex_key {
+	/* For FUT_OFF_INODE */
 	struct {
 		u64 i_seq;
 		unsigned long pgoff;
 		unsigned int offset;
 	} shared;
+
+	/* For FUT_OFF_MMSHARED or private */
 	struct {
 		union {
-			struct mm_struct *mm;
-			u64 __tmp;
+			struct mm_struct *mm; /* for private */
+			u64 mm_seq; /* for FUT_OFF_MMSHARED */
 		};
 		unsigned long address;
 		unsigned int offset;
 	} private;
+
 	struct {
 		u64 ptr;
 		unsigned long word;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d1a370add9bc8..690e0ea004a58 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -602,6 +602,9 @@ struct mm_struct {
 					  * by mmlist_lock
 					  */
 
+#ifdef CONFIG_FUTEX
+		atomic64_t futex_unique_id;
+#endif
 
 		unsigned long hiwater_rss; /* High-watermark of RSS usage */
 		unsigned long hiwater_vm;  /* High-water virtual memory usage */
diff --git a/kernel/fork.c b/kernel/fork.c
index 1a480f30ca985..37c5d6123cf62 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1159,6 +1159,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 #endif
 	mm_init_uprobes_state(mm);
 	hugetlb_count_init(mm);
+#ifdef CONFIG_FUTEX
+	atomic64_set(&mm->futex_unique_id, 0);
+#endif
 
 	if (current->mm) {
 		mm->flags = current->mm->flags & MMF_INIT_MASK;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index b370fdea7c217..5944e57285063 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -151,39 +151,27 @@ futex_setup_timer(ktime_t *time, struct hrtimer_sleeper *timeout,
 }
 
 /*
- * Generate a machine wide unique identifier for this inode.
+ * Generate a machine wide unique identifier for this object (inode or mm).
  *
  * This relies on u64 not wrapping in the life-time of the machine; which with
  * 1ns resolution means almost 585 years.
- *
- * This further relies on the fact that a well formed program will not unmap
- * the file while it has a (shared) futex waiting on it. This mapping will have
- * a file reference which pins the mount and inode.
- *
- * If for some reason an inode gets evicted and read back in again, it will get
- * a new sequence number and will _NOT_ match, even though it is the exact same
- * file.
- *
- * It is important that futex_match() will never have a false-positive, esp.
- * for PI futexes that can mess up the state. The above argues that false-negatives
- * are only possible for malformed programs.
  */
-static u64 get_inode_sequence_number(struct inode *inode)
+static u64 get_object_id(atomic64_t *object_seq)
 {
-	static atomic64_t i_seq;
+	static atomic64_t last_assigned_seq;
 	u64 old;
 
-	/* Does the inode already have a sequence number? */
-	old = atomic64_read(&inode->i_sequence);
+	/* Does the object already have a sequence number? */
+	old = atomic64_read(object_seq);
 	if (likely(old))
 		return old;
 
 	for (;;) {
-		u64 new = atomic64_add_return(1, &i_seq);
+		u64 new = atomic64_add_return(1, &last_assigned_seq);
 		if (WARN_ON_ONCE(!new))
 			continue;
 
-		old = atomic64_cmpxchg_relaxed(&inode->i_sequence, 0, new);
+		old = atomic64_cmpxchg_relaxed(object_seq, 0, new);
 		if (old)
 			return old;
 		return new;
@@ -206,7 +194,7 @@ static u64 get_inode_sequence_number(struct inode *inode)
  *
  *   ( inode->i_sequence, page->index, offset_within_page )
  *
- * [ also see get_inode_sequence_number() ]
+ * [ also see get_object_id() ]
  *
  * For private mappings (or when !@fshared), the key is:
  *
@@ -358,8 +346,8 @@ int get_futex_key(u32 __user *uaddr, bool fshared, union futex_key *key,
 			goto out;
 		}
 
-		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
-		key->private.mm = mm;
+		key->both.offset |= FUT_OFF_MMSHARED;
+		key->private.mm_seq = get_object_id(&mm->futex_unique_id);
 		key->private.address = address;
 
 	} else {
@@ -394,7 +382,22 @@ int get_futex_key(u32 __user *uaddr, bool fshared, union futex_key *key,
 		}
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.i_seq = get_inode_sequence_number(inode);
+		/*
+		 * This relies on the fact that a well formed program will not
+		 * unmap the file while it has a (shared) futex waiting on it.
+		 * This mapping will have a file reference which pins the mount
+		 * and inode.
+		 *
+		 * If for some reason an inode gets evicted and read back in
+		 * again, it will get a new sequence number and will _NOT_ match,
+		 * even though it is the exact same file.
+		 *
+		 * It is important that futex_match() will never have a
+		 * false-positive, esp. for PI futexes that can mess up the state.
+		 * The above argues that false-negatives are only possible for
+		 * malformed programs.
+		 */
+		key->shared.i_seq = get_object_id(&inode->i_sequence);
 		key->shared.pgoff = page_to_pgoff(tail);
 		rcu_read_unlock();
 	}
-- 
2.53.0



