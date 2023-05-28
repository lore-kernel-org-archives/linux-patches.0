Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AE8611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88E1C433D2;
	Sun, 28 May 2023 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301650;
	bh=K0NUl1YtlPlH6WTIMBjKWd7Wa38VBIFNSQcMk56EWco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Gsl1PRApwWAoN/Rhupn2CZ1X7+yZ4Bme7TvbsezeAWTQrw6XGPvcBEJHGzEJAiiu
	 1vO36ClvbD2Eo3jmikEe/wbzhprRjMSh2x/0/ipDZUHExdUIiYnhtPyNvySxLM+dUr
	 0AbWhdfLTKqF2iEF3MGLPtLrQf2K5zd0fezwakms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-parisc@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	stable@kernel.org
Subject: [PATCH 4.19 112/132] parisc: Fix flush_dcache_page() for usage from irq context
Date: Sun, 28 May 2023 20:10:51 +0100
Message-Id: <20230528190837.193837361@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
 arch/parisc/include/asm/cacheflush.h |    5 +++++
 arch/parisc/kernel/cache.c           |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -57,6 +57,11 @@ extern void flush_dcache_page(struct pag
 
 #define flush_dcache_mmap_lock(mapping)		xa_lock_irq(&mapping->i_pages)
 #define flush_dcache_mmap_unlock(mapping)	xa_unlock_irq(&mapping->i_pages)
+#define flush_dcache_mmap_lock_irqsave(mapping, flags)		\
+		xa_lock_irqsave(&mapping->i_pages, flags)
+#define flush_dcache_mmap_unlock_irqrestore(mapping, flags)	\
+		xa_unlock_irqrestore(&mapping->i_pages, flags)
+
 
 #define flush_icache_page(vma,page)	do { 		\
 	flush_kernel_dcache_page(page);			\
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -309,6 +309,7 @@ void flush_dcache_page(struct page *page
 	struct vm_area_struct *mpnt;
 	unsigned long offset;
 	unsigned long addr, old_addr = 0;
+	unsigned long flags;
 	pgoff_t pgoff;
 
 	if (mapping && !mapping_mapped(mapping)) {
@@ -328,7 +329,7 @@ void flush_dcache_page(struct page *page
 	 * declared as MAP_PRIVATE or MAP_SHARED), so we only need
 	 * to flush one address here for them all to become coherent */
 
-	flush_dcache_mmap_lock(mapping);
+	flush_dcache_mmap_lock_irqsave(mapping, flags);
 	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
 		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
 		addr = mpnt->vm_start + offset;
@@ -351,7 +352,7 @@ void flush_dcache_page(struct page *page
 			old_addr = addr;
 		}
 	}
-	flush_dcache_mmap_unlock(mapping);
+	flush_dcache_mmap_unlock_irqrestore(mapping, flags);
 }
 EXPORT_SYMBOL(flush_dcache_page);
 


