Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11363263C7B;
	Thu, 17 Apr 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914800; cv=none; b=XpHE5Yshpitknr19j1P/DcxPXiWYBRZpLsnRFsxUs8gVm6HxoYKvUFKghvbYo6BmQe8ghWQll3U2Br8iRmUeOLriCy8TeK4skAD1wvywNAwY8luqpCbEblt3A2szmH+9BFXvn5lJtqDzNTl18jBVelNTJoZBixYeT/PvDEd3ezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914800; c=relaxed/simple;
	bh=0ZAUjeYO82CfKGTKWDOBqjXHVKFHW1YQqvaB599+BbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9hSFcnLtUkoWmgXrfbm3S5fjZlZV/KMO9owalJAMqU2dK8H598HTWyJsQlK/198eOvctritCLKlWShevypyiCaLcFzUNpwssdTlpS5DDtTsTt0aUFr3rO47NBZ8tT11MYmxrtqBfhGbJMa9/P8GUectyrul4i1EBC0qGqp9Gr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYK3MxTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYK3MxTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD62C4CEE4;
	Thu, 17 Apr 2025 18:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914799;
	bh=0ZAUjeYO82CfKGTKWDOBqjXHVKFHW1YQqvaB599+BbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYK3MxTk7MS1D0yYaEkP/v2JKY6l3pFCJ1b2x2F/XuXQy10dJxvlxvdFJ4hlgtp0v
	 WWtlXj7jmwbdyZRCajK+D+jPYeB5FdY34d+K7rlGHL/e/rCkVCJXn44Lt39Zx2mnQ/
	 iE0ycf1x1kXvwwQiYpPndJHnCOAfq6LMtrsCFxTM=
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
Subject: [PATCH 6.13 334/414] mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
Date: Thu, 17 Apr 2025 19:51:32 +0200
Message-ID: <20250417175124.866990206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1113,6 +1113,12 @@ static inline bool is_page_hwpoison(cons
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
@@ -3121,8 +3121,7 @@ shmem_write_begin(struct file *file, str
 	if (ret)
 		return ret;
 
-	if (folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+	if (folio_contain_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;


