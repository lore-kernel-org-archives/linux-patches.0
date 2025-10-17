Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287C6337100;
	Fri, 17 Oct 2025 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714728; cv=none; b=IetdXyhWbWgAPywIhFKpBKhpHqWHgvTKVY8iiiTRlUlPGLZ65cQmMZ8FRRTVHy9ggW6RPVj039n+1bWWAJAZ1LTK7JJ79PZFrJFXkSRMcN6vpa7I0f0C6p/G/RbvOF8Uxj7GnA1o/SaYxi6P2oclLm76no15B5mlbZvyOSbwKdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714728; c=relaxed/simple;
	bh=+MHn9iKl5bBnlnY5NUh0yE7FzfUwXpME39CZDDBex/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q01/GB0J+kt6LkzkCSd9A1ak4g+SMaGT/SFsObK4oHrxod5tgyFhXklul8YnAo8Tncu2nYlKnDvteeevFctFxcHOqep+xOiIWXGwnhB/85/CHWBs6MUyFya6yXSZMNX9feet4eSwwq6WYKjIP2cjFA5/9tJIppRfjM4Uix2DEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlMaE8x6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlMaE8x6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C7EC4CEE7;
	Fri, 17 Oct 2025 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714728;
	bh=+MHn9iKl5bBnlnY5NUh0yE7FzfUwXpME39CZDDBex/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlMaE8x6cOqGW8EoLiSh+bNhM0KqBuGu+ACCw1RS9Va4g0QSFB1jMxv9I30GcmIPl
	 +Wd6mEERsE3QFXLJWb4F5ua9w5dQswrLpUZwzE360hFD578pHLZQIcPAMKd6I6Vuc/
	 INuUlh5/b/f7f0HvDXi77QuMLtROwHCZ23xCFFyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 212/277] ext4: add ext4_sb_bread_nofail() helper function for ext4_free_branches()
Date: Fri, 17 Oct 2025 16:53:39 +0200
Message-ID: <20251017145154.872325487@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit d8b90e6387a74bcb1714c8d1e6a782ff709de9a9 upstream.

The implicit __GFP_NOFAIL flag in ext4_sb_bread() was removed in commit
8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()"), meaning
the function can now fail under memory pressure.

Most callers of ext4_sb_bread() propagate the error to userspace and do not
remount the filesystem read-only. However, ext4_free_branches() handles
ext4_sb_bread() failure by remounting the filesystem read-only.

This implies that an ext3 filesystem (mounted via the ext4 driver) could be
forcibly remounted read-only due to a transient page allocation failure,
which is unacceptable.

To mitigate this, introduce a new helper function, ext4_sb_bread_nofail(),
which explicitly uses __GFP_NOFAIL, and use it in ext4_free_branches().

Fixes: 8a83ac54940d ("ext4: call bdev_getblk() from sb_getblk_gfp()")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h     |    2 ++
 fs/ext4/indirect.c |    2 +-
 fs/ext4/super.c    |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3107,6 +3107,8 @@ extern struct buffer_head *ext4_sb_bread
 					 sector_t block, blk_opf_t op_flags);
 extern struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
 						   sector_t block);
+extern struct buffer_head *ext4_sb_bread_nofail(struct super_block *sb,
+						sector_t block);
 extern void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
 				bh_end_io_t *end_io, bool simu_fail);
 extern int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1025,7 +1025,7 @@ static void ext4_free_branches(handle_t
 			}
 
 			/* Go read the buffer for the next level down */
-			bh = ext4_sb_bread(inode->i_sb, nr, 0);
+			bh = ext4_sb_bread_nofail(inode->i_sb, nr);
 
 			/*
 			 * A read failure? Report error and clear slot
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -266,6 +266,15 @@ struct buffer_head *ext4_sb_bread_unmova
 	return __ext4_sb_bread_gfp(sb, block, 0, gfp);
 }
 
+struct buffer_head *ext4_sb_bread_nofail(struct super_block *sb,
+					 sector_t block)
+{
+	gfp_t gfp = mapping_gfp_constraint(sb->s_bdev->bd_mapping,
+			~__GFP_FS) | __GFP_MOVABLE | __GFP_NOFAIL;
+
+	return __ext4_sb_bread_gfp(sb, block, 0, gfp);
+}
+
 void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 {
 	struct buffer_head *bh = bdev_getblk(sb->s_bdev, block,


