Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704493;
	b=IF1IC91vOozMsUh61qn9PYevTMwmg2WdHBAp2oGDPZyDJZS7vr285fXc0h3c9I7DVzJp
	 ju++UrWarGwAVOuyAwtBM4U7h3bwj0J9y7Ie9rOYPPFT38yUfHZUdEd5z024EFkFxYL6Q
	 3e92ABGLgdsZWNCHOc/tJ2qVraz3kEi2mBROI9sKJzwZBDEv+bKjh6FJUEQbyNURcKBue
	 g9ptiEVrlVdesmtspAFGDmjUo+rg6MjfyTR3TxHgGlLDH7/hge+IvvaJAXyP2vhB1nEwA
	 Vr/ZEZ3riAMKq2p7W61QNV43JXTpf8wZdCgQV0dp2ovtzWz2S2vRaen5DAF/XezFNAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/qmJt9pmhpZjdBLAmI4pz0FJTvRy4z8imcrmdQHH+oM=;
	b=1GxkGDIjEcrr2ZnDQVPxXK652vyVt9XldRgcUQfCdTFyxkzpw7k+JDgHzFPI6vcEjn81
	 hoWFkbvbNileVJ2WLZPNQHJvLtuPkJCssaErgJhn8IhYtBr5gP7Likn6rPsslI1c9VA21
	 k8Sbzt3XKa2USD04+7zsEisRdOBAQkLtJsRlulCcrXbCx1A/uGbFpE7Fb0ynqiamgPDDD
	 YwGgvIbNgHrIh4EYixjulf2t9UlwKPKTXJ57EKnCzaNzJiQ8IBxGe+HDbcPKlAdKVjAv3
	 Q9pxlLeb3ztGBYhfIGImvC1aLzcbv+X0hAyH1ctT5PU7koOwOgKbFsyblBQMrn9U7Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV3Wev9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC201606A31C;
	Thu, 26 Nov 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV3Wev9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9891F000C6;
	Thu, 26 Nov 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704493;
	bh=/qmJt9pmhpZjdBLAmI4pz0FJTvRy4z8imcrmdQHH+oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qV3Wev9+jdRSSBNci60vHYZFY0cWEbwKQccx5hAhIi6XapZeTzT62t6rRUH3C5iQ1
	 n5i2N7i417nnlmwiatAJQ+gqZSIkHjrupdHwP9fFtfo2o09znYs+ieivsmMR9rDlet
	 m2+hYQH1HBU7XxSxKVZlhkqr1ExebBED7WkljuOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/265] locking/osq_lock: Clarify osq_wait_next() calling convention
Date: Thu, 26 Nov 2026 15:37:09 +0100
Message-ID: <20261126143611.911831708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 563adbfc351b2af9f1406b809ba60b9f1673a882 ]

osq_wait_next() is passed 'prev' from osq_lock() and NULL from
osq_unlock() but only needs the 'cpu' value to write to lock->tail.

Just pass prev->cpu or OSQ_UNLOCKED_VAL instead.

Should have no effect on the generated code since gcc manages to assume
that 'prev != NULL' due to an earlier dereference.

Signed-off-by: David Laight <david.laight@aculab.com>
[ Changed 'old' to 'old_cpu' by request from Waiman Long  - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 1b9e01fcc47a ("locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 1de006ed3aa8c..6772f35c078c5 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -37,26 +37,23 @@ static inline struct optimistic_spin_node *decode_cpu(int encoded_cpu_val)
 /*
  * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
  * Can return NULL in case we were the last queued and we updated @lock instead.
+ *
+ * If osq_lock() is being cancelled there must be a previous node
+ * and 'old_cpu' is its CPU #.
+ * For osq_unlock() there is never a previous node and old_cpu is
+ * set to OSQ_UNLOCKED_VAL.
  */
 static inline struct optimistic_spin_node *
 osq_wait_next(struct optimistic_spin_queue *lock,
 	      struct optimistic_spin_node *node,
-	      struct optimistic_spin_node *prev)
+	      int old_cpu)
 {
 	struct optimistic_spin_node *next = NULL;
 	int curr = encode_cpu(smp_processor_id());
-	int old;
-
-	/*
-	 * If there is a prev node in queue, then the 'old' value will be
-	 * the prev node's CPU #, else it's set to OSQ_UNLOCKED_VAL since if
-	 * we're currently last in queue, then the queue will then become empty.
-	 */
-	old = prev ? prev->cpu : OSQ_UNLOCKED_VAL;
 
 	for (;;) {
 		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg_acquire(&lock->tail, curr, old) == curr) {
+		    atomic_cmpxchg_acquire(&lock->tail, curr, old_cpu) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
@@ -186,7 +183,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 	 * back to @prev.
 	 */
 
-	next = osq_wait_next(lock, node, prev);
+	next = osq_wait_next(lock, node, prev->cpu);
 	if (!next)
 		return false;
 
@@ -226,7 +223,7 @@ void osq_unlock(struct optimistic_spin_queue *lock)
 		return;
 	}
 
-	next = osq_wait_next(lock, node, NULL);
+	next = osq_wait_next(lock, node, OSQ_UNLOCKED_VAL);
 	if (next)
 		WRITE_ONCE(next->locked, 1);
 }
-- 
2.53.0



