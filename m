Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039083;
	b=5hPDEHe7rSaN9JXjY3V92OGNNEYpM47nT5pJdix019VJiz+cVYCh+kkBVISc/6Rt7Xn3
	 b8bUtGLZqRbgEiD+4kt3CjgmXKXJBI88TYJoxecnaxFV5lCfg5rZfM4wHZYR9MY+T1M4r
	 2UmoJIoHzUP+JPj5VvzqnbuB7Ed3xOPTx1Oy8vyX3JDV/FP/Ztkl4uEizE3xsm7ItvAkb
	 HICZECI6rFVRTEhnYDJfTKvMu6S+sl8ZWOYcndxZ4upa2BufoJPaYRpYEt/gfCPmlekxn
	 gGozV/1MtU52AwlWBtpj3IoGzdR6NH02wH7IIqgs5c1Jh/+CwH1zANszzNKWpqG4m/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kOeJOUqYaSi2Y1inJZ4HR6y1F28ZNuUuLpEKv68nCEg=;
	b=IQVns4QmPN8u0JNU2B/ZC1hnHr1kUyG3g4iOuwaEigBki+0fvaBBD1e2YEm1uinyrQeN
	 d/NhaA+BkkYGL82Woog0Jx1TVERXu2k2ThAXgixi2TlwxnqZGlhK0jAa9b+QEvcGoKLTn
	 hPicl2W9NxE6B9qdJeJNN+WSReGPxIvcOkcluc8el4JgulcdOkETtWHyUzm869elV8IFz
	 /ry/kNdgaxRxmA/JuuZA8sU6DMz3JBiARnQ8qisxRlBhqeESnqU53F6jHYcdZD5+dWnt4
	 mlXqC7bCzQ5tf9zMDiSxkHewptmhYOR/XWNaOzvrsj6w9b3rNE+kEuNFe79WChs0VRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afyznIRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DBB606A32A;
	Wed, 18 Nov 2026 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afyznIRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0016B1F000C4;
	Wed, 18 Nov 2026 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039083;
	bh=kOeJOUqYaSi2Y1inJZ4HR6y1F28ZNuUuLpEKv68nCEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afyznIRL3inYU8T/XsE7csamsYL37hs23IhL38ahI0CfYo1qRNy2HfWWUSA/4uyCW
	 0tEEQ0KxtNaMfPFa6YaTnHr3f39OjWJMPohIvo3NxlzZ7J2Js5/o6ZJQEDTCxaJWVl
	 N34t1GfrErs1oLtv/SdR5H3QowpLJ2ScFjs4BSOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1974/3318] mm/migrate: snapshot the source nid before the misplaced migration
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118150421.299975438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit fe623a81ad9eddf10059b4e44bca0440d9120613 ]

A successful migration frees the source folio before the promotion
counter update, so the folio_nid() read there operates on a freed
folio — which may already have been reallocated. It happens to work
today, as Zi explained:

  : Strictly speaking, it can be seen as a benign UAF. It works, because
  : 1. folio->flags happens to be the same as page->flags,
  : 2. folio/page nid is stored in the ->flags and never changed.
  :
  : In memdesc world, after a folio is freed, I assume folio->flags would be
  : zeroed since struct folio is freed and calling folio_nid() on a freed
  : folio would give a bogus result (yeah, it can be mitigated by not
  : zeroing node field and each node has its own struct folio pool, but that
  : makes folio_nid() implementation dependent).

and Matthew explained further:

  : once struct folio is separately allocated, it's a UAF.  It could be
  : recycled to a different NID or maybe the slab containing the folio could
  : be freed (assuming we're not holding the RCU read lock at this point in
  : migration, and I don't see why we would be).

A separate concern is memory hot-removal.  With memory-tiering mode
enabled, successful migration can release the source before the
promotion-accounting folio_nid() read.  If the task is preempted there,
an otherwise-free source block can be offlined and removed first.  On
the x86 path, removal can unmap the source's vmemmap, so the later read
can fault.  The snapshot avoids that read.

Link: https://lore.kernel.org/20261027021721.95781-1-laoar.shao@gmail.com
Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
[ sashal: Replaced folio_nid(folio) with page_to_nid(page) to fit migrate_misplaced_page(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 0b8c4fe36c714..8612b22aa08ed 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2572,6 +2572,7 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 	int isolated;
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = page_to_nid(page);
 	LIST_HEAD(migratepages);
 	int nr_pages = thp_nr_pages(page);
 
@@ -2609,7 +2610,7 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 	}
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (!node_is_toptier(page_to_nid(page)) && node_is_toptier(node))
+		if (!node_is_toptier(src_node) && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
-- 
2.53.0



