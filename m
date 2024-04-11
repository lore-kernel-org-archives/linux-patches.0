Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A4145353;
	Thu, 11 Apr 2024 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830629; cv=none; b=TzaYu8r7AaYk0uuUedy2LSUqZPelk/YhWAwovYrbYQwmvhkeBB/2hzOiF7TLLge3bR2KZ7xr2rE2IhGXNUWtTsGabEqYReHsoi2JWP+CHRXB7xk7excBSGAu575XX2NUMBvMaAmj6sRoTe3zh9DbLjTBGtfIRguYsihaNbBTX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830629; c=relaxed/simple;
	bh=nGeBabdMIOcdtX4xCxR32GUOqv26NO4i5h5SyhtxRZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASzfPtiK163irwSDcuUJI4R5ueePCehBPlN1snt6Uqv9FhR2xEtansd9o4FxfdgEgYVf+ichggp4MzzrXwnrW45nPtu/Dod7jWj3KP4yjDNPiY/PwpOlIGpofZZyeTm9fHKHkwVhNcDxkj/K+Ui6yhNS14/tNMk5+MH0Qpq7tO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=up82PH3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="up82PH3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810F0C43394;
	Thu, 11 Apr 2024 10:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830629;
	bh=nGeBabdMIOcdtX4xCxR32GUOqv26NO4i5h5SyhtxRZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up82PH3iRPM1OGawsSEdYd85x6oLtKT7kO5rATaGSsJkf54ZtItjnJ5By2rYsiR8E
	 dFPOSmIm8i2DsRT494vtrAyNhdpLo1wY7JZMjrDarH0FJjtrMNbWvFzXOwxwGL1oPv
	 ijm71QFua5z0RgGxTp9YasgzDZ3Icd8d3BRNmC6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linke li <lilinke99@qq.com>,
	Rabin Vincent <rabin@rab.in>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/215] ring-buffer: Fix resetting of shortest_full
Date: Thu, 11 Apr 2024 11:54:31 +0200
Message-ID: <20240411095426.760704706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 68282dd930ea38b068ce2c109d12405f40df3f93 ]

The "shortest_full" variable is used to keep track of the waiter that is
waiting for the smallest amount on the ring buffer before being woken up.
When a tasks waits on the ring buffer, it passes in a "full" value that is
a percentage. 0 means wake up on any data. 1-100 means wake up from 1% to
100% full buffer.

As all waiters are on the same wait queue, the wake up happens for the
waiter with the smallest percentage.

The problem is that the smallest_full on the cpu_buffer that stores the
smallest amount doesn't get reset when all the waiters are woken up. It
does get reset when the ring buffer is reset (echo > /sys/kernel/tracing/trace).

This means that tasks may be woken up more often then when they want to
be. Instead, have the shortest_full field get reset just before waking up
all the tasks. If the tasks wait again, they will update the shortest_full
before sleeping.

Also add locking around setting of shortest_full in the poll logic, and
change "work" to "rbwork" to match the variable name for rb_irq_work
structures that are used in other places.

Link: https://lore.kernel.org/linux-trace-kernel/20240308202431.948914369@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linke li <lilinke99@qq.com>
Cc: Rabin Vincent <rabin@rab.in>
Fixes: 2c2b0a78b3739 ("ring-buffer: Add percentage of ring buffer full to wake up reader")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 8145f1c35fa6 ("ring-buffer: Fix full_waiters_pending in poll")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ed505c6de7cae..a9c90088af780 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -601,8 +601,19 @@ static void rb_wake_up_waiters(struct irq_work *work)
 
 	wake_up_all(&rbwork->waiters);
 	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
+		/* Only cpu_buffer sets the above flags */
+		struct ring_buffer_per_cpu *cpu_buffer =
+			container_of(rbwork, struct ring_buffer_per_cpu, irq_work);
+
+		/* Called from interrupt context */
+		raw_spin_lock(&cpu_buffer->reader_lock);
 		rbwork->wakeup_full = false;
 		rbwork->full_waiters_pending = false;
+
+		/* Waking up all waiters, they will reset the shortest full */
+		cpu_buffer->shortest_full = 0;
+		raw_spin_unlock(&cpu_buffer->reader_lock);
+
 		wake_up_all(&rbwork->full_waiters);
 	}
 }
@@ -731,28 +742,33 @@ __poll_t ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	struct rb_irq_work *work;
+	struct rb_irq_work *rbwork;
 
 	if (cpu == RING_BUFFER_ALL_CPUS) {
-		work = &buffer->irq_work;
+		rbwork = &buffer->irq_work;
 		full = 0;
 	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return EPOLLERR;
 
 		cpu_buffer = buffer->buffers[cpu];
-		work = &cpu_buffer->irq_work;
+		rbwork = &cpu_buffer->irq_work;
 	}
 
 	if (full) {
-		poll_wait(filp, &work->full_waiters, poll_table);
-		work->full_waiters_pending = true;
+		unsigned long flags;
+
+		poll_wait(filp, &rbwork->full_waiters, poll_table);
+
+		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		rbwork->full_waiters_pending = true;
 		if (!cpu_buffer->shortest_full ||
 		    cpu_buffer->shortest_full > full)
 			cpu_buffer->shortest_full = full;
+		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 	} else {
-		poll_wait(filp, &work->waiters, poll_table);
-		work->waiters_pending = true;
+		poll_wait(filp, &rbwork->waiters, poll_table);
+		rbwork->waiters_pending = true;
 	}
 
 	/*
-- 
2.43.0



