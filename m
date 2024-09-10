Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CACD19048F;
	Tue, 10 Sep 2024 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963148; cv=none; b=sBjVe9TXmgIzc+WZS2pv0+XVCd3o9k7414+dA3awlbr48eaxicZGpF6DQkPBKcE3XgjnUYQ0dVhlvXKWIV9pgLxGdfy9ztCY73TrfVVBO3F24yGdC7MSTltezuzaf0pq6itwqv3pxWb9GVJB08ghryrEn4KemAdpKcQBfKigJGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963148; c=relaxed/simple;
	bh=jopl3DXQQFqUkfSWX0flqp2twI41ixxxw1F5bRovLtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMFfKa6NMQwhV0T6SWqJgGenCLATE3l5xAzj/xoNvofiB9MpQy7hr+xczrfrAHtrZ7U/9bYcKRvFODi9mvaUtY4/A9mRgyxkuuIKIWmWoNYCy5ECprBx9vKq+E1d8YqySyA2a6FhNtIBB6DibzCAN8mI75LdYS3e6uBGoGb3PgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN58Nw45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN58Nw45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E245C4CEC3;
	Tue, 10 Sep 2024 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963147;
	bh=jopl3DXQQFqUkfSWX0flqp2twI41ixxxw1F5bRovLtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN58Nw45QuN0Q/rvgKxDRQwn8Lan149YtupuMs5PsS1GsZxBz62yNoHa+YD4uanEA
	 slZXflNwxnY6dD+u8BEgqNNF6Bilf0W+Bd8tqkMEdjNU/MoiFzVwtfb8ZS+QN1BArg
	 aITteqUzeGkjNQwOS3jbhqF2tZPkWyjzGZzB5/4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ole <ole@binarygecko.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 152/192] perf/aux: Fix AUX buffer serialization
Date: Tue, 10 Sep 2024 11:32:56 +0200
Message-ID: <20240910092604.213487622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 2ab9d830262c132ab5db2f571003d80850d56b2a upstream.

Ole reported that event->mmap_mutex is strictly insufficient to
serialize the AUX buffer, add a per RB mutex to fully serialize it.

Note that in the lock order comment the perf_event::mmap_mutex order
was already wrong, that is, it nesting under mmap_lock is not new with
this patch.

Fixes: 45bfb2e50471 ("perf: Add AUX area to ring buffer for raw data streams")
Reported-by: Ole <ole@binarygecko.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c        |   18 ++++++++++++------
 kernel/events/internal.h    |    1 +
 kernel/events/ring_buffer.c |    2 ++
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1277,8 +1277,9 @@ static void put_ctx(struct perf_event_co
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
  *	      perf_event_context::lock
- *	    perf_event::mmap_mutex
  *	    mmap_lock
+ *	      perf_event::mmap_mutex
+ *	        perf_buffer::aux_mutex
  *	      perf_addr_filters_head::lock
  *
  *    cpu_hotplug_lock
@@ -6181,12 +6182,11 @@ static void perf_mmap_close(struct vm_ar
 		event->pmu->event_unmapped(event, vma->vm_mm);
 
 	/*
-	 * rb->aux_mmap_count will always drop before rb->mmap_count and
-	 * event->mmap_count, so it is ok to use event->mmap_mutex to
-	 * serialize with perf_mmap here.
+	 * The AUX buffer is strictly a sub-buffer, serialize using aux_mutex
+	 * to avoid complications.
 	 */
 	if (rb_has_aux(rb) && vma->vm_pgoff == rb->aux_pgoff &&
-	    atomic_dec_and_mutex_lock(&rb->aux_mmap_count, &event->mmap_mutex)) {
+	    atomic_dec_and_mutex_lock(&rb->aux_mmap_count, &rb->aux_mutex)) {
 		/*
 		 * Stop all AUX events that are writing to this buffer,
 		 * so that we can free its AUX pages and corresponding PMU
@@ -6203,7 +6203,7 @@ static void perf_mmap_close(struct vm_ar
 		rb_free_aux(rb);
 		WARN_ON_ONCE(refcount_read(&rb->aux_refcount));
 
-		mutex_unlock(&event->mmap_mutex);
+		mutex_unlock(&rb->aux_mutex);
 	}
 
 	if (atomic_dec_and_test(&rb->mmap_count))
@@ -6291,6 +6291,7 @@ static int perf_mmap(struct file *file,
 	struct perf_event *event = file->private_data;
 	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
+	struct mutex *aux_mutex = NULL;
 	struct perf_buffer *rb = NULL;
 	unsigned long locked, lock_limit;
 	unsigned long vma_size;
@@ -6339,6 +6340,9 @@ static int perf_mmap(struct file *file,
 		if (!rb)
 			goto aux_unlock;
 
+		aux_mutex = &rb->aux_mutex;
+		mutex_lock(aux_mutex);
+
 		aux_offset = READ_ONCE(rb->user_page->aux_offset);
 		aux_size = READ_ONCE(rb->user_page->aux_size);
 
@@ -6489,6 +6493,8 @@ unlock:
 		atomic_dec(&rb->mmap_count);
 	}
 aux_unlock:
+	if (aux_mutex)
+		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
 	/*
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -40,6 +40,7 @@ struct perf_buffer {
 	struct user_struct		*mmap_user;
 
 	/* AUX area */
+	struct mutex			aux_mutex;
 	long				aux_head;
 	unsigned int			aux_nest;
 	long				aux_wakeup;	/* last aux_watermark boundary crossed by aux_head */
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -332,6 +332,8 @@ ring_buffer_init(struct perf_buffer *rb,
 	 */
 	if (!rb->nr_pages)
 		rb->paused = 1;
+
+	mutex_init(&rb->aux_mutex);
 }
 
 void perf_aux_output_flag(struct perf_output_handle *handle, u64 flags)


