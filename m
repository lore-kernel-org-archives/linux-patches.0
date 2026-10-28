Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210629;
	b=mquxviMR04S7sQE7d546dd5PDpuzmOtOvxoJH0m9TS9+0mPEDcYdiqitiiyy05+BiRJL
	 hY0r0JamzFFeDO6dVKx1ztgC4yV0IYb12e8aHgcQl8BGYuVDI7uAoAHKzU9WClzwnJU7X
	 JntysPt3GMSdxDjy5NJMVQpn9pzlsMgkStM+12ke4jnX+wZEi0f3MRPFBDNd8x+oTmr9o
	 ni3sK8R5XSeJ+/Y51FlvqN/CKuIVa6aE+Qdi7nUoOytYycgo/zBJz8EOSwqLgx+VQJDi/
	 PqCoxPtLA3XUOv3v6Na1vhDiGe3ZsTyxkH6EkoX6OLh5xqZZhp3MVbcSi1+HmJ+NMzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkxYtUVTrAHLKZU1zqSJFwrx8xhefswfAt9+dgUntVQ=;
	b=rQAPIfa925YUe3iEbIfkR4eSjPbihq66FL25g9KruVNHW5e4xLUvS5jcEaVBirRYRr2e
	 g/8XnnzeMrqr3TrbOlRT0at7xiIif4yEI6z4fi/bv54Un9kIVNIabzSMXoo2AgbrFIlRQ
	 CaJPr7idfLjJZPefFJd/8ahpfvA72BSCPHSjPNXqbHTjm400Q7KV/YtT749CsVKTaL9kG
	 UdOClcefp3njQmDGY+DgUpaEvI+Vce6SyyewQHyQoRnM1MhG9D94wKXl7eRZOSh5SHoKK
	 AkABKdDQsdfxQV3vFbqwVZ7J5dqdLXZLvZ+PgY6rQ4PaakuFtLKiMWzL2yLnCrqnmvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zj+xkCAu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD24606A31D;
	Wed, 28 Oct 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zj+xkCAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7CF1F01825;
	Wed, 28 Oct 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210629;
	bh=bkxYtUVTrAHLKZU1zqSJFwrx8xhefswfAt9+dgUntVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zj+xkCAuQdxkG/jG+Na9BevmQBhA9zD8MmrlFWw4Ccv4jSw8JAt3lsqgOrfY6beXj
	 NNIifAEv0HRglXWwR4SLZOzO+l1jXx+FbOmedLD6TiYj5aAVpbioy9y48pRqDACUWf
	 dJ5Lui8E63M20Jf2Dfz09jRc3pf4e+8y5U4kzRWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/571] ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()
Date: Wed, 28 Oct 2026 17:54:01 +0100
Message-ID: <20261028170010.253708148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 815e07c8fe885a87751c2496a30ae0dcd4118210 ]

rb_wake_up_waiters() is a irq_work callback which is initialized with
init_irq_work(). As such it will be invoked in thread context on
PREEMPT_RT. Invoking the callback in IRQ context on PREEMPT_RT is not an
option due its usage of wake_up_all().  Since this callback may run in
thread context, it needs to acquire ring_buffer_per_cpu::reader_lock with
disabling interrupts and may not assume that they are disabled.

Use raw_spinlock_irqsave() to acquire ring_buffer_per_cpu::reader_lock.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260911102152.YEtwkBj9@linutronix.de
Fixes: 68282dd930ea3 ("ring-buffer: Fix resetting of shortest_full")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Replaced scoped_guard() with explicit raw_spin_lock_irqsave()/raw_spin_unlock_irqrestore() calls for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 84f3b0d0bc887..9c43f01fa2c2a 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -877,15 +877,15 @@ static void rb_wake_up_waiters(struct irq_work *work)
 		/* Only cpu_buffer sets the above flags */
 		struct ring_buffer_per_cpu *cpu_buffer =
 			container_of(rbwork, struct ring_buffer_per_cpu, irq_work);
+		unsigned long flags;
 
-		/* Called from interrupt context */
-		raw_spin_lock(&cpu_buffer->reader_lock);
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 		rbwork->wakeup_full = false;
 		rbwork->full_waiters_pending = false;
 
 		/* Waking up all waiters, they will reset the shortest full */
 		cpu_buffer->shortest_full = 0;
-		raw_spin_unlock(&cpu_buffer->reader_lock);
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 		wake_up_all(&rbwork->full_waiters);
 	}
-- 
2.53.0



