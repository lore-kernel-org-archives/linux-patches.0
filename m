Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE5B32C92B;
	Fri, 17 Oct 2025 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714848; cv=none; b=outuiDTP8Ex/nOsymq8vweaYT8IFUskgZcLyhX6/xbdObnouLWdpwXK9i3DBfhuFyY9Qi+oPYcBdOYQ+o4oNUJEZi9NC7r86YnuYQqB2PdjyAKU+TLa6k/qWzR66CGmC/nz/BjBE3e42MNqMLfanuaRbzEgND7GOX9ngRpJHZ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714848; c=relaxed/simple;
	bh=PclOt5ajjnOK1R7IRthKaWHIgVBWXJiwJiRf74qCCT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cAa+rJyCMvUm8/j1XrwJtu9FdsZcc/rc53Nzs/tXTsraqKOx3TugyuuqPEF2Da9BZaI3hntuyuKgndpaA7MsSfI/oi+NvO4MgZMrDwMDH7j7TJoVROFYgdGOi60fYCCbNxyOhsMEnKm7A3MQc/pcEuNFg4aHMSRRpoQUXQ4ZHqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hClHPAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hClHPAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876D6C116B1;
	Fri, 17 Oct 2025 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714847;
	bh=PclOt5ajjnOK1R7IRthKaWHIgVBWXJiwJiRf74qCCT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hClHPAABQIPpJlDuEOH8/SBhvzaq5qIw007ysLhoGQ+//jZHVhjSDqmDPgviM0s7
	 qUktmU+mj2I4IzmfFJrguubt1ZxyFhrNpgQTBDV1+BpQ/NGNSN2YylwcnUghFUTM2+
	 AibwX9S4DoyKAJrak4I6W8mvmULOjuJu2xDg4TJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 010/371] page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches
Date: Fri, 17 Oct 2025 16:49:45 +0200
Message-ID: <20251017145202.167778211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 95920c2ed02bde551ab654e9749c2ca7bc3100e0 upstream.

Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
boot on his 32-bit parisc machine. The cause of this is the mask is set
too wide, so the page_pool_page_is_pp() incurs false positives which
crashes the machine.

Just disabling the check in page_pool_is_pp() will lead to the page_pool
code itself malfunctioning; so instead of doing this, this patch changes
the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
pointers for page_pool-tagged pages.

The fix relies on the kernel pointers that alias with the pp_magic field
always being above PAGE_OFFSET. With this assumption, we can use the
lowest bit of the value of PAGE_OFFSET as the upper bound of the
PP_DMA_INDEX_MASK, which should avoid the false positives.

Because we cannot rely on PAGE_OFFSET always being a compile-time
constant, nor on it always being >0, we fall back to disabling the
dma_index storage when there are not enough bits available. This leaves
us in the situation we were in before the patch in the Fixes tag, but
only on a subset of architecture configurations. This seems to be the
best we can do until the transition to page types in complete for
page_pool pages.

v2:
- Make sure there's at least 8 bits available and that the PAGE_OFFSET
  bit calculation doesn't wrap

Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Cc: stable@vger.kernel.org # 6.15+
Tested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Tested-by: Helge Deller <deller@gmx.de>
Link: https://patch.msgid.link/20250930114331.675412-1-toke@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h   |   22 ++++++++------
 net/core/page_pool.c |   76 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 66 insertions(+), 32 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct
  * since this value becomes part of PP_SIGNATURE; meaning we can just use the
  * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), and the
  * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_DELTA is
- * 0, we make sure that we leave the two topmost bits empty, as that guarantees
- * we won't mistake a valid kernel pointer for a value we set, regardless of the
- * VMSPLIT setting.
+ * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that value is
+ * known at compile-time.
  *
- * Altogether, this means that the number of bits available is constrained by
- * the size of an unsigned long (at the upper end, subtracting two bits per the
- * above), and the definition of PP_SIGNATURE (with or without
- * POISON_POINTER_DELTA).
+ * If the value of PAGE_OFFSET is not known at compile time, or if it is too
+ * small to leave at least 8 bits available above PP_SIGNATURE, we define the
+ * number of bits to be 0, which turns off the DMA index tracking altogether
+ * (see page_pool_register_dma_index()).
  */
 #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
 #if POISON_POINTER_DELTA > 0
@@ -4175,8 +4174,13 @@ int arch_lock_shadow_stack_status(struct
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
 #else
-/* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+/* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits available; see above */
+#define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
+#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
+			    PAGE_OFFSET >= PP_DMA_INDEX_MIN_OFFSET && \
+			    !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1))) ? \
+			      MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
+
 #endif
 
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -472,11 +472,60 @@ page_pool_dma_sync_for_device(const stru
 	}
 }
 
+static int page_pool_register_dma_index(struct page_pool *pool,
+					netmem_ref netmem, gfp_t gfp)
+{
+	int err = 0;
+	u32 id;
+
+	if (unlikely(!PP_DMA_INDEX_BITS))
+		goto out;
+
+	if (in_softirq())
+		err = xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
+			       PP_DMA_INDEX_LIMIT, gfp);
+	else
+		err = xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
+				  PP_DMA_INDEX_LIMIT, gfp);
+	if (err) {
+		WARN_ONCE(err != -ENOMEM, "couldn't track DMA mapping, please report to netdev@");
+		goto out;
+	}
+
+	netmem_set_dma_index(netmem, id);
+out:
+	return err;
+}
+
+static int page_pool_release_dma_index(struct page_pool *pool,
+				       netmem_ref netmem)
+{
+	struct page *old, *page = netmem_to_page(netmem);
+	unsigned long id;
+
+	if (unlikely(!PP_DMA_INDEX_BITS))
+		return 0;
+
+	id = netmem_get_dma_index(netmem);
+	if (!id)
+		return -1;
+
+	if (in_softirq())
+		old = xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
+	else
+		old = xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
+	if (old != page)
+		return -1;
+
+	netmem_set_dma_index(netmem, 0);
+
+	return 0;
+}
+
 static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t gfp)
 {
 	dma_addr_t dma;
 	int err;
-	u32 id;
 
 	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
 	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
@@ -495,18 +544,10 @@ static bool page_pool_dma_map(struct pag
 		goto unmap_failed;
 	}
 
-	if (in_softirq())
-		err = xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
-			       PP_DMA_INDEX_LIMIT, gfp);
-	else
-		err = xa_alloc_bh(&pool->dma_mapped, &id, netmem_to_page(netmem),
-				  PP_DMA_INDEX_LIMIT, gfp);
-	if (err) {
-		WARN_ONCE(err != -ENOMEM, "couldn't track DMA mapping, please report to netdev@");
+	err = page_pool_register_dma_index(pool, netmem, gfp);
+	if (err)
 		goto unset_failed;
-	}
 
-	netmem_set_dma_index(netmem, id);
 	page_pool_dma_sync_for_device(pool, netmem, pool->p.max_len);
 
 	return true;
@@ -678,8 +719,6 @@ void page_pool_clear_pp_info(netmem_ref
 static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
 							   netmem_ref netmem)
 {
-	struct page *old, *page = netmem_to_page(netmem);
-	unsigned long id;
 	dma_addr_t dma;
 
 	if (!pool->dma_map)
@@ -688,15 +727,7 @@ static __always_inline void __page_pool_
 		 */
 		return;
 
-	id = netmem_get_dma_index(netmem);
-	if (!id)
-		return;
-
-	if (in_softirq())
-		old = xa_cmpxchg(&pool->dma_mapped, id, page, NULL, 0);
-	else
-		old = xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
-	if (old != page)
+	if (page_pool_release_dma_index(pool, netmem))
 		return;
 
 	dma = page_pool_get_dma_addr_netmem(netmem);
@@ -706,7 +737,6 @@ static __always_inline void __page_pool_
 			     PAGE_SIZE << pool->p.order, pool->p.dma_dir,
 			     DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING);
 	page_pool_set_dma_addr_netmem(netmem, 0);
-	netmem_set_dma_index(netmem, 0);
 }
 
 /* Disconnects a page (from a page_pool).  API users can have a need


