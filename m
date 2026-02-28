Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C3383C73
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302037; cv=none; b=Ck7JMV1QCPDje/M2WuijxcoIwJwCC1fEKQBJRi1bemTbRcg+G+37+jQvFRkbME4e9tAXDITvMDYNNF6hLYBoa6ZN8XW9oEBF2ZHOFE/wdClDEEDvFT1Tzf8IrMdiAXXE4g2FxupeRu3++TBRMXOwEU1IftQ3twicbJiK6SrGndY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302037; c=relaxed/simple;
	bh=0WbJmtqEUkuLfMrMfDeFtpQOYsaj66svCnqqn1wYhx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giB740iyjibYcUakFD5A1RKKjfPavVxzFDUJKJtkj3W5wKlrZFCOD+ONwAnM3JWTOF0+NA2L1S8hjiEObRKM0sInf5yl6uQIst2mr/BBeC5J6B2nl6rw4Xbbv/7DyOQzkeptEP/v/46hwcmnnRunnf3DckVzgjlP8/5BnDsckD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beWfAGe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beWfAGe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA91C19425;
	Sat, 28 Feb 2026 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302036;
	bh=0WbJmtqEUkuLfMrMfDeFtpQOYsaj66svCnqqn1wYhx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beWfAGe0a9ZlNnTmH0Py0e0tFfer3M+YmQqlS3O6vhGkmv15PWzstQMca5Q+pTxrA
	 NUy+2TX8os209J7xqq4rk3NL7dSKw4R3o6tCW2ZE24f+3FlrS9VbHSWvWL5Cpv+vMI
	 o0GB9KNqLRtcp60gRaTkCyInUtR6EYn0dWhgzIAtTYjPB9AoodjOVMZwMvg6VXEdgI
	 YKdFFMyNhGBKsOQM99mZlDFoCe9t6AmPr44jajIq50N/O+sFSsSK1Yvvf2YkK++O5m
	 2DO+yGK+ZVEnwKzN2EaPVD7eYRpjyM1THew46TO6NiDXJ9ybxbRGNymxLif5W1AE4T
	 arPMIfLmB2iLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zqiang <qiang.zhang@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/283] rcu: Remove local_irq_save/restore() in rcu_preempt_deferred_qs_handler()
Date: Sat, 28 Feb 2026 13:02:30 -0500
Message-ID: <20260228180709.1583486-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 18a8fd116fdff..04044b492cc31 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -615,11 +615,10 @@ notrace void rcu_preempt_deferred_qs(struct task_struct *t)
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
@@ -636,8 +635,6 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 	 */
 	if (rcu_preempt_depth() > 0)
 		WRITE_ONCE(rdp->defer_qs_iw_pending, DEFER_QS_IDLE);
-
-	local_irq_restore(flags);
 }
 
 /*
-- 
2.51.0

