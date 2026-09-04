Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5493242BD;
	Fri,  4 Sep 2026 05:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501097; cv=none; b=Cmr6iBLIzMo8fhj1NKMoY13U9t71+PWRjfb5nrq+NRp6W897xEGVsUD4hzAKl3vsVxe3LBvUvEU1VQKyYchKr4GAWkDT7kbS5NGTF6CRTk6Hnheovt20LCxx/oeU6Q26ptsAycxZaQiRNbCdrLH24mZXuFgN6oUKEfPKpY4xERI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501097; c=relaxed/simple;
	bh=3I8+Xl77QUCGs/77AjwxWRE5ALcKvEHxE64ebkYGFMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJBVpSxIRuKr2XQbJWHcTjKt2BBYhjJRYG8cL7QkaFY2BpmflOWHuhNWcW2w1nejILiOXPzNgJy2u3LBbuVMoaKPUyNt2KIkC3PuzZP0js2fY1ZZqpTcvLHGM8B/QCz5ZpKKSiXYj8iMasxQr+CBUZzmrD82zq6tSnYD5E+vWyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjN3by6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjN3by6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9311F00A3D;
	Fri,  4 Sep 2026 05:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501096;
	bh=YGzDRHInDdt8/XPQV9GYRWdu+Lb52qn6VoUcsxKCXEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjN3by6s5WQ6i1bsQl+6qMS3yZPfKnWqcoeBfn+8h3iTUmCgibrjbeoYO3ZDez1G/
	 FK3rEMNFSSSa7Lsa6W3aPcUI8/FE823HzdZYQ27U6f+QPQORDa/sG4cXD2U6VjbkcH
	 +JJ1LZz1S0TlRoQwP+4DK+i9UYyhG/4e3Z2LYA8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 288/552] sunrpc: init gssp_lock before publishing proc entry
Date: Fri,  4 Sep 2026 06:57:25 +0200
Message-ID: <20260904045756.484232925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 5ce1ed6159731a41fdd0b03eedbed4e147036a5a upstream.

create_use_gss_proxy_proc_entry() publishes /proc/net/rpc/use-gss-proxy
via proc_create_data() before init_gssp_clnt() runs mutex_init() on
sn->gssp_lock.  Once the dentry is linked under proc_subdir_lock it is
immediately reachable from userspace, so a write that lands in the
window drives set_gssp_clnt() into mutex_lock() on a zero-initialized
struct mutex.

    create_use_gss_proxy_proc_entry(net)
      proc_create_data("use-gss-proxy", ...)   /* dentry live */
      init_gssp_clnt(sn)
        mutex_init(&sn->gssp_lock)             /* too late */

    write_gssp()
      set_gssp_clnt(net)
        mutex_lock(&sn->gssp_lock)             /* uninitialized */
        gssp_rpc_create(...)
        sn->gssp_clnt = clnt
        mutex_unlock(&sn->gssp_lock)

The window spans only the two statements between proc_create_data()
returning and init_gssp_clnt(), so a writer reaches it only if the
registering thread is preempted there while another task is already
opening the freshly published file.  register_pernet_subsys() runs in
preemptible context under pernet_ops_rwsem, so that preemption is
possible, and the window widens on auth_rpcgss module load, when the
proc entry is created for every live net namespace whose tasks are
already running.  A writer that wins the race locks a zero-filled
struct mutex.  On CONFIG_DEBUG_MUTEXES the missing magic value trips a
"lock used without init" splat; on a production kernel the fast path
acquires the lock via CMPXCHG(owner, 0, current).  In the latter case
a second writer that arrives before init_gssp_clnt() re-zeroes owner
can enter set_gssp_clnt() concurrently, shut down the first writer's
clnt while it is still in use, and leak the loser's clnt.

Fix by initializing sn->gssp_lock in sunrpc_init_net() so its lifetime
matches the sunrpc_net it lives in.  sn->gssp_clnt is already NULL from
the kzalloc that backs net_generic storage, so the lazy helper is no
longer needed; drop init_gssp_clnt(), its prototype, and the call from
create_use_gss_proxy_proc_entry().  sunrpc.ko is a build-time
dependency of auth_rpcgss.ko, so sunrpc_init_net() has always run on
every netns before any auth_gss pernet init can publish the proc
entry.

Fixes: 030d794bf498 ("SUNRPC: Use gssproxy upcall for server RPCGSS authentication.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-tier2-local-v2-1-5a0fd532db57@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_rpc_upcall.c |    6 ------
 net/sunrpc/auth_gss/gss_rpc_upcall.h |    1 -
 net/sunrpc/auth_gss/svcauth_gss.c    |    1 -
 net/sunrpc/sunrpc_syms.c             |    1 +
 4 files changed, 1 insertion(+), 8 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -121,12 +121,6 @@ out:
 	return result;
 }
 
-void init_gssp_clnt(struct sunrpc_net *sn)
-{
-	mutex_init(&sn->gssp_lock);
-	sn->gssp_clnt = NULL;
-}
-
 int set_gssp_clnt(struct net *net)
 {
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.h
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.h
@@ -29,7 +29,6 @@ int gssp_accept_sec_context_upcall(struc
 				struct gssp_upcall_data *data);
 void gssp_free_upcall_data(struct gssp_upcall_data *data);
 
-void init_gssp_clnt(struct sunrpc_net *);
 int set_gssp_clnt(struct net *);
 void clear_gssp_clnt(struct sunrpc_net *);
 
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1468,7 +1468,6 @@ static int create_use_gss_proxy_proc_ent
 			      &use_gss_proxy_proc_ops, net);
 	if (!*p)
 		return -ENOMEM;
-	init_gssp_clnt(sn);
 	return 0;
 }
 
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -54,6 +54,7 @@ static __net_init int sunrpc_init_net(st
 	INIT_LIST_HEAD(&sn->all_clients);
 	spin_lock_init(&sn->rpc_client_lock);
 	spin_lock_init(&sn->rpcb_clnt_lock);
+	mutex_init(&sn->gssp_lock);
 	return 0;
 
 err_pipefs:


