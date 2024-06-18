Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF61214036D;
	Tue, 18 Jun 2024 12:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714829; cv=none; b=hBV2piZOadQlkSjbr0pywu3QoOaNr6/JE5zLTNgcG0JUBhRqKSqGgQ4PM61rmODNK1IjFpJLRC7sI0HC4cqjaqzzMBk9lD7UfLl+XWs45RYL34o7lyXmjlGGM1mBAGIZD/NSb1XoMigZ/IDWukaI28ocCVFjn+cP6tZvOqwxe6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714829; c=relaxed/simple;
	bh=0pdBdYwBZnv/eoGckB4xV0ywv7CWj++dN4SovR+Whms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etO4ws0AvsdSfNV/YKtUGGA01MFU3cwZelm9pjvu3yzFE1dQU1nNCWxxphilXPgTI2PS05YNmt+uAIv85zEjVy5fvD8FmxzEkbdm25dckEWENC/4RaQ8gHE7/ePYaIlB29qFv3CDzKSSc+tkfInH8eALurILot/UTYba1eYrDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkymLEQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkymLEQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61524C3277B;
	Tue, 18 Jun 2024 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714828;
	bh=0pdBdYwBZnv/eoGckB4xV0ywv7CWj++dN4SovR+Whms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkymLEQ0DPxOjs699lpxnzRpOuICAUR0o22aylGyI3JzYXA7+pNnWHBmWddZUTXxz
	 Mr56puOFjAqo8aE1q4ZXwmPPtTMZzvt2xN+QqOBFwhWMppt43/F1hWyU5MqSLu6PCS
	 T+LtiYUBVt/pqUQ4A8VPKOf5f5R2odkJFRQE2Q8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/770] nfsd: close cached files prior to a REMOVE or RENAME that would replace target
Date: Tue, 18 Jun 2024 14:29:14 +0200
Message-ID: <20240618123411.174863543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit 7f84b488f9add1d5cca3e6197c95914c7bd3c1cf ]

It's not uncommon for some workloads to do a bunch of I/O to a file and
delete it just afterward. If knfsd has a cached open file however, then
the file may still be open when the dentry is unlinked. If the
underlying filesystem is nfs, then that could trigger it to do a
sillyrename.

On a REMOVE or RENAME scan the nfsd_file cache for open files that
correspond to the inode, and proactively unhash and put their
references. This should prevent any delete-on-last-close activity from
occurring, solely due to knfsd's open file cache.

This must be done synchronously though so we use the variants that call
flush_delayed_fput. There are deadlock possibilities if you call
flush_delayed_fput while holding locks, however. In the case of
nfsd_rename, we don't even do the lookups of the dentries to be renamed
until we've locked for rename.

Once we've figured out what the target dentry is for a rename, check to
see whether there are cached open files associated with it. If there
are, then unwind all of the locking, close them all, and then reattempt
the rename.

None of this is really necessary for "typical" filesystems though. It's
mostly of use for NFS, so declare a new export op flag and use that to
determine whether to close the files beforehand.

Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[ cel: adjusted to apply to 5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/nfs/exporting.rst | 13 +++++++++++++
 fs/nfs/export.c                             |  2 +-
 fs/nfsd/vfs.c                               | 16 +++++++++-------
 include/linux/exportfs.h                    |  5 +++--
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index 960be64446cb9..0e98edd353b5f 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -202,3 +202,16 @@ following flags are defined:
     This flag exempts the filesystem from subtree checking and causes
     exportfs to get back an error if it tries to enable subtree checking
     on it.
+
+  EXPORT_OP_CLOSE_BEFORE_UNLINK - always close cached files before unlinking
+    On some exportable filesystems (such as NFS) unlinking a file that
+    is still open can cause a fair bit of extra work. For instance,
+    the NFS client will do a "sillyrename" to ensure that the file
+    sticks around while it's still open. When reexporting, that open
+    file is held by nfsd so we usually end up doing a sillyrename, and
+    then immediately deleting the sillyrenamed file just afterward when
+    the link count actually goes to zero. Sometimes this delete can race
+    with other operations (for instance an rmdir of the parent directory).
+    This flag causes nfsd to close any open files for this inode _before_
+    calling into the vfs to do an unlink or a rename that would replace
+    an existing file.
diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index b9ba306bf9120..5428713af5fee 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -171,5 +171,5 @@ const struct export_operations nfs_export_ops = {
 	.encode_fh = nfs_encode_fh,
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
-	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK,
+	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|EXPORT_OP_CLOSE_BEFORE_UNLINK,
 };
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 31edb883afd0d..fb4e6c57ce0bb 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1739,7 +1739,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	struct inode	*fdir, *tdir;
 	__be32		err;
 	int		host_err;
-	bool		has_cached = false;
+	bool		close_cached = false;
 
 	err = fh_verify(rqstp, ffhp, S_IFDIR, NFSD_MAY_REMOVE);
 	if (err)
@@ -1798,8 +1798,9 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	if (ndentry == trap)
 		goto out_dput_new;
 
-	if (nfsd_has_cached_files(ndentry)) {
-		has_cached = true;
+	if ((ndentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK) &&
+	    nfsd_has_cached_files(ndentry)) {
+		close_cached = true;
 		goto out_dput_old;
 	} else {
 		host_err = vfs_rename(fdir, odentry, tdir, ndentry, NULL, 0);
@@ -1820,7 +1821,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	 * as that would do the wrong thing if the two directories
 	 * were the same, so again we do it by hand.
 	 */
-	if (!has_cached) {
+	if (!close_cached) {
 		fill_post_wcc(ffhp);
 		fill_post_wcc(tfhp);
 	}
@@ -1834,8 +1835,8 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	 * shouldn't be done with locks held however, so we delay it until this
 	 * point and then reattempt the whole shebang.
 	 */
-	if (has_cached) {
-		has_cached = false;
+	if (close_cached) {
+		close_cached = false;
 		nfsd_close_cached_files(ndentry);
 		dput(ndentry);
 		goto retry;
@@ -1887,7 +1888,8 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 		type = d_inode(rdentry)->i_mode & S_IFMT;
 
 	if (type != S_IFDIR) {
-		nfsd_close_cached_files(rdentry);
+		if (rdentry->d_sb->s_export_op->flags & EXPORT_OP_CLOSE_BEFORE_UNLINK)
+			nfsd_close_cached_files(rdentry);
 		host_err = vfs_unlink(dirp, rdentry, NULL);
 	} else {
 		host_err = vfs_rmdir(dirp, rdentry);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 2fcbab0f6b612..d829403ffd3bb 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -213,8 +213,9 @@ struct export_operations {
 			  bool write, u32 *device_generation);
 	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
 			     int nr_iomaps, struct iattr *iattr);
-#define	EXPORT_OP_NOWCC		(0x1)	/* Don't collect wcc data for NFSv3 replies */
-#define	EXPORT_OP_NOSUBTREECHK	(0x2)	/* Subtree checking is not supported! */
+#define	EXPORT_OP_NOWCC			(0x1) /* don't collect v3 wcc data */
+#define	EXPORT_OP_NOSUBTREECHK		(0x2) /* no subtree checking */
+#define	EXPORT_OP_CLOSE_BEFORE_UNLINK	(0x4) /* close files before unlink */
 	unsigned long	flags;
 };
 
-- 
2.43.0



