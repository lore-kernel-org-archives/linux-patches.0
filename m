Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6A11FCFEF;
	Sat, 16 May 2026 10:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778926065; cv=none; b=oJAnpAzWoyN06aCnQ4NObHIj/80m+jW9gU+mTS5zUfrc0w13ISmVB5CCFWaT9o3z6xCrPqNbo7XI73MakbXC4PLvZf0uO8D/PuHUCgNro23AOdt6URnQdVybwPomoJX5p1XHU0tE93jc6jiJpVxx5u+RaOTSpi5xEnPkFTbs4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778926065; c=relaxed/simple;
	bh=RVSVsy49zcCR8JxducCQ8VPQjausu3k80Yu6oLH38VU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZqlEjAbdWN62famukilLKn+aQsH7wu1p+d4fgSbv2peokGWRNOK0NIql0qu9P/saeghGORAHjm5/W4IKpujznqojv96ehoHWz0kUucMUHjbMZEyGfCFDTwScC/MQpUEmJr1oVUCq8gnVllR+MXRYPsSirGu4CNv2qBGatn2WZIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+5dxUKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+5dxUKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D735CC19425;
	Sat, 16 May 2026 10:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778926065;
	bh=RVSVsy49zcCR8JxducCQ8VPQjausu3k80Yu6oLH38VU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+5dxUKrdn9eIlTB8OnO2XqT70gU4pfhZuTCXb166ugWxFMtmfGlh0HfqfC4HF5kf
	 RfHYi3v0c5NGKtHwKB1IDMyfsj9o+ZOUdnMrooNwGPHcI3K2dfD+qlRE+X3LZ7d8yE
	 Xyr/4Mpx3xhLwyvPZKwTcHrr9DXZwq4P3oIyrwsU=
Date: Sat, 16 May 2026 12:07:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>, Tejun Heo <tj@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH 6.18 143/188] sched_ext: Use HK_TYPE_DOMAIN_BOOT to
 detect isolcpus= domain isolation
Message-ID: <2026051633-crepe-enslave-0cdd@gregkh>
References: <20260515154657.309489048@linuxfoundation.org>
 <20260515154700.426346174@linuxfoundation.org>
 <508bf3b7-56c7-4290-b663-7daf8ed4e80d@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <508bf3b7-56c7-4290-b663-7daf8ed4e80d@googlemail.com>

On Sat, May 16, 2026 at 02:48:00AM +0200, Peter Schneider wrote:
> Hi Greg,
> 
> Am 15.05.2026 um 17:49 schrieb Greg Kroah-Hartman:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andrea Righi <arighi@nvidia.com>
> > 
> > commit 6ae315d37924435516d697ea7dde0b799a5928e0 upstream.
> > 
> > scx_enable() refuses to attach a BPF scheduler when isolcpus=domain is
> > in effect by comparing housekeeping_cpumask(HK_TYPE_DOMAIN) against
> > cpu_possible_mask.
> > 
> > Since commit 27c3a5967f05 ("sched/isolation: Convert housekeeping
> > cpumasks to rcu pointers"), HK_TYPE_DOMAIN's cpumask is RCU protected
> > and dereferencing it requires either RCU read lock, the cpu_hotplug
> > write lock, or the cpuset lock; scx_enable() holds none of these, so
> > booting with isolcpus=domain and attaching any BPF scheduler triggers
> > the following lockdep splat:
> > 
> >    =============================
> >    WARNING: suspicious RCU usage
> >    -----------------------------
> >    kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!
> > 
> >    1 lock held by scx_flash/281:
> >     #0: ffffffff8379fce0 (update_mutex){+.+.}-{4:4}, at:
> >         bpf_struct_ops_link_create+0x134/0x1c0
> > 
> >    Call Trace:
> >     dump_stack_lvl+0x6f/0xb0
> >     lockdep_rcu_suspicious.cold+0x37/0x70
> >     housekeeping_cpumask+0xcd/0xe0
> >     scx_enable.isra.0+0x17/0x120
> >     bpf_scx_reg+0x5e/0x80
> >     bpf_struct_ops_link_create+0x151/0x1c0
> >     __sys_bpf+0x1e4b/0x33c0
> >     __x64_sys_bpf+0x21/0x30
> >     do_syscall_64+0x117/0xf80
> >     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > 
> > In addition, commit 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask
> > from cpuset") made HK_TYPE_DOMAIN include cpuset isolated partitions as
> > well, which means the current check also rejects BPF schedulers when a
> > cpuset partition is active. That contradicts the original intent of
> > commit 9f391f94a173 ("sched_ext: Disallow loading BPF scheduler if
> > isolcpus= domain isolation is in effect"), which explicitly noted that
> > cpuset partitions are honored through per-task cpumasks and should not
> > be rejected.
> > 
> > Switch to housekeeping_enabled(HK_TYPE_DOMAIN_BOOT), which reads only
> > the housekeeping flag bit (no RCU dereference) and reflects exactly the
> > boot-time isolcpus= configuration that the error message refers to.
> > 
> > Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
> > Cc: stable@vger.kernel.org # v7.0+
> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Acked-by: Frederic Weisbecker <frederic@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   kernel/sched/ext.c |    3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > --- a/kernel/sched/ext.c
> > +++ b/kernel/sched/ext.c
> > @@ -4906,8 +4906,7 @@ static int scx_enable(struct sched_ext_o
> >   	static DEFINE_MUTEX(helper_mutex);
> >   	struct scx_enable_cmd cmd;
> > -	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
> > -			   cpu_possible_mask)) {
> > +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
> >   		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
> >   		return -EINVAL;
> >   	}
> > 
> > 
> 
> 
> This patch causes a build failure for me:
> 
>   CC      kernel/sched/build_policy.o
> In file included from kernel/sched/build_policy.c:62:
> kernel/sched/ext.c: In function ‘scx_enable’:
> kernel/sched/ext.c:4924:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first
> use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>  4924 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>       |                                  ^~~~~~~~~~~~~~~~~~~
>       |                                  HK_TYPE_DOMAIN
> kernel/sched/ext.c:4924:34: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [scripts/Makefile.build:287: kernel/sched/build_policy.o] Fehler 1
> make[3]: *** [scripts/Makefile.build:544: kernel/sched] Fehler 2
> make[2]: *** [scripts/Makefile.build:544: kernel] Fehler 2
> make[1]: *** [/usr/src/linux-stable-rc/Makefile:2024: .] Fehler 2
> make: *** [Makefile:248: __sub-make] Fehler 2
> root@linus:/usr/src/linux-stable-rc#
> 
> If I revert this patch, the build succeeds, and the kernel boots and seems to work fine without any observable regressions.
> 
> Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Thanks for this, I'll go drop this commit and push out a -rc2

greg k-h
