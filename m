Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7B13BF31F;
	Thu, 15 Jan 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499266; cv=none; b=TbKHSAHGYOpcutHi+KK1onJ54C0xrwdyyg6LhASbVyx17EM7/kQFLSBltMGdyjnRJGNXABv2y4HBJ72EEAEvyHb4bmvHU2dU46rNb1a0C2SwKSLNQwPrgpltcrDlZZt6kdVy7eLRa0T2CQHUrnqsOxOvooDAdHG2tLiUStu77O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499266; c=relaxed/simple;
	bh=dwa7LE273k7A+baGXux/kDx1aIH7TDQRxUbQ2geALW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW9sNXjVEMt5jUlrLYcCtGaLL3W5jZiaiu7SXwSWM7pDL+rxVa3uLs/Og3nXqjINK4c2pRM39xIrp8dwjiP8TMCT6tMHVxWLa9sffdAfr77cPJ0/qeqDO6+4b8pMlGw+BE4nfYz+XHJH/uuEOtK919sOGOazlCl7aYJw+z79PJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxnZgGiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxnZgGiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA42C116D0;
	Thu, 15 Jan 2026 17:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499265;
	bh=dwa7LE273k7A+baGXux/kDx1aIH7TDQRxUbQ2geALW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxnZgGiAd6s8W9JKd0X6hOglAVLjeKxO/VcL4LWQxQ+tGup+Rq6mzKyZf1+9QVCCU
	 PsKH3JQM1e+mk+7y/UzkIEQWZINki4CLTRRgaovlKYs7uGvJbNSxUYftMPJ5FhRnYT
	 +6IDpBJWv7Qg6UtLfypwfH6vRalvPDQjvmgWwm5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/451] NFS: dont unhash dentry during unlink/rename
Date: Thu, 15 Jan 2026 17:45:24 +0100
Message-ID: <20260115164235.372390370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 3c59366c207e4c6c6569524af606baf017a55c61 ]

NFS unlink() (and rename over existing target) must determine if the
file is open, and must perform a "silly rename" instead of an unlink (or
before rename) if it is.  Otherwise the client might hold a file open
which has been removed on the server.

Consequently if it determines that the file isn't open, it must block
any subsequent opens until the unlink/rename has been completed on the
server.

This is currently achieved by unhashing the dentry.  This forces any
open attempt to the slow-path for lookup which will block on i_rwsem on
the directory until the unlink/rename completes.  A future patch will
change the VFS to only get a shared lock on i_rwsem for unlink, so this
will no longer work.

Instead we introduce an explicit interlock.  A special value is stored
in dentry->d_fsdata while the unlink/rename is running and
->d_revalidate blocks while that value is present.  When ->d_revalidate
unblocks, the dentry will be invalid.  This closes the race
without requiring exclusion on i_rwsem.

d_fsdata is already used in two different ways.
1/ an IS_ROOT directory dentry might have a "devname" stored in
   d_fsdata.  Such a dentry doesn't have a name and so cannot be the
   target of unlink or rename.  For safety we check if an old devname
   is still stored, and remove it if it is.
2/ a dentry with DCACHE_NFSFS_RENAMED set will have a 'struct
   nfs_unlinkdata' stored in d_fsdata.  While this is set maydelete()
   will fail, so an unlink or rename will never proceed on such
   a dentry.

Neither of these can be in effect when a dentry is the target of unlink
or rename.  So we can expect d_fsdata to be NULL, and store a special
value ((void*)1) which is given the name NFS_FSDATA_BLOCKED to indicate
that any lookup will be blocked.

The d_count() is incremented under d_lock() when a lookup finds the
dentry, so we check d_count() is low, and set NFS_FSDATA_BLOCKED under
the same lock to avoid any races.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: bd4928ec799b ("NFS: Avoid changing nlink when file removes and attribute updates race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c           | 72 +++++++++++++++++++++++++++++++-----------
 include/linux/nfs_fs.h |  9 ++++++
 2 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 442e9835d5a3f..6dc3dcf23550d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1411,6 +1411,8 @@ __nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags,
 	int ret;
 
 	if (flags & LOOKUP_RCU) {
+		if (dentry->d_fsdata == NFS_FSDATA_BLOCKED)
+			return -ECHILD;
 		parent = READ_ONCE(dentry->d_parent);
 		dir = d_inode_rcu(parent);
 		if (!dir)
@@ -1419,6 +1421,9 @@ __nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags,
 		if (parent != READ_ONCE(dentry->d_parent))
 			return -ECHILD;
 	} else {
+		/* Wait for unlink to complete */
+		wait_var_event(&dentry->d_fsdata,
+			       dentry->d_fsdata != NFS_FSDATA_BLOCKED);
 		parent = dget_parent(dentry);
 		ret = reval(d_inode(parent), dentry, flags);
 		dput(parent);
@@ -2079,7 +2084,6 @@ static int nfs_safe_remove(struct dentry *dentry)
 int nfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error;
-	int need_rehash = 0;
 
 	dfprintk(VFS, "NFS: unlink(%s/%lu, %pd)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry);
@@ -2093,15 +2097,25 @@ int nfs_unlink(struct inode *dir, struct dentry *dentry)
 		error = nfs_sillyrename(dir, dentry);
 		goto out;
 	}
-	if (!d_unhashed(dentry)) {
-		__d_drop(dentry);
-		need_rehash = 1;
-	}
+	/* We must prevent any concurrent open until the unlink
+	 * completes.  ->d_revalidate will wait for ->d_fsdata
+	 * to clear.  We set it here to ensure no lookup succeeds until
+	 * the unlink is complete on the server.
+	 */
+	error = -ETXTBSY;
+	if (WARN_ON(dentry->d_flags & DCACHE_NFSFS_RENAMED) ||
+	    WARN_ON(dentry->d_fsdata == NFS_FSDATA_BLOCKED))
+		goto out;
+	if (dentry->d_fsdata)
+		/* old devname */
+		kfree(dentry->d_fsdata);
+	dentry->d_fsdata = NFS_FSDATA_BLOCKED;
+
 	spin_unlock(&dentry->d_lock);
 	error = nfs_safe_remove(dentry);
 	nfs_dentry_remove_handle_error(dir, dentry, error);
-	if (need_rehash)
-		d_rehash(dentry);
+	dentry->d_fsdata = NULL;
+	wake_up_var(&dentry->d_fsdata);
 out:
 	trace_nfs_unlink_exit(dir, dentry, error);
 	return error;
@@ -2204,6 +2218,15 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(nfs_link);
 
+static void
+nfs_unblock_rename(struct rpc_task *task, struct nfs_renamedata *data)
+{
+	struct dentry *new_dentry = data->new_dentry;
+
+	new_dentry->d_fsdata = NULL;
+	wake_up_var(&new_dentry->d_fsdata);
+}
+
 /*
  * RENAME
  * FIXME: Some nfsds, like the Linux user space nfsd, may generate a
@@ -2234,8 +2257,9 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
-	struct dentry *dentry = NULL, *rehash = NULL;
+	struct dentry *dentry = NULL;
 	struct rpc_task *task;
+	bool must_unblock = false;
 	int error = -EBUSY;
 
 	if (flags)
@@ -2253,18 +2277,27 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * the new target.
 	 */
 	if (new_inode && !S_ISDIR(new_inode->i_mode)) {
-		/*
-		 * To prevent any new references to the target during the
-		 * rename, we unhash the dentry in advance.
+		/* We must prevent any concurrent open until the unlink
+		 * completes.  ->d_revalidate will wait for ->d_fsdata
+		 * to clear.  We set it here to ensure no lookup succeeds until
+		 * the unlink is complete on the server.
 		 */
-		if (!d_unhashed(new_dentry)) {
-			d_drop(new_dentry);
-			rehash = new_dentry;
+		error = -ETXTBSY;
+		if (WARN_ON(new_dentry->d_flags & DCACHE_NFSFS_RENAMED) ||
+		    WARN_ON(new_dentry->d_fsdata == NFS_FSDATA_BLOCKED))
+			goto out;
+		if (new_dentry->d_fsdata) {
+			/* old devname */
+			kfree(new_dentry->d_fsdata);
+			new_dentry->d_fsdata = NULL;
 		}
 
+		spin_lock(&new_dentry->d_lock);
 		if (d_count(new_dentry) > 2) {
 			int err;
 
+			spin_unlock(&new_dentry->d_lock);
+
 			/* copy the target dentry's name */
 			dentry = d_alloc(new_dentry->d_parent,
 					 &new_dentry->d_name);
@@ -2277,14 +2310,19 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto out;
 
 			new_dentry = dentry;
-			rehash = NULL;
 			new_inode = NULL;
+		} else {
+			new_dentry->d_fsdata = NFS_FSDATA_BLOCKED;
+			must_unblock = true;
+			spin_unlock(&new_dentry->d_lock);
 		}
+
 	}
 
 	if (S_ISREG(old_inode->i_mode))
 		nfs_sync_inode(old_inode);
-	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry, NULL);
+	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry,
+				must_unblock ? nfs_unblock_rename : NULL);
 	if (IS_ERR(task)) {
 		error = PTR_ERR(task);
 		goto out;
@@ -2308,8 +2346,6 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		spin_unlock(&old_inode->i_lock);
 	}
 out:
-	if (rehash)
-		d_rehash(rehash);
 	trace_nfs_rename_exit(old_dir, old_dentry,
 			new_dir, new_dentry, error);
 	if (!error) {
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 7488864589a7a..8d4f019b7af8e 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -591,6 +591,15 @@ nfs_fileid_to_ino_t(u64 fileid)
 
 #define NFS_JUKEBOX_RETRY_TIME (5 * HZ)
 
+/* We need to block new opens while a file is being unlinked.
+ * If it is opened *before* we decide to unlink, we will silly-rename
+ * instead. If it is opened *after*, then we need to create or will fail.
+ * If we allow the two to race, we could end up with a file that is open
+ * but deleted on the server resulting in ESTALE.
+ * So use ->d_fsdata to record when the unlink is happening
+ * and block dentry revalidation while it is set.
+ */
+#define NFS_FSDATA_BLOCKED ((void*)1)
 
 # undef ifdebug
 # ifdef NFS_DEBUG
-- 
2.51.0



