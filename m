Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8E218F2FC;
	Tue, 26 Aug 2025 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213713; cv=none; b=myab8YdwBveC296E8HrLh4+3vq8WZEM42cVIrMeW6fe5mYXJn7mOTWzmDr6UsWRxtup37dlHzEH/xLU8dq5r8po+kJ3Dz7HtehSgR/Z8oqXskyoO/OQM6PbjFfCp9jy64uiwShccMtH2XdSs5TMOpG5y+c6wS9d+QsLSodEq0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213713; c=relaxed/simple;
	bh=jfPdBYrQkkZ5/a/O3BkbtwZczuPeTiyUxG+BwtH6CEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7beguCOIKaTU5VDhRn6ZbLZhks7RphDN3yFkRZj0e+pyNzU6wOFyBYphVRtrMi/VeJga3IqKihseO+Bdh1omQln9XT3AiHtMVEbF+pCb9so38Rc4sNhJ8/tWNuOm/FqnigIrpbQkd/OY+VUeuqLRlj6+T++svrSGqL2pzi4dao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X17dfBQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X17dfBQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1B8C4CEF1;
	Tue, 26 Aug 2025 13:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213712;
	bh=jfPdBYrQkkZ5/a/O3BkbtwZczuPeTiyUxG+BwtH6CEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X17dfBQ2Lh9gHq1aMSW6VVnDo7WMCFrO9Ccs1FZKAh1RilU+wq+88TccTllrmZHhJ
	 fH8VJXrSE70ywJR+xNOcrCFQTDj20UXI1jHQqGEAKcPc6US5pTSoDEAWBRoH6e5f18
	 uhNwv2o2ndlCeE4JnG3UCGXhS7wxZ8dGKeLsgqd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 444/587] btrfs: dont ignore inode missing when replaying log tree
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826111004.250775573@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7ebf381a69421a88265d3c49cd0f007ba7336c9d ]

During log replay, at add_inode_ref(), we return -ENOENT if our current
inode isn't found on the subvolume tree or if a parent directory isn't
found. The error comes from btrfs_iget_logging() <- btrfs_iget() <-
btrfs_read_locked_inode().

The single caller of add_inode_ref(), replay_one_buffer(), ignores an
-ENOENT error because it expects that error to mean only that a parent
directory wasn't found and that is ok.

Before commit 5f61b961599a ("btrfs: fix inode lookup error handling during
log replay") we were converting any error when getting a parent directory
to -ENOENT and any error when getting the current inode to -EIO, so our
caller would fail log replay in case we can't find the current inode.
After that commit however in case the current inode is not found we return
-ENOENT to the caller and therefore it ignores the critical fact that the
current inode was not found in the subvolume tree.

Fix this by converting -ENOENT to 0 when we don't find a parent directory,
returning -ENOENT when we don't find the current inode and making the
caller, replay_one_buffer(), not ignore -ENOENT anymore.

Fixes: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
CC: stable@vger.kernel.org # 6.16
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ adapted btrfs_inode pointer usage to older inode API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1422,6 +1422,8 @@ static noinline int add_inode_ref(struct
 		btrfs_dir = btrfs_iget_logging(parent_objectid, root);
 		if (IS_ERR(btrfs_dir)) {
 			ret = PTR_ERR(btrfs_dir);
+			if (ret == -ENOENT)
+				ret = 0;
 			dir = NULL;
 			goto out;
 		}
@@ -1455,6 +1457,15 @@ static noinline int add_inode_ref(struct
 				if (IS_ERR(btrfs_dir)) {
 					ret = PTR_ERR(btrfs_dir);
 					dir = NULL;
+					/*
+					 * A new parent dir may have not been
+					 * logged and not exist in the subvolume
+					 * tree, see the comment above before
+					 * the loop when getting the first
+					 * parent dir.
+					 */
+					if (ret == -ENOENT)
+						ret = 0;
 					goto out;
 				}
 				dir = &btrfs_dir->vfs_inode;
@@ -2623,9 +2634,8 @@ static int replay_one_buffer(struct btrf
 			   key.type == BTRFS_INODE_EXTREF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
-			if (ret && ret != -ENOENT)
+			if (ret)
 				break;
-			ret = 0;
 		} else if (key.type == BTRFS_EXTENT_DATA_KEY) {
 			ret = replay_one_extent(wc->trans, root, path,
 						eb, i, &key);


