Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F05142624;
	Thu, 11 Apr 2024 10:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830213; cv=none; b=oVph5+bLiYif2ndhoyAOHq+rE95c3UFq8mjxBZ54evC4KT2q7Kh7dT9VOo9Ocinq3wW8FPv/obikP1NsAhfLV4vsgdHBTYgq+ZqCcJiQDwWr9v09LxFi627GezoMe7u1zR4MuqDq1F8yId18MOvvl7V2s8L3Nnj+jzq958WhdsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830213; c=relaxed/simple;
	bh=vdgNzU18Ars3YX0l3Jaan7p/zEq+KU1OTmZDOMpSxR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0dXtGCCrO8mMz/6iWNPjV3Pz5pukdph2Pgo2bgYsI0D2x7yxL9gR4Utkmtdz5OCzAq5l6Z7tJZFxpjiFB64ghZJtEUwVmJEB9FHelGc6LOA1xk3RifgKPRF58iezBoBIonoX50G+QiJzx3FfVlmkI5781G1HtglYeCTZQQZqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6XH4T7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6XH4T7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F35EC433F1;
	Thu, 11 Apr 2024 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830213;
	bh=vdgNzU18Ars3YX0l3Jaan7p/zEq+KU1OTmZDOMpSxR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6XH4T7JoKRuQNRWicYr7T8T0xN8uJ5gxRdhz83As3VwnBEvDEBy8G6ytnD4PgEyR
	 nrdgn1f/16RHS2xAkmmHmO+/uayzlZY+DEPY2ek5X/bUtR5aLlTicX4/lupeGQrIYM
	 +wqW2NW+YAgErsDaf8K51P0iDwrTbT4yHAKC4bws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/143] rcu/nocb: Fix WARN_ON_ONCE() in the rcu_nocb_bypass_lock()
Date: Thu, 11 Apr 2024 11:55:41 +0200
Message-ID: <20240411095423.111499543@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit dda98810b552fc6bf650f4270edeebdc2f28bd3f ]

For the kernels built with CONFIG_RCU_NOCB_CPU_DEFAULT_ALL=y and
CONFIG_RCU_LAZY=y, the following scenarios will trigger WARN_ON_ONCE()
in the rcu_nocb_bypass_lock() and rcu_nocb_wait_contended() functions:

        CPU2                                               CPU11
kthread
rcu_nocb_cb_kthread                                       ksys_write
rcu_do_batch                                              vfs_write
rcu_torture_timer_cb                                      proc_sys_write
__kmem_cache_free                                         proc_sys_call_handler
kmemleak_free                                             drop_caches_sysctl_handler
delete_object_full                                        drop_slab
__delete_object                                           shrink_slab
put_object                                                lazy_rcu_shrink_scan
call_rcu                                                  rcu_nocb_flush_bypass
__call_rcu_commn                                            rcu_nocb_bypass_lock
                                                            raw_spin_trylock(&rdp->nocb_bypass_lock) fail
                                                            atomic_inc(&rdp->nocb_lock_contended);
rcu_nocb_wait_contended                                     WARN_ON_ONCE(smp_processor_id() != rdp->cpu);
 WARN_ON_ONCE(atomic_read(&rdp->nocb_lock_contended))                                          |
                            |_ _ _ _ _ _ _ _ _ _same rdp and rdp->cpu != 11_ _ _ _ _ _ _ _ _ __|

Reproduce this bug with "echo 3 > /proc/sys/vm/drop_caches".

This commit therefore uses rcu_nocb_try_flush_bypass() instead of
rcu_nocb_flush_bypass() in lazy_rcu_shrink_scan().  If the nocb_bypass
queue is being flushed, then rcu_nocb_try_flush_bypass will return
directly.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 4efbf7333d4e1..d430b4656f59e 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1383,7 +1383,7 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			rcu_nocb_unlock_irqrestore(rdp, flags);
 			continue;
 		}
-		WARN_ON_ONCE(!rcu_nocb_flush_bypass(rdp, NULL, jiffies, false));
+		rcu_nocb_try_flush_bypass(rdp, jiffies);
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		wake_nocb_gp(rdp, false);
 		sc->nr_to_scan -= _count;
-- 
2.43.0



