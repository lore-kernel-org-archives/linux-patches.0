Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207815;
	b=tQCphphyJsEQjqB12JD5B9prHgL7ARDDY7qb5PxpQByiR/XhHl4moT00XgCJpLMrQZhz
	 cVWohPEzauA2lwMZptJ+2IHDuch1LkW/E3jv9X4uXTrSfXzEvk0hmKZ8z2SPVEYKC6bHK
	 1H+pf0zCp19+5OHHMTTI/y08lEgllgyLQEj2/xuhypFNoC/Bapnz7qRAzhrFC0exx9hZ3
	 hYtnuUbl9sAYrr2kYPdsVPjWsdIbjtLy43avai9rPigB+iKINpUnPgj1Jr06kV6nH0fUa
	 9yP9BSBwtOORcg0fT/Lz5M0UwTuZ92z9pYRh33SgHK/2MbK/hQrHtnABMWZ/q/cvUgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3lvUo8hIANvcvZgQ1ditj9C/4jaf73Wnl3dbI9Z7QM=;
	b=qQu73H5LZl2uzAvR/K14zjYG5ba7YMvjDfgw1TSfirsz/W2FEmOOigJ+Iqzfat4RvCbJ
	 RGTMkwLU1IC4Ll/iRFPJn0Spq8TcYFbC3GGUTYXvK9ot+1N+mGbOEGafEUA9lG+gNN9S0
	 Dfs9HhVsSftnidXZp/+6qcpsrDvC1LaYAcljVq8V50EecHTrHOxxW0KyMy26Nnddi4JND
	 vhziSq8DxFJC5Q04RFs3NiqVIR2hetC334fhBuZGWQxqK5UO+qofYROCXw0NyQ3GtmCkI
	 KdTSWObRKqKRg0X7OdNtOTIVU3ouX84+Lw+KqF2gwLmOf2/IYdgAlv+7wL9D+8kwwWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmr8Hak2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684AC606A31F;
	Wed, 28 Oct 2026 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmr8Hak2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F6F1F031E3;
	Wed, 28 Oct 2026 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207815;
	bh=X3lvUo8hIANvcvZgQ1ditj9C/4jaf73Wnl3dbI9Z7QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmr8Hak2d9weE9bA2DH45yWnkwfuJwiDF4Z1eo0xQs+iuObwxnmh3wPHqLnAMLV+y
	 rXbL9hiFTnHjCst8oxNphOy+sY2hY/jojx6klCaR3wQx+BvdoXFyyGh/zJLKfizfbG
	 WwjSF/BQKWm+zNRkjGb9tb+uaYhmf3++nUwYDGk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/247] futex: Fix mm reuse handling for FUT_OFF_MMSHARED
Date: Wed, 28 Oct 2026 17:59:12 +0100
Message-ID: <20261028165950.940884410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced futex_mm_data infrastructure with a direct mm_struct field initialized in mm_init(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/futex.h    | 14 +++++++-----
 include/linux/mm_types.h |  3 +++
 kernel/fork.c            |  3 +++
 kernel/futex/core.c      | 47 ++++++++++++++++++++--------------------
 4 files changed, 39 insertions(+), 28 deletions(-)

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
index f9a280a27e5ca..3deb3f1d5ad26 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -945,6 +945,9 @@ struct mm_struct {
 		 */
 		seqcount_t mm_lock_seq;
 #endif
+#ifdef CONFIG_FUTEX
+		atomic64_t futex_unique_id;
+#endif
 
 
 		unsigned long hiwater_rss; /* High-watermark of RSS usage */
diff --git a/kernel/fork.c b/kernel/fork.c
index c0ecb097aa1d2..81a8a7d3a5bd3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1304,6 +1304,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 #endif
 	mm_init_uprobes_state(mm);
 	hugetlb_count_init(mm);
+#ifdef CONFIG_FUTEX
+	atomic64_set(&mm->futex_unique_id, 0);
+#endif
 
 	if (current->mm) {
 		mm->flags = mmf_init_flags(current->mm->flags);
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index c37d2263c21fe..fa6ea7e235b13 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -153,39 +153,27 @@ futex_setup_timer(ktime_t *time, struct hrtimer_sleeper *timeout,
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
@@ -208,7 +196,7 @@ static u64 get_inode_sequence_number(struct inode *inode)
  *
  *   ( inode->i_sequence, page->index, offset_within_page )
  *
- * [ also see get_inode_sequence_number() ]
+ * [ also see get_object_id() ]
  *
  * For private mappings (or when !@fshared), the key is:
  *
@@ -362,8 +350,8 @@ int get_futex_key(u32 __user *uaddr, unsigned int flags, union futex_key *key,
 			goto out;
 		}
 
-		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
-		key->private.mm = mm;
+		key->both.offset |= FUT_OFF_MMSHARED;
+		key->private.mm_seq = get_object_id(&mm->futex_unique_id);
 		key->private.address = address;
 
 	} else {
@@ -398,7 +386,20 @@ int get_futex_key(u32 __user *uaddr, unsigned int flags, union futex_key *key,
 		}
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.i_seq = get_inode_sequence_number(inode);
+		/*
+		 * This relies on the fact that a well formed program will not unmap
+		 * the file while it has a (shared) futex waiting on it. This mapping will have
+		 * a file reference which pins the mount and inode.
+		 *
+		 * If for some reason an inode gets evicted and read back in again, it will get
+		 * a new sequence number and will _NOT_ match, even though it is the exact same
+		 * file.
+		 *
+		 * It is important that futex_match() will never have a false-positive, esp.
+		 * for PI futexes that can mess up the state. The above argues that false-negatives
+		 * are only possible for malformed programs.
+		 */
+		key->shared.i_seq = get_object_id(&inode->i_sequence);
 		key->shared.pgoff = folio->index + folio_page_idx(folio, page);
 		rcu_read_unlock();
 	}
-- 
2.53.0



