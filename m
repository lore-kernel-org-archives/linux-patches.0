Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E4234AB12;
	Mon, 18 Aug 2025 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525699; cv=none; b=iNMUxksvMCixGe3qK62LW++DjQz0N9NuIAjJHLQYAuvcfdSzmZpJfZ7+fVcGGbJZXRAz/RHmt8TnarIZ6kn/g+/DCP5LDlsjBRDmtMRrzYywtZJXR07hsXan0eltvQlSm4prIDXgKxMYLOKUs/3YStuCVwi+g4vMpxo3UfeW40w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525699; c=relaxed/simple;
	bh=dDjsH4FMrPsfi1oK42WtABQO5wCfEzsP0AtuzmWgxsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZywsG5VHPcdc8yCra8yhcbH1TV9ek36s9pgOP7c8qRRII+8HE9HYoI3lOGWA5PCiU8SBVGZLJwlXVXwKcQvQQllpXyfCBH8iq3O+FYkG3ljXQ1/smgTerqk89HrVNzAA9gj3jBFrHY/lw1SMrGgWXlc/vjBGLNBqiicaHNkM90w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUdfbNst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUdfbNst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E41C4CEEB;
	Mon, 18 Aug 2025 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525699;
	bh=dDjsH4FMrPsfi1oK42WtABQO5wCfEzsP0AtuzmWgxsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUdfbNstw9nhblMBFH9PmvpZzz8j4juJ4fH2RjH0SWmGvTZHaOkOntP4QXxKcEcxZ
	 MLOB1eKuA4KN+9y1ckXYHOyse8VomQ3npfYzfZ7Mh8il4mG2YMzPgBReXt5ftFePLU
	 vVQ4QSyqpVx+ItezDSyRCzrPxq5Uoovd3ZJRNOgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 308/570] rcutorture: Fix rcutorture_one_extend_check() splat in RT kernels
Date: Mon, 18 Aug 2025 14:44:55 +0200
Message-ID: <20250818124517.738636363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 70ec0f21abc3..1d4635f8bb43 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -464,7 +464,7 @@ rcu_read_delay(struct torture_random_state *rrsp, struct rt_read_seg *rtrsp)
 	    !(torture_random(rrsp) % (nrealreaders * 2000 * longdelay_ms))) {
 		started = cur_ops->get_gp_seq();
 		ts = rcu_trace_clock_local();
-		if (preempt_count() & (SOFTIRQ_MASK | HARDIRQ_MASK))
+		if ((preempt_count() & HARDIRQ_MASK) || softirq_count())
 			longdelay_ms = 5; /* Avoid triggering BH limits. */
 		mdelay(longdelay_ms);
 		rtrsp->rt_delay_ms = longdelay_ms;
@@ -1930,7 +1930,7 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
 		return;
 
 	WARN_ONCE((curstate & (RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH)) &&
-		  !(preempt_count() & SOFTIRQ_MASK), ROEC_ARGS);
+		  !softirq_count(), ROEC_ARGS);
 	WARN_ONCE((curstate & (RCUTORTURE_RDR_PREEMPT | RCUTORTURE_RDR_SCHED)) &&
 		  !(preempt_count() & PREEMPT_MASK), ROEC_ARGS);
 	WARN_ONCE(cur_ops->readlock_nesting &&
@@ -1944,7 +1944,7 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
 
 	WARN_ONCE(cur_ops->extendables &&
 		  !(curstate & (RCUTORTURE_RDR_BH | RCUTORTURE_RDR_RBH)) &&
-		  (preempt_count() & SOFTIRQ_MASK), ROEC_ARGS);
+		  softirq_count(), ROEC_ARGS);
 
 	/*
 	 * non-preemptible RCU in a preemptible kernel uses preempt_disable()
@@ -1965,6 +1965,9 @@ static void rcutorture_one_extend_check(char *s, int curstate, int new, int old,
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



