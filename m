Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56993A9627;
	Tue, 16 Jun 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626038; cv=none; b=qKn0fo8H9NXkyGzkgWtLSu/aXMK9+EqysQJ3NpFMUlaC+tDWuzzOrgv2Hj80l6vivERLXBa9jeYePVFpspfahWf+FHWmmtdmPJs3hCdfw8jwOyC0jHKzF+4OZ0bfEMg+hqZrKYswqOgOjPGNHUV+8y220q4mPN24VfiEtB9jaRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626038; c=relaxed/simple;
	bh=ryZA9diOkM/puNDNSUPfNXYVLNru4jdksFErTZsYn1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl92glshTiiwfmfEMulwKRf3QSagXK2zwIHvlNfJSF6RJ4K5QeSZBQbWdc/O1FlV3POXtZ9s5B6t4rVO7DlXpM330rcreS3scNe2d043YG8XtZrLeNdG8nh9Ig0sZmhdzGrrqIjm3yX+u16N8BB417oFzP3VC+926RWm+A7GVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziPr16Hw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziPr16Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426C91F000E9;
	Tue, 16 Jun 2026 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626036;
	bh=oyhtdRwgw+5zVwxSqpVfnJQKhm5d4yLRpXkZCMwiRvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziPr16Hw7lFuFZNZP6gg8BjHJcClEE0qttdzMaFInI2kSt7AJp1PH4IZ/Va0CkrCT
	 rZ68TRq7Vvb+VSF2796KWagtVZ07CqXgtza2MCQLfka1rNDDKKArV7wP1Ku8d3ciel
	 0uELCv+aSnW5tPJWJjupBHo/GEvREIKe2hOw3fEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Chris Mason <clm@fb.com>,
	Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 255/325] mm/list_lru: drain before clearing xarray entry on reparent
Date: Tue, 16 Jun 2026 20:30:51 +0530
Message-ID: <20260616145111.269570350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 98733f3f0becb1ae0701d021c1748e974e5fa55c upstream.

memcg_reparent_list_lrus() clears the dying memcg's xarray entry with
xas_store(&xas, NULL) before reparenting its per-node lists into the
parent.  This opens a window where a concurrent list_lru_del() arriving
for the dying memcg sees xa_load() == NULL, walks to the parent in
lock_list_lru_of_memcg(), takes the parent's per-node lock, and calls
list_del_init() on an item still physically linked on the dying memcg's
list.

If another in-flight thread holds the dying memcg's per-node lock at the
same moment (another list_lru_del, or a list_lru_walk_one running an
isolate callback), both threads modify ->next/->prev pointers on the same
physical list under different locks.  Adjacent items can corrupt each
other's links.

Fix it by reversing the order: reparent each per-node list and mark the
child's list lru dead and then clear the xarray entry.  Any concurrent
list_lru op that finds the still-set xarray entry either takes the dying
memcg's per-node lock (synchronizing with the drain) or sees LONG_MIN and
walks to the parent, where the items now live.

Link: https://lore.kernel.org/20260601161501.1444829-1-shakeel.butt@linux.dev
Fixes: fb56fdf8b9a2 ("mm/list_lru: split the lock to per-cgroup scope")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Chris Mason <clm@fb.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/list_lru.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -472,26 +472,29 @@ void memcg_reparent_list_lrus(struct mem
 	mutex_lock(&list_lrus_mutex);
 	list_for_each_entry(lru, &memcg_list_lrus, list) {
 		struct list_lru_memcg *mlru;
-		XA_STATE(xas, &lru->xa, memcg->kmemcg_id);
 
 		/*
-		 * Lock the Xarray to ensure no on going list_lru_memcg
-		 * allocation and further allocation will see css_is_dying().
+		 * css_is_dying() check in memcg_list_lru_alloc() avoids
+		 * allocating a new mlru since CSS_DYING is already set for this
+		 * memcg a rcu grace period ago.
 		 */
-		xas_lock_irq(&xas);
-		mlru = xas_store(&xas, NULL);
-		xas_unlock_irq(&xas);
+		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
 		if (!mlru)
 			continue;
 
 		/*
-		 * With Xarray value set to NULL, holding the lru lock below
-		 * prevents list_lru_{add,del,isolate} from touching the lru,
-		 * safe to reparent.
+		 * Reparent each per-node list and mark the child dead
+		 * (LONG_MIN) before clearing xarray entry otherwise a
+		 * concurrent list_lru_del() may corrupt the list if it arrives
+		 * after xarray clear but before reparenting as
+		 * lock_list_lru_of_memcg will acquire parent's lock while the
+		 * item is still on child's list.
 		 */
 		for_each_node(i)
 			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
 
+		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
+
 		/*
 		 * Here all list_lrus corresponding to the cgroup are guaranteed
 		 * to remain empty, we can safely free this lru, any further


