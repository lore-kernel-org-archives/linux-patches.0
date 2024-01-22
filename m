Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0A212F5A7;
	Tue, 23 Jan 2024 00:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969024; cv=none; b=PxwB5pjFhSUVnp7pRkYspeFy80Hka8/NfZEA7Bp+D5aCj80BNjGF0f6ylb2usQfV6HvTFjRmGV6m+ONbzsBh3N+U9ZoHcytRjOF7VNSRhfBd6k8I7a9c4sKh8AkvKk1MpBmZCnFck0GZN5nZHH9oE5sRJWFyh5yam/oGVn4OmH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969024; c=relaxed/simple;
	bh=taQyxjREaUUiLs8ZcBXhhEW9wd1OQFun0PNeuZAtsM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdiHG8ZH241r0Edaj4+Kk/VMGpHIdZxmA/1TpLCVEq1FBLXuogZDR+IEwzfs7Y395YHTEjalx533Pp/15+ji5Af/ISqTz467jjwLYXZNqZZ9rO6u2wwoKllFKKHq4DHzlpIA2uTKqDHQldKOPeiTtIetpVDpjHHQUGctkJqsmtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEEc0PfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEEc0PfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E726C433F1;
	Tue, 23 Jan 2024 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969024;
	bh=taQyxjREaUUiLs8ZcBXhhEW9wd1OQFun0PNeuZAtsM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEEc0PfIGiBFFJ4uOKHjYyawiO5bdcz3s+o82+4IdXh22qHLk9qTSe2m5Sp1K/RXa
	 vUe4TRansIQPzbqDXzAkSF78/d3GXhYyi+JgwJY1PNIhyezh7h4zj4zfSnlJzEteZJ
	 qj+xtu1Ljtnz49kyCUJTFnAeBTQ753z6YSDOHnos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>,
	Todd Kjos <tkjos@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/194] binder: print warnings when detecting oneway spamming.
Date: Mon, 22 Jan 2024 15:58:17 -0800
Message-ID: <20240122235726.366071549@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

[ Upstream commit 261e7818f06ec51e488e007f787ccd7e77272918 ]

The most common cause of the binder transaction buffer filling up is a
client rapidly firing oneway transactions into a process, before it has
a chance to handle them. Yet the root cause of this is often hard to
debug, because either the system or the app will stop, and by that time
binder debug information we dump in bugreports is no longer relevant.

This change warns as soon as a process dips below 80% of its oneway
space (less than 100kB available in the configuration), when any one
process is responsible for either more than 50 transactions, or more
than 50% of the oneway space.

Signed-off-by: Martijn Coenen <maco@android.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20200821122544.1277051-1-maco@android.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c6d05e0762ab ("binder: fix unused alloc->free_async_space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c                |  2 +-
 drivers/android/binder_alloc.c          | 55 +++++++++++++++++++++++--
 drivers/android/binder_alloc.h          |  5 ++-
 drivers/android/binder_alloc_selftest.c |  2 +-
 4 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index ca1c67a1126d..5bb2716a59cd 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3425,7 +3425,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 	t->buffer = binder_alloc_new_buf(&target_proc->alloc, tr->data_size,
 		tr->offsets_size, extra_buffers_size,
-		!reply && (t->flags & TF_ONE_WAY));
+		!reply && (t->flags & TF_ONE_WAY), current->tgid);
 	if (IS_ERR(t->buffer)) {
 		/*
 		 * -ESRCH indicates VMA cleared. The target is dying.
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index a331e9f82125..ceb70543ca90 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -339,12 +339,50 @@ static inline struct vm_area_struct *binder_alloc_get_vma(
 	return vma;
 }
 
+static void debug_low_async_space_locked(struct binder_alloc *alloc, int pid)
+{
+	/*
+	 * Find the amount and size of buffers allocated by the current caller;
+	 * The idea is that once we cross the threshold, whoever is responsible
+	 * for the low async space is likely to try to send another async txn,
+	 * and at some point we'll catch them in the act. This is more efficient
+	 * than keeping a map per pid.
+	 */
+	struct rb_node *n = alloc->free_buffers.rb_node;
+	struct binder_buffer *buffer;
+	size_t total_alloc_size = 0;
+	size_t num_buffers = 0;
+
+	for (n = rb_first(&alloc->allocated_buffers); n != NULL;
+		 n = rb_next(n)) {
+		buffer = rb_entry(n, struct binder_buffer, rb_node);
+		if (buffer->pid != pid)
+			continue;
+		if (!buffer->async_transaction)
+			continue;
+		total_alloc_size += binder_alloc_buffer_size(alloc, buffer)
+			+ sizeof(struct binder_buffer);
+		num_buffers++;
+	}
+
+	/*
+	 * Warn if this pid has more than 50 transactions, or more than 50% of
+	 * async space (which is 25% of total buffer size).
+	 */
+	if (num_buffers > 50 || total_alloc_size > alloc->buffer_size / 4) {
+		binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
+			     "%d: pid %d spamming oneway? %zd buffers allocated for a total size of %zd\n",
+			      alloc->pid, pid, num_buffers, total_alloc_size);
+	}
+}
+
 static struct binder_buffer *binder_alloc_new_buf_locked(
 				struct binder_alloc *alloc,
 				size_t data_size,
 				size_t offsets_size,
 				size_t extra_buffers_size,
-				int is_async)
+				int is_async,
+				int pid)
 {
 	struct rb_node *n = alloc->free_buffers.rb_node;
 	struct binder_buffer *buffer;
@@ -487,11 +525,20 @@ static struct binder_buffer *binder_alloc_new_buf_locked(
 	buffer->offsets_size = offsets_size;
 	buffer->async_transaction = is_async;
 	buffer->extra_buffers_size = extra_buffers_size;
+	buffer->pid = pid;
 	if (is_async) {
 		alloc->free_async_space -= size;
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_alloc_buf size %zd async free %zd\n",
 			      alloc->pid, size, alloc->free_async_space);
+		if (alloc->free_async_space < alloc->buffer_size / 10) {
+			/*
+			 * Start detecting spammers once we have less than 20%
+			 * of async space left (which is less than 10% of total
+			 * buffer size).
+			 */
+			debug_low_async_space_locked(alloc, pid);
+		}
 	}
 	return buffer;
 
@@ -509,6 +556,7 @@ static struct binder_buffer *binder_alloc_new_buf_locked(
  * @offsets_size:       user specified buffer offset
  * @extra_buffers_size: size of extra space for meta-data (eg, security context)
  * @is_async:           buffer for async transaction
+ * @pid:				pid to attribute allocation to (used for debugging)
  *
  * Allocate a new buffer given the requested sizes. Returns
  * the kernel version of the buffer pointer. The size allocated
@@ -521,13 +569,14 @@ struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 					   size_t data_size,
 					   size_t offsets_size,
 					   size_t extra_buffers_size,
-					   int is_async)
+					   int is_async,
+					   int pid)
 {
 	struct binder_buffer *buffer;
 
 	mutex_lock(&alloc->mutex);
 	buffer = binder_alloc_new_buf_locked(alloc, data_size, offsets_size,
-					     extra_buffers_size, is_async);
+					     extra_buffers_size, is_async, pid);
 	mutex_unlock(&alloc->mutex);
 	return buffer;
 }
diff --git a/drivers/android/binder_alloc.h b/drivers/android/binder_alloc.h
index 02a19afd9506..f6052c97bce5 100644
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -33,6 +33,7 @@ struct binder_transaction;
  * @offsets_size:       size of array of offsets
  * @extra_buffers_size: size of space for other objects (like sg lists)
  * @user_data:          user pointer to base of buffer space
+ * @pid:                pid to attribute the buffer to (caller)
  *
  * Bookkeeping structure for binder transaction buffers
  */
@@ -53,6 +54,7 @@ struct binder_buffer {
 	size_t offsets_size;
 	size_t extra_buffers_size;
 	void __user *user_data;
+	int    pid;
 };
 
 /**
@@ -119,7 +121,8 @@ extern struct binder_buffer *binder_alloc_new_buf(struct binder_alloc *alloc,
 						  size_t data_size,
 						  size_t offsets_size,
 						  size_t extra_buffers_size,
-						  int is_async);
+						  int is_async,
+						  int pid);
 extern void binder_alloc_init(struct binder_alloc *alloc);
 extern int binder_alloc_shrinker_init(void);
 extern void binder_alloc_shrinker_exit(void);
diff --git a/drivers/android/binder_alloc_selftest.c b/drivers/android/binder_alloc_selftest.c
index 4151d9938255..c2b323bc3b3a 100644
--- a/drivers/android/binder_alloc_selftest.c
+++ b/drivers/android/binder_alloc_selftest.c
@@ -119,7 +119,7 @@ static void binder_selftest_alloc_buf(struct binder_alloc *alloc,
 	int i;
 
 	for (i = 0; i < BUFFER_NUM; i++) {
-		buffers[i] = binder_alloc_new_buf(alloc, sizes[i], 0, 0, 0);
+		buffers[i] = binder_alloc_new_buf(alloc, sizes[i], 0, 0, 0, 0);
 		if (IS_ERR(buffers[i]) ||
 		    !check_buffer_pages_allocated(alloc, buffers[i],
 						  sizes[i])) {
-- 
2.43.0



