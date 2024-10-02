Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5C17B421;
	Wed,  2 Oct 2024 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877009; cv=none; b=Mvc84y2oLIrcWOdHMqzdCDWYk0CTffg0yhBHUwNj06Dc7DuzBGop+CPOMraFZkLTY2WX28dJ329r8rNRm1schNdpnmAzBurTas7cct6D3UYTRnNJlCel0hrav3SzVy00ztiJbTzxphuUBwUsaahiRx4/j9O1fnAs1nEWFxzZZZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877009; c=relaxed/simple;
	bh=vrnNAYdeHwC0iBcuYjugwC0S0iyV9cGXWZpHi73jSPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0NPpQw3q75Cifk/7GGthsJwkgC+FhXSbAME1MLE1GGMHYT6QCvo1hQuuMtK7o6xaY57rz1bssb6Km+UBUZPh+mDY2rCnaFiFOEkYr8h1LRzJr+7sJrXHzVIooHXksoSRtsah30B1tKvd6uC84jeTHt+G1WO8HDinkbJa5QcLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLC/yezs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLC/yezs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38219C4CEC2;
	Wed,  2 Oct 2024 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877009;
	bh=vrnNAYdeHwC0iBcuYjugwC0S0iyV9cGXWZpHi73jSPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLC/yezs+Qp9IQee4MDY7G2NcgNGfRsuTl3u2eLC0yIUt4WtKKkveQ6ZYG45Z2zVZ
	 Y+9j2AnQCBBVXHY5sC34FWaj6bVhDwxl68xN2WU/WqlJBAltCit5Uzi7l7cimU930m
	 zhGMmPhJTh/oVtbDMOehqOIdx7GCzAiUr5JaCodA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 626/695] btrfs: fix race setting file private on concurrent lseek using same fd
Date: Wed,  2 Oct 2024 15:00:24 +0200
Message-ID: <20241002125847.500535244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 7ee85f5515e86a4e2a2f51969795920733912bad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h |    1 +
 fs/btrfs/ctree.h       |    2 ++
 fs/btrfs/file.c        |   34 +++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -152,6 +152,7 @@ struct btrfs_inode {
 	 * logged_trans), to access/update delalloc_bytes, new_delalloc_bytes,
 	 * defrag_bytes, disk_i_size, outstanding_extents, csum_bytes and to
 	 * update the VFS' inode number of bytes used.
+	 * Also protects setting struct file::private_data.
 	 */
 	spinlock_t lock;
 
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -459,6 +459,8 @@ struct btrfs_file_private {
 	void *filldir_buf;
 	u64 last_index;
 	struct extent_state *llseek_cached_state;
+	/* Task that allocated this structure. */
+	struct task_struct *owner_task;
 };
 
 static inline u32 BTRFS_LEAF_DATA_SIZE(const struct btrfs_fs_info *info)
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3485,7 +3485,7 @@ static bool find_desired_extent_in_hole(
 static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
 {
 	struct btrfs_inode *inode = BTRFS_I(file->f_mapping->host);
-	struct btrfs_file_private *private = file->private_data;
+	struct btrfs_file_private *private;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_state *cached_state = NULL;
 	struct extent_state **delalloc_cached_state;
@@ -3513,7 +3513,19 @@ static loff_t find_desired_extent(struct
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
@@ -3521,7 +3533,23 @@ static loff_t find_desired_extent(struct
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


