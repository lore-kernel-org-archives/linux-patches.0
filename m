Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0B1E522;
	Thu, 14 Aug 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755184632; cv=none; b=dlqMYiXrkP6uH+CGIBefjjH8KbGjryiHTveHI0TUOTY7pSD6fRvIBuWQbno8Zyml6kyo32StWDjmfBIAVUgSZo0SyEjtq7AMFzU5qERyu9fAKqMWJ9wFfrU5Vx90rfpNPYusI/16kUKMU3bOgblSUAvRZnjYHKMwG+YMzOysy9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755184632; c=relaxed/simple;
	bh=qNO9HqA8hFJwdj2rfCz2c3nfuzWBv4KHkkzscMChIRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p8Enm4NwYMuTp6fScGf/v8Fr2sXOcuvdYMdKUiG/QuVsoYc3FlBdyhNPvgm4lJyR1fyF6Hr9BWCw2U9WCU+uNly06V0qIioq6wRrSQnsVC2er3SGq0wP6g+HB62PHpH7gFHTRdP036OKjPG6iXL/99zRuZ/CxeIXN9H/tsbCg6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKRrFYmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKRrFYmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4317C4CEF1;
	Thu, 14 Aug 2025 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755184631;
	bh=qNO9HqA8hFJwdj2rfCz2c3nfuzWBv4KHkkzscMChIRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKRrFYmzIci9uqL/a8/Izgwv1VDid2XTIuaj7U/OW0D2BSA5p86kVM6j69O97MuWG
	 S545dS8KmoZ8SDphvUE0tMyN9/dIur5LlIO+QAqzmHHx5O0UeeQGv/waKUjrP3E90h
	 yEeQ6buPGQ2o/v00hbobf6lIPAxbPcDKm/EvvqmU=
Date: Thu, 14 Aug 2025 17:17:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 199/627] sched/deadline: Less agressive dl_server
 handling
Message-ID: <2025081451-geography-anchor-57a6@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173426.853672780@linuxfoundation.org>
 <17955c87-1a82-4eae-94ee-3ac1447d4e71@kernel.org>
 <58c46200-95b0-4cd8-bb5e-44f963a66875@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58c46200-95b0-4cd8-bb5e-44f963a66875@kernel.org>

On Thu, Aug 14, 2025 at 10:37:22AM +0200, Jiri Slaby wrote:
> On 14. 08. 25, 10:22, Jiri Slaby wrote:
> > Hi,
> > 
> > 
> > On 12. 08. 25, 19:28, Greg Kroah-Hartman wrote:
> > > 6.16-stable review patch.  If anyone has any objections, please let
> > > me know.
> > > 
> > > ------------------
> > > 
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > [ Upstream commit cccb45d7c4295bbfeba616582d0249f2d21e6df5 ]
> > > 
> > > Chris reported that commit 5f6bd380c7bd ("sched/rt: Remove default
> > > bandwidth control") caused a significant dip in his favourite
> > > benchmark of the day. Simply disabling dl_server cured things.
> > > 
> > > His workload hammers the 0->1, 1->0 transitions, and the
> > > dl_server_{start,stop}() overhead kills it -- fairly obviously a bad
> > > idea in hind sight and all that.
> > > 
> > > Change things around to only disable the dl_server when there has not
> > > been a fair task around for a whole period. Since the default period
> > > is 1 second, this ensures the benchmark never trips this, overhead
> > > gone.
> > 
> > This causes:
> > sched: DL replenish lagged too much
> > 
> > Maybe some prereq missing?
> 
> Not really, this is present both in linus/master and tip/master.
> > > Fixes: 557a6bfc662c ("sched/fair: Add trivial fair server")
> > > Reported-by: Chris Mason <clm@meta.com>
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
> > > Acked-by: Juri Lelli <juri.lelli@redhat.com>
> > > Link: https://lkml.kernel.org/r/20250702121158.465086194@infradead.org
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > thanks,

Ok, I'll move this out of this release and queue it up for the "next
one".

thanks,

greg k-h
