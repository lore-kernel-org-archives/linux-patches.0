Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC08E2E5B09;
	Tue, 15 Jul 2025 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585951; cv=none; b=QJV3u4Xs8Ufd7ah71MIqQCJverCjaFcakfAg7qFzBYBhLUUcundUfBzMWpEdJnrZDJLDQxPIg5izbAKaaLlXHyDuQ1EhrKgLulijVS714MZJSh5sOAcEmexn95bSS3fyKWuCaNkA7BZbzB/cuqFEDkJFHU4wQxH9a0vEcMp0cWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585951; c=relaxed/simple;
	bh=FSCHEJPK3JOzbXOf8BeYCSzaj3aUlZW6lwJfzSpNcJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXSnLWJDlAMROutGFeNy6G/7mnV/8+ErJp2VFqfQmANYA1aDO/mx79N4TVyU4kjzEz6bczg7MdCZRJngGUhkw6Iv262qhdzl/g2azzP54FlOlvw3RQjXvaMo5uZ8Xa381eE7ShDcdN0jkZ0R/5htvq4+sqyS+N2SWR+BhQNPvH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSPpdACM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSPpdACM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558C0C4CEE3;
	Tue, 15 Jul 2025 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585951;
	bh=FSCHEJPK3JOzbXOf8BeYCSzaj3aUlZW6lwJfzSpNcJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSPpdACMBKZEbVRtSr90JzxDtHogkKUlFclQk6YDDpSuqMw5zHsGCnZMGQ5suxUXv
	 6PAf4A7FD+VAXtKAFe3WxDfpx2pu3C8rIXdrqK28gg84Bhk/yjgGM5HXxZurt3O+9w
	 t9lLC0EP+lk8U3pOgiu5lua78Xlu19KhPFy5ORUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/109] btrfs: remove redundant root argument from fixup_inode_link_count()
Date: Tue, 15 Jul 2025 15:13:24 +0200
Message-ID: <20250715130801.605722307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

[ Upstream commit 8befc61cbba2d4567122d400542da8900a352971 ]

The root argument for fixup_inode_link_count() always matches the root of
the given inode, so remove the root argument and get it from the inode
argument. This also applies to the helpers count_inode_extrefs() and
count_inode_refs() used by fixup_inode_link_count() - they don't need the
root argument, as it always matches the root of the inode passed to them.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 5f61b961599a ("btrfs: fix inode lookup error handling during log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 13377c3b22897..a17942f4c155b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1504,8 +1504,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int count_inode_extrefs(struct btrfs_root *root,
-		struct btrfs_inode *inode, struct btrfs_path *path)
+static int count_inode_extrefs(struct btrfs_inode *inode, struct btrfs_path *path)
 {
 	int ret = 0;
 	int name_len;
@@ -1519,8 +1518,8 @@ static int count_inode_extrefs(struct btrfs_root *root,
 	struct extent_buffer *leaf;
 
 	while (1) {
-		ret = btrfs_find_one_extref(root, inode_objectid, offset, path,
-					    &extref, &offset);
+		ret = btrfs_find_one_extref(inode->root, inode_objectid, offset,
+					    path, &extref, &offset);
 		if (ret)
 			break;
 
@@ -1548,8 +1547,7 @@ static int count_inode_extrefs(struct btrfs_root *root,
 	return nlink;
 }
 
-static int count_inode_refs(struct btrfs_root *root,
-			struct btrfs_inode *inode, struct btrfs_path *path)
+static int count_inode_refs(struct btrfs_inode *inode, struct btrfs_path *path)
 {
 	int ret;
 	struct btrfs_key key;
@@ -1564,7 +1562,7 @@ static int count_inode_refs(struct btrfs_root *root,
 	key.offset = (u64)-1;
 
 	while (1) {
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, inode->root, &key, path, 0, 0);
 		if (ret < 0)
 			break;
 		if (ret > 0) {
@@ -1616,9 +1614,9 @@ static int count_inode_refs(struct btrfs_root *root,
  * will free the inode.
  */
 static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
-					   struct btrfs_root *root,
 					   struct inode *inode)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_path *path;
 	int ret;
 	u64 nlink = 0;
@@ -1628,13 +1626,13 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = count_inode_refs(root, BTRFS_I(inode), path);
+	ret = count_inode_refs(BTRFS_I(inode), path);
 	if (ret < 0)
 		goto out;
 
 	nlink = ret;
 
-	ret = count_inode_extrefs(root, BTRFS_I(inode), path);
+	ret = count_inode_extrefs(BTRFS_I(inode), path);
 	if (ret < 0)
 		goto out;
 
@@ -1706,7 +1704,7 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 			break;
 		}
 
-		ret = fixup_inode_link_count(trans, root, inode);
+		ret = fixup_inode_link_count(trans, inode);
 		iput(inode);
 		if (ret)
 			break;
-- 
2.39.5



