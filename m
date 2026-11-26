Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705216;
	b=E6rCSVhP0Mof75x+wTi3ebmYEAogRNe2nwc/zVBXNhlb+G/Np8Cm8N13glaXnP7s6+qk
	 327Rdj4YKs27Af3NtCsRRHtxYW+mL91WOR7xVz9quNYoiVRscZA3xtAWjZDm3hMHP8IQa
	 IPiIHq60V06V3Qr5WCU3S384oZVd+rcJQJaK/xiOWLAWtfH9ibbd+PUJ6MwfW8m21h/Ej
	 BRG5d75xpZgJGqmqJCuSAGwo45kek13xdSSRnrGBai30MMhER06N+u7x06G8umHLawOxD
	 kcM0v1CaYS8sNQzewC5l2Tnw/odJsntviH+Mf3EgIO3b2RMmGIchuDDaodlXhs0zdJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VdEPB+02aLkFWW0T4BgvH8SvpGAjip/GZNhuh8ecV2M=;
	b=iwvqI/GVHgzDMTbTcQLNbeILxmEz+J3GujBkmvQS373y710+vlbVg3nHflxKlay8AUMS
	 aN/RQtwizWF1sFUuECURgqo/CNY7l2wzZPovuWnTMTXfbCR1Hk6sOAmzRuK9EhVov5OiY
	 wBtY1TdqTYj6dVTSsIRy7mkbm1X8EUmyDNXiqABh2aa1SsDSgkPaQYqRWWTw6Hld+P1S2
	 WLOM0n06Sz2psx7883+XS1GGTKusFzdRwyhZRbMRIrbi7EH8VGSu0+iucywqJSfqNwLt5
	 60a65HDm30lzjzr/Vyx2UEyDEliRxIyBtPEzatLfZ68v+ZpZAaqWDH3mTW65pXkOGPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C25039wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FC9606A339;
	Thu, 26 Nov 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C25039wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314651F000CA;
	Thu, 26 Nov 2026 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705215;
	bh=VdEPB+02aLkFWW0T4BgvH8SvpGAjip/GZNhuh8ecV2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C25039wrZfPph4UjTuGtWYu0klcTKhXjWyAfmkJsWUnb1b+3oRvGUeJIBCU2aUg+y
	 gPXqtAZu/FX3sjgrvuG2jjMFR/fLcKm48dPfjGBDZaNAJ+/YR327BpvmguQRHm3hD2
	 Uwz1iSxXVWmYnJ44JlwDAQOGJ1JUS5eW+vfMSu6Q=
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
Subject: [PATCH 5.15 121/319] locking/osq: Fix unlink queue corruption
Date: Thu, 26 Nov 2026 15:38:09 +0100
Message-ID: <20261126144009.477195070@linuxfoundation.org>
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
index b3748ed287ebb..29597052f442c 100644
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



