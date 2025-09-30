Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5372FB0BE;
	Tue, 30 Sep 2025 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246123; cv=none; b=Ka02bQrUQU3HEphEFYvghyY/WJcl/3Pw9JtkYeRNt1XDH9bKD3kc6DGma7CPAoqo35DA6ZEMnu0+vwFMfnzGxy4Ytd0P4cgy7v57DTqeJXdKJf1ZKSb+EWoIK8IRHH0j8HZbHEDLcPW3orivLMMoNut0N20tigAUvX66UPRVLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246123; c=relaxed/simple;
	bh=ZfR5OdBuMsu6RJrBJehd+W/SrXYT7zkIwR7r7Xpxvro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbFSAY7tcj5GRdA3LSl6mkkrCxfG20oZ8b5dKpbq2a+uNSK18kdVNvxEHnDvTKHahhN8so6ksxrt4fDZJ9d6T+GMCBDmIbcZsxHYlewut+0tABogNY8pyICn0e3KLNKohO1pgdlXtgOaxUOycFw7Ju+U2rgbgRnJPDoP4YrDgM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih12AP3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih12AP3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0993FC4CEF0;
	Tue, 30 Sep 2025 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246122;
	bh=ZfR5OdBuMsu6RJrBJehd+W/SrXYT7zkIwR7r7Xpxvro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih12AP3Qs3C0Qb3casRpnStq5ssterN5Q0O+YQup4fI8T4V+tfoYNImgitdqqfekI
	 96vat4kCLqsBEITL5wy40FKeUiMu9TZV43Ljc766Z7a4pD2ZKKm4NKJdP+qvbyYRFJ
	 L7wUsdz15SukI/UgwCQvvccWN09RT+YKCq12HJbU=
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
Subject: [PATCH 6.12 58/89] mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
Date: Tue, 30 Sep 2025 16:48:12 +0200
Message-ID: <20250930143824.320343752@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Clean cherry-pick now into this tree ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index e9be7c49542a0..4dd0eb70988b2 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2356,8 +2356,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct pages_or_folios *pofs)
 {
 	unsigned long collected = 0;
-	bool drain_allow = true;
 	struct folio *folio;
+	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2376,10 +2376,17 @@ static unsigned long collect_longterm_unpinnable_folios(
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



