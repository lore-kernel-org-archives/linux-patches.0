Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1688F189BBA;
	Tue, 10 Sep 2024 09:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961187; cv=none; b=o9X0sI6o/xpHErBMj/4Rs+9j2Tdbea320yewYchxfWjutV8ldpHBf8sdrXIWtwuiajbqWPGevsm8wpVaIUELx1JX8sqtlFBTZE0sAI8omhyTaNhwg/T2hodlS4GyAU+FOAv6KxCTNMv8DJNNPyi8rq8JEy9eZA25Vnsd9dMgLHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961187; c=relaxed/simple;
	bh=CQAiZxEMpP0lwIpJovCmNRATN0eZiVwrpTLEaiX9b/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE15B+zm7acYVjL7KXAY8l9nSYofb7mVhVYn0YX5pvTdHsIyf5zwI/EWgv1DMwPMqLK8F8PA7bnE5aXgpzFde57emMWhqwuRhRoYI+92pS3WZhhoOaPI1nAsOAtnBkGgICM3Iq+WU1R+d1AgEQ3gRjiAfbDthbeEb64PbamvN/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQJA91bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQJA91bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE1C4CEC3;
	Tue, 10 Sep 2024 09:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961187;
	bh=CQAiZxEMpP0lwIpJovCmNRATN0eZiVwrpTLEaiX9b/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQJA91bjDVxmxUZFEREfORjbM7nLTzsR91f2f2OQn/dFSjLv6slv9vRKb8TVVphUE
	 zYJudrsRnsaZVC5dprcSQPvMRUNcwDhV4eOmvJr9rIJFDgpMpBa2dxG9sutiW1VSrB
	 PdmN0i//muNJn8P0B+DYv8NSgHAtqwacc7LHtX2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 82/96] ring-buffer: Rename ring_buffer_read() to read_buffer_iter_advance()
Date: Tue, 10 Sep 2024 11:32:24 +0200
Message-ID: <20240910092545.139696253@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit bc1a72afdc4a91844928831cac85731566e03bc6 ]

When the ring buffer was first created, the iterator followed the normal
producer/consumer operations where it had both a peek() operation, that just
returned the event at the current location, and a read(), that would return
the event at the current location and also increment the iterator such that
the next peek() or read() will return the next event.

The only use of the ring_buffer_read() is currently to move the iterator to
the next location and nothing now actually reads the event it returns.
Rename this function to its actual use case to ring_buffer_iter_advance(),
which also adds the "iter" part to the name, which is more meaningful. As
the timestamp returned by ring_buffer_read() was never used, there's no
reason that this new version should bother having returning it. It will also
become a void function.

Link: http://lkml.kernel.org/r/20200317213416.018928618@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 49aa8a1f4d68 ("tracing: Avoid possible softlockup in tracing_iter_reset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ring_buffer.h          |  3 +--
 kernel/trace/ring_buffer.c           | 23 ++++++-----------------
 kernel/trace/trace.c                 |  4 ++--
 kernel/trace/trace_functions_graph.c |  2 +-
 4 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 941bfd9b3c89..7c5b217347b3 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -135,8 +135,7 @@ void ring_buffer_read_finish(struct ring_buffer_iter *iter);
 
 struct ring_buffer_event *
 ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts);
-struct ring_buffer_event *
-ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
+void ring_buffer_iter_advance(struct ring_buffer_iter *iter);
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
 int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index aee6eab9bb8f..6cd50fb1b8fd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4379,35 +4379,24 @@ ring_buffer_read_finish(struct ring_buffer_iter *iter)
 EXPORT_SYMBOL_GPL(ring_buffer_read_finish);
 
 /**
- * ring_buffer_read - read the next item in the ring buffer by the iterator
+ * ring_buffer_iter_advance - advance the iterator to the next location
  * @iter: The ring buffer iterator
- * @ts: The time stamp of the event read.
  *
- * This reads the next event in the ring buffer and increments the iterator.
+ * Move the location of the iterator such that the next read will
+ * be the next location of the iterator.
  */
-struct ring_buffer_event *
-ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
+void ring_buffer_iter_advance(struct ring_buffer_iter *iter)
 {
-	struct ring_buffer_event *event;
 	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
- again:
-	event = rb_iter_peek(iter, ts);
-	if (!event)
-		goto out;
-
-	if (event->type_len == RINGBUF_TYPE_PADDING)
-		goto again;
 
 	rb_advance_iter(iter);
- out:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
-	return event;
+	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 }
-EXPORT_SYMBOL_GPL(ring_buffer_read);
+EXPORT_SYMBOL_GPL(ring_buffer_iter_advance);
 
 /**
  * ring_buffer_size - return the size of the ring buffer (in bytes)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8292c7441e23..022f50dbc456 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3090,7 +3090,7 @@ static void trace_iterator_increment(struct trace_iterator *iter)
 
 	iter->idx++;
 	if (buf_iter)
-		ring_buffer_read(buf_iter, NULL);
+		ring_buffer_iter_advance(buf_iter);
 }
 
 static struct trace_entry *
@@ -3250,7 +3250,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 		if (ts >= iter->trace_buffer->time_start)
 			break;
 		entries++;
-		ring_buffer_read(buf_iter, NULL);
+		ring_buffer_iter_advance(buf_iter);
 	}
 
 	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = entries;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 086af4f5c3e8..7add1f3ee2dd 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -726,7 +726,7 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 	/* this is a leaf, now advance the iterator */
 	if (ring_iter)
-		ring_buffer_read(ring_iter, NULL);
+		ring_buffer_iter_advance(ring_iter);
 
 	return next;
 }
-- 
2.43.0



