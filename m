Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D45582871;
	Wed, 19 Jun 2024 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802305; cv=none; b=dVjUCvvA9LIeY4KGmz2hxdGnXvpdwxwMuBnePwA93/NjNKjwae/qbdd2GTH1S3LPDXTQTzy8K2VwBo+bYiE7hpFMVoGtOJDFPk+P/FGYdsVAPoSdGQmIXxR/Ui1vgZLjJ2S9o62bdpdo0nTa/8S/3qdsNN604gbBinoE8A5RJLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802305; c=relaxed/simple;
	bh=XePicmrYM5/dSFzJW5YIrwWXatPo1ymt8oACSCjqglc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqXOEMGIqZEXTLJRzGg1+bIzGbmhhAbujHuqjnTdODFKx2R17w3VUAka4ljR/uFUfIkU8dXEqYLPmTLR/wgQc07ygauA9JWIYgX7acI2a2em9SuNuAWGFiB6FWJzfskbvPG7srGk5gjQHC97Wflb685ZT9C8bhqglETLTq/Wkvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyZXKtCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyZXKtCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A80C2BBFC;
	Wed, 19 Jun 2024 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802305;
	bh=XePicmrYM5/dSFzJW5YIrwWXatPo1ymt8oACSCjqglc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyZXKtCIToDiRBWITkJHHytO0HBKcZ89/UCPqZIj7crRrwDqCeFxMsNPuvse6UXH4
	 woyu3fBPs+4lwTrsbcNXqRvzFfFtYB7KFK2uPurATscUU2IUC0e4dfzntiXYugpUh6
	 KdV7MZIA8rkNBNtt9urU92gM6ehqNBQqmS9LjKYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	Richard Kojedzinszky <richard+debian+bugreport@kojedz.in>
Subject: [PATCH 6.6 120/267] NFS: add barriers when testing for NFS_FSDATA_BLOCKED
Date: Wed, 19 Jun 2024 14:54:31 +0200
Message-ID: <20240619125610.955147634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 99bc9f2eb3f79a2b4296d9bf43153e1d10ca50d3 ]

dentry->d_fsdata is set to NFS_FSDATA_BLOCKED while unlinking or
renaming-over a file to ensure that no open succeeds while the NFS
operation progressed on the server.

Setting dentry->d_fsdata to NFS_FSDATA_BLOCKED is done under ->d_lock
after checking the refcount is not elevated.  Any attempt to open the
file (through that name) will go through lookp_open() which will take
->d_lock while incrementing the refcount, we can be sure that once the
new value is set, __nfs_lookup_revalidate() *will* see the new value and
will block.

We don't have any locking guarantee that when we set ->d_fsdata to NULL,
the wait_var_event() in __nfs_lookup_revalidate() will notice.
wait/wake primitives do NOT provide barriers to guarantee order.  We
must use smp_load_acquire() in wait_var_event() to ensure we look at an
up-to-date value, and must use smp_store_release() before wake_up_var().

This patch adds those barrier functions and factors out
block_revalidate() and unblock_revalidate() far clarity.

There is also a hypothetical bug in that if memory allocation fails
(which never happens in practice) we might leave ->d_fsdata locked.
This patch adds the missing call to unblock_revalidate().

Reported-and-tested-by: Richard Kojedzinszky <richard+debian+bugreport@kojedz.in>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1071501
Fixes: 3c59366c207e ("NFS: don't unhash dentry during unlink/rename")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 9fc5061d51b2f..2a0f069d5a096 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1802,9 +1802,10 @@ __nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags,
 		if (parent != READ_ONCE(dentry->d_parent))
 			return -ECHILD;
 	} else {
-		/* Wait for unlink to complete */
+		/* Wait for unlink to complete - see unblock_revalidate() */
 		wait_var_event(&dentry->d_fsdata,
-			       dentry->d_fsdata != NFS_FSDATA_BLOCKED);
+			       smp_load_acquire(&dentry->d_fsdata)
+			       != NFS_FSDATA_BLOCKED);
 		parent = dget_parent(dentry);
 		ret = reval(d_inode(parent), dentry, flags);
 		dput(parent);
@@ -1817,6 +1818,29 @@ static int nfs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 	return __nfs_lookup_revalidate(dentry, flags, nfs_do_lookup_revalidate);
 }
 
+static void block_revalidate(struct dentry *dentry)
+{
+	/* old devname - just in case */
+	kfree(dentry->d_fsdata);
+
+	/* Any new reference that could lead to an open
+	 * will take ->d_lock in lookup_open() -> d_lookup().
+	 * Holding this lock ensures we cannot race with
+	 * __nfs_lookup_revalidate() and removes and need
+	 * for further barriers.
+	 */
+	lockdep_assert_held(&dentry->d_lock);
+
+	dentry->d_fsdata = NFS_FSDATA_BLOCKED;
+}
+
+static void unblock_revalidate(struct dentry *dentry)
+{
+	/* store_release ensures wait_var_event() sees the update */
+	smp_store_release(&dentry->d_fsdata, NULL);
+	wake_up_var(&dentry->d_fsdata);
+}
+
 /*
  * A weaker form of d_revalidate for revalidating just the d_inode(dentry)
  * when we don't really care about the dentry name. This is called when a
@@ -2499,15 +2523,12 @@ int nfs_unlink(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dentry->d_lock);
 		goto out;
 	}
-	/* old devname */
-	kfree(dentry->d_fsdata);
-	dentry->d_fsdata = NFS_FSDATA_BLOCKED;
+	block_revalidate(dentry);
 
 	spin_unlock(&dentry->d_lock);
 	error = nfs_safe_remove(dentry);
 	nfs_dentry_remove_handle_error(dir, dentry, error);
-	dentry->d_fsdata = NULL;
-	wake_up_var(&dentry->d_fsdata);
+	unblock_revalidate(dentry);
 out:
 	trace_nfs_unlink_exit(dir, dentry, error);
 	return error;
@@ -2619,8 +2640,7 @@ nfs_unblock_rename(struct rpc_task *task, struct nfs_renamedata *data)
 {
 	struct dentry *new_dentry = data->new_dentry;
 
-	new_dentry->d_fsdata = NULL;
-	wake_up_var(&new_dentry->d_fsdata);
+	unblock_revalidate(new_dentry);
 }
 
 /*
@@ -2682,11 +2702,6 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		if (WARN_ON(new_dentry->d_flags & DCACHE_NFSFS_RENAMED) ||
 		    WARN_ON(new_dentry->d_fsdata == NFS_FSDATA_BLOCKED))
 			goto out;
-		if (new_dentry->d_fsdata) {
-			/* old devname */
-			kfree(new_dentry->d_fsdata);
-			new_dentry->d_fsdata = NULL;
-		}
 
 		spin_lock(&new_dentry->d_lock);
 		if (d_count(new_dentry) > 2) {
@@ -2708,7 +2723,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			new_dentry = dentry;
 			new_inode = NULL;
 		} else {
-			new_dentry->d_fsdata = NFS_FSDATA_BLOCKED;
+			block_revalidate(new_dentry);
 			must_unblock = true;
 			spin_unlock(&new_dentry->d_lock);
 		}
@@ -2720,6 +2735,8 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry,
 				must_unblock ? nfs_unblock_rename : NULL);
 	if (IS_ERR(task)) {
+		if (must_unblock)
+			unblock_revalidate(new_dentry);
 		error = PTR_ERR(task);
 		goto out;
 	}
-- 
2.43.0



