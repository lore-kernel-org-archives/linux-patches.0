Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27A13346A0;
	Sat, 23 May 2026 09:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779528091; cv=none; b=RhkHLhjiP9IAEmI/pnq+7ORAOMQ+ugnGPpsTXRQytG/ez+OU93CcmRp7bJn/DAXdV0OQ+zKIkOhAN72cg7YFAct73v102aKDG6qKZIARgrJBopcQ4T68i7Mbk66d1qtUoUutCGxo9do11y5qCIZlXv+LeVIJHR3si9tg10nwCF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779528091; c=relaxed/simple;
	bh=RVcjqb9kfHrVuON9NigKW5XiLMIt39PZAS3lt1QUFYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AijestMAd125b3CETIrr1jJNPlluhO00qzE3+8R58JEcq6rhcm74H2DOpcsZItB5rgIFB9Yyphz1/+NGyRZELgwaOQYjabRUHnigmCAjfGDHJLOsRHIKduqwLmvAwl/5bkkBqF+p7xtFuy7bxKBIg7IBvGxVoLiwIcCsOeHNICo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7dKLSMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7dKLSMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4CB1F000E9;
	Sat, 23 May 2026 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779528089;
	bh=o0sExnt9Lp9TH75yOwZC6UU+46EVU69K49V/LzJ8xTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b7dKLSMA/v6TUSztK6Eqw1G2fzLbPGHIwisFb8BJX7r9hX5mgeh+Ulw0RpsEdZmMv
	 VTA+U/pVQenQWCePcw2/iJe6Go0nOYP0JWPWwBS9F7dp36oD++7u0NBGJnzjWCwq53
	 r7EkNoq9jRAuX4/62qCULHKNLXlBJTMgVPCeFxT0=
Date: Sat, 23 May 2026 11:21:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 505/666] sched/psi: fix race between file release
 and pressure write
Message-ID: <2026052321-deface-enviable-7d5a@gregkh>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162122.206605865@linuxfoundation.org>
 <8a06c5c3-8f7a-4252-a3b1-0c0d812e2654@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a06c5c3-8f7a-4252-a3b1-0c0d812e2654@oracle.com>

On Sat, May 23, 2026 at 01:17:57AM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 20/05/26 21:51, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Edward Adam Davis <eadavis@qq.com>
> > 
> > [ Upstream commit a5b98009f16d8a5fb4a8ff9a193f5735515c38fa ]
> > 
> > A potential race condition exists between pressure write and cgroup file
> > release regarding the priv member of struct kernfs_open_file, which
> > triggers the uaf reported in [1].
> > 
> > Consider the following scenario involving execution on two separate CPUs:
> > 
> >     CPU0					CPU1
> >     ====					====
> > 					vfs_rmdir()
> > 					kernfs_iop_rmdir()
> > 					cgroup_rmdir()
> > 					cgroup_kn_lock_live()
> > 					cgroup_destroy_locked()
> > 					cgroup_addrm_files()
> > 					cgroup_rm_file()
> > 					kernfs_remove_by_name()
> > 					kernfs_remove_by_name_ns()
> >   vfs_write()				__kernfs_remove()
> >   new_sync_write()			kernfs_drain()
> >   kernfs_fop_write_iter()		kernfs_drain_open_files()
> >   cgroup_file_write()			kernfs_release_file()
> >   pressure_write()			cgroup_file_release()
> >   ctx = of->priv;
> > 					kfree(ctx);
> >   					of->priv = NULL;
> > 					cgroup_kn_unlock()
> >   cgroup_kn_lock_live()
> >   cgroup_get(cgrp)
> >   cgroup_kn_unlock()
> >   if (ctx->psi.trigger)  // here, trigger uaf for ctx, that is of->priv
> > 
> > The cgroup_rmdir() is protected by the cgroup_mutex, it also safeguards
> > the memory deallocation of of->priv performed within cgroup_file_release().
> > However, the operations involving of->priv executed within pressure_write()
> > are not entirely covered by the protection of cgroup_mutex. Consequently,
> > if the code in pressure_write(), specifically the section handling the
> > ctx variable executes after cgroup_file_release() has completed, a uaf
> > vulnerability involving of->priv is triggered.
> > 
> > Therefore, the issue can be resolved by extending the scope of the
> > cgroup_mutex lock within pressure_write() to encompass all code paths
> > involving of->priv, thereby properly synchronizing the race condition
> > occurring between cgroup_file_release() and pressure_write().
> > 
> > And, if an live kn lock can be successfully acquired while executing
> > the pressure write operation, it indicates that the cgroup deletion
> > process has not yet reached its final stage; consequently, the priv
> > pointer within open_file cannot be NULL. Therefore, the operation to
> > retrieve the ctx value must be moved to a point *after* the live kn
> > lock has been successfully acquired.
> > 
> > In another situation, specifically after entering cgroup_kn_lock_live()
> > but before acquiring cgroup_mutex, there exists a different class of
> > race condition:
> > 
> > CPU0: write memory.pressure               CPU1: write cgroup.pressure=0
> > ===========================		  =============================
> > 
> > kernfs_fop_write_iter()
> >   kernfs_get_active_of(of)
> >   pressure_write()
> >     cgroup_kn_lock_live(memory.pressure)
> >       cgroup_tryget(cgrp)
> >       kernfs_break_active_protection(kn)
> >       ... blocks on cgroup_mutex
> > 
> >                                       	  cgroup_pressure_write()
> >                                       	  cgroup_kn_lock_live(cgroup.pressure)
> >                                       	  cgroup_file_show(memory.pressure, false)
> >                                       	    kernfs_show(false)
> >                                       	      kernfs_drain_open_files()
> >                                       	        cgroup_file_release(of)
> >                                       	          kfree(ctx)
> >                                       	            of->priv = NULL
> >                                       	  cgroup_kn_unlock()
> > 
> >     ... acquires cgroup_mutex
> >     ctx = of->priv;        // may now be NULL
> >     if (ctx->psi.trigger)  // NULL dereference
> > 
> > Consequently, there is a possibility that of->priv is NULL, the pressure
> > write needs to check for this.
> > 
> > Now that the scope of the cgroup_mutex has been expanded, the original
> > explicit cgroup_get/put operations are no longer necessary, this is
> > because acquiring/releasing the live kn lock inherently executes a
> > cgroup get/put operation.
> > 
> > [1]
> > BUG: KASAN: slab-use-after-free in pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
> > Call Trace:
> >   pressure_write+0xa4/0x210 kernel/cgroup/cgroup.c:4011
> >   cgroup_file_write+0x36f/0x790 kernel/cgroup/cgroup.c:4311
> >   kernfs_fop_write_iter+0x3b0/0x540 fs/kernfs/file.c:352
> > 
> > Allocated by task 9352:
> >   cgroup_file_open+0x90/0x3a0 kernel/cgroup/cgroup.c:4256
> >   kernfs_fop_open+0x9eb/0xcb0 fs/kernfs/file.c:724
> >   do_dentry_open+0x83d/0x13e0 fs/open.c:949
> > 
> > Freed by task 9353:
> >   cgroup_file_release+0xd6/0x100 kernel/cgroup/cgroup.c:4283
> >   kernfs_release_file fs/kernfs/file.c:764 [inline]
> >   kernfs_drain_open_files+0x392/0x720 fs/kernfs/file.c:834
> >   kernfs_drain+0x470/0x600 fs/kernfs/dir.c:525
> > 
> > Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> > Reported-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=33e571025d88efd1312c
> > Tested-by: syzbot+33e571025d88efd1312c@syzkaller.appspotmail.com
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   kernel/cgroup/cgroup.c | 24 ++++++++++++++++--------
> >   1 file changed, 16 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 046f671532b04..0914a1a189ee1 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -3876,33 +3876,41 @@ static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
> >   static ssize_t pressure_write(struct kernfs_open_file *of, char *buf,
> >   			      size_t nbytes, enum psi_res res)
> >   {
> > -	struct cgroup_file_ctx *ctx = of->priv;
> > +	struct cgroup_file_ctx *ctx;
> >   	struct psi_trigger *new;
> >   	struct cgroup *cgrp;
> >   	struct psi_group *psi;
> > +	ssize_t ret = 0;
> >   	cgrp = cgroup_kn_lock_live(of->kn, false);
> >   	if (!cgrp)
> >   		return -ENODEV;
> > -	cgroup_get(cgrp);
> > -	cgroup_kn_unlock(of->kn);
> > +	ctx = of->priv;
> > +	if (!ctx) {
> > +		ret = -ENODEV;
> > +		goto out_unlock;
> > +	}
> 
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issues goes like:
> 
> Upstream has:
> 
> static void cgroup_file_release(struct kernfs_open_file *of)
> {
>         struct cftype *cft = of_cft(of);
>         struct cgroup_file_ctx *ctx = of->priv;
> 
>         if (cft->release)
>                 cft->release(of);
>         put_cgroup_ns(ctx->ns);
>         kfree(ctx);
>         of->priv = NULL;
> }
> 
> 
> 
> On 6.12.y:
> 
> static void cgroup_file_release(struct kernfs_open_file *of)
> {
>         struct cftype *cft = of_cft(of);
>         struct cgroup_file_ctx *ctx = of->priv;
> 
>         if (cft->release)
>                 cft->release(of);
>         put_cgroup_ns(ctx->ns);
>         kfree(ctx);
> }
> 
> On 6.12.y, cgroup_file_release() frees ctx but does not clear of->priv. The
> posted backport adds
> 	ctx = of->priv;
> 	if (!ctx)
> 
> in pressure_write(), but that only works if release turns of->priv into
> NULL. In the pressure_write() vs cgroup_pressure_write() race from the
> commit message, 6.12.y still leaves a dangling pointer there, so this
> backport alone is incomplete and can still hit UAF.
> 
> So upstream has commit: 94a4acfec146 ("cgroup/psi: Set of->priv to NULL upon
> file release") which might be needed here as well, without that I would
> suggest a drop.

Dropped from 6.12 and older, thanks.

greg k-h
