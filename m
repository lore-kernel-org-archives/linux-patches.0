Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904AF3148C2;
	Thu, 16 Jul 2026 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210372; cv=none; b=ATtMRnNBvZhp1sZKvbGWtMybU9jELl8YfCPGbJOWvm7v1I+Ci35mae42PnElPDx6GRBV8R+vmThDnJUhpFprM+0GIr3gGKOqNCyiVlqzKTFozjCDf7ofE/q59GfOG4XvWDLAYOyaoo+QUUYdE7YleKMAdVXRkJhj/caSYBPMp8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210372; c=relaxed/simple;
	bh=Rt3Hjhr96NdUAGkumG3Bi9c1td95XYQ1MLFwvITi+xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma6su4atTVbgc8UKHP9OnZB+kiydBDvbwh6MrSUsbZyph7mBWpKWyUdHh7qW8IFTRve54j5K3XNi/fzgeRIi4GZKLMxqWZUJLUM5h0JddGtsr2Q7jrVMQ8lZTsw20jcHEu7Jk8uzUkXw94C0F3eOMbjdtKoU3tW1acfYj7aYUd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySgHaKs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySgHaKs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9B41F000E9;
	Thu, 16 Jul 2026 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210371;
	bh=6oxH5sWCmN+T9GJZ5XVnlxxGujwgwutuXT1IoHWgPTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySgHaKs+NbroZ25m/UXJcJ/g3zrD/SeDcHWbRlRKGPiPuoiLcdTo7cz78kPdmqZzg
	 IMaGJCVH6NlHf1R6B03ocQkrscz1upHzXFbahnAzMosLAUjqeEQgzcLzj+tSmIDNyq
	 IZb/dw5KdMKdYoCQTmdss42NeHlttN5hvt4a/2AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/480] nfsd: move name lookup out of nfsd4_list_rec_dir()
Date: Thu, 16 Jul 2026 15:26:09 +0200
Message-ID: <20260716133045.177225131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@ownmail.net>

[ Upstream commit 89bd77cf436bf25e448817a662ebf76515f22863 ]

nfsd4_list_rec_dir() is called with two different callbacks.
One of the callbacks uses vfs_rmdir() to remove the directory.
The other doesn't use the dentry at all, just the name.

As only one callback needs the dentry, this patch moves the lookup into
that callback.  This prepares of changes to how directory operations
are locked.

Signed-off-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 4552f4e3f2c9 ("nfsd: change nfs4_client_to_reclaim() to allocate data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 54 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 3ea4b8a8616315..8ab0b26c1f91ab 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -237,7 +237,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	nfs4_reset_creds(original_cred);
 }
 
-typedef int (recdir_func)(struct dentry *, struct dentry *, struct nfsd_net *);
+typedef int (recdir_func)(struct dentry *, char *, struct nfsd_net *);
 
 struct name_list {
 	char name[HEXDIR_LEN];
@@ -291,24 +291,14 @@ nfsd4_list_rec_dir(recdir_func *f, struct nfsd_net *nn)
 	}
 
 	status = iterate_dir(nn->rec_file, &ctx.ctx);
-	inode_lock_nested(d_inode(dir), I_MUTEX_PARENT);
 
 	list_for_each_entry_safe(entry, tmp, &ctx.names, list) {
-		if (!status) {
-			struct dentry *dentry;
-			dentry = lookup_one(&nop_mnt_idmap,
-					    &QSTR(entry->name), dir);
-			if (IS_ERR(dentry)) {
-				status = PTR_ERR(dentry);
-				break;
-			}
-			status = f(dir, dentry, nn);
-			dput(dentry);
-		}
+		if (!status)
+			status = f(dir, entry->name, nn);
+
 		list_del(&entry->list);
 		kfree(entry);
 	}
-	inode_unlock(d_inode(dir));
 	nfs4_reset_creds(original_cred);
 
 	list_for_each_entry_safe(entry, tmp, &ctx.names, list) {
@@ -406,18 +396,19 @@ nfsd4_remove_clid_dir(struct nfs4_client *clp)
 }
 
 static int
-purge_old(struct dentry *parent, struct dentry *child, struct nfsd_net *nn)
+purge_old(struct dentry *parent, char *cname, struct nfsd_net *nn)
 {
 	int status;
+	struct dentry *child;
 	struct xdr_netobj name;
 
-	if (child->d_name.len != HEXDIR_LEN - 1) {
-		printk("%s: illegal name %pd in recovery directory\n",
-				__func__, child);
+	if (strlen(cname) != HEXDIR_LEN - 1) {
+		printk("%s: illegal name %s in recovery directory\n",
+				__func__, cname);
 		/* Keep trying; maybe the others are OK: */
 		return 0;
 	}
-	name.data = kmemdup_nul(child->d_name.name, child->d_name.len, GFP_KERNEL);
+	name.data = kstrdup(cname, GFP_KERNEL);
 	if (!name.data) {
 		dprintk("%s: failed to allocate memory for name.data!\n",
 			__func__);
@@ -427,10 +418,17 @@ purge_old(struct dentry *parent, struct dentry *child, struct nfsd_net *nn)
 	if (nfs4_has_reclaimed_state(name, nn))
 		goto out_free;
 
-	status = vfs_rmdir(&nop_mnt_idmap, d_inode(parent), child);
-	if (status)
-		printk("failed to remove client recovery directory %pd\n",
-				child);
+	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
+	child = lookup_one(&nop_mnt_idmap, &QSTR(cname), parent);
+	if (!IS_ERR(child)) {
+		status = vfs_rmdir(&nop_mnt_idmap, d_inode(parent), child);
+		if (status)
+			printk("failed to remove client recovery directory %pd\n",
+			       child);
+		dput(child);
+	}
+	inode_unlock(d_inode(parent));
+
 out_free:
 	kfree(name.data);
 out:
@@ -461,18 +459,18 @@ nfsd4_recdir_purge_old(struct nfsd_net *nn)
 }
 
 static int
-load_recdir(struct dentry *parent, struct dentry *child, struct nfsd_net *nn)
+load_recdir(struct dentry *parent, char *cname, struct nfsd_net *nn)
 {
 	struct xdr_netobj name;
 	struct xdr_netobj princhash = { .len = 0, .data = NULL };
 
-	if (child->d_name.len != HEXDIR_LEN - 1) {
-		printk("%s: illegal name %pd in recovery directory\n",
-				__func__, child);
+	if (strlen(cname) != HEXDIR_LEN - 1) {
+		printk("%s: illegal name %s in recovery directory\n",
+				__func__, cname);
 		/* Keep trying; maybe the others are OK: */
 		return 0;
 	}
-	name.data = kmemdup_nul(child->d_name.name, child->d_name.len, GFP_KERNEL);
+	name.data = kstrdup(cname, GFP_KERNEL);
 	if (!name.data) {
 		dprintk("%s: failed to allocate memory for name.data!\n",
 			__func__);
-- 
2.53.0



