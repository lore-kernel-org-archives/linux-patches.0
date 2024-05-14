Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573F1272D5;
	Tue, 14 May 2024 11:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687201; cv=none; b=q4YgWhxvIqN8j8vXFTO2Tji4IIGbvgX8Xvethlb/ucyJ15r8fXpy2WNUPwu7fis+z2C5EjaoRLKBsh089g4z1IB533IpSEG1C0Pvk6aaKRWuOl4FPSFnNEpIBJm6eTRfx8D5FvO9mP5azdV5Q4dmbOtYkaXJhG2lPx2/6P/f+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687201; c=relaxed/simple;
	bh=0U44cHLO5ECJkAA7ZRi29YM8MHNk34IUExD6W6IRegs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmkK6RHmnBUupYyyHsEZazjztTK8LqEIV3PQCMDUkxDd/9sUSdw+55HPzI6bDC6tjpN/0DTBk10fYX9r2hQn8QvBR+h6Pz9v89DHNX8EUyMytiN9NoW9KbbMT27hOxGQnh9buVLF4fYOjq4tCzOeytZ1xKzcgKjEn+sP1vbrlR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucgvtQWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucgvtQWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F13BC2BD10;
	Tue, 14 May 2024 11:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687201;
	bh=0U44cHLO5ECJkAA7ZRi29YM8MHNk34IUExD6W6IRegs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucgvtQWjrAYI8HUKUhRrSVPEQPQSw8w11yy8kbW/ASxtdAJtt5XkYdmLV9jYni/GW
	 z7R/xHg9HJq5gD/X9paLpynAlA+uzK3emEbi/ErYd0Pz5FzWe0q7gtzL69iexqJGl4
	 o2WgGb9gu8VtXin3xdz/S+ZqDqsrK4mnV1bsRYPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/111] nfs: make the rpc_stat per net namespace
Date: Tue, 14 May 2024 12:19:13 +0200
Message-ID: <20240514100957.704993599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1548036ef1204df65ca5a16e8b199c858cb80075 ]

Now that we're exposing the rpc stats on a per-network namespace basis,
move this struct into struct nfs_net and use that to make sure only the
per-network namespace stats are exposed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 24457f1be29f ("nfs: Handle error of rpc_proc_register() in nfs_net_init().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c   | 5 ++++-
 fs/nfs/inode.c    | 4 +++-
 fs/nfs/internal.h | 2 --
 fs/nfs/netns.h    | 2 ++
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 818ff8b1b99da..1437eb31dd034 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -73,7 +73,6 @@ const struct rpc_program nfs_program = {
 	.number			= NFS_PROGRAM,
 	.nrvers			= ARRAY_SIZE(nfs_version),
 	.version		= nfs_version,
-	.stats			= &nfs_rpcstat,
 	.pipe_dir_name		= NFS_PIPE_DIRNAME,
 };
 
@@ -501,6 +500,7 @@ int nfs_create_rpc_client(struct nfs_client *clp,
 			  const struct nfs_client_initdata *cl_init,
 			  rpc_authflavor_t flavor)
 {
+	struct nfs_net		*nn = net_generic(clp->cl_net, nfs_net_id);
 	struct rpc_clnt		*clnt = NULL;
 	struct rpc_create_args args = {
 		.net		= clp->cl_net,
@@ -512,6 +512,7 @@ int nfs_create_rpc_client(struct nfs_client *clp,
 		.servername	= clp->cl_hostname,
 		.nodename	= cl_init->nodename,
 		.program	= &nfs_program,
+		.stats		= &nn->rpcstats,
 		.version	= clp->rpc_ops->version,
 		.authflavor	= flavor,
 		.cred		= cl_init->cred,
@@ -1110,6 +1111,8 @@ void nfs_clients_init(struct net *net)
 #endif
 	spin_lock_init(&nn->nfs_client_lock);
 	nn->boot_time = ktime_get_real();
+	memset(&nn->rpcstats, 0, sizeof(nn->rpcstats));
+	nn->rpcstats.program = &nfs_program;
 
 	nfs_netns_sysfs_setup(nn, net);
 }
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 51c721e2f5555..4ae50340c1152 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2225,8 +2225,10 @@ EXPORT_SYMBOL_GPL(nfs_net_id);
 
 static int nfs_net_init(struct net *net)
 {
+	struct nfs_net *nn = net_generic(net, nfs_net_id);
+
 	nfs_clients_init(net);
-	rpc_proc_register(net, &nfs_rpcstat);
+	rpc_proc_register(net, &nn->rpcstats);
 	return nfs_fs_proc_net_init(net);
 }
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index a7e0970b5bfe1..9a72abfb46abc 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -435,8 +435,6 @@ int nfs_try_get_tree(struct fs_context *);
 int nfs_get_tree_common(struct fs_context *);
 void nfs_kill_super(struct super_block *);
 
-extern struct rpc_stat nfs_rpcstat;
-
 extern int __init register_nfs_fs(void);
 extern void __exit unregister_nfs_fs(void);
 extern bool nfs_sb_active(struct super_block *sb);
diff --git a/fs/nfs/netns.h b/fs/nfs/netns.h
index c8374f74dce11..a68b21603ea9a 100644
--- a/fs/nfs/netns.h
+++ b/fs/nfs/netns.h
@@ -9,6 +9,7 @@
 #include <linux/nfs4.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/sunrpc/stats.h>
 
 struct bl_dev_msg {
 	int32_t status;
@@ -34,6 +35,7 @@ struct nfs_net {
 	struct nfs_netns_client *nfs_client;
 	spinlock_t nfs_client_lock;
 	ktime_t boot_time;
+	struct rpc_stat rpcstats;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_nfsfs;
 #endif
-- 
2.43.0



