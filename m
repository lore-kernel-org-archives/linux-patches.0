Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD193B7752;
	Thu, 17 Sep 2026 19:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671796; cv=none; b=iI2gr0lDn3jq+w5vwCWkht754dvwHq7apbX2FsIXZ2RQ7iZ2U62DZEzz1gH1SlavWN18lh1s5p6bZ1tJRmswuDRQYsCxh7X2SP2gygds2oKRnkuT7/XRJVHhd+jE5GnQpt32UPNMZAG5YThpTQdqhd52IcJ/cYMciCEKP6Rp9IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671796; c=relaxed/simple;
	bh=cZySsJUP03q1+ILQ78a5g3UiEccpjxbiibo8SUR1SQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9fEloBuv0GF49aPTj7QXK4cqAP72e8OFMTS/++REBmhMph8dQDUELw3VLpNKxCPuwOtIenPYZyhcFtzJOxkUUBZbGpMTnfb5ViKLsKYUNcWSYs0sz9l2dXSeUZmDs/m9/dIvqw1cUBG4Bgas3I/a1+GntuXLjmXeHOFdriEd8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjosvCbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjosvCbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A861F000FF;
	Thu, 17 Sep 2026 19:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671794;
	bh=UQucExAt3GtjNZQnGnZp1wYxgmTGujb2bWugSTmGAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fjosvCbsPSX4xauOswtmW2cqmUnX/sgW44/tTgWtt76ek6yC90R2NGQhfoLqmjFiH
	 Rp/1kenPUgZc/tRhK9q4y7NTzwHp4jPA9zF4Ji8G2ZiEIxe2MS8QojbR6nvlgyZK9e
	 3FsOd3HZ0LH1WnZu0m39UswRxvA9DARLWZ3Hofn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1085/1102] rpc_populate(): lift cleanup into callers
Date: Thu, 17 Sep 2026 16:17:08 +0100
Message-ID: <20260917151608.091355706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 8be22c49646e47452e74aa0b97ea50fb04c271ed ]

rpc_populate() is called either from fill_super (where we don't
need to remove any files on failure - rpc_kill_sb() will take
them all out anyway) or from rpc_mkdir_populate(), where we need
to remove the directory we'd been trying to populate along with
whatever we'd put into it before we failed.  Simpler to combine
that into simple_recursive_removal() there.

Note that rpc_pipe is overlocking directories quite a bit -
locked parent is no obstacle to finding a child in dcache, so
keeping it locked won't prevent userland observing a partially
built subtree.

All we need is to follow minimal VFS requirements; it's not
as if clients used directory locking for exclusion - tree
changes are serialized, but that's done on ->pipefs_sb_lock.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 932a8cf6abb2 ("sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/rpc_pipe_fs.h |    2 +-
 net/sunrpc/clnt.c                  |   36 ++++++++++++++----------------------
 net/sunrpc/rpc_pipe.c              |   26 +++++++++++++-------------
 3 files changed, 28 insertions(+), 36 deletions(-)

--- a/include/linux/sunrpc/rpc_pipe_fs.h
+++ b/include/linux/sunrpc/rpc_pipe_fs.h
@@ -98,7 +98,7 @@ static inline bool rpc_msg_is_inflight(c
 }
 
 struct rpc_clnt;
-extern struct dentry *rpc_create_client_dir(struct dentry *, const char *, struct rpc_clnt *);
+extern int rpc_create_client_dir(struct dentry *, const char *, struct rpc_clnt *);
 extern int rpc_remove_client_dir(struct rpc_clnt *);
 
 extern void rpc_init_pipe_dir_head(struct rpc_pipe_dir_head *pdh);
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -112,47 +112,46 @@ static void rpc_clnt_remove_pipedir(stru
 	}
 }
 
-static struct dentry *rpc_setup_pipedir_sb(struct super_block *sb,
+static int rpc_setup_pipedir_sb(struct super_block *sb,
 				    struct rpc_clnt *clnt)
 {
 	static uint32_t clntid;
 	const char *dir_name = clnt->cl_program->pipe_dir_name;
 	char name[15];
-	struct dentry *dir, *dentry;
+	struct dentry *dir;
+	int err;
 
 	dir = rpc_d_lookup_sb(sb, dir_name);
 	if (dir == NULL) {
 		pr_info("RPC: pipefs directory doesn't exist: %s\n", dir_name);
-		return dir;
+		return -ENOENT;
 	}
 	for (;;) {
 		snprintf(name, sizeof(name), "clnt%x", (unsigned int)clntid++);
 		name[sizeof(name) - 1] = '\0';
-		dentry = rpc_create_client_dir(dir, name, clnt);
-		if (!IS_ERR(dentry))
+		err = rpc_create_client_dir(dir, name, clnt);
+		if (!err)
 			break;
-		if (dentry == ERR_PTR(-EEXIST))
+		if (err == -EEXIST)
 			continue;
 		printk(KERN_INFO "RPC: Couldn't create pipefs entry"
-				" %s/%s, error %ld\n",
-				dir_name, name, PTR_ERR(dentry));
+				" %s/%s, error %d\n",
+				dir_name, name, err);
 		break;
 	}
 	dput(dir);
-	return dentry;
+	return err;
 }
 
 static int
 rpc_setup_pipedir(struct super_block *pipefs_sb, struct rpc_clnt *clnt)
 {
-	struct dentry *dentry;
-
 	clnt->pipefs_sb = pipefs_sb;
 
 	if (clnt->cl_program->pipe_dir_name != NULL) {
-		dentry = rpc_setup_pipedir_sb(pipefs_sb, clnt);
-		if (IS_ERR(dentry))
-			return PTR_ERR(dentry);
+		int err = rpc_setup_pipedir_sb(pipefs_sb, clnt);
+		if (err && err != -ENOENT)
+			return err;
 	}
 	return 0;
 }
@@ -180,16 +179,9 @@ static int rpc_clnt_skip_event(struct rp
 static int __rpc_clnt_handle_event(struct rpc_clnt *clnt, unsigned long event,
 				   struct super_block *sb)
 {
-	struct dentry *dentry;
-
 	switch (event) {
 	case RPC_PIPEFS_MOUNT:
-		dentry = rpc_setup_pipedir_sb(sb, clnt);
-		if (!dentry)
-			return -ENOENT;
-		if (IS_ERR(dentry))
-			return PTR_ERR(dentry);
-		break;
+		return rpc_setup_pipedir_sb(sb, clnt);
 	case RPC_PIPEFS_UMOUNT:
 		__rpc_clnt_remove_pipedir(clnt);
 		break;
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -725,7 +725,6 @@ static int rpc_populate(struct dentry *p
 	inode_unlock(dir);
 	return 0;
 out_bad:
-	__rpc_depopulate(parent, files, start, eof);
 	inode_unlock(dir);
 	printk(KERN_WARNING "%s: %s failed to populate directory %pd\n",
 			__FILE__, __func__, parent);
@@ -749,14 +748,15 @@ static struct dentry *rpc_mkdir_populate
 		goto out_err;
 	if (populate != NULL) {
 		error = populate(dentry, args_populate);
-		if (error)
-			goto err_rmdir;
+		if (error) {
+			inode_unlock(dir);
+			simple_recursive_removal(dentry, NULL);
+			return ERR_PTR(error);
+		}
 	}
 out:
 	inode_unlock(dir);
 	return dentry;
-err_rmdir:
-	__rpc_rmdir(dir, dentry);
 out_err:
 	dentry = ERR_PTR(error);
 	goto out;
@@ -1046,19 +1046,19 @@ static void rpc_clntdir_depopulate(struc
  * information about the client, together with any "pipes" that may
  * later be created using rpc_mkpipe().
  */
-struct dentry *rpc_create_client_dir(struct dentry *dentry,
-				   const char *name,
-				   struct rpc_clnt *rpc_client)
+int rpc_create_client_dir(struct dentry *dentry,
+			  const char *name,
+			  struct rpc_clnt *rpc_client)
 {
 	struct dentry *ret;
 
 	ret = rpc_mkdir_populate(dentry, name, 0555, NULL,
 				 rpc_clntdir_populate, rpc_client);
-	if (!IS_ERR(ret)) {
-		rpc_client->cl_pipedir_objects.pdh_dentry = ret;
-		rpc_create_pipe_dir_objects(&rpc_client->cl_pipedir_objects);
-	}
-	return ret;
+	if (IS_ERR(ret))
+		return PTR_ERR(ret);
+	rpc_client->cl_pipedir_objects.pdh_dentry = ret;
+	rpc_create_pipe_dir_objects(&rpc_client->cl_pipedir_objects);
+	return 0;
 }
 
 /**


