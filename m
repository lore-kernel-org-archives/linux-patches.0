Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB70416870;
	Sat, 12 Sep 2026 09:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205528; cv=none; b=n+vAMSYa8RYFBWbWBZqP4VInd3fYoh6/8nRQjZH6/19kQZp4PW8/oNmLpovSnSTnApBKxEDQb/8fB4SsE9Q0Adxo8uTxUbdmzPkzcJ0Cod1bXIVJbuyrlTGptGYD9vqaYtyno+pQexhkLmb13lqLDhPGkOlyQf/IimPD5QRZScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205528; c=relaxed/simple;
	bh=0YgdnPX2YHcz4Ol19NTaazfTs8SLiPEBNFOa4wxUCB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjBMsbpIL51YLco7qpWAEvB/DA9krVHduxl2dtZwcIakcirevhhOxSPapYSO/2P1DERth2KcvCh4PlSuw5whjqB9dzqF7XKBjT+2ww4WFiNSACW1bxWWOd4K1niNTRW4uc4yDW0fMvY/e0jbryKzXkvvnUPc/R/04HqtIXcKR5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEWf2sY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEWf2sY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347A01F000FF;
	Sat, 12 Sep 2026 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205526;
	bh=9v4aSvxMxwN/SIBz8OKEcdw61pS5Nhp5Ggbt72srVHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEWf2sY1Y5NN9pNrEPvDEsdZh2zpgW7No5tGyS6ZLrUE5zDgrzCIJESKIGmajRdCh
	 nljktKyIbU5IOFQCZ7z/4sTXfyMBwXbiP9qok4SK9+N/J3nHHW5RIqKhaernR3f52J
	 wMSQguKU81gGgggLMuEYkexOPqAfv2DPdVpr6z74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0020/1518] ring-buffer: Show persistent buffer dropped events in trace_pipe file
Date: Sat, 12 Sep 2026 08:36:29 +0200
Message-ID: <20260912065623.877213060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 8928e4a3be34bf053f9ef1cad67263604bf4f05e ]

When the persistent ring buffer is validated on boot up, if a subbuffer is
deemed invalid, it resets the buffer and continues. Have the code preserve
the RB_MISSED_EVENTS flag in the commit portion of the subbuffer header
and pass that back so that the trace_pipe file can show the missed events
like the trace file does.

For example:

   <...>-1242    [005] d....  4429.120116: page_fault_user: address=0x7ffaebb6e728 ip=0x7ffaeb9d4960 error_code=0x7
   <...>-1242    [005] .....  4429.120124: mm_page_alloc: page=00000000055254f3 pfn=0x1373bd order=0 migratetype=1 gfp_flags=GFP_HIGHUSER_MOVABLE|__GFP_COMP
   <...>-1242    [005] d..2.  4429.120132: tlb_flush: pages:1 reason:local MM shootdown (3)
CPU:5 [LOST EVENTS]
   <...>-1242    [005] d....  4429.120661: page_fault_user: address=0x55ba7c2d0944 ip=0x55ba7c20cd02 error_code=0x7
   <...>-1242    [005] .....  4429.120669: mm_page_alloc: page=0000000005a02500 pfn=0x12b6e4 order=0 migratetype=1 gfp_flags=GFP_HIGHUSER_MOVABLE|__GFP_COMP
   <...>-1242    [005] d..2.  4429.120680: tlb_flush: pages:1 reason:local MM shootdown (3)

Link: https://patch.msgid.link/20260522171052.156419479@kernel.org
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Backport notes for 6.18:

Keep the ring_buffer_read_page() changes needed as context for
6365c44a824f ("ring-buffer: Allow splice reads on static buffers").
Separate the raw commit flags from the page byte count and preserve the
lost-events flag when copying page contents. Keep the existing bpage name,
rb_page_capacity(reader) bounds and unsigned lost-event count. Read and
mask bpage->commit directly instead of adding the newer data-page helpers.

Drop the reader-page unknown-loss propagation: this tree lacks the
persistent invalid-subbuffer recovery and signed-loss reporting changes
that make that path meaningful.

Keep the copy loop bounded by the page size, not event_size, avoiding the
one-event-per-read regression subsequently fixed by af05b4e06279. Preserve
the loss flag when trimming a swapped page to real_end, and combine output
flags with bitwise OR so an already-set flag is not added a second time.

Stable-dep-of: 6365c44a824f ("ring-buffer: Allow splice reads on static buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   56 +++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6682,6 +6682,7 @@ int ring_buffer_read_page(struct trace_b
 	struct buffer_page *reader;
 	unsigned long missed_events;
 	unsigned int commit;
+	unsigned int size;
 	unsigned int read;
 	u64 save_timestamp;
 
@@ -6716,7 +6717,8 @@ int ring_buffer_read_page(struct trace_b
 	event = rb_reader_event(cpu_buffer);
 
 	read = reader->read;
-	commit = rb_page_size(reader);
+	commit = rb_page_commit(reader);
+	size = rb_page_size(reader);
 
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
@@ -6728,13 +6730,14 @@ int ring_buffer_read_page(struct trace_b
 	 * we must copy the data from the page to the buffer.
 	 * Otherwise, we can simply swap the page with the one passed in.
 	 */
-	if (read || (len < (commit - read)) ||
+	if (read || (len < (size - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
 	    cpu_buffer->mapped) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
-		unsigned int size;
+		unsigned int event_size;
+		unsigned int flags = 0;
 
 		/*
 		 * If a full page is expected, this can still be returned
@@ -6743,19 +6746,22 @@ int ring_buffer_read_page(struct trace_b
 		 * the reader page.
 		 */
 		if (full &&
-		    (!read || (len < (commit - read)) ||
+		    (!read || (len < (size - read)) ||
 		     cpu_buffer->reader_page == cpu_buffer->commit_page))
 			return -1;
 
-		if (len > (commit - read))
-			len = (commit - read);
+		if (len > (size - read))
+			len = (size - read);
 
 		/* Always keep the time extend and data together */
-		size = rb_event_ts_length(event);
+		event_size = rb_event_ts_length(event);
 
-		if (len < size)
+		if (len < event_size)
 			return -1;
 
+		if (commit & RB_MISSED_EVENTS)
+			flags = RB_MISSED_EVENTS;
+
 		/* save the current timestamp, since the user will need it */
 		save_timestamp = cpu_buffer->read_stamp;
 
@@ -6767,25 +6773,25 @@ int ring_buffer_read_page(struct trace_b
 			 * one or two events.
 			 * We have already ensured there's enough space if this
 			 * is a time extend. */
-			size = rb_event_length(event);
-			memcpy(bpage->data + pos, rpage->data + rpos, size);
+			event_size = rb_event_length(event);
+			memcpy(bpage->data + pos, rpage->data + rpos, event_size);
 
-			len -= size;
+			len -= event_size;
 
 			rb_advance_reader(cpu_buffer);
 			rpos = reader->read;
-			pos += size;
+			pos += event_size;
 
-			if (rpos >= commit)
+			if (rpos >= size)
 				break;
 
 			event = rb_reader_event(cpu_buffer);
 			/* Always keep the time extend and data together */
-			size = rb_event_ts_length(event);
-		} while (len >= size);
+			event_size = rb_event_ts_length(event);
+		} while (len >= event_size);
 
 		/* update bpage */
-		local_set(&bpage->commit, pos);
+		local_set(&bpage->commit, pos | flags);
 		bpage->time_stamp = save_timestamp;
 
 		/* we copied everything to the beginning */
@@ -6810,12 +6816,14 @@ int ring_buffer_read_page(struct trace_b
 		 * on the page.
 		 */
 		if (reader->real_end)
-			local_set(&bpage->commit, reader->real_end);
+			local_set(&bpage->commit, reader->real_end |
+				  (commit & RB_MISSED_EVENTS));
 	}
 
 	cpu_buffer->lost_events = 0;
 
 	commit = local_read(&bpage->commit);
+	size = commit & ~RB_MISSED_MASK;
 	/*
 	 * Set a flag in the commit field if we lost events
 	 */
@@ -6823,20 +6831,20 @@ int ring_buffer_read_page(struct trace_b
 		/* If there is room at the end of the page to save the
 		 * missed events, then record it there.
 		 */
-		if (rb_page_capacity(reader) - commit >= sizeof(missed_events)) {
-			memcpy(&bpage->data[commit], &missed_events,
+		if (rb_page_capacity(reader) - size >= sizeof(missed_events)) {
+			memcpy(&bpage->data[size], &missed_events,
 			       sizeof(missed_events));
-			local_add(RB_MISSED_STORED, &bpage->commit);
-			commit += sizeof(missed_events);
+			commit |= RB_MISSED_STORED;
+			size += sizeof(missed_events);
 		}
-		local_add(RB_MISSED_EVENTS, &bpage->commit);
+		local_set(&bpage->commit, commit | RB_MISSED_EVENTS);
 	}
 
 	/*
 	 * This page may be off to user land. Zero it out here.
 	 */
-	if (commit < rb_page_capacity(reader))
-		memset(&bpage->data[commit], 0, rb_page_capacity(reader) - commit);
+	if (size < rb_page_capacity(reader))
+		memset(&bpage->data[size], 0, rb_page_capacity(reader) - size);
 
 	return read;
 }


