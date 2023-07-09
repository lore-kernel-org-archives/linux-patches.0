Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996AC522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081C4C43397;
	Sun,  9 Jul 2023 11:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901281;
	bh=LZtVAwtME7iP+q2uqEAfoqIyf7Iti8DPLXHXcXXzCPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeAQfhxfDbF8R6LZ+6VIEXDlsxd7xTGQpkNasyNrztjTGoEQti3FfupZ07y/ztDXJ
	 unR1keXhl7boECRqn8n3ZLQzpcGPb/rFcJPYCz4iv4SYHHA8hW5R19i9endgRNyEmY
	 qsjkJpWZUSIZH5K87F/T8Of5WEBxHMbUnp8lZXLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 6/8] bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page
Date: Sun,  9 Jul 2023 13:14:12 +0200
Message-ID: <20230709111345.488184873@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111345.297026264@linuxfoundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

commit 028725e73375a1ff080bbdf9fb503306d0116f28 upstream.

commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
put_page_bootmem") fix an overlaps existing problem of kmemleak.  But the
problem still existed when HAVE_BOOTMEM_INFO_NODE is disabled, because in
this case, free_bootmem_page() will call free_reserved_page() directly.

Fix the problem by adding kmemleak_free_part() in free_bootmem_page() when
HAVE_BOOTMEM_INFO_NODE is disabled.

Link: https://lkml.kernel.org/r/20230704101942.2819426-1-liushixin2@huawei.com
Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bootmem_info.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/bootmem_info.h
+++ b/include/linux/bootmem_info.h
@@ -3,6 +3,7 @@
 #define __LINUX_BOOTMEM_INFO_H
 
 #include <linux/mm.h>
+#include <linux/kmemleak.h>
 
 /*
  * Types for free bootmem stored in page->lru.next. These have to be in
@@ -59,6 +60,7 @@ static inline void get_page_bootmem(unsi
 
 static inline void free_bootmem_page(struct page *page)
 {
+	kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 	free_reserved_page(page);
 }
 #endif


