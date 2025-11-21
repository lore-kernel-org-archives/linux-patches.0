Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CB334B1B7;
	Fri, 21 Nov 2025 13:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732072; cv=none; b=sLmsROTu4THlAKR8qO2VUP9WEhKJMCMfaSRKjyH++GgsX4Q9y0xeqAW5isPoN350RK9AT0vScmcpeklwBddv49ZsVp92eZoRDWrQFTdM7yYDBLxdlrKELUqnbtua3o0i7xjWICkkRx48aCn4YdQ/hSNGl/DTrtGBf+fANWxUYBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732072; c=relaxed/simple;
	bh=rgnsdCYTIACZt9+mf80x7C+qd7mn0CgZxmOUxFIi5nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm6Gq7VEQ5VbFb5NjOwGwnmfdXrquVqlDyMQcyVIzR6QrEBgxtSs3H0ZRlxbbOdhbvUdwzxfTc9J7YPEXCcD7M1kgBpFlGMLQmxcWKKy9XxLIOsoB3J7Pshy+QaMMYZmt1zZW7LChUUGpHwcZcJdsfkjwAtv1u7/KEBz+oqHQZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se5b8uDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se5b8uDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904BEC4CEF1;
	Fri, 21 Nov 2025 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732071;
	bh=rgnsdCYTIACZt9+mf80x7C+qd7mn0CgZxmOUxFIi5nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Se5b8uDWg6G34h2Vpa1Fsbu1LfEkqVO0pDUE//yeZP4rZT2IURxxZveSq68DXg9OH
	 i1xqJT5E3akM5DbzjZfzm75yWl1cKcGY+gnLcqY/ffv6HY+1b/OqKqoS1RO4PxPVgy
	 z4KNRes9c5QebR6kNHtlqqtYcsYqlxePaHPQjmAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 179/185] mm/huge_memory: do not change split_huge_page*() target order silently
Date: Fri, 21 Nov 2025 14:13:26 +0100
Message-ID: <20251121130150.350977461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 77008e1b2ef73249bceb078a321a3ff6bc087afb upstream.

Page cache folios from a file system that support large block size (LBS)
can have minimal folio order greater than 0, thus a high order folio might
not be able to be split down to order-0.  Commit e220917fa507 ("mm: split
a folio in minimum folio order chunks") bumps the target order of
split_huge_page*() to the minimum allowed order when splitting a LBS
folio.  This causes confusion for some split_huge_page*() callers like
memory failure handling code, since they expect after-split folios all
have order-0 when split succeeds but in reality get min_order_for_split()
order folios and give warnings.

Fix it by failing a split if the folio cannot be split to the target
order.  Rename try_folio_split() to try_folio_split_to_order() to reflect
the added new_order parameter.  Remove its unused list parameter.

[The test poisons LBS folios, which cannot be split to order-0 folios, and
also tries to poison all memory.  The non split LBS folios take more
memory than the test anticipated, leading to OOM.  The patch fixed the
kernel warning and the test needs some change to avoid OOM.]

Link: https://lkml.kernel.org/r/20251017013630.139907-1-ziy@nvidia.com
Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |   21 +++++++--------------
 mm/huge_memory.c        |    7 +------
 2 files changed, 8 insertions(+), 20 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -353,20 +353,7 @@ int min_order_for_split(struct folio *fo
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * split_huge_page() locks the page before splitting and
-	 * expects the same page that has been split to be locked when
-	 * returned. split_folio(page_folio(page)) cannot be used here
-	 * because it converts the page to folio and passes the head
-	 * page to be split.
-	 */
-	return split_huge_page_to_list_to_order(page, NULL, ret);
+	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
@@ -538,6 +525,12 @@ static inline int split_huge_page(struct
 	return 0;
 }
 
+static inline int min_order_for_split(struct folio *folio)
+{
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
+}
+
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
 	return 0;
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3597,12 +3597,7 @@ int min_order_for_split(struct folio *fo
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	int ret = min_order_for_split(folio);
-
-	if (ret < 0)
-		return ret;
-
-	return split_huge_page_to_list_to_order(&folio->page, list, ret);
+	return split_huge_page_to_list_to_order(&folio->page, list, 0);
 }
 
 /*


