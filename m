Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400D340416;
	Thu,  2 Jul 2026 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009320; cv=none; b=BxgsEp/11l885MpJzrotttucK5aoQHr4rlcEugCdQbFChi/c6f0q526cM0FnzS5i8FrfGFKbcUkm+4U/TEo8WNx/xs6gzWBhJZmQW+arg/8aaC4dQXs1UdampoYtGxF++jEcngPhsbRtwuUdobjSuJZWId6Doa38ZmIvkwX2gsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009320; c=relaxed/simple;
	bh=UPz1caS229fhiPRiNKdfCyDvXtRx3JTcdXJWGDsFx78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBxOO3Wk56qXXU9GLIFiyGK9OZDdrLTj0EbwG1m9xH2ZRunAP0RP/PjxyM3Y9KAGH0TekbUwt4PMD927iehK0W6rkkUptiLQlSjz++U7cPPDXta1NuUdmXrZot4/mmrXxSOcGrJPI4vz1J5aLV7+d6euWHrT3iyUGG1CbDQS3eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHcljZkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHcljZkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6501F000E9;
	Thu,  2 Jul 2026 16:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009318;
	bh=ROoQa62ubq9FXVO6wuqNUEh5aSLdXA0Ebod/FRT1SmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BHcljZkjg9chiEMW/g80ApiFQrsR8GjwzUKtJdJoqKb5Re+q9PI7gU0q38TXuEyKN
	 oCsed1pP72GLpzKU7TNJP6DmZXx6spLnIIGnfWqIYRa6RWS5itCQuyq0Q14KaAY3Zd
	 RZiDpqQ8Hk23PX9mPJKeJafp0bdzQ0jvHS2nk07M=
Date: Thu, 2 Jul 2026 18:16:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: 00107082 <00107082@163.com>, iklatzco <iklatzco@gmail.com>,
	patches <patches@lists.linux.dev>, peterz <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
	"yeoreum.yun" <yeoreum.yun@arm.com>
Subject: Re: [PATCH] perf: Fix dangling cgroup pointer in cpuctx backport
Message-ID: <2026070200-uneaten-smock-4130@gregkh>
References: <2026062455-obtrusive-sandbox-d6d1@gregkh>
 <20260624095920.2558406-1-guanwentao@uniontech.com>
 <2026062404-unusual-nutmeg-87d5@gregkh>
 <tencent_5FDA609363B90C6249A050FD@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_5FDA609363B90C6249A050FD@qq.com>

On Wed, Jun 24, 2026 at 06:07:41PM +0800, Wentao Guan wrote:
> > On Wed, Jun 24, 2026 at 05:59:21PM +0800, Wentao Guan wrote:
> > > recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
> > > use a middle version, so aligned with the upstream commit:
> > > 3b7a34aebbdf2a4b7295205bf0c654294283ec82
> > >
> > > > Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> > > ---
> > >  kernel/events/core.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > index a4187dea6402a..73a86db06cc9b 100644
> > > --- a/kernel/events/core.c
> > > +++ b/kernel/events/core.c
> > > @@ -2384,10 +2384,9 @@ __perf_remove_from_context(struct perf_event *event,
> > >  */
> > >  if (flags & DETACH_EXIT)
> > >  state = PERF_EVENT_STATE_EXIT;
> > > - if (flags & DETACH_DEAD) {
> > > - event->pending_disable = 1;
> > > + if (flags & DETACH_DEAD)
> > >  state = PERF_EVENT_STATE_DEAD;
> > > - }
> > > +
> > >  event_sched_out(event, ctx);
> > > 
> > >  if (event->state > PERF_EVENT_STATE_OFF)
> > > --
> > > 2.30.2
> > >
> > 
> > What kernel tree(s) is this for?  What git id does this fix?
> 1. v6.6.143 and v6.12.94
> 2. 
> ae1ada0af16249a3ed15e33fa6719a6a2f96f537 in v6.6.143
> 46f5623f9b0ef66127e1de16fb857850cdb14e68 in v6.12.94

Please put all of this information in the changelog and provide
versions for all of the branches you want it for.

thanks,

greg k-h
