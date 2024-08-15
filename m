Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F131714A1;
	Thu, 15 Aug 2024 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730114; cv=none; b=GpI2qrMug1TagHO9kK6uAUHcshp1YBWYgHW6My6RCiODgAvCawO+CqO7eSpUR5l/o4SwMJSjxCxmzTF95TP0C+f+vDewLQ/3aCblfJJ6SZs5DobUvRS5XILMTXM8InEQcyIn9MwEVjrT/yCfdR+ZNZgHkVD5r5Lh8oEnyC3w17Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730114; c=relaxed/simple;
	bh=OUfOVHHWmlzhWeU8JtUZBg6ByKTBPwMNh6VRImrqfdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAe+S1ta4r25fSjmIOfCr5Pw45FLp5/j0rx7U10GzC2ezmP3kRLE9dZmdHmoUbAI0B0G5v3Vw9sDsc4s6LLX7ApoAYAINCWUdVzabFha3AoMW0k1vUgS9OJUdLmSB3j9Go4+Wi2esp76E8SHKNlX2yxN6ZS4a78uT7H3oFFCizE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyJZtda9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyJZtda9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C5C32786;
	Thu, 15 Aug 2024 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730114;
	bh=OUfOVHHWmlzhWeU8JtUZBg6ByKTBPwMNh6VRImrqfdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyJZtda9lHPXOUCZt0WFQwdy+JC3BkRIMovLy3cuGG9jR7lN4B87UpF42qUryU8Xt
	 lxD68TQOK9iFYVnfuHIanSP0VWN+8xG4ai07r0vYR4VfkqAhtlVf/2rsooyX7fRm+6
	 q6SAHA4izVemBkSWPNpjrPjvkdxbsWJuXxniElwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/484] ext4: factor out a common helper to query extent map
Date: Thu, 15 Aug 2024 15:22:46 +0200
Message-ID: <20240815131953.306253666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 8e4e5cdf2fdeb99445a468b6b6436ad79b9ecb30 ]

Factor out a new common helper ext4_map_query_blocks() from the
ext4_da_map_blocks(), it query and return the extent map status on the
inode's extent path, no logic changes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20240517124005.347221-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0ea6560abb3b ("ext4: check the extent status again before inserting delalloc block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 57 +++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 329e3dc9cb32c..403f88662bc30 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -484,6 +484,35 @@ static void ext4_map_blocks_es_recheck(handle_t *handle,
 }
 #endif /* ES_AGGRESSIVE_TEST */
 
+static int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
+				 struct ext4_map_blocks *map)
+{
+	unsigned int status;
+	int retval;
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		retval = ext4_ext_map_blocks(handle, inode, map, 0);
+	else
+		retval = ext4_ind_map_blocks(handle, inode, map, 0);
+
+	if (retval <= 0)
+		return retval;
+
+	if (unlikely(retval != map->m_len)) {
+		ext4_warning(inode->i_sb,
+			     "ES len assertion failed for inode "
+			     "%lu: retval %d != map->m_len %d",
+			     inode->i_ino, retval, map->m_len);
+		WARN_ON(1);
+	}
+
+	status = map->m_flags & EXT4_MAP_UNWRITTEN ?
+			EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
+	ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+			      map->m_pblk, status);
+	return retval;
+}
+
 /*
  * The ext4_map_blocks() function tries to look up the requested blocks,
  * and returns if the blocks are already mapped.
@@ -1751,33 +1780,11 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 	down_read(&EXT4_I(inode)->i_data_sem);
 	if (ext4_has_inline_data(inode))
 		retval = 0;
-	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		retval = ext4_ext_map_blocks(NULL, inode, map, 0);
 	else
-		retval = ext4_ind_map_blocks(NULL, inode, map, 0);
-	if (retval < 0) {
-		up_read(&EXT4_I(inode)->i_data_sem);
-		return retval;
-	}
-	if (retval > 0) {
-		unsigned int status;
-
-		if (unlikely(retval != map->m_len)) {
-			ext4_warning(inode->i_sb,
-				     "ES len assertion failed for inode "
-				     "%lu: retval %d != map->m_len %d",
-				     inode->i_ino, retval, map->m_len);
-			WARN_ON(1);
-		}
-
-		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
-				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
-		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
-				      map->m_pblk, status);
-		up_read(&EXT4_I(inode)->i_data_sem);
-		return retval;
-	}
+		retval = ext4_map_query_blocks(NULL, inode, map);
 	up_read(&EXT4_I(inode)->i_data_sem);
+	if (retval)
+		return retval;
 
 add_delayed:
 	down_write(&EXT4_I(inode)->i_data_sem);
-- 
2.43.0



