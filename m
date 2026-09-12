Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB942BDC0E;
	Sat, 12 Sep 2026 10:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208464; cv=none; b=PaRN2RAsYPTBYJYpizYuvcptQS5vSQSCBRjL+4epkOhd9L2/d71ujusv8h7e9/tTqqmlw9Jzwb6pBHcV9nQL1sKSp/cfI7p+D4hI2RJVv9IcgW8gF+R/m8gnbfUd3XVnYkAN+MifCRSPuc9PJDN6Yx0juDyUCIpi79+8hkoHK0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208464; c=relaxed/simple;
	bh=30eEm6MYOlsJA3y64yc0byjIFBg/EryU6Zny6LH2fFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+q1q9vKYqHCajJJ6LDrbzVxRhiBTSNEgkTr4gpfZsMOjQ4U+3z4hBKmv/aWgVdh002MC9j+AJjSF3bR8n8cEuUGRC2qfOdbO7BHGlQhmHWWthJ2bxLZhswPZl6pCpkOrIGCWkdvnR4EMz8s4vhB1UfyHhtsqXA0t+EuH8vK5E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm/RxJna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm/RxJna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0DC1F000FF;
	Sat, 12 Sep 2026 10:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208462;
	bh=m63l2pUC0rjtvYprk7hz9ImQjIfuRBOOTyP2nBHjpMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm/RxJnaz9p+YCcZV3nG50o7OWJLfrvjSgc2UEqeAGpT9NiBJj6q40+J5+VgB1fHy
	 uk2cV3l4XYFX/mzvAOOHnWHb7N/egD7O4aG1CiYeFECzM5/CObZsNncJhiPkp31yPi
	 SqILCfUKTvvuMbss/C1Uf70kfKNJvcPSUDlWZSy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8baf9a79a3ffc6271cb6@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0622/1518] nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch
Date: Sat, 12 Sep 2026 08:46:31 +0200
Message-ID: <20260912065637.500993505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 56c4da417b6a1..89180e2f59fef 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -243,6 +243,7 @@ static void nilfs_copy_folio(struct folio *dst, struct folio *src,
 int nilfs_copy_dirty_pages(struct address_space *dmap,
 			   struct address_space *smap)
 {
+	struct inode *smap_inode = smap->host;
 	struct folio_batch fbatch;
 	unsigned int i;
 	pgoff_t index = 0;
@@ -258,8 +259,19 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
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
 		if (IS_ERR(dfolio)) {
@@ -277,6 +289,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_unlock(dfolio);
 		folio_put(dfolio);
+unlock_folio:
 		folio_unlock(folio);
 	}
 	folio_batch_release(&fbatch);
-- 
2.53.0



