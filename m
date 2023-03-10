Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA1C847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA4C4339B;
	Fri, 10 Mar 2023 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456550;
	bh=Y/F9FQehCBtrVJAaGZyYyQ8NBoZzhC7l6nfbBagWduk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OrO46Yi5e322c49BVLXbCD4n9IS34+UCgZev2TTrZ6sPcOn5BlBCKuzYdGvCzw/f
	 w2PwVoAwswMl5EB6yGhEpkwx8xgtTl0TiORMrKcUC3j/SEQ7TZyaF8S8cbwmGUwagr
	 YbwOmxi75TiidEyCj9+Tgxw87uSthDZBgXSbhdIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 040/211] ubifs: ubifs_releasepage: Remove ubifs_assert(0) to valid this process
Date: Fri, 10 Mar 2023 14:37:00 +0100
Message-Id: <20230310133719.949666902@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 66f4742e93523ab2f062d9d9828b3e590bc61536 ]

There are two states for ubifs writing pages:
1. Dirty, Private
2. Not Dirty, Not Private

The normal process cannot go to ubifs_releasepage() which means there
exists pages being private but not dirty. Reproducer[1] shows that it
could occur (which maybe related to [2]) with following process:

     PA                     PB                    PC
lock(page)[PA]
ubifs_write_end
  attach_page_private         // set Private
  __set_page_dirty_nobuffers  // set Dirty
unlock(page)

write_cache_pages[PA]
  lock(page)
  clear_page_dirty_for_io(page)	// clear Dirty
  ubifs_writepage

                        do_truncation[PB]
			  truncate_setsize
			    i_size_write(inode, newsize) // newsize = 0

    i_size = i_size_read(inode)	// i_size = 0
    end_index = i_size >> PAGE_SHIFT
    if (page->index > end_index)
      goto out // jump
out:
unlock(page)   // Private, Not Dirty

						generic_fadvise[PC]
						  lock(page)
						  invalidate_inode_page
						    try_to_release_page
						      ubifs_releasepage
						        ubifs_assert(c, 0)
		                                        // bad assertion!
						  unlock(page)
			  truncate_pagecache[PB]

Then we may get following assertion failed:
  UBIFS error (ubi0:0 pid 1683): ubifs_assert_failed [ubifs]:
  UBIFS assert failed: 0, in fs/ubifs/file.c:1513
  UBIFS warning (ubi0:0 pid 1683): ubifs_ro_mode [ubifs]:
  switched to read-only mode, error -22
  CPU: 2 PID: 1683 Comm: aa Not tainted 5.16.0-rc5-00184-g0bca5994cacc-dirty #308
  Call Trace:
    dump_stack+0x13/0x1b
    ubifs_ro_mode+0x54/0x60 [ubifs]
    ubifs_assert_failed+0x4b/0x80 [ubifs]
    ubifs_releasepage+0x67/0x1d0 [ubifs]
    try_to_release_page+0x57/0xe0
    invalidate_inode_page+0xfb/0x130
    __invalidate_mapping_pages+0xb9/0x280
    invalidate_mapping_pagevec+0x12/0x20
    generic_fadvise+0x303/0x3c0
    ksys_fadvise64_64+0x4c/0xb0

[1] https://bugzilla.kernel.org/show_bug.cgi?id=215373
[2] https://linux-mtd.infradead.narkive.com/NQoBeT1u/patch-rfc-ubifs-fix-assert-failed-in-ubifs-set-page-dirty

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/file.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 1f429260a85fc..10c1779af9c51 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1472,14 +1472,23 @@ static bool ubifs_release_folio(struct folio *folio, gfp_t unused_gfp_flags)
 	struct inode *inode = folio->mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 
-	/*
-	 * An attempt to release a dirty page without budgeting for it - should
-	 * not happen.
-	 */
 	if (folio_test_writeback(folio))
 		return false;
+
+	/*
+	 * Page is private but not dirty, weird? There is one condition
+	 * making it happened. ubifs_writepage skipped the page because
+	 * page index beyonds isize (for example. truncated by other
+	 * process named A), then the page is invalidated by fadvise64
+	 * syscall before being truncated by process A.
+	 */
 	ubifs_assert(c, folio_test_private(folio));
-	ubifs_assert(c, 0);
+	if (folio_test_checked(folio))
+		release_new_page_budget(c);
+	else
+		release_existing_page_budget(c);
+
+	atomic_long_dec(&c->dirty_pg_cnt);
 	folio_detach_private(folio);
 	folio_clear_checked(folio);
 	return true;
-- 
2.39.2



