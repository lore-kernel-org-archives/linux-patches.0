Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6F1B6D0F;
	Fri, 13 Dec 2024 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100049; cv=none; b=ZbosxH+OC/s7Y/7YxxrXEkKeqwbrgulHR3pZcUPbjcUdzMz5F0JmUym39TPfTeSiJ1UWaoH4Il87T74xt0+NKOYF0F4I30bn15AYoG13vnhcd3Klv+MM98xOVgpZ7BCh3r1wwjp/yBa+8RlP+TPb0z98SshCmQWrgiPxG8YiBbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100049; c=relaxed/simple;
	bh=/jUn34ql5mWkVGuueM/i8xNwlJ12UWTb6zHcWJ/zXQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayYE/lXSqDiFEdVSn7y2tPDl79MFGT8oghVbDmVzvq/LP89xBVTmtSwHzoKmGtrESgdMCFRH1ffYSHJdcajldMx9vFPGGxevKYHW+c2XM2iC7LR9BKAeVuP/3dL3CMx7z4lefM99IJXkDcV29/gAFLD8zXhCMONGmeRMamQYg9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0OZyb6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0OZyb6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C61C4CED0;
	Fri, 13 Dec 2024 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734100048;
	bh=/jUn34ql5mWkVGuueM/i8xNwlJ12UWTb6zHcWJ/zXQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C0OZyb6L072XqUbNO/12+4r4hQBZtx/86n6FYNzQWqAjoZtCJnaXQYYm5iyJwCR/X
	 PGM41hNXw3VP3wLTa2uOozUHtVtMZjAB5VasREpAtB6N+/597jxgZtAr4VPBstMb9l
	 1JoTSzFg3jYjMJwkXygJT8Pmafifg+uKOzg3j19A=
Date: Fri, 13 Dec 2024 15:27:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 440/466] sched/core: Remove the unnecessary
 need_resched() check in nohz_csd_func()
Message-ID: <2024121358-essence-condition-3312@gregkh>
References: <20241212144306.641051666@linuxfoundation.org>
 <20241212144324.242299901@linuxfoundation.org>
 <d21a8129-e982-463f-af8b-07a14b6a674a@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d21a8129-e982-463f-af8b-07a14b6a674a@amd.com>

On Thu, Dec 12, 2024 at 11:22:25PM +0530, K Prateek Nayak wrote:
> Hello Greg, Sasha,
> 
> On 12/12/2024 8:30 PM, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: K Prateek Nayak <kprateek.nayak@amd.com>
> > 
> > [ Upstream commit ea9cffc0a154124821531991d5afdd7e8b20d7aa ]
> > 
> > The need_resched() check currently in nohz_csd_func() can be tracked
> > to have been added in scheduler_ipi() back in 2011 via commit
> > ca38062e57e9 ("sched: Use resched IPI to kick off the nohz idle balance")
> > 
> > Since then, it has travelled quite a bit but it seems like an idle_cpu()
> > check currently is sufficient to detect the need to bail out from an
> > idle load balancing. To justify this removal, consider all the following
> > case where an idle load balancing could race with a task wakeup:
> > 
> > o Since commit f3dd3f674555b ("sched: Remove the limitation of WF_ON_CPU
> >    on wakelist if wakee cpu is idle") a target perceived to be idle
> >    (target_rq->nr_running == 0) will return true for
> >    ttwu_queue_cond(target) which will offload the task wakeup to the idle
> >    target via an IPI.
> > 
> >    In all such cases target_rq->ttwu_pending will be set to 1 before
> >    queuing the wake function.
> > 
> >    If an idle load balance races here, following scenarios are possible:
> > 
> >    - The CPU is not in TIF_POLLING_NRFLAG mode in which case an actual
> >      IPI is sent to the CPU to wake it out of idle. If the
> >      nohz_csd_func() queues before sched_ttwu_pending(), the idle load
> >      balance will bail out since idle_cpu(target) returns 0 since
> >      target_rq->ttwu_pending is 1. If the nohz_csd_func() is queued after
> >      sched_ttwu_pending() it should see rq->nr_running to be non-zero and
> >      bail out of idle load balancing.
> > 
> >    - The CPU is in TIF_POLLING_NRFLAG mode and instead of an actual IPI,
> >      the sender will simply set TIF_NEED_RESCHED for the target to put it
> >      out of idle and flush_smp_call_function_queue() in do_idle() will
> >      execute the call function. Depending on the ordering of the queuing
> >      of nohz_csd_func() and sched_ttwu_pending(), the idle_cpu() check in
> >      nohz_csd_func() should either see target_rq->ttwu_pending = 1 or
> >      target_rq->nr_running to be non-zero if there is a genuine task
> >      wakeup racing with the idle load balance kick.
> > 
> > o The waker CPU perceives the target CPU to be busy
> >    (targer_rq->nr_running != 0) but the CPU is in fact going idle and due
> >    to a series of unfortunate events, the system reaches a case where the
> >    waker CPU decides to perform the wakeup by itself in ttwu_queue() on
> >    the target CPU but target is concurrently selected for idle load
> >    balance (XXX: Can this happen? I'm not sure, but we'll consider the
> >    mother of all coincidences to estimate the worst case scenario).
> > 
> >    ttwu_do_activate() calls enqueue_task() which would increment
> >    "rq->nr_running" post which it calls wakeup_preempt() which is
> >    responsible for setting TIF_NEED_RESCHED (via a resched IPI or by
> >    setting TIF_NEED_RESCHED on a TIF_POLLING_NRFLAG idle CPU) The key
> >    thing to note in this case is that rq->nr_running is already non-zero
> >    in case of a wakeup before TIF_NEED_RESCHED is set which would
> >    lead to idle_cpu() check returning false.
> > 
> > In all cases, it seems that need_resched() check is unnecessary when
> > checking for idle_cpu() first since an impending wakeup racing with idle
> > load balancer will either set the "rq->ttwu_pending" or indicate a newly
> > woken task via "rq->nr_running".
> > 
> > Chasing the reason why this check might have existed in the first place,
> > I came across  Peter's suggestion on the fist iteration of Suresh's
> > patch from 2011 [1] where the condition to raise the SCHED_SOFTIRQ was:
> > 
> > 	sched_ttwu_do_pending(list);
> > 
> > 	if (unlikely((rq->idle == current) &&
> > 	    rq->nohz_balance_kick &&
> > 	    !need_resched()))
> > 		raise_softirq_irqoff(SCHED_SOFTIRQ);
> > 
> > Since the condition to raise the SCHED_SOFIRQ was preceded by
> > sched_ttwu_do_pending() (which is equivalent of sched_ttwu_pending()) in
> > the current upstream kernel, the need_resched() check was necessary to
> > catch a newly queued task. Peter suggested modifying it to:
> > 
> > 	if (idle_cpu() && rq->nohz_balance_kick && !need_resched())
> > 		raise_softirq_irqoff(SCHED_SOFTIRQ);
> > 
> > where idle_cpu() seems to have replaced "rq->idle == current" check.
> > 
> > Even back then, the idle_cpu() check would have been sufficient to catch
> > a new task being enqueued. Since commit b2a02fc43a1f ("smp: Optimize
> > send_call_function_single_ipi()") overloads the interpretation of
> > TIF_NEED_RESCHED for TIF_POLLING_NRFLAG idling, remove the
> > need_resched() check in nohz_csd_func() to raise SCHED_SOFTIRQ based
> > on Peter's suggestion.
> 
> Since v6.12 added support for PREEMPT_RT, you'll see the following
> warning being triggered when booting with PREEMPT_RT enabled on
> 6.12.5-rc1:
> 
>     ------------[ cut here ]------------
>     WARNING: CPU: 40 PID: 0 at kernel/softirq.c:292 do_softirq_post_smp_call_flush+0x1a/0x40
>     Modules linked in:
>     CPU: 40 UID: 0 PID: 0 Comm: swapper/40 Not tainted 6.12.5-rc1-test+ #220
>     Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS 2.7.3 03/30/2022
>     RIP: 0010:do_softirq_post_smp_call_flush+0x1a/0x40
>     Code: ...
>     RSP: 0018:ffffad4c405cfeb8 EFLAGS: 00010002
>     RAX: 0000000000000080 RBX: 0000000000000282 RCX: 0000000000000007
>     RDX: 0000000000000000 RSI: 0000000000000083 RDI: 0000000000000000
>     RBP: 0000000000000000 R08: ffff942efc626080 R09: 0000000000000001
>     R10: 7fffffffffffffff R11: ffffffffffd2d2da R12: 0000000000000000
>     R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>     FS:  0000000000000000(0000) GS:ffff942efc600000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 0000000000000000 CR3: 000000807da48001 CR4: 0000000000f70ef0
>     PKRU: 55555554
>     Call Trace:
>      <TASK>
>      ? __warn+0x88/0x130
>      ? do_softirq_post_smp_call_flush+0x1a/0x40
>      ? report_bug+0x18e/0x1a0
>      ? handle_bug+0x5b/0xa0
>      ? exc_invalid_op+0x18/0x70
>      ? asm_exc_invalid_op+0x1a/0x20
>      ? do_softirq_post_smp_call_flush+0x1a/0x40
>      ? srso_alias_return_thunk+0x5/0xfbef5
>      flush_smp_call_function_queue+0x65/0x80
>      do_idle+0x149/0x260
>      cpu_startup_entry+0x29/0x30
>      start_secondary+0x12d/0x160
>      common_startup_64+0x13e/0x141
>      </TASK>
>     ---[ end trace 0000000000000000 ]---
> 
> Could you please also include upstream commit 6675ce20046d ("softirq:
> Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel") to the
> 6.12 stable queue to prevent this splat for PREEMPT_RT users.
> 
> Full upstream commit SHA1: 6675ce20046d149e1e1ffe7e9577947dee17aad5
> 
> The commit can be cleanly cherry-picked on top of v6.12.5-rc1 and I can
> confirm that it fixes the splat.

Thanks, I've now queued that up.  You all should have put a "Fixes:" tag
on it so that I would have noticed it automatically...

thanks,

greg k-h
