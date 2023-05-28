Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00007611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820EAC433D2;
	Sun, 28 May 2023 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302516;
	bh=GQXlHT8Ggqn768bbJc7ia+KykEjCZqY21P8YhzMs7Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K06eYN/tzDpqtg9XWhCMVMKuHngX6yuUblkSeht/hTHG7eewJM07TvqPgtIaZhEiJ
	 7tE8A32CLJd4xgZgUiNf+5FvO/w5gdu9w7sih7XZJbTYdyQxkZZqyfJLwES9Tta6AO
	 tssU7izv0OcrNIH8QWuH6u3bPnp+BPTrlmWJSfZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-parisc@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	stable@kernel.org
Subject: [PATCH 6.1 034/119] parisc: Fix flush_dcache_page() for usage from irq context
Date: Sun, 28 May 2023 20:10:34 +0100
Message-Id: <20230528190836.501279600@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 61e150fb310729c98227a5edf6e4a3619edc3702 upstream.

Since at least kernel 6.1, flush_dcache_page() is called with IRQs
disabled, e.g. from aio_complete().

But the current implementation for flush_dcache_page() on parisc
unintentionally re-enables IRQs, which may lead to deadlocks.

Fix it by using xa_lock_irqsave() and xa_unlock_irqrestore()
for the flush_dcache_mmap_*lock() macros instead.

Cc: linux-parisc@vger.kernel.org
Cc: stable@kernel.org # 5.18+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/cacheflush.h | 4 ++++
 arch/parisc/kernel/cache.c           | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 0bdee6724132..c8b6928cee1e 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -48,6 +48,10 @@ void flush_dcache_page(struct page *page);
 
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)
 
 #define flush_icache_page(vma,page)	do { 		\
 	flush_kernel_dcache_page_addr(page_address(page)); \
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 1d3b8bc8a623..ca4a302d4365 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -399,6 +399,7 @@ void flush_dcache_page(struct page *page)
 	unsigned long offset;
 	unsigned long addr, old_addr = 0;
 	unsigned long count = 0;
+	unsigned long flags;
 	pgoff_t pgoff;
 
 	if (mapping && !mapping_mapped(mapping)) {
@@ -420,7 +421,7 @@ void flush_dcache_page(struct page *page)
 	 * to flush one address here for them all to become coherent
 	 * on machines that support equivalent aliasing
 	 */
-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
 		addr = mpnt->vm_start + offset;
@@ -460,7 +461,7 @@ void flush_dcache_page(struct page *page)
 		}
 		WARN_ON(++count == 4096);
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }
 EXPORT_SYMBOL(flush_dcache_page);
 
-- 
2.40.1



