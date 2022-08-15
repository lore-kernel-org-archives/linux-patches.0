Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9240A2573;
	Mon, 15 Aug 2022 15:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2678C433C1;
	Mon, 15 Aug 2022 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660578430;
	bh=nEXl7krktfyRZVwfRYGO2bfWgZ3SyJWp8ll/cv0CV/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FxkgWRJQ2G67tRm6g08dpy5VqV9PctIYJrv/elSvtJZlsudV/OhawWTq4KCbJFK5k
	 fjUPc6rtQ0UzXLuITCOAg3E7BROsQtUTFV7YjhoPOZ2Au1IOh+0V5UPavWw3iSUU4X
	 JfUj4EVdpzr/SMaG3foUimb41bsrfn4fAMnBy35E30I9iQnk8CBoFNa6Te9n9arCSh
	 FRZ2AsV/5MwrXRrDx48Z0hlcPMJa3Q+WLlqPr3J8r40FIuAu8Oi904MQMPuBhMfQHr
	 mkrRIDyFn7QLtX23zekfVswMUEkcUIEpo2/M+uNXw65tuxF+Hm41dwi/CvMJI+8ma/
	 3G8uY+Phs0B0w==
Date: Mon, 15 Aug 2022 08:47:08 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jon Mason <jdmason@kudzu.us>
Cc: Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
	Alexander Fomichev <a.fomichev@yadro.com>, ntb@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ntb_perf: Fix 64-bit division on 32-bit architectures
Message-ID: <YvpqfDNIBqLbC0FA@dev-arch.thelio-3990X>
References: <20220622174326.1832697-1-nathan@kernel.org>
 <YvZeC2UDZFdfb71M@kudzu.us>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvZeC2UDZFdfb71M@kudzu.us>

Hi Jon,

On Fri, Aug 12, 2022 at 10:04:59AM -0400, Jon Mason wrote:
> On Wed, Jun 22, 2022 at 10:43:26AM -0700, Nathan Chancellor wrote:
> > When compiling for a 32-bit architecture, such as arm, an error occurs
> > during modpost:
> > 
> >   ERROR: modpost: "__aeabi_uldivmod" [drivers/ntb/test/ntb_perf.ko] undefined!
> > 
> > The tries member of struct perf_thread is u64 so a 64-bit division
> > helper is needed. Use div_u64_rem() to get the remainder of the division
> > so that it can be checked against zero.
> > 
> > Fixes: dc150dfb081f ("ntb_perf: extend with burst latency measurement")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/ntb/test/ntb_perf.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/ntb/test/ntb_perf.c b/drivers/ntb/test/ntb_perf.c
> > index 23e154bd41b9..4e05c7aa070d 100644
> > --- a/drivers/ntb/test/ntb_perf.c
> > +++ b/drivers/ntb/test/ntb_perf.c
> > @@ -1118,6 +1118,7 @@ static int perf_run_latency(struct perf_thread *pthr)
> >  	void __iomem *flt_dst, *bnd_dst;
> >  	void *flt_src;
> >  	u64 stop_at;
> > +	u32 rem;
> >  	int ret;
> >  
> >  	pthr->tries = 0;
> > @@ -1146,7 +1147,8 @@ static int perf_run_latency(struct perf_thread *pthr)
> >  		}
> >  
> >  		/* Avoid processor soft lock-ups */
> > -		if (!(pthr->tries % RESCHEDULE_RATIO))
> > +		div_u64_rem(pthr->tries, RESCHEDULE_RATIO, &rem);
> > +		if (!rem)
> >  			schedule();
> >  	}
> >  
> > 
> > base-commit: 0c4b285d9636cc850f55151fa6a250dd131e5192
> > -- 
> > 2.37.0.rc1
> > 
> 
> Sorry for the extremely long delay in response.  This patch is in my
> ntb branch and will be in my pull request for v5.20 which should be
> going out later today.

No worries, we all get busy :)

For the record, I believe this was addressed by Max's patch [1], which I
did see in -next for a time. It doesn't matter to me which one goes in,
just so long as the build doesn't break :)

[1]: https://lore.kernel.org/20220627155710.2067032-1-jcmvbkbc@gmail.com/

Cheers,
Nathan
