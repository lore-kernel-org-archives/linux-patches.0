Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C571CF9B;
	Mon,  9 Sep 2024 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725894577; cv=none; b=uGdgq7tAuSFkA928gYYfH8ZCJqXLtd123ynCYBvdJh1u9iWWdxEX6fv6ntfljg9C+HvmSHS3UEgCcszM0UTltZo3TL3Ftcb/o8Oe/g8cq3RyNDQa1hGlKo3hPsyfYHsZiq4kVaS+ix3xsduOdNDGLOSPDW2OAoXQ7l2e7GBlFKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725894577; c=relaxed/simple;
	bh=Kc0K8mFNm7XDv1OvvGn2fVjEjW+2Hx4OIZ1+QD2rSd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uagIdlSsuY9E5gwdXA9sMD+RLZMrik8sQk/m+8nEdjsGFICMmd10SdhXrRghsjzgQ7jL+0gomWxHDv0xQmFTxyaRjQFIHNK2wnD+NgJeudLl5yvRjgA/f6e9/616nhjsQONyKEUFVVWu5ZuVyI/9C8u+eXx9gCNKzAhFwVoU0FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpSy66SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpSy66SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23B2C4CECF;
	Mon,  9 Sep 2024 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725894577;
	bh=Kc0K8mFNm7XDv1OvvGn2fVjEjW+2Hx4OIZ1+QD2rSd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IpSy66SGkZdNpeWZLl1Geezk+PGJLqZlE75pHTx6CMxZd8r0J5bJNLyqs81CpGDgz
	 GimC+5Ai391bF3VUuc9GveHbzgsZsfxMqp1xCr5wv5gQ8sAowRTAardJ/QDZWPkio5
	 vzrTU0wEzjUEvf6oUvqIqUukWYxYxfU61m13VnLBNXGxD4kQFcFO/ZJIkb/L6adpfl
	 DnY3MVEdTlXl2jCjZvVabvvYwruRQ6ZxvFQMMu/vcPpBuWNWgpxQjFDexgRzY9tKEO
	 uyEzUSo7zkKvWQx5kivp3xbrnoSeh3CkJnfP/2PBw4R6LZx5Qn+DyCLEi39ToNL3w1
	 5daJ2d58GGPBg==
Date: Mon, 9 Sep 2024 08:09:34 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH ipsec-next v2] xfrm: policy: Restore dir assignments in
 xfrm_hash_rebuild()
Message-ID: <20240909150934.GA1111756@thelio-3990X>
References: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v2-1-1cf8958f6e8e@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v2-1-1cf8958f6e8e@kernel.org>

Ping? This is still seen on next-20240909.

On Thu, Aug 29, 2024 at 11:14:54AM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR):
> 
>   net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
>    1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
>         |                      ^~~
>   net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
>    1257 |         int dir;
>         |                ^
>         |                 = 0
>   1 error generated.
> 
> A recent refactoring removed some assignments to dir because
> xfrm_policy_is_dead_or_sk() has a dir assignment in it. However, dir is
> used elsewhere in xfrm_hash_rebuild(), including within loops where it
> needs to be reloaded for each policy. Restore the assignments before the
> first use of dir to fix the warning and ensure dir is properly
> initialized throughout the function.
> 
> Fixes: 08c2182cf0b4 ("xfrm: policy: use recently added helper in more places")
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Restore another dir assignment in
>     list_for_each_entry_reverse(policy, ...
>   loop, necessitating a value reload to avoid a stale value (thanks to
>   Florian for the review).
> - Reword commit message slightly based on above change.
> - Pick up Florian's ack.
> - Add 'ipsec-next' subject prefix.
> - Link to v1: https://lore.kernel.org/r/20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org
> ---
>  net/xfrm/xfrm_policy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 6336baa8a93c..63890c0628c4 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1283,6 +1283,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>  		if (xfrm_policy_is_dead_or_sk(policy))
>  			continue;
>  
> +		dir = xfrm_policy_id2dir(policy->index);
>  		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
>  			if (policy->family == AF_INET) {
>  				dbits = rbits4;
> @@ -1337,6 +1338,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>  		hlist_del_rcu(&policy->bydst);
>  
>  		newpos = NULL;
> +		dir = xfrm_policy_id2dir(policy->index);
>  		chain = policy_hash_bysel(net, &policy->selector,
>  					  policy->family, dir);
>  
> 
> ---
> base-commit: 17163f23678c7599e40758d7b96f68e3f3f2ea15
> change-id: 20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-749ca2264581
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
