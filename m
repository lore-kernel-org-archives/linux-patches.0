Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873E30C366;
	Fri,  4 Sep 2026 05:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501077; cv=none; b=i9kRvJBSBR7MLilhoha1zsOrG3WN93E14MyMQul3Vydk+Y+Xtc6D1f2fWlfzknHT+yaD1t4gl8yF6BVBOUSHtmfzby5C3tEreGGkekvbCOlZH7hjDODvfCq4luZJxfmLuu6Fr3nWSgraDe/O3rJVwooZA9qKlmjXc7UsWawvsO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501077; c=relaxed/simple;
	bh=KZLFLjLu3Y0O39A8s8qu/AW1whP59XzDQceYkfHRUjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4PIt2ZraKIZGlFKeTiGY82AhRjDigtRGP11s2a/rtSNVHxT1mVfOqvwm8kJlse/eszhByzXlvvzmYnM3o27aX1Ygu4htQuzV5Z04aT7hIJ2GeXcxZ50DoGdmvcr1dToUGBIa9R06PUdLb3HNQUV+vW+DARLxA02WR7zcsMSKBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyDRPk2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyDRPk2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D031F00A3D;
	Fri,  4 Sep 2026 05:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501076;
	bh=Tz8DeuUaul5G29Lr8CuMd13rjj6WVZ2WMPbGajZwuLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyDRPk2xX7j546iRYmhggudJdrxXTG/Fivc2Wia2ct2Kuk7HWLBKImwi3VJCqvH7u
	 KWpG/G6ie1sL0AXOsh3D0U/+WUX4xqE6po/+Y4jdUUGwdxgW6URMupBawzu5CW4Iri
	 0TKgIeFKeiyGjhux1pmnxKoWNUtXk4vzJujBD9SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 282/552] SUNRPC: Check svc pool percpu counter allocation
Date: Fri,  4 Sep 2026 06:57:19 +0200
Message-ID: <20260904045756.357054748@linuxfoundation.org>
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
@@ -503,6 +503,35 @@ __svc_init_bc(struct svc_serv *serv)
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
@@ -568,12 +597,18 @@ __svc_create(struct svc_program *prog, i
 		INIT_LIST_HEAD(&pool->sp_all_threads);
 		init_llist_head(&pool->sp_idle_threads);
 
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
@@ -652,9 +687,7 @@ svc_destroy(struct svc_serv **servp)
 	for (i = 0; i < serv->sv_nrpools; i++) {
 		struct svc_pool *pool = &serv->sv_pools[i];
 
-		percpu_counter_destroy(&pool->sp_messages_arrived);
-		percpu_counter_destroy(&pool->sp_sockets_queued);
-		percpu_counter_destroy(&pool->sp_threads_woken);
+		svc_pool_destroy_counters(pool);
 	}
 	kfree(serv->sv_pools);
 	kfree(serv);


