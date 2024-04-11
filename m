Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD8F1474B9;
	Thu, 11 Apr 2024 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831683; cv=none; b=QqV5U3a3ws9M70d86lTkJajIM6SehQ0k5Hme7p23QNNdGEmwxQHMqLgtHqfzd3+1oPPtQG3Rnt0K0JP5AUi9KSKZDx8lHkJReCgA/xibwDxMIAOD2c+bg4WsZgzNn5mYJz5MYLf4zJD7cOlk9aprbUCdOlbg6iBn1jYXROcZIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831683; c=relaxed/simple;
	bh=sQ/xvsNpvt+kX6x4FfJk1cmlJuzrLXRKgInL5DM9FEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM0gyl9lFdaRctTf9emNEQxmKZBUjCW3NMPeSgWSkleEZQPGqd2iXURztcGdO1S/vlHXzTozWEOgTxVOJdXWnjmi3NGB8CYeXzchb9HJhYlLjTxYOAgGFRS8QbflpEOcMCBRxy3+Q+w2n82lbGZNepftzyqry6pdcdYkYRDItqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUlUM8Wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUlUM8Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DFC433C7;
	Thu, 11 Apr 2024 10:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831683;
	bh=sQ/xvsNpvt+kX6x4FfJk1cmlJuzrLXRKgInL5DM9FEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUlUM8Wy4WCnNN/RPmBFdKW5DPIILimYnN8TPxAZIRPCBd5R/GeDA4nJClpJ2ryrO
	 46xt3SJ177Nfs52pR6uLzT4We4AFZh8GfYruFr8qJh/8vwVH0/kVDViJiHy8v8BQ7r
	 D0ZGdCJclqKc+WeAe1JMmymncLZ4AaLSpeVK6BLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/294] ring-buffer: Fix full_waiters_pending in poll
Date: Thu, 11 Apr 2024 11:54:13 +0200
Message-ID: <20240411095438.390469035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 8145f1c35fa648da662078efab299c4467b85ad5 ]

If a reader of the ring buffer is doing a poll, and waiting for the ring
buffer to hit a specific watermark, there could be a case where it gets
into an infinite ping-pong loop.

The poll code has:

  rbwork->full_waiters_pending = true;
  if (!cpu_buffer->shortest_full ||
      cpu_buffer->shortest_full > full)
         cpu_buffer->shortest_full = full;

The writer will see full_waiters_pending and check if the ring buffer is
filled over the percentage of the shortest_full value. If it is, it calls
an irq_work to wake up all the waiters.

But the code could get into a circular loop:

	CPU 0					CPU 1
	-----					-----
 [ Poll ]
   [ shortest_full = 0 ]
   rbwork->full_waiters_pending = true;
					  if (rbwork->full_waiters_pending &&
					      [ buffer percent ] > shortest_full) {
					         rbwork->wakeup_full = true;
					         [ queue_irqwork ]

   cpu_buffer->shortest_full = full;

					  [ IRQ work ]
					  if (rbwork->wakeup_full) {
					        cpu_buffer->shortest_full = 0;
					        wakeup poll waiters;
  [woken]
   if ([ buffer percent ] > full)
      break;
   rbwork->full_waiters_pending = true;
					  if (rbwork->full_waiters_pending &&
					      [ buffer percent ] > shortest_full) {
					         rbwork->wakeup_full = true;
					         [ queue_irqwork ]

   cpu_buffer->shortest_full = full;

					  [ IRQ work ]
					  if (rbwork->wakeup_full) {
					        cpu_buffer->shortest_full = 0;
					        wakeup poll waiters;
  [woken]

 [ Wash, rinse, repeat! ]

In the poll, the shortest_full needs to be set before the
full_pending_waiters, as once that is set, the writer will compare the
current shortest_full (which is incorrect) to decide to call the irq_work,
which will reset the shortest_full (expecting the readers to update it).

Also move the setting of full_waiters_pending after the check if the ring
buffer has the required percentage filled. There's no reason to tell the
writer to wake up waiters if there are no waiters.

Link: https://lore.kernel.org/linux-trace-kernel/20240312131952.630922155@goodmis.org

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 42fb0a1e84ff5 ("tracing/ring-buffer: Have polling block on watermark")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 5465f4c950f27..fb87def73a3a4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1029,16 +1029,32 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 		poll_wait(filp, &rbwork->full_waiters, poll_table);
 
 		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-		rbwork->full_waiters_pending = true;
 		if (!cpu_buffer->shortest_full ||
 		    cpu_buffer->shortest_full > full)
 			cpu_buffer->shortest_full = full;
 		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-	} else {
-		poll_wait(filp, &rbwork->waiters, poll_table);
-		rbwork->waiters_pending = true;
+		if (full_hit(buffer, cpu, full))
+			return EPOLLIN | EPOLLRDNORM;
+		/*
+		 * Only allow full_waiters_pending update to be seen after
+		 * the shortest_full is set. If the writer sees the
+		 * full_waiters_pending flag set, it will compare the
+		 * amount in the ring buffer to shortest_full. If the amount
+		 * in the ring buffer is greater than the shortest_full
+		 * percent, it will call the irq_work handler to wake up
+		 * this list. The irq_handler will reset shortest_full
+		 * back to zero. That's done under the reader_lock, but
+		 * the below smp_mb() makes sure that the update to
+		 * full_waiters_pending doesn't leak up into the above.
+		 */
+		smp_mb();
+		rbwork->full_waiters_pending = true;
+		return 0;
 	}
 
+	poll_wait(filp, &rbwork->waiters, poll_table);
+	rbwork->waiters_pending = true;
+
 	/*
 	 * There's a tight race between setting the waiters_pending and
 	 * checking if the ring buffer is empty.  Once the waiters_pending bit
@@ -1054,9 +1070,6 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 	 */
 	smp_mb();
 
-	if (full)
-		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
-
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
-- 
2.43.0



