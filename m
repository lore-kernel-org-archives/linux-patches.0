Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1090215C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A23C433C1;
	Mon,  5 Dec 2022 19:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268797;
	bh=S4e/o02xo/o+tyIxCCxuRBkfk29bYSSvi/ifrmR2YC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ymae3ngeccXa4ShuUTpDd2t0uAN8LLFTtA0Mhy8LKmxQst0nsMJoe3lL+4Puh8xAn
	 nzqZtqwZMr2tKxn39IT24WVPmeAUiq4VKbPLQv7euvK06mkJwiE/5Ex477KYJ0c8Xc
	 F2MpOS+nW064dXvEIJJwq+a83y62/557wMmmkEsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/120] btrfs: sink iterator parameter to btrfs_ioctl_logical_to_ino
Date: Mon,  5 Dec 2022 20:09:05 +0100
Message-Id: <20221205190806.709848529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Sterba <dsterba@suse.com>

[ Upstream commit e3059ec06b9f1a96826cc2bb6ed131aac0942446 ]

There's only one function we pass to iterate_inodes_from_logical as
iterator, so we can drop the indirection and call it directly, after
moving the function to backref.c

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 418ffb9e3cf6 ("btrfs: free btrfs_path before copying inodes to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 25 ++++++++++++++++++++++---
 fs/btrfs/backref.h |  3 +--
 fs/btrfs/ioctl.c   | 22 +---------------------
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 60bec5a108fa..1ff527bbe54c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2060,10 +2060,29 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	struct btrfs_data_container *inodes = ctx;
+	const size_t c = 3 * sizeof(u64);
+
+	if (inodes->bytes_left >= c) {
+		inodes->bytes_left -= c;
+		inodes->val[inodes->elem_cnt] = inum;
+		inodes->val[inodes->elem_cnt + 1] = offset;
+		inodes->val[inodes->elem_cnt + 2] = root;
+		inodes->elem_cnt += 3;
+	} else {
+		inodes->bytes_missing += c - inodes->bytes_left;
+		inodes->bytes_left = 0;
+		inodes->elem_missed += 3;
+	}
+
+	return 0;
+}
+
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
-				bool ignore_offset)
+				void *ctx, bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -2081,7 +2100,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx, ignore_offset);
+					build_ino_list, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index ba454032dbe2..2759de7d324c 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -35,8 +35,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				bool ignore_offset);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
+				struct btrfs_path *path, void *ctx,
 				bool ignore_offset);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d9ff0697132b..143c2462924b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3911,26 +3911,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
-static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
-{
-	struct btrfs_data_container *inodes = ctx;
-	const size_t c = 3 * sizeof(u64);
-
-	if (inodes->bytes_left >= c) {
-		inodes->bytes_left -= c;
-		inodes->val[inodes->elem_cnt] = inum;
-		inodes->val[inodes->elem_cnt + 1] = offset;
-		inodes->val[inodes->elem_cnt + 2] = root;
-		inodes->elem_cnt += 3;
-	} else {
-		inodes->bytes_missing += c - inodes->bytes_left;
-		inodes->bytes_left = 0;
-		inodes->elem_missed += 3;
-	}
-
-	return 0;
-}
-
 static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 					void __user *arg, int version)
 {
@@ -3980,7 +3960,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes, ignore_offset);
+					  inodes, ignore_offset);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
-- 
2.35.1



