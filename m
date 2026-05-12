Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AFF375AB1;
	Tue, 12 May 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609648; cv=none; b=EQsUzn8Z/GGCDmowtfRY0CzQdb8fYvdln7YQZkvGyxmThK5Df4KN0qyN83Bvo9COorjVY3oaqXffwrCh2d/Nt8cqChKQglPNcTb/87sncJBSHcNvm+Djobvxfj7bcl9BzvS1oHRfzjwEBub/f188aDrjzLfCAMXBwgan92kXZf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609648; c=relaxed/simple;
	bh=qiurB8yIymldwSP2bZkeo6tBnAIPeCkoI4K9QZIZ140=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7+RrP35ZxRitt9ode1bkhaDVGcEtU7pXAhNHoH//V+RX/0aDrVrTDPBd/SIS/yf1z6Z8YhVTPDw2c28Q6PRT4xzLp2XyfCyTWEdabJ/lIaa+l2XWbkmzJRVioCO9Sw1mlEWyfm32qfLSJJrcGm0zqMafTJIZi6WqQ/uDs1Z/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POF5N4Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POF5N4Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD25C2BCF5;
	Tue, 12 May 2026 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609648;
	bh=qiurB8yIymldwSP2bZkeo6tBnAIPeCkoI4K9QZIZ140=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POF5N4KakgTledcOoLsAnRoUYV6O3UitdlL4zVoq48xUAHakBWNid5ebDfuv/bcSK
	 Bei4tZa7WyiPDLZJSnrFWtsN8nSSeuqGpdlo08agUwfVfcN2w+AGtWrPJd0ZVPBvb5
	 Qt8WFbHCircofcT3N6lqtWnZTNVLjNWm4M94IF0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 276/307] f2fs: fix inline data not being written to disk in writeback path
Date: Tue, 12 May 2026 19:41:11 +0200
Message-ID: <20260512173945.950170782@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit fe9b8b30b97102859a9102be7bd2a09803bd90bd upstream.

When f2fs_fiemap() is called with `fileinfo->fi_flags` containing the
FIEMAP_FLAG_SYNC flag, it attempts to write data to disk before
retrieving file mappings via filemap_write_and_wait(). However, there is
an issue where the file does not get mapped as expected. The following
scenario can occur:

root@vm:/mnt/f2fs# dd if=/dev/zero of=data.3k bs=3k count=1
root@vm:/mnt/f2fs# xfs_io data.3k -c "fiemap -v 0 4096"
data.3k:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..5]:          0..5                 6 0x307

The root cause of this issue is that f2fs_write_single_data_page() only
calls f2fs_write_inline_data() to copy data from the data folio to the
inode folio, and it clears the dirty flag on the data folio. However, it
does not mark the data folio as writeback. When
__filemap_fdatawait_range() checks for folios with the writeback flag,
it returns early, causing f2fs_fiemap() to report that the file has no
mapping.

To fix this issue, the solution is to call
f2fs_write_single_node_folio() in f2fs_inline_data_fiemap() when
getting fiemap with FIEMAP_FLAG_SYNC flags. This patch ensures that the
inode folio is written back and the writeback process completes before
proceeding.

Cc: stable@kernel.org
Fixes: 9ffe0fb5f3bb ("f2fs: handle inline data operations")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h   |    2 ++
 fs/f2fs/inline.c |    9 +++++++++
 fs/f2fs/node.c   |    2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3950,6 +3950,8 @@ int f2fs_sanity_check_node_footer(struct
 					enum node_type ntype, bool in_irq);
 struct folio *f2fs_get_inode_folio(struct f2fs_sb_info *sbi, pgoff_t ino);
 struct folio *f2fs_get_xnode_folio(struct f2fs_sb_info *sbi, pgoff_t xnid);
+int f2fs_write_single_node_folio(struct folio *node_folio, int sync_mode,
+			bool mark_dirty, enum iostat_type io_type);
 int f2fs_move_node_folio(struct folio *node_folio, int gc_type);
 void f2fs_flush_inline_data(struct f2fs_sb_info *sbi);
 int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -814,6 +814,15 @@ int f2fs_inline_data_fiemap(struct inode
 		goto out;
 	}
 
+	if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC) {
+		err = f2fs_write_single_node_folio(ifolio, true, false, FS_NODE_IO);
+		if (err)
+			return err;
+		ifolio = f2fs_get_inode_folio(F2FS_I_SB(inode), inode->i_ino);
+		if (IS_ERR(ifolio))
+			return PTR_ERR(ifolio);
+		f2fs_folio_wait_writeback(ifolio, NODE, true, true);
+	}
 	ilen = min_t(size_t, MAX_INLINE_DATA(inode), i_size_read(inode));
 	if (start >= ilen)
 		goto out;
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1842,7 +1842,7 @@ redirty_out:
 	return false;
 }
 
-static int f2fs_write_single_node_folio(struct folio *node_folio, int sync_mode,
+int f2fs_write_single_node_folio(struct folio *node_folio, int sync_mode,
 			bool mark_dirty, enum iostat_type io_type)
 {
 	int err = 0;


