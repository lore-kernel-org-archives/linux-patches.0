Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491DE1C0DE7;
	Mon,  1 Apr 2024 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990927; cv=none; b=ZRo/+lcgMgLAFUanQd+ph1UfsGRE/SjMTCs0eVPmvgoXg4RT+7fTbyPfnQQiRjnxQBWbu3s9EI1UbLvSKpUgG6OF/VjYgJIibKHbbXe4NGV3kA8I+HMJBX+xQju6IxjexsMU725UsoaCdI7Pe5MKunsthA5x2KyBlsxE3vngJdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990927; c=relaxed/simple;
	bh=yH7WQOiDbGN5mo7Qo0DrtB3dweHmvlsMZ6j+SR2jTvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paxpHdQzpt4RgouGP040tT5i0kz79ZSV8PH/e1hG8c0vvSe4A2dJ2IUM2KbelU+eVdjc1oxjtAC3WiT6pR+CB/ow/feM7XIfyGhr/JJ1pJNDDPJ+zEr33/wnyCL7NIsSPE5wPuW0qcxY9Btss0wSZZnOF1mtgofeZP5P4p9RzqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLpiAD9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLpiAD9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6899C433F1;
	Mon,  1 Apr 2024 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990927;
	bh=yH7WQOiDbGN5mo7Qo0DrtB3dweHmvlsMZ6j+SR2jTvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLpiAD9dZyO3hjztizk0Ksnfhs5kLzu9Sh12h0+lXR75JQBHMeuqHEml+NqYNej35
	 IL9I3EK2VoMjrCZgp5zSWVS5rwAc4jWvVY7S4payTtVeXyZcmcdhjtyMIMcIenAUnZ
	 ydWPlhjaAUGx6pJJgV4BiEE0eOYQx8Muo511SMwg=
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
Subject: [PATCH 6.1 109/272] ring-buffer: Fix resetting of shortest_full
Date: Mon,  1 Apr 2024 17:44:59 +0200
Message-ID: <20240401152534.058156351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c934839f625df..3b50e17e2c9ab 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -907,8 +907,19 @@ static void rb_wake_up_waiters(struct irq_work *work)
 
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
@@ -1086,28 +1097,33 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
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



