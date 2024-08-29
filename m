Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BBB24B28;
	Thu, 29 Aug 2024 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724954530; cv=none; b=kdOYD5UEat/NoBOxJH7qh48yHYpUz4yIFACb/JERBe8e92ZCtJQZRX0h+412vYK3Hze8O6nr1MWx5OuRYZXEop0hhvkgJwB1JsoNCfsKxdyicAVJtM89YoxzBZTUa3BMJnSbfOe4FsGDuEDUJxn/f+I/ZrUDo/bBCZO+Knom9Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724954530; c=relaxed/simple;
	bh=Tp59YiHtyy6Xa71BGo17CibGmtxxPygWKHWUVq5g8cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KF2gXHgrNmvSCbWBqYkUCluJtnjRuB0sTldUTMWv7lPtpffgX6KyGTmeUqKtwCJ5vnuUs0aVNllK2lqTUQUypcXQ42GQyHtt4DTP4qWY3BYt1J2xmyWbp6piWU4iyxsLZqk3V26zTjbsShunvyFeLnGQVua7Bpdiv7MCNMo3au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sjjTB-0005si-2d; Thu, 29 Aug 2024 20:02:05 +0200
Date: Thu, 29 Aug 2024 20:02:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] xfrm: policy: Restore dir assignment in
 xfrm_hash_rebuild()
Message-ID: <20240829180205.GA22521@breakpoint.cc>
References: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org>
 <20240829175411.GA22324@breakpoint.cc>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829175411.GA22324@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Nathan Chancellor <nathan@kernel.org> wrote:
> > Clang warns (or errors with CONFIG_WERROR):
> > 
> >   net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
> >    1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
> >         |                      ^~~
> >   net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
> >    1257 |         int dir;
> >         |                ^
> >         |                 = 0
> >   1 error generated.
> 
> Ugh, my bad.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Actually, this fix is incomplete, the assignment needs to be
restored in the second loop as well:

1340                 chain = policy_hash_bysel(net, &policy->selector,
1341                                           policy->family, dir);
							       ~~~

Nathan, Steffen, I'll leave it up to you to either do a v2 or a revert.
