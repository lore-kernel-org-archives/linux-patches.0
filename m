Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DB614830E;
	Thu, 23 May 2024 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470712; cv=none; b=khg/0lqvIUGrvhdWqSWb4WFnRlK+cMIZHdWNZ804i5LaAhbk9fgZnK75P/t4BInuqurhzjcE1gZGhA+V4zRER1+QMH3idz5iJ1Nxqmfumc4DgoWLg4zZ3TsB3R9lPI6/GAK8b6B4ZdzZFWBrWuQxXunaNoRdiF8ben5neIRWI5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470712; c=relaxed/simple;
	bh=F9dtzP/r3st81qFFtCURqOvKhIPyQtAcXLuSY03mWWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O91cnry1qmog4GuYHhRBufk1NpfFAwH85KTnc3SUxJfyTkyPgWX3psZHzLwtE58Cb/XwMNUobrrQiMhhG9r8654kkHKsXn9VMWoDlGNyRQQNWT8Iu0snqlszb+Y4vs1FfLwXI0iDqggWCpBBNTA3Wgdw9h5UEllGd/g5NN98OHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLwiBm4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLwiBm4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72368C4AF08;
	Thu, 23 May 2024 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470711;
	bh=F9dtzP/r3st81qFFtCURqOvKhIPyQtAcXLuSY03mWWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLwiBm4gSpowH7uZhUgY82iLlPtDfO11LK9x/zKCSMZGqPoZxDTNq36th1LV+mwnU
	 FesMsoWE3pax5OHt+wWqQkNjqDSMQyFdeYiwycqijplhiV+ZJpmaveHcL5uLK0iMJp
	 fBsedKva83f/tm1McpxO4nBpx+vDq/VM3YBysHB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/102] cifs: fixes for get_inode_info
Date: Thu, 23 May 2024 15:13:27 +0200
Message-ID: <20240523130344.810106341@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Meetakshi Setiya <msetiya@microsoft.com>

[ Upstream commit fc20c523211a38b87fc850a959cb2149e4fd64b0 ]

Fix potential memory leaks, add error checking, remove unnecessary
initialisation of status_file_deleted and do not use cifs_iget() to get
inode in reparse_info_to_fattr since fattrs may not be fully set.

Fixes: ffceb7640cbf ("smb: client: do not defer close open handles to deleted files")
Reported-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c  |  1 -
 fs/smb/client/inode.c | 24 +++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 6dc2e8db9c8ed..7ea8c3cf70f6c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -501,7 +501,6 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	cfile->uid = current_fsuid();
 	cfile->dentry = dget(dentry);
 	cfile->f_flags = file->f_flags;
-	cfile->status_file_deleted = false;
 	cfile->invalidHandle = false;
 	cfile->deferred_close_scheduled = false;
 	cfile->tlink = cifs_get_tlink(tlink);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 67bc1a1e54fde..67ad8eeaa7665 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -820,8 +820,10 @@ cifs_get_file_info(struct file *filp)
 	void *page = alloc_dentry_path();
 	const unsigned char *path;
 
-	if (!server->ops->query_file_info)
+	if (!server->ops->query_file_info) {
+		free_dentry_path(page);
 		return -ENOSYS;
+	}
 
 	xid = get_xid();
 	rc = server->ops->query_file_info(xid, tcon, cfile, &data);
@@ -835,8 +837,8 @@ cifs_get_file_info(struct file *filp)
 		}
 		path = build_path_from_dentry(dentry, page);
 		if (IS_ERR(path)) {
-			free_dentry_path(page);
-			return PTR_ERR(path);
+			rc = PTR_ERR(path);
+			goto cgfi_exit;
 		}
 		cifs_open_info_to_fattr(&fattr, &data, inode->i_sb);
 		if (fattr.cf_flags & CIFS_FATTR_DELETE_PENDING)
@@ -1009,7 +1011,6 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 	struct kvec rsp_iov, *iov = NULL;
 	int rsp_buftype = CIFS_NO_BUFFER;
 	u32 tag = data->reparse.tag;
-	struct inode *inode = NULL;
 	int rc = 0;
 
 	if (!tag && server->ops->query_reparse_point) {
@@ -1049,12 +1050,8 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 
 	if (tcon->posix_extensions)
 		smb311_posix_info_to_fattr(fattr, data, sb);
-	else {
+	else
 		cifs_open_info_to_fattr(fattr, data, sb);
-		inode = cifs_iget(sb, fattr);
-		if (inode && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
-			cifs_mark_open_handles_for_deleted_file(inode, full_path);
-	}
 out:
 	fattr->cf_cifstag = data->reparse.tag;
 	free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
@@ -1109,9 +1106,9 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 						   full_path, fattr);
 		} else {
 			cifs_open_info_to_fattr(fattr, data, sb);
-			if (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
-				cifs_mark_open_handles_for_deleted_file(*inode, full_path);
 		}
+		if (!rc && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
+			cifs_mark_open_handles_for_deleted_file(*inode, full_path);
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
@@ -1340,6 +1337,8 @@ int smb311_posix_get_inode_info(struct inode **inode,
 		goto out;
 
 	rc = update_inode_info(sb, &fattr, inode);
+	if (!rc && fattr.cf_flags & CIFS_FATTR_DELETE_PENDING)
+		cifs_mark_open_handles_for_deleted_file(*inode, full_path);
 out:
 	kfree(fattr.cf_symlink_target);
 	return rc;
@@ -1503,6 +1502,9 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		goto out;
 	}
 
+	if (!rc && fattr.cf_flags & CIFS_FATTR_DELETE_PENDING)
+		cifs_mark_open_handles_for_deleted_file(inode, path);
+
 	if (rc && tcon->pipe) {
 		cifs_dbg(FYI, "ipc connection - fake read inode\n");
 		spin_lock(&inode->i_lock);
-- 
2.43.0



