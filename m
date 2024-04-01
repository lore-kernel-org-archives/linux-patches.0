Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BF41CA8F;
	Mon,  1 Apr 2024 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987352; cv=none; b=BH9ZWHou+GP1qNQ8zYgtZylGtIZUAvti6la8vn6WCioTI1IuZ6SbMZZVs2fcg2eSHQ9+Lo3MLlhaZriTx71B0xToXYQDODbjQ2/buXUNQS6TeW8f7RCsBpSKpHC3bAsifGQSLux6WQobbg7jaOhvvGT6vE2+tEnItqK6MGBzJS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987352; c=relaxed/simple;
	bh=djVVtHIJqRtnwUE5QDvTP325pYqS+t7RMDZE0jLbXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDIOEP5PbQyetmo1vWWg+N/HXbWBVeaw4aRsSBjN0nN/YPqSszxxW1eDsZ3prNX2cor3sR5noHx/7YbBluSGZVz04PmqgXND5SU3Gj4FrcG+ZOt/vkWH+31fkmyB+kNt5Rb1x24w16YqcDdJE9sO133MZVpg4GE9cYezsoSYN5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sgt3N+QC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sgt3N+QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE68C43390;
	Mon,  1 Apr 2024 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987352;
	bh=djVVtHIJqRtnwUE5QDvTP325pYqS+t7RMDZE0jLbXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sgt3N+QC68gqKd4yJPLuSEbjm8aMibofZIyEzpobKgmIQ03YM4j6ez85npF46LGYi
	 vo/UpRlLyV6CSNlFlCv3+OcywjEYAQ9252Uaw9d3qouFscVISn4hWsvtxzjPXXupND
	 FZwjwx+zQ/81o5y7HgW4UDGbfnWAN+qHCHZgz8dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 233/399] btrfs: qgroup: validate btrfs_qgroup_inherit parameter
Date: Mon,  1 Apr 2024 17:43:19 +0200
Message-ID: <20240401152556.134033423@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 86211eea8ae1676cc819d2b4fdc8d995394be07d ]

[BUG]
Currently btrfs can create subvolume with an invalid qgroup inherit
without triggering any error:

  # mkfs.btrfs -O quota -f $dev
  # mount $dev $mnt
  # btrfs subvolume create -i 2/0 $mnt/subv1
  # btrfs qgroup show -prce --sync $mnt
  Qgroupid    Referenced    Exclusive   Path
  --------    ----------    ---------   ----
  0/5           16.00KiB     16.00KiB   <toplevel>
  0/256         16.00KiB     16.00KiB   subv1

[CAUSE]
We only do a very basic size check for btrfs_qgroup_inherit structure,
but never really verify if the values are correct.

Thus in btrfs_qgroup_inherit() function, we have to skip non-existing
qgroups, and never return any error.

[FIX]
Fix the behavior and introduce extra checks:

- Introduce early check for btrfs_qgroup_inherit structure
  Not only the size, but also all the qgroup ids would be verified.

  And the timing is very early, so we can return error early.
  This early check is very important for snapshot creation, as snapshot
  is delayed to transaction commit.

- Drop support for btrfs_qgroup_inherit::num_ref_copies and
  num_excl_copies
  Those two members are used to specify to copy refr/excl numbers from
  other qgroups.
  This would definitely mark qgroup inconsistent, and btrfs-progs has
  dropped the support for them for a long time.
  It's time to drop the support for kernel.

- Verify the supported btrfs_qgroup_inherit::flags
  Just in case we want to add extra flags for btrfs_qgroup_inherit.

Now above subvolume creation would fail with -ENOENT other than silently
ignore the non-existing qgroup.

CC: stable@vger.kernel.org # 6.7+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c           | 16 +++---------
 fs/btrfs/qgroup.c          | 51 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h          |  3 +++
 include/uapi/linux/btrfs.h |  1 +
 4 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 738afd56c7e9e..bd19aed66605a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1362,7 +1362,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
 	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
-		u64 nums;
+		struct btrfs_fs_info *fs_info = inode_to_fs_info(file_inode(file));
 
 		if (vol_args->size < sizeof(*inherit) ||
 		    vol_args->size > PAGE_SIZE) {
@@ -1375,19 +1375,9 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 			goto free_args;
 		}
 
-		if (inherit->num_qgroups > PAGE_SIZE ||
-		    inherit->num_ref_copies > PAGE_SIZE ||
-		    inherit->num_excl_copies > PAGE_SIZE) {
-			ret = -EINVAL;
-			goto free_inherit;
-		}
-
-		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
-		       2 * inherit->num_excl_copies;
-		if (vol_args->size != struct_size(inherit, qgroups, nums)) {
-			ret = -EINVAL;
+		ret = btrfs_qgroup_check_inherit(fs_info, inherit, vol_args->size);
+		if (ret < 0)
 			goto free_inherit;
-		}
 	}
 
 	ret = __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5df54f78db2b9..a78c6694959aa 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3048,6 +3048,57 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
+int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
+			       struct btrfs_qgroup_inherit *inherit,
+			       size_t size)
+{
+	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
+		return -EOPNOTSUPP;
+	if (size < sizeof(*inherit) || size > PAGE_SIZE)
+		return -EINVAL;
+
+	/*
+	 * In the past we allowed btrfs_qgroup_inherit to specify to copy
+	 * rfer/excl numbers directly from other qgroups.  This behavior has
+	 * been disabled in userspace for a very long time, but here we should
+	 * also disable it in kernel, as this behavior is known to mark qgroup
+	 * inconsistent, and a rescan would wipe out the changes anyway.
+	 *
+	 * Reject any btrfs_qgroup_inherit with num_ref_copies or num_excl_copies.
+	 */
+	if (inherit->num_ref_copies > 0 || inherit->num_excl_copies > 0)
+		return -EINVAL;
+
+	if (inherit->num_qgroups > PAGE_SIZE)
+		return -EINVAL;
+
+	if (size != struct_size(inherit, qgroups, inherit->num_qgroups))
+		return -EINVAL;
+
+	/*
+	 * Now check all the remaining qgroups, they should all:
+	 *
+	 * - Exist
+	 * - Be higher level qgroups.
+	 */
+	for (int i = 0; i < inherit->num_qgroups; i++) {
+		struct btrfs_qgroup *qgroup;
+		u64 qgroupid = inherit->qgroups[i];
+
+		if (btrfs_qgroup_level(qgroupid) == 0)
+			return -EINVAL;
+
+		spin_lock(&fs_info->qgroup_lock);
+		qgroup = find_qgroup_rb(fs_info, qgroupid);
+		if (!qgroup) {
+			spin_unlock(&fs_info->qgroup_lock);
+			return -ENOENT;
+		}
+		spin_unlock(&fs_info->qgroup_lock);
+	}
+	return 0;
+}
+
 static int qgroup_auto_inherit(struct btrfs_fs_info *fs_info,
 			       u64 inode_rootid,
 			       struct btrfs_qgroup_inherit **inherit)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index be18c862e64ed..45a7d8920d039 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -341,6 +341,9 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans);
+int btrfs_qgroup_check_inherit(struct btrfs_fs_info *fs_info,
+			       struct btrfs_qgroup_inherit *inherit,
+			       size_t size);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 			 u64 objectid, u64 inode_rootid,
 			 struct btrfs_qgroup_inherit *inherit);
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index f8bc34a6bcfa2..cdf6ad872149c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -92,6 +92,7 @@ struct btrfs_qgroup_limit {
  * struct btrfs_qgroup_inherit.flags
  */
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
+#define BTRFS_QGROUP_INHERIT_FLAGS_SUPP (BTRFS_QGROUP_INHERIT_SET_LIMITS)
 
 struct btrfs_qgroup_inherit {
 	__u64	flags;
-- 
2.43.0



