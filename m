Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213566;
	b=EDjf5xx6qt2uQYAkwkGu8vxZqOVvdWyDyP2yQiU2BZzZMIywYn5+CmDXyPYJjOfBl+KO
	 6gUzi8sun8rEbvVVrBJ/4v46ip6CXoEwDu8NIi0KvkIqgtfD57BeJYIwQ84GM6+/MVmeq
	 bgTL5tsfLxD3QzH7jDEOTUCdki5hDtVchVY0p5LDCLiDcOR7Nf02xUH8gr2hN7h8M1zEX
	 wr1Ecy84mU1UTfVcIZXdZF29lCG/oYCVeQw9BxusopLhR4ZNLgCqNWKq1mE8Y1sDa33R6
	 JSJh3zk8zDXzA1UFTIkMrldCIduFIx+ZUo4dZao8YadkZJmc3CbYfMXtlGMOne3zUuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nq3nw1XHTnBI3fqdC9CN+rV15wZ/ewU7h+1VTUY3feY=;
	b=hvDvyMtpDZLFMkmUSkwiM8hiifTjGEQ5goLWrGqn2cEj2NZukKsmmfL1ngHaY5HlFPQ1
	 hChdF7fw0IEQmWByDOyEvlHvh7aWNC58X2+l1KK/Q3V8khSqUxrvoCxOcvszdc2uiCE+C
	 +hHN+tK3BNBlJviX38J8nK3FT3L+dmYxYUOsp82c/93yhS+Yok4dCQXnpd4Ar8deDu1Eu
	 3ONzJjMleXusO/F3Lnk7YXSkkv4z5QEPcFMOjAfds5VxF4Als4Q7nAS38KqcBspqruJHR
	 6rg7kf/A8fBXD3v27MoeW+Ie2gIUCz8idAqdtN7mNcp7DwmP46kag9zkQCKi7b7sDRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hxWHKPZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F299606A31A;
	Wed, 28 Oct 2026 18:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxWHKPZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62201F01825;
	Wed, 28 Oct 2026 18:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213566;
	bh=Nq3nw1XHTnBI3fqdC9CN+rV15wZ/ewU7h+1VTUY3feY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxWHKPZ/NguVV3YqVASVge6ZEzgG/AbJgdOPjwp1OmcEvX8kY5WZI59ulvYyz2P+q
	 lh/WEGyKgu42JOp1SLgfpvqlRny1P8jAKDGwmG8FElhYzf5q2mAKMBBmub7ib6g1Fr
	 radJNZZ/D+9rc7uyDxErVK9apT0tfvPLa2x5x53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Xu Yu <xuyu@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0551/1887] mm: migrate: fix getting incorrect page mapping during page migration
Date: Wed, 28 Oct 2026 17:44:07 +0100
Message-ID: <20261028170511.914118225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit d1adb25df7111de83b64655a80b5a135adbded61 ]

When running stress-ng testing, we found below kernel crash after a few hours:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
pc : dentry_name+0xd8/0x224
lr : pointer+0x22c/0x370
sp : ffff800025f134c0
......
Call trace:
  dentry_name+0xd8/0x224
  pointer+0x22c/0x370
  vsnprintf+0x1ec/0x730
  vscnprintf+0x2c/0x60
  vprintk_store+0x70/0x234
  vprintk_emit+0xe0/0x24c
  vprintk_default+0x3c/0x44
  vprintk_func+0x84/0x2d0
  printk+0x64/0x88
  __dump_page+0x52c/0x530
  dump_page+0x14/0x20
  set_migratetype_isolate+0x110/0x224
  start_isolate_page_range+0xc4/0x20c
  offline_pages+0x124/0x474
  memory_block_offline+0x44/0xf4
  memory_subsys_offline+0x3c/0x70
  device_offline+0xf0/0x120
  ......

After analyzing the vmcore, I found this issue is caused by page migration.
The scenario is that, one thread is doing page migration, and we will use the
target page's ->mapping field to save 'anon_vma' pointer between page unmap and
page move, and now the target page is locked and refcount is 1.

Currently, there is another stress-ng thread performing memory hotplug,
attempting to offline the target page that is being migrated. It discovers that
the refcount of this target page is 1, preventing the offline operation, thus
proceeding to dump the page. However, page_mapping() of the target page may
return an incorrect file mapping to crash the system in dump_mapping(), since
the target page->mapping only saves 'anon_vma' pointer without setting
PAGE_MAPPING_ANON flag.

There are seveval ways to fix this issue:
(1) Setting the PAGE_MAPPING_ANON flag for target page's ->mapping when saving
'anon_vma', but this can confuse PageAnon() for PFN walkers, since the target
page has not built mappings yet.
(2) Getting the page lock to call page_mapping() in __dump_page() to avoid crashing
the system, however, there are still some PFN walkers that call page_mapping()
without holding the page lock, such as compaction.
(3) Using target page->private field to save the 'anon_vma' pointer and 2 bits
page state, just as page->mapping records an anonymous page, which can remove
the page_mapping() impact for PFN walkers and also seems a simple way.

So I choose option 3 to fix this issue, and this can also fix other potential
issues for PFN walkers, such as compaction.

Link: https://lkml.kernel.org/r/e60b17a88afc38cb32f84c3e30837ec70b343d2b.1702641709.git.baolin.wang@linux.alibaba.com
Fixes: 64c8902ed441 ("migrate_pages: split unmap_and_move() to _unmap() and _move()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 161ab6e2713d2..72ee6896a2cb2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1010,32 +1010,29 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 }
 
 /*
- * To record some information during migration, we use some unused
- * fields (mapping and private) of struct folio of the newly allocated
- * destination folio.  This is safe because nobody is using them
- * except us.
+ * To record some information during migration, we use unused private
+ * field of struct folio of the newly allocated destination folio.
+ * This is safe because nobody is using it except us.
  */
-union migration_ptr {
-	struct anon_vma *anon_vma;
-	struct address_space *mapping;
+enum {
+	PAGE_WAS_MAPPED = BIT(0),
 };
+
 static void __migrate_folio_record(struct folio *dst,
-				   unsigned long page_was_mapped,
+				   int page_was_mapped,
 				   struct anon_vma *anon_vma)
 {
-	union migration_ptr ptr = { .anon_vma = anon_vma };
-	dst->mapping = ptr.mapping;
-	dst->private = (void *)page_was_mapped;
+	dst->private = (void *)anon_vma + page_was_mapped;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 				   int *page_was_mappedp,
 				   struct anon_vma **anon_vmap)
 {
-	union migration_ptr ptr = { .mapping = dst->mapping };
-	*anon_vmap = ptr.anon_vma;
-	*page_was_mappedp = (unsigned long)dst->private;
-	dst->mapping = NULL;
+	unsigned long private = (unsigned long)dst->private;
+
+	*anon_vmap = (struct anon_vma *)(private & ~PAGE_WAS_MAPPED);
+	*page_was_mappedp = private & PAGE_WAS_MAPPED;
 	dst->private = NULL;
 }
 
-- 
2.53.0



