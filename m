Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8064778B;
	Mon,  1 Apr 2024 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987640; cv=none; b=hUlEgtfxHpq/AWVx/lreCwGblPfc3VOJLyxOAPP6AsMxhEA+6Wzk/wFTPcwAVPYuFzJOGI9k2FjFDWec5dPJ7CcytnjSkancIII1LidXbsjsjxO2uiOymkNzSUq/JZk4FXFTeB2cbSW9Mrkm5i4ny6Qunu3Yps5qOpcrRgIiwg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987640; c=relaxed/simple;
	bh=0DXvH/HPpEIuMnwZgThDWSByXK2FVuvTjj162ZvNzXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHiCosIaQmyfPKEldsSGAskFMv9OeQJ/4m2T/b83YVAyTPv+lkjoNMdu0DE1YpZK3wSe9Ueb4pCgpKhOF/nk1Ilfs8bl09Bf4vo/ZhuhmSmZMt+LVnppfUe+U1JmgTA5T0eYYGpHzZ/5b+71KAiDkBGlpXUx23ueXYAT1JvqAwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipQWUXcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipQWUXcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F2EC433C7;
	Mon,  1 Apr 2024 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987639;
	bh=0DXvH/HPpEIuMnwZgThDWSByXK2FVuvTjj162ZvNzXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipQWUXcMA9x4zdgb386qWktTavg+G+Mpvm1vKb7bX1JPzqcJpcc1W7utKw/cdtXGw
	 RJ5L0kJD9iB3AtJSTnX1WjfPjY17/gLaTifaGj2jPUCf9SQKGfbHUlo6/P8o2Myfou
	 BqvJVE9flivzvW0Omnrylkq6KBFSMIeiypm7KzSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 347/399] ring-buffer: Make wake once of ring_buffer_wait() more robust
Date: Mon,  1 Apr 2024 17:45:13 +0200
Message-ID: <20240401152559.534144018@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit b70f2938242a028f8e9473781ede175486a59dc8 ]

The default behavior of ring_buffer_wait() when passed a NULL "cond"
parameter is to exit the function the first time it is woken up. The
current implementation uses a counter that starts at zero and when it is
greater than one it exits the wait_event_interruptible().

But this relies on the internal working of wait_event_interruptible() as
that code basically has:

  if (cond)
    return;
  prepare_to_wait();
  if (!cond)
    schedule();
  finish_wait();

That is, cond is called twice before it sleeps. The default cond of
ring_buffer_wait() needs to account for that and wait for its counter to
increment twice before exiting.

Instead, use the seq/atomic_inc logic that is used by the tracing code
that calls this function. Add an atomic_t seq to rb_irq_work and when cond
is NULL, have the default callback take a descriptor as its data that
holds the rbwork and the value of the seq when it started.

The wakeups will now increment the rbwork->seq and the cond callback will
simply check if that number is different, and no longer have to rely on
the implementation of wait_event_interruptible().

Link: https://lore.kernel.org/linux-trace-kernel/20240315063115.6cb5d205@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 7af9ded0c2ca ("ring-buffer: Use wait_event_interruptible() in ring_buffer_wait()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ad0d475d1f570..43060a7ae15e7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -384,6 +384,7 @@ struct rb_irq_work {
 	struct irq_work			work;
 	wait_queue_head_t		waiters;
 	wait_queue_head_t		full_waiters;
+	atomic_t			seq;
 	bool				waiters_pending;
 	bool				full_waiters_pending;
 	bool				wakeup_full;
@@ -753,6 +754,9 @@ static void rb_wake_up_waiters(struct irq_work *work)
 {
 	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
 
+	/* For waiters waiting for the first wake up */
+	(void)atomic_fetch_inc_release(&rbwork->seq);
+
 	wake_up_all(&rbwork->waiters);
 	if (rbwork->full_waiters_pending || rbwork->wakeup_full) {
 		/* Only cpu_buffer sets the above flags */
@@ -881,20 +885,21 @@ rb_wait_cond(struct rb_irq_work *rbwork, struct trace_buffer *buffer,
 	return false;
 }
 
+struct rb_wait_data {
+	struct rb_irq_work		*irq_work;
+	int				seq;
+};
+
 /*
  * The default wait condition for ring_buffer_wait() is to just to exit the
  * wait loop the first time it is woken up.
  */
 static bool rb_wait_once(void *data)
 {
-	long *once = data;
+	struct rb_wait_data *rdata = data;
+	struct rb_irq_work *rbwork = rdata->irq_work;
 
-	/* wait_event() actually calls this twice before scheduling*/
-	if (*once > 1)
-		return true;
-
-	(*once)++;
-	return false;
+	return atomic_read_acquire(&rbwork->seq) != rdata->seq;
 }
 
 /**
@@ -915,14 +920,9 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full,
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct wait_queue_head *waitq;
 	struct rb_irq_work *rbwork;
-	long once = 0;
+	struct rb_wait_data rdata;
 	int ret = 0;
 
-	if (!cond) {
-		cond = rb_wait_once;
-		data = &once;
-	}
-
 	/*
 	 * Depending on what the caller is waiting for, either any
 	 * data in any cpu buffer, or a specific buffer, put the
@@ -944,6 +944,14 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full,
 	else
 		waitq = &rbwork->waiters;
 
+	/* Set up to exit loop as soon as it is woken */
+	if (!cond) {
+		cond = rb_wait_once;
+		rdata.irq_work = rbwork;
+		rdata.seq = atomic_read_acquire(&rbwork->seq);
+		data = &rdata;
+	}
+
 	ret = wait_event_interruptible((*waitq),
 				rb_wait_cond(rbwork, buffer, cpu, full, cond, data));
 
-- 
2.43.0



