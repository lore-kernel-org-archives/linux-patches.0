Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117751BDDE;
	Wed,  3 Jan 2024 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9iqMRfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B422C433C9;
	Wed,  3 Jan 2024 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301295;
	bh=nvq7KTLhf4k8RzegZvxyE9vLBwq64ZN8bVtYScfh6a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9iqMRfcDlwTXry1PHa+JQVuD9OY+5QOa3j9K7EfTaIrXuqJmXXZnQTxn3o4ZhFHe
	 2SOVR28+me9zfPTYU4OHymnIuk/2NE95WNYavzQLH+H4iOF/HmgbmgsX+zNTsKYSMH
	 eBLQdEqylwpE6cP6kh5SmpwHoVRCOoCpwUe/uLGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 093/100] ring-buffer: Remove useless update to write_stamp in rb_try_to_discard()
Date: Wed,  3 Jan 2024 17:55:22 +0100
Message-ID: <20240103164910.100157630@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

commit 083e9f65bd215582bf8f6a920db729fadf16704f upstream.

When filtering is enabled, a temporary buffer is created to place the
content of the trace event output so that the filter logic can decide
from the trace event output if the trace event should be filtered out or
not. If it is to be filtered out, the content in the temporary buffer is
simply discarded, otherwise it is written into the trace buffer.

But if an interrupt were to come in while a previous event was using that
temporary buffer, the event written by the interrupt would actually go
into the ring buffer itself to prevent corrupting the data on the
temporary buffer. If the event is to be filtered out, the event in the
ring buffer is discarded, or if it fails to discard because another event
were to have already come in, it is turned into padding.

The update to the write_stamp in the rb_try_to_discard() happens after a
fix was made to force the next event after the discard to use an absolute
timestamp by setting the before_stamp to zero so it does not match the
write_stamp (which causes an event to use the absolute timestamp).

But there's an effort in rb_try_to_discard() to put back the write_stamp
to what it was before the event was added. But this is useless and
wasteful because nothing is going to be using that write_stamp for
calculations as it still will not match the before_stamp.

Remove this useless update, and in doing so, we remove another
cmpxchg64()!

Also update the comments to reflect this change as well as remove some
extra white space in another comment.

Link: https://lore.kernel.org/linux-trace-kernel/20231215081810.1f4f38fe@rorschach.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Vincent Donnefort   <vdonnefort@google.com>
Fixes: b2dd797543cf ("ring-buffer: Force absolute timestamp on discard of event")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   47 ++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2987,25 +2987,6 @@ static unsigned rb_calculate_event_lengt
 	return length;
 }
 
-static u64 rb_time_delta(struct ring_buffer_event *event)
-{
-	switch (event->type_len) {
-	case RINGBUF_TYPE_PADDING:
-		return 0;
-
-	case RINGBUF_TYPE_TIME_EXTEND:
-		return rb_event_time_stamp(event);
-
-	case RINGBUF_TYPE_TIME_STAMP:
-		return 0;
-
-	case RINGBUF_TYPE_DATA:
-		return event->time_delta;
-	default:
-		return 0;
-	}
-}
-
 static inline int
 rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 		  struct ring_buffer_event *event)
@@ -3014,8 +2995,6 @@ rb_try_to_discard(struct ring_buffer_per
 	struct buffer_page *bpage;
 	unsigned long index;
 	unsigned long addr;
-	u64 write_stamp;
-	u64 delta;
 
 	new_index = rb_event_index(event);
 	old_index = new_index + rb_event_ts_length(event);
@@ -3024,14 +3003,10 @@ rb_try_to_discard(struct ring_buffer_per
 
 	bpage = READ_ONCE(cpu_buffer->tail_page);
 
-	delta = rb_time_delta(event);
-
-	if (!rb_time_read(&cpu_buffer->write_stamp, &write_stamp))
-		return 0;
-
-	/* Make sure the write stamp is read before testing the location */
-	barrier();
-
+	/*
+	 * Make sure the tail_page is still the same and
+	 * the next write location is the end of this event
+	 */
 	if (bpage->page == (void *)addr && rb_page_write(bpage) == old_index) {
 		unsigned long write_mask =
 			local_read(&bpage->write) & ~RB_WRITE_MASK;
@@ -3042,20 +3017,20 @@ rb_try_to_discard(struct ring_buffer_per
 		 * to make sure that the next event adds an absolute
 		 * value and does not rely on the saved write stamp, which
 		 * is now going to be bogus.
+		 *
+		 * By setting the before_stamp to zero, the next event
+		 * is not going to use the write_stamp and will instead
+		 * create an absolute timestamp. This means there's no
+		 * reason to update the wirte_stamp!
 		 */
 		rb_time_set(&cpu_buffer->before_stamp, 0);
 
-		/* Something came in, can't discard */
-		if (!rb_time_cmpxchg(&cpu_buffer->write_stamp,
-				       write_stamp, write_stamp - delta))
-			return 0;
-
 		/*
 		 * If an event were to come in now, it would see that the
 		 * write_stamp and the before_stamp are different, and assume
 		 * that this event just added itself before updating
 		 * the write stamp. The interrupting event will fix the
-		 * write stamp for us, and use the before stamp as its delta.
+		 * write stamp for us, and use an absolute timestamp.
 		 */
 
 		/*
@@ -3494,7 +3469,7 @@ static void check_buffer(struct ring_buf
 		return;
 
 	/*
-	 * If this interrupted another event, 
+	 * If this interrupted another event,
 	 */
 	if (atomic_inc_return(this_cpu_ptr(&checking)) != 1)
 		goto out;


