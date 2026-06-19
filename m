Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946B367F59;
	Fri, 19 Jun 2026 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781862975; cv=none; b=dZDmjvwS1RBhUtu+xa4xk3JWVVjWaikfz7+jijPF8wmR5t/WrFHlzrUl87Hq9pZTQ6aR8ahDKdStlMy79kO4UpAnJNAewUiN10Hr1NVi/8xqlgJyFVK4QSc6kD7DRICJkywfZnNrq8B0kL9DKQmR2bgHHalOMI181hTqi0v5+RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781862975; c=relaxed/simple;
	bh=BsgJwnB/nbLfAI8hzpc9mDJsBxbzXIhnEPJJm0gtd8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdSDfd9j4RSOGd7Z2a308qFwuneP8F/iKe4kwDkRJEYgvngmn0V3aVmLVY0YJtGFGrze5TVfztqVZFR5YsD5B2Ksc4FU8XWmDeHvktTRNYweFVQQWUFZnMZeHbZ1pdtnZ+ucEZqXeRJb4zF6vBhPGfnx1nUajSDq9mm0SF37lxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3pWA95V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3pWA95V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56941F000E9;
	Fri, 19 Jun 2026 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781862968;
	bh=RRAkZrz2NnBTdnmCperiOhBRhKw8kYvJMOVjYv7LxLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d3pWA95VK739UMks0oDjLHDM1BwctwLXmJJfjdV1kO4NDdTFkpIVX2MBt6ZXN5D/X
	 xTDq8qDKkcO3xghvYaWvmp1fjVahwLDxO9fEwRNuYv74rqgS1vZrtcYr0igRQUp7G6
	 fhN1PBXlf+32ROBPpDS6M7bvxgyfdg1ULr9ohF/M=
Date: Fri, 19 Jun 2026 11:54:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Robert Garcia <rob_garcia@163.com>, Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 045/411] wifi: brcmfmac: fix use-after-free when
 rescheduling brcmf_btcoex_info work
Message-ID: <2026061929-appendage-daughter-66d4@gregkh>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145102.682627807@linuxfoundation.org>
 <b24447af-a758-4ffa-95cf-4a5bcc4994d4@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b24447af-a758-4ffa-95cf-4a5bcc4994d4@oracle.com>

On Thu, Jun 18, 2026 at 11:48:35PM +0530, Harshit Mogalapalli wrote:
> Hi Sasha and Greg,
> 
> On 16/06/26 20:24, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Duoming Zhou <duoming@zju.edu.cn>
> > 
> > [ Upstream commit 9cb83d4be0b9b697eae93d321e0da999f9cdfcfc ]
> > 
> > The brcmf_btcoex_detach() only shuts down the btcoex timer, if the
> > flag timer_on is false. However, the brcmf_btcoex_timerfunc(), which
> > runs as timer handler, sets timer_on to false. This creates critical
> > race conditions:
> > 
> > 1.If brcmf_btcoex_detach() is called while brcmf_btcoex_timerfunc()
> > is executing, it may observe timer_on as false and skip the call to
> > timer_shutdown_sync().
> > 
> > 2.The brcmf_btcoex_timerfunc() may then reschedule the brcmf_btcoex_info
> > worker after the cancel_work_sync() has been executed, resulting in
> > use-after-free bugs.
> > 
> > The use-after-free bugs occur in two distinct scenarios, depending on
> > the timing of when the brcmf_btcoex_info struct is freed relative to
> > the execution of its worker thread.
> > 
> > Scenario 1: Freed before the worker is scheduled
> > 
> > The brcmf_btcoex_info is deallocated before the worker is scheduled.
> > A race condition can occur when schedule_work(&bt_local->work) is
> > called after the target memory has been freed. The sequence of events
> > is detailed below:
> > 
> > CPU0                           | CPU1
> > brcmf_btcoex_detach            | brcmf_btcoex_timerfunc
> >                                 |   bt_local->timer_on = false;
> >    if (cfg->btcoex->timer_on)   |
> >      ...                        |
> >    cancel_work_sync();          |
> >    ...                          |
> >    kfree(cfg->btcoex); // FREE  |
> >                                 |   schedule_work(&bt_local->work); // USE
> > 
> > Scenario 2: Freed after the worker is scheduled
> > 
> > The brcmf_btcoex_info is freed after the worker has been scheduled
> > but before or during its execution. In this case, statements within
> > the brcmf_btcoex_handler() — such as the container_of macro and
> > subsequent dereferences of the brcmf_btcoex_info object will cause
> > a use-after-free access. The following timeline illustrates this
> > scenario:
> > 
> > CPU0                            | CPU1
> > brcmf_btcoex_detach             | brcmf_btcoex_timerfunc
> >                                  |   bt_local->timer_on = false;
> >    if (cfg->btcoex->timer_on)    |
> >      ...                         |
> >    cancel_work_sync();           |
> >    ...                           |   schedule_work(); // Reschedule
> >                                  |
> >    kfree(cfg->btcoex); // FREE   |   brcmf_btcoex_handler() // Worker
> >    /*                            |     btci = container_of(....); // USE
> >     The kfree() above could      |     ...
> >     also occur at any point      |     btci-> // USE
> >     during the worker's execution|
> >     */                           |
> > 
> > To resolve the race conditions, drop the conditional check and call
> > timer_shutdown_sync() directly. It can deactivate the timer reliably,
> > regardless of its current state. Once stopped, the timer_on state is
> > then set to false.
> > 
> > Fixes: 61730d4dfffc ("brcmfmac: support critical protocol API for DHCP")
> > Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > Link: https://patch.msgid.link/20250822050839.4413-1-duoming@zju.edu.cn
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Robert Garcia <rob_garcia@163.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> > index f9f18ff451ea7c..f46e4090021777 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
> > @@ -392,10 +392,8 @@ void brcmf_btcoex_detach(struct brcmf_cfg80211_info *cfg)
> >   	if (!cfg->btcoex)
> >   		return;
> > -	if (cfg->btcoex->timer_on) {
> > -		cfg->btcoex->timer_on = false;
> > -		del_timer_sync(&cfg->btcoex->timer);
> > -	}
> > +	del_timer_sync(&cfg->btcoex->timer);
> > +	cfg->btcoex->timer_on = false;
> 
> I ran an AI assisted backport review over the 5.15.210 queue. I think this
> 5.15.y backport doesn;t really try to do the same thing like upstream. Why
> so ?
> 
> Upstream 9cb83d4be0b9 uses timer_shutdown_sync() before canceling the work
> and freeing cfg->btcoex:
> 
>         timer_shutdown_sync(&cfg->btcoex->timer);
>         cfg->btcoex->timer_on = false;
>         cancel_work_sync(&cfg->btcoex->work);
> 
> The 5.15.y backport still uses del_timer_sync():
> 
>         del_timer_sync(&cfg->btcoex->timer);
>         cfg->btcoex->timer_on = false;
>         cancel_work_sync(&cfg->btcoex->work);
> 
> The timer code in this 5.15.y tree already documents that del_timer_sync()
> cannot guarantee the timer is not rearmed by concurrent code, so the key
> point is the difference between del_timer_sync() and timer_shutdown_sync().
> 
> I think 5.15.y should directly use timer_shutdown_sync(), as we don't have
> commit: 292a089d78d3 ("treewide: Convert del_timer*() to timer_shutdown*()")
> in 5.15.y, thoughts ?

I think this is the best that can be done unless someone wants to
backport that mess of a timer conversion.  And note, I think I've
rejected that backport already :)

thanks,

greg k-h
