Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C42FA64F;
	Tue, 17 Jun 2025 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178802; cv=none; b=Hly2bRvpptOfGmKMOAY6/ersDLaSpjNPiYU/nqUSpVp8WM0pOk5NmLJVXwASQPICc05JFNFjGb6pbSnztzJjK3yNaLUUe03j6jRl3/8703fW10MDXwxrBq+x+l65DEE0ZfnARJlfNCbpxBtKJhlxnIwUeCqZrzbzMgbO6xgkCM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178802; c=relaxed/simple;
	bh=dBYAutuil/DQ06qRI57+BaIsiLHHsMWemORY1ujZHx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKGQzubIw/8/TcVbKgu/C46f0X8LVpk5aNtEucoX0nvR7q7TUgHM/oDVyw4bMAPQvEi9heHZ62ipJQWvd+Q2SfAZXhsEPKkY1LM/7Rt4FkKLn/igMoZ5dnigHhRW9J7QbYE+L/imCAat1JwgTpKV2VyzgvfHH8HIzQLvJ1+W+RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSgrS0fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSgrS0fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C14BC4CEE3;
	Tue, 17 Jun 2025 16:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178801;
	bh=dBYAutuil/DQ06qRI57+BaIsiLHHsMWemORY1ujZHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSgrS0fczgvJehHYAUMO8DUpY1lOJjsAOKdKutytZPmICz4Euj4Hyp2JKX7OoCaNs
	 4ZQaoMBzAiToVPBMm8ttKv67b/+nIGvjooIM1uKk+ULvz7XDYHmzL2eIRb7XY9RWbB
	 t29G8IqUSxReZ0R8Ha7PzhCFWwhm1uBJX/u9AMZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+204a4382fcb3311f3858@syzkaller.appspotmail.com,
	Dong Chenchen <dongchenchen2@huawei.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Mina Almasry <almasrymina@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 559/780] page_pool: Fix use-after-free in page_pool_recycle_in_ring
Date: Tue, 17 Jun 2025 17:24:27 +0200
Message-ID: <20250617152514.260664610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 271683bb2cf32e5126c592b5d5e6a756fa374fd9 ]

syzbot reported a uaf in page_pool_recycle_in_ring:

BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30 kernel/locking/lockdep.c:5862
Read of size 8 at addr ffff8880286045a0 by task syz.0.284/6943

CPU: 0 UID: 0 PID: 6943 Comm: syz.0.284 Not tainted 6.13.0-rc3-syzkaller-gdfa94ce54f41 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 lock_release+0x151/0xa30 kernel/locking/lockdep.c:5862
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:165 [inline]
 _raw_spin_unlock_bh+0x1b/0x40 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 ptr_ring_produce_bh include/linux/ptr_ring.h:164 [inline]
 page_pool_recycle_in_ring net/core/page_pool.c:707 [inline]
 page_pool_put_unrefed_netmem+0x748/0xb00 net/core/page_pool.c:826
 page_pool_put_netmem include/net/page_pool/helpers.h:323 [inline]
 page_pool_put_full_netmem include/net/page_pool/helpers.h:353 [inline]
 napi_pp_put_page+0x149/0x2b0 net/core/skbuff.c:1036
 skb_pp_recycle net/core/skbuff.c:1047 [inline]
 skb_free_head net/core/skbuff.c:1094 [inline]
 skb_release_data+0x6c4/0x8a0 net/core/skbuff.c:1125
 skb_release_all net/core/skbuff.c:1190 [inline]
 __kfree_skb net/core/skbuff.c:1204 [inline]
 sk_skb_reason_drop+0x1c9/0x380 net/core/skbuff.c:1242
 kfree_skb_reason include/linux/skbuff.h:1263 [inline]
 __skb_queue_purge_reason include/linux/skbuff.h:3343 [inline]

root cause is:

page_pool_recycle_in_ring
  ptr_ring_produce
    spin_lock(&r->producer_lock);
    WRITE_ONCE(r->queue[r->producer++], ptr)
      //recycle last page to pool
				page_pool_release
				  page_pool_scrub
				    page_pool_empty_ring
				      ptr_ring_consume
				      page_pool_return_page  //release all page
				  __page_pool_destroy
				     free_percpu(pool->recycle_stats);
				     free(pool) //free

     spin_unlock(&r->producer_lock); //pool->ring uaf read
  recycle_stat_inc(pool, ring);

page_pool can be free while page pool recycle the last page in ring.
Add producer-lock barrier to page_pool_release to prevent the page
pool from being free before all pages have been recycled.

recycle_stat_inc() is empty when CONFIG_PAGE_POOL_STATS is not
enabled, which will trigger Wempty-body build warning. Add definition
for pool stat macro to fix warning.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/netdev/20250513083123.3514193-1-dongchenchen2@huawei.com
Fixes: ff7d6b27f894 ("page_pool: refurbish version of page_pool code")
Reported-by: syzbot+204a4382fcb3311f3858@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=204a4382fcb3311f3858
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250527114152.3119109-1-dongchenchen2@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2b76848659418..2d9c51f480fb5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -153,9 +153,9 @@ u64 *page_pool_ethtool_stats_get(u64 *data, const void *stats)
 EXPORT_SYMBOL(page_pool_ethtool_stats_get);
 
 #else
-#define alloc_stat_inc(pool, __stat)
-#define recycle_stat_inc(pool, __stat)
-#define recycle_stat_add(pool, __stat, val)
+#define alloc_stat_inc(...)	do { } while (0)
+#define recycle_stat_inc(...)	do { } while (0)
+#define recycle_stat_add(...)	do { } while (0)
 #endif
 
 static bool page_pool_producer_lock(struct page_pool *pool)
@@ -741,19 +741,16 @@ void page_pool_return_page(struct page_pool *pool, netmem_ref netmem)
 
 static bool page_pool_recycle_in_ring(struct page_pool *pool, netmem_ref netmem)
 {
-	int ret;
-	/* BH protection not needed if current is softirq */
-	if (in_softirq())
-		ret = ptr_ring_produce(&pool->ring, (__force void *)netmem);
-	else
-		ret = ptr_ring_produce_bh(&pool->ring, (__force void *)netmem);
+	bool in_softirq, ret;
 
-	if (!ret) {
+	/* BH protection not needed if current is softirq */
+	in_softirq = page_pool_producer_lock(pool);
+	ret = !__ptr_ring_produce(&pool->ring, (__force void *)netmem);
+	if (ret)
 		recycle_stat_inc(pool, ring);
-		return true;
-	}
+	page_pool_producer_unlock(pool, in_softirq);
 
-	return false;
+	return ret;
 }
 
 /* Only allow direct recycling in special circumstances, into the
@@ -1146,10 +1143,14 @@ static void page_pool_scrub(struct page_pool *pool)
 
 static int page_pool_release(struct page_pool *pool)
 {
+	bool in_softirq;
 	int inflight;
 
 	page_pool_scrub(pool);
 	inflight = page_pool_inflight(pool, true);
+	/* Acquire producer lock to make sure producers have exited. */
+	in_softirq = page_pool_producer_lock(pool);
+	page_pool_producer_unlock(pool, in_softirq);
 	if (!inflight)
 		__page_pool_destroy(pool);
 
-- 
2.39.5



