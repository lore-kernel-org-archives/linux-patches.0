Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D503EA83;
	Mon,  1 Apr 2024 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986967; cv=none; b=rRtJYiem7H4D4DELrbNp0sftvWhdHAABT5t4Iz+cdlZnnFl5YyH3aPiuJh7P0loZnA3o3NO/50C2uWOWvfhjg/6EeESwu34IVNIeJKtmOi6uxU+eobcxqNjw9lYVyWOZuJI9dyIOdvUBDb6jmP6fZfwrWsGVfH8aZQFsI7DTqJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986967; c=relaxed/simple;
	bh=7CrXSmawSnWNn3bWcDbZ3k/oReDowz/WDLAcx6kaTIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhStIgQKEVXTA4hUPL/fqYEG5LVM9xV266wZi/9OdgkXtt/Cim4d7Xem3JzKI2IL0ZT+YlGpq1RxColCGnu1fmeJnwiYLYoJfVWdH23ZHnhmtYiAa4zF+Rt0/Yn24UkN0IR9U0Vb9q6dDNHEpYyM2YcfsVZ1wEy+OZ4WKgqlPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi4X3xw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi4X3xw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46192C43390;
	Mon,  1 Apr 2024 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986967;
	bh=7CrXSmawSnWNn3bWcDbZ3k/oReDowz/WDLAcx6kaTIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi4X3xw0x5Jbahpe6foIm8naADJQjySJQtxt3+7JOTg6xr2DZPTsylZriwOT+DkBE
	 LL8i2yS8qGgNbtsBeCxvlA6O3qbjn4ZmkwvU5GmcDdEt0rBnmx+2lhH1CHOySNG1BG
	 FPsHFc4zRcr/2idbOWNJGk4+KVAz/WkqYelBqm1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 143/399] cifs: prevent updating file size from server if we have a read/write lease
Date: Mon,  1 Apr 2024 17:41:49 +0200
Message-ID: <20240401152553.460426700@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit e4b61f3b1c67f5068590965f64ea6e8d5d5bd961 ]

In cases of large directories, the readdir operation may span multiple
round trips to retrieve contents. This introduces a potential race
condition in case of concurrent write and readdir operations. If the
readdir operation initiates before a write has been processed by the
server, it may update the file size attribute to an older value.
Address this issue by avoiding file size updates from readdir when we
have read/write lease.

Scenario:
1) process1: open dir xyz
2) process1: readdir instance 1 on xyz
3) process2: create file.txt for write
4) process2: write x bytes to file.txt
5) process2: close file.txt
6) process2: open file.txt for read
7) process1: readdir 2 - overwrites file.txt inode size to 0
8) process2: read contents of file.txt - bug, short read with 0 bytes

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  6 ++++--
 fs/smb/client/file.c      |  8 +++++---
 fs/smb/client/inode.c     | 13 +++++++------
 fs/smb/client/readdir.c   |  2 +-
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index a841bf4967fa4..58cfbd450a55e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -144,7 +144,8 @@ extern int cifs_reconnect(struct TCP_Server_Info *server,
 extern int checkSMB(char *buf, unsigned int len, struct TCP_Server_Info *srvr);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
-extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
+extern bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 eof,
+				   bool from_readdir);
 extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 			    unsigned int bytes_written);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
@@ -201,7 +202,8 @@ extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 				     struct cifs_sb_info *cifs_sb);
 extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
 					struct cifs_sb_info *);
-extern int cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
+extern int cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
+			       bool from_readdir);
 extern struct inode *cifs_iget(struct super_block *sb,
 			       struct cifs_fattr *fattr);
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 98514f2f2d7b1..9d42a39009076 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -329,7 +329,7 @@ int cifs_posix_open(const char *full_path, struct inode **pinode,
 		}
 	} else {
 		cifs_revalidate_mapping(*pinode);
-		rc = cifs_fattr_to_inode(*pinode, &fattr);
+		rc = cifs_fattr_to_inode(*pinode, &fattr, false);
 	}
 
 posix_open_ret:
@@ -4769,12 +4769,14 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
    refreshing the inode only on increases in the file size
    but this is tricky to do without racing with writebehind
    page caching in the current Linux kernel design */
-bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
+bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
+			    bool from_readdir)
 {
 	if (!cifsInode)
 		return true;
 
-	if (is_inode_writable(cifsInode)) {
+	if (is_inode_writable(cifsInode) ||
+		((cifsInode->oplock & CIFS_CACHE_RW_FLG) != 0 && from_readdir)) {
 		/* This inode is open for write at least once */
 		struct cifs_sb_info *cifs_sb;
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d02f8ba29cb5b..7f28edf4b20f3 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -147,7 +147,8 @@ cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 /* populate an inode with info from a cifs_fattr struct */
 int
-cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
+cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
+		    bool from_readdir)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -199,7 +200,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	 * Can't safely change the file size here if the client is writing to
 	 * it due to potential races.
 	 */
-	if (is_size_safe_to_change(cifs_i, fattr->cf_eof)) {
+	if (is_size_safe_to_change(cifs_i, fattr->cf_eof, from_readdir)) {
 		i_size_write(inode, fattr->cf_eof);
 
 		/*
@@ -368,7 +369,7 @@ static int update_inode_info(struct super_block *sb,
 		CIFS_I(*inode)->time = 0; /* force reval */
 		return -ESTALE;
 	}
-	return cifs_fattr_to_inode(*inode, fattr);
+	return cifs_fattr_to_inode(*inode, fattr, false);
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
@@ -403,7 +404,7 @@ cifs_get_file_info_unix(struct file *filp)
 	} else
 		goto cifs_gfiunix_out;
 
-	rc = cifs_fattr_to_inode(inode, &fattr);
+	rc = cifs_fattr_to_inode(inode, &fattr, false);
 
 cifs_gfiunix_out:
 	free_xid(xid);
@@ -934,7 +935,7 @@ cifs_get_file_info(struct file *filp)
 	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
 	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 	/* if filetype is different, return error */
-	rc = cifs_fattr_to_inode(inode, &fattr);
+	rc = cifs_fattr_to_inode(inode, &fattr, false);
 cgfi_exit:
 	cifs_free_open_info(&data);
 	free_xid(xid);
@@ -1491,7 +1492,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 		}
 
 		/* can't fail - see cifs_find_inode() */
-		cifs_fattr_to_inode(inode, fattr);
+		cifs_fattr_to_inode(inode, fattr, false);
 		if (sb->s_flags & SB_NOATIME)
 			inode->i_flags |= S_NOATIME | S_NOCMTIME;
 		if (inode->i_state & I_NEW) {
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index b520eea7bfce8..132ae7d884a97 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -148,7 +148,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 						rc = -ESTALE;
 					}
 				}
-				if (!rc && !cifs_fattr_to_inode(inode, fattr)) {
+				if (!rc && !cifs_fattr_to_inode(inode, fattr, true)) {
 					dput(dentry);
 					return;
 				}
-- 
2.43.0



