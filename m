Received: from mail115-76.sinamail.sina.com.cn (mail115-76.sinamail.sina.com.cn [218.30.115.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F1434DCCD
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 02:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772592591; cv=none; b=p0y173aqWN/OaX5RkBuoHtcBIT3uZ9b7QaKpwobboMZ2ApJgy84bwJRnXDB6wQAHFs5zcWg7jNnFy5KHD4MlZSEbNdf+Hmy5szoWFXP95eFlavf03eZYYzpQFO+aVxYmF4eQkcOdvrvIMk1z9kCEabAwlhRjx3TfzqkBT0/ywTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772592591; c=relaxed/simple;
	bh=H70FKmd6xMQBDIFHkrijaB1YoLEtsVUcNOqcqI/LXPg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XvWey4Y50jFKpDQJco9xdsd1S2w83WioxA0w2hqOfiJVSfLRvVDCUvyQUdO2eABeFmuitCVPdbTLX9XWCoZyQvlKnmrHNzMF97RcLQw4/Jv5j0Ev5KtZgQAqmPmG1cmIZNYXq6qz3HBV48n/oma3wSltN7EqRKUJ5lnYdInpzgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=KPFEeInt; arc=none smtp.client-ip=218.30.115.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="KPFEeInt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1772592588;
	bh=pz66RA33n115wePk+1z6PHB25yLmCnUhJIHAE3UThro=;
	h=From:Subject:Date:Message-Id;
	b=KPFEeIntlSoa8W20mNzr0p9PGn+f7vZbUgr3AME1SRs5xJw9+z/NHDU3FXpF1QwOs
	 flAuKWpYPQTrQw76p5AuhYpzpGtnSN1xwBK8mWxWybAwL7ymgztcF2/k6ewjXJ1vBi
	 pCNSJvqM73t93a28ntbdxo+C438NKUVjF6MUzVJU=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 69A79DBE00005C83; Wed, 4 Mar 2026 10:49:37 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 790547602323
X-SMAIL-UIID: E1E0329692F345BC87094A53C08E7C58-20260304-104937-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	qiang.zhang1211@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	paulmck@kernel.org,
	frederic@kernel.org,
	quic_neeraju@quicinc.com,
	josh@joshtriplett.org,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	joel@joelfernandes.org,
	rcu@vger.kernel.org,
	neeraj.upadhyay@kernel.org
Subject: [PATCH 6.1.y] rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access
Date: Wed,  4 Mar 2026 10:49:34 +0800
Message-Id: <20260304024934.2364383-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 1bba3900ca18bdae28d1b9fa10f16a8f8cb2ada1 ]

In the preparation stage of CPU online, if the corresponding
the rdp's->nocb_cb_kthread does not exist, will be created,
there is a situation where the rdp's rcuop kthreads creation fails,
and then de-offload this CPU's rdp, does not assign this CPU's
rdp->nocb_cb_kthread pointer, but this rdp's->nocb_gp_rdp and
rdp's->rdp_gp->nocb_gp_kthread is still valid.

This will cause the subsequent re-offload operation of this offline
CPU, which will pass the conditional check and the kthread_unpark()
will access invalid rdp's->nocb_cb_kthread pointer.

This commit therefore use rdp's->nocb_gp_kthread instead of
rdp_gp's->nocb_gp_kthread for safety check.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 kernel/rcu/tree_nocb.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 7c28d154b094..2f501de7bec9 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1112,7 +1112,6 @@ static long rcu_nocb_rdp_offload(void *arg)
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
@@ -1122,7 +1121,7 @@ static long rcu_nocb_rdp_offload(void *arg)
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1151,7 +1150,7 @@ static long rcu_nocb_rdp_offload(void *arg)
 	 */
 	wake_gp = rdp_offload_toggle(rdp, true, flags);
 	if (wake_gp)
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		wake_up_process(rdp->nocb_gp_kthread);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB) &&
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_GP));
-- 
2.34.1

