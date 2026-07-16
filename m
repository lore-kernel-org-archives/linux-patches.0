Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6142376D;
	Thu, 16 Jul 2026 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211610; cv=none; b=mRxtzYHp84wucnCHv3q9SzFICR18hAVOZypPJWAtCoXEu0MZSumjT4aOCUceGvK0viyY5r7KIrOmSj4vPZr21mOob0BoaEYgjxOuGK8QNyhoNezwz3sxu5hLZ8OKPZkzjkKsUSaxfQ9RJAkA7znGtZMzri2qLIm7CGmKQ+A/TH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211610; c=relaxed/simple;
	bh=bq8LsxNrKWa89PkYwSPeEqvOj07z3dYe6YvPz0sT9wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRuFEZKgJwZ2fMUG4z0o5hY2gGgBkWgb3k5PnEiXXOJWDoEmgxmfXrVM75jBtymayErgBgpVPwZhgsxBQLPK1EYEKLvJM1rWt1CzVLIRfgeH7hH0lsZZHp2GO6gal8+ShN2yrufR4S2f4LseUWyzDkcxkkXsKQBU66MNYNivEBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxNCkLbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxNCkLbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996C11F000E9;
	Thu, 16 Jul 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211609;
	bh=MTelo8lxFi2yGyejmkacafL8BeQZiADMm3cahXa8mnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxNCkLbiBlJDQG8xhVUI9r2fiaE60FjRNdWpVcQM3OKbJIvLnqVsvVrIDgKM0HsIl
	 doFvMcMaX2INwtq7azkHSKAAVqCOOAmL8/Ss2XbuZe/UCa1RkQhKLGjwgUxKMQm9+h
	 mo7AQYE3nBYLe30ricWnZcv7jnREZnUWesFAE4WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/349] f2fs: validate orphan inode entry count
Date: Thu, 16 Jul 2026 15:29:07 +0200
Message-ID: <20260716133033.589632108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -759,6 +759,7 @@ int f2fs_recover_orphan_inodes(struct f2
 	for (i = 0; i < orphan_blocks; i++) {
 		struct page *page;
 		struct f2fs_orphan_block *orphan_blk;
+		unsigned int entry_count;
 
 		page = f2fs_get_meta_page(sbi, start_blk + i);
 		if (IS_ERR(page)) {
@@ -767,7 +768,18 @@ int f2fs_recover_orphan_inodes(struct f2
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
@@ -104,6 +104,7 @@ enum f2fs_error {
 	ERROR_CORRUPTED_XATTR,
 	ERROR_INVALID_NODE_REFERENCE,
 	ERROR_INCONSISTENT_NAT,
+	ERROR_INCONSISTENT_ORPHAN,
 	ERROR_MAX,
 };
 


