Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1024A3C9886;
	Thu, 17 Sep 2026 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671774; cv=none; b=UORcTl0N5/ZHaJcVhuBnrwKHZO5+dFQ+zqumA8Itx3D4I45b7ZDCR4nfs9Vr06MeUlr0S8jT+0D1b0fTOFKEiKdbet9aV2cV4YkQevg+3uxYWG7kWgaKjDOlZvEmoWlRhvbaCumjrF6nDvk53ZgaEUZIufkGtDS8qMM6/kyws+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671774; c=relaxed/simple;
	bh=X4F9nz9cmsrtD2FCMEfZiEy1sYVAja344ExxQz+4bjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBG/JN+HUCrlb9IphebwffGKlVeaLXx8bDlEIZnMSk+73EM7DTH/kIRdMh3vgnUs0VzLNOb8LUHL7FQnwruUk6tobbtyn8z7oXR3LZNtR0NkOsQdl7vgkcQZuNqQFD7rXPQjcHUlniNSlQw5J3nmYgWH8Ny6AE9Znvt8mdh2NsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEkZ/QQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEkZ/QQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D11F000FF;
	Thu, 17 Sep 2026 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671772;
	bh=TTOvayr3tKMJzG6j54BdH5K8KFFZoNWF5rMkK7g5Duc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEkZ/QQ44csKJF2qsoJzOKRcRuHpMvBlPtwEPjyMn0hyUzBKh3XZEC2koZF4CawXG
	 b8Ct9wJXV1xOAuRqhCjujMADYpuwlPbpkOYDhNk2yPwK8cetgiXJXg8nukCk3HPI82
	 0WU5LOA5F3inCQrzRRhKkuz+1wWvpr8tto80ymGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1048/1102] btrfs: use BTRFS_PATH_AUTO_FREE in can_nocow_extent()
Date: Thu, 17 Sep 2026 16:16:31 +0100
Message-ID: <20260917151607.110353483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 5e8632035a173a8c54c17301ecff69c79babb4bf ]

This is the trivial pattern for path auto free, initialize at the
beginning and free at the end with simple goto -> return conversions.

Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 3f950867c307 ("btrfs: fix extent map leak in NOCOW direct I/O write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7054,7 +7054,7 @@ noinline int can_nocow_extent(struct ino
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
 	struct can_nocow_file_extent_args nocow_args = { 0 };
-	struct btrfs_path *path;
+	BTRFS_PATH_AUTO_FREE(path);
 	int ret;
 	struct extent_buffer *leaf;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -7071,13 +7071,12 @@ noinline int can_nocow_extent(struct ino
 	ret = btrfs_lookup_file_extent(NULL, root, path,
 			btrfs_ino(BTRFS_I(inode)), offset, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (ret == 1) {
 		if (path->slots[0] == 0) {
-			/* can't find the item, must cow */
-			ret = 0;
-			goto out;
+			/* Can't find the item, must COW. */
+			return 0;
 		}
 		path->slots[0]--;
 	}
@@ -7086,17 +7085,17 @@ noinline int can_nocow_extent(struct ino
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 	if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 	    key.type != BTRFS_EXTENT_DATA_KEY) {
-		/* not our file or wrong item type, must cow */
-		goto out;
+		/* Not our file or wrong item type, must COW. */
+		return 0;
 	}
 
 	if (key.offset > offset) {
-		/* Wrong offset, must cow */
-		goto out;
+		/* Wrong offset, must COW. */
+		return 0;
 	}
 
 	if (btrfs_file_extent_end(path) <= offset)
-		goto out;
+		return 0;
 
 	fi = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_file_extent_item);
 	found_type = btrfs_file_extent_type(leaf, fi);
@@ -7112,15 +7111,13 @@ noinline int can_nocow_extent(struct ino
 
 	if (ret != 1) {
 		/* Treat errors as not being able to NOCOW. */
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
-	ret = 0;
 	if (btrfs_extent_readonly(fs_info,
 				  nocow_args.file_extent.disk_bytenr +
 				  nocow_args.file_extent.offset))
-		goto out;
+		return 0;
 
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -7129,20 +7126,16 @@ noinline int can_nocow_extent(struct ino
 		range_end = round_up(offset + nocow_args.file_extent.num_bytes,
 				     root->fs_info->sectorsize) - 1;
 		ret = test_range_bit_exists(io_tree, offset, range_end, EXTENT_DELALLOC);
-		if (ret) {
-			ret = -EAGAIN;
-			goto out;
-		}
+		if (ret)
+			return -EAGAIN;
 	}
 
 	if (file_extent)
 		memcpy(file_extent, &nocow_args.file_extent, sizeof(*file_extent));
 
 	*len = nocow_args.file_extent.num_bytes;
-	ret = 1;
-out:
-	btrfs_free_path(path);
-	return ret;
+
+	return 1;
 }
 
 /* The callers of this must take lock_extent() */


