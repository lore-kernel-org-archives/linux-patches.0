Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A727A13B78F;
	Tue, 27 Feb 2024 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042942; cv=none; b=ZMaW+KlgeQLOGMVbj0pCXGKLgVdllPvXqbOJxCD5gwuDdP187WY9bx3Jm2lYCnD64xYoQhYjvMRSdcT4JWt1cIKSSyY7Q+ciDPi2XdBKOANLN+hkx/hnxMAWv3uoyTt156yo2PKkzL/2aiEIkYIKWFZyJFCG+W8SD3eKA+XTlDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042942; c=relaxed/simple;
	bh=kI8lAR1ifJgHaTZQjea7XCRWt1WGFDnrTt0z2mVjNIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi4Lo9Wtw8od5Kfoct7WoFqjnMusRp/vdeQHC80EJJkrBURQOeT5hFTTSMtidtBQw4/Syofw7y3w9OGOkktWKbiNLyZKM56EVjWbESuX+DBYhCMPO1Ax6jEAl3JMdlV8x4yGyNLaZsNYwiCgUkUAqaws4wRqhvO7J+sSf3Toi58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8BPXpB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8BPXpB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36582C433C7;
	Tue, 27 Feb 2024 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042942;
	bh=kI8lAR1ifJgHaTZQjea7XCRWt1WGFDnrTt0z2mVjNIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8BPXpB1xclp7ECD4OeLqf2wiqEpZVbv0YRbEBjS/EspTTlnui6iMGhVPkEgYD4dt
	 F3HIlEnpU4N3F3p7dbOvIZr7RJk/gzOU2dbIAGtTVQ453/E9uO+ebVpR4UKniQQgmP
	 J4BvFBc8gROtXinSverzfTGkd5VfIN3qO4tSWg30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Yicong Yang <yangyicong@hisilicon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/245] sched/fair: Dont balance task to its current running CPU
Date: Tue, 27 Feb 2024 14:26:04 +0100
Message-ID: <20240227131620.927644749@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 0dd37d6dd33a9c23351e6115ae8cdac7863bc7de ]

We've run into the case that the balancer tries to balance a migration
disabled task and trigger the warning in set_task_cpu() like below:

 ------------[ cut here ]------------
 WARNING: CPU: 7 PID: 0 at kernel/sched/core.c:3115 set_task_cpu+0x188/0x240
 Modules linked in: hclgevf xt_CHECKSUM ipt_REJECT nf_reject_ipv4 <...snip>
 CPU: 7 PID: 0 Comm: swapper/7 Kdump: loaded Tainted: G           O       6.1.0-rc4+ #1
 Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS V5.B221.01 12/09/2021
 pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : set_task_cpu+0x188/0x240
 lr : load_balance+0x5d0/0xc60
 sp : ffff80000803bc70
 x29: ffff80000803bc70 x28: ffff004089e190e8 x27: ffff004089e19040
 x26: ffff007effcabc38 x25: 0000000000000000 x24: 0000000000000001
 x23: ffff80000803be84 x22: 000000000000000c x21: ffffb093e79e2a78
 x20: 000000000000000c x19: ffff004089e19040 x18: 0000000000000000
 x17: 0000000000001fad x16: 0000000000000030 x15: 0000000000000000
 x14: 0000000000000003 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000001 x10: 0000000000000400 x9 : ffffb093e4cee530
 x8 : 00000000fffffffe x7 : 0000000000ce168a x6 : 000000000000013e
 x5 : 00000000ffffffe1 x4 : 0000000000000001 x3 : 0000000000000b2a
 x2 : 0000000000000b2a x1 : ffffb093e6d6c510 x0 : 0000000000000001
 Call trace:
  set_task_cpu+0x188/0x240
  load_balance+0x5d0/0xc60
  rebalance_domains+0x26c/0x380
  _nohz_idle_balance.isra.0+0x1e0/0x370
  run_rebalance_domains+0x6c/0x80
  __do_softirq+0x128/0x3d8
  ____do_softirq+0x18/0x24
  call_on_irq_stack+0x2c/0x38
  do_softirq_own_stack+0x24/0x3c
  __irq_exit_rcu+0xcc/0xf4
  irq_exit_rcu+0x18/0x24
  el1_interrupt+0x4c/0xe4
  el1h_64_irq_handler+0x18/0x2c
  el1h_64_irq+0x74/0x78
  arch_cpu_idle+0x18/0x4c
  default_idle_call+0x58/0x194
  do_idle+0x244/0x2b0
  cpu_startup_entry+0x30/0x3c
  secondary_start_kernel+0x14c/0x190
  __secondary_switched+0xb0/0xb4
 ---[ end trace 0000000000000000 ]---

Further investigation shows that the warning is superfluous, the migration
disabled task is just going to be migrated to its current running CPU.
This is because that on load balance if the dst_cpu is not allowed by the
task, we'll re-select a new_dst_cpu as a candidate. If no task can be
balanced to dst_cpu we'll try to balance the task to the new_dst_cpu
instead. In this case when the migration disabled task is not on CPU it
only allows to run on its current CPU, load balance will select its
current CPU as new_dst_cpu and later triggers the warning above.

The new_dst_cpu is chosen from the env->dst_grpmask. Currently it
contains CPUs in sched_group_span() and if we have overlapped groups it's
possible to run into this case. This patch makes env->dst_grpmask of
group_balance_mask() which exclude any CPUs from the busiest group and
solve the issue. For balancing in a domain with no overlapped groups
the behaviour keeps same as before.

Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230530082507.10444-1-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd8b5656641b7..b55d51b4105cd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10177,7 +10177,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.sd		= sd,
 		.dst_cpu	= this_cpu,
 		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_span(sd->groups),
+		.dst_grpmask    = group_balance_mask(sd->groups),
 		.idle		= idle,
 		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
-- 
2.43.0



