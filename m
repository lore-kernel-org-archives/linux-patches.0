Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5606520E334;
	Fri,  9 Oct 2026 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555314; cv=none; b=ZMw4imHHKk8mNEyrrr7hIUzJgtdAL0e4ecRMXeqSy1aClUmgkx4cJ6Sog+ofQIiZXiL1wTKyJMYKQV30zrqZbllIBtV3MaNRS6Rq9w+i00oMqPQp1xay+MXHmV41fBEIxUwMxSl7/VuoQYwHMQWiFhRGurg0oc0U+3QiBAGRP00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555314; c=relaxed/simple;
	bh=8X42IEgfCMgEI5pOj0VDVrUEoETGtSsJzABzWW69Pjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA+jHR/kciJDmjOHd/k4d+QfA1PUKvRUa1FfWhTDIOnheD05OeD2Dg6gNwcu+Do5C6kRZl4uEdzY/vOArAEkIDk1nezn2lKuZiU5jUo9gmVpYd3N5Rn8quQU0ptMaAfG39a3H08yBeaqzZqYLmXF53JJF5zTKnGitzqQJKUWyQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwffhI/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwffhI/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761C71F00898;
	Fri,  9 Oct 2026 14:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555308;
	bh=xNrdHP0Xk14jazGJXBZibm1G9XAUI0mZg/1Bg5LrdtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwffhI/7M9glWp0mF7t3bQPTWaUdi8oRneiEccMxIH3hXPeznMAcg/R4k/fL/Hftj
	 OznPmGfZIVBJAoCAYWL6udyb1jnmB1Y+3wvvoEXR/5cWyEp2pzsyf9zrnJ0fMxBqKB
	 vEkNo1QHDfT5iUsVid+Q28Y8cu0gJgkUgLETZ3hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hubert Mazur <hmazur@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Atish Patra <atishp@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/403] mm/execmem: make the populate and alloc atomic
Date: Fri,  9 Oct 2026 16:06:06 +0200
Message-ID: <20261009140952.247073301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Hubert Mazur <hmazur@google.com>

[ Upstream commit 1871d548fc4feb007644efb6d669c93a4e191254 ]

When a block of memory is requested from the execmem manager it tries to
find a suitable fragment by traversing the free_areas.  In case there is
no such block, a new memory area is added to the free_areas and then
allocated to the caller by traversing the free_area tree again.

The above operations of allocation and tree traversal are not atomic hence
another request may consume this newly allocated memory block which
results in the allocation failure for the original request.  Such
occurrence can be spotted on devices running the 6.18 kernel during the
parallel modules loading.

To mitigate such resource races execute the cache population and
allocation operations under one mutex lock.

Link: https://lkml.kernel.org/r/20260320075723.779985-1-hmazur@google.com
Signed-off-by: Hubert Mazur <hmazur@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stanislaw Kardach <skardach@google.com>
Cc: Michal Krawczyk <mikrawczyk@google.com>
Cc: Slawomir Rosek <srosek@google.com>
Cc: Hubert Mazur <hmazur@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Atish Patra <atishp@meta.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/execmem.c | 55 +++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c9243..084a207e4278b 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -203,13 +203,6 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
 }
 
-static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
-{
-	guard(mutex)(&execmem_cache.mutex);
-
-	return execmem_cache_add_locked(ptr, size, gfp_mask);
-}
-
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
 			 size_t size)
 {
@@ -225,18 +218,16 @@ static bool within_range(struct execmem_range *range, struct ma_state *mas,
 	return false;
 }
 
-static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
 	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
 	MA_STATE(mas_free, free_areas, 0, ULONG_MAX);
 	MA_STATE(mas_busy, busy_areas, 0, ULONG_MAX);
-	struct mutex *mutex = &execmem_cache.mutex;
 	unsigned long addr, last, area_size = 0;
 	void *area, *ptr = NULL;
 	int err;
 
-	mutex_lock(mutex);
 	mas_for_each(&mas_free, area, ULONG_MAX) {
 		area_size = mas_range_len(&mas_free);
 
@@ -245,7 +236,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	}
 
 	if (area_size < size)
-		goto out_unlock;
+		return NULL;
 
 	addr = mas_free.index;
 	last = mas_free.last;
@@ -254,7 +245,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		goto out_unlock;
+		return NULL;
 
 	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
 	if (area_size > size) {
@@ -268,19 +259,25 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 		if (err) {
 			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			goto out_unlock;
+			return NULL;
 		}
 	}
 	ptr = (void *)addr;
 
-out_unlock:
-	mutex_unlock(mutex);
 	return ptr;
 }
 
-static int execmem_cache_populate(struct execmem_range *range, size_t size)
+static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+{
+	guard(mutex)(&execmem_cache.mutex);
+
+	return execmem_cache_alloc_locked(range, size);
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
+	struct mutex *mutex = &execmem_cache.mutex;
 	struct vm_struct *vm;
 	size_t alloc_size;
 	int err = -ENOMEM;
@@ -294,7 +291,7 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	}
 
 	if (!p)
-		return err;
+		return NULL;
 
 	vm = find_vm_area(p);
 	if (!vm)
@@ -307,33 +304,39 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
+	/*
+	 * New memory blocks must be allocated and added to the cache
+	 * as an atomic operation, otherwise they may be consumed
+	 * by a parallel call to the execmem_cache_alloc function.
+	 */
+	mutex_lock(mutex);
+	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
 	if (err)
 		goto err_reset_direct_map;
 
-	return 0;
+	p = execmem_cache_alloc_locked(range, size);
+
+	mutex_unlock(mutex);
+
+	return p;
 
 err_reset_direct_map:
+	mutex_unlock(mutex);
 	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
-	return err;
+	return NULL;
 }
 
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
-	int err;
 
 	p = __execmem_cache_alloc(range, size);
 	if (p)
 		return p;
 
-	err = execmem_cache_populate(range, size);
-	if (err)
-		return NULL;
-
-	return __execmem_cache_alloc(range, size);
+	return execmem_cache_populate_alloc(range, size);
 }
 
 static inline bool is_pending_free(void *ptr)
-- 
2.53.0



