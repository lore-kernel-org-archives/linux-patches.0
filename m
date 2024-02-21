Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840278B53;
	Wed, 21 Feb 2024 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523505; cv=none; b=AH5/U0jyFuJWjikBQY0VRQ0FEDXKzqtd+/J/h0GNxdihVyn2BL8EvhL1DJV8t3qDQ25YKPpl9+qallri1vnLRTHZhKDrT5rQLC4xDhxdVNvRGz4ymdtHXBEIMohN/xfKpoZBE3jsUQRpwlLlOw8qcRiWObvYvNpgejeTyZ0yE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523505; c=relaxed/simple;
	bh=fMh+B/MycA7TRLU8E6ZJk9VU3wJZgZ8A7pfh5YK4TCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zz5Yl4ne6JlA1Q2Ur67FSC8RbMDWTjuDOxn7XIylmO4Qndbuw9Q5vYhGoR9WWDOvRZyX1AViIFK6OV8DoXpF6dpIt2Was5jlOPBXlojVHS6T5UXWqDYeTzCcB/TzfIa1buE3CBJ1lPvyGhtEGNa/FtaQIJQ7Brm0gZRbWIRfsoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/p0OQT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/p0OQT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48133C433C7;
	Wed, 21 Feb 2024 13:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523502;
	bh=fMh+B/MycA7TRLU8E6ZJk9VU3wJZgZ8A7pfh5YK4TCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/p0OQT9DV4DOdTn4Zn3QlqiT16pQreEAQB6f/X/kw8LP/1mv7PyS1k3V9fk1UOS8
	 qpuI2jDiC9P0fsHMbRfIOfQXk7WqkzDkGNtsXFE7A6xSvCXhP8GhhiMnjgH8SjBBRM
	 ud2sn80V0ASYfJCYvh1DhMGqSwxYbTCz0xaUyZEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/476] dma-buf: add dma_fence_timestamp helper
Date: Wed, 21 Feb 2024 14:07:57 +0100
Message-ID: <20240221130023.775470776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit b83ce9cb4a465b8f9a3fa45561b721a9551f60e3 ]

When a fence signals there is a very small race window where the timestamp
isn't updated yet. sync_file solves this by busy waiting for the
timestamp to appear, but on other ocassions didn't handled this
correctly.

Provide a dma_fence_timestamp() helper function for this and use it in
all appropriate cases.

Another alternative would be to grab the spinlock when that happens.

v2 by teddy: add a wait parameter to wait for the timestamp to show up, in case
   the accurate timestamp is needed and/or the timestamp is not based on
   ktime (e.g. hw timestamp)
v3 chk: drop the parameter again for unified handling

Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 1774baa64f93 ("drm/scheduler: Change scheduled fence track v2")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20230929104725.2358-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-fence-unwrap.c     | 176 +++++++++++++++++++++++++
 drivers/dma-buf/sync_file.c            |   9 +-
 drivers/gpu/drm/scheduler/sched_main.c |   3 +-
 include/linux/dma-fence.h              |  19 +++
 4 files changed, 199 insertions(+), 8 deletions(-)
 create mode 100644 drivers/dma-buf/dma-fence-unwrap.c

diff --git a/drivers/dma-buf/dma-fence-unwrap.c b/drivers/dma-buf/dma-fence-unwrap.c
new file mode 100644
index 000000000000..628af51c81af
--- /dev/null
+++ b/drivers/dma-buf/dma-fence-unwrap.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * dma-fence-util: misc functions for dma_fence objects
+ *
+ * Copyright (C) 2022 Advanced Micro Devices, Inc.
+ * Authors:
+ *	Christian König <christian.koenig@amd.com>
+ */
+
+#include <linux/dma-fence.h>
+#include <linux/dma-fence-array.h>
+#include <linux/dma-fence-chain.h>
+#include <linux/dma-fence-unwrap.h>
+#include <linux/slab.h>
+
+/* Internal helper to start new array iteration, don't use directly */
+static struct dma_fence *
+__dma_fence_unwrap_array(struct dma_fence_unwrap *cursor)
+{
+	cursor->array = dma_fence_chain_contained(cursor->chain);
+	cursor->index = 0;
+	return dma_fence_array_first(cursor->array);
+}
+
+/**
+ * dma_fence_unwrap_first - return the first fence from fence containers
+ * @head: the entrypoint into the containers
+ * @cursor: current position inside the containers
+ *
+ * Unwraps potential dma_fence_chain/dma_fence_array containers and return the
+ * first fence.
+ */
+struct dma_fence *dma_fence_unwrap_first(struct dma_fence *head,
+					 struct dma_fence_unwrap *cursor)
+{
+	cursor->chain = dma_fence_get(head);
+	return __dma_fence_unwrap_array(cursor);
+}
+EXPORT_SYMBOL_GPL(dma_fence_unwrap_first);
+
+/**
+ * dma_fence_unwrap_next - return the next fence from a fence containers
+ * @cursor: current position inside the containers
+ *
+ * Continue unwrapping the dma_fence_chain/dma_fence_array containers and return
+ * the next fence from them.
+ */
+struct dma_fence *dma_fence_unwrap_next(struct dma_fence_unwrap *cursor)
+{
+	struct dma_fence *tmp;
+
+	++cursor->index;
+	tmp = dma_fence_array_next(cursor->array, cursor->index);
+	if (tmp)
+		return tmp;
+
+	cursor->chain = dma_fence_chain_walk(cursor->chain);
+	return __dma_fence_unwrap_array(cursor);
+}
+EXPORT_SYMBOL_GPL(dma_fence_unwrap_next);
+
+/* Implementation for the dma_fence_merge() marco, don't use directly */
+struct dma_fence *__dma_fence_unwrap_merge(unsigned int num_fences,
+					   struct dma_fence **fences,
+					   struct dma_fence_unwrap *iter)
+{
+	struct dma_fence_array *result;
+	struct dma_fence *tmp, **array;
+	ktime_t timestamp;
+	unsigned int i;
+	size_t count;
+
+	count = 0;
+	timestamp = ns_to_ktime(0);
+	for (i = 0; i < num_fences; ++i) {
+		dma_fence_unwrap_for_each(tmp, &iter[i], fences[i]) {
+			if (!dma_fence_is_signaled(tmp)) {
+				++count;
+			} else {
+				ktime_t t = dma_fence_timestamp(tmp);
+
+				if (ktime_after(t, timestamp))
+					timestamp = t;
+			}
+		}
+	}
+
+	/*
+	 * If we couldn't find a pending fence just return a private signaled
+	 * fence with the timestamp of the last signaled one.
+	 */
+	if (count == 0)
+		return dma_fence_allocate_private_stub(timestamp);
+
+	array = kmalloc_array(count, sizeof(*array), GFP_KERNEL);
+	if (!array)
+		return NULL;
+
+	/*
+	 * This trashes the input fence array and uses it as position for the
+	 * following merge loop. This works because the dma_fence_merge()
+	 * wrapper macro is creating this temporary array on the stack together
+	 * with the iterators.
+	 */
+	for (i = 0; i < num_fences; ++i)
+		fences[i] = dma_fence_unwrap_first(fences[i], &iter[i]);
+
+	count = 0;
+	do {
+		unsigned int sel;
+
+restart:
+		tmp = NULL;
+		for (i = 0; i < num_fences; ++i) {
+			struct dma_fence *next;
+
+			while (fences[i] && dma_fence_is_signaled(fences[i]))
+				fences[i] = dma_fence_unwrap_next(&iter[i]);
+
+			next = fences[i];
+			if (!next)
+				continue;
+
+			/*
+			 * We can't guarantee that inpute fences are ordered by
+			 * context, but it is still quite likely when this
+			 * function is used multiple times. So attempt to order
+			 * the fences by context as we pass over them and merge
+			 * fences with the same context.
+			 */
+			if (!tmp || tmp->context > next->context) {
+				tmp = next;
+				sel = i;
+
+			} else if (tmp->context < next->context) {
+				continue;
+
+			} else if (dma_fence_is_later(tmp, next)) {
+				fences[i] = dma_fence_unwrap_next(&iter[i]);
+				goto restart;
+			} else {
+				fences[sel] = dma_fence_unwrap_next(&iter[sel]);
+				goto restart;
+			}
+		}
+
+		if (tmp) {
+			array[count++] = dma_fence_get(tmp);
+			fences[sel] = dma_fence_unwrap_next(&iter[sel]);
+		}
+	} while (tmp);
+
+	if (count == 0) {
+		tmp = dma_fence_allocate_private_stub(ktime_get());
+		goto return_tmp;
+	}
+
+	if (count == 1) {
+		tmp = array[0];
+		goto return_tmp;
+	}
+
+	result = dma_fence_array_create(count, array,
+					dma_fence_context_alloc(1),
+					1, false);
+	if (!result) {
+		tmp = NULL;
+		goto return_tmp;
+	}
+	return &result->base;
+
+return_tmp:
+	kfree(array);
+	return tmp;
+}
+EXPORT_SYMBOL_GPL(__dma_fence_unwrap_merge);
diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index 394e6e1e9686..875ae4b3b047 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -384,13 +384,10 @@ static int sync_fill_fence_info(struct dma_fence *fence,
 		sizeof(info->driver_name));
 
 	info->status = dma_fence_get_status(fence);
-	while (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) &&
-	       !test_bit(DMA_FENCE_FLAG_TIMESTAMP_BIT, &fence->flags))
-		cpu_relax();
 	info->timestamp_ns =
-		test_bit(DMA_FENCE_FLAG_TIMESTAMP_BIT, &fence->flags) ?
-		ktime_to_ns(fence->timestamp) :
-		ktime_set(0, 0);
+		dma_fence_is_signaled(fence) ?
+			ktime_to_ns(dma_fence_timestamp(fence)) :
+			ktime_set(0, 0);
 
 	return info->status;
 }
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 67382621b429..e827e8a83c4e 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -698,8 +698,7 @@ drm_sched_get_cleanup_job(struct drm_gpu_scheduler *sched)
 						typeof(*next), list);
 		if (next)
 			next->s_fence->scheduled.timestamp =
-				job->s_fence->finished.timestamp;
-
+				dma_fence_timestamp(&job->s_fence->finished);
 	} else {
 		job = NULL;
 		/* queue timeout for next job */
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 6ffb4b2c6371..9d276655cc25 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -551,6 +551,25 @@ static inline void dma_fence_set_error(struct dma_fence *fence,
 	fence->error = error;
 }
 
+/**
+ * dma_fence_timestamp - helper to get the completion timestamp of a fence
+ * @fence: fence to get the timestamp from.
+ *
+ * After a fence is signaled the timestamp is updated with the signaling time,
+ * but setting the timestamp can race with tasks waiting for the signaling. This
+ * helper busy waits for the correct timestamp to appear.
+ */
+static inline ktime_t dma_fence_timestamp(struct dma_fence *fence)
+{
+	if (WARN_ON(!test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags)))
+		return ktime_get();
+
+	while (!test_bit(DMA_FENCE_FLAG_TIMESTAMP_BIT, &fence->flags))
+		cpu_relax();
+
+	return fence->timestamp;
+}
+
 signed long dma_fence_wait_timeout(struct dma_fence *,
 				   bool intr, signed long timeout);
 signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
-- 
2.43.0



