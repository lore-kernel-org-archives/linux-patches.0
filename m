Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127F533F8A3;
	Wed, 22 Jul 2026 13:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726747; cv=none; b=ELOhGLteHiCeiPYpsZB83yt4MEx+0zSXyVU4b3fIQ+LVjvCbiWhlTs4CQy/pUZ55wKEW5LRJIVxoaORpVr+3HoKhhs50Cahrh4/2XXxvIJfv1PMAlNws2QG/KYhmRgozz0xrTcBLob47ffwLlBQoEhXHuAPog7pXvt/jjCdSaiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726747; c=relaxed/simple;
	bh=ORF0NR03uUvejeVPGOQ1gjz/F9vxipBG+0yAybP4WQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipmKW8NgbWoBIkYopLLE42Y7hbPlv14gjd9p8SOO2+SMT+hz3VaHsZZCwm1c1naVI7q59F/hhXRQ/+b9sEvljdw4EIXzaCoHoeoFFtKK7h17nrx/3qWEeLRfbcE67RPL0Yyt540FjCdLNSNpW9FU9YQoPEBt42OHHvjqaAeoKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dnf59Is8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dnf59Is8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260541F000E9;
	Wed, 22 Jul 2026 13:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784726745;
	bh=JlVwsgUU44JlChANx8iFerR99T32QYVdq68KqtRkrEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dnf59Is8KO2c3A4u7dTip8mtTVVi1Y7pQ8nfN5pBKnak/2WVVocUxcbwEpXGBcTRE
	 h4Z68cpx+TaCkaB+8bCh9R2JACVwJvEifiA1jyk3hvr7StWMFvMIq5plxI1y7LBDkF
	 JveNKdaZSn/oy8iRXoADIqm1nhEwRYJlr+7DPdgM=
Date: Wed, 22 Jul 2026 15:25:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.1 0944/2077] perf sched: Use is_idle_sample() for idle
 thread runtime cast guard
Message-ID: <2026072225-polyester-lid-1a1d@gregkh>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152615.083823288@linuxfoundation.org>
 <5d1db582-46e2-49e4-9884-eb96b573079e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d1db582-46e2-49e4-9884-eb96b573079e@kernel.org>

On Wed, Jul 22, 2026 at 07:29:43AM +0200, Jiri Slaby wrote:
> On 21. 07. 26, 17:10, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > [ Upstream commit c9b3054c99cafd5f5f92158101760992a83e5a5e ]
> ...
> > --- a/tools/perf/builtin-sched.c
> > +++ b/tools/perf/builtin-sched.c
> > @@ -2904,7 +2904,13 @@ static int timehist_sched_change_event(const struct perf_tool *tool,
> >   			t = ptime->end;
> >   	}
> > -	if (!sched->idle_hist || thread__tid(thread) == 0) {
> > +	/*
> > +	 * Use is_idle_sample() not thread__tid() == 0: a crafted perf.data
> > +	 * can set common_pid=0 with prev_pid!=0, giving us a machine thread
> > +	 * whose priv is thread_runtime, not idle_thread_runtime — the cast
> > +	 * below would read past the allocation.
> > +	 */
> > +	if (!sched->idle_hist || is_idle_sample(sample)) {
> 
> This would need:
> 1ac10645bb29 perf sched: Don't pass evsel with sample
> 
> Instead, calling
>   is_idle_sample(sample, evsel)
> here would be simpler backport.

Yes, thanks, I've made that change now.

greg k-h
