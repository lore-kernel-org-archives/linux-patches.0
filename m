Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864FB34389F;
	Sat, 30 May 2026 17:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162223; cv=none; b=le3eWLISkhwA4zo5H+tpYVrhFLgvrZoyq83EQA2sotxnNLEqi+56zAPHG6oGCf3YGUSJjs3dI5EnXYhPSG2qb3gFEE1uOtypCfpj54d3Cxlf++cTH7/Z2bnm+YTUhrgBgh7WVHHIyIqWWgrUHh+61XWLrtO+HjGEOdRwC+qKO+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162223; c=relaxed/simple;
	bh=AX6GV5XYtPhgFYrjKmhhlT9HGDAVfquPpOwZwDbcPjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svjeWSy7gJNWpXgkV8Qob9OiaBNrfqi77pEWFs4ytoe1jqnB3ok+cEY5HoIq74QUK2JDS7AXiOqjERKatU6/FVpQdPsPmwptZK7TMNnzSmCesP8wqVofkijpSE4zZdi6og9bOptSGGtKDCO2xoWDTgcgczTzdhEPgCm4kUncmaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIgXLy5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIgXLy5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DCC1F00893;
	Sat, 30 May 2026 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162222;
	bh=/ZflJiBzkiXdCXRsuWPYywVbGsoi67bmKo2TNASYrHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIgXLy5uz/K8+eiLS8Edo0l1K/FJMrJgCyi3uwl4EI2j//Rl5LXas5fUfmqZcLs/V
	 pqtfsqUiJkl/YgMLYzbckxHpoKyfVPJvgAKc+vIqzo75tj3rasU8NBiB3773pUvcb1
	 UzcZI6Zb3eGudRGx5UW7JGBlRaD91WVaOxtaB2/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 856/969] ring-buffer: Fix reporting of missed events in iterator
Date: Sat, 30 May 2026 18:06:20 +0200
Message-ID: <20260530160324.305833188@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4387,6 +4387,7 @@ static void rb_iter_reset(struct ring_bu
 	iter->head_page = cpu_buffer->reader_page;
 	iter->head = cpu_buffer->reader_page->read;
 	iter->next_event = iter->head;
+	iter->missed_events = 0;
 
 	iter->cache_reader_page = iter->head_page;
 	iter->cache_read = cpu_buffer->read;
@@ -5000,10 +5001,7 @@ ring_buffer_peek(struct trace_buffer *bu
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
 
@@ -5220,7 +5218,7 @@ void ring_buffer_iter_advance(struct rin
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-
+	iter->missed_events = 0;
 	rb_advance_iter(iter);
 
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);


