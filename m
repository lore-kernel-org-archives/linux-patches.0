Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44774FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C673DC433D2;
	Thu,  1 Jun 2023 13:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625931;
	bh=n9wKVvgjmRvm7T9ORA2GZ7A1N9b7N+FFTYEMoCPslB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDPC3RqTBA2+la2qCXQcHturqanvWaG0/gVOmDvzfoSp6f67GancgcKKNjWl4ZswH
	 4Sx2Dcb4SCmP503Y7DxG8pHLdcjDWE0WDFY1MnFufLr3mmeTuvEfhsfeHm4yrLmRo6
	 rX6+lekVMpbxMvooTTbIkkJwyqPhxpQqEjjeZVhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/42] page_pool: fix inconsistency for page_pool_ring_[un]lock()
Date: Thu,  1 Jun 2023 14:21:20 +0100
Message-Id: <20230601131938.197126297@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 368d3cb406cdd074d1df2ad9ec06d1bfcb664882 ]

page_pool_ring_[un]lock() use in_softirq() to decide which
spin lock variant to use, and when they are called in the
context with in_softirq() being false, spin_lock_bh() is
called in page_pool_ring_lock() while spin_unlock() is
called in page_pool_ring_unlock(), because spin_lock_bh()
has disabled the softirq in page_pool_ring_lock(), which
causes inconsistency for spin lock pair calling.

This patch fixes it by returning in_softirq state from
page_pool_producer_lock(), and use it to decide which
spin lock variant to use in page_pool_producer_unlock().

As pool->ring has both producer and consumer lock, so
rename it to page_pool_producer_[un]lock() to reflect
the actual usage. Also move them to page_pool.c as they
are only used there, and remove the 'inline' as the
compiler may have better idea to do inlining or not.

Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Link: https://lore.kernel.org/r/20230522031714.5089-1-linyunsheng@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/page_pool.h | 18 ------------------
 net/core/page_pool.c    | 28 ++++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 80d987419436e..edcc22605842e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -282,22 +282,4 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
 		page_pool_update_nid(pool, new_nid);
 }
 
-static inline void page_pool_ring_lock(struct page_pool *pool)
-	__acquires(&pool->ring.producer_lock)
-{
-	if (in_softirq())
-		spin_lock(&pool->ring.producer_lock);
-	else
-		spin_lock_bh(&pool->ring.producer_lock);
-}
-
-static inline void page_pool_ring_unlock(struct page_pool *pool)
-	__releases(&pool->ring.producer_lock)
-{
-	if (in_softirq())
-		spin_unlock(&pool->ring.producer_lock);
-	else
-		spin_unlock_bh(&pool->ring.producer_lock);
-}
-
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1d520fa1b98a8..069d6ba0e33fb 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -26,6 +26,29 @@
 
 #define BIAS_MAX	LONG_MAX
 
+static bool page_pool_producer_lock(struct page_pool *pool)
+	__acquires(&pool->ring.producer_lock)
+{
+	bool in_softirq = in_softirq();
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
 static int page_pool_init(struct page_pool *pool,
 			  const struct page_pool_params *params)
 {
@@ -489,6 +512,7 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count)
 {
 	int i, bulk_len = 0;
+	bool in_softirq;
 
 	for (i = 0; i < count; i++) {
 		struct page *page = virt_to_head_page(data[i]);
@@ -503,12 +527,12 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 		return;
 
 	/* Bulk producer into ptr_ring page_pool cache */
-	page_pool_ring_lock(pool);
+	in_softirq = page_pool_producer_lock(pool);
 	for (i = 0; i < bulk_len; i++) {
 		if (__ptr_ring_produce(&pool->ring, data[i]))
 			break; /* ring full */
 	}
-	page_pool_ring_unlock(pool);
+	page_pool_producer_unlock(pool, in_softirq);
 
 	/* Hopefully all pages was return into ptr_ring */
 	if (likely(i == bulk_len))
-- 
2.39.2



