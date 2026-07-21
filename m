Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7142347142D;
	Tue, 21 Jul 2026 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664699; cv=none; b=GT7/30a+uhG5eVHzRyleX0aT9BLGZcovKQZYVOwODrAZFrxVUujiqBqs9/hXaq/xIa7gQDi9AU2BKUlZFo1A6x+RhPGapB9rYQzabjw19sb6miMLcnLE+4Bgw7+u7PA0GghohklkEVBFGjUENnJucDo3ay3l4spzNuTUS+XGp84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664699; c=relaxed/simple;
	bh=ACHB2GIcAYvWSR3zg6lzVPryfyqMdamRbGxYpN8IIw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHI9xK/k9vmUFqokX+RHQfSrsVo5oOCriwiweZKG94lDrpJV48ln0CitqTT9sNT24RE051aGzBaVZZB4Da52F3WOTlmJDAyg/ZIBcizCbvV5O1nxMIrOfC3F1Pq5pOASKhAZc3FTbCNUQ+SXbAs+nH7QEnn9VhhVKvjRxQqVglo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J10c09gO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J10c09gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873251F00A3A;
	Tue, 21 Jul 2026 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664696;
	bh=X4KWuoPVJ4kkb9VCSAj3Uziax6/zM8VTXxh+Nf1GXMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J10c09gOLacASgpmICaWUTqYKsFV7BzB8U+SZGl7fjq9zr7OvNLVHzxABo8jGUe6B
	 K8+P9jRnqSVV8tCdGjug4JRSPn8XqAow1hgaKkzuslgD6GbysWphiiEylBiwjikbNW
	 bFOjfYB5aAXuzCW2dSPMl+FPgyEOOm2p/wOaNFW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0024/1266] f2fs: validate orphan inode entry count
Date: Tue, 21 Jul 2026 17:07:41 +0200
Message-ID: <20260721152442.332734743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 846c499a65816d13f1186e3090e825e8bb8bcb8b ]

f2fs_recover_orphan_inodes() trusts the orphan block entry_count when
replaying orphan inodes from the checkpoint pack. A corrupted entry_count
larger than F2FS_ORPHANS_PER_BLOCK makes the recovery loop read past the
ino[] array and interpret footer or following data as inode numbers.

On a crafted image, mounting an unpatched kernel can drive orphan recovery
into f2fs_bug_on() and panic the kernel. Validate entry_count before
consuming entries so corrupted checkpoint data fails the mount with
-EFSCORRUPTED and requests fsck instead.

Set ERROR_INCONSISTENT_ORPHAN as well, so the corruption reason can be
recorded in the superblock s_errors[] field. This gives fsck a persistent
hint even though mount-time orphan recovery failure may leave no chance to
persist SBI_NEED_FSCK through a checkpoint.

Cc: stable@kernel.org
Fixes: 127e670abfa7 ("f2fs: add checkpoint operations")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c    |   14 +++++++++++++-
 include/linux/f2fs_fs.h |    1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -742,6 +742,7 @@ int f2fs_recover_orphan_inodes(struct f2
 	for (i = 0; i < orphan_blocks; i++) {
 		struct page *page;
 		struct f2fs_orphan_block *orphan_blk;
+		unsigned int entry_count;
 
 		page = f2fs_get_meta_page(sbi, start_blk + i);
 		if (IS_ERR(page)) {
@@ -750,7 +751,18 @@ int f2fs_recover_orphan_inodes(struct f2
 		}
 
 		orphan_blk = (struct f2fs_orphan_block *)page_address(page);
-		for (j = 0; j < le32_to_cpu(orphan_blk->entry_count); j++) {
+		entry_count = le32_to_cpu(orphan_blk->entry_count);
+		if (entry_count > F2FS_ORPHANS_PER_BLOCK) {
+			f2fs_err(sbi, "invalid orphan inode entry count %u",
+				 entry_count);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			f2fs_handle_error(sbi, ERROR_INCONSISTENT_ORPHAN);
+			err = -EFSCORRUPTED;
+			f2fs_put_page(page, 1);
+			goto out;
+		}
+
+		for (j = 0; j < entry_count; j++) {
 			nid_t ino = le32_to_cpu(orphan_blk->ino[j]);
 
 			err = recover_orphan_inode(sbi, ino);
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -102,6 +102,7 @@ enum f2fs_error {
 	ERROR_CORRUPTED_XATTR,
 	ERROR_INVALID_NODE_REFERENCE,
 	ERROR_INCONSISTENT_NAT,
+	ERROR_INCONSISTENT_ORPHAN,
 	ERROR_MAX,
 };
 


