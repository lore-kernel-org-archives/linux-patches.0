Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC0A3C3F
	for <patches@lists.linux.dev>; Mon, 31 Jul 2023 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hBRR22FR8xNmWXNrInZaMZd2O22yY7rJ14heZ6BFuXM=; b=fGt7jYCs/IPvjJg40gtRSIE2jB
	OJtBP1HPRrqnMMBKQ1UoDiX3A73Ujo2SM29Ny0bnigJY2dvcEyb53TmZAmM9mGb+fwDX185u6/EwB
	1rRwH8h/4oO4jCVcyrPI42jkCNBv/WvyROGOw5l8ygezj3/Z1COsjeNRxRVrGEUsuFGvZzE5XB81z
	NIbtuyqQ/7P+Ak/Ea69jN3GQnGPdBjJJ1/ViHxkgXOY086MP5cL+fQIPqlRpexthkQ1BRrQreSoRF
	npTAG+rqB+DHG2NTqr/Us0e71/uQbKwh98V+mE8K35ZfuYglA/vKh433ywQyDy2FyQLT6Ox+OCl20
	ubryZZ/g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qQU3u-0029vR-IY; Mon, 31 Jul 2023 14:39:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 77135300134;
	Mon, 31 Jul 2023 16:39:54 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5F0D020165060; Mon, 31 Jul 2023 16:39:54 +0200 (CEST)
Date: Mon, 31 Jul 2023 16:39:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Joel Fernandes <joel@joelfernandes.org>, paulmck@kernel.org,
	Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	rcu@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: scheduler problems in -next (was: Re: [PATCH 6.4 000/227]
 6.4.7-rc1 review)
Message-ID: <20230731143954.GB37820@hirez.programming.kicks-ass.net>
References: <2cfc68cc-3a2f-4350-a711-ef0c0d8385fd@paulmck-laptop>
 <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
 <3da81a5c-700b-8e21-1bde-27dd3a0b8945@roeck-us.net>
 <20230731141934.GK29590@hirez.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731141934.GK29590@hirez.programming.kicks-ass.net>

On Mon, Jul 31, 2023 at 04:19:34PM +0200, Peter Zijlstra wrote:
> On Sat, Jul 29, 2023 at 09:00:02PM -0700, Guenter Roeck wrote:
> > On 7/27/23 16:18, Joel Fernandes wrote:
> > 
> > [ ... ]
> > 
> > > > I freely confess that I am having a hard time imagining what would
> > > > be CPU dependent in that code.  Timing, maybe?  Whatever the reason,
> > > > I am not seeing these failures in my testing.
> > > > 
> > > > So which of the following Kconfig options is defined in your .config?
> > > > CONFIG_TASKS_RCU, CONFIG_TASKS_RUDE_RCU, and CONFIG_TASKS_TRACE_RCU.
> > > > 
> > > > If you have more than one of them, could you please apply this patch
> > > > and show me the corresponding console output from the resulting hang?
> > > 
> > > FWIW, I am not able to repro this issue either. If a .config can be shared of the problem system, I can try it out to see if it can be reproduced on my side.
> > > 
> > 
> > I managed to bisect the problem. See bisect log below. Bisect repeated twice.
> > so it should be reliable. I don't really understand it, but the following
> > reverts fix the problem. This is on top of next-20230721 because next-20230728
> > crashes immediately in my tests.
> > 
> > 0caafe9b94ab (HEAD) Revert "sched/fair: Remove sched_feat(START_DEBIT)"
> > 518bdbd39fdb Revert "sched/fair: Add lag based placement"
> > a011162c3e32 Revert "sched/fair: Implement an EEVDF-like scheduling policy"
> > df579720bf98 Revert "sched/fair: Commit to lag based placement"
> > aac459a7e738 Revert "sched/smp: Use lag to simplify cross-runqueue placement"
> > 8d686eb173e1 Revert "sched/fair: Commit to EEVDF"
> > 486474c50f95 Revert "sched/debug: Rename sysctl_sched_min_granularity to sysctl_sched_base_slice"
> > 79e94d67d08a Revert "sched/fair: Propagate enqueue flags into place_entity()"
> > ae867bc97b71 (tag: next-20230721) Add linux-next specific files for 20230721
> > 
> > For context: x86 images (32 and 64 bit) in -next tend to hang at
> > 
> > [    2.309323] RCU Tasks: Setting shift to 0 and lim to 1 rcu_task_cb_adjust=1.
> > [    2.311634] Running RCU-tasks wait API self tests
> > 
> > The hang is not seen with every boot; it happens roughly about once every
> > 10 boot attempts. It is not CPU dependent as I initially thought.
> > 
> > Configuration file is at http://server.roeck-us.net/qemu/x86-next/config.
> > Example qemu command line:
> 
> Hurmph, let me see if I can reproduce on next-20230731 (not having the
> older next thingies around).

I've taken your config above, and the rootfs.ext2 and run-sh from x86/.
I've then modified run-sh to use:

  qemu-system-x86_64 -enable-kvm -cpu host

What I'm seeing is that some boots get stuck at:

[    0.608230] Running RCU-tasks wait API self tests

Is this the right 'problem' ?

