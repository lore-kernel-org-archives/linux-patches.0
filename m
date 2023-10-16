Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8EF262AC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub6fz68D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F480C433C7;
	Mon, 16 Oct 2023 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468244;
	bh=YMXf3pFZhiMsBtlqZ91xu5947x1ZZtujvpgNkOQ3/vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ub6fz68D89J6jj1P1koiTFNXWVeOg6t9Z3VdZ8bpYzHqrOKa4P2V2w3kdSxXhwJ6N
	 Bp9+L8dgu8ChGc0eQnb6HEPxY44sCIocIM3sARKJtPusLA2Cc6Q3fco/fYcg73xbQ8
	 I3MXQ4vVGYSmfSFnajGJ2JEIs2KMhUbDDk2aVmLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 189/191] ovl: make use of ->layers safe in rcu pathwalk
Date: Mon, 16 Oct 2023 10:42:54 +0200
Message-ID: <20231016084019.782186516@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit a535116d80339dbfe50b9b81b2f808c69eefbbc3 ]

ovl_permission() accesses ->layers[...].mnt; we can't have ->layers
freed without an RCU delay on fs shutdown.

Fortunately, kern_unmount_array() that is used to drop those mounts
does include an RCU delay, so freeing is delayed; unfortunately, the
array passed to kern_unmount_array() is formed by mangling ->layers
contents and that happens without any delays.

The ->layers[...].name string entries are used to store the strings to
display in "lowerdir=..." by ovl_show_options().  Those entries are not
accessed in RCU walk.

Move the name strings into a separate array ofs->config.lowerdirs and
reuse the ofs->config.lowerdirs array as the temporary mount array to
pass to kern_unmount_array().

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20231002023711.GP3389589@ZenIV/
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Stable-dep-of: 32db51070850 ("ovl: fix regression in showing lowerdir mount option")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/ovl_entry.h | 10 +---------
 fs/overlayfs/params.c    | 17 +++++++++--------
 fs/overlayfs/super.c     | 18 +++++++++++-------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 306e1ecdc96d3..2b703521871ea 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -8,6 +8,7 @@
 struct ovl_config {
 	char *upperdir;
 	char *workdir;
+	char **lowerdirs;
 	bool default_permissions;
 	int redirect_mode;
 	bool index;
@@ -38,17 +39,8 @@ struct ovl_layer {
 	int idx;
 	/* One fsid per unique underlying sb (upper fsid == 0) */
 	int fsid;
-	char *name;
 };
 
-/*
- * ovl_free_fs() relies on @mnt being the first member when unmounting
- * the private mounts created for each layer. Let's check both the
- * offset and type.
- */
-static_assert(offsetof(struct ovl_layer, mnt) == 0);
-static_assert(__same_type(typeof_member(struct ovl_layer, mnt), struct vfsmount *));
-
 struct ovl_path {
 	const struct ovl_layer *layer;
 	struct dentry *dentry;
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c0f70af422d6c..e6edad7542e88 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -695,12 +695,12 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
 
-	/* Hack!  Reuse ofs->layers as a vfsmount array before freeing it */
-	mounts = (struct vfsmount **) ofs->layers;
+	/* Reuse ofs->config.lowerdirs as a vfsmount array before freeing it */
+	mounts = (struct vfsmount **) ofs->config.lowerdirs;
 	for (i = 0; i < ofs->numlayer; i++) {
 		iput(ofs->layers[i].trap);
+		kfree(ofs->config.lowerdirs[i]);
 		mounts[i] = ofs->layers[i].mnt;
-		kfree(ofs->layers[i].name);
 	}
 	kern_unmount_array(mounts, ofs->numlayer);
 	kfree(ofs->layers);
@@ -708,6 +708,7 @@ void ovl_free_fs(struct ovl_fs *ofs)
 		free_anon_bdev(ofs->fs[i].pseudo_dev);
 	kfree(ofs->fs);
 
+	kfree(ofs->config.lowerdirs);
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
 	if (ofs->creator_cred)
@@ -857,16 +858,16 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = sb->s_fs_info;
 	size_t nr, nr_merged_lower = ofs->numlayer - ofs->numdatalayer;
-	const struct ovl_layer *data_layers = &ofs->layers[nr_merged_lower];
+	char **lowerdatadirs = &ofs->config.lowerdirs[nr_merged_lower];
 
-	/* ofs->layers[0] is the upper layer */
-	seq_printf(m, ",lowerdir=%s", ofs->layers[1].name);
+	/* lowerdirs[] starts from offset 1 */
+	seq_printf(m, ",lowerdir=%s", ofs->config.lowerdirs[1]);
 	/* dump regular lower layers */
 	for (nr = 2; nr < nr_merged_lower; nr++)
-		seq_printf(m, ":%s", ofs->layers[nr].name);
+		seq_printf(m, ":%s", ofs->config.lowerdirs[nr]);
 	/* dump data lower layers */
 	for (nr = 0; nr < ofs->numdatalayer; nr++)
-		seq_printf(m, "::%s", data_layers[nr].name);
+		seq_printf(m, "::%s", lowerdatadirs[nr]);
 	if (ofs->config.upperdir) {
 		seq_show_option(m, "upperdir", ofs->config.upperdir);
 		seq_show_option(m, "workdir", ofs->config.workdir);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1090c68e5b051..80a70eaa30d90 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -565,11 +565,6 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	upper_layer->idx = 0;
 	upper_layer->fsid = 0;
 
-	err = -ENOMEM;
-	upper_layer->name = kstrdup(ofs->config.upperdir, GFP_KERNEL);
-	if (!upper_layer->name)
-		goto out;
-
 	/*
 	 * Inherit SB_NOSEC flag from upperdir.
 	 *
@@ -1113,7 +1108,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		layers[ofs->numlayer].idx = ofs->numlayer;
 		layers[ofs->numlayer].fsid = fsid;
 		layers[ofs->numlayer].fs = &ofs->fs[fsid];
-		layers[ofs->numlayer].name = l->name;
+		/* Store for printing lowerdir=... in ovl_show_options() */
+		ofs->config.lowerdirs[ofs->numlayer] = l->name;
 		l->name = NULL;
 		ofs->numlayer++;
 		ofs->fs[fsid].is_lower = true;
@@ -1358,8 +1354,16 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!layers)
 		goto out_err;
 
+	ofs->config.lowerdirs = kcalloc(ctx->nr + 1, sizeof(char *), GFP_KERNEL);
+	if (!ofs->config.lowerdirs) {
+		kfree(layers);
+		goto out_err;
+	}
 	ofs->layers = layers;
-	/* Layer 0 is reserved for upper even if there's no upper */
+	/*
+	 * Layer 0 is reserved for upper even if there's no upper.
+	 * For consistency, config.lowerdirs[0] is NULL.
+	 */
 	ofs->numlayer = 1;
 
 	sb->s_stack_depth = 0;
-- 
2.40.1



