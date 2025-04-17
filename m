Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B6223710;
	Thu, 17 Apr 2025 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913517; cv=none; b=FtFkpDj/icnh5KeGtFMoeyREk6oQhhNmsSB2pput2u4n6zvXYsS4u7GEzSBPK4/PJ6z/iV6w9Ys9MO0eb/dlWlk0a1G2KniPlyj9brN6acYCkEDlXd3BqB4J7ejpBmay/N37R8pyeqGYiEBwwqE9eoV9szKt25gudQq2wKM+FaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913517; c=relaxed/simple;
	bh=eFYZ97EzyIDwA1UUOUW1Hr//JfE/6+xDSh4+0Hsbwe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/sqO5SkskUW2U3OWYuhT0vFFrspUhboWWb+33BnETTHjNYnLeWH/lk9VajG74niNOZs6ZqYKTYP/r3zrTFAdWTi+MqFbNcg0s0c29rSBs2YGy0ancfTejkvxVIoevinsv4V8lpQ1W6+5WpKU48uPJRAUq/OXXrfd217lrCxGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8QWRrRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8QWRrRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2880C4CEE4;
	Thu, 17 Apr 2025 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913517;
	bh=eFYZ97EzyIDwA1UUOUW1Hr//JfE/6+xDSh4+0Hsbwe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8QWRrRPlew5HqYfUMDA6rovP5PkBjRYhNLObdQDW5tT+WDmMMr0tO27NjybNAYej
	 sigCI4ldsaVBblHknp8wtieNnR8ndZO1gKi1pRI3GZ3N5vc9vQwywF12PGQOYeAeem
	 u22mHXizz+jru6W/CQYBuTogSDcw7NnAyvK7cNvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 366/449] mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
Date: Thu, 17 Apr 2025 19:50:54 +0200
Message-ID: <20250417175132.970733146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 5f5ee52d4f58605330b09851273d6e56aaadd29e upstream.

Patch series "mm/vmscan: don't try to reclaim hwpoison folio".

Fix a bug during memory reclaim if folio is hwpoisoned.


This patch (of 2):

Introduce helper folio_contain_hwpoisoned_page() to check if the entire
folio is hwpoisoned or it contains hwpoisoned pages.

Link: https://lkml.kernel.org/r/20250318083939.987651-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250318083939.987651-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page-flags.h |    6 ++++++
 mm/memory_hotplug.c        |    3 +--
 mm/shmem.c                 |    3 +--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1104,6 +1104,12 @@ static inline bool is_page_hwpoison(cons
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
+static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+{
+	return folio_test_hwpoison(folio) ||
+	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+}
+
 bool is_free_buddy_page(const struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1828,8 +1828,7 @@ static void do_migrate_range(unsigned lo
 		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
 
-		if (folio_test_hwpoison(folio) ||
-		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+		if (folio_contain_hwpoisoned_page(folio)) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio)) {
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3302,8 +3302,7 @@ shmem_write_begin(struct file *file, str
 	if (ret)
 		return ret;
 
-	if (folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+	if (folio_contain_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;


