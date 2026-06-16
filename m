Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84E6477E36;
	Tue, 16 Jun 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630203; cv=none; b=kHzoNHoFFRosYjq0IV/p3tqOltK9Fma9ggazT87Hri3I3D8lSxfS/zu7WQa/s1iTNOWBmcutwT5HNF14Z2dixLadSA6q+TUD8Dyni80QSunFWUrz8qiVsmVxsl9lwKlsTQoQ1i3dOWsJ5vuFu10Cfrwh9Mddbg2eMa0G7r/hzbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630203; c=relaxed/simple;
	bh=ijWM243cIL33HaKuMsTc/neWTgYrrCQSC8zE2T8h8nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8MP3VHQFks4qqIyBHHf5pxDqf6XnrtxAdPnVhfClKLtyw3+ei+Dnyk14AT2FIib8s55z6E3Owz0w9O9QPYbPifwTfh/Q+Lb2VAAz7svmC6xn1Okec8IUHyFygvBu2hCmZIeEOus2YiPlfmcpq+XswRARHguoyz46Mds//2Orrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYyaM1JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYyaM1JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288431F00A3A;
	Tue, 16 Jun 2026 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630198;
	bh=7MytYL8giTHFr0kdMSMWqICQkNwHMTjHO5vYriF5M6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYyaM1JWyCfPqSYxH0czfg0dDUg5/fQQLL7TEJHw3AJThdSRKMld7lujrWjIBRk9C
	 l2K2q6WNsJnSaBy3Tuc0B4eIlRoWik8eCiYTl80pabjBRTe4ndchskA8U3yoCrVXt5
	 Klaf4rNd78MJmIe98HZthyoYQVHOXNlszN2vQ2p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 429/452] mm/migrate: dont call folio_putback_active_hugetlb() on dst hugetlb folio
Date: Tue, 16 Jun 2026 20:30:56 +0530
Message-ID: <20260616145139.212867540@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

[ Upstream commit ba23f58de896842028b4b33b95530f08288396fe ]

We replaced a simple put_page() by a putback_active_hugepage() call in
commit 3aaa76e125c1 ("mm: migrate: hugetlb: putback destination hugepage
to active list"), to set the "active" flag on the dst hugetlb folio.

Nowadays, we decoupled the "active" list from the flag, by calling the
flag "migratable".

Calling "putback" on something that wasn't allocated is weird and not
future proof, especially if we might reach that path when migration failed
and we just want to free the freshly allocated hugetlb folio.

Let's simply handle the migratable flag and the active list flag in
move_hugetlb_state(), where we know that allocation succeeded and already
handle the temporary flag; use a simple folio_put() to return our
reference.

Link: https://lkml.kernel.org/r/20250113131611.2554758-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3c2d42b8ee34 ("mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   10 ++++++++++
 mm/migrate.c |    8 ++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7358,6 +7358,16 @@ void move_hugetlb_state(struct folio *ol
 		}
 		spin_unlock_irq(&hugetlb_lock);
 	}
+
+	/*
+	 * Our old folio is isolated and has "migratable" cleared until it
+	 * is putback. As migration succeeded, set the new folio "migratable"
+	 * and add it to the active list.
+	 */
+	spin_lock_irq(&hugetlb_lock);
+	folio_set_hugetlb_migratable(new_folio);
+	list_move_tail(&new_folio->lru, &(folio_hstate(new_folio))->hugepage_activelist);
+	spin_unlock_irq(&hugetlb_lock);
 }
 
 /*
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1461,14 +1461,14 @@ out:
 		list_move_tail(&src->lru, ret);
 
 	/*
-	 * If migration was not successful and there's a freeing callback, use
-	 * it.  Otherwise, put_page() will drop the reference grabbed during
-	 * isolation.
+	 * If migration was not successful and there's a freeing callback,
+	 * return the folio to that special allocator. Otherwise, simply drop
+	 * our additional reference.
 	 */
 	if (put_new_folio)
 		put_new_folio(dst, private);
 	else
-		folio_putback_active_hugetlb(dst);
+		folio_put(dst);
 
 	return rc;
 }


