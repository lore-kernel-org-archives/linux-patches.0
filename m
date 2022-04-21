Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5C3D6D
	for <patches@lists.linux.dev>; Thu, 21 Apr 2022 23:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EFDC385AB;
	Thu, 21 Apr 2022 23:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1650584171;
	bh=Rz872EwhpkJz/H2MaVr7yZn1UCITr1zMVSOzm3WIcy8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=mvbYeQaV5E6rrgsDY1NUacWjwhOxK4oaLqhjNg/ovRsVV64CKNx/ir2NYp8iJvYVM
	 Gx3SNERDUHQFxuI8lvvqleC24ZIKx2VuLiHOHNbftA2EYlBYVaf+gsV5+5aqpNjRS+
	 F1s/kyWRat5PpPZ4y+zEeIdfDjqXaXi1mUZ0jLjw=
Date: Thu, 21 Apr 2022 16:36:10 -0700
To: stable@vger.kernel.org,rcampbell@nvidia.com,jhubbard@nvidia.com,jgg@nvidia.com,christian.koenig@amd.com,apopple@nvidia.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 13/13] mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()
Message-Id: <20220421233610.E9EFDC385AB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Alistair Popple <apopple@nvidia.com>
Subject: mm/mmu_notifier.c: fix race in mmu_interval_notifier_remove()

In some cases it is possible for mmu_interval_notifier_remove() to race
with mn_tree_inv_end() allowing it to return while the notifier data
structure is still in use.  Consider the following sequence:

CPU0 - mn_tree_inv_end()            CPU1 - mmu_interval_notifier_remove()
----------------------------------- ------------------------------------
                                    spin_lock(subscriptions->lock);
                                    seq = subscriptions->invalidate_seq;
spin_lock(subscriptions->lock);     spin_unlock(subscriptions->lock);
subscriptions->invalidate_seq++;
                                    wait_event(invalidate_seq != seq);
                                    return;
interval_tree_remove(interval_sub); kfree(interval_sub);
spin_unlock(subscriptions->lock);
wake_up_all();

As the wait_event() condition is true it will return immediately.  This
can lead to use-after-free type errors if the caller frees the data
structure containing the interval notifier subscription while it is still
on a deferred list.  Fix this by taking the appropriate lock when reading
invalidate_seq to ensure proper synchronisation.

I observed this whilst running stress testing during some development. 
You do have to be pretty unlucky, but it leads to the usual problems of
use-after-free (memory corruption, kernel crash, difficult to diagnose
WARN_ON, etc).

Link: https://lkml.kernel.org/r/20220420043734.476348-1-apopple@nvidia.com
Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifierc-fix-race-in-mmu_interval_notifier_remove
+++ a/mm/mmu_notifier.c
@@ -1036,6 +1036,18 @@ int mmu_interval_notifier_insert_locked(
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked);
 
+static bool
+mmu_interval_seq_released(struct mmu_notifier_subscriptions *subscriptions,
+			  unsigned long seq)
+{
+	bool ret;
+
+	spin_lock(&subscriptions->lock);
+	ret = subscriptions->invalidate_seq != seq;
+	spin_unlock(&subscriptions->lock);
+	return ret;
+}
+
 /**
  * mmu_interval_notifier_remove - Remove a interval notifier
  * @interval_sub: Interval subscription to unregister
@@ -1083,7 +1095,7 @@ void mmu_interval_notifier_remove(struct
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 	if (seq)
 		wait_event(subscriptions->wq,
-			   READ_ONCE(subscriptions->invalidate_seq) != seq);
+			   mmu_interval_seq_released(subscriptions, seq));
 
 	/* pairs with mmgrab in mmu_interval_notifier_insert() */
 	mmdrop(mm);
_
