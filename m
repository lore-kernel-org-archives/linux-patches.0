Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517E271A6D;
	Mon, 18 Aug 2025 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523823; cv=none; b=KFtgu9SMSNBTCeJWBI/jllMgp5zsTMuzGSFuNVNeWKCvrqrLO3xA0FomuY/tJ8pa6LTA8z9M3vxeFNr4TwYOSXRJJ88tAuipx8WM2x04KNjgi0cM82hwrpb11mDBhVgmHPoJoOk46rMXNi6OvZ9q+B5ezTyQR4odmyT5DE+cq7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523823; c=relaxed/simple;
	bh=YRbXaiyrRE6Pq2wctI7WyxzKaz0xZitAAPsf9TBWLe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoeXM51iEKihBHNWqQGRagxxX88pqkWCU6ocaRaawSgr1soLb27c+Sumys5pEH/g4QSACkOaTsNET4gQQeu3TAWnkJV0jyIx/3rOtZv4Q0xBlyRfB5ISmMvNGkyr1gW4D5pgfBCDrLvNTkvo/7Kcl0GUYVS0fX2F0WnMNQi+NqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4yjl+AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4yjl+AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C85C4CEEB;
	Mon, 18 Aug 2025 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523823;
	bh=YRbXaiyrRE6Pq2wctI7WyxzKaz0xZitAAPsf9TBWLe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4yjl+ATqjqa9fruozTrm5qJ830kVbiTQW+rOaUW5ca7Wb11AKS5KsGd2t8wvqDWR
	 Eas5iX6yENAuhWUtWaPG+YZIlUk6P93j0XtSoEidk6Pn9gPuI+g7p0wCvvPDOKW6om
	 RqUmI6aw/BnyXVJ8x98TgTdmLKJzuoYoaLgeefrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 283/515] rcutorture: Fix rcutorture_one_extend_check() splat in RT kernels
Date: Mon, 18 Aug 2025 14:44:29 +0200
Message-ID: <20250818124509.314830070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 8d71351d88e478d3c4e945e3218e97ec677fd807 ]

For built with CONFIG_PREEMPT_RT=y kernels, running rcutorture
tests resulted in the following splat:

[   68.797425] rcutorture_one_extend_check during change: Current 0x1  To add 0x1  To remove 0x0  preempt_count() 0x0
[   68.797533] WARNING: CPU: 2 PID: 512 at kernel/rcu/rcutorture.c:1993 rcutorture_one_extend_check+0x419/0x560 [rcutorture]
[   68.797601] Call Trace:
[   68.797602]  <TASK>
[   68.797619]  ? lockdep_softirqs_off+0xa5/0x160
[   68.797631]  rcutorture_one_extend+0x18e/0xcc0 [rcutorture 2466dbd2ff34dbaa36049cb323a80c3306ac997c]
[   68.797646]  ? local_clock+0x19/0x40
[   68.797659]  rcu_torture_one_read+0xf0/0x280 [rcutorture 2466dbd2ff34dbaa36049cb323a80c3306ac997c]
[   68.797678]  ? __pfx_rcu_torture_one_read+0x10/0x10 [rcutorture 2466dbd2ff34dbaa36049cb323a80c3306ac997c]
[   68.797804]  ? __pfx_rcu_torture_timer+0x10/0x10 [rcutorture 2466dbd2ff34dbaa36049cb323a80c3306ac997c]
[   68.797815] rcu-torture: rcu_torture_reader task started
[   68.797824] rcu-torture: Creating rcu_torture_reader task
[   68.797824]  rcu_torture_reader+0x238/0x580 [rcutorture 2466dbd2ff34dbaa36049cb323a80c3306ac997c]
[   68.797836]  ? kvm_sched_clock_read+0x15/0x30

Disable BH does not change the SOFTIRQ corresponding bits in
preempt_count() for RT kernels, this commit therefore use
softirq_count() to check the if BH is disabled.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 4fa7772be183..a6202cbef9c5 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -458,7 +458,7 @@ rcu_read_delay(struct torture_random_state *rrsp, struct rt_read_seg *rtrsp)
 	    !(torture_random(rrsp) % (nrealreaders * 2000 * longdelay_ms))) {
 		started = cur_ops->get_gp_seq();
 		ts = rcu_trace_clock_local();
-		if (preempt_count() & (SOFTIRQ_MASK | HARDIRQ_MASK))
+		if ((preempt_count() & HARDIRQ_MASK) || softirq_count())
 			longdelay_ms = 5; /* Avoid triggering BH limits. */
 		mdelay(longdelay_ms);
 		rtrsp->rt_delay_ms = longdelay_ms;
@@ -1922,7 +1922,7 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
 		return;
 
 	WARN_ONCE((curstate & (RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH)) &&
-		  !(preempt_count() & SOFTIRQ_MASK), ROEC_ARGS);
+		  !softirq_count(), ROEC_ARGS);
 	WARN_ONCE((curstate & (RCUTORTURE_RDR_PREEMPT | RCUTORTURE_RDR_SCHED)) &&
 		  !(preempt_count() & PREEMPT_MASK), ROEC_ARGS);
 	WARN_ONCE(cur_ops->readlock_nesting &&
@@ -1936,7 +1936,7 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
 
 	WARN_ONCE(cur_ops->extendables &&
 		  !(curstate & (RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH)) &&
-		  (preempt_count() & SOFTIRQ_MASK), ROEC_ARGS);
+		  softirq_count(), ROEC_ARGS);
 
 	/*
 	 * non-preemptible RCU in a preemptible kernel uses preempt_disable()
@@ -1957,6 +1957,9 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
 	if (!IS_ENABLED(CONFIG_PREEMPT_RCU))
 		mask |= RCUTORTURE_RDR_PREEMPT | RCUTORTURE_RDR_SCHED;
 
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && softirq_count())
+		mask |= RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH;
+
 	WARN_ONCE(cur_ops->readlock_nesting && !(curstate & mask) &&
 		  cur_ops->readlock_nesting() > 0, ROEC_ARGS);
 }
-- 
2.39.5



