Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731EF7640E;
	Tue, 30 Sep 2025 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245366; cv=none; b=Aik73dw+XXMUIvPnWQIVMzyiJ0FB7RGzRTgfkua5vVjRqhbpq9Sl+WzQXXFJfYgp1nKUP2yEQAY9hZUBMnCtL5kpnKQ4D8N19XeuaL7SIZvkGnajXL4jPwaNj6gCJ7N/sgwT8MLpqvSdzoi2HE4UJL/1NL+ASwUNj8mcltg4gjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245366; c=relaxed/simple;
	bh=A+m9xahocD+ANtAaq6N4cyNzcYXvd4UzKc7qRCeZrpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN3g0isy3q1OChz7yBFJFtbKMBf9CtEk1rEL5ZPxbrpW+TAu03l/m2gXUz/YzMeRDGWCXr6WeqIZxwdfXKGc6rIyyk5cQQ0rSHzxbsINgKJun0deJ8rW2iTR/tiqUisbzWKQmELfzQfJF5UgU1DaMx/X+mo8UlM9y3foQxDCKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKo22tBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKo22tBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E74C4CEF0;
	Tue, 30 Sep 2025 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245366;
	bh=A+m9xahocD+ANtAaq6N4cyNzcYXvd4UzKc7qRCeZrpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKo22tBNJDy/38j/SapWrdiwxfiyV17NYTu0ggl2Q+5w+/Wk9hka3LjGqIzJ6tas4
	 ssjlghmUl5Ed4YmUjXsv+jm1BL9TEsLa8JJgnkjkhb3qizn92dZYn9/XtMql6mPSVY
	 SM7TXgVzWo8NFyKWCClPDDzlsFn4b9rtCEJEKuH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/151] mm/hugetlb: fix folio is still mapped when deleted
Date: Tue, 30 Sep 2025 16:47:57 +0200
Message-ID: <20250930143833.452162058@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjiang Tu <tujinjiang@huawei.com>

[ Upstream commit 7b7387650dcf2881fd8bb55bcf3c8bd6c9542dd7 ]

Migration may be raced with fallocating hole.  remove_inode_single_folio
will unmap the folio if the folio is still mapped.  However, it's called
without folio lock.  If the folio is migrated and the mapped pte has been
converted to migration entry, folio_mapped() returns false, and won't
unmap it.  Due to extra refcount held by remove_inode_single_folio,
migration fails, restores migration entry to normal pte, and the folio is
mapped again.  As a result, we triggered BUG in filemap_unaccount_folio.

The log is as follows:
 BUG: Bad page cache in process hugetlb  pfn:156c00
 page: refcount:515 mapcount:0 mapping:0000000099fef6e1 index:0x0 pfn:0x156c00
 head: order:9 mapcount:1 entire_mapcount:1 nr_pages_mapped:0 pincount:0
 aops:hugetlbfs_aops ino:dcc dentry name(?):"my_hugepage_file"
 flags: 0x17ffffc00000c1(locked|waiters|head|node=0|zone=2|lastcpupid=0x1fffff)
 page_type: f4(hugetlb)
 page dumped because: still mapped when deleted
 CPU: 1 UID: 0 PID: 395 Comm: hugetlb Not tainted 6.17.0-rc5-00044-g7aac71907bde-dirty #484 NONE
 Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
 Call Trace:
  <TASK>
  dump_stack_lvl+0x4f/0x70
  filemap_unaccount_folio+0xc4/0x1c0
  __filemap_remove_folio+0x38/0x1c0
  filemap_remove_folio+0x41/0xd0
  remove_inode_hugepages+0x142/0x250
  hugetlbfs_fallocate+0x471/0x5a0
  vfs_fallocate+0x149/0x380

Hold folio lock before checking if the folio is mapped to avold race with
migration.

Link: https://lkml.kernel.org/r/20250912074139.3575005-1-tujinjiang@huawei.com
Fixes: 4aae8d1c051e ("mm/hugetlbfs: unmap pages if page fault raced with hole punch")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ folio -> page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -519,13 +519,13 @@ static void remove_inode_hugepages(struc
 
 			/*
 			 * If page is mapped, it was faulted in after being
-			 * unmapped in caller.  Unmap (again) now after taking
-			 * the fault mutex.  The mutex will prevent faults
-			 * until we finish removing the page.
-			 *
-			 * This race can only happen in the hole punch case.
-			 * Getting here in a truncate operation is a bug.
+			 * unmapped in caller or hugetlb_vmdelete_list() skips
+			 * unmapping it due to fail to grab lock.  Unmap (again)
+			 * while holding the fault mutex.  The mutex will prevent
+			 * faults until we finish removing the page.  Hold page
+			 * lock to guarantee no concurrent migration.
 			 */
+			lock_page(page);
 			if (unlikely(page_mapped(page))) {
 				BUG_ON(truncate_op);
 
@@ -537,8 +537,6 @@ static void remove_inode_hugepages(struc
 					(index + 1) * pages_per_huge_page(h));
 				i_mmap_unlock_write(mapping);
 			}
-
-			lock_page(page);
 			/*
 			 * We must free the huge page and remove from page
 			 * cache (remove_huge_page) BEFORE removing the


