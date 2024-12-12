Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAED5748A;
	Thu, 12 Dec 2024 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017357; cv=none; b=deKOtyQSiSIOqedI8vRLBm2+AR2eTk5zTlSBF2H4e3tTHq/5Xrypb5dx8aTlCGdIJzThTGJFkjazbrQhGxFbdsj/sWDmjDxIrn2+dYX7oGiJUgX8+3R8k02ckaMj736UY5r3ouTJsanxHNah12r4t8wVe/RSmM4CNrMYxh2B/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017357; c=relaxed/simple;
	bh=SAXNbwDWb+YsjWeJCY7RsBiWAaHTueMgpPqqrhZsuic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+EmDg8T+uk+5+rLGm2QwdL6NgtQeJtjur3yJb7tMFo7SDhOeWTpKFqyUYXihQ/6FsFz113BLiztLb1AUZzepefpMqJkprJrFAg9Lob7M4nyoL/GDRobH87+05km6tXz+LpwSecHUvb8QgP2XYMuXfWgHGPyssvXf3rXSWH9pdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGlAmudC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGlAmudC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49274C4CECE;
	Thu, 12 Dec 2024 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017357;
	bh=SAXNbwDWb+YsjWeJCY7RsBiWAaHTueMgpPqqrhZsuic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGlAmudCOillEYMydOcfNqilqZTX31kUR+aeFCldpI3fwg6uS1ebZsgEfisYlzxng
	 Fhd73nhDuo8WsX6mbMFqvOksSTR6YhPHkaGLgbvjb7fovBc/rNUoRYHD/LTaBJDpZ7
	 8oDFJC6NaN26wpwsrgahWU4cTR8adye2ynSsaxWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/466] smb: client: dont try following DFS links in cifs_tree_connect()
Date: Thu, 12 Dec 2024 15:59:56 +0100
Message-ID: <20241212144323.621360659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 36008fe6e3dc588e5e9ceae6e82c7f69399eb5d8 ]

We can't properly support chasing DFS links in cifs_tree_connect()
because

  (1) We don't support creating new sessions while we're reconnecting,
      which would be required for DFS interlinks.

  (2) ->is_path_accessible() can't be called from cifs_tree_connect()
     as it would deadlock with smb2_reconnect().  This is required for
     checking if new DFS target is a nested DFS link.

By unconditionally trying to get an DFS referral from new DFS target
isn't correct because if the new DFS target (interlink) is an DFS
standalone namespace, then we would end up getting -ELOOP and then
potentially leaving tcon disconnected.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dfs.c | 188 ++++----------------------------------------
 1 file changed, 17 insertions(+), 171 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 3f6077c68d68a..c35953843373e 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -321,49 +321,6 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	return rc;
 }
 
-/* Update dfs referral path of superblock */
-static int update_server_fullpath(struct TCP_Server_Info *server, struct cifs_sb_info *cifs_sb,
-				  const char *target)
-{
-	int rc = 0;
-	size_t len = strlen(target);
-	char *refpath, *npath;
-
-	if (unlikely(len < 2 || *target != '\\'))
-		return -EINVAL;
-
-	if (target[1] == '\\') {
-		len += 1;
-		refpath = kmalloc(len, GFP_KERNEL);
-		if (!refpath)
-			return -ENOMEM;
-
-		scnprintf(refpath, len, "%s", target);
-	} else {
-		len += sizeof("\\");
-		refpath = kmalloc(len, GFP_KERNEL);
-		if (!refpath)
-			return -ENOMEM;
-
-		scnprintf(refpath, len, "\\%s", target);
-	}
-
-	npath = dfs_cache_canonical_path(refpath, cifs_sb->local_nls, cifs_remap(cifs_sb));
-	kfree(refpath);
-
-	if (IS_ERR(npath)) {
-		rc = PTR_ERR(npath);
-	} else {
-		mutex_lock(&server->refpath_lock);
-		spin_lock(&server->srv_lock);
-		kfree(server->leaf_fullpath);
-		server->leaf_fullpath = npath;
-		spin_unlock(&server->srv_lock);
-		mutex_unlock(&server->refpath_lock);
-	}
-	return rc;
-}
-
 static int target_share_matches_server(struct TCP_Server_Info *server, char *share,
 				       bool *target_match)
 {
@@ -388,77 +345,22 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	return rc;
 }
 
-static void __tree_connect_ipc(const unsigned int xid, char *tree,
-			       struct cifs_sb_info *cifs_sb,
-			       struct cifs_ses *ses)
-{
-	struct TCP_Server_Info *server = ses->server;
-	struct cifs_tcon *tcon = ses->tcon_ipc;
-	int rc;
-
-	spin_lock(&ses->ses_lock);
-	spin_lock(&ses->chan_lock);
-	if (cifs_chan_needs_reconnect(ses, server) ||
-	    ses->ses_status != SES_GOOD) {
-		spin_unlock(&ses->chan_lock);
-		spin_unlock(&ses->ses_lock);
-		cifs_server_dbg(FYI, "%s: skipping ipc reconnect due to disconnected ses\n",
-				__func__);
-		return;
-	}
-	spin_unlock(&ses->chan_lock);
-	spin_unlock(&ses->ses_lock);
-
-	cifs_server_lock(server);
-	scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
-	cifs_server_unlock(server);
-
-	rc = server->ops->tree_connect(xid, ses, tree, tcon,
-				       cifs_sb->local_nls);
-	cifs_server_dbg(FYI, "%s: tree_reconnect %s: %d\n", __func__, tree, rc);
-	spin_lock(&tcon->tc_lock);
-	if (rc) {
-		tcon->status = TID_NEED_TCON;
-	} else {
-		tcon->status = TID_GOOD;
-		tcon->need_reconnect = false;
-	}
-	spin_unlock(&tcon->tc_lock);
-}
-
-static void tree_connect_ipc(const unsigned int xid, char *tree,
-			     struct cifs_sb_info *cifs_sb,
-			     struct cifs_tcon *tcon)
-{
-	struct cifs_ses *ses = tcon->ses;
-
-	__tree_connect_ipc(xid, tree, cifs_sb, ses);
-	__tree_connect_ipc(xid, tree, cifs_sb, CIFS_DFS_ROOT_SES(ses));
-}
-
-static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-				     struct cifs_sb_info *cifs_sb, char *tree, bool islink,
-				     struct dfs_cache_tgt_list *tl)
+static int tree_connect_dfs_target(const unsigned int xid,
+				   struct cifs_tcon *tcon,
+				   struct cifs_sb_info *cifs_sb,
+				   char *tree, bool islink,
+				   struct dfs_cache_tgt_list *tl)
 {
-	int rc;
+	const struct smb_version_operations *ops = tcon->ses->server->ops;
 	struct TCP_Server_Info *server = tcon->ses->server;
-	const struct smb_version_operations *ops = server->ops;
-	struct cifs_ses *root_ses = CIFS_DFS_ROOT_SES(tcon->ses);
-	char *share = NULL, *prefix = NULL;
 	struct dfs_cache_tgt_iterator *tit;
+	char *share = NULL, *prefix = NULL;
 	bool target_match;
-
-	tit = dfs_cache_get_tgt_iterator(tl);
-	if (!tit) {
-		rc = -ENOENT;
-		goto out;
-	}
+	int rc = -ENOENT;
 
 	/* Try to tree connect to all dfs targets */
-	for (; tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
-		const char *target = dfs_cache_get_tgt_name(tit);
-		DFS_CACHE_TGT_LIST(ntl);
-
+	for (tit = dfs_cache_get_tgt_iterator(tl);
+	     tit; tit = dfs_cache_get_next_tgt(tl, tit)) {
 		kfree(share);
 		kfree(prefix);
 		share = prefix = NULL;
@@ -479,69 +381,16 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
 		}
 
 		dfs_cache_noreq_update_tgthint(server->leaf_fullpath + 1, tit);
-		tree_connect_ipc(xid, tree, cifs_sb, tcon);
-
 		scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
-		if (!islink) {
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
-			break;
-		}
-
-		/*
-		 * If no dfs referrals were returned from link target, then just do a TREE_CONNECT
-		 * to it.  Otherwise, cache the dfs referral and then mark current tcp ses for
-		 * reconnect so either the demultiplex thread or the echo worker will reconnect to
-		 * newly resolved target.
-		 */
-		if (dfs_cache_find(xid, root_ses, cifs_sb->local_nls, cifs_remap(cifs_sb), target,
-				   NULL, &ntl)) {
-			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, cifs_sb->local_nls);
-			if (rc)
-				continue;
-
+		rc = ops->tree_connect(xid, tcon->ses, tree,
+				       tcon, tcon->ses->local_nls);
+		if (islink && !rc && cifs_sb)
 			rc = cifs_update_super_prepath(cifs_sb, prefix);
-		} else {
-			/* Target is another dfs share */
-			rc = update_server_fullpath(server, cifs_sb, target);
-			dfs_cache_free_tgts(tl);
-
-			if (!rc) {
-				rc = -EREMOTE;
-				list_replace_init(&ntl.tl_list, &tl->tl_list);
-			} else
-				dfs_cache_free_tgts(&ntl);
-		}
 		break;
 	}
 
-out:
 	kfree(share);
 	kfree(prefix);
-
-	return rc;
-}
-
-static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tcon,
-				   struct cifs_sb_info *cifs_sb, char *tree, bool islink,
-				   struct dfs_cache_tgt_list *tl)
-{
-	int rc;
-	int num_links = 0;
-	struct TCP_Server_Info *server = tcon->ses->server;
-	char *old_fullpath = server->leaf_fullpath;
-
-	do {
-		rc = __tree_connect_dfs_target(xid, tcon, cifs_sb, tree, islink, tl);
-		if (!rc || rc != -EREMOTE)
-			break;
-	} while (rc = -ELOOP, ++num_links < MAX_NESTED_LINKS);
-	/*
-	 * If we couldn't tree connect to any targets from last referral path, then
-	 * retry it from newly resolved dfs referral.
-	 */
-	if (rc && server->leaf_fullpath != old_fullpath)
-		cifs_signal_cifsd_for_reconnect(server, true);
-
 	dfs_cache_free_tgts(tl);
 	return rc;
 }
@@ -596,14 +445,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	if (!IS_ERR(sb))
 		cifs_sb = CIFS_SB(sb);
 
-	/*
-	 * Tree connect to last share in @tcon->tree_name whether dfs super or
-	 * cached dfs referral was not found.
-	 */
-	if (!cifs_sb || !server->leaf_fullpath ||
+	/* Tree connect to last share in @tcon->tree_name if no DFS referral */
+	if (!server->leaf_fullpath ||
 	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
-		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name, tcon,
-				       cifs_sb ? cifs_sb->local_nls : nlsc);
+		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name,
+				       tcon, tcon->ses->local_nls);
 		goto out;
 	}
 
-- 
2.43.0



