Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C67B18BC2F;
	Mon, 24 Feb 2025 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408254; cv=none; b=jkGp+4s+L2xrnw1Fx8eBhEXwU9kvuQFDNOtfMJF+c/uE4D20S0HDYFeAkNzYFhZ7MGClzOLT+NfobNPr9tyxZs9piwX5fEqoigL4yU6NQjpQo7oVhhNyTxbgtUDkNI3PUsRY5+7uXRpzvkyqCCRqun3I5TBNMgPHg9qd2DmaeoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408254; c=relaxed/simple;
	bh=EdlsDqmjyDMZKGbx9yi5gjVdIidqspDVnbWDoe1ipWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhU9KnAiIYkWlUXE4AHZyeB78YrCTbI87UD26Z474xvnA7yGjlsLFJ+IKda6Az7hecvvOdVZdz7G9HUy/ELb1EJTrM1o1u99tr6BQCfakuBnkB8mKRhhnnBuLEsFNK4gPuJpn/Ynw016QxTkzEH88sVKH3sYMgNxqQzPIoLtadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBzhjtLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBzhjtLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D95C4CEE6;
	Mon, 24 Feb 2025 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408254;
	bh=EdlsDqmjyDMZKGbx9yi5gjVdIidqspDVnbWDoe1ipWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBzhjtLWfS4rmTxhcFPJRxDtZ0mVSmBh/UB9/WgOP4xuMB5qyRCyjDj0Wv8CI224d
	 8xAgV2KSaqfsn7ECGCdjjVbVuCyZuZD47ZzQPERVPRA6qZBvHJrCU5UA7Rp9T77jIi
	 kDsXsSZcDMlhjcow/l1EfG5FgpiyThCOzNBpgWCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 6.6 137/140] nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link
Date: Mon, 24 Feb 2025 15:35:36 +0100
Message-ID: <20250224142608.391916959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 584db20c181f5e28c0386d7987406ace7fbd3e49 upstream.

Patch series "nilfs2: Folio conversions for directory paths".

This series applies page->folio conversions to nilfs2 directory
operations.  This reduces hidden compound_head() calls and also converts
deprecated kmap calls to kmap_local in the directory code.

Although nilfs2 does not yet support large folios, Matthew has done his
best here to include support for large folios, which will be needed for
devices with large block sizes.

This series corresponds to the second half of the original post [1], but
with two complementary patches inserted at the beginning and some
adjustments, to prevent a kmap_local constraint violation found during
testing with highmem mapping.

[1] https://lkml.kernel.org/r/20231106173903.1734114-1-willy@infradead.org

I have reviewed all changes and tested this for regular and small block
sizes, both on machines with and without highmem mapping.  No issues
found.

This patch (of 17):

In a few directory operations, the call to nilfs_put_page() for a page
obtained using nilfs_find_entry() or nilfs_dotdot() is hidden in
nilfs_set_link() and nilfs_delete_entry(), making it difficult to track
page release and preventing change of its call position.

By moving nilfs_put_page() out of these functions, this makes the page
get/put correspondence clearer and makes it easier to swap
nilfs_put_page() calls (and kunmap calls within them) when modifying
multiple directory entries simultaneously in nilfs_rename().

Also, update comments for nilfs_set_link() and nilfs_delete_entry() to
reflect changes in their behavior.

To make nilfs_put_page() visible from namei.c, this moves its definition
to nilfs.h and replaces existing equivalents to use it, but the exposure
of that definition is temporary and will be removed on a later kmap ->
kmap_local conversion.

Link: https://lkml.kernel.org/r/20231127143036.2425-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20231127143036.2425-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ee70999a988b ("nilfs2: handle errors that nilfs_prepare_chunk() may return")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dir.c   |   11 +----------
 fs/nilfs2/namei.c |   13 +++++++------
 fs/nilfs2/nilfs.h |    6 ++++++
 3 files changed, 14 insertions(+), 16 deletions(-)

--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -64,12 +64,6 @@ static inline unsigned int nilfs_chunk_s
 	return inode->i_sb->s_blocksize;
 }
 
-static inline void nilfs_put_page(struct page *page)
-{
-	kunmap(page);
-	put_page(page);
-}
-
 /*
  * Return the offset into page `page_nr' of the last valid
  * byte in that page, plus one.
@@ -450,7 +444,6 @@ int nilfs_inode_by_name(struct inode *di
 	return 0;
 }
 
-/* Releases the page */
 void nilfs_set_link(struct inode *dir, struct nilfs_dir_entry *de,
 		    struct page *page, struct inode *inode)
 {
@@ -465,7 +458,6 @@ void nilfs_set_link(struct inode *dir, s
 	de->inode = cpu_to_le64(inode->i_ino);
 	nilfs_set_de_type(de, inode);
 	nilfs_commit_chunk(page, mapping, from, to);
-	nilfs_put_page(page);
 	dir->i_mtime = inode_set_ctime_current(dir);
 }
 
@@ -569,7 +561,7 @@ out_unlock:
 
 /*
  * nilfs_delete_entry deletes a directory entry by merging it with the
- * previous entry. Page is up-to-date. Releases the page.
+ * previous entry. Page is up-to-date.
  */
 int nilfs_delete_entry(struct nilfs_dir_entry *dir, struct page *page)
 {
@@ -605,7 +597,6 @@ int nilfs_delete_entry(struct nilfs_dir_
 	nilfs_commit_chunk(page, mapping, from, to);
 	inode->i_mtime = inode_set_ctime_current(inode);
 out:
-	nilfs_put_page(page);
 	return err;
 }
 
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -297,6 +297,7 @@ static int nilfs_do_unlink(struct inode
 		set_nlink(inode, 1);
 	}
 	err = nilfs_delete_entry(de, page);
+	nilfs_put_page(page);
 	if (err)
 		goto out;
 
@@ -406,6 +407,7 @@ static int nilfs_rename(struct mnt_idmap
 			goto out_dir;
 		}
 		nilfs_set_link(new_dir, new_de, new_page, old_inode);
+		nilfs_put_page(new_page);
 		nilfs_mark_inode_dirty(new_dir);
 		inode_set_ctime_current(new_inode);
 		if (dir_de)
@@ -429,9 +431,11 @@ static int nilfs_rename(struct mnt_idmap
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
+	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
+		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
 	nilfs_mark_inode_dirty(old_dir);
@@ -441,13 +445,10 @@ static int nilfs_rename(struct mnt_idmap
 	return err;
 
 out_dir:
-	if (dir_de) {
-		kunmap(dir_page);
-		put_page(dir_page);
-	}
+	if (dir_de)
+		nilfs_put_page(dir_page);
 out_old:
-	kunmap(old_page);
-	put_page(old_page);
+	nilfs_put_page(old_page);
 out:
 	nilfs_transaction_abort(old_dir->i_sb);
 	return err;
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -243,6 +243,12 @@ extern struct nilfs_dir_entry *nilfs_dot
 extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 			   struct page *, struct inode *);
 
+static inline void nilfs_put_page(struct page *page)
+{
+	kunmap(page);
+	put_page(page);
+}
+
 /* file.c */
 extern int nilfs_sync_file(struct file *, loff_t, loff_t, int);
 


