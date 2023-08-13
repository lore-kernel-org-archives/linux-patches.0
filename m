Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F859443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEA7C433C7;
	Sun, 13 Aug 2023 21:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961937;
	bh=XHFufILvnS2pkIk6rDSBWLu1ZV085aBG5lgvPFPLzzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+uYGrATMRdkNCiO7OS4/d2d6c7x2K0eKIt+OS6F67xv9njkd8iHEpMgFfDSm8g/c
	 HqU6zEwhVtAWCiBss9Smvvw090fyK4j/ETYhQKeXwYqSPPz1pGFhh57yntCJ1c3z29
	 zckHBBEpsI6SEu0I5bjKN/O/x+XCT7CmNTrtKjC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Yang <andrew.yang@mediatek.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 052/206] zsmalloc: fix races between modifications of fullness and isolated
Date: Sun, 13 Aug 2023 23:17:02 +0200
Message-ID: <20230813211726.504101325@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Yang <andrew.yang@mediatek.com>

commit 4b5d1e47b69426c0f7491d97d73ad0152d02d437 upstream.

We encountered many kernel exceptions of VM_BUG_ON(zspage->isolated ==
0) in dec_zspage_isolation() and BUG_ON(!pages[1]) in zs_unmap_object()
lately.  This issue only occurs when migration and reclamation occur at
the same time.

With our memory stress test, we can reproduce this issue several times
a day.  We have no idea why no one else encountered this issue.  BTW,
we switched to the new kernel version with this defect a few months
ago.

Since fullness and isolated share the same unsigned int, modifications of
them should be protected by the same lock.

[andrew.yang@mediatek.com: move comment]
  Link: https://lkml.kernel.org/r/20230727062910.6337-1-andrew.yang@mediatek.com
Link: https://lkml.kernel.org/r/20230721063705.11455-1-andrew.yang@mediatek.com
Fixes: c4549b871102 ("zsmalloc: remove zspage isolation for migration")
Signed-off-by: Andrew Yang <andrew.yang@mediatek.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1977,6 +1977,7 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
+	struct zs_pool *pool;
 	struct zspage *zspage;
 
 	/*
@@ -1986,9 +1987,10 @@ static bool zs_page_isolate(struct page
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	migrate_write_lock(zspage);
+	pool = zspage->pool;
+	spin_lock(&pool->lock);
 	inc_zspage_isolation(zspage);
-	migrate_write_unlock(zspage);
+	spin_unlock(&pool->lock);
 
 	return true;
 }
@@ -2054,12 +2056,12 @@ static int zs_page_migrate(struct page *
 	kunmap_atomic(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
+	dec_zspage_isolation(zspage);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release the pool's lock.
 	 */
 	spin_unlock(&pool->lock);
-	dec_zspage_isolation(zspage);
 	migrate_write_unlock(zspage);
 
 	get_page(newpage);
@@ -2076,14 +2078,16 @@ static int zs_page_migrate(struct page *
 
 static void zs_page_putback(struct page *page)
 {
+	struct zs_pool *pool;
 	struct zspage *zspage;
 
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	migrate_write_lock(zspage);
+	pool = zspage->pool;
+	spin_lock(&pool->lock);
 	dec_zspage_isolation(zspage);
-	migrate_write_unlock(zspage);
+	spin_unlock(&pool->lock);
 }
 
 static const struct movable_operations zsmalloc_mops = {


