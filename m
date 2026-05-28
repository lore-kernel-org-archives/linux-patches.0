Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110E92F1FEC;
	Thu, 28 May 2026 20:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000550; cv=none; b=qyadsVDnoZSrRvjPeVB/NtjHRT+IcZo7ZiDtLZdwq6cXG1rYoBCIcjgPAg6NNntNH5IuWiVtx3WtGJ9+EaHukXXN1OVDnOc7MpcifzgwnW29s3C4SeG1zw7PXqEEfc2A5SG+gVTbmB9CEBqPaGZEqOwyXCJwwuphMjHJj91QxyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000550; c=relaxed/simple;
	bh=rttEHrBuV92TtpQKgZd6YHO+nuoLcgFALavlp74ouyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAOZuk9txFUdrI/kkCWWpubSdMJfpiKdTnFSATkycDI4kER/cMwKf2g4r6LjeQyGsw29lL3pkgR0qerLWWKJyGngi40YnbXqESPhk67g5hQfoPXEjHveljMvyHSk3/o1x92+uC9VpSdeey82KgqPOZFScLis/yprosC9Yq8zP6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNIXjpGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNIXjpGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD761F000E9;
	Thu, 28 May 2026 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000549;
	bh=XqtnsAbL1sF5Q0pWSj6aMKUZljp8OHlf/fjPl73zL1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNIXjpGatUk84KhSmM375dgBeKpphSzgyBpyfUirr/DoDuQHv32Cw3DMKpYXNx59F
	 672Yknyf2FxGmvRwR21gzGJjwqLVub8246k1n55GSAEyqifFKTpoTVRKQNIGWTKVfG
	 p87aZY/uqRAofEzLHKlchIHm57kyigbDPVbM9SR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 083/272] ring-buffer: Fix reporting of missed events in iterator
Date: Thu, 28 May 2026 21:47:37 +0200
Message-ID: <20260528194631.702583912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit a254b6d13b0edd6272926674d2afc46d46e496b7 upstream.

When tracing is active while reading the trace file, if the iterator
reading the buffer detects that the writer has passed the iterator head,
it will reset and set a "missed events" flag. This flag is passed to the
output processing to show the user that events were missed:

  CPU:4 [LOST EVENTS]

The problem is that the flag is reset after it is checked in
ring_buffer_iter_dropped(). But the "trace" file iterates over all the CPU
ring buffers and it will check if they are dropped when figuring out which
buffer to print next. This prematurely clears the missed_events flag if
the CPU buffer with the missed events is not the one that is printed next.

On the iteration where the CPU buffer with the missed events is printed,
the check if it had missed events would return false and the output does
not show that events were missed.

Do not reset the missed_events flag when checking if there were missed
events, but instead clear it when moving the iterator head to the next
event.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20260520220801.4fd09d13@fedora
Fixes: c9b7a4a72ff64 ("ring-buffer/tracing: Have iterator acknowledge dropped events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5120,6 +5120,7 @@ static void rb_iter_reset(struct ring_bu
 	iter->head_page = cpu_buffer->reader_page;
 	iter->head = cpu_buffer->reader_page->read;
 	iter->next_event = iter->head;
+	iter->missed_events = 0;
 
 	iter->cache_reader_page = iter->head_page;
 	iter->cache_read = cpu_buffer->read;
@@ -5735,10 +5736,7 @@ ring_buffer_peek(struct trace_buffer *bu
  */
 bool ring_buffer_iter_dropped(struct ring_buffer_iter *iter)
 {
-	bool ret = iter->missed_events != 0;
-
-	iter->missed_events = 0;
-	return ret;
+	return iter->missed_events != 0;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_iter_dropped);
 
@@ -5900,7 +5898,7 @@ void ring_buffer_iter_advance(struct rin
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-
+	iter->missed_events = 0;
 	rb_advance_iter(iter);
 
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);


