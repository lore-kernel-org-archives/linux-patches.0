Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BFE28935A;
	Fri, 17 Oct 2025 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715794; cv=none; b=Rw8kdHj8tKntzQUUfWz2G/GZpn0Nq/UGmdHDFhSEP7VpS1vrXWD/+qbU4Exdgn6u65mv2vaJd/NAAgr8mSa2VQ0B07m7ppQMt/b3GAzdswJgLnBCMMnsswnYMOJbAQz6zQAQWKHYIifNur3t0Xn5YVinOqnh6I7VDyLTm1VQ9QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715794; c=relaxed/simple;
	bh=H8pETXp6spKWNkEaQAbzpvjxzWiG+sgK2u5VCuDwcLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS7OYQzeTnZf9IpVem5rrH5xQyxXs0LRSbA/EwOvk9feNxKxj6bL+HxGN69OuE0ktXUj4Gb4EloMWjoifLfU3Ptr1w8iNJXC7drVb8fkrJ+OnfV1ZgMh12BHgxLCD1GQVIHTRCvXNTiYBpQCZoDv1kgGiVTY2r1femJbKfJUmv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjsjx6U6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjsjx6U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD8FC4CEFE;
	Fri, 17 Oct 2025 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715794;
	bh=H8pETXp6spKWNkEaQAbzpvjxzWiG+sgK2u5VCuDwcLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjsjx6U6jr5K0bmKu8ZvfgKkPAfHLnuN/VSCNAfvqU2ImilCPn19MRSxk/2TNJQRU
	 qpM/qpyZztruoZbRdjSuWBFIoPvhgwdfiWssA51nrCyPZxURc1Tu0Q1JLwUVrltWAq
	 3PIEbMHvNQyzEVWM6sPsPdESE4vCkvSzVNwFo3+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 338/371] ext4: add ext4_sb_bread_nofail() helper function for ext4_free_branches()
Date: Fri, 17 Oct 2025 16:55:13 +0200
Message-ID: <20251017145214.312463252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3144,6 +3144,8 @@ extern struct buffer_head *ext4_sb_bread
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
@@ -265,6 +265,15 @@ struct buffer_head *ext4_sb_bread_unmova
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


