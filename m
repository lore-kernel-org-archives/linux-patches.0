Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5816249659;
	Mon, 14 Oct 2024 14:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917149; cv=none; b=aC0zbkP74L3HDRGai+tY/GjvKQhsPE6wy83eDvPcN7sA3w+8LeLcygjZkJ6ivB3TgWBb4lHjWVY+oZgutlFcAzB3TsWp8U3KtcUmNQuskeshSWDbqwdzUQiqEXouosencZXr9AdNO+/PNVH2Em3G3BnXvqRn1jDLjpSzblREsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917149; c=relaxed/simple;
	bh=kmOmSPRHKlOoK8DY4dPVnJpRSQd+D1KLUXPFupcJBUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPTeWAT3QHQ6f0+2DuwE9W/VIF9cLQP91tCwyNqR6832cBeur+3Rr8robx+0CFkRD81y9ibDTsCUtt3MV1wRhYEc8Pn8dvK0D8imUEs4SiMZkRY5RaCk0YEg0SWx1gmWScwXSCrNje43tSWO1ZYwaO0jzu9N61BUdzjKyS7aSUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rS36l3DJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rS36l3DJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718E8C4CEC3;
	Mon, 14 Oct 2024 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917148;
	bh=kmOmSPRHKlOoK8DY4dPVnJpRSQd+D1KLUXPFupcJBUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rS36l3DJzs/al31GsT+fRTF82Qbn0KYTIGVaLaxH0n780X516o8Gd7dLPps9kTD2y
	 RaoqenLoTvPW9w8YQHW2LytgS/7OCo/TI+iQuWCYfXEUHcO17YN9iblQeru7iGHNLp
	 LY7FL2BzJtJ0eV2sPjJm1UKCkIDPbCgypuu0kkfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/213] rcu/nocb: Fix rcuog wake-up from offline softirq
Date: Mon, 14 Oct 2024 16:21:11 +0200
Message-ID: <20241014141049.410758881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit f7345ccc62a4b880cf76458db5f320725f28e400 ]

After a CPU has set itself offline and before it eventually calls
rcutree_report_cpu_dead(), there are still opportunities for callbacks
to be enqueued, for example from a softirq. When that happens on NOCB,
the rcuog wake-up is deferred through an IPI to an online CPU in order
not to call into the scheduler and risk arming the RT-bandwidth after
hrtimers have been migrated out and disabled.

But performing a synchronized IPI from a softirq is buggy as reported in
the following scenario:

        WARNING: CPU: 1 PID: 26 at kernel/smp.c:633 smp_call_function_single
        Modules linked in: rcutorture torture
        CPU: 1 UID: 0 PID: 26 Comm: migration/1 Not tainted 6.11.0-rc1-00012-g9139f93209d1 #1
        Stopper: multi_cpu_stop+0x0/0x320 <- __stop_cpus+0xd0/0x120
        RIP: 0010:smp_call_function_single
        <IRQ>
        swake_up_one_online
        __call_rcu_nocb_wake
        __call_rcu_common
        ? rcu_torture_one_read
        call_timer_fn
        __run_timers
        run_timer_softirq
        handle_softirqs
        irq_exit_rcu
        ? tick_handle_periodic
        sysvec_apic_timer_interrupt
        </IRQ>

Fix this with forcing deferred rcuog wake up through the NOCB timer when
the CPU is offline. The actual wake up will happen from
rcutree_report_cpu_dead().

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409231644.4c55582d-lkp@intel.com
Fixes: 9139f93209d1 ("rcu/nocb: Fix RT throttling hrtimer armed from offline CPU")
Reviewed-by: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 7a0bce3f784df..8993b2322be2b 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -568,13 +568,19 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_LAZY,
 					   TPS("WakeLazy"));
-		} else if (!irqs_disabled_flags(flags)) {
+		} else if (!irqs_disabled_flags(flags) && cpu_online(rdp->cpu)) {
 			/* ... if queue was empty ... */
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp(rdp, false);
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
+			/*
+			 * Don't do the wake-up upfront on fragile paths.
+			 * Also offline CPUs can't call swake_up_one_online() from
+			 * (soft-)IRQs. Rely on the final deferred wake-up from
+			 * rcutree_report_cpu_dead()
+			 */
 			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE,
 					   TPS("WakeEmptyIsDeferred"));
-- 
2.43.0



