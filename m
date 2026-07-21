Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB5284662;
	Tue, 21 Jul 2026 19:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663206; cv=none; b=PhnMhuhrCzOK7sfIg+/eLbg9/s0hopQK1Tu1Yn04/zLILkEHx7Ek0aukjz9zDNaPX+dnxNshi32EpEWrgwX+X9xkZPoCC3ftUAPrYfEcof2XyQ+fMXvgfAjjIarA3cJVly55JQu6xpOHMZpOC2gkpdA/cgZJnk5Whtd6gvH+4Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663206; c=relaxed/simple;
	bh=buvTcD/RqIHtbAoTYko8svXvN+pyp4pRBiVwZle2Niw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB07dsTfd3mfino9ZxOZbU0MCBZdZ9NbbXP8m8Ksnf/brJ7YLar2xWv3JBMYiIx6rXUaxGeD3EA0Vwj8Y1mlZ81FXlJzG4GEczB2tyb0G6IVa4aWnTJ2i/A0ZPB2mLKEI05GTGvpgAxDl0Rtjh7ZeRkhGuxbFcf73zOzKMW7WFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEnJlsk0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEnJlsk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF26F1F000E9;
	Tue, 21 Jul 2026 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663205;
	bh=qiebxwnwGBE9qAhtixcCgOiDhLbtBI+6dUnzkQ0geI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEnJlsk0KCxUko0/fNpwekb4tv9o1Do3zvDf3s6sr4/5/z2WmeIt4Pn1oKZG/fhep
	 Q4iIYTIMwh6UO52j/Q1ZumJ8tr1igsqvYjTU/sfyV9Xvlk3gARECl//EQCskFynSS6
	 ++tFs8Mpp729IxibsGOIB6TRgELePLyM0AzdA0S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0733/1276] afs: Make /afs/@cell and /afs/.@cell symlinks
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152502.485728599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 30bca65bbbae13f32ee4f2897c55a496ea8132cf ]

Make /afs/@cell a symlink in the /afs dynamic root to match what other AFS
clients do rather than doing a substitution in the dentry name.  This has
the bonus of being tab-expandable also.

Further, provide a /afs/.@cell symlink to point to the dotted cell share.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20250107183454.608451-4-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: c9c3b615a462 ("afs: Fix misplaced inc of net->cells_outstanding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c           | 177 +++++++++++++++++++++++++++----------
 include/trace/events/afs.h |   2 +
 2 files changed, 131 insertions(+), 48 deletions(-)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index f80a4244b9d274..d8bf52f77d9302 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -185,50 +185,6 @@ struct inode *afs_try_auto_mntpt(struct dentry *dentry, struct inode *dir)
 	return ret == -ENOENT ? NULL : ERR_PTR(ret);
 }
 
-/*
- * Look up @cell in a dynroot directory.  This is a substitution for the
- * local cell name for the net namespace.
- */
-static struct dentry *afs_lookup_atcell(struct dentry *dentry)
-{
-	struct afs_cell *cell;
-	struct afs_net *net = afs_d2net(dentry);
-	struct dentry *ret;
-	char *name;
-	int len;
-
-	if (!net->ws_cell)
-		return ERR_PTR(-ENOENT);
-
-	ret = ERR_PTR(-ENOMEM);
-	name = kmalloc(AFS_MAXCELLNAME + 1, GFP_KERNEL);
-	if (!name)
-		goto out_p;
-
-	down_read(&net->cells_lock);
-	cell = net->ws_cell;
-	if (cell) {
-		len = cell->name_len;
-		memcpy(name, cell->name, len + 1);
-	}
-	up_read(&net->cells_lock);
-
-	ret = ERR_PTR(-ENOENT);
-	if (!cell)
-		goto out_n;
-
-	ret = lookup_one_len(name, dentry->d_parent, len);
-
-	/* We don't want to d_add() the @cell dentry here as we don't want to
-	 * the cached dentry to hide changes to the local cell name.
-	 */
-
-out_n:
-	kfree(name);
-out_p:
-	return ret;
-}
-
 /*
  * Look up an entry in a dynroot directory.
  */
@@ -247,10 +203,6 @@ static struct dentry *afs_dynroot_lookup(struct inode *dir, struct dentry *dentr
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
-	if (dentry->d_name.len == 5 &&
-	    memcmp(dentry->d_name.name, "@cell", 5) == 0)
-		return afs_lookup_atcell(dentry);
-
 	return d_splice_alias(afs_try_auto_mntpt(dentry, dir), dentry);
 }
 
@@ -343,6 +295,131 @@ void afs_dynroot_rmdir(struct afs_net *net, struct afs_cell *cell)
 	_leave("");
 }
 
+static void afs_atcell_delayed_put_cell(void *arg)
+{
+	struct afs_cell *cell = arg;
+
+	afs_put_cell(cell, afs_cell_trace_put_atcell);
+}
+
+/*
+ * Read @cell or .@cell symlinks.
+ */
+static const char *afs_atcell_get_link(struct dentry *dentry, struct inode *inode,
+				       struct delayed_call *done)
+{
+	struct afs_vnode *vnode = AFS_FS_I(inode);
+	struct afs_cell *cell;
+	struct afs_net *net = afs_i2net(inode);
+	const char *name;
+	bool dotted = vnode->fid.vnode == 3;
+
+	if (!net->ws_cell)
+		return ERR_PTR(-ENOENT);
+
+	down_read(&net->cells_lock);
+
+	cell = net->ws_cell;
+	if (dotted)
+		name = cell->name - 1;
+	else
+		name = cell->name;
+	afs_get_cell(cell, afs_cell_trace_get_atcell);
+	set_delayed_call(done, afs_atcell_delayed_put_cell, cell);
+
+	up_read(&net->cells_lock);
+	return name;
+}
+
+static const struct inode_operations afs_atcell_inode_operations = {
+	.get_link	= afs_atcell_get_link,
+};
+
+/*
+ * Look up @cell or .@cell in a dynroot directory.  This is a substitution for
+ * the local cell name for the net namespace.
+ */
+static struct dentry *afs_dynroot_create_symlink(struct dentry *root, const char *name)
+{
+	struct afs_vnode *vnode;
+	struct afs_fid fid = { .vnode = 2, .unique = 1, };
+	struct dentry *dentry;
+	struct inode *inode;
+
+	if (name[0] == '.')
+		fid.vnode = 3;
+
+	dentry = d_alloc_name(root, name);
+	if (!dentry)
+		return ERR_PTR(-ENOMEM);
+
+	inode = iget5_locked(dentry->d_sb, fid.vnode,
+			     afs_iget5_pseudo_test, afs_iget5_pseudo_set, &fid);
+	if (!inode) {
+		dput(dentry);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	vnode = AFS_FS_I(inode);
+
+	/* there shouldn't be an existing inode */
+	if (WARN_ON_ONCE(!(inode->i_state & I_NEW))) {
+		iput(inode);
+		dput(dentry);
+		return ERR_PTR(-EIO);
+	}
+
+	netfs_inode_init(&vnode->netfs, NULL, false);
+	simple_inode_init_ts(inode);
+	set_nlink(inode, 1);
+	inode->i_size		= 0;
+	inode->i_mode		= S_IFLNK | 0555;
+	inode->i_op		= &afs_atcell_inode_operations;
+	inode->i_uid		= GLOBAL_ROOT_UID;
+	inode->i_gid		= GLOBAL_ROOT_GID;
+	inode->i_blocks		= 0;
+	inode->i_generation	= 0;
+	inode->i_flags		|= S_NOATIME;
+
+	unlock_new_inode(inode);
+	d_splice_alias(inode, dentry);
+	return dentry;
+}
+
+/*
+ * Create @cell and .@cell symlinks.
+ */
+static int afs_dynroot_symlink(struct afs_net *net)
+{
+	struct super_block *sb = net->dynroot_sb;
+	struct dentry *root, *symlink, *dsymlink;
+	int ret;
+
+	/* Let the ->lookup op do the creation */
+	root = sb->s_root;
+	inode_lock(root->d_inode);
+	symlink = afs_dynroot_create_symlink(root, "@cell");
+	if (IS_ERR(symlink)) {
+		ret = PTR_ERR(symlink);
+		goto unlock;
+	}
+
+	dsymlink = afs_dynroot_create_symlink(root, ".@cell");
+	if (IS_ERR(dsymlink)) {
+		ret = PTR_ERR(dsymlink);
+		dput(symlink);
+		goto unlock;
+	}
+
+	/* Note that we're retaining extra refs on the dentries. */
+	symlink->d_fsdata = (void *)1UL;
+	dsymlink->d_fsdata = (void *)1UL;
+	ret = 0;
+unlock:
+	inode_unlock(root->d_inode);
+	return ret;
+}
+
 /*
  * Populate a newly created dynamic root with cell names.
  */
@@ -355,6 +432,10 @@ int afs_dynroot_populate(struct super_block *sb)
 	mutex_lock(&net->proc_cells_lock);
 
 	net->dynroot_sb = sb;
+	ret = afs_dynroot_symlink(net);
+	if (ret < 0)
+		goto error;
+
 	hlist_for_each_entry(cell, &net->proc_cells, proc_link) {
 		ret = afs_dynroot_mkdir(net, cell);
 		if (ret < 0)
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 3dddfc6abf0ee3..27bac4d5ac906e 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -170,6 +170,7 @@ enum yfs_cm_operation {
 #define afs_cell_traces \
 	EM(afs_cell_trace_alloc,		"ALLOC     ") \
 	EM(afs_cell_trace_free,			"FREE      ") \
+	EM(afs_cell_trace_get_atcell,		"GET atcell") \
 	EM(afs_cell_trace_get_queue_dns,	"GET q-dns ") \
 	EM(afs_cell_trace_get_queue_manage,	"GET q-mng ") \
 	EM(afs_cell_trace_get_queue_new,	"GET q-new ") \
@@ -177,6 +178,7 @@ enum yfs_cm_operation {
 	EM(afs_cell_trace_get_vol,		"GET vol   ") \
 	EM(afs_cell_trace_insert,		"INSERT    ") \
 	EM(afs_cell_trace_manage,		"MANAGE    ") \
+	EM(afs_cell_trace_put_atcell,		"PUT atcell") \
 	EM(afs_cell_trace_put_candidate,	"PUT candid") \
 	EM(afs_cell_trace_put_destroy,		"PUT destry") \
 	EM(afs_cell_trace_put_queue_work,	"PUT q-work") \
-- 
2.53.0



