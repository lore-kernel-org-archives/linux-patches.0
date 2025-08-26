Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402DF2E6106;
	Tue, 26 Aug 2025 13:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213794; cv=none; b=DWIlW5yJ+kM07Ik4OM5z9yNV7b0TtsHKHxstXcpvEtL4tpSWLuexw3jqbHblykPCC6f/rd7Eny/OPJ42JP9OttLCC+QQiAMWEPklvbvQko86Du8/jVQRKGeCFiX6wScPKAJ4q1rvBzo4xFCRDAeqgSDb/i1mWNys/aO2li0IORk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213794; c=relaxed/simple;
	bh=rIZ903vtMGOnxp16r25j08+7fsM5ztH8SMfbLPgWINQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6QVJ5wwtb9VdvV90rP245dK7MW5dDd9Hm5KEUyyg6WnMJ34GZBeP9/1OXgH7v3NjwY09DAo0F7j2ZFbJ+rSqSg1harzvg8mLUx2RBGxfbzWvSchBcJUcRq456St0zhSS8YYyLocgOKuPUJy3htNBJ9bxZTt0rmPNhzn6eeFz4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rn7XR8MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rn7XR8MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65560C4CEF1;
	Tue, 26 Aug 2025 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213793;
	bh=rIZ903vtMGOnxp16r25j08+7fsM5ztH8SMfbLPgWINQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn7XR8MQiwkCUMJTV17hWlpNxTqMbabyf5EdmFNnQSuMJvweqvTYqKC05THspLcTo
	 2CwLhk/9gfG4xfmLQuJnEL0UFC9ebJCULx11duyej0kjrq/nxgoVWwgxDV9sfOTKHC
	 6Y5EqLj4EUmO7ZLnkcVBD3porf7uI8R6Bddj7Z6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 450/587] btrfs: open code timespec64 in struct btrfs_inode
Date: Tue, 26 Aug 2025 13:09:59 +0200
Message-ID: <20250826111004.405945365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit c6e8f898f56fae2cb5bc4396bec480f23cd8b066 ]

The type of timespec64::tv_nsec is 'unsigned long', while we have only
u32 for on-disk and in-memory. This wastes a few bytes in btrfs_inode.
Add separate members for sec and nsec with the corresponding type width.
This creates a 4 byte hole in btrfs_inode which can be utilized in the
future.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1ef94169db09 ("btrfs: populate otime when logging an inode item")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h   |    3 ++-
 fs/btrfs/delayed-inode.c |   12 ++++--------
 fs/btrfs/inode.c         |   26 ++++++++++++--------------
 3 files changed, 18 insertions(+), 23 deletions(-)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -251,7 +251,8 @@ struct btrfs_inode {
 	struct btrfs_delayed_node *delayed_node;
 
 	/* File creation time. */
-	struct timespec64 i_otime;
+	u64 i_otime_sec;
+	u32 i_otime_nsec;
 
 	/* Hook into fs_info->delayed_iputs */
 	struct list_head delayed_iput;
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1849,10 +1849,8 @@ static void fill_stack_inode_item(struct
 	btrfs_set_stack_timespec_nsec(&inode_item->ctime,
 				      inode_get_ctime(inode).tv_nsec);
 
-	btrfs_set_stack_timespec_sec(&inode_item->otime,
-				     BTRFS_I(inode)->i_otime.tv_sec);
-	btrfs_set_stack_timespec_nsec(&inode_item->otime,
-				     BTRFS_I(inode)->i_otime.tv_nsec);
+	btrfs_set_stack_timespec_sec(&inode_item->otime, BTRFS_I(inode)->i_otime_sec);
+	btrfs_set_stack_timespec_nsec(&inode_item->otime, BTRFS_I(inode)->i_otime_nsec);
 }
 
 int btrfs_fill_inode(struct inode *inode, u32 *rdev)
@@ -1901,10 +1899,8 @@ int btrfs_fill_inode(struct inode *inode
 	inode_set_ctime(inode, btrfs_stack_timespec_sec(&inode_item->ctime),
 			btrfs_stack_timespec_nsec(&inode_item->ctime));
 
-	BTRFS_I(inode)->i_otime.tv_sec =
-		btrfs_stack_timespec_sec(&inode_item->otime);
-	BTRFS_I(inode)->i_otime.tv_nsec =
-		btrfs_stack_timespec_nsec(&inode_item->otime);
+	BTRFS_I(inode)->i_otime_sec = btrfs_stack_timespec_sec(&inode_item->otime);
+	BTRFS_I(inode)->i_otime_nsec = btrfs_stack_timespec_nsec(&inode_item->otime);
 
 	inode->i_generation = BTRFS_I(inode)->generation;
 	BTRFS_I(inode)->index_cnt = (u64)-1;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3785,10 +3785,8 @@ static int btrfs_read_locked_inode(struc
 	inode_set_ctime(inode, btrfs_timespec_sec(leaf, &inode_item->ctime),
 			btrfs_timespec_nsec(leaf, &inode_item->ctime));
 
-	BTRFS_I(inode)->i_otime.tv_sec =
-		btrfs_timespec_sec(leaf, &inode_item->otime);
-	BTRFS_I(inode)->i_otime.tv_nsec =
-		btrfs_timespec_nsec(leaf, &inode_item->otime);
+	BTRFS_I(inode)->i_otime_sec = btrfs_timespec_sec(leaf, &inode_item->otime);
+	BTRFS_I(inode)->i_otime_nsec = btrfs_timespec_nsec(leaf, &inode_item->otime);
 
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
@@ -3958,10 +3956,8 @@ static void fill_inode_item(struct btrfs
 	btrfs_set_token_timespec_nsec(&token, &item->ctime,
 				      inode_get_ctime(inode).tv_nsec);
 
-	btrfs_set_token_timespec_sec(&token, &item->otime,
-				     BTRFS_I(inode)->i_otime.tv_sec);
-	btrfs_set_token_timespec_nsec(&token, &item->otime,
-				      BTRFS_I(inode)->i_otime.tv_nsec);
+	btrfs_set_token_timespec_sec(&token, &item->otime, BTRFS_I(inode)->i_otime_sec);
+	btrfs_set_token_timespec_nsec(&token, &item->otime, BTRFS_I(inode)->i_otime_nsec);
 
 	btrfs_set_token_inode_nbytes(&token, item, inode_get_bytes(inode));
 	btrfs_set_token_inode_generation(&token, item,
@@ -5644,7 +5640,8 @@ static struct inode *new_simple_dir(stru
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
 	inode->i_mtime = inode_set_ctime_current(inode);
 	inode->i_atime = dir->i_atime;
-	BTRFS_I(inode)->i_otime = inode->i_mtime;
+	BTRFS_I(inode)->i_otime_sec = inode->i_mtime.tv_sec;
+	BTRFS_I(inode)->i_otime_nsec = inode->i_mtime.tv_nsec;
 	inode->i_uid = dir->i_uid;
 	inode->i_gid = dir->i_gid;
 
@@ -6321,7 +6318,8 @@ int btrfs_create_new_inode(struct btrfs_
 
 	inode->i_mtime = inode_set_ctime_current(inode);
 	inode->i_atime = inode->i_mtime;
-	BTRFS_I(inode)->i_otime = inode->i_mtime;
+	BTRFS_I(inode)->i_otime_sec = inode->i_mtime.tv_sec;
+	BTRFS_I(inode)->i_otime_nsec = inode->i_mtime.tv_nsec;
 
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
@@ -8550,8 +8548,8 @@ struct inode *btrfs_alloc_inode(struct s
 
 	ei->delayed_node = NULL;
 
-	ei->i_otime.tv_sec = 0;
-	ei->i_otime.tv_nsec = 0;
+	ei->i_otime_sec = 0;
+	ei->i_otime_nsec = 0;
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
@@ -8703,8 +8701,8 @@ static int btrfs_getattr(struct mnt_idma
 	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
-	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
-	stat->btime.tv_nsec = BTRFS_I(inode)->i_otime.tv_nsec;
+	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
+	stat->btime.tv_nsec = BTRFS_I(inode)->i_otime_nsec;
 	if (bi_flags & BTRFS_INODE_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (bi_flags & BTRFS_INODE_COMPRESS)


