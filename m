Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E5DDC5;
	Thu, 28 May 2026 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000094; cv=none; b=K4fP0We4rkV1Vtbih+7Qaw8GUOcsyzxbMKQ3znOkC3AwrPNNYglhhEDSy3PuO+KMQjsSAd6v/LFUAiMB53AT66/J6FQe80P7UBfnqr+XJdzkCPhgKMqu2qhVKeEEP0Yix7YkMMv8XGF6KoeMNpJ1IguSJnx7och91Z97Mqs0bbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000094; c=relaxed/simple;
	bh=cZPK6WZ+kRlT28tmJVzVzAtwUYL51x0b5SkFUIiX7kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXkW8Wtqx7TcnU3wtwB59WnuCzVHCrUM/8CMvBWkIy2Eh3x5MotvU2wDLPBHyheyq9SQLetIMHeYAlvTyvhj8TUHXiY4RHvm4iJiBITknGhh04yMNUcRgCZGrQiz2MUG6bH0h4uNGJ2jZhw89iPRb21SSU2qZSOYbirigOz377w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T93+gXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T93+gXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28481F000E9;
	Thu, 28 May 2026 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000093;
	bh=xH3E9+Ni2NF95cbvoHxxKZ1aL2s1u76WyybDjrKdIWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0T93+gXggsVmUEi2tqay73J35nAeP5b2uBm5LtoJhAzBpACGpkl0H8eE2GGrlGF9U
	 wvg/pquJDAGb0jP3cqXOVMjc5B/NJ0OJqdGNfOvVmUp4Oz7jaH49sz6nibEbaHKQSI
	 3pFqmpu83UWBlD5Deodc+bydIf6vKl+sF5RoeOf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/377] btrfs: dont search back for dir inode item in INO_LOOKUP_USER
Date: Thu, 28 May 2026 21:48:57 +0200
Message-ID: <20260528194647.015775177@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 70085399b1a1623ef488d96b4c2d0c67be1d0607 ]

We don't need to search back to the inode item, the directory inode
number is in key.offset, so simply use that.  If we can't find the
directory we'll get an ENOENT at the iget().

Note: The patch was taken from v5 of fscrypt patchset
(https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
which was handled over time by various people: Omar Sandoval, Sweet Tea
Dorminy, Josef Bacik.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1e92637722ae ("btrfs: check for subvolume before deleting squota qgroup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c0691e93e0a58..41e549d37aac8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1832,7 +1832,7 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
 	struct btrfs_root_ref *rref;
 	struct btrfs_root *root = NULL;
 	struct btrfs_path *path;
-	struct btrfs_key key, key2;
+	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	char *ptr;
 	int slot;
@@ -1887,24 +1887,6 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
 			read_extent_buffer(leaf, ptr,
 					(unsigned long)(iref + 1), len);
 
-			/* Check the read+exec permission of this directory */
-			ret = btrfs_previous_item(root, path, dirid,
-						  BTRFS_INODE_ITEM_KEY);
-			if (ret < 0) {
-				goto out_put;
-			} else if (ret > 0) {
-				ret = -ENOENT;
-				goto out_put;
-			}
-
-			leaf = path->nodes[0];
-			slot = path->slots[0];
-			btrfs_item_key_to_cpu(leaf, &key2, slot);
-			if (key2.objectid != dirid) {
-				ret = -ENOENT;
-				goto out_put;
-			}
-
 			/*
 			 * We don't need the path anymore, so release it and
 			 * avoid deadlocks and lockdep warnings in case
@@ -1912,11 +1894,12 @@ static int btrfs_search_path_in_tree_user(struct mnt_idmap *idmap,
 			 * btree and lock the same leaf.
 			 */
 			btrfs_release_path(path);
-			temp_inode = btrfs_iget(key2.objectid, root);
+			temp_inode = btrfs_iget(key.offset, root);
 			if (IS_ERR(temp_inode)) {
 				ret = PTR_ERR(temp_inode);
 				goto out_put;
 			}
+			/* Check the read+exec permission of this directory. */
 			ret = inode_permission(idmap, &temp_inode->vfs_inode,
 					       MAY_READ | MAY_EXEC);
 			iput(&temp_inode->vfs_inode);
-- 
2.53.0



