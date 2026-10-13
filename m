Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A21B1A6803;
	Tue, 13 Oct 2026 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893805; cv=none; b=MaHibKKnWaTgt4kD/m/gE8r8qSX3WsrgHzP84ewBqKwSAYHYkeHsdu/cVi8Pduvd2KgkVNe6Dl55GWMynpzD18XXVWwPgon86UVwlvD2hREIGQtAiAIOrUn/L5/OtKGhW840NzEa/33V0JFk2abey7dxkh75DoE9XCr6kZIPZko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893805; c=relaxed/simple;
	bh=5StCNjHokdcWT9KO7iL7XZ/zxTZU6rxpo4V91Tka9Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFDQzQHiRRggERdGE3I6FK2RBZJiDFkEAvTPcp7U4k8HM11LfIAmqYf3AY/u4duLSvhXzHRVIEpImaOCspMiDlaZBvXcCwiRqsHWwmCCWKO9UF+yZ4OP4lHEAoYPJ5JfyENCKGKYOew7MhLLT9SjuHojpYF9udj8x1OW3krvEhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuroWMkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuroWMkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838991F000FF;
	Tue, 13 Oct 2026 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893804;
	bh=T4lQGDumkvGXSWGoLFyyawdo3T2Iqfkoy9v/r+lwehM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuroWMkEkYZkixqtTXKxxumu14p/7aj1BBFRje5HV05Q5UK3mNddB82H1psUr18di
	 JE5ukbtZRTwUi+eS6Uf4rSPkMfnNkaevNTG8R1VKpfBdQf9qiD3tlIBFLOg8cDw+Nr
	 yl6ZOg23Iw8DhESFkfzNpLmOyGcOgVKsu2L4onj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/621] ext4: add mext_check_validity() to do basic check
Date: Tue, 13 Oct 2026 13:34:59 +0200
Message-ID: <20261013112928.067955581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 22218516e462d59b27ffcfc9dd75d4f98e482c51 ]

Currently, the basic validation checks during the move extent operation
are scattered across __ext4_ioctl() and ext4_move_extents(), which makes
the code somewhat disorganized. Introduce a new helper,
mext_check_validity(), to handle these checks. This change involves only
code relocation without any logical modifications.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251013015128.499308-7-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c143957520c6 ("ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c       |  10 -----
 fs/ext4/move_extent.c | 102 +++++++++++++++++++++++++++---------------
 2 files changed, 65 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fbf5771eca993..c7ca6d8f7bd28 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1654,16 +1654,6 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!(fd_file(donor)->f_mode & FMODE_WRITE))
 			return -EBADF;
 
-		if (ext4_has_feature_bigalloc(sb)) {
-			ext4_msg(sb, KERN_ERR,
-				 "Online defrag not supported with bigalloc");
-			return -EOPNOTSUPP;
-		} else if (IS_DAX(inode)) {
-			ext4_msg(sb, KERN_ERR,
-				 "Online defrag not supported with DAX");
-			return -EOPNOTSUPP;
-		}
-
 		err = mnt_want_write_file(filp);
 		if (err)
 			return err;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 0f4b7c89edd39..e2705ea5e5c63 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -442,6 +442,68 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	goto unlock_folios;
 }
 
+/*
+ * Check the validity of the basic filesystem environment and the
+ * inodes' support status.
+ */
+static int mext_check_validity(struct inode *orig_inode,
+			       struct inode *donor_inode)
+{
+	struct super_block *sb = orig_inode->i_sb;
+
+	/* origin and donor should be different inodes */
+	if (orig_inode == donor_inode) {
+		ext4_debug("ext4 move extent: The argument files should not be same inode [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
+	/* origin and donor should belone to the same filesystem */
+	if (orig_inode->i_sb != donor_inode->i_sb) {
+		ext4_debug("ext4 move extent: The argument files should be in same FS [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
+	/* Regular file check */
+	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
+		ext4_debug("ext4 move extent: The argument files should be regular file [ino:orig %lu, donor %lu]\n",
+			   orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
+	if (ext4_has_feature_bigalloc(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Online defrag not supported with bigalloc");
+		return -EOPNOTSUPP;
+	}
+
+	if (IS_DAX(orig_inode)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Online defrag not supported with DAX");
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * TODO: it's not obvious how to swap blocks for inodes with full
+	 * journaling enabled.
+	 */
+	if (ext4_should_journal_data(orig_inode) ||
+	    ext4_should_journal_data(donor_inode)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Online defrag not supported with data journaling");
+		return -EOPNOTSUPP;
+	}
+
+	if (IS_ENCRYPTED(orig_inode) || IS_ENCRYPTED(donor_inode)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Online defrag not supported for encrypted files");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 /**
  * mext_check_arguments - Check whether move extent can be done
  *
@@ -570,43 +632,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 	ext4_lblk_t d_start = donor_blk;
 	int ret;
 
-	if (orig_inode->i_sb != donor_inode->i_sb) {
-		ext4_debug("ext4 move extent: The argument files "
-			"should be in same FS [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
-	/* orig and donor should be different inodes */
-	if (orig_inode == donor_inode) {
-		ext4_debug("ext4 move extent: The argument files should not "
-			"be same inode [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
-	/* Regular file check */
-	if (!S_ISREG(orig_inode->i_mode) || !S_ISREG(donor_inode->i_mode)) {
-		ext4_debug("ext4 move extent: The argument files should be "
-			"regular file [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
-	/* TODO: it's not obvious how to swap blocks for inodes with full
-	   journaling enabled */
-	if (ext4_should_journal_data(orig_inode) ||
-	    ext4_should_journal_data(donor_inode)) {
-		ext4_msg(orig_inode->i_sb, KERN_ERR,
-			 "Online defrag not supported with data journaling");
-		return -EOPNOTSUPP;
-	}
-
-	if (IS_ENCRYPTED(orig_inode) || IS_ENCRYPTED(donor_inode)) {
-		ext4_msg(orig_inode->i_sb, KERN_ERR,
-			 "Online defrag not supported for encrypted files");
-		return -EOPNOTSUPP;
-	}
+	ret = mext_check_validity(orig_inode, donor_inode);
+	if (ret)
+		return ret;
 
 	/* Protect orig and donor inodes against a truncate */
 	lock_two_nondirectories(orig_inode, donor_inode);
-- 
2.53.0



