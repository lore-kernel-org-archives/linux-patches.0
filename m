Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AB31100
	for <patches@lists.linux.dev>; Tue, 26 Sep 2023 02:49:39 +0000 (UTC)
Date: Mon, 25 Sep 2023 19:49:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695696577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KsOaFDbsgZ6azgPIUFRm68AgjbUNl5+lAAmJUzShuJw=;
	b=OOns7TyqlCgDQgzlUHreD4BhyUyXY3xo2emigxpQd7k+0klb4BK9Wiegn7DEXkGXiZxsy2
	57HdGmEhMcUYkwpgHMPzc4L+kmbQLQMYgcfANprQafT9rN9X8H/hRAYj9mVGEfJhuxxLnT
	LTSxHhKYeTUSFO83ggkzRFlhAjfeuwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	mathieu.tortuyaux@gmail.com
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop
 kmem.limit_in_bytes
Message-ID: <ZRJGu6iHDcub_IwR@P9FQF9L96D.corp.robot.car>
References: <20230917191040.964416434@linuxfoundation.org>
 <20230917191042.204185566@linuxfoundation.org>
 <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz>
 <101987a1-b1ab-429d-af03-b6bdf6216474@linux.microsoft.com>
 <ZQrSXh+riB7NnZuE@dhcp22.suse.cz>
 <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz>
 <ZQ4cjqQLhgX1pOVX@P9FQF9L96D.corp.robot.car>
 <ZRE5pHgr28SaOmMC@dhcp22.suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRE5pHgr28SaOmMC@dhcp22.suse.cz>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 25, 2023 at 09:41:24AM +0200, Michal Hocko wrote:
> On Fri 22-09-23 16:00:30, Roman Gushchin wrote:
> > On Wed, Sep 20, 2023 at 03:47:37PM +0200, Michal Hocko wrote:
> > > On Wed 20-09-23 15:25:23, Jeremi Piotrowski wrote:
> > > > On 9/20/2023 1:07 PM, Michal Hocko wrote:
> > > [...]
> > > > > I mean, normally I would be just fine reverting this API change because
> > > > > it is disruptive but the only way to have the file available and not
> > > > > break somebody is to revert 58056f77502f ("memcg, kmem: further
> > > > > deprecate kmem.limit_in_bytes") as well. Or to ignore any value written
> > > > > there but that sounds rather dubious. Although one could argue this
> > > > > would mimic nokmem kernel option.
> > > > > 
> > > > 
> > > > I just want to make sure we don't introduce yet another new behavior in this legacy
> > > > system. I have not seen breakage due to 58056f77502f. Mimicing nokmem sounds good but
> > > > does this mean "don't enforce limits" (that should be fine) or "ignore writes to the limit"
> > > > (=don't event store the written limit). The latter might have unintended consequences.
> > > 
> > > Yes it would mean that the limit is never enforced. Bad as it is the
> > > thing is that the hard limit on kernel memory is broken by design and
> > > unfixable.  This causes all sorts of unexpected kernel allocation
> > > failures that this is simply unsafe to use.
> > > 
> > > All that being said I can see the following options
> > > 1) keep the current upstream status and not export the file
> > > 2) revert both 58056f77502f and 86327e8eb94 and make it clear
> > >    that kmem.limit_in_bytes is unsupported so failures or misbehavior
> > >    as a result of the limit being hit are likely not going to be
> > >    investigated or fixed.
> > > 3) reverting like in 2) but never inforce the limit (so basically nokmem
> > >    semantic)
> > 
> > Since it's a part of cgroup v1 interface, which is in a frozen state as a whole,
> > and there is no significant (performance, code complexity) benefit of
> > additionally deprecating kmem.limit_in_bytes, I vote for 2).
> > 1) is also an option.
> 
> We have a stronger agrement over 3)
> http://lkml.kernel.org/r/ZRE5VJozPZt9bRPy@dhcp22.suse.cz. Please speak
> up if you disagree.

This works for me too.
Thank you!

Btw, it seems like going forward we should be more resistant for any
cgroup v1 changes and just leave it as it is.

Thanks.
