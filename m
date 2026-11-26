Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704500;
	b=WJjrQOc4SuZjShuz5jZH1mVT04/kpKQEg79QgOePPztlOjoL+tb6T7PNIty7khyU12jV
	 y34EQ6ltbqltpw/DfX47S1Wg6LSjPM00hCMYn+TfGR/TaHr2f7pdIkhrI7PIFZ3g7lHCL
	 o043NgXudIzNaT5jFhQZShc2osrhFC8cOtPtjzPBAFWMAvE+v3zC+MjVcUpT252nrfv3A
	 kn4dWWeIAIjVoUSwle2hAL9PJ+pHAk1Lb3Pbib4kTXMMAmQkY03sgOyw8b9mCyy58y5vQ
	 yUnvBOBykd0DdPzXmXpFkIqD4HgCcEcNvR/SU/Wbqq4JKAd/hm/JdrvW2d1lXXBQIVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mRlj0eemdJjT7QY95MPdf2bf3I8qNHovkJlT2hSxC90=;
	b=T1nVCASvv/oALpXMVb5kSyG0/9x5GpMCoUi6wGCQzBcymfUMeDMCd5Hy6i/D3g0NDbTa
	 t0Lg3UHd45ln1EJiSjpmcBekbBXKlm9bOnaZV/ccDhpKL2xPGO4lQ9YHH9S0Z3S6cFFNO
	 nEbQ2TzH5+Eu/4V1jzPrBb8njmawH0KMPQcxgfdIMXRWPn5fbAwDYvBTzJ64snaREoit3
	 SkoNbpsszRvkQh34cY2DpTe9LjGNcuvPDae3CReFlvApmEI1MevtHTK40Wch6BF1m2vQX
	 CF77OdzaMafKtfBUZb1nLFLI46Z9/VtFird0iWt/sziJayls/YVSSsxyn2ppqnxFwrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A++EneYb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF259606A31E;
	Thu, 26 Nov 2026 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A++EneYb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7FF1F000D4;
	Thu, 26 Nov 2026 14:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704499;
	bh=mRlj0eemdJjT7QY95MPdf2bf3I8qNHovkJlT2hSxC90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A++EneYb9SLvGLH4liAkQf0uZBr+JT/ComgmIGkTWuXy+Zd6L74qOu2mMo2KEFsrF
	 9JMOcH9mPbedAVVKsJWYO221aqtHyRyGaSmK7WconLEb57D1aTwatWLuogjbvDYG91
	 q/LZmy27nREftad7ONpPzcJYabWFxK2AiL7hi7kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/265] locking/osq: Fix unlink queue corruption
Date: Thu, 26 Nov 2026 15:37:11 +0100
Message-ID: <20261126143612.064241579@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 408b129aac48b574c0c9d11137a89eefba825d5d ]

Very similar to commit 50972fe78f24 ("locking/osq_lock: Fix osq_lock
queue corruption"), make sure to order the prev->next store against
the next->prev store.

Fixes: 50972fe78f24 ("locking/osq_lock: Fix osq_lock queue corruption")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 60 +++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index aded61b363d0f..59a3bcc1ae8c4 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -84,6 +84,49 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 	return next;
 }
 
+/*
+ * Set prev->next; this is the counterpart of osq_wait_next() in that
+ * by setting ->next the wait is terminated and progress is resumed.
+ */
+static inline void osq_link_next(struct optimistic_spin_node *prev,
+				 struct optimistic_spin_node *next)
+{
+	/*
+	 * Suppose:
+	 *
+	 *                   tail
+	 *                    |
+	 *                    V
+	 *   CPU1 -> CPU2 -> CPU3:
+	 *   n: 2    n: 3    n: nil
+	 *   p: nil  p: 1    p: 2
+	 *
+	 * And this is CPU2 doing the self-unqueue concurrent against CPU1s
+	 * unlock()/unqueue(). Since 'prev->next == NULL' and CPU1 will be
+	 * stuck in osq_wait_next() until the below store of 'prev->next'.
+	 *
+	 * CPU2				CPU1
+	 *
+	 * next->prev = prev;		osq_wait_next()
+	 * WMB				MB
+	 * prev->next = next;		next->prev = prev
+	 *
+	 * Without the WMB it would be possible to have conflicting stores
+	 * like:
+	 *
+	 * CPU2				CPU1
+	 *
+	 * prev->next = next // CPU1.n = 3
+	 *				next = osq_wait_next() // = 3
+	 *				next->prev = prev // CPU3.p = nil
+	 * next->prev = prev // CPU3.p = 1
+	 *
+	 * Which would result in list corruption.
+	 */
+	smp_wmb();
+	WRITE_ONCE(prev->next, next);
+}
+
 bool osq_lock(struct optimistic_spin_queue *lock)
 {
 	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
@@ -107,20 +150,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 
 	prev = decode_cpu(old);
 	node->prev = prev;
-
-	/*
-	 * osq_lock()			unqueue
-	 *
-	 * node->prev = prev		osq_wait_next()
-	 * WMB				MB
-	 * prev->next = node		next->prev = prev // unqueue-C
-	 *
-	 * Here 'node->prev' and 'next->prev' are the same variable and we need
-	 * to ensure these stores happen in-order to avoid corrupting the list.
-	 */
-	smp_wmb();
-
-	WRITE_ONCE(prev->next, node);
+	osq_link_next(prev, node);
 
 	/*
 	 * Normally @prev is untouchable after the above store; because at that
@@ -196,7 +226,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 	 */
 
 	WRITE_ONCE(next->prev, prev);
-	WRITE_ONCE(prev->next, next);
+	osq_link_next(prev, next);
 
 	return false;
 }
-- 
2.53.0



