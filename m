Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751B330B14;
	Sat, 12 Sep 2026 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224253; cv=none; b=uxHHXHnU3XLNzbgj0wu3SQUfc8vMmGWDaBqdRnARgkD5krrfSho7bJtrUxIGmn01jeYivNTKpLjYWAu1KcOoPHeiNwDMELik2iD5HDA8vKJaSq8QttkkhKHQxIg6T5PzO4urq/pm42LdU8PoxUTl+++4maOYrJN0cDPShcjEQHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224253; c=relaxed/simple;
	bh=syvReLBp4IgO27SMaFFgO/qYwydazCzi59T4fgkW+Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSTzGfgixddFEZCMxDERnCxd8c8jCRlJLUVcAYqhha/uespJRIVEy7KJoH2oK02zsjOwWKP7XzQMgeSHhqnX4erU9MUPiEMGNJX6ObucqDr+o/q6YGXOk83MQqNLowpPoqS376NSKxkwKtJnHiLLPUw2wuD7Uk5EXMtStC4sZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmH3PrYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmH3PrYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007931F000FF;
	Sat, 12 Sep 2026 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224252;
	bh=fdKCFtp2LpGmUaEw/P0MZjhJDGGXVAAfnMxel1+ereY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmH3PrYUhOruU50+xi9jKSCVbIS+2aRQL3wo2sSwxgjVb/3Zlzspc7TvRG5dUQkm1
	 RWgF/jw2K4ZQ1jF2gHUaYOHYLnKo/GBHF5Q5pBNY3w/VFk502e2zEFGjt1PEyfHVrN
	 0k3PuB8YHaKIiX4jMp2VKCDvrsS1Ar9oq1y7Z4gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0913/1424] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch
Date: Sat, 12 Sep 2026 08:55:45 +0200
Message-ID: <20260912065627.771775195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 66f4ad3ce158902e5f98afea93189972ed8750c2 ]

Syzbot reported a kernel BUG triggered within nilfs_copy_dirty_pages(),
which copies dirty DAT file folios/pages to its shadow page cache.  The
BUG occurs when a retrieved dirty folio/page unexpectedly loses its
'dirty' status.

This issue arises because, since the commit referenced below, the 'dirty'
flag of a folio/page can be cleared asynchronously after the filesystem
detects metadata corruption and transitions to read-only mode.

Resolve the issue by returning an -EROFS error if the filesystem has
transitioned to read-only mode.  Also change the behavior to issue a
kernel warning only once instead of triggering a kernel BUG when this
unexpected 'dirty' state is detected while the filesystem is not in
read-only mode.

Reported-by: syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8baf9a79a3ffc6271cb6
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/page.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 06204110ae1f2..dd40357d836b2 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -242,6 +242,7 @@ static void nilfs_copy_page(struct page *dst, struct page *src, int copy_dirty)
 int nilfs_copy_dirty_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	struct inode *smap_inode = smap->host;
 	struct folio_batch fbatch;
 	unsigned int i;
 	pgoff_t index = 0;
@@ -257,8 +258,19 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 		struct folio *folio = fbatch.folios[i], *dfolio;
 
 		folio_lock(folio);
-		if (unlikely(!folio_test_dirty(folio)))
-			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
+		if (unlikely(!folio_test_dirty(folio))) {
+			if (WARN_ONCE(!sb_rdonly(smap_inode->i_sb),
+					"inconsistent dirty state\n"))
+				goto unlock_folio;
+
+			/*
+			 * If the filesystem has been forced to read-only
+			 * due to metadata corruption.
+			 */
+			folio_unlock(folio);
+			err = -EROFS;
+			break;
+		}
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
 		if (unlikely(IS_ERR(dfolio))) {
@@ -276,6 +288,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_unlock(dfolio);
 		folio_put(dfolio);
+unlock_folio:
 		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
-- 
2.53.0



