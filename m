Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7A4846F;
	Tue, 30 Sep 2025 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245810; cv=none; b=Ythi8y6AIYJVD4eUskvikSpBhcWD2PbsD5hHFFXkXpPqYZN9kvBWv/N9ks8XlQzm3RDLtUu2muoCXEWvJmWzenJ5lML35sGeEiXu1T5IGlE+SLLbBfQZnUZ8xbCh8HiWQHOippqNaK+zTxPlNM2KReGpfpJfKelqgukQ3ZY00z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245810; c=relaxed/simple;
	bh=3Lqj3tCYA6D8ZcffmkAK4z7V2MAKCzD47auxMPcmNF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHSbghcOEXdri64Fg7kMz9LzTi8DQnRTGcLNrBXGB9YDsky0+scRUY7l9c5ZRQPksofAPM5NxlkEWCkHOed+10asNYgFl5vvcevpm2okpDzYXrptiNDnQE7BI65xJKWUWan7830q3mhOptDWfByxTAF8bbQLF4KQi3KN9arO1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PijoQrHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PijoQrHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE6C4CEF0;
	Tue, 30 Sep 2025 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245809;
	bh=3Lqj3tCYA6D8ZcffmkAK4z7V2MAKCzD47auxMPcmNF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PijoQrHog3m2HPy7X6SWfbcrUW908Ocdw1jSR5Qk20RM6hs40VTK9Rt9tm+MbAOWO
	 44gi5wojeWHhvI61JwwXKUFp82yM9NdkitW/uNGNNFJzZE0CwmGSWnCois9/tm8UK/
	 ovUssrC/Hm+z6LYLksNMSLfQZfVmhqPMJH5EgNYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Chris Li <chrisl@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Keir Fraser <keirf@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Li Zhe <lizhe.67@bytedance.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Shivank Garg <shivankg@amd.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Xu <weixugc@google.com>,
	Will Deacon <will@kernel.org>,
	yangge <yangge1116@126.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/91] mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
Date: Tue, 30 Sep 2025 16:47:24 +0200
Message-ID: <20250930143822.185221638@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

[ Upstream commit a09a8a1fbb374e0053b97306da9dbc05bd384685 ]

In many cases, if collect_longterm_unpinnable_folios() does need to drain
the LRU cache to release a reference, the cache in question is on this
same CPU, and much more efficiently drained by a preliminary local
lru_add_drain(), than the later cross-CPU lru_add_drain_all().

Marked for stable, to counter the increase in lru_add_drain_all()s from
"mm/gup: check ref_count instead of lru before migration".  Note for clean
backports: can take 6.16 commit a03db236aebf ("gup: optimize longterm
pin_user_pages() for large folio") first.

Link: https://lkml.kernel.org/r/66f2751f-283e-816d-9530-765db7edc465@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Resolved minor conflicts ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 00ac2df7164c3..5be764395e046 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1953,7 +1953,7 @@ static unsigned long collect_longterm_unpinnable_pages(
 {
 	unsigned long i, collected = 0;
 	struct folio *prev_folio = NULL;
-	bool drain_allow = true;
+	int drained = 0;
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
@@ -1975,10 +1975,17 @@ static unsigned long collect_longterm_unpinnable_pages(
 			continue;
 		}
 
-		if (drain_allow && folio_ref_count(folio) !=
-				   folio_expected_ref_count(folio) + 1) {
+		if (drained == 0 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
+			lru_add_drain();
+			drained = 1;
+		}
+		if (drained == 1 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
-			drain_allow = false;
+			drained = 2;
 		}
 
 		if (!folio_isolate_lru(folio))
-- 
2.51.0



