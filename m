Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA161C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXvirABB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187A7C433C8;
	Wed,  4 Oct 2023 18:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444543;
	bh=OHZSJQ1y3oAv3KC0XimOuO8LYJ7OQhWNp3FuVO8tys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXvirABBUTl79IvUAvuZxzzAsfNgSwMhJ6+UAWoJ/lg2DuHMSyxPOxrRhyDSEIQ5K
	 vJuoEcRmJIs81b5sqq8qPQ2ywkE313pi9tsGkQhP+0UN1XvkQnMn/0P1SCmcp45SOC
	 sP8vyyJmsr0Ls2DSdfbTW1Xb4ERd9tLVed8eDF8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.5 288/321] ring-buffer: Fix bytes info in per_cpu buffer stats
Date: Wed,  4 Oct 2023 19:57:13 +0200
Message-ID: <20231004175242.616645291@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 45d99ea451d0c30bfd4864f0fe485d7dac014902 upstream.

The 'bytes' info in file 'per_cpu/cpu<X>/stats' means the number of
bytes in cpu buffer that have not been consumed. However, currently
after consuming data by reading file 'trace_pipe', the 'bytes' info
was not changed as expected.

  # cat per_cpu/cpu0/stats
  entries: 0
  overrun: 0
  commit overrun: 0
  bytes: 568             <--- 'bytes' is problematical !!!
  oldest event ts:  8651.371479
  now ts:  8653.912224
  dropped events: 0
  read events: 8

The root cause is incorrect stat on cpu_buffer->read_bytes. To fix it:
  1. When stat 'read_bytes', account consumed event in rb_advance_reader();
  2. When stat 'entries_bytes', exclude the discarded padding event which
     is smaller than minimum size because it is invisible to reader. Then
     use rb_page_commit() instead of BUF_PAGE_SIZE at where accounting for
     page-based read/remove/overrun.

Also correct the comments of ring_buffer_bytes_cpu() in this patch.

Link: https://lore.kernel.org/linux-trace-kernel/20230921125425.1708423-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Fixes: c64e148a3be3 ("trace: Add ring buffer stats to measure rate of events")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -354,6 +354,11 @@ static void rb_init_page(struct buffer_d
 	local_set(&bpage->commit, 0);
 }
 
+static __always_inline unsigned int rb_page_commit(struct buffer_page *bpage)
+{
+	return local_read(&bpage->page->commit);
+}
+
 static void free_buffer_page(struct buffer_page *bpage)
 {
 	free_page((unsigned long)bpage->page);
@@ -2011,7 +2016,7 @@ rb_remove_pages(struct ring_buffer_per_c
 			 * Increment overrun to account for the lost events.
 			 */
 			local_add(page_entries, &cpu_buffer->overrun);
-			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+			local_sub(rb_page_commit(to_remove_page), &cpu_buffer->entries_bytes);
 			local_inc(&cpu_buffer->pages_lost);
 		}
 
@@ -2375,11 +2380,6 @@ rb_reader_event(struct ring_buffer_per_c
 			       cpu_buffer->reader_page->read);
 }
 
-static __always_inline unsigned rb_page_commit(struct buffer_page *bpage)
-{
-	return local_read(&bpage->page->commit);
-}
-
 static struct ring_buffer_event *
 rb_iter_head_event(struct ring_buffer_iter *iter)
 {
@@ -2525,7 +2525,7 @@ rb_handle_head_page(struct ring_buffer_p
 		 * the counters.
 		 */
 		local_add(entries, &cpu_buffer->overrun);
-		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		local_sub(rb_page_commit(next_page), &cpu_buffer->entries_bytes);
 		local_inc(&cpu_buffer->pages_lost);
 
 		/*
@@ -2668,9 +2668,6 @@ rb_reset_tail(struct ring_buffer_per_cpu
 
 	event = __rb_page_index(tail_page, tail);
 
-	/* account for padding bytes */
-	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
-
 	/*
 	 * Save the original length to the meta data.
 	 * This will be used by the reader to add lost event
@@ -2684,7 +2681,8 @@ rb_reset_tail(struct ring_buffer_per_cpu
 	 * write counter enough to allow another writer to slip
 	 * in on this page.
 	 * We put in a discarded commit instead, to make sure
-	 * that this space is not used again.
+	 * that this space is not used again, and this space will
+	 * not be accounted into 'entries_bytes'.
 	 *
 	 * If we are less than the minimum size, we don't need to
 	 * worry about it.
@@ -2709,6 +2707,9 @@ rb_reset_tail(struct ring_buffer_per_cpu
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
+	/* account for padding bytes */
+	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
+
 	/* Make sure the padding is visible before the tail_page->write update */
 	smp_wmb();
 
@@ -4223,7 +4224,7 @@ u64 ring_buffer_oldest_event_ts(struct t
 EXPORT_SYMBOL_GPL(ring_buffer_oldest_event_ts);
 
 /**
- * ring_buffer_bytes_cpu - get the number of bytes consumed in a cpu buffer
+ * ring_buffer_bytes_cpu - get the number of bytes unconsumed in a cpu buffer
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to read from.
  */
@@ -4731,6 +4732,7 @@ static void rb_advance_reader(struct rin
 
 	length = rb_event_length(event);
 	cpu_buffer->reader_page->read += length;
+	cpu_buffer->read_bytes += length;
 }
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
@@ -5824,7 +5826,7 @@ int ring_buffer_read_page(struct trace_b
 	} else {
 		/* update the entry counter */
 		cpu_buffer->read += rb_page_entries(reader);
-		cpu_buffer->read_bytes += BUF_PAGE_SIZE;
+		cpu_buffer->read_bytes += rb_page_commit(reader);
 
 		/* swap the pages */
 		rb_init_page(bpage);


