Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9E1F9DA;
	Mon, 14 Oct 2024 14:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916326; cv=none; b=FpBCT8IBBTSSNqpD27qvr0914wuKa+1hG6IQDFCOT0tNLo6gXlzyiASePGKudzu5x1qwXnFNG5w14fuUletpVU36tGwPoJwtAbomGHlJxlLXPGOeHAoS1g39Q/wNXY2P3T29GpkOLq/bLv+I8bucm3TGRU4WPvLzSDwdsb9opHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916326; c=relaxed/simple;
	bh=Fz3KUIMSTFe0DXN960jm6UVPvp6bisieyyCFoH89wqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVRhr1muyCY3u7w7xb8+i+UwxOalXXWhBYTvWuzTt8Q2xHx8wrTWw+DLcujCsyqo3cBtiFpUFso/BtZejshnK+ZrEZpQypDNBc2HsVodCILSeLiYt3bB94pKi9dRjlTnMZ2/IvDTGLN5RcGCG/mXuhCZ+In/xBhipqfBIT27ZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4Mhtgj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4Mhtgj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875C7C4CEC7;
	Mon, 14 Oct 2024 14:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916325;
	bh=Fz3KUIMSTFe0DXN960jm6UVPvp6bisieyyCFoH89wqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4Mhtgj6FtkXPCDZRCfpOVSIXkbz3CPWAKOYxL4aqRofH9U3JUxCNal4QIVJTBbqt
	 fZdY07jroRmGE3CDkMrg+7wt8JBoIIhVIryTHbF5/8InXYziUvRVfFeYBqfNepfS0D
	 PEbfnWl1pY2FEyr9g/tfZjWdfNuw3Y1i/gCPwS2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 150/214] rcu/nocb: Fix rcuog wake-up from offline softirq
Date: Mon, 14 Oct 2024 16:20:13 +0200
Message-ID: <20241014141050.840850530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2686ba122fa08..3630f712358e4 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -569,13 +569,19 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
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



