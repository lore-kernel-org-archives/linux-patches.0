Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E31CAA4;
	Tue, 14 May 2024 11:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686091; cv=none; b=NOIYTi/122DoPKMUsbg3AEPTTG/N+zZuet6nfM4/ldVbVsmKgi0j8iUvcA1BczUYNZ/FO6c1krG8YIIdGXNWWxxoMHMB+E0p9o20sPSagDPGbmhAK0k+KM/A40/A0n66aQC1drMaRJbhLbd16pZV4wb704xkkx6NViyMYqDIVnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686091; c=relaxed/simple;
	bh=uSd9t5ljvbxf4kMubkv9vCyrVBIekMY5A2vXTIrLqOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlZEXRlgObPdszD3fT2tzkWbkbxVDWZBWn75KqCVCk3CDPSWLBYDeuRm7fXSH4HxO+9OkmweiS6jUacPDXZyEn3TOg/HT6qJVYz0EKEJ3se36BrwDUbZfqJ7WR0cSsHheqBJZT5dJCzhj5KFaQ176WYTa0ImWn0qF+nVvE+l+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpIDYvuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpIDYvuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB27AC2BD10;
	Tue, 14 May 2024 11:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686090;
	bh=uSd9t5ljvbxf4kMubkv9vCyrVBIekMY5A2vXTIrLqOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpIDYvuB/aTXZzGkTMGvkhvr/mVy9FMqqREr48YP5eq4NcGx2s2KuLSDD7x565+CT
	 E28UPVyDuKr/V2p4ol/V09CNCl1CuvyFHbhzHvzrfVZD9i/SE9BCbvu9ilRJAwESem
	 8c8pgPuNoQnZKFK3daaXnDeCR3p2jkgMayHwMnfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Colin Cross <ccross@google.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Hugh Dickins <hughd@google.com>,
	kernel test robot <lkp@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/236] mm/hugetlb: add folio support to hugetlb specific flag macros
Date: Tue, 14 May 2024 12:16:11 +0200
Message-ID: <20240514101020.683087227@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit d03c376d9066532551dc56837c7c5490e4fcbbfe ]

Patch series "begin converting hugetlb code to folios", v4.

This patch series starts the conversion of the hugetlb code to operate on
struct folios rather than struct pages.  This removes the ambiguitiy of
whether functions are operating on head pages, tail pages of compound
pages, or base pages.

This series passes the linux test project hugetlb test cases.

Patch 1 adds hugeltb specific page macros that can operate on folios.

Patch 2 adds the private field of the first tail page to struct page.  For
32-bit, _private_1 alinging with page[1].private was confirmed by using
pahole.

Patch 3 introduces hugetlb subpool helper functions which operate on
struct folios. These patches were tested using the hugepage-mmap.c
selftest along with the migratepages command.

Patch 4 converts hugetlb_delete_from_page_cache() to use folios.

Patch 5 adds a folio_hstate() function to get hstate information from a
folio and adds a user of folio_hstate().

Bpftrace was used to track time spent in the free_huge_pages function
during the ltp test cases as it is a caller of the hugetlb subpool
functions. From the histogram, the performance is similar before and
after the patch series.

Time spent in 'free_huge_page'

6.0.0-rc2.master.20220823
@nsecs:
[256, 512)         14770 |@@@@@@@@@@@@@@@@@@@@@@@@@@@
			 |@@@@@@@@@@@@@@@@@@@@@@@@@			      |
[512, 1K)            155 |                                                    |
[1K, 2K)             169 |                                                    |
[2K, 4K)              50 |                                                    |
[4K, 8K)              14 |                                                    |
[8K, 16K)              3 |                                                    |
[16K, 32K)             3 |                                                    |

6.0.0-rc2.master.20220823 + patch series
@nsecs:
[256, 512)         13678 |@@@@@@@@@@@@@@@@@@@@@@@@@@@			      |
			 |@@@@@@@@@@@@@@@@@@@@@@@@@			      |
[512, 1K)            142 |                                                    |
[1K, 2K)             199 |                                                    |
[2K, 4K)              44 |                                                    |
[4K, 8K)              13 |                                                    |
[8K, 16K)              4 |                                                    |
[16K, 32K)             1 |                                                    |

This patch (of 5):

Allow the macros which test, set, and clear hugetlb specific page flags to
take a hugetlb folio as an input.  The macrros are generated as
folio_{test, set, clear}_hugetlb_{restore_reserve, migratable, temporary,
freed, vmemmap_optimized, raw_hwp_unreliable}.

Link: https://lkml.kernel.org/r/20220922154207.1575343-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20220922154207.1575343-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1c6f35ba1604f..0c5326fd3c47a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -625,26 +625,50 @@ enum hugetlb_page_flags {
  */
 #ifdef CONFIG_HUGETLB_PAGE
 #define TESTHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+bool folio_test_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		return test_bit(HPG_##flname, private);		\
+	}							\
 static inline int HPage##uname(struct page *page)		\
 	{ return test_bit(HPG_##flname, &(page->private)); }
 
 #define SETHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+void folio_set_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		set_bit(HPG_##flname, private);			\
+	}							\
 static inline void SetHPage##uname(struct page *page)		\
 	{ set_bit(HPG_##flname, &(page->private)); }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
+static __always_inline						\
+void folio_clear_hugetlb_##flname(struct folio *folio)		\
+	{	void *private = &folio->private;		\
+		clear_bit(HPG_##flname, private);		\
+	}							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ clear_bit(HPG_##flname, &(page->private)); }
 #else
 #define TESTHPAGEFLAG(uname, flname)				\
+static inline bool						\
+folio_test_hugetlb_##flname(struct folio *folio)		\
+	{ return 0; }						\
 static inline int HPage##uname(struct page *page)		\
 	{ return 0; }
 
 #define SETHPAGEFLAG(uname, flname)				\
+static inline void						\
+folio_set_hugetlb_##flname(struct folio *folio) 		\
+	{ }							\
 static inline void SetHPage##uname(struct page *page)		\
 	{ }
 
 #define CLEARHPAGEFLAG(uname, flname)				\
+static inline void						\
+folio_clear_hugetlb_##flname(struct folio *folio)		\
+	{ }							\
 static inline void ClearHPage##uname(struct page *page)		\
 	{ }
 #endif
-- 
2.43.0



