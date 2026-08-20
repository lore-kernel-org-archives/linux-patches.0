Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2813C410D30;
	Thu, 20 Aug 2026 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247184; cv=none; b=X4wzogFkDG1DY71yI/+dnbplCeTujFCeiyWyC1zQf1yRXvJyZoEve9iFarI7NwdniQi4loDVZpXBXpRQAqOXpi5RWH6VlFr/E3crb+iwOfXMGTNykKRjPgOkO2c0Bc3wezWcWh5X6UEeWMg1Ww1Lt9lg/sy0l9+xefTBZqNTV+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247184; c=relaxed/simple;
	bh=8qOVffOBcBZjnKWgzfu8tJPtO4yAoriA6qRzqyjNDf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVwBOzFKW7R4fBpMyIssqJM2suqWbdJu0hMF2+iPAtkjKVmnM7sbLOSya/v4HzyYmaWfh0G3J7nBTQB1HxDGw2kxoEq0pxdqCEnc/bPjYe9xCMC4VtzeMYSasspeBAMAJCZgseVzLLyt7nMRk/2ULYke1fJxtLbq9k56A5Ky4tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCJajtNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCJajtNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235321F00A3E;
	Thu, 20 Aug 2026 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247182;
	bh=ZzoX2e3xXe3PyrE0NfZzHVNa0jGpU2wWk47SBQ/Qpjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCJajtNtIYbztly/wC6XASzgyLa8SfNLz0x0Zv7GZWsq8xrKjtjrM+wmY1oKeENct
	 CvkaBAYcl4CkZC48Uvf91jebQd82Wfqn4w+SXg0CXXlx6pMAdffXdMq7zd6HwOiwF7
	 FbiLifyAoCUB/Qh0NFwjJMTOEcyscR5a18I4Xtg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/220] ring-buffer: Simplify functions with __free(kfree) to free allocations
Date: Thu, 20 Aug 2026 16:56:07 +0200
Message-ID: <20260820145228.794442506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit 99d232804405e35d7a9af1536a057578a1442e81 ]

The function rb_allocate_pages() allocates cpu_buffer and on error needs
to free it. It has a single return. Use __free(kfree) and return directly
on errors and have the return use return_ptr(cpu_buffer).

The function alloc_buffer() allocates buffer and on error needs to free
it. It has a single return. Use __free(kfree) and return directly on
errors and have the return use return_ptr(buffer).

The function __rb_map_vma() allocates a temporary array "pages". Have it
use __free() and not worry about freeing it when returning.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250527143144.6edc4625@gandalf.local.home
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 6d014e44b68d ("ring-buffer: Initialise reader page order in rb_allocate_cpu_buffer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2193,7 +2193,7 @@ static int rb_allocate_pages(struct ring
 static struct ring_buffer_per_cpu *
 rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_per_cpu *cpu_buffer __free(kfree) = NULL;
 	struct ring_buffer_meta *meta;
 	struct buffer_page *bpage;
 	struct page *page;
@@ -2219,7 +2219,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
 	if (!bpage)
-		goto fail_free_buffer;
+		return NULL;
 
 	rb_check_bpage(cpu_buffer, bpage);
 
@@ -2285,13 +2285,11 @@ rb_allocate_cpu_buffer(struct trace_buff
 		rb_head_page_activate(cpu_buffer);
 	}
 
-	return cpu_buffer;
+	return_ptr(cpu_buffer);
 
  fail_free_reader:
 	free_buffer_page(cpu_buffer->reader_page);
 
- fail_free_buffer:
-	kfree(cpu_buffer);
 	return NULL;
 }
 
@@ -2335,7 +2333,7 @@ static struct trace_buffer *alloc_buffer
 					 unsigned long end,
 					 struct lock_class_key *key)
 {
-	struct trace_buffer *buffer;
+	struct trace_buffer *buffer __free(kfree) = NULL;
 	long nr_pages;
 	int subbuf_size;
 	int bsize;
@@ -2349,7 +2347,7 @@ static struct trace_buffer *alloc_buffer
 		return NULL;
 
 	if (!zalloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
-		goto fail_free_buffer;
+		return NULL;
 
 	buffer->subbuf_order = order;
 	subbuf_size = (PAGE_SIZE << order);
@@ -2441,7 +2439,7 @@ static struct trace_buffer *alloc_buffer
 		atomic_notifier_chain_register(&panic_notifier_list, &buffer->flush_nb);
 	}
 
-	return buffer;
+	return_ptr(buffer);
 
  fail_free_buffers:
 	for_each_buffer_cpu(buffer, cpu) {
@@ -2453,8 +2451,6 @@ static struct trace_buffer *alloc_buffer
  fail_free_cpumask:
 	free_cpumask_var(buffer->cpumask);
 
- fail_free_buffer:
-	kfree(buffer);
 	return NULL;
 }
 
@@ -7007,7 +7003,7 @@ static int __rb_map_vma(struct ring_buff
 {
 	unsigned long nr_subbufs, nr_pages, nr_vma_pages, pgoff = vma->vm_pgoff;
 	unsigned int subbuf_pages, subbuf_order;
-	struct page **pages;
+	struct page **pages __free(kfree) = NULL;
 	int p = 0, s = 0;
 	int err;
 
@@ -7075,10 +7071,8 @@ static int __rb_map_vma(struct ring_buff
 		struct page *page;
 		int off = 0;
 
-		if (WARN_ON_ONCE(s >= nr_subbufs)) {
-			err = -EINVAL;
-			goto out;
-		}
+		if (WARN_ON_ONCE(s >= nr_subbufs))
+			return -EINVAL;
 
 		page = virt_to_page((void *)cpu_buffer->subbuf_ids[s]);
 
@@ -7093,9 +7087,6 @@ static int __rb_map_vma(struct ring_buff
 
 	err = vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
 
-out:
-	kfree(pages);
-
 	return err;
 }
 #else


