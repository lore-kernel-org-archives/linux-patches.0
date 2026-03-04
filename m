Received: from mail115-79.sinamail.sina.com.cn (mail115-79.sinamail.sina.com.cn [218.30.115.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3C23537DD
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772593053; cv=none; b=hLMOHVaRl/TPXihQVhKsgVHzYNlkSNlU5k1OeWv+OHiGpz/deGkbkkvGO7vQt9WOcgx616QgYl+qEdQJSuCLLBJKY61LUqseUwDe5Qr5Z/cxdKCf9yi+FPfvE0Ehd5sKI1Q4VAW/8IXVDs+1cHnvz0QdIEhG8MKT42qN4K6pOHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772593053; c=relaxed/simple;
	bh=qkeRbo78B+2gM+r2nbeXSUfeM0u2W8lSayzGSDjRBRc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=alReXCWbkZiSSSG2cu0H8YPHue62v4qh453hnq8OQ7qodbBOnPTR4MBDMgD8hQRYsAxeYJ2d+gjPcRi1NskrntEQ2NEQW0seD6zkVbO0iLO2h3f/qaNfekFNcaULbbp534PANmvAnLPuPiPbmz9suzpgaeVqM+G7AI7KspolA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=Wh2MP7Fu; arc=none smtp.client-ip=218.30.115.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="Wh2MP7Fu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1772593049;
	bh=DCsWQhNqFPEinGuq6D8087JmXqNHHQaNhOmiVDfpepM=;
	h=From:Subject:Date:Message-Id;
	b=Wh2MP7FuVtwFGixupGwVwA24K0+RckFi3fPlIya9nqsUY3ppc+gBaU+yitdC2Lhda
	 PjwwEOm78x4xox73A4PRssuwmI+VHqvJf7c4m7m1MrUweDefX+5A2Of5uX3+5FI04r
	 Y+usc50onLmq/QSkDu0SeVCr6VI8yfC3bnmvFmx8=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 69A79F9400002FF7; Wed, 4 Mar 2026 10:57:26 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 7820897602635
X-SMAIL-UIID: 7B04746125BA4BD6BB653162830FBA2D-20260304-105726-1
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
Subject: [PATCH 6.6.y] rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access
Date: Wed,  4 Mar 2026 10:57:24 +0800
Message-Id: <20260304025724.2365669-1-jianqkang@sina.cn>
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
index 8993b2322be2..a3d613f063a8 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1221,7 +1221,6 @@ static long rcu_nocb_rdp_offload(void *arg)
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
@@ -1231,7 +1230,7 @@ static long rcu_nocb_rdp_offload(void *arg)
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1260,7 +1259,7 @@ static long rcu_nocb_rdp_offload(void *arg)
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

