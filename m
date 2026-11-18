Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047666;
	b=0CnclhBZQIY8m0nxbWPyMZ53HulqFHS0niXd2IOjisbk4Iml786hkqq2GMpwOKazO5CO
	 /V8gl9c2Yo2UK8Ungkk7dxmpr/vtXmgBfeEE/bwS0FkgDhH5RuZ2uoOp7bn+Q6G+L6YbA
	 ulqAsD+pu1Qor+r/DpgoMjjniIDdtZHfFW5MXaA9DprNC+iEskliOPcRWtHd8/bkGzf3b
	 SNF/RGRcL8LkYrHa5kzGkg2DFU2FsNK+jjrAf4O0Tuh0vf9Y6NYXJwZymBzYCHzruoe3O
	 lFA3IlHQR94VFf9OGwzMbDpGgKnKl1aDtAkDmZTZgBCEBsZ3ar5/w3ctfep/Yrbt3pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hZN5B5WNlRH+iqDN7QumfhLdn3V1uR+wdoDLJjzNNuQ=;
	b=QqAQSRulO2w1xMCFMmBJHs7he4sBSnkf+UzRSmP31wRzZd17AtmzKPkQ8SvlPTLzTiwL
	 Pc2Td7SvxSQwE05iBkhH5mkoblyj/J2d9iWwQ+fWQWYyfmSjEcJ7HDedjAVtMXk3+Dhxm
	 rDv3oQq28A2GDFEvlayb1RpBGp/xd7szgs522cMns6nXtTZ/O4yKpmuRnpNG0knd6FHJj
	 H8s9X4NDypHUK3BJxbP8jFOdm1ixMjQhgeNOrOzDOwdHJY2YKhPs9sN/1hQi2+TEVi+sj
	 nZ2QW+j8tO/E3UwQZTI17iUshacr6uBld/mPEuq2SehRp5GGUUnG046CrtEUCCQsv6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIqYQQgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E099606A320;
	Thu, 19 Nov 2026 00:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIqYQQgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5261F000CB;
	Thu, 19 Nov 2026 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047666;
	bh=hZN5B5WNlRH+iqDN7QumfhLdn3V1uR+wdoDLJjzNNuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIqYQQgyKN+9l7STKuwCK1Wqc0Tw7iCm/tDKZUSYHSExuuKgw3XNZfLpQ3KpU0Ker
	 1W6rNm/2aHV7s/NwmkeBnIfL41BI1OyktazeIwoAlz1yL8KEWQ6AJ+mmGui276zeXO
	 Tp/bm/lyOB6lXUBqWqGTq4mC9CJIXJJyMpvV7Vw0=
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
Subject: [PATCH 6.1 1719/2857] mm/migrate: snapshot the source nid before the misplaced migration
Date: Wed, 18 Nov 2026 15:45:53 +0100
Message-ID: <20261118150303.219434643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted folio_nid(folio) to page_to_nid(page) in migrate_misplaced_page() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 09acee0c43569..0f3af8eb6356c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2458,6 +2458,7 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
 	int isolated;
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = page_to_nid(page);
 	LIST_HEAD(migratepages);
 	int nr_pages = thp_nr_pages(page);
 
@@ -2495,7 +2496,7 @@ int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
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



