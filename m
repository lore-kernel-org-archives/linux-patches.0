Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B991487EA;
	Tue, 23 Jan 2024 01:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972082; cv=none; b=RwDED+tRLl9YmpPRRmtOhkTUKtOfbGfNW0jtMqNQ63HYFMAVgAWkpVRPOio9HyC9UQP3rpBarVpyjOsf0N70k8FBetmqCvgWmjuhWdOMj4s+sdfHh0/LRrbthpuiX2GY7U1BIz/zvAL1ld9yiXZqqVSiNemk3ifSXiinFEhCg/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972082; c=relaxed/simple;
	bh=bJbid+rd9vrP9AXncu/tl+9gK85nbedBJsSC6e/o2Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNNlzkNwLOzpWvWue3Kp+Eg1xGaWDqRYmovQk2vFrGd/LfXXDFAJQJrhthI2rsij+vpGDyw9Ji7wdB+t9jmI/u/LIwHT5k+vUyfTuC+3mIMNxOVN0GW5LwoGunMetnD4wUc1e9pklJNOti2AUUuw23DarG3tj6l/Y3MO8M9dZws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWjjrLug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWjjrLug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7910C43390;
	Tue, 23 Jan 2024 01:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972081;
	bh=bJbid+rd9vrP9AXncu/tl+9gK85nbedBJsSC6e/o2Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWjjrLug0RDOlV3oDVCFQVl6W7KzJBd2g9Lp4j8bYM3nbMahXSDcUYDVGOkdpaxw+
	 kjgBrApkGLxCKUInKChdJEugxgY/OkJOysO1ul1DTupRRkFP1QT+ejpjOPPBLcuphy
	 MEXuEdCRe6YL9An0pm9qaRtiP66GxLK9pYWq2zio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/374] debugfs: fix automount d_fsdata usage
Date: Mon, 22 Jan 2024 15:54:22 -0800
Message-ID: <20240122235744.846569148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0ed04a1847a10297595ac24dc7d46b35fb35f90a ]

debugfs_create_automount() stores a function pointer in d_fsdata,
but since commit 7c8d469877b1 ("debugfs: add support for more
elaborate ->d_fsdata") debugfs_release_dentry() will free it, now
conditionally on DEBUGFS_FSDATA_IS_REAL_FOPS_BIT, but that's not
set for the function pointer in automount. As a result, removing
an automount dentry would attempt to free the function pointer.
Luckily, the only user of this (tracing) never removes it.

Nevertheless, it's safer if we just handle the fsdata in one way,
namely either DEBUGFS_FSDATA_IS_REAL_FOPS_BIT or allocated. Thus,
change the automount to allocate it, and use the real_fops in the
data to indicate whether or not automount is filled, rather than
adding a type tag. At least for now this isn't actually needed,
but the next changes will require it.

Also check in debugfs_file_get() that it gets only called
on regular files, just to make things clearer.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c     |  8 ++++++++
 fs/debugfs/inode.c    | 27 ++++++++++++++++++++-------
 fs/debugfs/internal.h | 10 ++++++++--
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 38930d9b0bb7..df5c2162e729 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -84,6 +84,14 @@ int debugfs_file_get(struct dentry *dentry)
 	struct debugfs_fsdata *fsd;
 	void *d_fsd;
 
+	/*
+	 * This could only happen if some debugfs user erroneously calls
+	 * debugfs_file_get() on a dentry that isn't even a file, let
+	 * them know about it.
+	 */
+	if (WARN_ON(!d_is_reg(dentry)))
+		return -EINVAL;
+
 	d_fsd = READ_ONCE(dentry->d_fsdata);
 	if (!((unsigned long)d_fsd & DEBUGFS_FSDATA_IS_REAL_FOPS_BIT)) {
 		fsd = d_fsd;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 26f9cd328291..5290a721a703 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -214,17 +214,19 @@ static const struct super_operations debugfs_super_operations = {
 
 static void debugfs_release_dentry(struct dentry *dentry)
 {
-	void *fsd = dentry->d_fsdata;
+	struct debugfs_fsdata *fsd = dentry->d_fsdata;
 
-	if (!((unsigned long)fsd & DEBUGFS_FSDATA_IS_REAL_FOPS_BIT))
-		kfree(dentry->d_fsdata);
+	if ((unsigned long)fsd & DEBUGFS_FSDATA_IS_REAL_FOPS_BIT)
+		return;
+
+	kfree(fsd);
 }
 
 static struct vfsmount *debugfs_automount(struct path *path)
 {
-	debugfs_automount_t f;
-	f = (debugfs_automount_t)path->dentry->d_fsdata;
-	return f(path->dentry, d_inode(path->dentry)->i_private);
+	struct debugfs_fsdata *fsd = path->dentry->d_fsdata;
+
+	return fsd->automount(path->dentry, d_inode(path->dentry)->i_private);
 }
 
 static const struct dentry_operations debugfs_dops = {
@@ -602,13 +604,23 @@ struct dentry *debugfs_create_automount(const char *name,
 					void *data)
 {
 	struct dentry *dentry = start_creating(name, parent);
+	struct debugfs_fsdata *fsd;
 	struct inode *inode;
 
 	if (IS_ERR(dentry))
 		return dentry;
 
+	fsd = kzalloc(sizeof(*fsd), GFP_KERNEL);
+	if (!fsd) {
+		failed_creating(dentry);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fsd->automount = f;
+
 	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
 		failed_creating(dentry);
+		kfree(fsd);
 		return ERR_PTR(-EPERM);
 	}
 
@@ -616,13 +628,14 @@ struct dentry *debugfs_create_automount(const char *name,
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create automount '%s'\n",
 		       name);
+		kfree(fsd);
 		return failed_creating(dentry);
 	}
 
 	make_empty_dir_inode(inode);
 	inode->i_flags |= S_AUTOMOUNT;
 	inode->i_private = data;
-	dentry->d_fsdata = (void *)f;
+	dentry->d_fsdata = fsd;
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_instantiate(dentry, inode);
diff --git a/fs/debugfs/internal.h b/fs/debugfs/internal.h
index 92af8ae31313..f7c489b5a368 100644
--- a/fs/debugfs/internal.h
+++ b/fs/debugfs/internal.h
@@ -17,8 +17,14 @@ extern const struct file_operations debugfs_full_proxy_file_operations;
 
 struct debugfs_fsdata {
 	const struct file_operations *real_fops;
-	refcount_t active_users;
-	struct completion active_users_drained;
+	union {
+		/* automount_fn is used when real_fops is NULL */
+		debugfs_automount_t automount;
+		struct {
+			refcount_t active_users;
+			struct completion active_users_drained;
+		};
+	};
 };
 
 /*
-- 
2.43.0



