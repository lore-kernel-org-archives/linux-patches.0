Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4A3822B5;
	Thu, 20 Aug 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239272; cv=none; b=uicxwswDXEbu2iz0fZo1XXvINGLCnMEGgPUG/C4LCraLFjfQROzAnhv63JXnhnWWozJPZ+CXLZflML/+0yUpHLIScPUFrj2Es7qMJyw2G2CdrlA+nVTmiu8cLeg3ZfjNNcl6ASwhdjNWuxcf1/h48w0Lb7nahdwloGxq5Rn5WN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239272; c=relaxed/simple;
	bh=lNcoWCP7bTP1uhwg6yWTWIS+DvDdXhf6hztp8rjZs6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAnqlXuDzZEWSxsIpazBy13Jqrj2cpgEGESNSQ7HMqbYWvvNdk7nRuRQ+kIroHms9FAziBvaKUM0rq3rD2FTo/U0MjQg5HP0ZyUmn1As+tufwtw/UeK8WJbPkkJoliq84ssejXXrErOxr4BKUrw/sB912FbcRxH/L7WWYpsVrkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LnjTCng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LnjTCng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A311D1F000E9;
	Thu, 20 Aug 2026 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239271;
	bh=eCSSHcDacf5wVchfl9eohIeLfiEWzzMOEZyH3DDkkIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LnjTCnguyIi0f2kJ1KbgauVIBta0UszkRZ+uAKpb+bP7g60VSUh9UPHJ0xA//cOV
	 DYAKcnvWy2utDEF748sdZZnCkpFp4r7lW8YGuLeQ2xfIQ8S6hI2yTuGf8Ud7VqA4ni
	 P5//i/qXtMVf34ZiQFG83zZPprX4Eln64mvl6Qkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/217] ring-buffer: Add helper functions for allocations
Date: Thu, 20 Aug 2026 16:55:28 +0200
Message-ID: <20260820145242.569528350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
Stable-dep-of: 7c727dfce6be ("ring-buffer: Prevent resizing of persistent ring buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   97 ++++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 44 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,6 +405,41 @@ static void free_buffer_page(struct buff
 }
 
 /*
+ * For best performance, allocate cpu buffer data cache line sized
+ * and per CPU.
+ */
+#define alloc_cpu_buffer(cpu) (struct ring_buffer_per_cpu *)		\
+	kzalloc_node(ALIGN(sizeof(struct ring_buffer_per_cpu),		\
+			   cache_line_size()), GFP_KERNEL, cpu_to_node(cpu));
+
+#define alloc_cpu_page(cpu) (struct buffer_page *)			\
+	kzalloc_node(ALIGN(sizeof(struct buffer_page),			\
+			   cache_line_size()), GFP_KERNEL, cpu_to_node(cpu));
+
+static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
+{
+	struct buffer_data_page *dpage;
+	struct page *page;
+	gfp_t mflags;
+
+	/*
+	 * __GFP_RETRY_MAYFAIL flag makes sure that the allocation fails
+	 * gracefully without invoking oom-killer and the system is not
+	 * destabilized.
+	 */
+	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
+
+	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
+	if (!page)
+		return NULL;
+
+	dpage = page_address(page);
+	rb_init_page(dpage);
+
+	return dpage;
+}
+
+/*
  * We need to fit the time_stamp delta into 27 bits.
  */
 static inline bool test_time_stamp(u64 delta)
@@ -2214,7 +2249,6 @@ static int __rb_allocate_pages(struct ri
 	struct ring_buffer_cpu_meta *meta = NULL;
 	struct buffer_page *bpage, *tmp;
 	bool user_thread = current->mm != NULL;
-	gfp_t mflags;
 	long i;
 
 	/*
@@ -2229,13 +2263,6 @@ static int __rb_allocate_pages(struct ri
 		return -ENOMEM;
 
 	/*
-	 * __GFP_RETRY_MAYFAIL flag makes sure that the allocation fails
-	 * gracefully without invoking oom-killer and the system is not
-	 * destabilized.
-	 */
-	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-
-	/*
 	 * If a user thread allocates too much, and si_mem_available()
 	 * reports there's enough memory, even though there is not.
 	 * Make sure the OOM killer kills this thread. This can happen
@@ -2251,10 +2278,8 @@ static int __rb_allocate_pages(struct ri
 		meta = rb_range_meta(buffer, nr_pages, cpu_buffer->cpu);
 
 	for (i = 0; i < nr_pages; i++) {
-		struct page *page;
 
-		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-				    mflags, cpu_to_node(cpu_buffer->cpu));
+		bpage = alloc_cpu_page(cpu_buffer->cpu);
 		if (!bpage)
 			goto free_pages;
 
@@ -2277,13 +2302,10 @@ static int __rb_allocate_pages(struct ri
 			bpage->range = 1;
 			bpage->id = i + 1;
 		} else {
-			page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
-						mflags | __GFP_COMP | __GFP_ZERO,
-						cpu_buffer->buffer->subbuf_order);
-			if (!page)
+			int order = cpu_buffer->buffer->subbuf_order;
+			bpage->page = alloc_cpu_data(cpu_buffer->cpu, order);
+			if (!bpage->page)
 				goto free_pages;
-			bpage->page = page_address(page);
-			rb_init_page(bpage->page);
 		}
 		bpage->order = cpu_buffer->buffer->subbuf_order;
 
@@ -2334,14 +2356,12 @@ static int rb_allocate_pages(struct ring
 static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 {
-	struct ring_buffer_per_cpu *cpu_buffer __free(kfree) = NULL;
+	struct ring_buffer_per_cpu *cpu_buffer __free(kfree) =
+		alloc_cpu_buffer(cpu);
 	struct ring_buffer_cpu_meta *meta;
 	struct buffer_page *bpage;
-	struct page *page;
 	int ret;
 
-	cpu_buffer = kzalloc_node(ALIGN(sizeof(*cpu_buffer), cache_line_size()),
-				  GFP_KERNEL, cpu_to_node(cpu));
 	if (!cpu_buffer)
 		return NULL;
 
@@ -2357,8 +2377,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 	init_waitqueue_head(&cpu_buffer->irq_work.full_waiters);
 	mutex_init(&cpu_buffer->mapping_lock);
 
-	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
-			    GFP_KERNEL, cpu_to_node(cpu));
+	bpage = alloc_cpu_page(cpu);
 	if (!bpage)
 		return NULL;
 	bpage->order = cpu_buffer->buffer->subbuf_order;
@@ -2381,13 +2400,10 @@ rb_allocate_cpu_buffer(struct trace_buff
 			rb_meta_buffer_update(cpu_buffer, bpage);
 		bpage->range = 1;
 	} else {
-		page = alloc_pages_node(cpu_to_node(cpu),
-					GFP_KERNEL | __GFP_COMP | __GFP_ZERO,
-					cpu_buffer->buffer->subbuf_order);
-		if (!page)
+		int order = cpu_buffer->buffer->subbuf_order;
+		bpage->page = alloc_cpu_data(cpu, order);
+		if (!bpage->page)
 			goto fail_free_reader;
-		bpage->page = page_address(page);
-		rb_init_page(bpage->page);
 	}
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
@@ -6494,7 +6510,6 @@ ring_buffer_alloc_read_page(struct trace
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_read_page *bpage = NULL;
 	unsigned long flags;
-	struct page *page;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return ERR_PTR(-ENODEV);
@@ -6516,22 +6531,16 @@ ring_buffer_alloc_read_page(struct trace
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
+		rb_init_page(bpage->data);
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


