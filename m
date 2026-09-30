Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A74CA784;
	Wed, 30 Sep 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789665; cv=none; b=bHK2kgesQkFYMZv+bzyGcAvY0cWNu4M93tS4NbkQbRs2+45Jer0KNVhyD3rVbi/0MJY07pk0yTb1TxE2zOSL4o6UavB7bTHhrCf0hpvK529HC8vlE1gVrdckUJ12hxOR2LkGRLs3XdWtqXUIwRICc9FKjKmclERgKkxr+9wH5eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789665; c=relaxed/simple;
	bh=84V+GdYmVTSCzzyYGCt5AWvpLt0nZBRv0uHT3g6JJxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq8IAnUoIQhYDVVCQ6oz9Qf0AagKyRHQPH/9FawqciXSdhDPEX9Hefxr/wXw0ul5E6HIhdQBJKHtvZoZGVrYasxzEHP9sghF+jIxM0NeoKLNuOf3NKtESq/jpRBjPGYadrTPMLFJLYBd/kAm2qp52RZ+/xiXM69tpiZ0HY5EEEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzVgd3YC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzVgd3YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9411F00899;
	Wed, 30 Sep 2026 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789664;
	bh=rBdPTyHjn+m91HnesQnNALeZpKQ60mSopg9JA00ni8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzVgd3YC5BcuHfY14HLspZ/zH+/cOpq8IkmAe4PkhkyN/V1DF8EG/Pxwn8joL1PEM
	 z7nBNpgwhxO0EgnGFqUIUG8iLbtQ1ckE43w4nKrY0aY8LWHLV12sGBeVQDhynXOlVI
	 F6W4ebLC8UcQ5TeO4Lf/OJnMgTLS7xpVO4zXIh6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 558/877] ring-buffer: Add helper functions for allocations
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152426.683045279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit b1e7a590a0133606d3efd41aee38cdeac630b52f ]

The allocation of the per CPU buffer descriptor, the buffer page
descriptors and the buffer page data itself can be pretty ugly:

  kzalloc_node(ALIGN(sizeof(struct buffer_page), cache_line_size()),
               GFP_KERNEL, cpu_to_node(cpu));

And the data pages:

  page = alloc_pages_node(cpu_to_node(cpu),
                          GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO, order);
  if (!page)
	return NULL;
  bpage->page = page_address(page);
  rb_init_page(bpage->page);

Add helper functions to make the code easier to read.

This does make all allocations of the data page (bpage->page) allocated
with the __GFP_RETRY_MAYFAIL flag (and not just the bulk allocator). Which
is actually better, as allocating the data page for the ring buffer tracing
should try hard but not trigger the OOM killer.

Link: https://lore.kernel.org/all/CAHk-=wjMMSAaqTjBSfYenfuzE1bMjLj+2DLtLWJuGt07UGCH_Q@mail.gmail.com/

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20251125121153.35c07461@gandalf.local.home
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Stable backport adjustment for e743527c5bfd:

Keep only the read-page allocation refactor needed by the target. Express
alloc_cpu_data as a statement-expression macro instead of adding a C
function, retaining NUMA allocation, __GFP_RETRY_MAYFAIL, compound/zeroed
pages, NULL failure handling, and data-page initialization.

Rename the existing rb_init_page initializer to rb_init_data_page, without
changing its implementation, and update its callers. This supplies the
context expected by the target without importing the unrelated cleanup
from 7cf02d0aa6bd or introducing additional functions.

Drop the CPU-buffer and buffer-page descriptor refactors and the bulk and
internal reader-page allocator conversions. These are not needed by the
target; leaving them intact preserves this tree's ring_buffer_meta type,
__GFP_RETRY_MAYFAIL descriptor allocations, and the existing bpage->order
and resize-disabled fixes. Only newly allocated external read pages switch
from __GFP_NORETRY to __GFP_RETRY_MAYFAIL in this backport.

The target's change to allocate using the saved bpage->order is deliberately
left for e743527c5bfd itself.

Stable-dep-of: e743527c5bfd ("ring-buffer: Fix subbuf resize race with ring_buffer_alloc_read_page()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   50 ++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -382,7 +382,7 @@ struct buffer_page {
 #define RB_WRITE_MASK		0xfffff
 #define RB_WRITE_INTCNT		(1 << 20)
 
-static void rb_init_page(struct buffer_data_page *bpage)
+static void rb_init_data_page(struct buffer_data_page *bpage)
 {
 	local_set(&bpage->commit, 0);
 }
@@ -411,6 +411,21 @@ static void free_buffer_page(struct buff
 	kfree(bpage);
 }
 
+/* Try hard to allocate data pages without invoking the OOM killer. */
+#define alloc_cpu_data(cpu, order) ({						\
+	struct buffer_data_page *__rb_data = NULL;				\
+	struct page *__rb_page;							\
+										\
+	__rb_page = alloc_pages_node(cpu_to_node(cpu),				\
+		GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO,	\
+		(order));							\
+	if (__rb_page) {							\
+		__rb_data = page_address(__rb_page);				\
+		rb_init_data_page(__rb_data);					\
+	}									\
+	__rb_data;								\
+})
+
 /*
  * We need to fit the time_stamp delta into 27 bits.
  */
@@ -2016,7 +2031,7 @@ static void rb_range_meta_init(struct tr
 		 */
 		for (i = 0; i < meta->nr_subbufs; i++) {
 			meta->buffers[i] = i;
-			rb_init_page(subbuf);
+			rb_init_data_page(subbuf);
 			subbuf += meta->subbuf_size;
 		}
 	}
@@ -2187,7 +2202,7 @@ static int __rb_allocate_pages(struct ri
 			if (!page)
 				goto free_pages;
 			bpage->page = page_address(page);
-			rb_init_page(bpage->page);
+			rb_init_data_page(bpage->page);
 		}
 		bpage->order = cpu_buffer->buffer->subbuf_order;
 
@@ -2293,7 +2308,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 		if (!page)
 			goto fail_free_reader;
 		bpage->page = page_address(page);
-		rb_init_page(bpage->page);
+		rb_init_data_page(bpage->page);
 	}
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
@@ -6008,7 +6023,7 @@ static void rb_clear_buffer_page(struct
 {
 	local_set(&page->write, 0);
 	local_set(&page->entries, 0);
-	rb_init_page(page->page);
+	rb_init_data_page(page->page);
 	page->read = 0;
 }
 
@@ -6394,7 +6409,6 @@ ring_buffer_alloc_read_page(struct trace
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_read_page *bpage = NULL;
 	unsigned long flags;
-	struct page *page;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return ERR_PTR(-ENODEV);
@@ -6416,22 +6430,16 @@ ring_buffer_alloc_read_page(struct trace
 	arch_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
-	if (bpage->data)
-		goto out;
-
-	page = alloc_pages_node(cpu_to_node(cpu),
-				GFP_KERNEL | __GFP_NORETRY | __GFP_COMP | __GFP_ZERO,
-				cpu_buffer->buffer->subbuf_order);
-	if (!page) {
-		kfree(bpage);
-		return ERR_PTR(-ENOMEM);
+	if (bpage->data) {
+		rb_init_data_page(bpage->data);
+	} else {
+		bpage->data = alloc_cpu_data(cpu, cpu_buffer->buffer->subbuf_order);
+		if (!bpage->data) {
+			kfree(bpage);
+			return ERR_PTR(-ENOMEM);
+		}
 	}
 
-	bpage->data = page_address(page);
-
- out:
-	rb_init_page(bpage->data);
-
 	return bpage;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
@@ -6640,7 +6648,7 @@ int ring_buffer_read_page(struct trace_b
 		cpu_buffer->read_bytes += rb_page_size(reader);
 
 		/* swap the pages */
-		rb_init_page(bpage);
+		rb_init_data_page(bpage);
 		bpage = reader->page;
 		reader->page = data_page->data;
 		local_set(&reader->write, 0);


