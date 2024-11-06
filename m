Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB701E1A25;
	Wed,  6 Nov 2024 13:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898370; cv=none; b=m4NRwhrH7V3CZDcbtn84j+YQ7WOZdna9O29aLiEXHpiaDlXMmfh907JsNHMl6FJi5EPqDRMb720fTf7yGE9Vd15ahcQSSSQZweZ/iw7h9q15byfLFwV8uNnaqllLIObg6gGBrItV9ytTrQOqpB+/6kVkX702c554aJTVd/m18tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898370; c=relaxed/simple;
	bh=ECF473+EcarV+BYH+yR/cs2GfEQX3baQnfnMA8rkxxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql1FyWlU/pgBQmI1BqdL3HbMCTdzclxRLqhJCswNqBPxUpZyDPJ9E65mZh3KydE7oLAXN4VxQhPVQBP5sMlROqkjBNA6TRyuzX96RQCEKDcXkB31l0wmMsvZFme/GbAqCTzAjU8ewtX5v3Tj/tEoZg+LvNia81UszeZaVLIDeeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRmTxcaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRmTxcaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD4CC4CECD;
	Wed,  6 Nov 2024 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898370;
	bh=ECF473+EcarV+BYH+yR/cs2GfEQX3baQnfnMA8rkxxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRmTxcajM5jJHLj3757rFY81BXJgw8X/v9a9NEdcobB9C+5kTRM59IlGx6TxXxt8d
	 +XEVQJPM1s0twWXVMcmRNIL8ZnhgQ0rfgX62x9ZxxB2o5udmM1XR0th0QArwIWGajS
	 A0C1s2IIS55pUvZv5y39AXccRBGU+/7i6hhNVsvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/462] signal: Replace BUG_ON()s
Date: Wed,  6 Nov 2024 13:01:48 +0100
Message-ID: <20241106120336.833340841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7f8af7bac5380f2d95a63a6f19964e22437166e1 ]

These really can be handled gracefully without killing the machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1f4293a107b49..fae5a2adc9ec2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1821,10 +1821,11 @@ struct sigqueue *sigqueue_alloc(void)
 
 void sigqueue_free(struct sigqueue *q)
 {
-	unsigned long flags;
 	spinlock_t *lock = &current->sighand->siglock;
+	unsigned long flags;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	if (WARN_ON_ONCE(!(q->flags & SIGQUEUE_PREALLOC)))
+		return;
 	/*
 	 * We must hold ->siglock while testing q->list
 	 * to serialize with collect_signal() or with
@@ -1852,7 +1853,10 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 	unsigned long flags;
 	int ret, result;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	if (WARN_ON_ONCE(!(q->flags & SIGQUEUE_PREALLOC)))
+		return 0;
+	if (WARN_ON_ONCE(q->info.si_code != SI_TIMER))
+		return 0;
 
 	ret = -1;
 	rcu_read_lock();
@@ -1871,7 +1875,6 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 		 * If an SI_TIMER entry is already queue just increment
 		 * the overrun count.
 		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
 		result = TRACE_SIGNAL_ALREADY_PENDING;
 		goto out;
-- 
2.43.0



