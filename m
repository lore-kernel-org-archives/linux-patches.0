Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFAC3E493
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGLoGxYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43952C433CA;
	Wed, 11 Oct 2023 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697041896;
	bh=FGA8gM4FeYE4IWyx429Dya7HEFgaNp50J+X1XqE49q8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=VGLoGxYihF/YYfew9Ft1kVSjBHObtFNw5bKvSrYo98+Qn+61pehsVyPIUnOEwN0hS
	 EwAD2BQWoOzwjuwQGShhSeizFMKMyLNXFwxtwN6I9nPnMIR2wRxk83BoTTXHVUSv6e
	 AOhNH8xNcRKEoULOJe5HnJt+KvSLrBC0csomVujidH1b+6pfMVhsSGtY28Ll8PDjk1
	 ik33X3N0RSINRmps91GGkcxrcsJLizPNhDf7eTKMezNOnm0IrumVHabo7dd0BSph3O
	 RjeqEBIKaxn85DieIibabR+HwOndWQrXIgbu/aoi31pbuOPe/kwxSa+q6P0KCoedQW
	 r53uBsdnIY7SA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E681ECE0AD4; Wed, 11 Oct 2023 09:31:35 -0700 (PDT)
Date: Wed, 11 Oct 2023 09:31:35 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Chengming Zhou <zhouchengming@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Ingo Molnar <mingo@kernel.org>, rcu <rcu@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Message-ID: <273869c3-ba4b-4173-a14e-bd201d900079@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20231004175203.943277832@linuxfoundation.org>
 <CA+G9fYunnEUT2evdabX1KOTiryP1heNHWDH4LWZCt2SVRmnKOA@mail.gmail.com>
 <20231006162038.d3q7sl34b4ouvjxf@revolver>
 <57c1ff4d-f138-4f89-8add-c96fb3ba6701@paulmck-laptop>
 <20231006175714.begtgj6wrs46ukmo@revolver>
 <7652477c-a37c-4509-9dc9-7f9d1dc08291@paulmck-laptop>
 <CAEXW_YS16NxPxg52T=3FcyZ2qocj36zKyhPnEQL3nBTbD-qJ-A@mail.gmail.com>
 <9470dab6-dee5-4505-95a2-f6782b648726@paulmck-laptop>
 <433f5823-059c-4b51-8d18-8b356a5a507f@paulmck-laptop>
 <ZSana69n6RWgCnqi@localhost.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZSana69n6RWgCnqi@localhost.localdomain>

On Wed, Oct 11, 2023 at 03:47:23PM +0200, Frederic Weisbecker wrote:
> Le Tue, Oct 10, 2023 at 06:34:35PM -0700, Paul E. McKenney a écrit :
> > If this problem is real, fixes include:
> > 
> > o	Revert Liam's patch and make Tiny RCU's call_rcu() deal with
> > 	the problem.  This is overhead and non-tinyness, but to Joel's
> > 	point, it might be best.
> 
> But what is calling call_rcu() or start_poll_synchronize_rcu() so
> early that the CPU is not even online? (that's before boot_cpu_init() !)
> 
> Deferring PF_IDLE setting might pave the way for more issues like this one,
> present or future. Though is_idle_task() returning true when the task is not
> in the idle loop but is playing the init/0 role is debatable.
> 
> An alternative for tiny RCU is to force waking up ksoftirqd when call_rcu()
> is in the idle task. Since rcu_qs() during the context switch raises a softirq
> anyway. It's more overhead for start_poll_synchronize_rcu() though but do we
> expect much RCU polling in idle?

Nice!!!

This does solve the original problem with little or no additional overhead
(perhaps even with decreased overhead), and avoids the other RCU Tasks
issues.

						Thanx, Paul

> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index a92bce40b04b..6ab15233e2be 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -604,6 +604,7 @@ extern void __raise_softirq_irqoff(unsigned int nr);
>  
>  extern void raise_softirq_irqoff(unsigned int nr);
>  extern void raise_softirq(unsigned int nr);
> +extern void raise_ksoftirqd_irqsoff(unsigned int nr);
>  
>  DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
>  
> diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
> index 42f7589e51e0..872dab8b8b53 100644
> --- a/kernel/rcu/tiny.c
> +++ b/kernel/rcu/tiny.c
> @@ -189,12 +189,12 @@ void call_rcu(struct rcu_head *head, rcu_callback_t func)
>  	local_irq_save(flags);
>  	*rcu_ctrlblk.curtail = head;
>  	rcu_ctrlblk.curtail = &head->next;
> -	local_irq_restore(flags);
>  
>  	if (unlikely(is_idle_task(current))) {
>  		/* force scheduling for rcu_qs() */
> -		resched_cpu(0);
> +		raise_ksoftirqd_irqsoff(RCU_SOFTIRQ);
>  	}
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu);
>  
> @@ -225,10 +225,13 @@ EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
>  unsigned long start_poll_synchronize_rcu(void)
>  {
>  	unsigned long gp_seq = get_state_synchronize_rcu();
> +	unsigned long flags;
>  
>  	if (unlikely(is_idle_task(current))) {
> +		local_irq_save(flags);
>  		/* force scheduling for rcu_qs() */
> -		resched_cpu(0);
> +		raise_ksoftirqd_irqsoff(RCU_SOFTIRQ);
> +		local_irq_restore(flags);
>  	}
>  	return gp_seq;
>  }
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 210cf5f8d92c..ef105cbdc705 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -695,6 +695,14 @@ void __raise_softirq_irqoff(unsigned int nr)
>  	or_softirq_pending(1UL << nr);
>  }
>  
> +#ifdef CONFIG_RCU_TINY
> +void raise_ksoftirqd(unsigned int nr)
> +{
> +	__raise_softirq_irqoff(nr);
> +	wakeup_softirqd();
> +}
> +#endif
> +
>  void open_softirq(int nr, void (*action)(struct softirq_action *))
>  {
>  	softirq_vec[nr].action = action;
> 
> 
> 
> 
