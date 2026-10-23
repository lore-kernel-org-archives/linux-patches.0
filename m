Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774182;
	b=Qiz6LQZySOQfW+/4i5DUEPjmzpQ/9zKcFMpRlse33hAV4fIcvEX390ArmtgtbJ2ZwLjK
	 2GLDlj17ljac/PH0M0EEhRoiFo6H3D4yxsQjgEPhwf+APrSt4+oCXZ5/p5RTtaWG1XMUx
	 YiVZBsPT0eo4BneCFLq5Resrbs5CgMmmu8AlEM/iNqrdC/OKkWzmuDEub4RrI+OiSfh/t
	 xNSYz8lHt+RXDDSbAHecnL/nlP6QRdnNV8GJEsq7rGDqOBaVnv7GjYbQUawIlhSWLDHhk
	 dIu/BN3RiiyrqhBQxhipklvthf/0fbAfQ+O0gDDrpR8Tr5vF9b35XvXZaUanmE2fKCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rR+tEnob+e9FC+kE6myfVso85uC7cXpgxFhhgYKp0tk=;
	b=Bnder5517imy4CDd7PyFanmAc7Nw93Y6j6liE+6/aC5GY3YlmLvOYLgJbzy6tBgdo9nT
	 4TRgIMJfRc6EjQrN22UhG8EaT/nugtW6Nt9TCsMgenlEnk4RCIGgO/qyKqQtWnmhN/+ds
	 4TxEdWMy+8EUysEOYUYJmfqt+HUv+SvSB2q7JDoDPACan2EuYl+8jcF250GPNaJirmcqu
	 v2pzhENMQHgc7e+lr3tP+Hw4HvFovTexah15jL0GwgdcuXk/Sm6j50/CPx+kGrBMsIVwD
	 APqZMY7E2oiYhGNxfjH9CYKUXROPKoxkJruxHdsyCsAfS2mmfLQLgDVVIyDNwmU55PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQFhZSPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315A606A31D;
	Fri, 23 Oct 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yQFhZSPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AEB1F01828;
	Fri, 23 Oct 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774181;
	bh=rR+tEnob+e9FC+kE6myfVso85uC7cXpgxFhhgYKp0tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQFhZSPGcSIGho6xIBKun9E02u711oU7wTBpm9rOrZ6ymTivs1ytIfce+h4a4V+q1
	 lxVJBMo0r7WJRRnuzVOF0ZxcoB1YLXEVET/qraYLiV/V/U+rkpk67hdTMhJqWrblpt
	 VBAAMkvWDsrGOb61RTY1/y+vaWwR/L3pr0blWEnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/193] futex: Fix mm reuse handling for FUT_OFF_MMSHARED
Date: Fri, 23 Oct 2026 18:37:06 +0200
Message-ID: <20261023163717.736835406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted mm->futex.unique_id access to mm->futex_unique_id because struct futex_mm_data is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/futex.h    |   18 ++++++-----
 include/linux/mm_types.h |    3 +
 kernel/futex/core.c      |   75 ++++++++++++++++++++++++++---------------------
 3 files changed, 56 insertions(+), 40 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -23,28 +23,32 @@ struct task_struct;
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
 		/* unsigned int node; */
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
 		/* unsigned int node; */
 	} private;
+
 	struct {
 		u64 ptr;
 		unsigned long word;
@@ -83,15 +87,15 @@ long do_futex(u32 __user *uaddr, int op,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4);
 
+int futex_mm_init(struct mm_struct *mm);
+
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 int futex_hash_allocate_default(void);
 void futex_hash_free(struct mm_struct *mm);
-int futex_mm_init(struct mm_struct *mm);
 
 #else /* !CONFIG_FUTEX_PRIVATE_HASH */
 static inline int futex_hash_allocate_default(void) { return 0; }
 static inline int futex_hash_free(struct mm_struct *mm) { return 0; }
-static inline int futex_mm_init(struct mm_struct *mm) { return 0; }
 #endif /* CONFIG_FUTEX_PRIVATE_HASH */
 
 #else /* !CONFIG_FUTEX */
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1079,6 +1079,9 @@ struct mm_struct {
 		 */
 		seqcount_t mm_lock_seq;
 #endif
+#ifdef CONFIG_FUTEX
+		atomic64_t			futex_unique_id;
+#endif
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 		struct mutex			futex_hash_lock;
 		struct futex_private_hash	__rcu *futex_phash;
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -441,45 +441,51 @@ futex_setup_timer(ktime_t *time, struct
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
-		u64 new = atomic64_inc_return(&i_seq);
+		u64 new = atomic64_inc_return(&last_assigned_seq);
 		if (WARN_ON_ONCE(!new))
 			continue;
 
 		old = 0;
-		if (!atomic64_try_cmpxchg_relaxed(&inode->i_sequence, &old, new))
+		if (!atomic64_try_cmpxchg_relaxed(object_seq, &old, new))
 			return old;
 		return new;
 	}
 }
 
+/*
+ * This relies on the fact that a well formed program will not unmap
+ * the file while it has a (shared) futex waiting on it. This mapping will have
+ * a file reference which pins the mount and inode.
+ *
+ * If for some reason an inode gets evicted and read back in again, it will get
+ * a new sequence number and will _NOT_ match, even though it is the exact same
+ * file.
+ *
+ * It is important that futex_match() will never have a false-positive, esp.
+ * for PI futexes that can mess up the state. The above argues that false-negatives
+ * are only possible for malformed programs.
+ */
+static u64 get_inode_sequence_number(struct inode *inode)
+{
+	return get_object_id(&inode->i_sequence);
+}
+
 /**
  * get_futex_key() - Get parameters which are the keys for a futex
  * @uaddr:	virtual address of the futex
@@ -685,8 +691,8 @@ again:
 			goto out;
 		}
 
-		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
-		key->private.mm = mm;
+		key->both.offset |= FUT_OFF_MMSHARED;
+		key->private.mm_seq = get_object_id(&mm->futex_unique_id);
 		key->private.address = address;
 
 	} else {
@@ -1724,18 +1730,6 @@ static bool futex_ref_is_dead(struct fut
 	return atomic_long_read(&mm->futex_atomic) == 0;
 }
 
-int futex_mm_init(struct mm_struct *mm)
-{
-	mutex_init(&mm->futex_hash_lock);
-	RCU_INIT_POINTER(mm->futex_phash, NULL);
-	mm->futex_phash_new = NULL;
-	/* futex-ref */
-	mm->futex_ref = NULL;
-	atomic_long_set(&mm->futex_atomic, 0);
-	mm->futex_batches = get_state_synchronize_rcu();
-	return 0;
-}
-
 void futex_hash_free(struct mm_struct *mm)
 {
 	struct futex_private_hash *fph;
@@ -1982,6 +1976,21 @@ static int futex_hash_get_slots(void)
 
 #endif
 
+int futex_mm_init(struct mm_struct *mm)
+{
+	atomic64_set(&mm->futex_unique_id, 0);
+#ifdef CONFIG_FUTEX_PRIVATE_HASH
+	mutex_init(&mm->futex_hash_lock);
+	RCU_INIT_POINTER(mm->futex_phash, NULL);
+	mm->futex_phash_new = NULL;
+	/* futex-ref */
+	mm->futex_ref = NULL;
+	atomic_long_set(&mm->futex_atomic, 0);
+	mm->futex_batches = get_state_synchronize_rcu();
+#endif
+	return 0;
+}
+
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4)
 {
 	unsigned int flags = FH_CUSTOM;


