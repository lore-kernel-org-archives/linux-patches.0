Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F9A34A77D;
	Fri,  4 Sep 2026 05:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499048; cv=none; b=VlP3JeMlyxOKatS6ftlUGtyXx9olG7PA9c5kCYoL4xfUFMBKyfVGT02PmovDFodpgxjnlHg/i08xQroMrQhMOqaPEzbFeMSICf4Xb43utNu8iTn1Vwhxj6d90HYHxdum8GAm/1svdZdQ3KXTDFCCNY4kMBvXb/0t67teNf4AScA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499048; c=relaxed/simple;
	bh=1/UBR34ZrXzIw2SeXJB06IlvYZrfXqAuRxE5YgRz5Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amJovrkQTvTYqdqOlfD44UKWegCOp/8vqhr0js/SdKCiG2M0ZMoADeLPBuilKCUz8u7+42OGIaNlG6wHJsp819DpgDY2d2XBMU9Xu3vXdodGYZgiFOYIOvH5ExRLszJ0VEW7EY2PNOeY3Sx6QkLATr6Kdlb+CvQeLXLpg608Qbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwDSTPiD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwDSTPiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4E31F00A3D;
	Fri,  4 Sep 2026 05:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499046;
	bh=CwsbCQLnu8PXl3qiBjXJrikihK9bZUwyC4YgvlKs8b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwDSTPiDw5tef4PuODDK4dA/JsvIbrUiV5UXuSnle07/rXCFkvWv9ldodHkgA2LR9
	 xrPP0sjGiTO82cBox1M4Fe0bOIuJCuntZQ/FocUC/51MSmhCN0w4qOl5681Ut/+QHa
	 2LFNWB+8FO6XP1CU69PRhXNzk4Mcqm6HczQ2rNqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 280/713] ext2: Fix lost inode updates for IS_SYNC inodes
Date: Fri,  4 Sep 2026 06:54:08 +0200
Message-ID: <20260904045810.118333686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 356984d1a5c32e94810cbb6c8dc7d8ff2d4d919a upstream.

ext2_setsize() and ext2_xattr_set2() had a construct like:

	if (IS_SYNC(inode)) {
		sync_inode_metadata(inode, 1);
	} else {
		mark_inode_dirty(inode);
	}

which leads to lost inode updates for IS_SYNC inodes because
sync_inode_metadata() does anything only if the inode is already dirty
and hence inode updates may be simply lost. Fix the problem by
unconditionally marking the inode dirty and *then* call
sync_inode_metadata().

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260727104923.3828017-26-jack@suse.cz
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/inode.c |    7 ++-----
 fs/ext2/xattr.c |    4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1258,12 +1258,9 @@ static int ext2_setsize(struct inode *in
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	if (inode_needs_sync(inode)) {
-		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
+	mark_inode_dirty(inode);
+	if (inode_needs_sync(inode))
 		sync_inode_metadata(inode, 1);
-	} else {
-		mark_inode_dirty(inode);
-	}
 
 	return 0;
 }
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -777,6 +777,7 @@ ext2_xattr_set2(struct inode *inode, str
 	/* Update the inode. */
 	EXT2_I(inode)->i_file_acl = new_bh ? new_bh->b_blocknr : 0;
 	inode_set_ctime_current(inode);
+	mark_inode_dirty(inode);
 	if (IS_SYNC(inode)) {
 		error = sync_inode_metadata(inode, 1);
 		/* In case sync failed due to ENOSPC the inode was actually
@@ -789,8 +790,7 @@ ext2_xattr_set2(struct inode *inode, str
 			}
 			goto cleanup;
 		}
-	} else
-		mark_inode_dirty(inode);
+	}
 
 	error = 0;
 	if (old_bh && old_bh != new_bh) {


