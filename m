Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FA0279DB6;
	Tue, 12 Aug 2025 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025886; cv=none; b=uklj+yIEXSnA/y8MBjEzGqMa3aL6qGFvAOGB5gL+9Pxj004amsjo/sbMC3UbfEoPhhVklLXEMOTdvNYPEf7K27r75zWF2SUHfD7d+j/ddTQYxCO3penZJ+YcNNeau+Lli6fZqu+R9RGCIhcPmo6MfoYhn0v9vR1f27CNau5v1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025886; c=relaxed/simple;
	bh=uAcezjmTQ88FapaXyvK2jPtLPd9qQzScZS6XOrun6LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5O6/eub+XwWx9jkNGxXqoq91ZgnYlWIoN/C4haTllllILOgjuI+dD9Cc6KZEItGFdIHRj1rT5ZE7uDIRIazBfM6cD8ywoqoSMz6HxoKip7EQmCkPkML4LxW7cJtnFW0YOYcF3JYObN+A9qUfhKoPPZFacJw8Nzr847HRl1gD0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5rgarK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5rgarK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3041C4CEF0;
	Tue, 12 Aug 2025 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025886;
	bh=uAcezjmTQ88FapaXyvK2jPtLPd9qQzScZS6XOrun6LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5rgarK8YwdciBCsAW63YKj/AarFjw2hjLp+r4Bvy88/KhYcNqF9564LaTmSV31jg
	 W/TbuJ5eMxF8DD1VIfuvHnaFLoAzKxTWUvmvJwPzkKDdZdu+z3PVMyfRAPMzQEhoCy
	 TrHEVlDK5vnekLb2y5pvjeK0fn/4tmYK/OacNt38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-jui Wang <cheng-jui.wang@mediatek.com>,
	Lorry.Luo@mediatek.com,
	weiyangyang@vivo.com,
	Tze-nan Wu <Tze-nan.Wu@mediatek.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 173/480] rcu: Fix delayed execution of hurry callbacks
Date: Tue, 12 Aug 2025 19:46:21 +0200
Message-ID: <20250812174404.648651299@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

[ Upstream commit 463d46044f04013306a4893242f65788b8a16b2e ]

We observed a regression in our customer’s environment after enabling
CONFIG_LAZY_RCU. In the Android Update Engine scenario, where ioctl() is
used heavily, we found that callbacks queued via call_rcu_hurry (such as
percpu_ref_switch_to_atomic_rcu) can sometimes be delayed by up to 5
seconds before execution. This occurs because the new grace period does
not start immediately after the previous one completes.

The root cause is that the wake_nocb_gp_defer() function now checks
"rdp->nocb_defer_wakeup" instead of "rdp_gp->nocb_defer_wakeup". On CPUs
that are not rcuog, "rdp->nocb_defer_wakeup" may always be
RCU_NOCB_WAKE_NOT. This can cause "rdp_gp->nocb_defer_wakeup" to be
downgraded and the "rdp_gp->nocb_timer" to be postponed by up to 10
seconds, delaying the execution of hurry RCU callbacks.

The trace log of one scenario we encountered is as follow:
  // previous GP ends at this point
  rcu_preempt   [000] d..1.   137.240210: rcu_grace_period: rcu_preempt 8369 end
  rcu_preempt   [000] .....   137.240212: rcu_grace_period: rcu_preempt 8372 reqwait
  // call_rcu_hurry enqueues "percpu_ref_switch_to_atomic_rcu", the callback waited on by UpdateEngine
  update_engine [002] d..1.   137.301593: __call_rcu_common: wyy: unlikely p_ref = 00000000********. lazy = 0
  // FirstQ on cpu 2 rdp_gp->nocb_timer is set to fire after 1 jiffy (4ms)
  // and the rdp_gp->nocb_defer_wakeup is set to RCU_NOCB_WAKE
  update_engine [002] d..2.   137.301595: rcu_nocb_wake: rcu_preempt 2 FirstQ on cpu2 with rdp_gp (cpu0).
  // FirstBQ event on cpu2 during the 1 jiffy, make the timer postpond 10 seconds later.
  // also, the rdp_gp->nocb_defer_wakeup is overwrite to RCU_NOCB_WAKE_LAZY
  update_engine [002] d..1.   137.301601: rcu_nocb_wake: rcu_preempt 2 WakeEmptyIsDeferred
  ...
  ...
  ...
  // before the 10 seconds timeout, cpu0 received another call_rcu_hurry
  // reset the timer to jiffies+1 and set the waketype = RCU_NOCB_WAKE.
  kworker/u32:0 [000] d..2.   142.557564: rcu_nocb_wake: rcu_preempt 0 FirstQ
  kworker/u32:0 [000] d..1.   142.557576: rcu_nocb_wake: rcu_preempt 0 WakeEmptyIsDeferred
  kworker/u32:0 [000] d..1.   142.558296: rcu_nocb_wake: rcu_preempt 0 WakeNot
  kworker/u32:0 [000] d..1.   142.558562: rcu_nocb_wake: rcu_preempt 0 WakeNot
  // idle(do_nocb_deferred_wakeup) wake rcuog due to waketype == RCU_NOCB_WAKE
  <idle>        [000] d..1.   142.558786: rcu_nocb_wake: rcu_preempt 0 DoWake
  <idle>        [000] dN.1.   142.558839: rcu_nocb_wake: rcu_preempt 0 DeferredWake
  rcuog/0       [000] .....   142.558871: rcu_nocb_wake: rcu_preempt 0 EndSleep
  rcuog/0       [000] .....   142.558877: rcu_nocb_wake: rcu_preempt 0 Check
  // finally rcuog request a new GP at this point (5 seconds after the FirstQ event)
  rcuog/0       [000] d..2.   142.558886: rcu_grace_period: rcu_preempt 8372 newreq
  rcu_preempt   [001] d..1.   142.559458: rcu_grace_period: rcu_preempt 8373 start
  ...
  rcu_preempt   [000] d..1.   142.564258: rcu_grace_period: rcu_preempt 8373 end
  rcuop/2       [000] D..1.   142.566337: rcu_batch_start: rcu_preempt CBs=219 bl=10
  // the hurry CB is invoked at this point
  rcuop/2       [000] b....   142.566352: blk_queue_usage_counter_release: wyy: wakeup. p_ref = 00000000********.

This patch changes the condition to check "rdp_gp->nocb_defer_wakeup" in
the lazy path. This prevents an already scheduled "rdp_gp->nocb_timer"
from being postponed and avoids overwriting "rdp_gp->nocb_defer_wakeup"
when it is not RCU_NOCB_WAKE_NOT.

Fixes: 3cb278e73be5 ("rcu: Make call_rcu() lazy to save power")
Co-developed-by: Cheng-jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Cheng-jui Wang <cheng-jui.wang@mediatek.com>
Co-developed-by: Lorry.Luo@mediatek.com
Signed-off-by: Lorry.Luo@mediatek.com
Tested-by: weiyangyang@vivo.com
Signed-off-by: weiyangyang@vivo.com
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index fa269d34167a..6b3118a4dde3 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -276,7 +276,7 @@ static void wake_nocb_gp_defer(struct rcu_data *rdp, int waketype,
 	 * callback storms, no need to wake up too early.
 	 */
 	if (waketype == RCU_NOCB_WAKE_LAZY &&
-	    rdp->nocb_defer_wakeup == RCU_NOCB_WAKE_NOT) {
+	    rdp_gp->nocb_defer_wakeup == RCU_NOCB_WAKE_NOT) {
 		mod_timer(&rdp_gp->nocb_timer, jiffies + rcu_get_jiffies_lazy_flush());
 		WRITE_ONCE(rdp_gp->nocb_defer_wakeup, waketype);
 	} else if (waketype == RCU_NOCB_WAKE_BYPASS) {
-- 
2.39.5



