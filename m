Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F73B4B44B1;
	Thu, 17 Sep 2026 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659482; cv=none; b=n2GcSfGS61+W6C7e9IskmfW7upBFft3Z7fth+c0BbtnwgmplMIlG5iWYNg+52xK9DgkZedKjUTQnnYnctk5sOYowaiGXzZpcQiRNS9sQWnTejJUUOJtWw+IPFFQzC4gP/J7uPqUS0+RfjkqXGRYtrxUp5kdRPaISYP2nvPUNmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659482; c=relaxed/simple;
	bh=ikXFhcDv+5T25fL9EF59YHpkJbma8qtVF6bqRV2i9Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxKaZla4PTZHgnKg4SSD0dLJyg9nUSyM9O1zdBzncwSBjbvC7kdy0CCBkH5Aq2+sG6U+m9R7C9E8Mk6CSHgSrBmBD5ZWH3x/G59DCySe5wUM6iMffPDnakY8TUoAwqSnEsZ1aPvebYhGll/lPeC3yxuw27HTYhXDNo3Wum05iag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0toFVQV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0toFVQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050A61F00898;
	Thu, 17 Sep 2026 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659472;
	bh=dlSFd8oW4zMHYlrhpAOgtjGd/csCg1JyBkS/rzNFPzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0toFVQVeCM00/Y3/NJ3Af+zAMYjMuTCO0gzQTlgA1nHrpX2suBIvbXbWWArevf/r
	 8eoKpDQWuNgyvzGIKFwdXgmj40M/f2EAFH/YMVvpf4R4PQwSXUO7iNOO7PjuHB4pui
	 nxK54W3iktXprT6Jb0gp/xYNtffH/YCLb0QpXrAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 268/733] ring-buffer: Remove ring_buffer_per_cpu::mapped
Date: Thu, 17 Sep 2026 16:09:36 +0100
Message-ID: <20260917151358.017819891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 8b502bf6eb3da15f4b954ad3632335ff10ed746a ]

ring_buffer_per_cpu::mapped tracks if a ring-buffer is either mapped by
user-space or if it is a persistent buffer. We already have user_mapped
for the former and ring_meta for the latter. Get rid of mapped and
instead create rb_is_static(). A static ring-buffer cannot be resized,
swapped or have its pages extracted.

Link: https://patch.msgid.link/20260813131152.3589632-10-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Stable-dep-of: dae8dda341d2 ("tracing: Fix subbuf resize races with trace_pipe_raw readers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 45 ++++++++++++++------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 70e43fe3a1006..86e4c224071b3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -514,7 +514,7 @@ struct ring_buffer_per_cpu {
 	int				cpu;
 	atomic_t			record_disabled;
 	atomic_t			resize_disabled;
-	struct trace_buffer	*buffer;
+	struct trace_buffer		*buffer;
 	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
@@ -552,7 +552,6 @@ struct ring_buffer_per_cpu {
 	/* pages removed since last reset */
 	unsigned long			pages_removed;
 
-	unsigned int			mapped;
 	unsigned int			user_mapped;	/* user space mapping */
 	struct mutex			mapping_lock;
 	struct buffer_page		**subbuf_ids;	/* ID to subbuf VA */
@@ -632,6 +631,11 @@ unsigned long rb_subbuf_start(struct trace_buffer *buffer, unsigned long addr)
 	return addr & ~((unsigned long)(rb_subbuf_size(buffer) - 1));
 }
 
+static bool rb_is_static(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return cpu_buffer->user_mapped || cpu_buffer->remote || cpu_buffer->ring_meta;
+}
+
 struct ring_buffer_iter {
 	struct ring_buffer_per_cpu	*cpu_buffer;
 	unsigned long			head;
@@ -2567,7 +2571,6 @@ rb_allocate_cpu_buffer(struct trace_buffer *buffer, long nr_pages, int cpu)
 		 * Range mapped buffers have the same restrictions as memory
 		 * mapped ones do.
 		 */
-		cpu_buffer->mapped = 1;
 		cpu_buffer->ring_meta = rb_range_meta(buffer, nr_pages, cpu);
 		bpage->page = rb_range_buffer(cpu_buffer, 0);
 		if (!bpage->page)
@@ -6661,12 +6664,11 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	rb_head_page_activate(cpu_buffer);
 	cpu_buffer->pages_removed = 0;
 
-	if (cpu_buffer->mapped) {
-		rb_update_meta_page(cpu_buffer);
-		if (cpu_buffer->ring_meta) {
-			struct ring_buffer_cpu_meta *meta = cpu_buffer->ring_meta;
-			meta->commit_buffer = meta->head_buffer;
-		}
+	rb_update_meta_page(cpu_buffer);
+	if (cpu_buffer->ring_meta) {
+		struct ring_buffer_cpu_meta *meta = cpu_buffer->ring_meta;
+
+		meta->commit_buffer = meta->head_buffer;
 	}
 }
 
@@ -6915,8 +6917,8 @@ int ring_buffer_swap_cpu(struct trace_buffer *buffer_a,
 	cpu_buffer_a = buffer_a->buffers[cpu];
 	cpu_buffer_b = buffer_b->buffers[cpu];
 
-	/* It's up to the callers to not try to swap mapped buffers */
-	if (WARN_ON_ONCE(cpu_buffer_a->mapped || cpu_buffer_b->mapped))
+	/* It's up to the callers to not try to swap static buffers */
+	if (WARN_ON_ONCE(rb_is_static(cpu_buffer_a) || rb_is_static(cpu_buffer_b)))
 		return -EBUSY;
 
 	/* At least make sure the two buffers are somewhat the same */
@@ -7128,7 +7130,6 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	unsigned int size;
 	unsigned int read;
 	u64 save_timestamp;
-	bool force_memcpy;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return -1;
@@ -7167,8 +7168,6 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;
 
-	force_memcpy = cpu_buffer->mapped || cpu_buffer->remote;
-
 	/*
 	 * If this page has been partially read or
 	 * if len is not big enough to read the rest of the page or
@@ -7178,7 +7177,7 @@ int ring_buffer_read_page(struct trace_buffer *buffer,
 	 */
 	if (read || (len < (size - read)) ||
 	    cpu_buffer->reader_page == cpu_buffer->commit_page ||
-	    force_memcpy) {
+	    rb_is_static(cpu_buffer)) {
 		struct buffer_data_page *rpage = cpu_buffer->reader_page->page;
 		unsigned int rpos = read;
 		unsigned int pos = 0;
@@ -7620,11 +7619,7 @@ static int __rb_inc_dec_mapped(struct ring_buffer_per_cpu *cpu_buffer,
 
 	lockdep_assert_held(&cpu_buffer->mapping_lock);
 
-	/* mapped is always greater or equal to user_mapped */
-	if (WARN_ON(cpu_buffer->mapped < cpu_buffer->user_mapped))
-		return -EINVAL;
-
-	if (inc && cpu_buffer->mapped == UINT_MAX)
+	if (inc && cpu_buffer->user_mapped == UINT_MAX)
 		return -EBUSY;
 
 	if (WARN_ON(!inc && cpu_buffer->user_mapped == 0))
@@ -7633,13 +7628,10 @@ static int __rb_inc_dec_mapped(struct ring_buffer_per_cpu *cpu_buffer,
 	mutex_lock(&cpu_buffer->buffer->mutex);
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
-	if (inc) {
+	if (inc)
 		cpu_buffer->user_mapped++;
-		cpu_buffer->mapped++;
-	} else {
+	else
 		cpu_buffer->user_mapped--;
-		cpu_buffer->mapped--;
-	}
 
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 	mutex_unlock(&cpu_buffer->buffer->mutex);
@@ -7811,7 +7803,6 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 	if (!err) {
 		raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 		/* This is the first time it is mapped by user */
-		cpu_buffer->mapped++;
 		cpu_buffer->user_mapped = 1;
 		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 	} else {
@@ -7868,8 +7859,6 @@ int ring_buffer_unmap(struct trace_buffer *buffer, int cpu)
 	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
 	/* This is the last user space mapping */
-	if (!WARN_ON_ONCE(cpu_buffer->mapped < cpu_buffer->user_mapped))
-		cpu_buffer->mapped--;
 	cpu_buffer->user_mapped = 0;
 
 	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-- 
2.53.0



