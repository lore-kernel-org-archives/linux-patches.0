Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC11D1F7A;
	Wed,  2 Oct 2024 14:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880677; cv=none; b=hifJzERZYD2thdwiqX6L/qjZ59gRT9MfigI3aXb5LnC9cNnGaOFjPPJiNbdADG22WQk0R1qbSuvXgUq6HZ6SqPdDvHJNwNPOVM5pkO5IKIiTO0LMbI3Xw0B38XMyrMiF0KbwohX2fGvkAKZlcXg3i2Za/kZZzqCEOEasmSlmUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880677; c=relaxed/simple;
	bh=LQ2PZ6uV+zXAa1JVIpFukyu9tsaUOjuAHx7nI0lazjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKLihxnQhjrYcf2k6pGkLEo/7vNShkS4ydC+iXoC4AD8M13+8AqFg285/ZJN1cHe/PtNeEJMw09hGtpeYIGgd8mxlMGRV0IcBRH2S4aPwTocPK0CHZMpIgXPkXORfK5VTEA+5WuwHhp4FUAXa3rucwmZpOveBvaGXBI8iJpUO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWE4EjRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWE4EjRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69762C4CECF;
	Wed,  2 Oct 2024 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880676;
	bh=LQ2PZ6uV+zXAa1JVIpFukyu9tsaUOjuAHx7nI0lazjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWE4EjREJT2wj1EqlVz9XIy9hQoJH+wI0uvInGvpXqPHQNBvwszm7WfquNhEx9qzU
	 WreTmYGTFW0PJxkWPDDflQPp2H4tzozFfPIPnfcCPXNMqXh5KyYaSd6XeGvJi+b5vV
	 m1MyKmXc6nOr+f6OKSq82FP3tQ8t8yZi0Ku4UuxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/538] btrfs: fix race setting file private on concurrent lseek using same fd
Date: Wed,  2 Oct 2024 15:02:18 +0200
Message-ID: <20241002125812.136504973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7ee85f5515e86a4e2a2f51969795920733912bad ]

When doing concurrent lseek(2) system calls against the same file
descriptor, using multiple threads belonging to the same process, we have
a short time window where a race happens and can result in a memory leak.

The race happens like this:

1) A program opens a file descriptor for a file and then spawns two
   threads (with the pthreads library for example), lets call them
   task A and task B;

2) Task A calls lseek with SEEK_DATA or SEEK_HOLE and ends up at
   file.c:find_desired_extent() while holding a read lock on the inode;

3) At the start of find_desired_extent(), it extracts the file's
   private_data pointer into a local variable named 'private', which has
   a value of NULL;

4) Task B also calls lseek with SEEK_DATA or SEEK_HOLE, locks the inode
   in shared mode and enters file.c:find_desired_extent(), where it also
   extracts file->private_data into its local variable 'private', which
   has a NULL value;

5) Because it saw a NULL file private, task A allocates a private
   structure and assigns to the file structure;

6) Task B also saw a NULL file private so it also allocates its own file
   private and then assigns it to the same file structure, since both
   tasks are using the same file descriptor.

   At this point we leak the private structure allocated by task A.

Besides the memory leak, there's also the detail that both tasks end up
using the same cached state record in the private structure (struct
btrfs_file_private::llseek_cached_state), which can result in a
use-after-free problem since one task can free it while the other is
still using it (only one task took a reference count on it). Also, sharing
the cached state is not a good idea since it could result in incorrect
results in the future - right now it should not be a problem because it
end ups being used only in extent-io-tree.c:count_range_bits() where we do
range validation before using the cached state.

Fix this by protecting the private assignment and check of a file while
holding the inode's spinlock and keep track of the task that allocated
the private, so that it's used only by that task in order to prevent
user-after-free issues with the cached state record as well as potentially
using it incorrectly in the future.

Fixes: 3c32c7212f16 ("btrfs: use cached state when looking for delalloc ranges with lseek")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  1 +
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/file.c        | 34 +++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index e9a979d0a9585..ec6679a538c1d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -85,6 +85,7 @@ struct btrfs_inode {
 	 * logged_trans), to access/update delalloc_bytes, new_delalloc_bytes,
 	 * defrag_bytes, disk_i_size, outstanding_extents, csum_bytes and to
 	 * update the VFS' inode number of bytes used.
+	 * Also protects setting struct file::private_data.
 	 */
 	spinlock_t lock;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 06333a74d6c4c..f7bb4c34b984b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -445,6 +445,8 @@ struct btrfs_file_private {
 	void *filldir_buf;
 	u64 last_index;
 	struct extent_state *llseek_cached_state;
+	/* Task that allocated this structure. */
+	struct task_struct *owner_task;
 };
 
 static inline u32 BTRFS_LEAF_DATA_SIZE(const struct btrfs_fs_info *info)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15fd8c00f4c08..fc6c91773bc89 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3481,7 +3481,7 @@ static bool find_desired_extent_in_hole(struct btrfs_inode *inode, int whence,
 static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
 {
 	struct btrfs_inode *inode = BTRFS_I(file->f_mapping->host);
-	struct btrfs_file_private *private = file->private_data;
+	struct btrfs_file_private *private;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_state *cached_state = NULL;
 	struct extent_state **delalloc_cached_state;
@@ -3509,7 +3509,19 @@ static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
 	    inode_get_bytes(&inode->vfs_inode) == i_size)
 		return i_size;
 
-	if (!private) {
+	spin_lock(&inode->lock);
+	private = file->private_data;
+	spin_unlock(&inode->lock);
+
+	if (private && private->owner_task != current) {
+		/*
+		 * Not allocated by us, don't use it as its cached state is used
+		 * by the task that allocated it and we don't want neither to
+		 * mess with it nor get incorrect results because it reflects an
+		 * invalid state for the current task.
+		 */
+		private = NULL;
+	} else if (!private) {
 		private = kzalloc(sizeof(*private), GFP_KERNEL);
 		/*
 		 * No worries if memory allocation failed.
@@ -3517,7 +3529,23 @@ static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
 		 * lseek SEEK_HOLE/DATA calls to a file when there's delalloc,
 		 * so everything will still be correct.
 		 */
-		file->private_data = private;
+		if (private) {
+			bool free = false;
+
+			private->owner_task = current;
+
+			spin_lock(&inode->lock);
+			if (file->private_data)
+				free = true;
+			else
+				file->private_data = private;
+			spin_unlock(&inode->lock);
+
+			if (free) {
+				kfree(private);
+				private = NULL;
+			}
+		}
 	}
 
 	if (private)
-- 
2.43.0



