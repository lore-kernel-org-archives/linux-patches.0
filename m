Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AE3B5319;
	Sat, 17 Oct 2026 17:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257716; cv=none; b=j7ks+/gRcIUAG7pjK3xTHVvdogTS5QDXSxF+Ax3pc62Uvmm6nq5KI4P68g9Pf+zFUJ3WGhD2nierG7jqq7VH6oZjnybXN8HKBtNdRwAeeC2lUqgYVnwvi+jalg0hIAfM++K/0uR5qmc6CLDQUZOUHeb1EtoWqB5aMeROc+E1gjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257716; c=relaxed/simple;
	bh=EH2zQ+Nd7oveNI0hTugQiwZbOGvRDMSgVUh/mblG7WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuPhnpNdBpghzd8fMhyBGNYE2COF71S8SrAcCEO57efiWKPG+9Qy50QoREw82pv8TRUP5yv5cQmMrW4j1V1MoaOIuxHVT7XMo6gBnFPTa3IotP54wO3GuHi+vA+md/Lux80N8szr+4uhWbdl/RQdBpW4kvNYXv9M3JFqpFXfhac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pU6HBRa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pU6HBRa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0D61F000C5;
	Sat, 17 Oct 2026 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257714;
	bh=lAI0+f+hjD8aoxFVovPYoySlInuCKU/yEy4szEqQ1W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pU6HBRa9MS0mlMQnS4oz0pwZHsiqhRBy7Af8glsT98MZqAd41ltcIFtmA4k0O9JA6
	 ddGiMB76mHzff3cOAazMDcx7391A16WSLFPdJGqFze3JQp4w7NQyeftZzyidDZperk
	 TOPS6TrQc1VjgPla8Ig84JGIxQTCBJZOMeDMvN7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0646/1674] mm/slub: avoid zeroing outside-object freepointer for single free
Date: Sat, 17 Oct 2026 17:48:38 +0200
Message-ID: <20261017160447.687610550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 8f828aa48812ced28aa39cb3cfe55ef2444d03dd ]

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
Stable-dep-of: 59090e479ac7 ("mm, slub: avoid zeroing kmalloc redzone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 52 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c27bf00f3f275..9870dd4238ddc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -452,6 +452,26 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
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
@@ -740,26 +760,6 @@ static void print_section(char *level, char *text, u8 *addr,
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
@@ -1808,15 +1808,20 @@ static __always_inline bool slab_free_hook(struct kmem_cache *s,
 	 *
 	 * The initialization memset's clear the object and the metadata,
 	 * but don't touch the SLAB redzone.
+	 *
+	 * The object's freepointer is also avoided if stored outside the
+	 * object.
 	 */
 	if (init) {
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
 	return kasan_slab_free(s, x, init);
@@ -3463,7 +3468,8 @@ static void *__slab_alloc_node(struct kmem_cache *s,
 static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
 						   void *obj)
 {
-	if (unlikely(slab_want_init_on_free(s)) && obj)
+	if (unlikely(slab_want_init_on_free(s)) && obj &&
+	    !freeptr_outside_object(s))
 		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
 			0, sizeof(void *));
 }
-- 
2.53.0



