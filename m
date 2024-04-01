Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2001C0DE7;
	Mon,  1 Apr 2024 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990933; cv=none; b=STD5roROH5Ry6nquDe101JYn9KWrTsJz+5Vi+nEOEAmblLgaw3qmMWuG4lAKoF2xEdu5wKSKPmUarGGIg9yGFhOJtXTpe0/MFJW5/m2kiVWLasvi4xvSraktp/ADr9jEQ4aHHazn3PeULHJ/x76mQNM7w35GaEt8WlOHngyGGCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990933; c=relaxed/simple;
	bh=l3GQ3OeuPcIMZuf6sex/HTKZbYVT+PAKcVUD0neOBe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq+9GehNj+URBOzLjP40s3jSEhEbg/JWy1r9tELUdxa31DOk/hjDGW3jibE4J0ByNF3DT2KTlOyyVbsNelfW+38inU06v0CmiBDVPxcUcI4mJJO/93Ok+EdJAfw/Sw6H7Qpa9hTO7bXttSSQpFMnFd0hk27DiAl1x4BWXnngD1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sLZE+0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sLZE+0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50E5C433C7;
	Mon,  1 Apr 2024 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990933;
	bh=l3GQ3OeuPcIMZuf6sex/HTKZbYVT+PAKcVUD0neOBe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sLZE+0DtCuMWyR7iVD5RDh9YIT9x5MXa2U63+sHD9OMexp15YRYqa9LEpQVJHRIX
	 upKuL0z9oqx1oqUd3uOGCRvCvccigGONySCyeHlLGmT9+3O9knoLmT3+G51rxdTUwc
	 Hzycd+2QDs7FLW/dmMt6ibwTH4eAxfEf1yGkKIGU=
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
Subject: [PATCH 6.1 111/272] ring-buffer: Use wait_event_interruptible() in ring_buffer_wait()
Date: Mon,  1 Apr 2024 17:45:01 +0200
Message-ID: <20240401152534.119666808@linuxfoundation.org>
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

[ Upstream commit 7af9ded0c2caac0a95f33df5cb04706b0f502588 ]

Convert ring_buffer_wait() over to wait_event_interruptible(). The default
condition is to execute the wait loop inside __wait_event() just once.

This does not change the ring_buffer_wait() prototype yet, but
restructures the code so that it can take a "cond" and "data" parameter
and will call wait_event_interruptible() with a helper function as the
condition.

The helper function (rb_wait_cond) takes the cond function and data
parameters. It will first check if the buffer hit the watermark defined by
the "full" parameter and then call the passed in condition parameter. If
either are true, it returns true.

If rb_wait_cond() does not return true, it will set the appropriate
"waiters_pending" flag and returns false.

Link: https://lore.kernel.org/linux-trace-kernel/CAHk-=wgsNgewHFxZAJiAQznwPMqEtQmi1waeS2O1v6L4c_Um5A@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20240312121703.399598519@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linke li <lilinke99@qq.com>
Cc: Rabin Vincent <rabin@rab.in>
Fixes: f3ddb74ad0790 ("tracing: Wake up ring buffer waiters on closing of the file")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ring_buffer.h |   1 +
 kernel/trace/ring_buffer.c  | 116 +++++++++++++++++++++---------------
 2 files changed, 69 insertions(+), 48 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 3c7d295746f67..3e7bfc0f65aee 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -98,6 +98,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
+typedef bool (*ring_buffer_cond_fn)(void *data);
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table, int full);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e07f45d1890d3..431a922e5c89e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -994,43 +994,15 @@ static bool rb_watermark_hit(struct trace_buffer *buffer, int cpu, int full)
 	return ret;
 }
 
-/**
- * ring_buffer_wait - wait for input to the ring buffer
- * @buffer: buffer to wait on
- * @cpu: the cpu buffer to wait on
- * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
- *
- * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
- * as data is added to any of the @buffer's cpu buffers. Otherwise
- * it will wait for data to be added to a specific cpu buffer.
- */
-int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
+static inline bool
+rb_wait_cond(struct rb_irq_work *rbwork, struct trace_buffer *buffer,
+	     int cpu, int full, ring_buffer_cond_fn cond, void *data)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
-	DEFINE_WAIT(wait);
-	struct rb_irq_work *work;
-	int ret = 0;
-
-	/*
-	 * Depending on what the caller is waiting for, either any
-	 * data in any cpu buffer, or a specific buffer, put the
-	 * caller on the appropriate wait queue.
-	 */
-	if (cpu == RING_BUFFER_ALL_CPUS) {
-		work = &buffer->irq_work;
-		/* Full only makes sense on per cpu reads */
-		full = 0;
-	} else {
-		if (!cpumask_test_cpu(cpu, buffer->cpumask))
-			return -ENODEV;
-		cpu_buffer = buffer->buffers[cpu];
-		work = &cpu_buffer->irq_work;
-	}
+	if (rb_watermark_hit(buffer, cpu, full))
+		return true;
 
-	if (full)
-		prepare_to_wait(&work->full_waiters, &wait, TASK_INTERRUPTIBLE);
-	else
-		prepare_to_wait(&work->waiters, &wait, TASK_INTERRUPTIBLE);
+	if (cond(data))
+		return true;
 
 	/*
 	 * The events can happen in critical sections where
@@ -1053,27 +1025,75 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 	 * a task has been queued. It's OK for spurious wake ups.
 	 */
 	if (full)
-		work->full_waiters_pending = true;
+		rbwork->full_waiters_pending = true;
 	else
-		work->waiters_pending = true;
+		rbwork->waiters_pending = true;
 
-	if (rb_watermark_hit(buffer, cpu, full))
-		goto out;
+	return false;
+}
 
-	if (signal_pending(current)) {
-		ret = -EINTR;
-		goto out;
+/*
+ * The default wait condition for ring_buffer_wait() is to just to exit the
+ * wait loop the first time it is woken up.
+ */
+static bool rb_wait_once(void *data)
+{
+	long *once = data;
+
+	/* wait_event() actually calls this twice before scheduling*/
+	if (*once > 1)
+		return true;
+
+	(*once)++;
+	return false;
+}
+
+/**
+ * ring_buffer_wait - wait for input to the ring buffer
+ * @buffer: buffer to wait on
+ * @cpu: the cpu buffer to wait on
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
+ *
+ * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
+ * as data is added to any of the @buffer's cpu buffers. Otherwise
+ * it will wait for data to be added to a specific cpu buffer.
+ */
+int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct wait_queue_head *waitq;
+	ring_buffer_cond_fn cond;
+	struct rb_irq_work *rbwork;
+	void *data;
+	long once = 0;
+	int ret = 0;
+
+	cond = rb_wait_once;
+	data = &once;
+
+	/*
+	 * Depending on what the caller is waiting for, either any
+	 * data in any cpu buffer, or a specific buffer, put the
+	 * caller on the appropriate wait queue.
+	 */
+	if (cpu == RING_BUFFER_ALL_CPUS) {
+		rbwork = &buffer->irq_work;
+		/* Full only makes sense on per cpu reads */
+		full = 0;
+	} else {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -ENODEV;
+		cpu_buffer = buffer->buffers[cpu];
+		rbwork = &cpu_buffer->irq_work;
 	}
 
-	schedule();
- out:
 	if (full)
-		finish_wait(&work->full_waiters, &wait);
+		waitq = &rbwork->full_waiters;
 	else
-		finish_wait(&work->waiters, &wait);
+		waitq = &rbwork->waiters;
 
-	if (!ret && !rb_watermark_hit(buffer, cpu, full) && signal_pending(current))
-		ret = -EINTR;
+	ret = wait_event_interruptible((*waitq),
+				rb_wait_cond(rbwork, buffer, cpu, full, cond, data));
 
 	return ret;
 }
-- 
2.43.0



