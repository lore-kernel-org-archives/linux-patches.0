Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5067400973;
	Thu, 16 Jul 2026 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211163; cv=none; b=ms6FJAHyaVUHo/RFa2wSBtcIo2rAG5X1RxQZokyOJ5pBs7rEfXKsxDcu8C/nkThaYTqFtR7x6zJPPG0oIzDS1qvHe94ESu5I5KOWmtianXKLee4FMP4e8mwjG4BKxKjogrvIeGviR4fA+jPB2uum0KcyRKcEv/fR5jeE/ZnI+Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211163; c=relaxed/simple;
	bh=nIUxdACJsUBOUo6PpMqYYz8DJbaZbBIRZh8Zna74fyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiQR/t7gaVEQ7NC5kyBLWDnzarYMen2sdjxOXGy5Ba7AZ5YnCNy+kSk11jUP3nhgyCrXgoZ1HzHZ0X5Ovzu7gu2SAyCAG2xyeogKksR85T5XLVi2224NQyoGg/X/NVn627Hoq7yFNzexkW0txkb330Gmc5vQBpryR5BHvx6llX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYvKJfiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYvKJfiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569BF1F000E9;
	Thu, 16 Jul 2026 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211161;
	bh=+mZltPrDkuK2ub/ouvXO7Vb8LZmph08k3+K0w6/byKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYvKJfiOPzGe7wQieg8GlpeFGoq9EnYumUrAdsbM7Ija4y5Hs5Wbwf6+L7O3pS/bY
	 LnRO5o2RlnLabydOkCSoMRIcAYnFqwBzsrayoGHw2t7GoNZovr2gd+EBQCrpOAqIZz
	 pA7BYnTbz5NCx9YStUgjTU0fctPua7ZCrD5vbAGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Chao <machao26@xiaomi.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/480] mm: shmem: fix potential livelock issue for shmem direct swapin
Date: Thu, 16 Jul 2026 15:31:08 +0200
Message-ID: <20260716133051.762758243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
is used to prevent parallel swapin from proceeding with the swap cache flag.
However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:

Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
Meanwhile, a higher priority thread B also attempts direct swapin of the same
shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
thread B runs at higher priority, thread A cannot preempt it, resulting in
starvation and a livelock.

Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
swapcache_prepare() fails, following the same approach used in commit
029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
commit 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").

However, commit 01626a1823 ("mm: avoid unconditional one-tick sleep when
swapcache_prepare fails") found that the unconditional one-tick sleep can
cause UI stuttering on latency-sensitive Android devices. So we can follow
the same approach by adding a waitqueue to wake up tasks when needed,
instead of always sleeping for a full tick.

Note that mainline does not have this potential issue, which has already been
resolved by Kairui's swap refactoring work[2].

[1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
[2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
Reported-by: Ma Chao <machao26@xiaomi.com>
Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 94c5b0d78ac31e..3c329b794ae4df 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2005,11 +2005,14 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 	return ERR_PTR(error);
 }
 
+static DECLARE_WAIT_QUEUE_HEAD(shmem_swapcache_wq);
+
 static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	DECLARE_WAITQUEUE(wait, current);
 	int nr_pages = 1 << order;
 	struct folio *new;
 	gfp_t alloc_gfp;
@@ -2066,6 +2069,10 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
 		new = ERR_PTR(-EEXIST);
+		/* Relax a bit to prevent rapid repeated page faults */
+		add_wait_queue(&shmem_swapcache_wq, &wait);
+		schedule_timeout_uninterruptible(1);
+		remove_wait_queue(&shmem_swapcache_wq, &wait);
 		/* Try smaller folio to avoid cache conflict */
 		goto fallback;
 	}
@@ -2423,6 +2430,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (skip_swapcache) {
 		folio->swap.val = 0;
 		swapcache_clear(si, swap, nr_pages);
+		if (waitqueue_active(&shmem_swapcache_wq))
+			wake_up(&shmem_swapcache_wq);
 	} else {
 		swap_cache_del_folio(folio);
 	}
@@ -2442,8 +2451,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
+	if (skip_swapcache) {
 		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
+		if (waitqueue_active(&shmem_swapcache_wq))
+			wake_up(&shmem_swapcache_wq);
+	}
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
-- 
2.53.0



