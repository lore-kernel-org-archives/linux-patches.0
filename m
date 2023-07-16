Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF58F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6C0C433C7;
	Sun, 16 Jul 2023 20:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540982;
	bh=EI6wO8giUQQhQh4W06TpXwyA+1EUB0MmphoebsFXEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWxxUq/3O9Cto5BQq1onBwnGNsCy8QHaCkaPO8xIvFGa0iAoL8Ih4DB3aKkjwQuBi
	 ldDjv7HNt0QRdwaTcJco9NwH4YvzkX9lz3iAjCz8wNXpVOSQpJ4nbZ1bjoAuNidhps
	 VRsj3SHf8gkoVtL+/77vl1Ko3CTdj2rddpZ8x1CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 550/591] fs: Lock moved directories
Date: Sun, 16 Jul 2023 21:51:29 +0200
Message-ID: <20230716194938.086888916@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

commit 28eceeda130f5058074dd007d9c59d2e8bc5af2e upstream.

When a directory is moved to a different directory, some filesystems
(udf, ext4, ocfs2, f2fs, and likely gfs2, reiserfs, and others) need to
update their pointer to the parent and this must not race with other
operations on the directory. Lock the directories when they are moved.
Although not all filesystems need this locking, we perform it in
vfs_rename() because getting the lock ordering right is really difficult
and we don't want to expose these locking details to filesystems.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230601105830.13168-5-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/directory-locking.rst |   26 ++++++++++++------------
 fs/namei.c                                      |   22 ++++++++++++--------
 2 files changed, 28 insertions(+), 20 deletions(-)

--- a/Documentation/filesystems/directory-locking.rst
+++ b/Documentation/filesystems/directory-locking.rst
@@ -22,12 +22,11 @@ exclusive.
 3) object removal.  Locking rules: caller locks parent, finds victim,
 locks victim and calls the method.  Locks are exclusive.
 
-4) rename() that is _not_ cross-directory.  Locking rules: caller locks
-the parent and finds source and target.  In case of exchange (with
-RENAME_EXCHANGE in flags argument) lock both.  In any case,
-if the target already exists, lock it.  If the source is a non-directory,
-lock it.  If we need to lock both, lock them in inode pointer order.
-Then call the method.  All locks are exclusive.
+4) rename() that is _not_ cross-directory.  Locking rules: caller locks the
+parent and finds source and target.  We lock both (provided they exist).  If we
+need to lock two inodes of different type (dir vs non-dir), we lock directory
+first.  If we need to lock two inodes of the same type, lock them in inode
+pointer order.  Then call the method.  All locks are exclusive.
 NB: we might get away with locking the source (and target in exchange
 case) shared.
 
@@ -44,15 +43,17 @@ All locks are exclusive.
 rules:
 
 	* lock the filesystem
-	* lock parents in "ancestors first" order.
+	* lock parents in "ancestors first" order. If one is not ancestor of
+	  the other, lock them in inode pointer order.
 	* find source and target.
 	* if old parent is equal to or is a descendent of target
 	  fail with -ENOTEMPTY
 	* if new parent is equal to or is a descendent of source
 	  fail with -ELOOP
-	* If it's an exchange, lock both the source and the target.
-	* If the target exists, lock it.  If the source is a non-directory,
-	  lock it.  If we need to lock both, do so in inode pointer order.
+	* Lock both the source and the target provided they exist. If we
+	  need to lock two inodes of different type (dir vs non-dir), we lock
+	  the directory first. If we need to lock two inodes of the same type,
+	  lock them in inode pointer order.
 	* call the method.
 
 All ->i_rwsem are taken exclusive.  Again, we might get away with locking
@@ -66,8 +67,9 @@ If no directory is its own ancestor, the
 
 Proof:
 
-	First of all, at any moment we have a partial ordering of the
-	objects - A < B iff A is an ancestor of B.
+	First of all, at any moment we have a linear ordering of the
+	objects - A < B iff (A is an ancestor of B) or (B is not an ancestor
+        of A and ptr(A) < ptr(B)).
 
 	That ordering can change.  However, the following is true:
 
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4661,7 +4661,7 @@ SYSCALL_DEFINE2(link, const char __user
  *	   sb->s_vfs_rename_mutex. We might be more accurate, but that's another
  *	   story.
  *	c) we have to lock _four_ objects - parents and victim (if it exists),
- *	   and source (if it is not a directory).
+ *	   and source.
  *	   And that - after we got ->i_mutex on parents (until then we don't know
  *	   whether the target exists).  Solution: try to be smart with locking
  *	   order for inodes.  We rely on the fact that tree topology may change
@@ -4745,10 +4745,16 @@ int vfs_rename(struct renamedata *rd)
 
 	take_dentry_name_snapshot(&old_name, old_dentry);
 	dget(new_dentry);
-	if (!is_dir || (flags & RENAME_EXCHANGE))
-		lock_two_nondirectories(source, target);
-	else if (target)
-		inode_lock(target);
+	/*
+	 * Lock all moved children. Moved directories may need to change parent
+	 * pointer so they need the lock to prevent against concurrent
+	 * directory changes moving parent pointer. For regular files we've
+	 * historically always done this. The lockdep locking subclasses are
+	 * somewhat arbitrary but RENAME_EXCHANGE in particular can swap
+	 * regular files and directories so it's difficult to tell which
+	 * subclasses to use.
+	 */
+	lock_two_inodes(source, target, I_MUTEX_NORMAL, I_MUTEX_NONDIR2);
 
 	error = -EPERM;
 	if (IS_SWAPFILE(source) || (target && IS_SWAPFILE(target)))
@@ -4796,9 +4802,9 @@ int vfs_rename(struct renamedata *rd)
 			d_exchange(old_dentry, new_dentry);
 	}
 out:
-	if (!is_dir || (flags & RENAME_EXCHANGE))
-		unlock_two_nondirectories(source, target);
-	else if (target)
+	if (source)
+		inode_unlock(source);
+	if (target)
 		inode_unlock(target);
 	dput(new_dentry);
 	if (!error) {


