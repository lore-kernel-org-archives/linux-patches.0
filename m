Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93213D9DA3;
	Mon,  1 Jun 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326926; cv=none; b=WX3GIgEfEplzYGNGCt+6TnCahT0lUXNKwgQ4cnL8Uu768SDQukbhkvxNnVsq/UcEkLuTPzDEQervkuahoN8lkxpdYIEHklKlIkPYTwwTLPJvV/g0jRJMGOB7TGknQFEfYnicnpUbF+KB8UV3LNhaTLB8kRYri8JPdBD/M+DTC5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326926; c=relaxed/simple;
	bh=hGRGzNIypnX0AXDA+PMDv6F5SBrA2Bv15IQFwTdGUYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gA6v2LvglJrdI+UeBcUZ3DgUslHlV7T6vGQH1IjRLfsLMsLLJA9vYnFDHFAeWcLVWUSjpXUbJGWKTJKZfNereM0FMIDZoukTUgGS0TCI8AbHzOYdi0cFC61ZYx2o7FZ3ARu/i502kXST1f5Eu2tdMX5AlLW28N1dAS4+gjeT570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFYNZC/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFYNZC/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE561F00893;
	Mon,  1 Jun 2026 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780326921;
	bh=UQw2Qn4eAdwLyjPPOT3pNt9iKj28FHguU2RFXMVV1vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dFYNZC/CLmUB85jCOvOHyypXgAz9Nmigu7Qlrh1G0TNLwxkEi+n65Wejsz97dSQs5
	 peKbrmpSjNuJDMEUtJ9cy9e0qDfCML8TNtVhWUvsRauW8zBcu///VsdehReta9Fu7N
	 Yo97LWWPYqABi8pnUWH2uGuq+ZQVmngTaOS7u080=
Date: Mon, 1 Jun 2026 17:14:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 017/272] sched/deadline: Always stop dl-server
 before changing parameters
Message-ID: <2026060119-twistable-radiation-356b@gregkh>
References: <20260528194629.379955525@linuxfoundation.org>
 <20260528194629.863626682@linuxfoundation.org>
 <c393e33f-dd81-4e84-8c26-98f865bffc9e@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c393e33f-dd81-4e84-8c26-98f865bffc9e@oracle.com>

On Mon, Jun 01, 2026 at 06:44:34PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 29/05/26 01:16, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Juri Lelli <juri.lelli@redhat.com>
> > 
> > commit bb4700adc3abec34c0a38b64f66258e4e233fc16 upstream.
> > 
> > Commit cccb45d7c4295 ("sched/deadline: Less agressive dl_server
> > handling") reduced dl-server overhead by delaying disabling servers only
> > after there are no fair task around for a whole period, which means that
> > deadline entities are not dequeued right away on a server stop event.
> > However, the delay opens up a window in which a request for changing
> > server parameters can break per-runqueue running_bw tracking, as
> > reported by Yuri.
> > 
> > Close the problematic window by unconditionally calling dl_server_stop()
> > before applying the new parameters (ensuring deadline entities go
> > through an actual dequeue).
> > 
> > Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
> > Reported-by: Yuri Andriaccio <yurand2000@gmail.com>
> > Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Reviewed-by: Valentin Schneider <vschneid@redhat.com>
> > Link: https://lore.kernel.org/r/20250721-upstream-fix-dlserver-lessaggressive-b4-v1-1-4ebc10c87e40@redhat.com
> > Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   kernel/sched/debug.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> > index 7d14e9fa53ac3..564ea17ae405e 100644
> > --- a/kernel/sched/debug.c
> > +++ b/kernel/sched/debug.c
> > @@ -378,10 +378,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
> >   			return  -EINVAL;
> >   		}
> > -		if (rq->cfs.h_nr_queued) {
> > -			update_rq_clock(rq);
> > -			dl_server_stop(&rq->fair_server);
> > -		}
> > +		update_rq_clock(rq);
> > +		dl_server_stop(&rq->fair_server);
> 
> I have run an AI assisted backport review and took a look at this one.
> 
> I think 6.12.y is missing what upstream has:
> 
> The backport makes sched_fair_server_write() always do:
> 
> update_rq_clock(rq);
> dl_server_stop(&rq->fair_server);
> 
> That matches upstream bb4700adc3ab, but upstream also has this in
> dl_server_stop():
> 
> if (!dl_server(dl_se) || !dl_server_active(dl_se))
>         return;
> 
> 
> 6.12.y only has:
> 
> if (!dl_se->dl_runtime)
>         return;
> 
> so an inactive but configured fair server can still go through the deadline
> dequeue accounting path.
> 
> So it looks like this backport is not very safe. Thoughts ?

Now dropped, thanks.

greg k-h
