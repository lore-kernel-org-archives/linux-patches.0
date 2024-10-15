Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C17146588;
	Tue, 15 Oct 2024 11:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992751; cv=none; b=haPMGjqt7Ow2dRg8hsg/+WpashD+xL3ddjQ8xSbbkyySz9KeQnICozxgP7vpa7gKUr6w3tPi9r65j7bohvx9PO10uQCRGBbM/MFhzKbphcKceCm3BiDRTEgdgqGw/MtSsnivPyVjyrR8Bo/CV2X3V9SRA4VVJ2kIoGcIAQsgjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992751; c=relaxed/simple;
	bh=PHvSisS6qZ31FZ1c7NzJb0kCKqPA7oU4riVnl5jegiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX2CPFA+WMSYfM9c7LYb6FwHkEbMy8gZXox17u+RrkHFdSvWcZMjGnjWfYGzCcuor2uC+Xl9L4ly0CdHi1ltHkryWsn0VEGkMRQXOdxiDsn0B8wKJ9iSkxKX+bO4W1C3h5wr+Qq0wtxEwiqi411RgEetCXvuo0cpSulUXpddujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uptED1bC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uptED1bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0A9C4CEC6;
	Tue, 15 Oct 2024 11:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992750;
	bh=PHvSisS6qZ31FZ1c7NzJb0kCKqPA7oU4riVnl5jegiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uptED1bCFszJSh70c67b3O0QuTn8PApOcsnNp+FF+Rg3yMMlUqpN9Sp8tVOdTSpks
	 RclO2j4ySakEcsooK/r/vjKO9JY91tAtMnkJIWZG6CXoEQbsG1LaP9hW1eOEfyhcxU
	 hp6XDcPlDDbfWtgmFDgSb4zksZ0oD/b3eOOu1F3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/691] ext4: avoid potential buffer_head leak in __ext4_new_inode()
Date: Tue, 15 Oct 2024 13:22:34 +0200
Message-ID: <20241015112448.537110373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 227d31b9214d1b9513383cf6c7180628d4b3b61f ]

If a group is marked EXT4_GROUP_INFO_IBITMAP_CORRUPT after it's inode
bitmap buffer_head was successfully verified, then __ext4_new_inode()
will get a valid inode_bitmap_bh of a corrupted group from
ext4_read_inode_bitmap() in which case inode_bitmap_bh misses a release.
Hnadle "IS_ERR(inode_bitmap_bh)" and group corruption separately like
how ext4_free_inode() does to avoid buffer_head leak.

Fixes: 9008a58e5dce ("ext4: make the bitmap read routines return real error codes")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4478ba2e8cc54..a00c91aa755c4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1056,12 +1056,13 @@ struct inode *__ext4_new_inode(struct user_namespace *mnt_userns,
 		brelse(inode_bitmap_bh);
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		/* Skip groups with suspicious inode tables */
-		if (((!(sbi->s_mount_state & EXT4_FC_REPLAY))
-		     && EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) ||
-		    IS_ERR(inode_bitmap_bh)) {
+		if (IS_ERR(inode_bitmap_bh)) {
 			inode_bitmap_bh = NULL;
 			goto next_group;
 		}
+		if (!(sbi->s_mount_state & EXT4_FC_REPLAY) &&
+		    EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+			goto next_group;
 
 repeat_in_this_group:
 		ret2 = find_inode_bit(sb, group, inode_bitmap_bh, &ino);
-- 
2.43.0



