Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9DB2FA622;
	Tue, 17 Jun 2025 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179374; cv=none; b=mnpPOgBvOxS8Y0ZD1IWk8zlqA3lFdAffdcTMoJvrUZ9vR+P8meZCUVUWre2+L4rJ7sRa/oB1FRDbGvgHMhDZ/bSPYvGwIRrq8HqDU4HpzTszv34FKKNdwjHkhDe/vRlCXWcpOXfbXeR/dQ4m1oTmNwAthL3MAbZhy+BV8jBQ2vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179374; c=relaxed/simple;
	bh=T9RojoFY8Agqri2/I3NokU681yveogSZPj2U5AtqZ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnpbOUZ8Z4fuBBKQ1hDhlta63XWJpER2I15ExWW+HHK69Ge6UpqVFHAW0K5s2V4cWIkEpGtoiVpaqnfAMauuoy44FCGwnBPxe8oDuiyatxX//7AQRBFkFXUdIJfxYnkKIUtyfpcD9yj4LOIfnKQBQrcHELEtUkBhwDU5LunCMpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6mOhO9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6mOhO9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A9C4CEE3;
	Tue, 17 Jun 2025 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179374;
	bh=T9RojoFY8Agqri2/I3NokU681yveogSZPj2U5AtqZ7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6mOhO9MB36hDd6EPHgrk2PJr833s0MdMuDDzrH7Pj3wkMI/M0MyYJLFHPrBj/aMd
	 eITLrIEMQYZBtoWdxSjxpE5qzfLxl1U6xwMOftETSIogw0o9szwZCsC+TCR6LUteMP
	 e++Rn7p+MMAIZpf9z/Vsob8K6GGGBvh1d/bgobEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 726/780] btrfs: fix fsync of files with no hard links not persisting deletion
Date: Tue, 17 Jun 2025 17:27:14 +0200
Message-ID: <20250617152521.060049177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5e85262e542d6da8898bb8563a724ad98f6fc936 ]

If we fsync a file (or directory) that has no more hard links, because
while a process had a file descriptor open on it, the file's last hard
link was removed and then the process did an fsync against the file
descriptor, after a power failure or crash the file still exists after
replaying the log.

This behaviour is incorrect since once an inode has no more hard links
it's not accessible anymore and we insert an orphan item into its
subvolume's tree so that the deletion of all its items is not missed in
case of a power failure or crash.

So after log replay the file shouldn't exist anymore, which is also the
behaviour on ext4, xfs, f2fs and other filesystems.

Fix this by not ignoring inodes with zero hard links at
btrfs_log_inode_parent() and by committing an inode's delayed inode when
we are not doing a fast fsync (either BTRFS_INODE_COPY_EVERYTHING or
BTRFS_INODE_NEEDS_FULL_SYNC is set in the inode's runtime flags). This
last step is necessary because when removing the last hard link we don't
delete the corresponding ref (or extref) item, instead we record the
change in the inode's delayed inode with the BTRFS_DELAYED_NODE_DEL_IREF
flag, so that when the delayed inode is committed we delete the ref/extref
item from the inode's subvolume tree - otherwise the logging code will log
the last hard link and therefore upon log replay the inode is not deleted.

The base code for a fstests test case that reproduces this bug is the
following:

   . ./common/dmflakey

   _require_scratch
   _require_dm_target flakey
   _require_mknod

   _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
   _require_metadata_journaling $SCRATCH_DEV
   _init_flakey
   _mount_flakey

   touch $SCRATCH_MNT/foo

   # Commit the current transaction and persist the file.
   _scratch_sync

   # A fifo to communicate with a background xfs_io process that will
   # fsync the file after we deleted its hard link while it's open by
   # xfs_io.
   mkfifo $SCRATCH_MNT/fifo

   tail -f $SCRATCH_MNT/fifo | \
        $XFS_IO_PROG $SCRATCH_MNT/foo >>$seqres.full &
   XFS_IO_PID=$!

   # Give some time for the xfs_io process to open a file descriptor for
   # the file.
   sleep 1

   # Now while the file is open by the xfs_io process, delete its only
   # hard link.
   rm -f $SCRATCH_MNT/foo

   # Now that it has no more hard links, make the xfs_io process fsync it.
   echo "fsync" > $SCRATCH_MNT/fifo

   # Terminate the xfs_io process so that we can unmount.
   echo "quit" > $SCRATCH_MNT/fifo
   wait $XFS_IO_PID
   unset XFS_IO_PID

   # Simulate a power failure and then mount again the filesystem to
   # replay the journal/log.
   _flakey_drop_and_remount

   # We don't expect the file to exist anymore, since it was fsynced when
   # it had no more hard links.
   [ -f $SCRATCH_MNT/foo ] && echo "file foo still exists"

   _unmount_flakey

   # success, all done
   echo "Silence is golden"
   status=0
   exit

A test case for fstests will be submitted soon.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 90dc094cfa5e5..f5af11565b876 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6583,6 +6583,19 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		btrfs_log_get_delayed_items(inode, &delayed_ins_list,
 					    &delayed_del_list);
 
+	/*
+	 * If we are fsyncing a file with 0 hard links, then commit the delayed
+	 * inode because the last inode ref (or extref) item may still be in the
+	 * subvolume tree and if we log it the file will still exist after a log
+	 * replay. So commit the delayed inode to delete that last ref and we
+	 * skip logging it.
+	 */
+	if (inode->vfs_inode.i_nlink == 0) {
+		ret = btrfs_commit_inode_delayed_inode(inode);
+		if (ret)
+			goto out_unlock;
+	}
+
 	ret = copy_inode_items_to_log(trans, inode, &min_key, &max_key,
 				      path, dst_path, logged_isize,
 				      inode_only, ctx,
@@ -7051,14 +7064,9 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (btrfs_root_generation(&root->root_item) == trans->transid)
 		return BTRFS_LOG_FORCE_COMMIT;
 
-	/*
-	 * Skip already logged inodes or inodes corresponding to tmpfiles
-	 * (since logging them is pointless, a link count of 0 means they
-	 * will never be accessible).
-	 */
-	if ((btrfs_inode_in_log(inode, trans->transid) &&
-	     list_empty(&ctx->ordered_extents)) ||
-	    inode->vfs_inode.i_nlink == 0)
+	/* Skip already logged inodes and without new extents. */
+	if (btrfs_inode_in_log(inode, trans->transid) &&
+	    list_empty(&ctx->ordered_extents))
 		return BTRFS_NO_LOG_SYNC;
 
 	ret = start_log_trans(trans, root, ctx);
-- 
2.39.5



