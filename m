Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB313C1081;
	Tue, 21 Jul 2026 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670821; cv=none; b=MBJGY+T0OGOjEqlbL/vkyB2qAFQ7F07RNp4EcuBzwZetdSA5UksHOLY7HkgqEQ+UryAlbSoLLkYAlQha0P+VeeH44VQzqucbxBe/bZhc7pUjhz3NmBtVNcED5y/htxLvS2Hp8aZSofU/fvOnq/4Bqvrn/qlX6717Ol9VJyrL9lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670821; c=relaxed/simple;
	bh=bjI7W6lfynVRYAlO3pHVWC6+r30cK3jTfzfeV/rdCnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzkTez2AAt2pxox4NvpRTKKZ9mV8lU2KZRa5CHNht7RUnCDoo5WQazC8DxA3cfEaXV2yMpIdSPz4tKwWuQ1QVYfBWM7j1LPx0PsM3TF5VYziP74McQAGYlMn+BrTGAc21AyQZAGV8bSvJXZI4VDK0p45+lAEMlVNJKEeKSlunfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/oOW1qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/oOW1qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7CE1F000E9;
	Tue, 21 Jul 2026 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670820;
	bh=7XGpzNFhG2oTgtChcFc2vKNuoI3Sktcuj9tiLEZbGyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/oOW1qaBoBqU+rFi6LsyX4uYxVyNKfZq5FAsLzQcv4ZV8+DongYM4dQJCTvcV0l1
	 YuPDTp5PUZB6FXmldlnDumXCF+eHPvATWsLEVP/pWVkExH19ekPad3SCP11P1hZc9B
	 Muj6Ym3RRaYu+2GFlEhyE297UV2smwX7yAgBWodQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/843] nfsd: move name lookup out of nfsd4_list_rec_dir()
Date: Tue, 21 Jul 2026 17:14:09 +0200
Message-ID: <20260721152406.276701513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfsd/nfs4recover.c | 55 ++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index b8ea2bdfbcfbf5..52984348ba3995 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -254,7 +254,7 @@ nfsd4_create_clid_dir(struct nfs4_client *clp)
 	nfs4_reset_creds(original_cred);
 }
 
-typedef int (recdir_func)(struct dentry *, struct dentry *, struct nfsd_net *);
+typedef int (recdir_func)(struct dentry *, char *, struct nfsd_net *);
 
 struct name_list {
 	char name[HEXDIR_LEN];
@@ -308,23 +308,14 @@ nfsd4_list_rec_dir(recdir_func *f, struct nfsd_net *nn)
 	}
 
 	status = iterate_dir(nn->rec_file, &ctx.ctx);
-	inode_lock_nested(d_inode(dir), I_MUTEX_PARENT);
 
 	list_for_each_entry_safe(entry, tmp, &ctx.names, list) {
-		if (!status) {
-			struct dentry *dentry;
-			dentry = lookup_one_len(entry->name, dir, HEXDIR_LEN-1);
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
@@ -422,18 +413,19 @@ nfsd4_remove_clid_dir(struct nfs4_client *clp)
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
@@ -443,10 +435,17 @@ purge_old(struct dentry *parent, struct dentry *child, struct nfsd_net *nn)
 	if (nfs4_has_reclaimed_state(name, nn))
 		goto out_free;
 
-	status = vfs_rmdir(&init_user_ns, d_inode(parent), child);
-	if (status)
-		printk("failed to remove client recovery directory %pd\n",
-				child);
+	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
+	child = lookup_one_len(cname, parent, HEXDIR_LEN - 1);
+	if (!IS_ERR(child)) {
+		status = vfs_rmdir(&init_user_ns, d_inode(parent), child);
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
@@ -477,18 +476,18 @@ nfsd4_recdir_purge_old(struct nfsd_net *nn)
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
@@ -843,11 +842,13 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				return PTR_ERR(name.data);
 			name.len = namelen;
 		}
+#ifdef CONFIG_NFSD_V4
 		if (name.len > 5 && memcmp(name.data, "hash:", 5) == 0) {
 			name.len = name.len - 5;
 			memmove(name.data, name.data + 5, name.len);
 			cn->cn_has_legacy = true;
 		}
+#endif
 		if (!nfs4_client_to_reclaim(name, princhash, nn)) {
 			kfree(name.data);
 			kfree(princhash.data);
-- 
2.53.0



