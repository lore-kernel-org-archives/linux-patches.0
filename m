Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207801;
	b=ov4lhTnmhyiMTmRIyBRC37vvlsfpPV9cweN5zh6zSAoZwI0M2gh7WasWtz5tri2MYWx3
	 YG9c7DG2sU2PxnLdoQhHj0gi+QONNCLiLr7jV9yw/FBpo2HbIknheEaw2D9t7eJOq6izu
	 JhjxiT/j8Y5JZMcfpj4iR5Jhv+aX3PvG3PNdnmIHNeK/dd3bH5FcozbgSLPCvTmVLIQ6e
	 8oPg/S5ypRNutofT1mdOtwobl0FUmHvV8nT02MSGT4EaFbNRKVNO7wyGcKUE5wYAWFPEP
	 c9llu0kBbJ76UG3al4sPYNH+ts3xs9+Kz4tC2Nfd9aYATjtLY6DVeeVvgs/lcTSbA7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jn6jpUYsRe4Qd0r4jvKZUKs8PJMf031fmD6Sd3ix4xM=;
	b=ZC9FCdnbaw7iV1T6DHz0Qan29mErV4ocp6ZBeRkZEy5mdQCHnWx2ymTfilIiTsB76orn
	 wP5liPuXyfWNVLD6AhZFeu0hIDyIiSHgSqUixKHUnnQY268GdYVwODoXYPepJ9naYjftr
	 q0umYNXfsKaUIHpr2MxTGBLUNEx3eyx8SLLxUC1WAREUco5jwTz83/TPjVPL/+lKsnPoK
	 gCY59fUTt0bpjPnB53iq2CFPGJwzmVGw+FRq5I7mQloAVAkudcZcI/S22QoW3EOdhdsiG
	 mGPVtr7Gr6LUciXeme3FQMKA9b+deyAIBa5BFQXqqOOfMryX2bBDtzyplm9J41W5Mug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLIykqyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECBA606A31A;
	Wed, 28 Oct 2026 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLIykqyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB1F1F01828;
	Wed, 28 Oct 2026 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207801;
	bh=jn6jpUYsRe4Qd0r4jvKZUKs8PJMf031fmD6Sd3ix4xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLIykqybztPWGILEzQXTohTSWgHgYbEx4RcMToH3wK4kDngnZiKuW4FIcl3EmeXh7
	 0Ec7PxAdINoAnVGj/7ksDk3NHLtoqydfp2nKIgEgW0mdHyIvpC/IndFIddGjbWF5qe
	 OYt0UNtFBIMRCz0vY8oNeni+tJu5SekHyk+JE2sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/247] workqueue: release pwq pools by pool type
Date: Wed, 28 Oct 2026 17:59:08 +0100
Message-ID: <20261028165950.843617039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3180ee71b676845603274c66f6bb5528939cf470 ]

Add is_percpu_pool() and test the pool directly for per cpu. Convert the
other open-coded pool->cpu checks -- in put_unbound_pool(),
pool_allowed_cpus() and the workqueue watchdog -- to the same helper.

No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>

Use a single-evaluation macro for is_percpu_pool() so the predicate
conversion does not add a function. Keep the existing watchdog stall
accounting; only its pool-type check needs to change. This preserves
the release-path context needed by the pending-pwq lifetime fix.

Stable-dep-of: cf9c8aaea0d4 ("workqueue: Fix unbound pool lifetime for pending pwqs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 329394830c40f..14a3d1775c2ff 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1559,6 +1559,8 @@ work_func_t wq_worker_last_func(struct task_struct *task)
 	return worker->last_func;
 }
 
+#define is_percpu_pool(pool) ((pool)->cpu >= 0)
+
 /**
  * wq_node_nr_active - Determine wq_node_nr_active to use
  * @wq: workqueue of interest
@@ -2683,7 +2685,7 @@ static struct worker *alloc_worker(int node)
 
 static cpumask_t *pool_allowed_cpus(struct worker_pool *pool)
 {
-	if (pool->cpu < 0 && pool->attrs->affn_strict)
+	if (!is_percpu_pool(pool) && pool->attrs->affn_strict)
 		return pool->attrs->__pod_cpumask;
 	else
 		return pool->attrs->cpumask;
@@ -4969,7 +4971,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		return;
 
 	/* sanity checks */
-	if (WARN_ON(!(pool->cpu < 0)) ||
+	if (WARN_ON(is_percpu_pool(pool)) ||
 	    WARN_ON(!list_empty(&pool->worklist)))
 		return;
 
@@ -5121,7 +5123,7 @@ static void pwq_release_workfn(struct kthread_work *work)
 		mutex_unlock(&wq->mutex);
 	}
 
-	if (wq->flags & WQ_UNBOUND) {
+	if (!is_percpu_pool(pool)) {
 		mutex_lock(&wq_pool_mutex);
 		put_unbound_pool(pool);
 		mutex_unlock(&wq_pool_mutex);
@@ -7639,7 +7641,7 @@ static void wq_watchdog_timer_fn(struct timer_list *unused)
 		/* did we stall? */
 		if (time_after(now, ts + thresh)) {
 			lockup_detected = true;
-			if (pool->cpu >= 0 && !(pool->flags & POOL_BH)) {
+			if (is_percpu_pool(pool) && !(pool->flags & POOL_BH)) {
 				pool->cpu_stall = true;
 				cpu_pool_stall = true;
 			}
-- 
2.53.0



