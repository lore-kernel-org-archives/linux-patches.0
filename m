Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9A243991D;
	Mon, 17 Aug 2026 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978175; cv=none; b=tjIabkLL6BiiY+RBLUDJO5sKk25PVcVqahFGD/yIx3lenII37GHUDgFgQeKWv8mG97AjoZHYpwC8crKfQjWVcnw/UOKhdu+FdAvGOd3e1Y01sldTEMtqE/zSborrz8eOPbmToOeYcvlCS9Sz6DpBWrjPWnbVJqSLCERwmluQfhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978175; c=relaxed/simple;
	bh=l6TR8xk1O+6eu5hQGOL5BYiIzM1VDk+t46BQHZeiPGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDum/VMgx6jHe0fmt7BSJzueerRY2jNlUhuR47oL22qcU2REUb2B/q/buIZZM1X6sN5jVVL7VG+eMbtVOPnG0wo2YcNeYTQ2ozCJNG5tr68dfZsbTEd1JzTZeHdkFEloFgd7oQ6JRPc0ye1Ubk9zP4TVd8vTGLGUlwwb9X523h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPBiBnk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPBiBnk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89DB1F00A3E;
	Mon, 17 Aug 2026 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978168;
	bh=aN3wJwy9Q8vYhk5j7Z7iwlbHW4vVBjlaOcsf71RfaLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPBiBnk+7lt6brQaWvAU9cvpz5UJJkoc4EtlRfxQA5xOoPetqdgvsPf/NJ/OfTzOz
	 fbMA/SbSTZwNVbXUP+HByY4gCVo/VWrL35DLrOCqP38R8TRdrrTylvOmCf4lJgGudp
	 mm2tRawgVTrU92wl8U1iPVzGy4K/dvWaViX0HSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 086/181] ipvs: stop estimator after disabled calc phase
Date: Mon, 17 Aug 2026 15:33:00 +0200
Message-ID: <20260817132538.828743434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -187,8 +187,11 @@ static int ip_vs_estimation_kthread(void
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
@@ -263,6 +266,7 @@ int ip_vs_est_kthread_start(struct netns
 		kd->task = NULL;
 		goto out;
 	}
+	get_task_struct(kd->task);
 
 	set_user_nice(kd->task, sysctl_est_nice(ipvs));
 	set_cpus_allowed_ptr(kd->task, sysctl_est_cpulist(ipvs));
@@ -278,7 +282,7 @@ void ip_vs_est_kthread_stop(struct ip_vs
 {
 	if (kd->task) {
 		pr_info("stopping estimator thread %d...\n", kd->id);
-		kthread_stop(kd->task);
+		kthread_stop_put(kd->task);
 		kd->task = NULL;
 	}
 }
@@ -510,7 +514,7 @@ static void ip_vs_est_kthread_destroy(st
 	if (kd) {
 		if (kd->task) {
 			pr_info("stop unused estimator thread %d...\n", kd->id);
-			kthread_stop(kd->task);
+			kthread_stop_put(kd->task);
 		}
 		ip_vs_stats_free(kd->calc_stats);
 		kfree(kd);


