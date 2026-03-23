Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C50282F35;
	Mon, 23 Mar 2026 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282977; cv=none; b=V++HLP+Bv7H2SPl8nantUUVQLfmrMGvZ0oYgteIPfzerzRkMhOcgSTY18CNbKIlp65xGeWtQ+ZeidRj1R1cSEzsC/6KqZMUZDvn2wuQ/YY8c24YrAQXPg1zUWx53EkSYhnkx7oWDUgDZI7KsJrXRgwi4rn+LRFtrRk1JQ2aToac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282977; c=relaxed/simple;
	bh=9ohquUWFz0TgjZNXm5OBsUBVb9mneefhsGETz6Lj5R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKc0BHAEFHw6yI1F3sxxeZxsM0uGcgpuoxNZD1YX5ED8rVVvxmzeXqDL7KY7bYqtyb7CEZg2eS+HpKghOOq6Sl4r9idnhvVVcCKV42DdfUKv90NfGC7JMD/4E5G/+NaLSJLABYBRRUlLyB2lNJPQKLl1Fi7PldIFc6bPmekllDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzuHx9/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzuHx9/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374C4C4CEF7;
	Mon, 23 Mar 2026 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282977;
	bh=9ohquUWFz0TgjZNXm5OBsUBVb9mneefhsGETz6Lj5R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzuHx9/VL+aTgNRWA5t2Svd5IWjDszk5otDNxaWsVz608Yoc4DWy2OWDEhdNeE3W4
	 OGbnT0BAKIuekb4yHvbhLBcHKDoKnSHYTIQ16G7/0bLueNqDWZo3GBHFf1fd6Ecqne
	 py5dTrtk4yQdfBr+WzYRW46uqrfkTXFsFz2d255Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/481] btrfs: fix transaction abort on set received ioctl due to item overflow
Date: Mon, 23 Mar 2026 14:45:37 +0100
Message-ID: <20260323134533.759655322@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 87f2c46003fce4d739138aab4af1942b1afdadac ]

If the set received ioctl fails due to an item overflow when attempting to
add the BTRFS_UUID_KEY_RECEIVED_SUBVOL we have to abort the transaction
since we did some metadata updates before.

This means that if a user calls this ioctl with the same received UUID
field for a lot of subvolumes, we will hit the overflow, trigger the
transaction abort and turn the filesystem into RO mode. A malicious user
could exploit this, and this ioctl does not even requires that a user
has admin privileges (CAP_SYS_ADMIN), only that he/she owns the subvolume.

Fix this by doing an early check for item overflow before starting a
transaction. This is also race safe because we are holding the subvol_sem
semaphore in exclusive (write) mode.

A test case for fstests will follow soon.

Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
CC: stable@vger.kernel.org # 3.12+
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ A whole bunch of small things :) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h     |    2 ++
 fs/btrfs/ioctl.c     |   21 +++++++++++++++++++--
 fs/btrfs/uuid-tree.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3210,6 +3210,8 @@ int btrfs_uuid_tree_add(struct btrfs_tra
 			u64 subid);
 int btrfs_uuid_tree_remove(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 			u64 subid);
+int btrfs_uuid_tree_check_overflow(struct btrfs_fs_info *fs_info,
+				   u8 *uuid, u8 type);
 int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info);
 
 /* dir-item.c */
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4883,6 +4883,25 @@ static long _btrfs_ioctl_set_received_su
 		goto out;
 	}
 
+	received_uuid_changed = memcmp(root_item->received_uuid, sa->uuid,
+				       BTRFS_UUID_SIZE);
+
+	/*
+	 * Before we attempt to add the new received uuid, check if we have room
+	 * for it in case there's already an item. If the size of the existing
+	 * item plus this root's ID (u64) exceeds the maximum item size, we can
+	 * return here without the need to abort a transaction. If we don't do
+	 * this check, the btrfs_uuid_tree_add() call below would fail with
+	 * -EOVERFLOW and result in a transaction abort. Malicious users could
+	 * exploit this to turn the fs into RO mode.
+	 */
+	if (received_uuid_changed && !btrfs_is_empty_uuid(sa->uuid)) {
+		ret = btrfs_uuid_tree_check_overflow(fs_info, sa->uuid,
+						     BTRFS_UUID_KEY_RECEIVED_SUBVOL);
+		if (ret < 0)
+			goto out;
+	}
+
 	/*
 	 * 1 - root item
 	 * 2 - uuid items (received uuid + subvol uuid)
@@ -4898,8 +4917,6 @@ static long _btrfs_ioctl_set_received_su
 	sa->rtime.sec = ct.tv_sec;
 	sa->rtime.nsec = ct.tv_nsec;
 
-	received_uuid_changed = memcmp(root_item->received_uuid, sa->uuid,
-				       BTRFS_UUID_SIZE);
 	if (received_uuid_changed &&
 	    !btrfs_is_empty_uuid(root_item->received_uuid)) {
 		ret = btrfs_uuid_tree_remove(trans, root_item->received_uuid,
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -225,6 +225,52 @@ out:
 	return ret;
 }
 
+/*
+ * Check if we can add one root ID to a UUID key.
+ * If the key does not yet exists, we can, otherwise only if extended item does
+ * not exceeds the maximum item size permitted by the leaf size.
+ *
+ * Returns 0 on success, negative value on error.
+ */
+int btrfs_uuid_tree_check_overflow(struct btrfs_fs_info *fs_info,
+				   u8 *uuid, u8 type)
+{
+	struct btrfs_path *path = NULL;
+	int ret;
+	u32 item_size;
+	struct btrfs_key key;
+
+	if (WARN_ON_ONCE(!fs_info->uuid_root)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	btrfs_uuid_to_key(uuid, type, &key);
+	ret = btrfs_search_slot(NULL, fs_info->uuid_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = 0;
+		goto out;
+	}
+
+	item_size = btrfs_item_size(path->nodes[0], path->slots[0]);
+
+	if (sizeof(struct btrfs_item) + item_size + sizeof(u64) >
+	    BTRFS_LEAF_DATA_SIZE(fs_info))
+		ret = -EOVERFLOW;
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid, u8 type,
 			       u64 subid)
 {


