Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4D1375ACC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301617; cv=none; b=LrKP65k8deQeeQwO3Fs5062D0aIlSTcyNq03nB6coNFMnWtpToCpzoU2IaVmpHkRkI+PbtmSzXidDPHa+76Qc8Wy+AeETJ291sYyUDHbFRSn4yE1I+6zIYujFK+HWLvhLk7Wpw+on10WMJEKkaAUaZaGBVyE5sstu0/GKforxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301617; c=relaxed/simple;
	bh=yGZKqxwZqNAvDw6/eG7tIVHF31JVbXMYg8xIX/ssY/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMG/qKoC/PGmB5yUTIVotavpIicvpkkGOk0citON9kZD/jjROxQSA5jSDz9tkr9aBwzjoIDfXwrZNykvEAXilzKxHSCGrOPxP9ZunAzwkZzij0xD3RK5rxoT3nCVuDVuxxBCXacvr+AzVjbbw4wMFc9zF2I9pSPni1XrbRkbWiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AliAnph4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AliAnph4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDE0C116D0;
	Sat, 28 Feb 2026 18:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301617;
	bh=yGZKqxwZqNAvDw6/eG7tIVHF31JVbXMYg8xIX/ssY/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AliAnph4/R1j/1em3oreWmVBmAP+ykjg/N2bnt8MSCdrbd0FYH7fdDYDavKBpRaND
	 WedL+scafns/EQVMGjVzulJ0OFLhWnFBsGFIYr927NW3n4rWzvFpKc7A2uMOfK3WsP
	 f95n15O/MqFiqVvYn0NIYNsAJYHuX+C4ef9woyf2BxMvMMrroSK92ym6WwxqTFc90G
	 F4m32NJrA+CUjxwQku+6J/0W3Pz2vMC/uvFF3o4+Qeibe74/Jj+opPUTjv4zSpuEYA
	 keZjgkAYSLpDKmma37grSeLeZPo7yfMJ342BqgCShaahzIQ0zsAQHcnsbov8E9vo9D
	 uvOa55ujsoGMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zqiang <qiang.zhang@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/385] rcu: Remove local_irq_save/restore() in rcu_preempt_deferred_qs_handler()
Date: Sat, 28 Feb 2026 12:53:48 -0500
Message-ID: <20260228180011.1568201-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 42d590d100f2e47e47d974a902b9ed610e464824 ]

The per-CPU rcu_data structure's ->defer_qs_iw field is initialized
by IRQ_WORK_INIT_HARD(), which means that the subsequent invocation of
rcu_preempt_deferred_qs_handler() will always be executed with interrupts
disabled.  This commit therefore removes the local_irq_save/restore()
operations from rcu_preempt_deferred_qs_handler() and adds a call to
lockdep_assert_irqs_disabled() in order to enable lockdep to diagnose
mistaken invocations of this function from interrupts-enabled code.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: d41e37f26b31 ("rcu: Fix rcu_read_unlock() deadloop due to softirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 8a75ddcff8c40..ada3cf2e72fc6 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -626,11 +626,10 @@ notrace void rcu_preempt_deferred_qs(struct task_struct *t)
  */
 static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 {
-	unsigned long flags;
 	struct rcu_data *rdp;
 
+	lockdep_assert_irqs_disabled();
 	rdp = container_of(iwp, struct rcu_data, defer_qs_iw);
-	local_irq_save(flags);
 
 	/*
 	 * If the IRQ work handler happens to run in the middle of RCU read-side
@@ -647,8 +646,6 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 	 */
 	if (rcu_preempt_depth() > 0)
 		WRITE_ONCE(rdp->defer_qs_iw_pending, DEFER_QS_IDLE);
-
-	local_irq_restore(flags);
 }
 
 /*
-- 
2.51.0

