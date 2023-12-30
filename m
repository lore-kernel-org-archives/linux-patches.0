Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0904CC2C6;
	Sat, 30 Dec 2023 21:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6388CC433C7;
	Sat, 30 Dec 2023 21:46:43 +0000 (UTC)
Date: Sat, 30 Dec 2023 16:47:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Masami Hiramatsu
 <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes
 <joel@joelfernandes.org>, Vincent Donnefort <vdonnefort@google.com>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 133/156] ring-buffer: Remove useless update to
 write_stamp in rb_try_to_discard()
Message-ID: <20231230164736.3b8c86c4@gandalf.local.home>
In-Reply-To: <20231230115816.705008371@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
	<20231230115816.705008371@linuxfoundation.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 30 Dec 2023 11:59:47 +0000
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Steven Rostedt (Google) <rostedt@goodmis.org>
> 
> [ Upstream commit 083e9f65bd215582bf8f6a920db729fadf16704f ]

BTW, here's a fix for 6.1 and 5.15

-- Steve


diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 61803208706a..dae2d4511d46 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2981,25 +2981,6 @@ static unsigned rb_calculate_event_length(unsigned length)
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
@@ -3008,8 +2989,6 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 	struct buffer_page *bpage;
 	unsigned long index;
 	unsigned long addr;
-	u64 write_stamp;
-	u64 delta;
 
 	new_index = rb_event_index(event);
 	old_index = new_index + rb_event_ts_length(event);
@@ -3018,14 +2997,10 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 
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
@@ -3036,20 +3011,20 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
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
@@ -3488,7 +3463,7 @@ static void check_buffer(struct ring_buffer_per_cpu *cpu_buffer,
 		return;
 
 	/*
-	 * If this interrupted another event, 
+	 * If this interrupted another event,
 	 */
 	if (atomic_inc_return(this_cpu_ptr(&checking)) != 1)
 		goto out;
