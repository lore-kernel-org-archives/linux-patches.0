Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA2216E3B;
	Thu, 12 Dec 2024 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024469; cv=none; b=tVutM82NEWdg2bW4jPeqJVpOPWQl/06Xb/ISXBw6JvKmPTREvks7fwuQn0bYyJhdLM/VotYCFpov0j4dc+LEy9jeDh2Maie6EGZQhVdez3t9Sx+UCH9U6S05nQV8kIfXtfKwMBsxpCzLW5b5XNfI3wAZutsaf6+a4/QIYYA3HE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024469; c=relaxed/simple;
	bh=6awoLZnR6v4yOlPysJgF4cm6FqNuZsOlewr+hSSXzQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow3iRl94REpGl0StlNIbAwXg9H9fgvcZXu2mZh8TJ6UZv5unOYBaE/fcx8fOs2akbGplzUGK6TT5ouv0WvrJU5AVPrA5i9I80wO60J/4QICKrWi1A/LgF45gKyaQWlq+LqXeEVJKZA/bG2vgRu3FubqdQd9QI+gt7dBTfhyypfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h833vzjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h833vzjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9F4C4CECE;
	Thu, 12 Dec 2024 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024469;
	bh=6awoLZnR6v4yOlPysJgF4cm6FqNuZsOlewr+hSSXzQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h833vzjTj1PsqcRi3df4Mf3w60Sw/Z7FFfLlvid3cZIUxa6hIG900UgqnqQ8b6wZN
	 qfO3nhFkM5uEZ+7D72myoXg8S8DAGnvKygf4hzcNYAH2hfU50i8Wka6QvYgH6nAe5w
	 r5tqiwrXQUGLiaYgbo5VHlF67ZQGElNrx+EUfktc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/459] SUNRPC: Convert rpc_client refcount to use refcount_t
Date: Thu, 12 Dec 2024 16:00:44 +0100
Message-ID: <20241212144305.732907756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 71d3d0ebc894294ef9454e45a3ac2e9ba60b3351 ]

There are now tools in the refcount library that allow us to convert the
client shutdown code.

Reported-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 4db9ad82a6c8 ("sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/clnt.h          |  3 ++-
 net/sunrpc/auth_gss/gss_rpc_upcall.c |  2 +-
 net/sunrpc/clnt.c                    | 22 ++++++++++------------
 net/sunrpc/debugfs.c                 |  2 +-
 net/sunrpc/rpc_pipe.c                |  2 +-
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 187e9f06cf64b..33691492dafb8 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -14,6 +14,7 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/refcount.h>
 
 #include <linux/sunrpc/msg_prot.h>
 #include <linux/sunrpc/sched.h>
@@ -34,7 +35,7 @@ struct rpc_inode;
  * The high-level client handle
  */
 struct rpc_clnt {
-	atomic_t		cl_count;	/* Number of references */
+	refcount_t		cl_count;	/* Number of references */
 	unsigned int		cl_clid;	/* client id */
 	struct list_head	cl_clients;	/* Global list of clients */
 	struct list_head	cl_tasks;	/* List of tasks */
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index af9c7f43859c4..05ff66b86b4eb 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -160,7 +160,7 @@ static struct rpc_clnt *get_gssp_clnt(struct sunrpc_net *sn)
 	mutex_lock(&sn->gssp_lock);
 	clnt = sn->gssp_clnt;
 	if (clnt)
-		atomic_inc(&clnt->cl_count);
+		refcount_inc(&clnt->cl_count);
 	mutex_unlock(&sn->gssp_lock);
 	return clnt;
 }
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 86397f9c4bc83..457042b653bba 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -169,7 +169,7 @@ static int rpc_clnt_skip_event(struct rpc_clnt *clnt, unsigned long event)
 	case RPC_PIPEFS_MOUNT:
 		if (clnt->cl_pipedir_objects.pdh_dentry != NULL)
 			return 1;
-		if (atomic_read(&clnt->cl_count) == 0)
+		if (refcount_read(&clnt->cl_count) == 0)
 			return 1;
 		break;
 	case RPC_PIPEFS_UMOUNT:
@@ -419,7 +419,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	clnt->cl_rtt = &clnt->cl_rtt_default;
 	rpc_init_rtt(&clnt->cl_rtt_default, clnt->cl_timeout->to_initval);
 
-	atomic_set(&clnt->cl_count, 1);
+	refcount_set(&clnt->cl_count, 1);
 
 	if (nodename == NULL)
 		nodename = utsname()->nodename;
@@ -430,7 +430,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args,
 	if (err)
 		goto out_no_path;
 	if (parent)
-		atomic_inc(&parent->cl_count);
+		refcount_inc(&parent->cl_count);
 
 	trace_rpc_clnt_new(clnt, xprt, program->name, args->servername);
 	return clnt;
@@ -917,18 +917,16 @@ rpc_free_client(struct rpc_clnt *clnt)
 static struct rpc_clnt *
 rpc_free_auth(struct rpc_clnt *clnt)
 {
-	if (clnt->cl_auth == NULL)
-		return rpc_free_client(clnt);
-
 	/*
 	 * Note: RPCSEC_GSS may need to send NULL RPC calls in order to
 	 *       release remaining GSS contexts. This mechanism ensures
 	 *       that it can do so safely.
 	 */
-	atomic_inc(&clnt->cl_count);
-	rpcauth_release(clnt->cl_auth);
-	clnt->cl_auth = NULL;
-	if (atomic_dec_and_test(&clnt->cl_count))
+	if (clnt->cl_auth != NULL) {
+		rpcauth_release(clnt->cl_auth);
+		clnt->cl_auth = NULL;
+	}
+	if (refcount_dec_and_test(&clnt->cl_count))
 		return rpc_free_client(clnt);
 	return NULL;
 }
@@ -942,7 +940,7 @@ rpc_release_client(struct rpc_clnt *clnt)
 	do {
 		if (list_empty(&clnt->cl_tasks))
 			wake_up(&destroy_wait);
-		if (!atomic_dec_and_test(&clnt->cl_count))
+		if (refcount_dec_not_one(&clnt->cl_count))
 			break;
 		clnt = rpc_free_auth(clnt);
 	} while (clnt != NULL);
@@ -1083,7 +1081,7 @@ void rpc_task_set_client(struct rpc_task *task, struct rpc_clnt *clnt)
 	if (clnt != NULL) {
 		rpc_task_set_transport(task, clnt);
 		task->tk_client = clnt;
-		atomic_inc(&clnt->cl_count);
+		refcount_inc(&clnt->cl_count);
 		if (clnt->cl_softrtry)
 			task->tk_flags |= RPC_TASK_SOFT;
 		if (clnt->cl_softerr)
diff --git a/net/sunrpc/debugfs.c b/net/sunrpc/debugfs.c
index 56029e3af6ff0..79995eb959279 100644
--- a/net/sunrpc/debugfs.c
+++ b/net/sunrpc/debugfs.c
@@ -90,7 +90,7 @@ static int tasks_open(struct inode *inode, struct file *filp)
 		struct seq_file *seq = filp->private_data;
 		struct rpc_clnt *clnt = seq->private = inode->i_private;
 
-		if (!atomic_inc_not_zero(&clnt->cl_count)) {
+		if (!refcount_inc_not_zero(&clnt->cl_count)) {
 			seq_release(inode, filp);
 			ret = -EINVAL;
 		}
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index bb13620e62468..a3545ecf9a6e5 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -423,7 +423,7 @@ rpc_info_open(struct inode *inode, struct file *file)
 		spin_lock(&file->f_path.dentry->d_lock);
 		if (!d_unhashed(file->f_path.dentry))
 			clnt = RPC_I(inode)->private;
-		if (clnt != NULL && atomic_inc_not_zero(&clnt->cl_count)) {
+		if (clnt != NULL && refcount_inc_not_zero(&clnt->cl_count)) {
 			spin_unlock(&file->f_path.dentry->d_lock);
 			m->private = clnt;
 		} else {
-- 
2.43.0



