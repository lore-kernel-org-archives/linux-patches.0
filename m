Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46931418A5D;
	Sat, 12 Sep 2026 09:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203852; cv=none; b=dgbbZPBjE5K5K7Fzost7Zk/wFTv/Gr7aBXk/mpJLni4K2Y0coAaA3OQmDdj6lIH6LW5/ouDHS/5gyS6PiRHA67ktyVvHPSuUb3iBzlbq4MX64U8UURjLkiddJKVFiQsdDaZA/rwIR/CQPBd8bJOyFtvK6vZk9QqewtpI6cGqex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203852; c=relaxed/simple;
	bh=tfQJONy/0kkcNNz7wXFqxbEurawCNpILGUDM7QskoGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aymS59Ty83aCNs4nC5FJuiw7GqOPEiTEQkH+zzKGxuRPKOpspjSJHzzToqKdzy4TNnbfLyZd/htFIsnajNHjRTl5+SC0uhmRvxQdLgN6GOmu7LzvLNy1Gl7b4ZDFR235zz70krKOn5R2CQtSxhsUHl419ofCHnmavZwlC8wmZPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k2llYPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k2llYPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28901F000FF;
	Sat, 12 Sep 2026 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203850;
	bh=WGtTM0+um6Sql3h6s6FyXo/TCFF+gjxDY6lOqHECFUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2k2llYPuUsHMMZi6kyCb/ip/nYgWFF28Zuq6eo4cRiMrkaAgVIzRQaet7D+TnQ00I
	 dLJ03vFWWJZz1Xh//kULsanRBELU9RGDIERP9BjKw9JdmVjYrFTMAVPSBrVUeghnas
	 NWe62n6kzKFF4w6fauGIyiaFPDKEbbIwYkfNbqio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1491/1815] ublk: avoid teardown retry loop on xarray allocation failure
Date: Sat, 12 Sep 2026 08:54:01 +0200
Message-ID: <20260912065724.005641831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 4fd66a7f829f3f38f92a79081f0f2688aed644f0 ]

__ublk_shmem_remove_ranges() removes matching maple tree ranges in
batches, but first stores each range into a temporary xarray so that the
pages can be unpinned after dropping the maple tree lock.

That temporary xarray is filled under the maple tree lock with
xa_store(..., GFP_ATOMIC). If the store fails before mas_erase(), the
current range is left in the tree and the helper returns false. The
outer ublk_shmem_remove_ranges() loop then immediately retries the same
range. While the atomic allocation keeps failing, the teardown path has
no forward progress.

The issue can be reproduced with radix_tree_node failslab injection after
a SHMEM_ZC buffer has already been registered:

  # Kernel config:
  #   CONFIG_BLK_DEV_UBLK=y
  #   CONFIG_DEBUG_FS=y
  #   CONFIG_FAULT_INJECTION=y
  #   CONFIG_FAULT_INJECTION_DEBUG_FS=y
  #   CONFIG_FAILSLAB=y

  echo 10 > /proc/sys/vm/nr_hugepages
  mkdir -p /tmp/htlb
  mount -t hugetlbfs none /tmp/htlb
  fallocate -l 4M /tmp/htlb/ublk_buf

  dev_id=$(kublk add -t null --shmem_zc \
		--htlb /tmp/htlb/ublk_buf |
	   awk -F '[ :]' '/dev id/ {print $3}')

  echo 1 > /sys/kernel/slab/radix_tree_node/failslab
  echo Y > /sys/kernel/debug/failslab/cache-filter
  echo Y > /sys/kernel/debug/failslab/ignore-gfp-wait
  echo 1 > /sys/kernel/debug/failslab/interval
  echo -1 > /sys/kernel/debug/failslab/times
  echo 100 > /sys/kernel/debug/failslab/probability

  kublk del -n "$dev_id"

On the unfixed kernel the delete command was still running after 3
seconds. Disabling failslab made it return. The fault-injection stack
showed:

  should_failslab
  kmem_cache_alloc_lru_noprof
  __xas_nomem
  __xa_store
  xa_store
  __ublk_shmem_remove_ranges
  ublk_cdev_rel
  ublk_ctrl_del_dev

Remove the allocation from the teardown loop. Keep the existing batch
limit, but collect {base_pfn, nr_pages} pairs in a fixed-size stack array.
Once a matching range is found, the range is erased from the maple tree
before dropping the lock, so each successful scan makes progress without
depending on any GFP_ATOMIC allocation.

With the same failslab settings, the fixed kernel completed
"kublk del -n $dev_id" successfully in about 45 ms.

Fixes: 309e02dccf64 ("ublk: avoid unpinning pages under maple tree spinlock")
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260804125736.2011774-1-sangyao@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0bbf1d5a4fbc6..b71283588ea77 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -5522,39 +5522,36 @@ static void ublk_unpin_range_pages(unsigned long base_pfn,
 
 /*
  * Inner loop: erase up to UBLK_REMOVE_BATCH matching ranges under
- * mas_lock, collecting them into an xarray. Then drop the lock and
- * unpin pages + free ranges outside spinlock context.
+ * mas_lock, collecting the page ranges in a fixed-size array. Then
+ * drop the lock and unpin pages + free ranges outside spinlock context.
  *
  * Returns true if the tree walk completed, false if more ranges remain.
- * Xarray key is the base PFN, value encodes nr_pages via xa_mk_value().
  */
 #define UBLK_REMOVE_BATCH	64
 
+struct ublk_unpin_range {
+	unsigned long base_pfn;
+	unsigned long nr_pages;
+};
+
 static bool __ublk_shmem_remove_ranges(struct ublk_device *ub,
 					int buf_index, int *ret)
 {
 	MA_STATE(mas, &ub->buf_tree, 0, ULONG_MAX);
 	struct ublk_buf_range *range;
-	struct xarray to_unpin;
-	unsigned long idx;
+	struct ublk_unpin_range to_unpin[UBLK_REMOVE_BATCH];
 	unsigned int count = 0;
+	unsigned int i;
 	bool done = false;
-	void *entry;
-
-	xa_init(&to_unpin);
 
 	mas_lock(&mas);
 	mas_for_each(&mas, range, ULONG_MAX) {
-		unsigned long nr;
-
 		if (buf_index >= 0 && range->buf_index != buf_index)
 			continue;
 
 		*ret = 0;
-		nr = mas.last - mas.index + 1;
-		if (xa_err(xa_store(&to_unpin, mas.index,
-				    xa_mk_value(nr), GFP_ATOMIC)))
-			goto unlock;
+		to_unpin[count].base_pfn = mas.index;
+		to_unpin[count].nr_pages = mas.last - mas.index + 1;
 		mas_erase(&mas);
 		kfree(range);
 		if (++count >= UBLK_REMOVE_BATCH)
@@ -5564,9 +5561,9 @@ static bool __ublk_shmem_remove_ranges(struct ublk_device *ub,
 unlock:
 	mas_unlock(&mas);
 
-	xa_for_each(&to_unpin, idx, entry)
-		ublk_unpin_range_pages(idx, xa_to_value(entry));
-	xa_destroy(&to_unpin);
+	for (i = 0; i < count; i++)
+		ublk_unpin_range_pages(to_unpin[i].base_pfn,
+				       to_unpin[i].nr_pages);
 
 	return done;
 }
-- 
2.53.0



