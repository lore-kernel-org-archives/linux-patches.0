Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC2B3BF695;
	Wed, 17 Jun 2026 07:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781681639; cv=none; b=cjkCA0L19D7wesoYJkcVUxUoJ0+IYAVu5jVYPW5ynxWyMQxocgqRc5FHOPTYzL8xsH7X21cyYK4roBVKJT3Rbp68POchy9RLwrs55IfJk0uiUW1JC6u/4SdhdbKaiW/r3eRge36B6WAzvoK5CEQYHCxvOl3s4jdo/Apr7Gf5/CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781681639; c=relaxed/simple;
	bh=/GQ/ul2YjvF7RtKv6nA6jcE+6cpabB/t4PWbItjkQQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kL+Rm8RXwbWs8mGgltfZfBL75UiCULmqoOvMARZ+Byu+DQJ/hGhSdUBRGLd12JZ+QJ1dVKHDzCpsd2Dt046ShzidnQ4+C5uC2fD8t2YqLsVaTJ1NFTE2SxPnmCyDfL/q+a+4zkYEa3hFuBYp1Oov0cdp1zSDMGGGM7YzCF0fdtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1AUM1xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1AUM1xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66FE1F000E9;
	Wed, 17 Jun 2026 07:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781681637;
	bh=XuMrOuNjdnTAc3Nue3jyug1nZ2oEyjbMJyrDv/yzpfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B1AUM1xPYEow9uqiLAD922CoV+AqK2mG+EfREsxFeTGKN63f4Q9e9dgytD9ZsHH0N
	 Rzxy9flqDQlZmNGxYGkyefHNEeExfiVXgUUlDCSAkqbQ8A2JCqmmJFYBkeXUDbDUpg
	 ArW4eBSu06lUD9wCd4AvIrRHCWvUEgLDjvp5+Svo=
Date: Wed, 17 Jun 2026 13:02:51 +0530
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev, Ji-Soo Chung <jschung2@proton.me>,
	Gerlinde <lrGerlinde@mailfence.com>,
	zyc zyc <zyc199902@zohomail.cn>,
	Manas Ghandat <ghandatmanas@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 033/522] net/sched: Revert "net/sched: Restrict
 conditions for adding duplicating netems to qdisc tree"
Message-ID: <2026061727-curfew-playful-046c@gregkh>
References: <20260616145125.307082728@linuxfoundation.org>
 <20260616145127.216541751@linuxfoundation.org>
 <cb2e59a48887f106a57c3fbef66d5a164b8e2f5f.camel@decadent.org.uk>
 <20260616153146.461b425c@phoenix.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616153146.461b425c@phoenix.local>

On Tue, Jun 16, 2026 at 03:31:46PM -0700, Stephen Hemminger wrote:
> On Wed, 17 Jun 2026 00:17:03 +0200
> Ben Hutchings <ben@decadent.org.uk> wrote:
> 
> > On Tue, 2026-06-16 at 20:23 +0530, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Jamal Hadi Salim <jhs@mojatatu.com>
> > > 
> > > [ Upstream commit eda0b7f203bb166c98d1418b204135bd566ac83b ]
> > > 
> > > This reverts commit ec8e0e3d7adef940cdf9475e2352c0680189d14e.
> > > 
> > > The original patch rejects any tree containing two netems when
> > > either has duplication set, even when they sit on unrelated classes
> > > of the same classful parent. That broke configurations that have
> > > worked since netem was introduced.
> > > 
> > > The re-entrancy problem the original commit was trying to solve is
> > > handled by later patch using tc_depth flag.
> > > 
> > > Doing this revert will (re)expose the original bug with multiple
> > > netem duplication. When this patch is backported make sure  
> >                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > and get the full series.  
> >   ^^^^^^^^^^^^^^^^^^^^^^^
> > [...]
> > 
> > That whole series was applied as:
> > 
> > 98b34f3e8c34 net: Introduce skb tc depth field to track packet loops
> > eda0b7f203bb net/sched: Revert "net/sched: Restrict conditions for adding duplicating netems to qdisc tree"
> > b213a4c6074f Revert "selftests/tc-testing: Add tests for restrictions on netem duplication"
> > 9552b11e3eda net/sched: fix packet loop on netem when duplicate is on
> > db875221ab08 net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
> > a005fa5d7502 net/sched: act_mirred: Fix blockcast recursion bypass leading to stack overflow
> > e80ad525fc7e net/sched: act_mirred: Fix return code in early mirred redirect error paths
> > d38dc56a0225 selftests/tc-testing: Add mirred test cases exercising loops
> > 0f6e00aa5f65 selftests/tc-testing: Add netem test case exercising loops
> > 
> > You included most of those in 6.12.93 and 7.0.12, but for the older
> > branches and 6.18 I'm only seeing this one.
> > 
> > Ben.
> > 
> 
> LGTM
> The important part is to pick up the packet loop detection in netem and mirred

Ok, for now, I'll drop this one and wait for someone to provide full
backports to all of the kernels.

thanks,

greg k-h
