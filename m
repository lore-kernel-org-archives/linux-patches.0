Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578B912CD8A;
	Tue, 14 May 2024 10:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682135; cv=none; b=K2GJh/zGXdANEJuXcrG0kXI1i0x1WoSja1tIcR+qDpqP4zeKWgM3sXwpSni0ey4iOajLAr52lk57bf6ks5EfrEIDZ9FTSyHL5/mufuXUmRbdikz8P0RracT/AiaZhdRy61lyS4rTulhpDrl7GRqAJjtcsPLSn2BXz9QFrrs8u14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682135; c=relaxed/simple;
	bh=wRsXCKU0CAlinvR7IM9vl/kuSU5/XoVfS+u+OBT3P9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKivl86UqrXgXj//IcUFvfbwdafufMcpZJDb1S45PVjrbLThY1snwl7RuJ9qg+PghJxB5NyE3bRLUsEWwgNOMF7nyHJUzG6mA5GPQo5pOkP93q16+LHQewMSyFfDSxhfFdX8YfCJw2ZZ//REJfM/Xsl9tfqc8IE00E5xJFKKJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GduDU8le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GduDU8le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06A4C2BD10;
	Tue, 14 May 2024 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682134;
	bh=wRsXCKU0CAlinvR7IM9vl/kuSU5/XoVfS+u+OBT3P9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GduDU8leO5A2kHNeYVVAe+I+f9FY9gcAZsl0WPOgGtZgklYT/xcQxfoclUAHDLq8f
	 t+7OrJGsBgvailz5j0ZurKTiypSqG7Y4JYBUue9CdHvYihC1VPLXntTk0j23eAljm2
	 E5mdStANKo4quPouPG30briF+jkpVRafMTeseC8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 018/336] nfsd: expose /proc/net/sunrpc/nfsd in net namespaces
Date: Tue, 14 May 2024 12:13:42 +0200
Message-ID: <20240514101039.294333730@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 93483ac5fec62cc1de166051b219d953bb5e4ef4 ]

We are running nfsd servers inside of containers with their own network
namespace, and we want to monitor these services using the stats found
in /proc.  However these are not exposed in the proc inside of the
container, so we have to bind mount the host /proc into our containers
to get at this information.

Separate out the stat counters init and the proc registration, and move
the proc registration into the pernet operations entry and exit points
so that these stats can be exposed inside of network namespaces.

This is an intermediate step, this just exposes the global counters in
the network namespace.  Subsequent patches will move these counters into
the per-network namespace container.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 18180a4550d0 ("NFSD: Fix nfsd4_encode_fattr4() crasher")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c |  8 +++++---
 fs/nfsd/stats.c  | 21 ++++++---------------
 fs/nfsd/stats.h  |  6 ++++--
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f206ca32e7f53..b57480b50e350 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1679,6 +1679,7 @@ static __net_init int nfsd_net_init(struct net *net)
 	nfsd4_init_leases_net(nn);
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
+	nfsd_proc_stat_init(net);
 
 	return 0;
 
@@ -1699,6 +1700,7 @@ static __net_exit void nfsd_net_exit(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
+	nfsd_proc_stat_shutdown(net);
 	nfsd_net_reply_cache_destroy(nn);
 	nfsd_idmap_shutdown(net);
 	nfsd_export_shutdown(net);
@@ -1722,7 +1724,7 @@ static int __init init_nfsd(void)
 	retval = nfsd4_init_pnfs();
 	if (retval)
 		goto out_free_slabs;
-	retval = nfsd_stat_init();	/* Statistics */
+	retval = nfsd_stat_counters_init();	/* Statistics */
 	if (retval)
 		goto out_free_pnfs;
 	retval = nfsd_drc_slab_create();
@@ -1762,7 +1764,7 @@ static int __init init_nfsd(void)
 	nfsd_lockd_shutdown();
 	nfsd_drc_slab_free();
 out_free_stat:
-	nfsd_stat_shutdown();
+	nfsd_stat_counters_destroy();
 out_free_pnfs:
 	nfsd4_exit_pnfs();
 out_free_slabs:
@@ -1780,7 +1782,7 @@ static void __exit exit_nfsd(void)
 	nfsd_drc_slab_free();
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
-	nfsd_stat_shutdown();
+	nfsd_stat_counters_destroy();
 	nfsd_lockd_shutdown();
 	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index 12d79f5d4eb1a..394a65a33942d 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -108,31 +108,22 @@ void nfsd_percpu_counters_destroy(struct percpu_counter counters[], int num)
 		percpu_counter_destroy(&counters[i]);
 }
 
-static int nfsd_stat_counters_init(void)
+int nfsd_stat_counters_init(void)
 {
 	return nfsd_percpu_counters_init(nfsdstats.counter, NFSD_STATS_COUNTERS_NUM);
 }
 
-static void nfsd_stat_counters_destroy(void)
+void nfsd_stat_counters_destroy(void)
 {
 	nfsd_percpu_counters_destroy(nfsdstats.counter, NFSD_STATS_COUNTERS_NUM);
 }
 
-int nfsd_stat_init(void)
+void nfsd_proc_stat_init(struct net *net)
 {
-	int err;
-
-	err = nfsd_stat_counters_init();
-	if (err)
-		return err;
-
-	svc_proc_register(&init_net, &nfsd_svcstats, &nfsd_proc_ops);
-
-	return 0;
+	svc_proc_register(net, &nfsd_svcstats, &nfsd_proc_ops);
 }
 
-void nfsd_stat_shutdown(void)
+void nfsd_proc_stat_shutdown(struct net *net)
 {
-	nfsd_stat_counters_destroy();
-	svc_proc_unregister(&init_net, "nfsd");
+	svc_proc_unregister(net, "nfsd");
 }
diff --git a/fs/nfsd/stats.h b/fs/nfsd/stats.h
index 7ed4325ac6912..38811aa7d13e1 100644
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -40,8 +40,10 @@ extern struct svc_stat		nfsd_svcstats;
 int nfsd_percpu_counters_init(struct percpu_counter *counters, int num);
 void nfsd_percpu_counters_reset(struct percpu_counter *counters, int num);
 void nfsd_percpu_counters_destroy(struct percpu_counter *counters, int num);
-int nfsd_stat_init(void);
-void nfsd_stat_shutdown(void);
+int nfsd_stat_counters_init(void);
+void nfsd_stat_counters_destroy(void);
+void nfsd_proc_stat_init(struct net *net);
+void nfsd_proc_stat_shutdown(struct net *net);
 
 static inline void nfsd_stats_rc_hits_inc(void)
 {
-- 
2.43.0



