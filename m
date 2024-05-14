Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCB45FDD2;
	Tue, 14 May 2024 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686067; cv=none; b=g2wZX0cT20JzQr2dIbS2VEPx1mR2w6PSAqdYJMHtX7o5cq4Babyy7fn0B7kfFN2MTm7GsJrF09bMgeLdj13xhoBoZtpgTRhBTxXjRznRpO8uWwlfLcFDf9JfM8Cp1P+fnf3QweeDqMLMs0QJMnCiQHodecgNvADjwni99T2Qizk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686067; c=relaxed/simple;
	bh=lEzs8hNTEm3I3jovpZzbZg2vzA5Dz178l5eX+yosyRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcsJS1rcq/mqDDV0LYwfAG/ADN352LSfNJEQPnrcW1QUzzVPw9ZmkcgPIvST45zgV9Osnk07/Z+zjaNqRHxQqUIEx2DQP1QuuT+JaF2gIS/ro+E4z7/RvkInZGlJhBN67OYENAvAFkXpS1psI1s50f/vMsiqu16Iqdswmkc0IiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9WZ23Ko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9WZ23Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF574C2BD10;
	Tue, 14 May 2024 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686067;
	bh=lEzs8hNTEm3I3jovpZzbZg2vzA5Dz178l5eX+yosyRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9WZ23Ko4PrAAwvPpwjWTsye0Qtmz0xIJH2IurGEDcmgcInpltQ3HpQvJeYgthluo
	 eyeVaZG7rsfgKrkoctFYd6DJbCbo+2ViNy8KNyO6U+FOEw6OJel1CcBzjXxF+tlErj
	 QAjcwSNmigRk0UpPNguU580Dnz7znE/yvP6qH/oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Colin Cross <ccross@google.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Hugh Dickins <hughd@google.com>,
	kernel test robot <lkp@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Peter Xu <peterx@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/236] mm: add private field of first tail to struct page and struct folio
Date: Tue, 14 May 2024 12:16:12 +0200
Message-ID: <20240514101020.720859275@linuxfoundation.org>
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

[ Upstream commit d340625f4849ab5dbfebbc7d84709fbfcd39e52f ]

Allow struct folio to store hugetlb metadata that is contained in the
private field of the first tail page.  On 32-bit, _private_1 aligns with
page[1].private.

Link: https://lkml.kernel.org/r/20220922154207.1575343-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 247aedb18d5c3..a9c1d611029d1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -144,6 +144,7 @@ struct page {
 			atomic_t compound_pincount;
 #ifdef CONFIG_64BIT
 			unsigned int compound_nr; /* 1 << compound_order */
+			unsigned long _private_1;
 #endif
 		};
 		struct {	/* Second tail page of compound page */
@@ -264,6 +265,7 @@ struct page {
  * @_total_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
+ * @_private_1: Do not use directly, call folio_get_private_1().
  *
  * A folio is a physically, virtually and logically contiguous set
  * of bytes.  It is a power-of-two in size, and it is aligned to that
@@ -311,6 +313,7 @@ struct folio {
 #ifdef CONFIG_64BIT
 	unsigned int _folio_nr_pages;
 #endif
+	unsigned long _private_1;
 };
 
 #define FOLIO_MATCH(pg, fl)						\
@@ -338,6 +341,7 @@ FOLIO_MATCH(compound_mapcount, _total_mapcount);
 FOLIO_MATCH(compound_pincount, _pincount);
 #ifdef CONFIG_64BIT
 FOLIO_MATCH(compound_nr, _folio_nr_pages);
+FOLIO_MATCH(_private_1, _private_1);
 #endif
 #undef FOLIO_MATCH
 
@@ -383,6 +387,16 @@ static inline void *folio_get_private(struct folio *folio)
 	return folio->private;
 }
 
+static inline void folio_set_private_1(struct folio *folio, unsigned long private)
+{
+	folio->_private_1 = private;
+}
+
+static inline unsigned long folio_get_private_1(struct folio *folio)
+{
+	return folio->_private_1;
+}
+
 struct page_frag_cache {
 	void * va;
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-- 
2.43.0



