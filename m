Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770EF18C324;
	Tue, 10 Sep 2024 10:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964928; cv=none; b=GYUTNn1b+5hcVrd7x/f6nLT7MD9TRUVO9OXh8YaPkLeiyNb9J91CfRT/Fuk8bfdijUQwDNu9yG4VZLYXzSCRqI7J5mqdiZx26Xtw+HKsmI2PitveF4ONqOrDCHSp8t+D0tzOFKJkGuoZNl7IvZASfwCnshson+PjSit9/XqCBJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964928; c=relaxed/simple;
	bh=rd+TXIPqxLk/V826xeDmDp5jO5n20pOxg8fsYmqLf8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSfTphWuRGC7QWQISRrIU9k73taHR//Nmd01cnaXrRUH51S1IGoOmjEc/aHT4mdDcqGUv8dcZ0Pi+FK1tB1FJcUSSJ+rY+QhKOIXN+VhEi/nQIEhAouOGxXQHN3EkvQnQAYjzu2w+SZ+1jgZzXeW+d9tvc/kUvWcMNePSv6AbRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mg+Onat6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mg+Onat6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93052C4CEC3;
	Tue, 10 Sep 2024 10:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964928;
	bh=rd+TXIPqxLk/V826xeDmDp5jO5n20pOxg8fsYmqLf8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg+Onat6UeSLk6N5w2m92mLZMiHQYc89OZ9B/AFO9sOI9pdy/9k4YP4ebcRtM9B9N
	 qdQx6njD0wSpWa9jwPecEgBFX0XL17COU2aM8mJcvQbck9n8odXT/FkbLnZ5D0DRO6
	 dwJHl6NEa2cZHRc/5QhlqDPqWZYaEo8eFwisu6+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Eirik Fuller <efuller@redhat.com>
Subject: [PATCH 5.10 079/186] nfsd: move init of percpu reply_cache_stats counters back to nfsd_init_net
Date: Tue, 10 Sep 2024 11:32:54 +0200
Message-ID: <20240910092557.772442336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit ed9ab7346e908496816cffdecd46932035f66e2e ]

Commit f5f9d4a314da ("nfsd: move reply cache initialization into nfsd
startup") moved the initialization of the reply cache into nfsd startup,
but didn't account for the stats counters, which can be accessed before
nfsd is ever started. The result can be a NULL pointer dereference when
someone accesses /proc/fs/nfsd/reply_cache_stats while nfsd is still
shut down.

This is a regression and a user-triggerable oops in the right situation:

- non-x86_64 arch
- /proc/fs/nfsd is mounted in the namespace
- nfsd is not started in the namespace
- unprivileged user calls "cat /proc/fs/nfsd/reply_cache_stats"

Although this is easy to trigger on some arches (like aarch64), on
x86_64, calling this_cpu_ptr(NULL) evidently returns a pointer to the
fixed_percpu_data. That struct looks just enough like a newly
initialized percpu var to allow nfsd_reply_cache_stats_show to access
it without Oopsing.

Move the initialization of the per-net+per-cpu reply-cache counters
back into nfsd_init_net, while leaving the rest of the reply cache
allocations to be done at nfsd startup time.

Kudos to Eirik who did most of the legwork to track this down.

Cc: stable@vger.kernel.org # v6.3+
Fixes: f5f9d4a314da ("nfsd: move reply cache initialization into nfsd startup")
Reported-and-tested-by: Eirik Fuller <efuller@redhat.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2215429
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 4b14885411f7 ("nfsd: make all of the nfsd stats per-network namespace")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/cache.h    |    2 ++
 fs/nfsd/nfscache.c |   25 ++++++++++++++-----------
 fs/nfsd/nfsctl.c   |   10 +++++++++-
 3 files changed, 25 insertions(+), 12 deletions(-)

--- a/fs/nfsd/cache.h
+++ b/fs/nfsd/cache.h
@@ -80,6 +80,8 @@ enum {
 
 int	nfsd_drc_slab_create(void);
 void	nfsd_drc_slab_free(void);
+int	nfsd_net_reply_cache_init(struct nfsd_net *nn);
+void	nfsd_net_reply_cache_destroy(struct nfsd_net *nn);
 int	nfsd_reply_cache_init(struct nfsd_net *);
 void	nfsd_reply_cache_shutdown(struct nfsd_net *);
 int	nfsd_cache_lookup(struct svc_rqst *);
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -148,12 +148,23 @@ void nfsd_drc_slab_free(void)
 	kmem_cache_destroy(drc_slab);
 }
 
-static int nfsd_reply_cache_stats_init(struct nfsd_net *nn)
+/**
+ * nfsd_net_reply_cache_init - per net namespace reply cache set-up
+ * @nn: nfsd_net being initialized
+ *
+ * Returns zero on succes; otherwise a negative errno is returned.
+ */
+int nfsd_net_reply_cache_init(struct nfsd_net *nn)
 {
 	return nfsd_percpu_counters_init(nn->counter, NFSD_NET_COUNTERS_NUM);
 }
 
-static void nfsd_reply_cache_stats_destroy(struct nfsd_net *nn)
+/**
+ * nfsd_net_reply_cache_destroy - per net namespace reply cache tear-down
+ * @nn: nfsd_net being freed
+ *
+ */
+void nfsd_net_reply_cache_destroy(struct nfsd_net *nn)
 {
 	nfsd_percpu_counters_destroy(nn->counter, NFSD_NET_COUNTERS_NUM);
 }
@@ -169,16 +180,12 @@ int nfsd_reply_cache_init(struct nfsd_ne
 	hashsize = nfsd_hashsize(nn->max_drc_entries);
 	nn->maskbits = ilog2(hashsize);
 
-	status = nfsd_reply_cache_stats_init(nn);
-	if (status)
-		goto out_nomem;
-
 	nn->nfsd_reply_cache_shrinker.scan_objects = nfsd_reply_cache_scan;
 	nn->nfsd_reply_cache_shrinker.count_objects = nfsd_reply_cache_count;
 	nn->nfsd_reply_cache_shrinker.seeks = 1;
 	status = register_shrinker(&nn->nfsd_reply_cache_shrinker);
 	if (status)
-		goto out_stats_destroy;
+		return status;
 
 	nn->drc_hashtbl = kvzalloc(array_size(hashsize,
 				sizeof(*nn->drc_hashtbl)), GFP_KERNEL);
@@ -194,9 +201,6 @@ int nfsd_reply_cache_init(struct nfsd_ne
 	return 0;
 out_shrinker:
 	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
-out_stats_destroy:
-	nfsd_reply_cache_stats_destroy(nn);
-out_nomem:
 	printk(KERN_ERR "nfsd: failed to allocate reply cache\n");
 	return -ENOMEM;
 }
@@ -216,7 +220,6 @@ void nfsd_reply_cache_shutdown(struct nf
 									rp, nn);
 		}
 	}
-	nfsd_reply_cache_stats_destroy(nn);
 
 	kvfree(nn->drc_hashtbl);
 	nn->drc_hashtbl = NULL;
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1458,6 +1458,9 @@ static __net_init int nfsd_init_net(stru
 	retval = nfsd_idmap_init(net);
 	if (retval)
 		goto out_idmap_error;
+	retval = nfsd_net_reply_cache_init(nn);
+	if (retval)
+		goto out_repcache_error;
 	nn->nfsd_versions = NULL;
 	nn->nfsd4_minorversions = NULL;
 	nfsd4_init_leases_net(nn);
@@ -1466,6 +1469,8 @@ static __net_init int nfsd_init_net(stru
 
 	return 0;
 
+out_repcache_error:
+	nfsd_idmap_shutdown(net);
 out_idmap_error:
 	nfsd_export_shutdown(net);
 out_export_error:
@@ -1474,9 +1479,12 @@ out_export_error:
 
 static __net_exit void nfsd_exit_net(struct net *net)
 {
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	nfsd_net_reply_cache_destroy(nn);
 	nfsd_idmap_shutdown(net);
 	nfsd_export_shutdown(net);
-	nfsd_netns_free_versions(net_generic(net, nfsd_net_id));
+	nfsd_netns_free_versions(nn);
 }
 
 static struct pernet_operations nfsd_net_ops = {


