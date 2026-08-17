Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE843C7C7;
	Mon, 17 Aug 2026 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974266; cv=none; b=T7KDzNe8guA4ooNt6RROpDqOYiEdStaaG/t12HY2/gQBkkhl/ErZJM7BIDcNL0kJaTK6CYgDSoV5LQ/6osg3zrXI66cDtL3ECyYQnZSyc2yw1ROgzkiHe7VAB8aNhbFUjrIwk1ZCXzhh6xle71qGWjzkbmiLfovFeWF3MbvweRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974266; c=relaxed/simple;
	bh=v3dwGMTcz1RPXfLjdWn/n3lj62tpNHMrP4POKgZWMz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLM4d2e84i31jnq+Lma7u8i81USbOEOM5wBtgRxJnCJfF7XHSApjB6dNtatTObnt1g/CoSSuF+kz0OJ+Sjg3gzJ/YVe+tJLa7S6zdjhyKzSTn3ChCHEEoteak+eZO14m05EiO1wceDooMAQ5+M2S2vV/18nKeWAD5ugHAa67VIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txXNHbB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txXNHbB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107971F00A3A;
	Mon, 17 Aug 2026 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974258;
	bh=RRjvRZrNw6HAbpbJ9211BZeM6mncZqHPOHhGKLYbPUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txXNHbB3rd+5UNXZVx1tq0ERUDIG6Ly0SWHE/0UXvUhOR0V0KFprlOZnr5TO2L6HK
	 yfuooULml7CXvpw/o9+0ZDIpoyawBq9rwYTfTWdvSJ4BRoFw7bQIQNTybeosvkJTtc
	 K4t3d3GlF74d5rGyPY6r5MM1JMH95gEEdlZB0tyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 144/271] ipvs: stop estimator after disabled calc phase
Date: Mon, 17 Aug 2026 15:31:09 +0200
Message-ID: <20260817132542.772793047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 558f67f1340f803a346ecd14a69c49653111c5f4 upstream.

IPVS estimator kthread 0 starts with zeroed chain and tick limits until
its initial calculation phase completes. If network namespace teardown
clears ipvs->enable during that phase, ip_vs_est_calc_phase() can return
without installing positive limits.

The kthread can then continue into its main loop and drain
est_temp_list with zero chain_max, tick_max and est_max_count values.
Each enqueue consumes one available tick row, but est_count never
reaches the zero est_max_count value. After all rows are consumed, the
row lookup returns IPVS_EST_NTICKS and ip_vs_enqueue_estimator() writes
past the ticks and tick_len arrays.

Exit kthread 0 after the calculation phase if the kthread is stopping or
IPVS has been disabled. That keeps temporary estimators from being
drained after the limits failed to initialize.

Estimator kthreads can now self-exit before teardown or reload stops
kd->task. Keep an extra task reference after creation and release it
with kthread_stop_put(), so kd->task remains valid until the stop paths
consume that reference.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_est.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -191,8 +191,11 @@ static int ip_vs_estimation_kthread(void
 		}
 
 		/* kthread 0 will handle the calc phase */
-		if (ipvs->est_calc_phase)
+		if (ipvs->est_calc_phase) {
 			ip_vs_est_calc_phase(ipvs);
+			if (kthread_should_stop() || !READ_ONCE(ipvs->enable))
+				return 0;
+		}
 	}
 
 	while (1) {
@@ -270,6 +273,7 @@ int ip_vs_est_kthread_start(struct netns
 		kd->task = NULL;
 		goto out;
 	}
+	get_task_struct(kd->task);
 
 	set_user_nice(kd->task, sysctl_est_nice(ipvs));
 	if (sysctl_est_preferred_cpulist(ipvs))
@@ -286,7 +290,7 @@ void ip_vs_est_kthread_stop(struct ip_vs
 {
 	if (kd->task) {
 		pr_info("stopping estimator thread %d...\n", kd->id);
-		kthread_stop(kd->task);
+		kthread_stop_put(kd->task);
 		kd->task = NULL;
 	}
 }
@@ -526,7 +530,7 @@ static void ip_vs_est_kthread_destroy(st
 	if (kd) {
 		if (kd->task) {
 			pr_info("stop unused estimator thread %d...\n", kd->id);
-			kthread_stop(kd->task);
+			kthread_stop_put(kd->task);
 		}
 		ip_vs_stats_free(kd->calc_stats);
 		kfree(kd);


