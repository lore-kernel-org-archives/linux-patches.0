Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774326;
	b=oJmLknMsNbnEb/T8fJE/J+n4i0oMmOYQStm82Ibq5bdU3RitqWhUR9/iKb4TtQZum4IS
	 obG1VTixvWVXq8B2XF0OlP4mtZ40jcupO8LzujypnQ1p/3RMbIdxs3fHjjdDtYx6r8atz
	 msl1wM5+c78cKEvUoGcA5i3jqYRPb0r7kHY/ztGlFEVFD6M002ZmPDYyCWAzDZq9KS78p
	 mMUoyoszNNwmGwUTrQrBi1rlMLyfbHznUvCNw9biIXVNFMHrGusEzf3FddFKHN83iAXu9
	 BzQBczt/Y5L62cdbL2awYh6hZw3CQskrMlF2Sz5EBPVihrcQvOrUFkZf9/VtZq8dwrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Qfuzj54Dhme1XrPEvdDZ1aF/U2pApvlqw16Mh4swTM=;
	b=Jh5yhJtnM4YFLccvMdAbGXkeKs+EGuvTSUawVYTx8MTjXZPFRdLPZAQgxgv/6ZBz6XP0
	 XKCjIIXcgx0Va4QoEMx7V6LY4A0dXtIzZXkuPAaRy+9YAtKmjL/Gt1nj9fcQayYOEh+Oa
	 9qXdlWNEcd/6q4SAHw4uXgTnY2yzQa75OoHdLnjU53uTJ6LKOuOInnfi6X04AZM3j3IG7
	 NAdq8xtfjcGHZpxnjirVkPCNXxDZRqOnQ8DHJC/IKpqOgmh/WvwI9Zehm/e73/CuUUNft
	 ZCTecv4/bpKXWwExB6kBcmzkLfCZOKUjVBlWMfVcPQyMGzvMFEi8uTn+o/ufD+J4OaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjhfB+hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ACB606A31D;
	Fri, 23 Oct 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjhfB+hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DB31F01825;
	Fri, 23 Oct 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774326;
	bh=+Qfuzj54Dhme1XrPEvdDZ1aF/U2pApvlqw16Mh4swTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjhfB+hmwbUS42r21Z1E2bw97aRbe9jbOt/xQgSdj/Kp6mxfaqALcEYedytkpbres
	 Yu5fQ3Qc9RTk8TRI0PGzuZ+gCZbZxziGRN2OXdr+i5VInbGt+q9YAIYAjZ3eRRXDYq
	 4jN+Wecvxg6+IbcQjmcG6e3w7Ika281ATfDn4ooU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/193] workqueue: release pwq pools by pool type
Date: Fri, 23 Oct 2026 18:37:38 +0200
Message-ID: <20261023163718.499044882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3180ee71b676845603274c66f6bb5528939cf470 ]

Add is_percpu_pool() and test the pool directly for per cpu. Convert the
other open-coded pool->cpu checks -- in put_unbound_pool(),
pool_allowed_cpus() and the workqueue watchdog -- to the same helper.

No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>

Use a single-evaluation macro for the pool predicate. Keep the existing
watchdog timestamp and reporting behavior, converting only its pool-type
test; the newer stall-duration accounting is absent.

Stable-dep-of: cf9c8aaea0d4 ("workqueue: Fix unbound pool lifetime for pending pwqs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1562,6 +1562,9 @@ work_func_t wq_worker_last_func(struct t
 	return worker->last_func;
 }
 
+/* True if @pool is a static per-cpu pool rather than an unbound one. */
+#define is_percpu_pool(pool) ((pool)->cpu >= 0)
+
 /**
  * wq_node_nr_active - Determine wq_node_nr_active to use
  * @wq: workqueue of interest
@@ -2689,7 +2692,7 @@ static struct worker *alloc_worker(int n
 
 static cpumask_t *pool_allowed_cpus(struct worker_pool *pool)
 {
-	if (pool->cpu < 0 && pool->attrs->affn_strict)
+	if (!is_percpu_pool(pool) && pool->attrs->affn_strict)
 		return pool->attrs->__pod_cpumask;
 	else
 		return pool->attrs->cpumask;
@@ -5030,7 +5033,7 @@ static void put_unbound_pool(struct work
 		return;
 
 	/* sanity checks */
-	if (WARN_ON(!(pool->cpu < 0)) ||
+	if (WARN_ON(is_percpu_pool(pool)) ||
 	    WARN_ON(!list_empty(&pool->worklist)))
 		return;
 
@@ -5182,7 +5185,7 @@ static void pwq_release_workfn(struct kt
 		mutex_unlock(&wq->mutex);
 	}
 
-	if (wq->flags & WQ_UNBOUND) {
+	if (!is_percpu_pool(pool)) {
 		mutex_lock(&wq_pool_mutex);
 		put_unbound_pool(pool);
 		mutex_unlock(&wq_pool_mutex);
@@ -7720,7 +7723,7 @@ static void wq_watchdog_timer_fn(struct
 		/* did we stall? */
 		if (time_after(now, ts + thresh)) {
 			lockup_detected = true;
-			if (pool->cpu >= 0 && !(pool->flags & POOL_BH)) {
+			if (is_percpu_pool(pool) && !(pool->flags & POOL_BH)) {
 				pool->cpu_stall = true;
 				cpu_pool_stall = true;
 			}


