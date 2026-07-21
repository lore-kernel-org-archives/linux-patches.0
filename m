Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD1356746;
	Tue, 21 Jul 2026 19:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663201; cv=none; b=VmCzeOQ1MN67jJ369h4Uv/ER3ih9lDsH1pDQE2jEhBZttNQYWZi+w+Ep9iTOF3BVxuOOiuN4tX7d5x/I0F+JG7LUPWrIXKYxg+SzzFImeuJym0lQ2xrYH9y0DtClC9difpT32Fz+dbTLpWiWEqQ2yujDL3Hif66cFUEtFmJzayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663201; c=relaxed/simple;
	bh=dmE2HoNe65/iTUL0zWH/aSvm7GXxlZ3mhYsTqOV2XFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYUaBg/Y0pKE+5Arim7uM9nm1f8MrIR9Zg04VeDqWwKYGxomf848Hv6ulf+/ctZ7atZjRrMSADMals2cuRQ3D6ByJwHrjm9ycZSNVd+jfqnOyPiNpV2iY7q90FeFg2Dc8qK15L7EoijLT+whWTdXHMuS2z3cflhgUVeJXGpK3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmjRi5a9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmjRi5a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9861F000E9;
	Tue, 21 Jul 2026 19:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663200;
	bh=UD642eOxxnzKmCV+PBX+uQ/4wJo8YYd7ZifcOsgT+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmjRi5a93musW9c2j8AckYvj0bBgvsJD5ZfqWY7T67Ot/QkM6365nj6gbMteeHYV4
	 x/+MRMExDAf9Xt3ipT7YmdQZ+kTX22zpnuY8k+2bKKpQ63rKpo8hfzk6xVx7TWNuJG
	 PDp8VEifJDrB7VXVKKLOaE6zOHn8TApngbsrXDbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0731/1276] afs: Make /afs/.<cell> as well as /afs/<cell> mountpoints
Date: Tue, 21 Jul 2026 17:19:34 +0200
Message-ID: <20260721152502.442024804@linuxfoundation.org>
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

[ Upstream commit 92f08e9d3cf0f8005ac6fcb931e3c388efc3ac49 ]

When a cell is instantiated, automatically create an /afs/.<cell>
mountpoint to match the /afs/<cell> mountpoint to match other AFS clients.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20250107183454.608451-2-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: c9c3b615a462 ("afs: Fix misplaced inc of net->cells_outstanding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c    | 13 +++++++-----
 fs/afs/dynroot.c | 52 ++++++++++++++++++++++++++++++------------------
 2 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index caa09875f52099..1aba6d4d03a9b0 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -146,18 +146,20 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cell->name = kmalloc(namelen + 1, GFP_KERNEL);
+	cell->name = kmalloc(1 + namelen + 1, GFP_KERNEL);
 	if (!cell->name) {
 		kfree(cell);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	cell->net = net;
+	cell->name[0] = '.';
+	cell->name++;
 	cell->name_len = namelen;
 	for (i = 0; i < namelen; i++)
 		cell->name[i] = tolower(name[i]);
 	cell->name[i] = 0;
 
+	cell->net = net;
 	refcount_set(&cell->ref, 1);
 	atomic_set(&cell->active, 0);
 	INIT_WORK(&cell->manager, afs_manage_cell_work);
@@ -211,7 +213,7 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 	if (ret == -EINVAL)
 		printk(KERN_ERR "kAFS: bad VL server IP address\n");
 error:
-	kfree(cell->name);
+	kfree(cell->name - 1);
 	kfree(cell);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
@@ -502,7 +504,7 @@ static void afs_cell_destroy(struct rcu_head *rcu)
 	afs_put_vlserverlist(net, rcu_access_pointer(cell->vl_servers));
 	afs_unuse_cell(net, cell->alias_of, afs_cell_trace_unuse_alias);
 	key_put(cell->anonymous_key);
-	kfree(cell->name);
+	kfree(cell->name - 1);
 	kfree(cell);
 
 	afs_dec_cells_outstanding(net);
@@ -710,7 +712,8 @@ static void afs_deactivate_cell(struct afs_net *net, struct afs_cell *cell)
 	afs_proc_cell_remove(cell);
 
 	mutex_lock(&net->proc_cells_lock);
-	hlist_del_rcu(&cell->proc_link);
+	if (!hlist_unhashed(&cell->proc_link))
+		hlist_del_rcu(&cell->proc_link);
 	afs_dynroot_rmdir(net, cell);
 	mutex_unlock(&net->proc_cells_lock);
 
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index c4d2711e20ad44..f80a4244b9d274 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -271,7 +271,8 @@ const struct dentry_operations afs_dynroot_dentry_operations = {
 int afs_dynroot_mkdir(struct afs_net *net, struct afs_cell *cell)
 {
 	struct super_block *sb = net->dynroot_sb;
-	struct dentry *root, *subdir;
+	struct dentry *root, *subdir, *dsubdir;
+	char *dotname = cell->name - 1;
 	int ret;
 
 	if (!sb || atomic_read(&sb->s_active) == 0)
@@ -286,34 +287,31 @@ int afs_dynroot_mkdir(struct afs_net *net, struct afs_cell *cell)
 		goto unlock;
 	}
 
-	/* Note that we're retaining an extra ref on the dentry */
+	dsubdir = lookup_one_len(dotname, root, cell->name_len + 1);
+	if (IS_ERR(dsubdir)) {
+		ret = PTR_ERR(dsubdir);
+		dput(subdir);
+		goto unlock;
+	}
+
+	/* Note that we're retaining extra refs on the dentries. */
 	subdir->d_fsdata = (void *)1UL;
+	dsubdir->d_fsdata = (void *)1UL;
 	ret = 0;
 unlock:
 	inode_unlock(root->d_inode);
 	return ret;
 }
 
-/*
- * Remove a manually added cell mount directory.
- * - The caller must hold net->proc_cells_lock
- */
-void afs_dynroot_rmdir(struct afs_net *net, struct afs_cell *cell)
+static void afs_dynroot_rm_one_dir(struct dentry *root, const char *name, size_t name_len)
 {
-	struct super_block *sb = net->dynroot_sb;
-	struct dentry *root, *subdir;
-
-	if (!sb || atomic_read(&sb->s_active) == 0)
-		return;
-
-	root = sb->s_root;
-	inode_lock(root->d_inode);
+	struct dentry *subdir;
 
 	/* Don't want to trigger a lookup call, which will re-add the cell */
-	subdir = try_lookup_one_len(cell->name, root, cell->name_len);
+	subdir = try_lookup_one_len(name, root, name_len);
 	if (IS_ERR_OR_NULL(subdir)) {
 		_debug("lookup %ld", PTR_ERR(subdir));
-		goto no_dentry;
+		return;
 	}
 
 	_debug("rmdir %pd %u", subdir, d_count(subdir));
@@ -324,8 +322,24 @@ void afs_dynroot_rmdir(struct afs_net *net, struct afs_cell *cell)
 		dput(subdir);
 	}
 	dput(subdir);
-no_dentry:
-	inode_unlock(root->d_inode);
+}
+
+/*
+ * Remove a manually added cell mount directory.
+ * - The caller must hold net->proc_cells_lock
+ */
+void afs_dynroot_rmdir(struct afs_net *net, struct afs_cell *cell)
+{
+	struct super_block *sb = net->dynroot_sb;
+	char *dotname = cell->name - 1;
+
+	if (!sb || atomic_read(&sb->s_active) == 0)
+		return;
+
+	inode_lock(sb->s_root->d_inode);
+	afs_dynroot_rm_one_dir(sb->s_root, cell->name, cell->name_len);
+	afs_dynroot_rm_one_dir(sb->s_root, dotname, cell->name_len + 1);
+	inode_unlock(sb->s_root->d_inode);
 	_leave("");
 }
 
-- 
2.53.0



