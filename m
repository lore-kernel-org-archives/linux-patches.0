Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373C611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A47C433C7;
	Mon, 28 Aug 2023 10:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218917;
	bh=+JnsrZKGYYqd4Eog2BPpx674k/QBfgF3GZz/GhAOdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+TweSq7yfcbOAzfHbXw9vaE+mGAj7+2xx83z6Guc5863VJ27nKlSJItMEfLpgx4o
	 Nz184OHEIcXxVB2jhdWNUXAhRxk7Z8j7QLl2uwYVqgk+k6EHEEc1FWcfaR+ckKYLEu
	 JLGTRGdJDISO+SACdPIhVUuZ62OQ5O3DGleLLNYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Fengwei <fengwei.yin@intel.com>,
	Yu Zhao <yuzhao@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Matthew Wilcox <willy@infradead.org>,
	Minchan Kim <minchan@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 110/122] madvise:madvise_free_pte_range(): dont use mapcount() against large folio for sharing check
Date: Mon, 28 Aug 2023 12:13:45 +0200
Message-ID: <20230828101200.083518183@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Yin Fengwei <fengwei.yin@intel.com>

commit 0e0e9bd5f7b9d40fd03b70092367247d52da1db0 upstream.

Commit 98b211d6415f ("madvise: convert madvise_free_pte_range() to use a
folio") replaced the page_mapcount() with folio_mapcount() to check
whether the folio is shared by other mapping.

It's not correct for large folios. folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares.
That means it's not 100% correct. It should be OK for madvise case here.

User-visible effects is that the THP is skipped when user call madvise.
But the correct behavior is THP should be split and processed then.

NOTE: this change is a temporary fix to reduce the user-visible effects
before the long term fix from David is ready.

Link: https://lkml.kernel.org/r/20230808020917.2230692-4-fengwei.yin@intel.com
Fixes: 98b211d6415f ("madvise: convert madvise_free_pte_range() to use a folio")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h |   19 +++++++++++++++++++
 mm/madvise.c       |    4 ++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1727,6 +1727,25 @@ static inline size_t folio_size(struct f
 	return PAGE_SIZE << folio_order(folio);
 }
 
+/**
+ * folio_estimated_sharers - Estimate the number of sharers of a folio.
+ * @folio: The folio.
+ *
+ * folio_estimated_sharers() aims to serve as a function to efficiently
+ * estimate the number of processes sharing a folio. This is done by
+ * looking at the precise mapcount of the first subpage in the folio, and
+ * assuming the other subpages are the same. This may not be true for large
+ * folios. If you want exact mapcounts for exact calculations, look at
+ * page_mapcount() or folio_total_mapcount().
+ *
+ * Return: The estimated number of processes sharing a folio.
+ */
+static inline int folio_estimated_sharers(struct folio *folio)
+{
+	return page_mapcount(folio_page(folio, 0));
+}
+
+
 #ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 static inline int arch_make_page_accessible(struct page *page)
 {
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -654,8 +654,8 @@ static int madvise_free_pte_range(pmd_t
 		 * deactivate all pages.
 		 */
 		if (folio_test_large(folio)) {
-			if (folio_mapcount(folio) != 1)
-				goto out;
+			if (folio_estimated_sharers(folio) != 1)
+				break;
 			folio_get(folio);
 			if (!folio_trylock(folio)) {
 				folio_put(folio);


