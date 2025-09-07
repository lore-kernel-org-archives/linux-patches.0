Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C6915C158;
	Sun,  7 Sep 2025 20:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277151; cv=none; b=X1DsJg465aROp0AdLysMEL8FtXmmwbpwZSv5DztNxw8/pX28Lb2X8bLl0iZXKcWn0l6eh3esgPsVXPgAL1j9ALDoyHQvVEjI4ASd77GIapkZbQcz3gUeeUEVUb9vh/Ldf+bjOrC91xjYH7oVxjr51JtXTCVrbBvMblLh5ZXRWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277151; c=relaxed/simple;
	bh=I89DFtj0cbv66ObIeIEbxKgPmhStNl1BS3kOeTREldY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ziqu0aet2O/OovtiWd18b9/y+bi2tGci2yHvR5gFZ90hiHrgMbcfcB6nkiEpq0+d2kTrQ7ZrAYdUmysUqnPh4mXFh9TZRAfaTVqpQLUTVsfpQscLdbVSOAyHO5+uH8Nd36m5R8ulSTyzwpMTnq16sUOLQKUYD05vDCnNqql0gVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoJxN8hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoJxN8hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FA3C4CEF0;
	Sun,  7 Sep 2025 20:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277150;
	bh=I89DFtj0cbv66ObIeIEbxKgPmhStNl1BS3kOeTREldY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoJxN8hHPYFtFfgZNS5nZUY8m1irpxp0gKlKHxt0NgVpYUf1iqqIGkM9z4zxzH8JX
	 IVtRRrWGT0okA3yiyMDT2EUKskNv3pj7d1DWgS22mWlBOSbOVLyTGUdd+F8VLlD7sZ
	 N2z3j5apFYPW2TKqdDwdurE0RqnJmmwPHSu/uPKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 101/175] mm: slub: avoid wake up kswapd in set_track_prepare
Date: Sun,  7 Sep 2025 21:58:16 +0200
Message-ID: <20250907195617.241947036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: yangshiguang <yangshiguang@xiaomi.com>

commit 850470a8413a8a78e772c4f6bd9fe81ec6bd5b0f upstream.

set_track_prepare() can incur lock recursion.
The issue is that it is called from hrtimer_start_range_ns
holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
and try to hold the per_cpu(hrtimer_bases)[n].lock.

Avoid deadlock caused by implicitly waking up kswapd by passing in
allocation flags, which do not contain __GFP_KSWAPD_RECLAIM in the
debug_objects_fill_pool() case. Inside stack depot they are processed by
gfp_nested_mask().
Since ___slab_alloc() has preemption disabled, we mask out
__GFP_DIRECT_RECLAIM from the flags there.

The oops looks something like:

BUG: spinlock recursion on CPU#3, swapper/3/0
 lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
Call trace:
spin_bug+0x0
_raw_spin_lock_irqsave+0x80
hrtimer_try_to_cancel+0x94
task_contending+0x10c
enqueue_dl_entity+0x2a4
dl_server_start+0x74
enqueue_task_fair+0x568
enqueue_task+0xac
do_activate_task+0x14c
ttwu_do_activate+0xcc
try_to_wake_up+0x6c8
default_wake_function+0x20
autoremove_wake_function+0x1c
__wake_up+0xac
wakeup_kswapd+0x19c
wake_all_kswapds+0x78
__alloc_pages_slowpath+0x1ac
__alloc_pages_noprof+0x298
stack_depot_save_flags+0x6b0
stack_depot_save+0x14
set_track_prepare+0x5c
___slab_alloc+0xccc
__kmalloc_cache_noprof+0x470
__set_page_owner+0x2bc
post_alloc_hook[jt]+0x1b8
prep_new_page+0x28
get_page_from_freelist+0x1edc
__alloc_pages_noprof+0x13c
alloc_slab_page+0x244
allocate_slab+0x7c
___slab_alloc+0x8e8
kmem_cache_alloc_noprof+0x450
debug_objects_fill_pool+0x22c
debug_object_activate+0x40
enqueue_hrtimer[jt]+0xdc
hrtimer_start_range_ns+0x5f8
...

Signed-off-by: yangshiguang <yangshiguang@xiaomi.com>
Fixes: 5cf909c553e9 ("mm/slub: use stackdepot to save stack trace in objects")
Cc: stable@vger.kernel.org
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -935,19 +935,19 @@ static struct track *get_track(struct km
 }
 
 #ifdef CONFIG_STACKDEPOT
-static noinline depot_stack_handle_t set_track_prepare(void)
+static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	depot_stack_handle_t handle;
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
-	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
+	handle = stack_depot_save(entries, nr_entries, gfp_flags);
 
 	return handle;
 }
 #else
-static inline depot_stack_handle_t set_track_prepare(void)
+static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	return 0;
 }
@@ -969,9 +969,9 @@ static void set_track_update(struct kmem
 }
 
 static __always_inline void set_track(struct kmem_cache *s, void *object,
-				      enum track_item alloc, unsigned long addr)
+				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
 {
-	depot_stack_handle_t handle = set_track_prepare();
+	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
 
 	set_track_update(s, object, alloc, addr, handle);
 }
@@ -1872,9 +1872,9 @@ static inline bool free_debug_processing
 static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
 static inline int check_object(struct kmem_cache *s, struct slab *slab,
 			void *object, u8 val) { return 1; }
-static inline depot_stack_handle_t set_track_prepare(void) { return 0; }
+static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags) { return 0; }
 static inline void set_track(struct kmem_cache *s, void *object,
-			     enum track_item alloc, unsigned long addr) {}
+			     enum track_item alloc, unsigned long addr, gfp_t gfp_flags) {}
 static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
@@ -3822,9 +3822,14 @@ new_objects:
 			 * For debug caches here we had to go through
 			 * alloc_single_from_partial() so just store the
 			 * tracking info and return the object.
+			 *
+			 * Due to disabled preemption we need to disallow
+			 * blocking. The flags are further adjusted by
+			 * gfp_nested_mask() in stack_depot itself.
 			 */
 			if (s->flags & SLAB_STORE_USER)
-				set_track(s, freelist, TRACK_ALLOC, addr);
+				set_track(s, freelist, TRACK_ALLOC, addr,
+					  gfpflags & ~(__GFP_DIRECT_RECLAIM));
 
 			return freelist;
 		}
@@ -3856,7 +3861,8 @@ new_objects:
 			goto new_objects;
 
 		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr);
+			set_track(s, freelist, TRACK_ALLOC, addr,
+				  gfpflags & ~(__GFP_DIRECT_RECLAIM));
 
 		return freelist;
 	}
@@ -4344,8 +4350,12 @@ static noinline void free_to_partial_lis
 	unsigned long flags;
 	depot_stack_handle_t handle = 0;
 
+	/*
+	 * We cannot use GFP_NOWAIT as there are callsites where waking up
+	 * kswapd could deadlock
+	 */
 	if (s->flags & SLAB_STORE_USER)
-		handle = set_track_prepare();
+		handle = set_track_prepare(__GFP_NOWARN);
 
 	spin_lock_irqsave(&n->list_lock, flags);
 


