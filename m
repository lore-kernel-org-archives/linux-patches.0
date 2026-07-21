Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC48F2BEFF5;
	Tue, 21 Jul 2026 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667163; cv=none; b=ZrfqAWPk8/ODZNPECpONm3+q5KzJyAHwa4gtkLAkBXYeN8KCA5lKRKJSDJZpCKFFS6pV6HgYi8KE5yUfF2B0FLFYqvWN8QDrHBMUHeblRUcfhoxHJDDbZb1ftC51B64jHdd1oBb0OZrSdbvNlnf5XRNcRiTHbVi899Q/UGuLqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667163; c=relaxed/simple;
	bh=y1/Ujf0ccDNd2q9wb7J3cHB3IBuQZyfzoJLFKlukfyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWTh4ZBTXK6KEpPs9ElsWxuOJL3PXVU0Fo2OHKBcdxjuvhT+OWec25XJehJb3oHehG4pJtPB9lE7yNXmgflYxcVoe8cotzyKlqfHe6/jqSABVF3VQQsa0Bs9jVHefy/6JPUzjH8dhz4hMVsXy8luKCtSQiQNLP4Nv4n4Oq+dL6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjOP2ZMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjOP2ZMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAD21F000E9;
	Tue, 21 Jul 2026 20:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667162;
	bh=8J98D2CY/zNw9OLXvo00D/ELZYa/jeNIs39+S+9YdbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjOP2ZMRlcWPqaDnCg6jmmq4DlPDA8QB1xcKkkqGnko2zZaySnpHhlyIvdkmUWASW
	 5yYAyujsHdJaxMTKwU1sVNyn83xlmEYi/cfhE/RZYQCn8URa06H0CpwGs+mtKeQPol
	 6M4tTTI2qDASIhyFyv3HZF8pE0CzwiD6fSaSuXFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0956/1266] cifs: invalidate cfid on unlink/rename/rmdir
Date: Tue, 21 Jul 2026 17:23:13 +0200
Message-ID: <20260721152503.221002711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

commit f71d68d2b473e47db260c27c98212829590d8bae upstream.

Today we do not invalidate the cached_dirent or the entire
parent cfid when a dentry in a dir has been removed/moved.

This change invalidates the parent cfid so that we don't serve
directory contents from the cache.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -119,6 +119,23 @@ cifs_revalidate_cache(struct inode *inod
 	fscache_invalidate(cifs_inode_cookie(inode), &cd, i_size_read(inode), 0);
 }
 
+static void cifs_invalidate_cached_dir(struct cifs_tcon *tcon,
+				       struct dentry *parent)
+{
+	struct cached_fid *parent_cfid = NULL;
+
+	if (!tcon || !parent)
+		return;
+
+	if (!open_cached_dir_by_dentry(tcon, parent, &parent_cfid)) {
+		mutex_lock(&parent_cfid->dirents.de_mutex);
+		parent_cfid->dirents.is_valid = false;
+		parent_cfid->dirents.is_failed = true;
+		mutex_unlock(&parent_cfid->dirents.de_mutex);
+		close_cached_dir(parent_cfid);
+	}
+}
+
 /*
  * copy nlink to the inode, unless it wasn't provided.  Provide
  * sane values if we don't have an existing one and none was provided
@@ -1964,6 +1981,9 @@ psx_del_no_retry:
 		cifs_set_file_info(inode, attrs, xid, full_path, origattr);
 
 out_reval:
+	if (!rc && dentry->d_parent)
+		cifs_invalidate_cached_dir(tcon, dentry->d_parent);
+
 	if (inode) {
 		cifs_inode = CIFS_I(inode);
 		cifs_inode->time = 0;	/* will force revalidate to get info
@@ -2268,13 +2288,14 @@ int cifs_rmdir(struct inode *inode, stru
 	}
 
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
-	cifs_put_tlink(tlink);
 
 	if (!rc) {
 		spin_lock(&d_inode(direntry)->i_lock);
 		i_size_write(d_inode(direntry), 0);
 		clear_nlink(d_inode(direntry));
 		spin_unlock(&d_inode(direntry)->i_lock);
+		if (direntry->d_parent)
+			cifs_invalidate_cached_dir(tcon, direntry->d_parent);
 	}
 
 	cifsInode = CIFS_I(d_inode(direntry));
@@ -2290,6 +2311,7 @@ int cifs_rmdir(struct inode *inode, stru
 
 	inode_set_ctime_current(d_inode(direntry));
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	cifs_put_tlink(tlink);
 
 rmdir_exit:
 	free_dentry_path(page);
@@ -2512,6 +2534,12 @@ unlink_target:
 	}
 
 	/* force revalidate to go get info when needed */
+	if (!rc) {
+		cifs_invalidate_cached_dir(tcon, source_dentry->d_parent);
+		if (target_dentry->d_parent != source_dentry->d_parent)
+			cifs_invalidate_cached_dir(tcon, target_dentry->d_parent);
+	}
+
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:


