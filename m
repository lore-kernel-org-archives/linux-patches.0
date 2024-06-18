Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD3415B99B;
	Tue, 18 Jun 2024 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715343; cv=none; b=nhmNK8Fp9/fXYX6WV/3OCG40Kyt9VM5dHzAhvfFqrQIiPVg6VsrJMYlKxGY99WHdgU/rXQT4vV3qa6V4bhEiFlC9BnYShOd5Xh1Eel++NL4abNLYrb88UCYkMDE0j7ROyukDWxdROSqrcaedKe60geRl02vBWk1GZcdhPzwskl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715343; c=relaxed/simple;
	bh=uFXvgwxzwytfqzrTtvSJRqSfkg60ToJe7bVWtXVT+NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D53WlMKv4Ed4VM4A41avILdPhhR8cLUuIJklHv5VdmN+MyV/Q2S3dO8hayt2hjrXdChKUmLLiKoFkdSJ87FHhRK5fJGzqttEsV7nhhtET2zQ62ud8HfJXQ0HJ64ZPhQZeEWCReDwCfW9+S8OkS2BQaYywSteK6uSU9ATEBnHEk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSEIW0Nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSEIW0Nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F0C3277B;
	Tue, 18 Jun 2024 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715342;
	bh=uFXvgwxzwytfqzrTtvSJRqSfkg60ToJe7bVWtXVT+NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSEIW0NxSkBkFpk2sndIDZhqCUtuAGwsuOOiJE6Y/059G8pZe9JUgmhS9gTOVW2fm
	 Ks/a+CfhEjAK7BKVYJCjDahOM2HRtndNz3knqqCA1mPo2COie56zWMRYxwMO9mOyST
	 AxmzKXDTJ+1B7HhazUH4XjyNhefy4qPpvjMaWo1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/770] nfsd: report client confirmation status in "info" file
Date: Tue, 18 Jun 2024 14:31:38 +0200
Message-ID: <20240618123416.736051864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 472d155a0631bd1a09b5c0c275a254e65605d683 ]

mountd can now monitor clients appearing and disappearing in
/proc/fs/nfsd/clients, and will log these events, in liu of the logging
of mount/unmount events for NFSv3.

Currently it cannot distinguish between unconfirmed clients (which might
be transient and totally uninteresting) and confirmed clients.

So add a "status: " line which reports either "confirmed" or
"unconfirmed", and use fsnotify to report that the info file
has been modified.

This requires a bit of infrastructure to keep the dentry for the "info"
file.  There is no need to take a counted reference as the dentry must
remain around until the client is removed.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 19 +++++++++++++++----
 fs/nfsd/nfsctl.c    | 14 ++++++++------
 fs/nfsd/nfsd.h      |  4 +++-
 fs/nfsd/state.h     |  4 ++++
 4 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0afc14b3e4593..104d563636540 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -43,6 +43,7 @@
 #include <linux/sunrpc/addr.h>
 #include <linux/jhash.h>
 #include <linux/string_helpers.h>
+#include <linux/fsnotify.h>
 #include "xdr4.h"
 #include "xdr4cb.h"
 #include "vfs.h"
@@ -2370,6 +2371,10 @@ static int client_info_show(struct seq_file *m, void *v)
 	memcpy(&clid, &clp->cl_clientid, sizeof(clid));
 	seq_printf(m, "clientid: 0x%llx\n", clid);
 	seq_printf(m, "address: \"%pISpc\"\n", (struct sockaddr *)&clp->cl_addr);
+	if (test_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags))
+		seq_puts(m, "status: confirmed\n");
+	else
+		seq_puts(m, "status: unconfirmed\n");
 	seq_printf(m, "name: ");
 	seq_quote_mem(m, clp->cl_name.data, clp->cl_name.len);
 	seq_printf(m, "\nminor version: %d\n", clp->cl_minorversion);
@@ -2724,6 +2729,7 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 	int ret;
 	struct net *net = SVC_NET(rqstp);
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct dentry *dentries[ARRAY_SIZE(client_files)];
 
 	clp = alloc_client(name);
 	if (clp == NULL)
@@ -2743,9 +2749,11 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 	memcpy(&clp->cl_addr, sa, sizeof(struct sockaddr_storage));
 	clp->cl_cb_session = NULL;
 	clp->net = net;
-	clp->cl_nfsd_dentry = nfsd_client_mkdir(nn, &clp->cl_nfsdfs,
-			clp->cl_clientid.cl_id - nn->clientid_base,
-			client_files);
+	clp->cl_nfsd_dentry = nfsd_client_mkdir(
+		nn, &clp->cl_nfsdfs,
+		clp->cl_clientid.cl_id - nn->clientid_base,
+		client_files, dentries);
+	clp->cl_nfsd_info_dentry = dentries[0];
 	if (!clp->cl_nfsd_dentry) {
 		free_client(clp);
 		return NULL;
@@ -2820,7 +2828,10 @@ move_to_confirmed(struct nfs4_client *clp)
 	list_move(&clp->cl_idhash, &nn->conf_id_hashtbl[idhashval]);
 	rb_erase(&clp->cl_namenode, &nn->unconf_name_tree);
 	add_clp_to_name_tree(clp, &nn->conf_name_tree);
-	set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags);
+	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags) &&
+	    clp->cl_nfsd_dentry &&
+	    clp->cl_nfsd_info_dentry)
+		fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
 	renew_client_locked(clp);
 }
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index fa060f91df1b8..147ed8995a79f 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1270,7 +1270,8 @@ static void nfsdfs_remove_files(struct dentry *root)
 /* XXX: cut'n'paste from simple_fill_super; figure out if we could share
  * code instead. */
 static  int nfsdfs_create_files(struct dentry *root,
-					const struct tree_descr *files)
+				const struct tree_descr *files,
+				struct dentry **fdentries)
 {
 	struct inode *dir = d_inode(root);
 	struct inode *inode;
@@ -1279,8 +1280,6 @@ static  int nfsdfs_create_files(struct dentry *root,
 
 	inode_lock(dir);
 	for (i = 0; files->name && files->name[0]; i++, files++) {
-		if (!files->name)
-			continue;
 		dentry = d_alloc_name(root, files->name);
 		if (!dentry)
 			goto out;
@@ -1294,6 +1293,8 @@ static  int nfsdfs_create_files(struct dentry *root,
 		inode->i_private = __get_nfsdfs_client(dir);
 		d_add(dentry, inode);
 		fsnotify_create(dir, dentry);
+		if (fdentries)
+			fdentries[i] = dentry;
 	}
 	inode_unlock(dir);
 	return 0;
@@ -1305,8 +1306,9 @@ static  int nfsdfs_create_files(struct dentry *root,
 
 /* on success, returns positive number unique to that client. */
 struct dentry *nfsd_client_mkdir(struct nfsd_net *nn,
-		struct nfsdfs_client *ncl, u32 id,
-		const struct tree_descr *files)
+				 struct nfsdfs_client *ncl, u32 id,
+				 const struct tree_descr *files,
+				 struct dentry **fdentries)
 {
 	struct dentry *dentry;
 	char name[11];
@@ -1317,7 +1319,7 @@ struct dentry *nfsd_client_mkdir(struct nfsd_net *nn,
 	dentry = nfsd_mkdir(nn->nfsd_client_dir, ncl, name);
 	if (IS_ERR(dentry)) /* XXX: tossing errors? */
 		return NULL;
-	ret = nfsdfs_create_files(dentry, files);
+	ret = nfsdfs_create_files(dentry, files, fdentries);
 	if (ret) {
 		nfsd_client_rmdir(dentry);
 		return NULL;
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 27c1308ffc2ba..14dbfa75059d5 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -106,7 +106,9 @@ struct nfsdfs_client {
 
 struct nfsdfs_client *get_nfsdfs_client(struct inode *);
 struct dentry *nfsd_client_mkdir(struct nfsd_net *nn,
-		struct nfsdfs_client *ncl, u32 id, const struct tree_descr *);
+				 struct nfsdfs_client *ncl, u32 id,
+				 const struct tree_descr *,
+				 struct dentry **fdentries);
 void nfsd_client_rmdir(struct dentry *dentry);
 
 
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 73deea3531699..54cab651ac1d0 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -371,6 +371,10 @@ struct nfs4_client {
 
 	/* debugging info directory under nfsd/clients/ : */
 	struct dentry		*cl_nfsd_dentry;
+	/* 'info' file within that directory. Ref is not counted,
+	 * but will remain valid iff cl_nfsd_dentry != NULL
+	 */
+	struct dentry		*cl_nfsd_info_dentry;
 
 	/* for nfs41 callbacks */
 	/* We currently support a single back channel with a single slot */
-- 
2.43.0



