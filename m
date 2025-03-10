Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421822F3BD;
	Mon, 10 Mar 2025 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631014; cv=none; b=mQMvVYgIfG294+lis+B2BgnHd11cp/bNELNu4UrI01FuWuRoaoQq8Va+ud5caai5wjAgXzg14AdQjR8vk9b0aqrT1cim4AVx8PO2iXQYbgX8imnY7KQ9QTRTfYffFGggCoKSQkqbVhZ24g05zJgUFEQSLn2+ZBUdLAO+rcGwj1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631014; c=relaxed/simple;
	bh=2JXE8Y9/gyitUeTvCtc81a4u2zp4Gu6MUlgbLhwbFik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4XTC5USfSYpZYrT6xK9USZ1YN8HIWOWuuJrDqVq8tmFUlAwVrcjJDHBMFal6Jx57Aw5aewb3BlNQY+5YJW8AvbP3U26XA8wMeWw3Px4Bo4bBetvBs0EVTXdKqkOjvbEWoo1fJ4NKt8QL8jJSVFpf6BukNU8zAVWtUknJWCQ/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmUED4Iv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmUED4Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8045BC4CEE5;
	Mon, 10 Mar 2025 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631013;
	bh=2JXE8Y9/gyitUeTvCtc81a4u2zp4Gu6MUlgbLhwbFik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmUED4IvD1Ysl+Djxhr6e8QxET7S6qOQ6fdpkh6BN1PKGo8KBIb4+X90bv+CeMbCf
	 Pu7MlR320W/EkRQJhudq+AzQn9DDih8f5atPMknBS704jMDa2U1v5JG6LCwPBdiDaI
	 aWHfnoAqMw+lBbqRhObTarHTC9WLFyza3LwIS09k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com,
	syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 612/620] nilfs2: handle errors that nilfs_prepare_chunk() may return
Date: Mon, 10 Mar 2025 18:07:38 +0100
Message-ID: <20250310170609.697157192@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit ee70999a988b8abc3490609142f50ebaa8344432 upstream.

Patch series "nilfs2: fix issues with rename operations".

This series fixes BUG_ON check failures reported by syzbot around rename
operations, and a minor behavioral issue where the mtime of a child
directory changes when it is renamed instead of moved.


This patch (of 2):

The directory manipulation routines nilfs_set_link() and
nilfs_delete_entry() rewrite the directory entry in the folio/page
previously read by nilfs_find_entry(), so error handling is omitted on the
assumption that nilfs_prepare_chunk(), which prepares the buffer for
rewriting, will always succeed for these.  And if an error is returned, it
triggers the legacy BUG_ON() checks in each routine.

This assumption is wrong, as proven by syzbot: the buffer layer called by
nilfs_prepare_chunk() may call nilfs_get_block() if necessary, which may
fail due to metadata corruption or other reasons.  This has been there all
along, but improved sanity checks and error handling may have made it more
reproducible in fuzzing tests.

Fix this issue by adding missing error paths in nilfs_set_link(),
nilfs_delete_entry(), and their caller nilfs_rename().

Link: https://lkml.kernel.org/r/20250111143518.7901-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20250111143518.7901-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+32c3706ebf5d95046ea1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=32c3706ebf5d95046ea1
Reported-by: syzbot+1097e95f134f37d9395c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1097e95f134f37d9395c
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c   |   13 ++++++++++---
 fs/nilfs2/namei.c |   29 +++++++++++++++--------------
 fs/nilfs2/nilfs.h |    4 ++--
 3 files changed, 27 insertions(+), 19 deletions(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -444,7 +444,7 @@ int nilfs_inode_by_name(struct inode *di
 	return 0;
 }
 
-void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
 	unsigned int from = (char *)de - (char *)page_address(page);
@@ -454,11 +454,15 @@ void nilfs_set_link(struct inode *dir, s
 
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		unlock_page(page);
+		return err;
+	}
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
 	nilfs_commit_chunk(page, mapping, from, to);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
+	return 0;
 }
 
 /*
@@ -590,7 +594,10 @@ int nilfs_delete_entry(struct nilfs_dir_
 		from = (char *)pde - (char *)page_address(page);
 	lock_page(page);
 	err = nilfs_prepare_chunk(page, from, to);
-	BUG_ON(err);
+	if (unlikely(err)) {
+		unlock_page(page);
+		goto out;
+	}
 	if (pde)
 		pde->rec_len = nilfs_rec_len_to_disk(to - from);
 	dir->inode = 0;
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -406,8 +406,10 @@ static int nilfs_rename(struct user_name
 			err = PTR_ERR(new_de);
 			goto out_dir;
 		}
-		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		err = nilfs_set_link(new_dir, new_de, new_page, old_inode);
 		nilfs_put_page(new_page);
+		if (unlikely(err))
+			goto out_dir;
 		nilfs_mark_inode_dirty(new_dir);
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
@@ -430,28 +432,27 @@ static int nilfs_rename(struct user_name
 	 */
 	old_inode->i_ctime = current_time(old_inode);
 
-	nilfs_delete_entry(old_de, old_page);
-
-	if (dir_de) {
-		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
-		nilfs_put_page(dir_page);
-		drop_nlink(old_dir);
+	err = nilfs_delete_entry(old_de, old_page);
+	if (likely(!err)) {
+		if (dir_de) {
+			err = nilfs_set_link(old_inode, dir_de, dir_page,
+					     new_dir);
+			drop_nlink(old_dir);
+		}
+		nilfs_mark_inode_dirty(old_dir);
 	}
-	nilfs_put_page(old_page);
-
-	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
-	err = nilfs_transaction_commit(old_dir->i_sb);
-	return err;
-
 out_dir:
 	if (dir_de)
 		nilfs_put_page(dir_page);
 out_old:
 	nilfs_put_page(old_page);
 out:
-	nilfs_transaction_abort(old_dir->i_sb);
+	if (likely(!err))
+		err = nilfs_transaction_commit(old_dir->i_sb);
+	else
+		nilfs_transaction_abort(old_dir->i_sb);
 	return err;
 }
 
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -240,8 +240,8 @@ nilfs_find_entry(struct inode *, const s
 extern int nilfs_delete_entry(struct nilfs_dir_entry *, struct page *);
 extern int nilfs_empty_dir(struct inode *);
 extern struct nilfs_dir_entry *nilfs_dotdot(struct inode *, struct page **);
-extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
-			   struct page *, struct inode *);
+int nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
+		   struct page *page, struct inode *inode);
 
 static inline void nilfs_put_page(struct page *page)
 {


