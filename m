Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79A84189DD;
	Fri,  4 Sep 2026 05:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501069; cv=none; b=I/Kw9VAzNt3G2BNydpVTQ9rIgQ1O6riZNX1IOlQkcLDR7HZy2FKst2l4HN08bhNqF2o6M5zWGtb0wkHdM+OHm0NiaFiiwXvLHPNNV9A95cvXsQDwUNYZQm4OGvWd6/vSFanfT6j5+2q9pJ0aUZP92mSlpDrRJiBmEEIXEhV6y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501069; c=relaxed/simple;
	bh=k64LkzMKFPHF2CQxW+lD9y+AQpbpoA6qc9adVBA+Ctw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp55nwybW9S42yK7ewPvtlJ86TJmUQB5gQv+5VdrXSwA8LI6By/g2EqKiIPdLvlu+eSa8qLnYdn2IxjMhS0HCwG6TdfOH/S2j6QIQW4X+4NZOMX3t9VXtTHETxrCfrDj/ci5urpwk3GfT1aWRx3HXwB7bpYU5dKCodgxkSt8nhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joYAYKkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joYAYKkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522B71F00A3D;
	Fri,  4 Sep 2026 05:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501067;
	bh=Va5ZY31/vED8NiTBy25K0XQs8BwH627E+xs4e/DITx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joYAYKkR4VLx2IqhX5hloEPsypR6lBkvCHpSZZllLnEFxH6F8Vac3aG6Z6PLpRCkp
	 K7QjdiiKDmZPeyQe6lzSPxb2mWxj2ekpUySdFNrtpaae0PA9fn0WAKR46yuEZY/80h
	 1sbZS8bdD4WUcVQw57xSR3ywmXKAz0T5cmivLetE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 279/552] sunrpc: route to a populated pool in svc_pool_for_cpu()
Date: Fri,  4 Sep 2026 06:57:16 +0200
Message-ID: <20260904045756.292344167@linuxfoundation.org>
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


