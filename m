Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1719F485;
	Tue, 27 Aug 2024 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771042; cv=none; b=j0xvnGSNWqzT7swORvLJnITYaaabnvuClkI7XMidzX5ddmNdVXF08PIJdbMx77yoG4u4RoNErp9R4lCFDDk26B3JuH0jVEuMrdE8Xd47h/aNq3eRMaztjKLSS3Kyxd64srEY76eWBlL4sv+VTeQqBWEse590/gna8MMB6J/mLVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771042; c=relaxed/simple;
	bh=YLmAQMwSrndJAkIVCkl1qJitDYBDUDL1+NmtXXA1bR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfhgg/WJJEI33TbxtUDC9bUQ0qavf+B6U/9ZyUJwGuVy0U3SDILLkLv00svZiwS9OdG9x+xkX4nvPlQYP5/1T4AZRC9tW5d/cMap5QrrYsyCUZcXl0aAQvTSIwMIvfZuokTuBtpk021rikS6NZqc78714+hmzxxl9BmrnqYHVRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oKhpsRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oKhpsRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097B0C6104C;
	Tue, 27 Aug 2024 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771042;
	bh=YLmAQMwSrndJAkIVCkl1qJitDYBDUDL1+NmtXXA1bR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oKhpsRD37b/2TnwkU50hh37ivo/P8q1iqOvm+dq4i0Xh0QtdHXk1K7uMejgspV6o
	 74Jnw00OMBqr3iEENWJztXKXXr00mTJxhRrJBHriJ32+uOkBtbgC5S/ZlQw9ADEcWV
	 nrpvFTWpHoFj6WJfJ8dHN47W8PdG/VGDxCj96U4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 062/273] btrfs: check delayed refs when were checking if a ref exists
Date: Tue, 27 Aug 2024 16:36:26 +0200
Message-ID: <20240827143835.766550830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 42fac187b5c746227c92d024f1caf33bc1d337e4 upstream.

In the patch 78c52d9eb6b7 ("btrfs: check for refs on snapshot delete
resume") I added some code to handle file systems that had been
corrupted by a bug that incorrectly skipped updating the drop progress
key while dropping a snapshot.  This code would check to see if we had
already deleted our reference for a child block, and skip the deletion
if we had already.

Unfortunately there is a bug, as the check would only check the on-disk
references.  I made an incorrect assumption that blocks in an already
deleted snapshot that was having the deletion resume on mount wouldn't
be modified.

If we have 2 pending deleted snapshots that share blocks, we can easily
modify the rules for a block.  Take the following example

subvolume a exists, and subvolume b is a snapshot of subvolume a.  They
share references to block 1.  Block 1 will have 2 full references, one
for subvolume a and one for subvolume b, and it belongs to subvolume a
(btrfs_header_owner(block 1) == subvolume a).

When deleting subvolume a, we will drop our full reference for block 1,
and because we are the owner we will drop our full reference for all of
block 1's children, convert block 1 to FULL BACKREF, and add a shared
reference to all of block 1's children.

Then we will start the snapshot deletion of subvolume b.  We look up the
extent info for block 1, which checks delayed refs and tells us that
FULL BACKREF is set, so sets parent to the bytenr of block 1.  However
because this is a resumed snapshot deletion, we call into
check_ref_exists().  Because check_ref_exists() only looks at the disk,
it doesn't find the shared backref for the child of block 1, and thus
returns 0 and we skip deleting the reference for the child of block 1
and continue.  This orphans the child of block 1.

The fix is to lookup the delayed refs, similar to what we do in
btrfs_lookup_extent_info().  However we only care about whether the
reference exists or not.  If we fail to find our reference on disk, go
look up the bytenr in the delayed refs, and if it exists look for an
existing ref in the delayed ref head.  If that exists then we know we
can delete the reference safely and carry on.  If it doesn't exist we
know we have to skip over this block.

This bug has existed since I introduced this fix, however requires
having multiple deleted snapshots pending when we unmount.  We noticed
this in production because our shutdown path stops the container on the
system, which deletes a bunch of subvolumes, and then reboots the box.
This gives us plenty of opportunities to hit this issue.  Looking at the
history we've seen this occasionally in production, but we had a big
spike recently thanks to faster machines getting jobs with multiple
subvolumes in the job.

Chris Mason wrote a reproducer which does the following

mount /dev/nvme4n1 /btrfs
btrfs subvol create /btrfs/s1
simoop -E -f 4k -n 200000 -z /btrfs/s1
while(true) ; do
	btrfs subvol snap /btrfs/s1 /btrfs/s2
	simoop -f 4k -n 200000 -r 10 -z /btrfs/s2
	btrfs subvol snap /btrfs/s2 /btrfs/s3
	btrfs balance start -dusage=80 /btrfs
	btrfs subvol del /btrfs/s2 /btrfs/s3
	umount /btrfs
	btrfsck /dev/nvme4n1 || exit 1
	mount /dev/nvme4n1 /btrfs
done

On the second loop this would fail consistently, with my patch it has
been running for hours and hasn't failed.

I also used dm-log-writes to capture the state of the failure so I could
debug the problem.  Using the existing failure case to test my patch
validated that it fixes the problem.

Fixes: 78c52d9eb6b7 ("btrfs: check for refs on snapshot delete resume")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-ref.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-ref.h |    2 +
 fs/btrfs/extent-tree.c |   51 ++++++++++++++++++++++++++++++++-----
 3 files changed, 114 insertions(+), 6 deletions(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -1169,6 +1169,73 @@ btrfs_find_delayed_ref_head(struct btrfs
 	return find_ref_head(delayed_refs, bytenr, false);
 }
 
+static int find_comp(struct btrfs_delayed_ref_node *entry, u64 root, u64 parent)
+{
+	int type = parent ? BTRFS_SHARED_BLOCK_REF_KEY : BTRFS_TREE_BLOCK_REF_KEY;
+
+	if (type < entry->type)
+		return -1;
+	if (type > entry->type)
+		return 1;
+
+	if (type == BTRFS_TREE_BLOCK_REF_KEY) {
+		if (root < entry->ref_root)
+			return -1;
+		if (root > entry->ref_root)
+			return 1;
+	} else {
+		if (parent < entry->parent)
+			return -1;
+		if (parent > entry->parent)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * Check to see if a given root/parent reference is attached to the head.  This
+ * only checks for BTRFS_ADD_DELAYED_REF references that match, as that
+ * indicates the reference exists for the given root or parent.  This is for
+ * tree blocks only.
+ *
+ * @head: the head of the bytenr we're searching.
+ * @root: the root objectid of the reference if it is a normal reference.
+ * @parent: the parent if this is a shared backref.
+ */
+bool btrfs_find_delayed_tree_ref(struct btrfs_delayed_ref_head *head,
+				 u64 root, u64 parent)
+{
+	struct rb_node *node;
+	bool found = false;
+
+	lockdep_assert_held(&head->mutex);
+
+	spin_lock(&head->lock);
+	node = head->ref_tree.rb_root.rb_node;
+	while (node) {
+		struct btrfs_delayed_ref_node *entry;
+		int ret;
+
+		entry = rb_entry(node, struct btrfs_delayed_ref_node, ref_node);
+		ret = find_comp(entry, root, parent);
+		if (ret < 0) {
+			node = node->rb_left;
+		} else if (ret > 0) {
+			node = node->rb_right;
+		} else {
+			/*
+			 * We only want to count ADD actions, as drops mean the
+			 * ref doesn't exist.
+			 */
+			if (entry->action == BTRFS_ADD_DELAYED_REF)
+				found = true;
+			break;
+		}
+	}
+	spin_unlock(&head->lock);
+	return found;
+}
+
 void __cold btrfs_delayed_ref_exit(void)
 {
 	kmem_cache_destroy(btrfs_delayed_ref_head_cachep);
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -389,6 +389,8 @@ int btrfs_delayed_refs_rsv_refill(struct
 void btrfs_migrate_to_delayed_refs_rsv(struct btrfs_fs_info *fs_info,
 				       u64 num_bytes);
 bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
+bool btrfs_find_delayed_tree_ref(struct btrfs_delayed_ref_head *head,
+				 u64 root, u64 parent);
 
 static inline u64 btrfs_delayed_ref_owner(struct btrfs_delayed_ref_node *node)
 {
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5387,23 +5387,62 @@ static int check_ref_exists(struct btrfs
 			    struct btrfs_root *root, u64 bytenr, u64 parent,
 			    int level)
 {
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
 	struct btrfs_path *path;
 	struct btrfs_extent_inline_ref *iref;
 	int ret;
+	bool exists = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-
+again:
 	ret = lookup_extent_backref(trans, path, &iref, bytenr,
 				    root->fs_info->nodesize, parent,
 				    btrfs_root_id(root), level, 0);
+	if (ret != -ENOENT) {
+		/*
+		 * If we get 0 then we found our reference, return 1, else
+		 * return the error if it's not -ENOENT;
+		 */
+		btrfs_free_path(path);
+		return (ret < 0 ) ? ret : 1;
+	}
+
+	/*
+	 * We could have a delayed ref with this reference, so look it up while
+	 * we're holding the path open to make sure we don't race with the
+	 * delayed ref running.
+	 */
+	delayed_refs = &trans->transaction->delayed_refs;
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(delayed_refs, bytenr);
+	if (!head)
+		goto out;
+	if (!mutex_trylock(&head->mutex)) {
+		/*
+		 * We're contended, means that the delayed ref is running, get a
+		 * reference and wait for the ref head to be complete and then
+		 * try again.
+		 */
+		refcount_inc(&head->refs);
+		spin_unlock(&delayed_refs->lock);
+
+		btrfs_release_path(path);
+
+		mutex_lock(&head->mutex);
+		mutex_unlock(&head->mutex);
+		btrfs_put_delayed_ref_head(head);
+		goto again;
+	}
+
+	exists = btrfs_find_delayed_tree_ref(head, root->root_key.objectid, parent);
+	mutex_unlock(&head->mutex);
+out:
+	spin_unlock(&delayed_refs->lock);
 	btrfs_free_path(path);
-	if (ret == -ENOENT)
-		return 0;
-	if (ret < 0)
-		return ret;
-	return 1;
+	return exists ? 1 : 0;
 }
 
 /*


