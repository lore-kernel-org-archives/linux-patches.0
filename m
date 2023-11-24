Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D693A8C6;
	Fri, 24 Nov 2023 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKsNPaTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2036C433C8;
	Fri, 24 Nov 2023 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849970;
	bh=4JbaNmKtHByQnhM7dPW52IcNtrz7YWvih5ZvXs8Lqcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKsNPaTjh9eQ54OA+jCgo4IoPq4UEIIgsy29Escwwtf7q1LSHFZemuLIgJ18/o3F0
	 G4iq9Ld9LvxgjXc4J5wMZ90hfw5aU3hkDc1XJBG8vOdUo1j8rEaKc/ejz+DC9wr/jp
	 FiZdTcC/JJx044hc0ZtEnigdeNC9Gd80/HMpQA5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.6 376/530] s390/mm: add missing arch_set_page_dat() call to gmap allocations
Date: Fri, 24 Nov 2023 17:49:02 +0000
Message-ID: <20231124172039.457476291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 1954da4a2b621a3328a63382cae7e5f5e2af502c upstream.

If the cmma no-dat feature is available all pages that are not used for
dynamic address translation are marked as "no-dat" with the ESSA
instruction. This information is visible to the hypervisor, so that the
hypervisor can optimize purging of guest TLB entries. This also means that
pages which are used for dynamic address translation must not be marked as
"no-dat", since the hypervisor may then incorrectly not purge guest TLB
entries.

Region, segment, and page tables allocated within the gmap code are
incorrectly marked as "no-dat", since an explicit call to
arch_set_page_dat() is missing, which would remove the "no-dat" mark.

In order to fix this add a new gmap_alloc_crst() function which should
be used to allocate region and segment tables, and which also calls
arch_set_page_dat().

Also add the arch_set_page_dat() call to page_table_alloc_pgste().

Cc: <stable@vger.kernel.org>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/gmap.c    |   24 ++++++++++++++++++------
 arch/s390/mm/pgalloc.c |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -21,10 +21,22 @@
 
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
+#include <asm/page.h>
 #include <asm/tlb.h>
 
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
+static struct page *gmap_alloc_crst(void)
+{
+	struct page *page;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	if (!page)
+		return NULL;
+	arch_set_page_dat(page, CRST_ALLOC_ORDER);
+	return page;
+}
+
 /**
  * gmap_alloc - allocate and initialize a guest address space
  * @limit: maximum address of the gmap address space
@@ -67,7 +79,7 @@ static struct gmap *gmap_alloc(unsigned
 	spin_lock_init(&gmap->guest_table_lock);
 	spin_lock_init(&gmap->shadow_lock);
 	refcount_set(&gmap->ref_count, 1);
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		goto out_free;
 	page->index = 0;
@@ -308,7 +320,7 @@ static int gmap_alloc_table(struct gmap
 	unsigned long *new;
 
 	/* since we dont free the gmap table until gmap_free we can unlock */
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
 	new = page_to_virt(page);
@@ -1759,7 +1771,7 @@ int gmap_shadow_r2t(struct gmap *sg, uns
 
 	BUG_ON(!gmap_is_shadow(sg));
 	/* Allocate a shadow region second table */
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
 	page->index = r2t & _REGION_ENTRY_ORIGIN;
@@ -1843,7 +1855,7 @@ int gmap_shadow_r3t(struct gmap *sg, uns
 
 	BUG_ON(!gmap_is_shadow(sg));
 	/* Allocate a shadow region second table */
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
 	page->index = r3t & _REGION_ENTRY_ORIGIN;
@@ -1927,7 +1939,7 @@ int gmap_shadow_sgt(struct gmap *sg, uns
 
 	BUG_ON(!gmap_is_shadow(sg) || (sgt & _REGION3_ENTRY_LARGE));
 	/* Allocate a shadow segment table */
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
 	page->index = sgt & _REGION_ENTRY_ORIGIN;
@@ -2855,7 +2867,7 @@ int s390_replace_asce(struct gmap *gmap)
 	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
 		return -EINVAL;
 
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	page = gmap_alloc_crst();
 	if (!page)
 		return -ENOMEM;
 	page->index = 0;
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -146,6 +146,7 @@ struct page *page_table_alloc_pgste(stru
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	if (ptdesc) {
 		table = (u64 *)ptdesc_to_virt(ptdesc);
+		arch_set_page_dat(virt_to_page(table), 0);
 		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
 	}


