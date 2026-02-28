Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3F837315A;
	Sat, 28 Feb 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301520; cv=none; b=EDqM61hMcpq0+6Gqqg7Em19ZItDbrUtx1z27nHpWxjo4sDJes9ErSndCkyx0xG0xLfjLW4+Enn/FKN0WVMHYSL5zftEkbug0NKZLuAvgA0yhOffhldbZrpN2ZFuh2lyjSHTF5PoMUcezQmlPUXVZMWm9tbLmS0snOy4d6SAGeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301520; c=relaxed/simple;
	bh=TU0dAKQdV6aC4MqczuZJ/US2NyO2cxaxzG9z+YRd644=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLTBYqQSC/G0Q5LpZhv2iUgOGHXpWzZIOkCH0m9b9A2EmZmbeH7TyhKuALh6Lj6fyq7Zm48FB4t7YqwXgvEVxUsBNnSRtYB5jJboee9wX2plx1obfAgifYB4U9JTOoGyn1ofV9r5tGHncaFiiLkcJ6XkAMClWndjV5hy8pWtedU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjP/PiiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjP/PiiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4730CC116D0;
	Sat, 28 Feb 2026 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301520;
	bh=TU0dAKQdV6aC4MqczuZJ/US2NyO2cxaxzG9z+YRd644=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjP/PiiQrwNEy3BSHg0FfNYeeERJzqvp3N3QoSAnIE91lFJRMqwtcqPpzgnzFHZ34
	 NohAFFky0QUOkFYkLVMmg1uUynCqJ8b5KC6to3jCrIpiiddZykrw/tTkfixZBe8ywo
	 bPWPOrmuVccfRS6I4Art2ttaHvFBAxdkpp3GomwAX5ACbTLcjr4jbYRbATdilydMJx
	 umA+pmMZYW4tORCBRdX3bK/kgub2+N4rpX26QngMkEiP1b4oCvVfXnhOiHo8uxBOZO
	 7r+f1/wRJhTeKj6qqHd+UnEksM4xM1LgbDVijnxl9qwl9uYzK5JgezXmDZnPtPYfV9
	 aLyiC+gaOxcwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 705/752] mm/hugetlb: restore failed global reservations to subpool
Date: Sat, 28 Feb 2026 12:46:56 -0500
Message-ID: <20260228174750.1542406-705-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joshua Hahn <joshua.hahnjy@gmail.com>

[ Upstream commit 1d3f9bb4c8af70304d19c22e30f5d16a2d589bb5 ]

Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
fixed an underflow error for hstate->resv_huge_pages caused by incorrectly
attributing globally requested pages to the subpool's reservation.

Unfortunately, this fix also introduced the opposite problem, which would
leave spool->used_hpages elevated if the globally requested pages could
not be acquired.  This is because while a subpool's reserve pages only
accounts for what is requested and allocated from the subpool, its "used"
counter keeps track of what is consumed in total, both from the subpool
and globally.  Thus, we need to adjust spool->used_hpages in the other
direction, and make sure that globally requested pages are uncharged from
the subpool's used counter.

Each failed allocation attempt increments the used_hpages counter by how
many pages were requested from the global pool.  Ultimately, this renders
the subpool unusable, as used_hpages approaches the max limit.

The issue can be reproduced as follows:
1. Allocate 4 hugetlb pages
2. Create a hugetlb mount with max=4, min=2
3. Consume 2 pages globally
4. Request 3 pages from the subpool (2 from subpool + 1 from global)
	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
		used_hpages += 3
	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
		used_hpages -= 2
5. Subpool now has used_hpages = 1, despite not being able to
   successfully allocate any hugepages. It believes it can now only
   allocate 3 more hugepages, not 4.

With each failed allocation attempt incrementing the used counter, the
subpool eventually reaches a point where its used counter equals its
max counter.  At that point, any future allocations that try to
allocate hugeTLB pages from the subpool will fail, despite the subpool
not having any of its hugeTLB pages consumed by any user.

Once this happens, there is no way to make the subpool usable again,
since there is no way to decrement the used counter as no process is
really consuming the hugeTLB pages.

The underflow issue that the original commit fixes still remains fixed
as well.

Without this fix, used_hpages would keep on leaking if
hugetlb_acct_memory() fails.

Link: https://lkml.kernel.org/r/20260116204037.2270096-1-joshua.hahnjy@gmail.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index be0f935a8b121..13293976e0568 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7386,6 +7386,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 		 */
 		hugetlb_acct_memory(h, -gbl_resv);
 	}
+	/* Restore used_hpages for pages that failed global reservation */
+	if (gbl_reserve && spool) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_reserve;
+		unlock_or_release_subpool(spool, flags);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
-- 
2.51.0

