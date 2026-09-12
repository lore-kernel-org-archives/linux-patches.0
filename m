Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ECD2DE702;
	Sat, 12 Sep 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220333; cv=none; b=nYVUTdGr/HrB80pB4FfMLQealudb5RgBVoU8tJfSC/9AtL24INlaSHCb+g2G+0dAAhvVrnddwKsjEBVkJVkzM7g0axvLAS7dCOCi45V54CpT71oYvwyKLBxcmp1T68E8GYguCCchd3nTDCun87kNFZUJyrN7V8bXfBBDfhzwrQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220333; c=relaxed/simple;
	bh=e1G2AUtvpro4rQvz8hulLN1oa7M0kWbhlG+6ZspBoBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QysnLV6Pt+hZw+m+wM0/ywzVeEc9ghFoHu8p4z3ZPITi1py8td8y8Rs4hFazZltDQ09nZSwKC9ZUiHXV/Swlt8P/uT1VUbaR2USWypygrR3Gm6LwDfE+eDAo7CBjvJd9yLyBhG+jxZGFGPf5Br2mliGJ0JioyIp5FdvdtmGKxgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gajNVXGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gajNVXGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018161F000FF;
	Sat, 12 Sep 2026 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220332;
	bh=NkOG3XbgzktWooXgTgHKCV4HwxIHLzMu09+m84KTY0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gajNVXGxFtm+GMy/VpiBwKcHIpjSnldC6ZiLwB4IfZ76YnUcs+hUd2fYQ1c7zMuOT
	 Tr+QraUIWwZO3M5iMlSomTOUi3iKRCS9eF59mZRAkl3IWxM9o/LNAPcGFfKa6lGAQ0
	 e/D3jcqW8bCCKaItbVuRUhMMIlVKT8ox70CSGPS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0154/1424] SUNRPC: Check svc pool percpu counter allocation
Date: Sat, 12 Sep 2026 08:43:06 +0200
Message-ID: <20260912065610.745375877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 43e11e164704dde975c9edb370de1a06bec67270 upstream.

__svc_create() initializes three per-pool percpu_counter stats and
ignores every return value. On SMP, percpu_counter_init() fails when
__alloc_percpu_gfp() cannot satisfy the allocation, leaving the failed
counter with fbc->counters == NULL and its embedded raw_spinlock_t,
list_head, and count never initialized. __svc_create() returns the
half-constructed svc_serv to nfsd, lockd, or the NFS callback service
anyway.

Once that service is live, the hot-path increments in
svc_xprt_enqueue(), svc_handle_xprt(), and
svc_pool_wake_idle_thread() reach a counter whose backing pointer is
NULL. The pointer is a per-cpu offset, so the access does not fault:
it resolves to offset zero of the current CPU's per-cpu area and
silently corrupts whatever variable lives there. A
/proc/fs/nfsd/pool_stats read walks the same NULL per-cpu storage and
returns garbage, and on CONFIG_DEBUG_SPINLOCK or lockdep it splats on
the never-initialized lock.

Creating the broken service requires a percpu allocation failure during
RPC server startup, so it is reachable only by a local administrator
under memory pressure or fault injection; a remote peer cannot induce
the bad state on its own.

Check each percpu_counter_init() return value in __svc_create() and
fail when an allocation fails, unwinding the counters already set up
in the current pool and in every pool initialized before it. A
discrete percpu_counter_destroy() per counter at teardown frees each
per-cpu allocation exactly once.

Fixes: ccf08bed6e7a ("SUNRPC: Replace pool stats with per-CPU variables")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-tier2-local-v2-2-5a0fd532db57@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -476,6 +476,35 @@ __svc_init_bc(struct svc_serv *serv)
 }
 #endif
 
+static int svc_pool_init_counters(struct svc_pool *pool)
+{
+	int err;
+
+	err = percpu_counter_init(&pool->sp_messages_arrived, 0, GFP_KERNEL);
+	if (err)
+		return err;
+	err = percpu_counter_init(&pool->sp_sockets_queued, 0, GFP_KERNEL);
+	if (err)
+		goto err_sockets;
+	err = percpu_counter_init(&pool->sp_threads_woken, 0, GFP_KERNEL);
+	if (err)
+		goto err_threads;
+	return 0;
+
+err_threads:
+	percpu_counter_destroy(&pool->sp_sockets_queued);
+err_sockets:
+	percpu_counter_destroy(&pool->sp_messages_arrived);
+	return err;
+}
+
+static void svc_pool_destroy_counters(struct svc_pool *pool)
+{
+	percpu_counter_destroy(&pool->sp_messages_arrived);
+	percpu_counter_destroy(&pool->sp_sockets_queued);
+	percpu_counter_destroy(&pool->sp_threads_woken);
+}
+
 /*
  * Create an RPC service
  */
@@ -540,12 +569,18 @@ __svc_create(struct svc_program *prog, s
 		INIT_LIST_HEAD(&pool->sp_all_threads);
 		spin_lock_init(&pool->sp_lock);
 
-		percpu_counter_init(&pool->sp_messages_arrived, 0, GFP_KERNEL);
-		percpu_counter_init(&pool->sp_sockets_queued, 0, GFP_KERNEL);
-		percpu_counter_init(&pool->sp_threads_woken, 0, GFP_KERNEL);
+		if (svc_pool_init_counters(pool))
+			goto out_err;
 	}
 
 	return serv;
+
+out_err:
+	while (i--)
+		svc_pool_destroy_counters(&serv->sv_pools[i]);
+	kfree(serv->sv_pools);
+	kfree(serv);
+	return NULL;
 }
 
 /**
@@ -618,9 +653,7 @@ svc_destroy(struct kref *ref)
 	for (i = 0; i < serv->sv_nrpools; i++) {
 		struct svc_pool *pool = &serv->sv_pools[i];
 
-		percpu_counter_destroy(&pool->sp_messages_arrived);
-		percpu_counter_destroy(&pool->sp_sockets_queued);
-		percpu_counter_destroy(&pool->sp_threads_woken);
+		svc_pool_destroy_counters(pool);
 	}
 	kfree(serv->sv_pools);
 	kfree(serv);


