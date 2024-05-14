Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4DF69950;
	Tue, 14 May 2024 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683716; cv=none; b=mCS6W1cFogJKxE46nCo18LGaynsDsUj6a7LvxdO/ajVrHBtzpp6ep769JKV/y5M1SH7+ucF2depuAyM6lweE/7RVtHJljA9Aw6XROXaCH5l+VMZIF6g3+nTuCi3D3Oj2OC3X0E3vYG1B7MNI4aSSRYI7FvRhP/RnjOMfG933d3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683716; c=relaxed/simple;
	bh=K4lqH1Ki6RmwCqS7blCXVSdOFsuLglIHoQ9B/8El78U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOZ1I1qkH/yt05+u2Omm++TmFodzwpwSUpXYoF9UVnoKO6RKJtcA682HlPVCzyCdc1gYkcuCm92eYT/FdernVUKesJM1Vtf21tl+XYgotXMCtsXRU/zGzNb9T2JoepmBc+i1LLAeIZ8X+v1LbJZPH7DTqzyiK2sDYquET0hNDYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8JIoqny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8JIoqny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC17DC2BD10;
	Tue, 14 May 2024 10:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683716;
	bh=K4lqH1Ki6RmwCqS7blCXVSdOFsuLglIHoQ9B/8El78U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8JIoqnyY/ZjZhlgoLopnwWiIN1suHMzGZLqTmhVbuIbjvmi18r7WLuzCqrpIS7cC
	 15mJ1PBBSzslVizvbScDl2sLE/62dZRYHBYYhT4dDldhAJ7isMEnA0yMM4Xoheaw9s
	 CUeFd1M3EdmwjeW9CzHWba8icjn3V6yaq8mHTm0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.8 262/336] mm/slub: avoid zeroing outside-object freepointer for single free
Date: Tue, 14 May 2024 12:17:46 +0200
Message-ID: <20240514101048.507239337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

commit 8f828aa48812ced28aa39cb3cfe55ef2444d03dd upstream.

Commit 284f17ac13fe ("mm/slub: handle bulk and single object freeing
separately") splits single and bulk object freeing in two functions
slab_free() and slab_free_bulk() which leads slab_free() to call
slab_free_hook() directly instead of slab_free_freelist_hook().

If `init_on_free` is set, slab_free_hook() zeroes the object.
Afterward, if `slub_debug=F` and `CONFIG_SLAB_FREELIST_HARDENED` are
set, the do_slab_free() slowpath executes freelist consistency
checks and try to decode a zeroed freepointer which leads to a
"Freepointer corrupt" detection in check_object().

During bulk free, slab_free_freelist_hook() isn't affected as it always
sets it objects freepointer using set_freepointer() to maintain its
reconstructed freelist after `init_on_free`.

For single free, object's freepointer thus needs to be avoided when
stored outside the object if `init_on_free` is set. The freepointer left
as is, check_object() may later detect an invalid pointer value due to
objects overflow.

To reproduce, set `slub_debug=FU init_on_free=1 log_level=7` on the
command line of a kernel build with `CONFIG_SLAB_FREELIST_HARDENED=y`.

dmesg sample log:
[   10.708715] =============================================================================
[   10.710323] BUG kmalloc-rnd-05-32 (Tainted: G    B           T ): Freepointer corrupt
[   10.712695] -----------------------------------------------------------------------------
[   10.712695]
[   10.712695] Slab 0xffffd8bdc400d580 objects=32 used=4 fp=0xffff9d9a80356f80 flags=0x200000000000a00(workingset|slab|node=0|zone=2)
[   10.716698] Object 0xffff9d9a80356600 @offset=1536 fp=0x7ee4f480ce0ecd7c
[   10.716698]
[   10.716698] Bytes b4 ffff9d9a803565f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   10.720703] Object   ffff9d9a80356600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   10.720703] Object   ffff9d9a80356610: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   10.724696] Padding  ffff9d9a8035666c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   10.724696] Padding  ffff9d9a8035667c: 00 00 00 00                                      ....
[   10.724696] FIX kmalloc-rnd-05-32: Object at 0xffff9d9a80356600 not freed

Fixes: 284f17ac13fe ("mm/slub: handle bulk and single object freeing separately")
Cc: <stable@vger.kernel.org>
Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   52 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -557,6 +557,26 @@ static inline void set_freepointer(struc
 	*(freeptr_t *)freeptr_addr = freelist_ptr_encode(s, fp, freeptr_addr);
 }
 
+/*
+ * See comment in calculate_sizes().
+ */
+static inline bool freeptr_outside_object(struct kmem_cache *s)
+{
+	return s->offset >= s->inuse;
+}
+
+/*
+ * Return offset of the end of info block which is inuse + free pointer if
+ * not overlapping with object.
+ */
+static inline unsigned int get_info_end(struct kmem_cache *s)
+{
+	if (freeptr_outside_object(s))
+		return s->inuse + sizeof(void *);
+	else
+		return s->inuse;
+}
+
 /* Loop over all objects in a slab */
 #define for_each_object(__p, __s, __addr, __objects) \
 	for (__p = fixup_red_left(__s, __addr); \
@@ -845,26 +865,6 @@ static void print_section(char *level, c
 	metadata_access_disable();
 }
 
-/*
- * See comment in calculate_sizes().
- */
-static inline bool freeptr_outside_object(struct kmem_cache *s)
-{
-	return s->offset >= s->inuse;
-}
-
-/*
- * Return offset of the end of info block which is inuse + free pointer if
- * not overlapping with object.
- */
-static inline unsigned int get_info_end(struct kmem_cache *s)
-{
-	if (freeptr_outside_object(s))
-		return s->inuse + sizeof(void *);
-	else
-		return s->inuse;
-}
-
 static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
@@ -2107,15 +2107,20 @@ bool slab_free_hook(struct kmem_cache *s
 	 *
 	 * The initialization memset's clear the object and the metadata,
 	 * but don't touch the SLAB redzone.
+	 *
+	 * The object's freepointer is also avoided if stored outside the
+	 * object.
 	 */
 	if (unlikely(init)) {
 		int rsize;
+		unsigned int inuse;
 
+		inuse = get_info_end(s);
 		if (!kasan_has_integrated_init())
 			memset(kasan_reset_tag(x), 0, s->object_size);
 		rsize = (s->flags & SLAB_RED_ZONE) ? s->red_left_pad : 0;
-		memset((char *)kasan_reset_tag(x) + s->inuse, 0,
-		       s->size - s->inuse - rsize);
+		memset((char *)kasan_reset_tag(x) + inuse, 0,
+		       s->size - inuse - rsize);
 	}
 	/* KASAN might put x into memory quarantine, delaying its reuse. */
 	return !kasan_slab_free(s, x, init);
@@ -3737,7 +3742,8 @@ static void *__slab_alloc_node(struct km
 static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
 						   void *obj)
 {
-	if (unlikely(slab_want_init_on_free(s)) && obj)
+	if (unlikely(slab_want_init_on_free(s)) && obj &&
+	    !freeptr_outside_object(s))
 		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
 			0, sizeof(void *));
 }


