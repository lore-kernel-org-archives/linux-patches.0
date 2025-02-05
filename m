Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DDC7E792;
	Wed,  5 Feb 2025 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766299; cv=none; b=RzKCglCLZUbcGGk/yoUO38AitIh8DAaw2SX6x5zrk6cLzjjZ9/g4pev6/iMKZPGj7RbSe4sqoRBJLLPaY+N8oVvCBtb0RuNTb7XfB5JITl2cIw4KYHNOOihpXz2jJi2mShh9XoOG0nDQInN3KkteK9t6ZXiVu2VZqTo4MTmzPv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766299; c=relaxed/simple;
	bh=UW3Ojnb19xKcGDXAtImkX4jRAQduzDUCqTKk3yMcvX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/3HVb5Sq+pmmaWXlpBHLn1CjTRAGI5jBMO7Z+dDIoYwZKr6cK5ljLf2yyD+svLxV4529xPM4NDRCnYyZB2cYde8kwAFMUPHAS6eiYbt/a8ghUgJkh2AOQadryud9+AbhYTm0V4wLVobR2cTeUithMUgFEAS5HM+h5ILc/fVJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjZWZJtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjZWZJtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1236C4CED1;
	Wed,  5 Feb 2025 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766299;
	bh=UW3Ojnb19xKcGDXAtImkX4jRAQduzDUCqTKk3yMcvX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjZWZJtkPI/eFvozWr1GvTL6qdhdVAG6ybMrbDNYT3v7e3X1d4AD89jLAwapzNjnw
	 +HMG8ZrgI1YYEzFGj0mI6QvPBQ5YLyH3adCx5pWMg8zZAp8t4q0WCEmHePhBHLZRf3
	 L5zSnj8ikTbI/BMgJqNDy9TIna+tcFyGplrk/ob4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/393] hostfs: convert hostfs to use the new mount API
Date: Wed,  5 Feb 2025 14:44:29 +0100
Message-ID: <20250205134433.697634503@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit cd140ce9f611a5e9d2a5989a282b75e55c71dab3 ]

Convert the hostfs filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20240530120111.3794664-1-lihongbo22@huawei.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 60a600243244 ("hostfs: fix string handling in __dentry_name()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 83 ++++++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 21 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index ff201753fd181..1fb8eacb9817f 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -16,11 +16,16 @@
 #include <linux/seq_file.h>
 #include <linux/writeback.h>
 #include <linux/mount.h>
+#include <linux/fs_context.h>
 #include <linux/namei.h>
 #include "hostfs.h"
 #include <init.h>
 #include <kern.h>
 
+struct hostfs_fs_info {
+	char *host_root_path;
+};
+
 struct hostfs_inode_info {
 	int fd;
 	fmode_t mode;
@@ -90,8 +95,10 @@ static char *__dentry_name(struct dentry *dentry, char *name)
 	char *p = dentry_path_raw(dentry, name, PATH_MAX);
 	char *root;
 	size_t len;
+	struct hostfs_fs_info *fsi;
 
-	root = dentry->d_sb->s_fs_info;
+	fsi = dentry->d_sb->s_fs_info;
+	root = fsi->host_root_path;
 	len = strlen(root);
 	if (IS_ERR(p)) {
 		__putname(name);
@@ -196,8 +203,10 @@ static int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 	long long f_bavail;
 	long long f_files;
 	long long f_ffree;
+	struct hostfs_fs_info *fsi;
 
-	err = do_statfs(dentry->d_sb->s_fs_info,
+	fsi = dentry->d_sb->s_fs_info;
+	err = do_statfs(fsi->host_root_path,
 			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
 			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
 			&sf->f_namelen);
@@ -245,7 +254,11 @@ static void hostfs_free_inode(struct inode *inode)
 
 static int hostfs_show_options(struct seq_file *seq, struct dentry *root)
 {
-	const char *root_path = root->d_sb->s_fs_info;
+	struct hostfs_fs_info *fsi;
+	const char *root_path;
+
+	fsi = root->d_sb->s_fs_info;
+	root_path = fsi->host_root_path;
 	size_t offset = strlen(root_ino) + 1;
 
 	if (strlen(root_path) > offset)
@@ -924,10 +937,11 @@ static const struct inode_operations hostfs_link_iops = {
 	.get_link	= hostfs_get_link,
 };
 
-static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
+static int hostfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
+	struct hostfs_fs_info *fsi = sb->s_fs_info;
 	struct inode *root_inode;
-	char *host_root_path, *req_root = d;
+	char *host_root = fc->source;
 	int err;
 
 	sb->s_blocksize = 1024;
@@ -941,15 +955,15 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 		return err;
 
 	/* NULL is printed as '(null)' by printf(): avoid that. */
-	if (req_root == NULL)
-		req_root = "";
+	if (fc->source == NULL)
+		host_root = "";
 
-	sb->s_fs_info = host_root_path =
-		kasprintf(GFP_KERNEL, "%s/%s", root_ino, req_root);
-	if (host_root_path == NULL)
+	fsi->host_root_path =
+		kasprintf(GFP_KERNEL, "%s/%s", root_ino, host_root);
+	if (fsi->host_root_path == NULL)
 		return -ENOMEM;
 
-	root_inode = hostfs_iget(sb, host_root_path);
+	root_inode = hostfs_iget(sb, fsi->host_root_path);
 	if (IS_ERR(root_inode))
 		return PTR_ERR(root_inode);
 
@@ -957,7 +971,7 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 		char *name;
 
 		iput(root_inode);
-		name = follow_link(host_root_path);
+		name = follow_link(fsi->host_root_path);
 		if (IS_ERR(name))
 			return PTR_ERR(name);
 
@@ -974,11 +988,38 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	return 0;
 }
 
-static struct dentry *hostfs_read_sb(struct file_system_type *type,
-			  int flags, const char *dev_name,
-			  void *data)
+static int hostfs_fc_get_tree(struct fs_context *fc)
 {
-	return mount_nodev(type, flags, data, hostfs_fill_sb_common);
+	return get_tree_nodev(fc, hostfs_fill_super);
+}
+
+static void hostfs_fc_free(struct fs_context *fc)
+{
+	struct hostfs_fs_info *fsi = fc->s_fs_info;
+
+	if (!fsi)
+		return;
+
+	kfree(fsi->host_root_path);
+	kfree(fsi);
+}
+
+static const struct fs_context_operations hostfs_context_ops = {
+	.get_tree	= hostfs_fc_get_tree,
+	.free		= hostfs_fc_free,
+};
+
+static int hostfs_init_fs_context(struct fs_context *fc)
+{
+	struct hostfs_fs_info *fsi;
+
+	fsi = kzalloc(sizeof(*fsi), GFP_KERNEL);
+	if (!fsi)
+		return -ENOMEM;
+
+	fc->s_fs_info = fsi;
+	fc->ops = &hostfs_context_ops;
+	return 0;
 }
 
 static void hostfs_kill_sb(struct super_block *s)
@@ -988,11 +1029,11 @@ static void hostfs_kill_sb(struct super_block *s)
 }
 
 static struct file_system_type hostfs_type = {
-	.owner 		= THIS_MODULE,
-	.name 		= "hostfs",
-	.mount	 	= hostfs_read_sb,
-	.kill_sb	= hostfs_kill_sb,
-	.fs_flags 	= 0,
+	.owner			= THIS_MODULE,
+	.name			= "hostfs",
+	.init_fs_context	= hostfs_init_fs_context,
+	.kill_sb		= hostfs_kill_sb,
+	.fs_flags		= 0,
 };
 MODULE_ALIAS_FS("hostfs");
 
-- 
2.39.5



