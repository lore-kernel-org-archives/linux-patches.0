Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B1366DBC;
	Tue,  6 Jan 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722094; cv=none; b=OPoCemnER6f2vqpG7OTBNieggKVOmAvt7v0jbmlnjB4nofe935cV0piAtzKuaXGAZ6MVW1gT2mcjSLA/lEqIi2OC5GVHLh836o+qR2cXBiBkooyJHhj5RL7IWvT/zr8Ivsvk68TqPk1Zfa983oJwjbSm1vCvU1JIY63jWTJInIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722094; c=relaxed/simple;
	bh=8dUGC6uV/rdPvPsJJ+1zZpsfgXQApcnNODpAjj+exOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyjmQtJLIwLprQK7rI9ft3vSzaonklWPDY/LQCSSeBPcMDXWkWxgm5MvQETu0zwMGRggYezarnV3ErI3oJrbKsO08yP8Anuy1HwMB4GvxcN1HxrWDhWCl8VqpDXj274huFay5WQ25zVL8OE7vczFUUYQiRVUIr0W+aSPDz9Q870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1j5+aAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1j5+aAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A310EC116C6;
	Tue,  6 Jan 2026 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722094;
	bh=8dUGC6uV/rdPvPsJJ+1zZpsfgXQApcnNODpAjj+exOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1j5+aAa6SvBteRspkPhak5JcY4ENRBbMU0KfQS3amIyRHNYEKbLkI1RL1fZVM41J
	 0CVOZHiosuq5MIN72n8oTsjTX+1b9wbadVk7TvArrFbC3YMQbvgeHbtgkQlSXaElZI
	 kS86dcBaLmfnoUDbHSkKMuQGyc8S6CTRdWJ45MZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 130/312] mm, swap: do not perform synchronous discard during allocation
Date: Tue,  6 Jan 2026 18:03:24 +0100
Message-ID: <20260106170552.546514302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Kairui Song <kasong@tencent.com>

commit 9fb749cd15078c7bdc46e5d45c37493f83323e33 upstream.

Patch series "mm, swap: misc cleanup and bugfix", v2.

A few cleanups and a bugfix that are either suitable after the swap table
phase I or found during code review.

Patch 1 is a bugfix and needs to be included in the stable branch, the
rest have no behavioral change.


This patch (of 5):

Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
fast path"), swap allocation is protected by a local lock, which means we
can't do any sleeping calls during allocation.

However, the discard routine is not taken well care of.  When the swap
allocator failed to find any usable cluster, it would look at the pending
discard cluster and try to issue some blocking discards.  It may not
necessarily sleep, but the cond_resched at the bio layer indicates this is
wrong when combined with a local lock.  And the bio GFP flag used for
discard bio is also wrong (not atomic).

It's arguable whether this synchronous discard is helpful at all.  In most
cases, the async discard is good enough.  And the swap allocator is doing
very differently at organizing the clusters since the recent change, so it
is very rare to see discard clusters piling up.

So far, no issues have been observed or reported with typical SSD setups
under months of high pressure.  This issue was found during my code
review.  But by hacking the kernel a bit: adding a mdelay(500) in the
async discard path, this issue will be observable with WARNING triggered
by the wrong GFP and cond_resched in the bio layer for debug builds.

So now let's apply a hotfix for this issue: remove the synchronous discard
in the swap allocation path.  And when order 0 is failing with all cluster
list drained on all swap devices, try to do a discard following the swap
device priority list.  If any discards released some cluster, try the
allocation again.  This way, we can still avoid OOM due to swap failure if
the hardware is very slow and memory pressure is extremely high.

This may cause more fragmentation issues if the discarding hardware is
really slow.  Ideally, we want to discard pending clusters before
continuing to iterate the fragment cluster lists.  This can be implemented
in a cleaner way if we clean up the device list iteration part first.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com
Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com
Fixes: 1b7e90020eb7 ("mm, swap: use percpu cluster as allocation fast path")
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/swapfile.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1101,13 +1101,6 @@ new_cluster:
 			goto done;
 	}
 
-	/*
-	 * We don't have free cluster but have some clusters in discarding,
-	 * do discard now and reclaim them.
-	 */
-	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))
-		goto new_cluster;
-
 	if (order)
 		goto done;
 
@@ -1394,6 +1387,33 @@ start_over:
 	return false;
 }
 
+/*
+ * Discard pending clusters in a synchronized way when under high pressure.
+ * Return: true if any cluster is discarded.
+ */
+static bool swap_sync_discard(void)
+{
+	bool ret = false;
+	int nid = numa_node_id();
+	struct swap_info_struct *si, *next;
+
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+		spin_unlock(&swap_avail_lock);
+		if (get_swap_device_info(si)) {
+			if (si->flags & SWP_PAGE_DISCARD)
+				ret = swap_do_scheduled_discard(si);
+			put_swap_device(si);
+		}
+		if (ret)
+			return true;
+		spin_lock(&swap_avail_lock);
+	}
+	spin_unlock(&swap_avail_lock);
+
+	return false;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio
 		}
 	}
 
+again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(&entry, order))
 		swap_alloc_slow(&entry, order);
 	local_unlock(&percpu_swap_cluster.lock);
 
+	if (unlikely(!order && !entry.val)) {
+		if (swap_sync_discard())
+			goto again;
+	}
+
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (mem_cgroup_try_charge_swap(folio, entry))
 		goto out_free;


