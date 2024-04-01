Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397501CA8F;
	Mon,  1 Apr 2024 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988380; cv=none; b=nXUAjAm4SlkrD3ZzTuSrc5DKlrgVXqgobN2g+ppo+9LGWpGO6wK4LKZkLXyHoGX+WlIEHwDpHY/6HqS4DaGSlUT7MC5CRJm10HAbiieH//pRbVV3ea/9GoTf/ntP8lfVKWvmBdwiGK8jLCGfNy9gsIR/tBoscF6a2SaZi+TsCYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988380; c=relaxed/simple;
	bh=Lm5Z/uZV0sNEo+uQZVe+KKTPlC6wPwkkW37WSniPxC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO8quHbKaIWTQPWDCXNTe0Cf82/zvW0dX/vvpuERck+MtlMpVmCpsJVfOAAG9viszjSGE0OEC4e/gRJw34rJuAQ3pJng+n2CXB0ym+0sO8stIgy32uwKtd71ijeuqcVVdkt7SCaVyuURaSqZTRL392k5DeWXmtAFcXspani0jwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3oA/ddG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3oA/ddG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984EAC433C7;
	Mon,  1 Apr 2024 16:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988380;
	bh=Lm5Z/uZV0sNEo+uQZVe+KKTPlC6wPwkkW37WSniPxC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3oA/ddG6/JxvcnMrf9jPo8082PQAlW5j4lSjz1YZSic0NKDhas7HEL2CWgRtjGET
	 sKjH0SNwqIfjVz2v0AskspppB3yxZbbBG8SP446AnntCMW0cVSKOgQXtJITbbOLmvU
	 hd0rROqxbFnP/nsJ9Dnn/19gkueh98ZtcPpDyxwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 139/432] smb: client: stop revalidating reparse points unnecessarily
Date: Mon,  1 Apr 2024 17:42:06 +0200
Message-ID: <20240401152557.284728513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 6d039984c15d1ea1ca080176df6dfab443e44585 ]

Query dir responses don't provide enough information on reparse points
such as major/minor numbers and symlink targets other than reparse
tags, however we don't need to unconditionally revalidate them only
because they are reparse points.  Instead, revalidate them only when
their ctime or reparse tag has changed.

For instance, Windows Server updates ctime of reparse points when
their data have changed.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: e4b61f3b1c67 ("cifs: prevent updating file size from server if we have a read/write lease")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |   1 +
 fs/smb/client/inode.c    |   4 +-
 fs/smb/client/readdir.c  | 133 ++++++++++++++++-----------------------
 3 files changed, 57 insertions(+), 81 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 462554917e5a1..57bf6b406c590 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1562,6 +1562,7 @@ struct cifsInodeInfo {
 	spinlock_t deferred_lock; /* protection on deferred list */
 	bool lease_granted; /* Flag to indicate whether lease or oplock is granted. */
 	char *symlink_target;
+	__u32 reparse_tag;
 };
 
 static inline struct cifsInodeInfo *
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eb54e48937771..471abc99bbf02 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -182,6 +182,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 		inode->i_mode = fattr->cf_mode;
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
+	cifs_i->reparse_tag = fattr->cf_cifstag;
 
 	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
 		cifs_i->time = 0;
@@ -209,7 +210,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 		inode->i_blocks = (512 - 1 + fattr->cf_bytes) >> 9;
 	}
 
-	if (S_ISLNK(fattr->cf_mode)) {
+	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
 		kfree(cifs_i->symlink_target);
 		cifs_i->symlink_target = fattr->cf_symlink_target;
 		fattr->cf_symlink_target = NULL;
@@ -1103,6 +1104,7 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 
 	cifs_open_info_to_fattr(fattr, data, sb);
 out:
+	fattr->cf_cifstag = data->reparse.tag;
 	free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
 	return rc;
 }
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index e23cd216bffbe..520c490e844b5 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -55,6 +55,23 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
 }
 #endif /* DEBUG2 */
 
+/*
+ * Match a reparse point inode if reparse tag and ctime haven't changed.
+ *
+ * Windows Server updates ctime of reparse points when their data have changed.
+ * The server doesn't allow changing reparse tags from existing reparse points,
+ * though it's worth checking.
+ */
+static inline bool reparse_inode_match(struct inode *inode,
+				       struct cifs_fattr *fattr)
+{
+	struct timespec64 ctime = inode_get_ctime(inode);
+
+	return (CIFS_I(inode)->cifsAttrs & ATTR_REPARSE) &&
+		CIFS_I(inode)->reparse_tag == fattr->cf_cifstag &&
+		timespec64_equal(&ctime, &fattr->cf_ctime);
+}
+
 /*
  * Attempt to preload the dcache with the results from the FIND_FIRST/NEXT
  *
@@ -71,6 +88,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	struct super_block *sb = parent->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
+	int rc;
 
 	cifs_dbg(FYI, "%s: for %s\n", __func__, name->name);
 
@@ -82,9 +100,11 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 		 * We'll end up doing an on the wire call either way and
 		 * this spares us an invalidation.
 		 */
-		if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
-			return;
 retry:
+		if ((fattr->cf_cifsattrs & ATTR_REPARSE) ||
+		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
+			return;
+
 		dentry = d_alloc_parallel(parent, name, &wq);
 	}
 	if (IS_ERR(dentry))
@@ -104,12 +124,34 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
 				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
 
-			/* update inode in place
-			 * if both i_ino and i_mode didn't change */
-			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid &&
-			    cifs_fattr_to_inode(inode, fattr) == 0) {
-				dput(dentry);
-				return;
+			/*
+			 * Update inode in place if both i_ino and i_mode didn't
+			 * change.
+			 */
+			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+				/*
+				 * Query dir responses don't provide enough
+				 * information about reparse points other than
+				 * their reparse tags.  Save an invalidation by
+				 * not clobbering the existing mode, size and
+				 * symlink target (if any) when reparse tag and
+				 * ctime haven't changed.
+				 */
+				rc = 0;
+				if (fattr->cf_cifsattrs & ATTR_REPARSE) {
+					if (likely(reparse_inode_match(inode, fattr))) {
+						fattr->cf_mode = inode->i_mode;
+						fattr->cf_eof = CIFS_I(inode)->server_eof;
+						fattr->cf_symlink_target = NULL;
+					} else {
+						CIFS_I(inode)->time = 0;
+						rc = -ESTALE;
+					}
+				}
+				if (!rc && !cifs_fattr_to_inode(inode, fattr)) {
+					dput(dentry);
+					return;
+				}
 			}
 		}
 		d_invalidate(dentry);
@@ -127,29 +169,6 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	dput(dentry);
 }
 
-static bool reparse_file_needs_reval(const struct cifs_fattr *fattr)
-{
-	if (!(fattr->cf_cifsattrs & ATTR_REPARSE))
-		return false;
-	/*
-	 * The DFS tags should be only intepreted by server side as per
-	 * MS-FSCC 2.1.2.1, but let's include them anyway.
-	 *
-	 * Besides, if cf_cifstag is unset (0), then we still need it to be
-	 * revalidated to know exactly what reparse point it is.
-	 */
-	switch (fattr->cf_cifstag) {
-	case IO_REPARSE_TAG_DFS:
-	case IO_REPARSE_TAG_DFSR:
-	case IO_REPARSE_TAG_SYMLINK:
-	case IO_REPARSE_TAG_NFS:
-	case IO_REPARSE_TAG_MOUNT_POINT:
-	case 0:
-		return true;
-	}
-	return false;
-}
-
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
@@ -181,14 +200,6 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	}
 
 out_reparse:
-	/*
-	 * We need to revalidate it further to make a decision about whether it
-	 * is a symbolic link, DFS referral or a reparse point with a direct
-	 * access like junctions, deduplicated files, NFS symlinks.
-	 */
-	if (reparse_file_needs_reval(fattr))
-		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
-
 	/* non-unix readdir doesn't provide nlink */
 	fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
 
@@ -269,9 +280,6 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		fattr->cf_dtype = DT_REG;
 	}
 
-	if (reparse_file_needs_reval(fattr))
-		fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
-
 	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
 	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
 }
@@ -333,38 +341,6 @@ cifs_std_info_to_fattr(struct cifs_fattr *fattr, FIND_FILE_STANDARD_INFO *info,
 	cifs_fill_common_info(fattr, cifs_sb);
 }
 
-/* BB eventually need to add the following helper function to
-      resolve NT_STATUS_STOPPED_ON_SYMLINK return code when
-      we try to do FindFirst on (NTFS) directory symlinks */
-/*
-int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
-			     unsigned int xid)
-{
-	__u16 fid;
-	int len;
-	int oplock = 0;
-	int rc;
-	struct cifs_tcon *ptcon = cifs_sb_tcon(cifs_sb);
-	char *tmpbuffer;
-
-	rc = CIFSSMBOpen(xid, ptcon, full_path, FILE_OPEN, GENERIC_READ,
-			OPEN_REPARSE_POINT, &fid, &oplock, NULL,
-			cifs_sb->local_nls,
-			cifs_remap(cifs_sb);
-	if (!rc) {
-		tmpbuffer = kmalloc(maxpath);
-		rc = CIFSSMBQueryReparseLinkInfo(xid, ptcon, full_path,
-				tmpbuffer,
-				maxpath -1,
-				fid,
-				cifs_sb->local_nls);
-		if (CIFSSMBClose(xid, ptcon, fid)) {
-			cifs_dbg(FYI, "Error closing temporary reparsepoint open\n");
-		}
-	}
-}
- */
-
 static int
 _initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
@@ -433,13 +409,10 @@ _initiate_cifs_search(const unsigned int xid, struct file *file,
 					  &cifsFile->fid, search_flags,
 					  &cifsFile->srch_inf);
 
-	if (rc == 0)
+	if (rc == 0) {
 		cifsFile->invalidHandle = false;
-	/* BB add following call to handle readdir on new NTFS symlink errors
-	else if STATUS_STOPPED_ON_SYMLINK
-		call get_symlink_reparse_path and retry with new path */
-	else if ((rc == -EOPNOTSUPP) &&
-		(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+	} else if ((rc == -EOPNOTSUPP) &&
+		   (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
 		goto ffirst_retry;
 	}
-- 
2.43.0



