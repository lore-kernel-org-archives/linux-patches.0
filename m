Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD530F531;
	Mon, 13 Oct 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367815; cv=none; b=pbLxPBj4yTz+Wsh/GCT7UCKJOfBNx41dujF/yU3ozzjI92W4ae5pn5nkWoNCXNqIt0hA9S6fO+qKQ+yaOLW5UtyzvtVjTH8sjGk1BdMXtAhnZP7gXxiFcSMdwjOEq+LdyJU6VB1Kwe+qxK58Ap8rSwnRXNnQz5aiQ0F7J+e2QuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367815; c=relaxed/simple;
	bh=I8COHu1S6ms/Jxr5xJ1Mu3E7zhCIplFjSRZyedjSrxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8pfISqrM/ZrBhX2b35QN3NUTEVC50UuW1Frg4FKSGu9xsxp9QafvA7K9SM589lZIvI9PMGKixW9cS3ccXypsL3Uq1OtVhSgZIx6rAYcLz/uV5PFbF38gOQ/fbLmgcnbdJzj4gsFjWZrIkYETRudKxZMedsxum2ZySYvFmTikY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKMot0HS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKMot0HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AD3C4CEE7;
	Mon, 13 Oct 2025 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367815;
	bh=I8COHu1S6ms/Jxr5xJ1Mu3E7zhCIplFjSRZyedjSrxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKMot0HS2HAo5Q4sZNdNX/0+NOPwa9NluXyVAbMyqXQ2XYariCmBPY1iGZLh4/d+X
	 LSioXvoH0+sXusTmryHluIdtisbX5BpJFyUfq+Px26GZioDePP/dN7qE7ynSPB77VI
	 uCFCktrTWY13U0pA+ClHPF42ewE4bnCVZcmSqVCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1651b5234028c294c339@syzkaller.appspotmail.com,
	Julian Anastasov <ja@ssi.bg>,
	Zhang Tengfei <zhtfdev@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/196] ipvs: Use READ_ONCE/WRITE_ONCE for ipvs->enable
Date: Mon, 13 Oct 2025 16:45:01 +0200
Message-ID: <20251013144319.292038307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Zhang Tengfei <zhtfdev@gmail.com>

[ Upstream commit 944b6b216c0387ac3050cd8b773819ae360bfb1c ]

KCSAN reported a data-race on the `ipvs->enable` flag, which is
written in the control path and read concurrently from many other
contexts.

Following a suggestion by Julian, this patch fixes the race by
converting all accesses to use `WRITE_ONCE()/READ_ONCE()`.
This lightweight approach ensures atomic access and acts as a
compiler barrier, preventing unsafe optimizations where the flag
is checked in loops (e.g., in ip_vs_est.c).

Additionally, the `enable` checks in the fast-path hooks
(`ip_vs_in_hook`, `ip_vs_out_hook`, `ip_vs_forward_icmp`) are
removed. These are unnecessary since commit 857ca89711de
("ipvs: register hooks only with services"). The `enable=0`
condition they check for can only occur in two rare and non-fatal
scenarios: 1) after hooks are registered but before the flag is set,
and 2) after hooks are unregistered on cleanup_net. In the worst
case, a single packet might be mishandled (e.g., dropped), which
does not lead to a system crash or data corruption. Adding a check
in the performance-critical fast-path to handle this harmless
condition is not a worthwhile trade-off.

Fixes: 857ca89711de ("ipvs: register hooks only with services")
Reported-by: syzbot+1651b5234028c294c339@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1651b5234028c294c339
Suggested-by: Julian Anastasov <ja@ssi.bg>
Link: https://lore.kernel.org/lvs-devel/2189fc62-e51e-78c9-d1de-d35b8e3657e3@ssi.bg/
Signed-off-by: Zhang Tengfei <zhtfdev@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |  4 ++--
 net/netfilter/ipvs/ip_vs_core.c | 11 ++++-------
 net/netfilter/ipvs/ip_vs_ctl.c  |  6 +++---
 net/netfilter/ipvs/ip_vs_est.c  | 16 ++++++++--------
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 8182833a35828..d9c3eefe8cbb0 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -884,7 +884,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 			 * conntrack cleanup for the net.
 			 */
 			smp_rmb();
-			if (ipvs->enable)
+			if (READ_ONCE(ipvs->enable))
 				ip_vs_conn_drop_conntrack(cp);
 		}
 
@@ -1432,7 +1432,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
 		cond_resched_rcu();
 
 		/* netns clean up started, abort delayed work */
-		if (!ipvs->enable)
+		if (!READ_ONCE(ipvs->enable))
 			break;
 	}
 	rcu_read_unlock();
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 3230506ae3ffd..34c4648ba36ec 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1353,9 +1353,6 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 	if (unlikely(!skb_dst(skb)))
 		return NF_ACCEPT;
 
-	if (!ipvs->enable)
-		return NF_ACCEPT;
-
 	ip_vs_fill_iph_skb(af, skb, false, &iph);
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6) {
@@ -1936,7 +1933,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 		return NF_ACCEPT;
 	}
 	/* ipvs enabled in this netns ? */
-	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
+	if (unlikely(sysctl_backup_only(ipvs)))
 		return NF_ACCEPT;
 
 	ip_vs_fill_iph_skb(af, skb, false, &iph);
@@ -2104,7 +2101,7 @@ ip_vs_forward_icmp(void *priv, struct sk_buff *skb,
 	int r;
 
 	/* ipvs enabled in this netns ? */
-	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
+	if (unlikely(sysctl_backup_only(ipvs)))
 		return NF_ACCEPT;
 
 	if (state->pf == NFPROTO_IPV4) {
@@ -2291,7 +2288,7 @@ static int __net_init __ip_vs_init(struct net *net)
 		return -ENOMEM;
 
 	/* Hold the beast until a service is registered */
-	ipvs->enable = 0;
+	WRITE_ONCE(ipvs->enable, 0);
 	ipvs->net = net;
 	/* Counters used for creating unique names */
 	ipvs->gen = atomic_read(&ipvs_netns_cnt);
@@ -2363,7 +2360,7 @@ static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
 		ipvs = net_ipvs(net);
 		ip_vs_unregister_hooks(ipvs, AF_INET);
 		ip_vs_unregister_hooks(ipvs, AF_INET6);
-		ipvs->enable = 0;	/* Disable packet reception */
+		WRITE_ONCE(ipvs->enable, 0);	/* Disable packet reception */
 		smp_wmb();
 		ip_vs_sync_net_cleanup(ipvs);
 	}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ae76542de3e98..c82dcbb4dabce 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -256,7 +256,7 @@ static void est_reload_work_handler(struct work_struct *work)
 		struct ip_vs_est_kt_data *kd = ipvs->est_kt_arr[id];
 
 		/* netns clean up started, abort delayed work */
-		if (!ipvs->enable)
+		if (!READ_ONCE(ipvs->enable))
 			goto unlock;
 		if (!kd)
 			continue;
@@ -1482,9 +1482,9 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 
 	*svc_p = svc;
 
-	if (!ipvs->enable) {
+	if (!READ_ONCE(ipvs->enable)) {
 		/* Now there is a service - full throttle */
-		ipvs->enable = 1;
+		WRITE_ONCE(ipvs->enable, 1);
 
 		/* Start estimation for first time */
 		ip_vs_est_reload_start(ipvs);
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index c5970ba416aea..b48d3a09e2174 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -230,7 +230,7 @@ static int ip_vs_estimation_kthread(void *data)
 void ip_vs_est_reload_start(struct netns_ipvs *ipvs)
 {
 	/* Ignore reloads before first service is added */
-	if (!ipvs->enable)
+	if (!READ_ONCE(ipvs->enable))
 		return;
 	ip_vs_est_stopped_recalc(ipvs);
 	/* Bump the kthread configuration genid */
@@ -304,7 +304,7 @@ static int ip_vs_est_add_kthread(struct netns_ipvs *ipvs)
 	int i;
 
 	if ((unsigned long)ipvs->est_kt_count >= ipvs->est_max_threads &&
-	    ipvs->enable && ipvs->est_max_threads)
+	    READ_ONCE(ipvs->enable) && ipvs->est_max_threads)
 		return -EINVAL;
 
 	mutex_lock(&ipvs->est_mutex);
@@ -341,7 +341,7 @@ static int ip_vs_est_add_kthread(struct netns_ipvs *ipvs)
 	}
 
 	/* Start kthread tasks only when services are present */
-	if (ipvs->enable && !ip_vs_est_stopped(ipvs)) {
+	if (READ_ONCE(ipvs->enable) && !ip_vs_est_stopped(ipvs)) {
 		ret = ip_vs_est_kthread_start(ipvs, kd);
 		if (ret < 0)
 			goto out;
@@ -484,7 +484,7 @@ int ip_vs_start_estimator(struct netns_ipvs *ipvs, struct ip_vs_stats *stats)
 	struct ip_vs_estimator *est = &stats->est;
 	int ret;
 
-	if (!ipvs->est_max_threads && ipvs->enable)
+	if (!ipvs->est_max_threads && READ_ONCE(ipvs->enable))
 		ipvs->est_max_threads = ip_vs_est_max_threads(ipvs);
 
 	est->ktid = -1;
@@ -661,7 +661,7 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
 			/* Wait for cpufreq frequency transition */
 			wait_event_idle_timeout(wq, kthread_should_stop(),
 						HZ / 50);
-			if (!ipvs->enable || kthread_should_stop())
+			if (!READ_ONCE(ipvs->enable) || kthread_should_stop())
 				goto stop;
 		}
 
@@ -679,7 +679,7 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
 		rcu_read_unlock();
 		local_bh_enable();
 
-		if (!ipvs->enable || kthread_should_stop())
+		if (!READ_ONCE(ipvs->enable) || kthread_should_stop())
 			goto stop;
 		cond_resched();
 
@@ -755,7 +755,7 @@ static void ip_vs_est_calc_phase(struct netns_ipvs *ipvs)
 	mutex_lock(&ipvs->est_mutex);
 	for (id = 1; id < ipvs->est_kt_count; id++) {
 		/* netns clean up started, abort */
-		if (!ipvs->enable)
+		if (!READ_ONCE(ipvs->enable))
 			goto unlock2;
 		kd = ipvs->est_kt_arr[id];
 		if (!kd)
@@ -785,7 +785,7 @@ static void ip_vs_est_calc_phase(struct netns_ipvs *ipvs)
 	id = ipvs->est_kt_count;
 
 next_kt:
-	if (!ipvs->enable || kthread_should_stop())
+	if (!READ_ONCE(ipvs->enable) || kthread_should_stop())
 		goto unlock;
 	id--;
 	if (id < 0)
-- 
2.51.0



