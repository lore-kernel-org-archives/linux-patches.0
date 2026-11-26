Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705209;
	b=puTDzh2E8QhyTA29/esjIhJPEK1C9JVdilqCW+gvETtRxd00FEG408dRLkwrkGYS8499
	 r64KlcyzyF0SbzU8SGPsjZIhwoOjezuyMTMJiHhDKhfHHBy+0tW6NO0j59KGOQgXs6TO2
	 DHpYWA3Lgdag3WaUDcOV3meIKGaqk/qdDndOEScZGbOFzQxRNXzVr3pz32xVH+E8Npu2U
	 5LuG9vBsbr6/E3OeOCKEicWLtS/5NITozJwRiVUlgrjau2gr79ZYxgUv4xqXTwmqN6fb4
	 nnruUy/t/UvzV50LG6GQN6Kl33oqAs/vwDlfmMh/ayGUfZduXxxjFk2IwtmDm/TDAUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbL4L/CBhUSYaiNcX93/L/+/IQd1xuJc4ObNN7y8mfQ=;
	b=zIRt+coqunsLMUjLukB1/8322baoANI6Y8n/ZHNku7heWCZmIHfXiTWF46IHe9nEJR9R
	 tvti0LzE5SzfQpqxD3Ymh1QseV8bhB7/PnWPNVJZGymvADQsXnqIPSM9Lk+cZUHTWXoYP
	 eOayBMEaAH0CUTb3xYvyRT0Y+SZP8yuQqRHM2AvlZL8V88S0el073x5ConncpF/pIv1k8
	 5yYIkngBD+o1kGp+LfZw8e/lHbfTL0sv9ldflAgFtrOLV9hU65kGFK5TlF2f0cJZV1wjJ
	 EL1xewo94cK9fl5Pq+zS9VYhJGeDtSI4bpJTU0EtiU72khcsVAUhEBj5Y9DuxYeAobQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEb3ZVC8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA268606A33C;
	Thu, 26 Nov 2026 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEb3ZVC8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175F21F000CF;
	Thu, 26 Nov 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705209;
	bh=hbL4L/CBhUSYaiNcX93/L/+/IQd1xuJc4ObNN7y8mfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEb3ZVC8HGMtB38iKnDTcWesRs/5Qln2bb/z1Ty1U1p+DF19wKtwa8uG9L8Cg7YPA
	 ZkLvyCxaJj5kZ93bUTvHup4z/NZPPzKD/dAB9UPIQXJrzbM65i/olHdAuDUYOl1nqB
	 hta/xRRs0EgNq8YjK8gBYtZoWbmtlWOUsh+ZVNhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/319] locking/osq_lock: Clarify osq_wait_next() calling convention
Date: Thu, 26 Nov 2026 15:38:07 +0100
Message-ID: <20261126144009.432108512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d5610ad52b92b..ebb1493915ce9 100644
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



