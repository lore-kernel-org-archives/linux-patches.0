Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0818F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08F6C433C7;
	Sun, 16 Jul 2023 20:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539274;
	bh=yhLj4Y+Rf0mxwvFY7xg5aUwgJEVbLX4B6PBPOxUaxuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsYw8MPbBlt9X9lMiljg3FvCXSxL1vfSDzbSaXSNQNu8ewYsPAI5i+ZtrLPzd7MRi
	 D9SDHmwyNqAJTDykLeo63N5qGjzwTIxmIK0SzWBiHTkye2Unt7rv/ckjiDb5+XynbO
	 Fd3/UVwDCW5tSFtb1u57PrFv7Z4mXcBYF0uJgydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.4 749/800] fs: Establish locking order for unrelated directories
Date: Sun, 16 Jul 2023 21:50:02 +0200
Message-ID: <20230716195006.519965643@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit f23ce757185319886ca80c4864ce5f81ac6cc9e9 upstream.

Currently the locking order of inode locks for directories that are not
in ancestor relationship is not defined because all operations that
needed to lock two directories like this were serialized by
sb->s_vfs_rename_mutex. However some filesystems need to lock two
subdirectories for RENAME_EXCHANGE operations and for this we need the
locking order established even for two tree-unrelated directories.
Provide a helper function lock_two_inodes() that establishes lock
ordering for any two inodes and use it in lock_two_directories().

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230601105830.13168-4-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h |    2 ++
 fs/namei.c    |    4 ++--
 3 files changed, 46 insertions(+), 2 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1104,6 +1104,48 @@ void discard_new_inode(struct inode *ino
 EXPORT_SYMBOL(discard_new_inode);
 
 /**
+ * lock_two_inodes - lock two inodes (may be regular files but also dirs)
+ *
+ * Lock any non-NULL argument. The caller must make sure that if he is passing
+ * in two directories, one is not ancestor of the other.  Zero, one or two
+ * objects may be locked by this function.
+ *
+ * @inode1: first inode to lock
+ * @inode2: second inode to lock
+ * @subclass1: inode lock subclass for the first lock obtained
+ * @subclass2: inode lock subclass for the second lock obtained
+ */
+void lock_two_inodes(struct inode *inode1, struct inode *inode2,
+		     unsigned subclass1, unsigned subclass2)
+{
+	if (!inode1 || !inode2) {
+		/*
+		 * Make sure @subclass1 will be used for the acquired lock.
+		 * This is not strictly necessary (no current caller cares) but
+		 * let's keep things consistent.
+		 */
+		if (!inode1)
+			swap(inode1, inode2);
+		goto lock;
+	}
+
+	/*
+	 * If one object is directory and the other is not, we must make sure
+	 * to lock directory first as the other object may be its child.
+	 */
+	if (S_ISDIR(inode2->i_mode) == S_ISDIR(inode1->i_mode)) {
+		if (inode1 > inode2)
+			swap(inode1, inode2);
+	} else if (!S_ISDIR(inode1->i_mode))
+		swap(inode1, inode2);
+lock:
+	if (inode1)
+		inode_lock_nested(inode1, subclass1);
+	if (inode2 && inode2 != inode1)
+		inode_lock_nested(inode2, subclass2);
+}
+
+/**
  * lock_two_nondirectories - take two i_mutexes on non-directory objects
  *
  * Lock any non-NULL argument that is not a directory.
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -152,6 +152,8 @@ extern long prune_icache_sb(struct super
 int dentry_needs_remove_privs(struct mnt_idmap *, struct dentry *dentry);
 bool in_group_or_capable(struct mnt_idmap *idmap,
 			 const struct inode *inode, vfsgid_t vfsgid);
+void lock_two_inodes(struct inode *inode1, struct inode *inode2,
+		     unsigned subclass1, unsigned subclass2);
 
 /*
  * fs-writeback.c
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3028,8 +3028,8 @@ static struct dentry *lock_two_directori
 		return p;
 	}
 
-	inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
-	inode_lock_nested(p2->d_inode, I_MUTEX_PARENT2);
+	lock_two_inodes(p1->d_inode, p2->d_inode,
+			I_MUTEX_PARENT, I_MUTEX_PARENT2);
 	return NULL;
 }
 


