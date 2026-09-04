Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2306E422522;
	Fri,  4 Sep 2026 05:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499311; cv=none; b=ViN2/JRAmJ5dx+WYtgqEmpGFAKWPIkZ9s6tBDmIvK2Kj3OmyogCWQTlbn+K8HahQZzJm1SawkJDkYHORmP4UhloBCmSbnxfVcYcioTHO+lp+GJ2eyZZcDZVCnl19xEzEUnxKG9Qjrsw0FE/45IUrD5LyRilv/mhvr3n5mE4hQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499311; c=relaxed/simple;
	bh=Ac7LDqEwnlGMPhKjBHRmH4NHvqxaV53h3au/Y9cC79E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn9ECxUil2f523noTs2NaRww3A/rYHGgS96aIsAeE9OXJAKiXkDCwi4H41ubMx2Rl2AfNA28x6IncdjaPteRPy+ZvhRPXZQOVYH0N9k7OADbmbZko8nlEviR1GlxfR4IqC9h8jfvnbN3Z3OsKP6YQuNTlWHQyI3cHFP8p5IApTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kIrc8hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kIrc8hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6341F00ACA;
	Fri,  4 Sep 2026 05:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499310;
	bh=HvEiRtd9bSmKeHGwlNZIE4N+sj8iWHXcVpolwYRDJ1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kIrc8hXsOQGMzOdpUWv78Zq4U/OTFjrgkhRRPm0v04lqZtNlxp+2ThuvZtb8saK6
	 D1ySXBpUySDYma9W56WTL/j+sCrwaoK48ao3JPqfocOq42sHpEbs28PGVuQBlGbmVZ
	 PHUtCC2aTj84dtpazwp6SQwkwA7yPFpusMkLrhI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 373/713] sunrpc: route to a populated pool in svc_pool_for_cpu()
Date: Fri,  4 Sep 2026 06:55:41 +0200
Message-ID: <20260904045812.188724781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit f6310491c4cdb88af73aa551ec9df1f10a90c709 upstream.

svc_set_num_threads() spreads the requested threads evenly across the
service's pools (base = nrservs / sv_nrpools).  When a service runs
fewer threads than it has pools -- e.g. an nfsd configured with fewer
threads than the host has NUMA nodes while running in "pernode" or
"percpu" mode -- the trailing pools are left with no threads at all.

svc_xprt_enqueue() selects a pool from the CPU servicing the transport,
queues the transport on that pool's sp_xprts, and only wakes a thread
from the same pool.  Each thread services exclusively its own pool, so a
transport that lands on a threadless pool is enqueued on sp_xprts and
never picked up: the connection hangs indefinitely.

Have svc_pool_for_cpu() skip pools that currently have no threads,
falling back to the next populated pool.  This trades NUMA locality for
a guarantee that the work is actually serviced.  sp_nrthreads is only
updated under the service mutex; the lockless read here is a best-effort
routing hint, so annotate it with data_race().

Fixes: bfd241600a3b ("[PATCH] knfsd: make rpc threads pools numa aware")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260706-sunrpc-pool-mode-v5-1-6c4ee7cd89aa@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -402,6 +402,7 @@ struct svc_pool *svc_pool_for_cpu(struct
 	struct svc_pool_map *m = &svc_pool_map;
 	int cpu = raw_smp_processor_id();
 	unsigned int pidx = 0;
+	unsigned int i;
 
 	if (serv->sv_nrpools <= 1)
 		return serv->sv_pools;
@@ -414,8 +415,34 @@ struct svc_pool *svc_pool_for_cpu(struct
 		pidx = m->to_pool[cpu_to_node(cpu)];
 		break;
 	}
+	pidx %= serv->sv_nrpools;
 
-	return &serv->sv_pools[pidx % serv->sv_nrpools];
+	/*
+	 * It's possible to have a pool with no threads. Userland can just set
+	 * things up this way directly. Also, when threads are autodistributed
+	 * they are spread evenly across the pools, but when there are fewer
+	 * threads than pools some pools can end up with none.
+	 *
+	 * A transport enqueued on a threadless pool would never be picked up,
+	 * since each thread only services its own pool. Fall back to the next
+	 * populated pool, trading NUMA locality for a guarantee that the
+	 * transport is serviced.
+	 */
+	for (i = 0; i < serv->sv_nrpools; i++) {
+		struct svc_pool *pool = &serv->sv_pools[pidx];
+
+		/* This is set under the service mutex and rarely ever
+		 * changes. A data race here is harmless.
+		 */
+		if (data_race(pool->sp_nrthreads))
+			return pool;
+
+		if (++pidx >= serv->sv_nrpools)
+			pidx = 0;
+	}
+
+	/* No pool has any threads; nothing can service the transport. */
+	return &serv->sv_pools[pidx];
 }
 
 static int svc_rpcb_setup(struct svc_serv *serv, struct net *net)


