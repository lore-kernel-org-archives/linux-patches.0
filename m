Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B55635C6AA;
	Sat, 12 Sep 2026 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213325; cv=none; b=MyZ+IqFwY5YhxnhuSSiTe8NVQ0+r7FBzCukmy3DrT7M9auAyTdD9dfXJG1lvE1P1AgvPtgYaP1AKCjwHYi/WOePJyUtQXcAAtp1Bp33yunLddGvF3/R7vrzPN6/dlX7Lzn3/co7WlDs9KV85wf4ySBr6nv8k5/NNgmWiRp71Mpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213325; c=relaxed/simple;
	bh=GL5Sj8zUhbONZWkjsc+3QUCHhvmM7pUuLT3wEzUdohs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+Yq8KqxHxjup/FGhA4gkZFs9oK/bggEhh+cWG29+vqWyd+5mu6PSnqpRaGr6NvMxww0fKHo2+32DNQlu4n0kkS8iSyQDdsDL8JVV55nGyWJrX5/eTrQSkO+r/H98PVxzez6R6ZI3ORsbt2DibZQBIGAn/4m9wQ6bTmv7/V2eAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wenc0x9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wenc0x9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED681F00893;
	Sat, 12 Sep 2026 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213323;
	bh=vvJEGODmpY83zMO9w/963upc7EjRKCcXwm1LpJKAdB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wenc0x9ePWIwr9BcT3xywP7LkT8yNN9VoVsqyWvxfwXRcFSVqDMsdYzsmi2ghr8N4
	 oRaNPEqm9udMNc5DdmAaj42GTb5xCzDH6HfVL/l1RBHuJfNNY24siZebohpd3ulJ26
	 v27qpkZOqMVBCje4J9drGhWD6CwOSyfTtnI4R53c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wupeng Ma <mawupeng1@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0091/1376] mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
Date: Sat, 12 Sep 2026 08:41:57 +0200
Message-ID: <20260912065609.591234206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Wupeng Ma <mawupeng1@huawei.com>

commit 8ee1ef0f2f8ce29338f4ab00a3d344c010208058 upstream.

Commit ba23f58de896 ("mm/migrate: don't call
folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of the
migratable flag and active-list placement from
folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that the
freshly allocated destination folio is handled where allocation is known
to have succeeded.

Unfortunately, the new code was appended after the existing
temporary-folio block in move_hugetlb_state(), which contains an early
return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize the
surplus state transfer code in move_hugetlb_state()"):

  if (folio_test_hugetlb_temporary(new_folio)) {
      ...
      if (new_nid == old_nid)
          return;                       <-- skips the new code
      ...
  }

  /* added by ba23f58 */
  folio_set_hugetlb_migratable(new_folio);
  list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);

When the destination folio is temporary (i.e.  the hugetlb pool was
exhausted and the migration callback fell back to
alloc_migrate_hugetlb_folio()) and the migration does not cross a node --
the common case, and always true on a single-NUMA system --
move_hugetlb_state() returns before setting the migratable flag or adding
the new folio to the active list.  The destination folio is then installed
in the page table but cannot be isolated afterwards, since
folio_isolate_hugetlb() rejects folios without the migratable flag; a
subsequent soft-offline, hard-offline or memory-hotplug offline of that
folio fails with -EBUSY.

This was reproduced on a single-NUMA arm64 VM: a second MADV_SOFT_OFFLINE
on an already-migrated hugetlb page returned EBUSY and logged "hugepage
isolation failed".

Keep the surplus adjustment, which is the only part that depends on the
node crossing, guarded by `if (new_nid != old_nid)', while making the
migratable flag and active-list placement unconditional.  This preserves
the cleanup intent of ba23f58 and closes the early-return hole.

Link: https://lore.kernel.org/20260707110254.3147686-1-mawupeng1@huawei.com
Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7523,14 +7523,14 @@ void move_hugetlb_state(struct folio *ol
 		 * There is no need to transfer the per-node surplus state
 		 * when we do not cross the node.
 		 */
-		if (new_nid == old_nid)
-			return;
-		spin_lock_irq(&hugetlb_lock);
-		if (h->surplus_huge_pages_node[old_nid]) {
-			h->surplus_huge_pages_node[old_nid]--;
-			h->surplus_huge_pages_node[new_nid]++;
+		if (new_nid != old_nid) {
+			spin_lock_irq(&hugetlb_lock);
+			if (h->surplus_huge_pages_node[old_nid]) {
+				h->surplus_huge_pages_node[old_nid]--;
+				h->surplus_huge_pages_node[new_nid]++;
+			}
+			spin_unlock_irq(&hugetlb_lock);
 		}
-		spin_unlock_irq(&hugetlb_lock);
 	}
 }
 


