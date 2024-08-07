Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053033EA9A;
	Wed,  7 Aug 2024 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042949; cv=none; b=qOf2wGKl2CPSp1bGdtDrhu4fEi7zxKV2qb7T3XXTKRk/U+J7+ioK53YB403KxP/NgXkvur/eTuZZ/eKxpJbR+iM6s1jI9hVWo4KSuv84CMKkmc8vkhrvQGIElfSnbRZ/F3PgqovNdTCxVz2RbenSOtvS4qyb86ZEY8+MFn6rfpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042949; c=relaxed/simple;
	bh=n6tBxFLP5SecrlqELC+8vbT5brvn7NND0WGbWV3DNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QySQVUUYAUw0WZRO8QctZ7FQTUt9tiV5J5ARtwekPD8wZqSQUtfVbbJOq1J3LWx3vMUXE+joVPXFUgAJsuAnTGT5yo1LhrnkxtHwjZjgD4Lz8lSZFuIdoyBLTUT6V9tSYmzFP9xJAf3feJ33Ru9jWjy+/yisWiA1DVswTivK2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy17Bpze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy17Bpze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373A7C32781;
	Wed,  7 Aug 2024 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042948;
	bh=n6tBxFLP5SecrlqELC+8vbT5brvn7NND0WGbWV3DNWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fy17BpzeCvqBEUtukMsStAtTTNM6LRiJradNNiQwc6CVpTPWW7Q2AE9gy2Nk00cuL
	 xnXWAKX4mw49/QRPwri6H6O3G/fogSptZ2+y0o9BQJAu0sa3bDo+Omidf1vtw9rO50
	 HJaG5JRmGNlO7oRMJkb9QqIya1SekoUFP8q0rMeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 006/123] ext4: factor out a common helper to query extent map
Date: Wed,  7 Aug 2024 16:58:45 +0200
Message-ID: <20240807150021.016620120@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4bae9ccf5fe01..168819b4db019 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -453,6 +453,35 @@ static void ext4_map_blocks_es_recheck(handle_t *handle,
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
@@ -1744,33 +1773,11 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
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



