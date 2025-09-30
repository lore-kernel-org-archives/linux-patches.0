Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A1202C48;
	Tue, 30 Sep 2025 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244438; cv=none; b=WYlzxdJW4RCfY6lIzwUlO+BxEAG5MtivnxNGGKddUJms1irHKGE+sn0VUfbPElrBekh/oBc6TYLLTRX9TPCSsxhpDC8PAfGtPxqks8ucZafcHf8qeXQA13PmRM6BoZIwGFd6bs5Ro+R4uVFecZ5pZGwm4QKVmSk02JAVd4mPGGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244438; c=relaxed/simple;
	bh=H7d8dD54l8v15zhGCYLlf7z4D3Az6UN/VLokjxNT6zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCuI0FzrOAxm2RVrdyR0KKnetZb6UXKq3X5s2Z88/xfIdYIsK6uIYASUEvezUTGj9AcDF18nl03JvOl/pKC35U3cj+TBqF7roGAfBA63Olati2suHmfYcX1R7+w8AUr+Z+XnqytyZYYLPn+Yb8Z3ejlUPTAoSgqGMLbfLWqJAac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycJ1cqnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycJ1cqnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66E2C4CEF0;
	Tue, 30 Sep 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244438;
	bh=H7d8dD54l8v15zhGCYLlf7z4D3Az6UN/VLokjxNT6zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycJ1cqnUuz5644ZTN72QyLhvmlXYoGtb8j8iAnXYFqso5QVs3heMBGK1qqWI+xUf4
	 fQ2eVo2EBWph0tB830SfuGNz+wRkMEaMdzlEPZxs7zb5rP6aKKH/RQ78tgehH1XG40
	 gePTWxPuOOAyHlglYzABlwvaj/37KoPxtS/jJgko=
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
Subject: [PATCH 5.10 122/122] mm/hugetlb: fix folio is still mapped when deleted
Date: Tue, 30 Sep 2025 16:47:33 +0200
Message-ID: <20250930143827.953003796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,13 +515,13 @@ static void remove_inode_hugepages(struc
 
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
 
@@ -533,8 +533,6 @@ static void remove_inode_hugepages(struc
 					(index + 1) * pages_per_huge_page(h));
 				i_mmap_unlock_write(mapping);
 			}
-
-			lock_page(page);
 			/*
 			 * We must free the huge page and remove from page
 			 * cache (remove_huge_page) BEFORE removing the


