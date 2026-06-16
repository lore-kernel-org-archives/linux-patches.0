Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B6A3D8100;
	Tue, 16 Jun 2026 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635821; cv=none; b=WwrVhluKdNdr+3I68ZzA7z5Nu4aKGRFE5jBB7S4eqMPbfxHczKgnee6W+C4K4x5WxR4Q2TNTwgBXzb3VWMNGrGkcKBJwhovWftLUpd6krKg1/XdYuqQLEEUiCoEFUNR0ELYVPUgFNeDuOw8N3ErG7qLCBUbGtVchk3cXu2CzecQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635821; c=relaxed/simple;
	bh=UMZpHmV2RIx+xHr2BVDq8/nLKnoIaFzlWIpn25BBbIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFYdrw5wo68VNgp+z1G0vFk3kwBdc3X5rBCgu9w6v2MpvX0PEplrNImbSUuqV6NuSKmp7YeIM075ZTm/OlIl/zApvoXGNSF8xR89HeNNyIrhdOimeXUCajdp4ZSmdsp5js/EleDDS163gyh44KFz6wnhZKk6fKR7T2Y0ZktVGnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNnUWI3G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNnUWI3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A578C1F000E9;
	Tue, 16 Jun 2026 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635819;
	bh=ykNSYiRLyr9cy6Mgu/KqDhKACe4958Th0NUuHRkJORU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNnUWI3GkL4yFO9JSmh6ccBeyRFPqryinZoknxZ7gsX70aKuNHrmR7YqWJnA2fqwa
	 stcOIcp0zvm/vQTrXUJg2rnA7iNhciQNmVsWniBTLcYfjBRehQ4wJj+k6tgf+95fm1
	 UuLBJmvbwWrLWduLJPLHwY4w7DjFPkWZcdTrgj7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	syzbot+204a4382fcb3311f3858@syzkaller.appspotmail.com,
	Dong Chenchen <dongchenchen2@huawei.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Mina Almasry <almasrymina@google.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/342] page_pool: Fix use-after-free in page_pool_recycle_in_ring
Date: Tue, 16 Jun 2026 20:26:56 +0530
Message-ID: <20260616145053.801255804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dong Chenchen <dongchenchen2@huawei.com>

[ Upstream commit 271683bb2cf32e5126c592b5d5e6a756fa374fd9 ]

syzbot reported a uaf in page_pool_recycle_in_ring:

BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30 kernel/locking/lockdep.c:5862
Read of size 8 at addr ffff8880286045a0 by task syz.0.284/6943

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
[v5.10: introduced page_pool_producer_lock/unlock helpers inline since
 prerequisite commit 368d3cb406cd ("page_pool: fix inconsistency for
 page_pool_ring_[un]lock()") depends on page_pool_put_page_bulk which
 does not exist in 5.10; used in_serving_softirq() per 5.10 convention;
 kept struct page * API (no netmem_ref); dropped recycle_stat_inc change
 as page pool stats do not exist in this tree]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Assisted-by: Claude:claude-opus-4-6-v1
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 15ad99330bb9b1..09d98fcf669f2c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -318,16 +318,39 @@ static void page_pool_return_page(struct page_pool *pool, struct page *page)
 	 */
 }
 
+static bool page_pool_producer_lock(struct page_pool *pool)
+	__acquires(&pool->ring.producer_lock)
+{
+	bool in_softirq = in_serving_softirq();
+
+	if (in_softirq)
+		spin_lock(&pool->ring.producer_lock);
+	else
+		spin_lock_bh(&pool->ring.producer_lock);
+
+	return in_softirq;
+}
+
+static void page_pool_producer_unlock(struct page_pool *pool,
+				      bool in_softirq)
+	__releases(&pool->ring.producer_lock)
+{
+	if (in_softirq)
+		spin_unlock(&pool->ring.producer_lock);
+	else
+		spin_unlock_bh(&pool->ring.producer_lock);
+}
+
 static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 {
-	int ret;
+	bool in_softirq, ret;
+
 	/* BH protection not needed if current is serving softirq */
-	if (in_serving_softirq())
-		ret = ptr_ring_produce(&pool->ring, page);
-	else
-		ret = ptr_ring_produce_bh(&pool->ring, page);
+	in_softirq = page_pool_producer_lock(pool);
+	ret = !__ptr_ring_produce(&pool->ring, page);
+	page_pool_producer_unlock(pool, in_softirq);
 
-	return (ret == 0) ? true : false;
+	return ret;
 }
 
 /* Only allow direct recycling in special circumstances, into the
@@ -464,10 +487,14 @@ static void page_pool_scrub(struct page_pool *pool)
 
 static int page_pool_release(struct page_pool *pool)
 {
+	bool in_softirq;
 	int inflight;
 
 	page_pool_scrub(pool);
 	inflight = page_pool_inflight(pool);
+	/* Acquire producer lock to make sure producers have exited. */
+	in_softirq = page_pool_producer_lock(pool);
+	page_pool_producer_unlock(pool, in_softirq);
 	if (!inflight)
 		page_pool_free(pool);
 
-- 
2.53.0



