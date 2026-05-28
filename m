Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDDA33F5B4;
	Thu, 28 May 2026 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998145; cv=none; b=pFWLKBRXqyUZwbCKISS88ix8qh2lF2LAsSfL42Wou4Cqoz8pRO7ajKp1Y7QK6eL4qONTCUzL87HuAug1fMfGYF1cfwTaVgQL6k+zEISWnvfftqXDo4MTNovM3msq2uqjdESJowGJnUylWypemQNG3mimNR7DCtdsQ0Jd56KyLaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998145; c=relaxed/simple;
	bh=TdaJOXI5TGNNi5ekPsFr1S3MiSUhTfUHshS2j8ZeJ5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf2Lr/ttvQw4sRGgbGMQUGnQWTPK6LlgHHXP8YwEV01tJAEgmPh7T4A+iF08H9XiZe3yiHo3TCIijw1F2/pvVIq6nDOgnzNgqb8Wc1JoUxoVh+cEb6Gk4V2RmAzkjcFldQ6sMfoNyhhb4puydEy1RZgB3NmsRpvoOxPWX2RWYK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0klHCUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0klHCUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3F61F000E9;
	Thu, 28 May 2026 19:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998144;
	bh=MS+lQeOPCZ+qL+/NKFku5wiPr6IhXASGIDbUUOw1dHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0klHCUD2xbX8RhCPa5i7OCssGXC7RGmQuIOhbG6Z6LvRbD4TOaBlXFbTF0++3ndQ
	 sme2WFVaztbkQae0ob2m1bS5qfQI97c5UAwC34RDLOP2ffwKQSpiWH3aNCYEIMW9jB
	 3OzuaCclcl+x1UrOuNtr4YDYkoNLzg8zfCbYelXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.0 068/461] ring-buffer: Fix reporting of missed events in iterator
Date: Thu, 28 May 2026 21:43:17 +0200
Message-ID: <20260528194648.891721609@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5283,6 +5283,7 @@ static void rb_iter_reset(struct ring_bu
 	iter->head_page = cpu_buffer->reader_page;
 	iter->head = cpu_buffer->reader_page->read;
 	iter->next_event = iter->head;
+	iter->missed_events = 0;
 
 	iter->cache_reader_page = iter->head_page;
 	iter->cache_read = cpu_buffer->read;
@@ -5897,10 +5898,7 @@ ring_buffer_peek(struct trace_buffer *bu
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
 
@@ -6062,7 +6060,7 @@ void ring_buffer_iter_advance(struct rin
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-
+	iter->missed_events = 0;
 	rb_advance_iter(iter);
 
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);


