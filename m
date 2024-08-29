Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F5314B086;
	Thu, 29 Aug 2024 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724954824; cv=none; b=nLOJ2V4Abhg3MCAKy1ff4H5IoVjpkAt304tc4lxHPQnerL0uHSQgunDZNOUJ476+mCmLdy+hDe3D9yAwEuAugLWe5jtTylySPOH+Zz4M7mv3VV9DQNM+rx96KpCF1R6nz9KLwbfoNy2Shx14vS9p96Niw4y1QFvD7jwlZgJvE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724954824; c=relaxed/simple;
	bh=atw2RuO6vfZX3k63ZXtEHPGul+rCa1nUKe493obTjY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNIxcX7VDiPu92j06nqjoOyUaV9n2Q9atkoo1REW23v9/kKjvAyqinXaHWlQKT7gM8Ylfn935hijyyZiQEM/mkiWLoua9L1HROtLSpfpv0m35Yss7BAGQIKMkEuZhuMsYc5Gy/mpYWjYS79OGIWa9Z6JD2yIPMqLM5gpTk2crHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+1e7US7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+1e7US7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE58C4CEC1;
	Thu, 29 Aug 2024 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724954823;
	bh=atw2RuO6vfZX3k63ZXtEHPGul+rCa1nUKe493obTjY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+1e7US7Fw4NQQEWzeGfNuoy13gFIt6RSfAig6aO7xvajC6k92FB/3ffrX40p52RP
	 GnvZdnDCYzAIuaH4q1DnanZF+lVfPylDNdnRpMVJ8LKBZ5GTdxg/21JOq91zs7uJFP
	 I/Uiakz86EMgMFZy22dU32C2BkWPK8leq9AnDWMEeLcMc9ToBqUCiZbxuXEilFgZ6o
	 f/513azk1dD+Dz6hvYIN63MZW5QhYDEIw7vl4UoEPcpGwPCX84ichZ0aNRpvgk4Vwv
	 DaN0UgcY7RZsxBwUaBD3IRn1oH9oMQVbq94J4H/ZYArTcrud+rj6ypH4T/bsj4KK4u
	 TQfa7R1KBorvA==
Date: Thu, 29 Aug 2024 11:07:01 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] xfrm: policy: Restore dir assignment in
 xfrm_hash_rebuild()
Message-ID: <20240829180701.GA3894635@thelio-3990X>
References: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org>
 <20240829175411.GA22324@breakpoint.cc>
 <20240829180205.GA22521@breakpoint.cc>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829180205.GA22521@breakpoint.cc>

On Thu, Aug 29, 2024 at 08:02:05PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Nathan Chancellor <nathan@kernel.org> wrote:
> > > Clang warns (or errors with CONFIG_WERROR):
> > > 
> > >   net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
> > >    1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
> > >         |                      ^~~
> > >   net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
> > >    1257 |         int dir;
> > >         |                ^
> > >         |                 = 0
> > >   1 error generated.
> > 
> > Ugh, my bad.
> > 
> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> Actually, this fix is incomplete, the assignment needs to be
> restored in the second loop as well:
> 
> 1340                 chain = policy_hash_bysel(net, &policy->selector,
> 1341                                           policy->family, dir);
> 							       ~~~
> 
> Nathan, Steffen, I'll leave it up to you to either do a v2 or a revert.

Ah, good catch. I'll send a v2 shortly with this fixed and your ack
picked up.

Cheers,
Nathan
