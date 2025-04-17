Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122A1257AC3;
	Thu, 17 Apr 2025 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916008; cv=none; b=BCo9asZG6r52IreOlBg5y6g8ik/GEwQBkTwu/Z4Hb7XhDrK7awl8KacIN7NJYNa3c7Ow5XbF8L8qIzm3tuVdJNR06FsLzORQCe/D/NHgcbBGQE9uuIYY9xtGHAmW9NbussijPfu4GjbppKdoWQxPLfXqQX35Hio5jD7MrNy9Ejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916008; c=relaxed/simple;
	bh=/ojVC2hHpfIM88fSFYbAqmu7J/u8J7+W6rRIjNqqDZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhHJ6zDrtpAniezJomUeZepSDXoFuRbzVqwmqKxWpI+7Jpnerv0mh+SgUD/2HUjo4MI9hi5fkEvleWUgO8+w+axISgaU85PoYTVPLckic99HoBVACB90QkIywNYzuZ9OeWwW5zMo/BHK/frbvidcqMIfMFsgCIoeatFQcXbgjCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoW49vr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoW49vr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FF9C4CEE4;
	Thu, 17 Apr 2025 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916007;
	bh=/ojVC2hHpfIM88fSFYbAqmu7J/u8J7+W6rRIjNqqDZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PoW49vr36zQG8CXNioVfie2nvukwlmOjWvS7OutF33bxPxjd346mgalx6potglE05
	 faxOEQOmfyQRX1OSaQsGBCtWCfHkwwNN95ruC9bfrBYjGWBaisisOy4rEAwTKaTeEW
	 nvjHP9epRe7KPL2TPgL1wrUtAA7zi7DktoXDwC/4=
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
Subject: [PATCH 6.12 312/393] mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
Date: Thu, 17 Apr 2025 19:52:01 +0200
Message-ID: <20250417175120.159491062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1111,6 +1111,12 @@ static inline bool is_page_hwpoison(cons
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
@@ -1801,8 +1801,7 @@ static void do_migrate_range(unsigned lo
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
@@ -3042,8 +3042,7 @@ shmem_write_begin(struct file *file, str
 	if (ret)
 		return ret;
 
-	if (folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+	if (folio_contain_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;


