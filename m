Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6E53A7;
	Thu, 31 Oct 2024 01:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339913; cv=none; b=MlZwKl4QkDGWYdxod/brM2iHdpWRpIAV0GJEjCZ2ecb7ki32lBlRlUx8drzGE1XhoeL+O1LnaQuc0ddpNRqMjRe1vFSgbuw8Po31tmifQxxIg+/Er6HKxghXvvjw2Y6QqocALD74O9DSz5Sx5S1AHo0GpLQjM4jO1rOoBbJIY88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339913; c=relaxed/simple;
	bh=9SAfMZKRAGCMzi6Bxf3p8pMoE4NEPe9FyWazsj+F8X4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ivmNcElfDPHP0DnILm0kdohIM7ZhZ+lVSj929SAbeCdJT3ZCDWCmjlDrQvNUQsaTxOSdVM8wteetHyzDClFrzJxccpRuxYj7RVTpgzbO3NVjZcdUdKQtboyf7fKHlZQvkGwpLqERamn4cr+F061VWDAYkKokhblgLImbemC8XOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHjTWA/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHjTWA/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF6C4CECE;
	Thu, 31 Oct 2024 01:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730339912;
	bh=9SAfMZKRAGCMzi6Bxf3p8pMoE4NEPe9FyWazsj+F8X4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dHjTWA/4fbuKkZx1m4MVHwwQdbEOzpIx4ZQjDSL3Kh2wLydPl/3JVPRki3hyhx7ZO
	 gaPoOD76GCNbK3t+yQ4dKVZYB3TPX2Ym93kL1JKdaCcDzvlGyuNZzYH8+QkEqbL4mt
	 GbnVv4na+Cr21mJHQELXRcNpR6M0DKgQJqDq3ZQHYIpXRZjikqWiwdjuZwxve5MocH
	 Zl/SyBIPV3+PIcd9CMk9ksnp/AFeid6Al2P27BFtdhMYwFDHJJbXuvqzaAvAZExl+A
	 v8H2nuHq6iHA0luRILqu/8iexfNeDSKJhO5u6KDfsO9eW2M0bhTDj+O+Zo6diDy+fw
	 M54XO7df8esww==
Date: Thu, 31 Oct 2024 10:58:27 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>, Anil S Keshavamurthy
 <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 1/2] kprobes: Fix __get_insn_slot() after __counted_by
 annotation
Message-Id: <20241031105827.08b362cf0dcf558f9cf59ad8@kernel.org>
In-Reply-To: <20241030-kprobes-fix-counted-by-annotation-v1-1-8f266001fad0@kernel.org>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
	<20241030-kprobes-fix-counted-by-annotation-v1-1-8f266001fad0@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Oct 2024 09:14:48 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> Commit 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
> added a __counted_by annotation without adjusting the code for the
> __counted_by requirements, resulting in a panic when UBSAN_BOUNDS and
> FORTIFY_SOURCE are enabled:
> 
>   | memset: detected buffer overflow: 512 byte write of buffer size 0
>   | WARNING: CPU: 0 PID: 1 at lib/string_helpers.c:1032 __fortify_report+0x64/0x80
>   | Call Trace:
>   |  __fortify_report+0x60/0x80 (unreliable)
>   |  __fortify_panic+0x18/0x1c
>   |  __get_insn_slot+0x33c/0x340
> 
> __counted_by requires that the counter be set before accessing the
> flexible array but ->nused is not set until after ->slot_used is
> accessed via memset(). Even if the current ->nused assignment were moved
> up before memset(), the value of 1 would be incorrect because the entire
> array is being accessed, not just one element.

Ah, I think I misunderstood the __counted_by(). If so, ->nused can be
smaller than the accessing element of slot_used[]. I should revert it.
The accessing index and ->nused should have no relationship.

for example, slots_per_page(c) is 10, and 10 kprobes are registered
and then, the 1st and 2nd kprobes are unregistered. At this moment,
->nused is 8 but slot_used[9] is still used. To unregister this 10th
kprobe, we have to access slot_used[9].

So let's just revert the commit 0888460c9050.

Thank you,

> 
> Set ->nused to the full number of slots from slots_per_page() before
> calling memset() to resolve the panic. While it is not strictly
> necessary because of the new assignment, move the existing ->nused
> assignment above accessing ->slot_used[0] for visual consistency.
> 
> The value of slots_per_page() should not change throughout
> __get_insn_slot() because ->insn_size is never modified after its
> initial assignment (which has to be done by this point otherwise it
> would be incorrect) and the other values are constants, so use a new
> variable to reuse its value directly.
> 
> Fixes: 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  kernel/kprobes.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 98d71a5acb723ddfff3efcc44cc6754ee36ec1de..2cf4628bc97ce2ae18547b513cd75b6350e9cc9c 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -145,16 +145,18 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
>  {
>  	struct kprobe_insn_page *kip;
>  	kprobe_opcode_t *slot = NULL;
> +	int num_slots;
>  
>  	/* Since the slot array is not protected by rcu, we need a mutex */
>  	mutex_lock(&c->mutex);
> +	num_slots = slots_per_page(c);
>   retry:
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(kip, &c->pages, list) {
> -		if (kip->nused < slots_per_page(c)) {
> +		if (kip->nused < num_slots) {
>  			int i;
>  
> -			for (i = 0; i < slots_per_page(c); i++) {
> +			for (i = 0; i < num_slots; i++) {
>  				if (kip->slot_used[i] == SLOT_CLEAN) {
>  					kip->slot_used[i] = SLOT_USED;
>  					kip->nused++;
> @@ -164,7 +166,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
>  				}
>  			}
>  			/* kip->nused is broken. Fix it. */
> -			kip->nused = slots_per_page(c);
> +			kip->nused = num_slots;
>  			WARN_ON(1);
>  		}
>  	}
> @@ -175,7 +177,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
>  		goto retry;
>  
>  	/* All out of space.  Need to allocate a new page. */
> -	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(slots_per_page(c)), GFP_KERNEL);
> +	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(num_slots), GFP_KERNEL);
>  	if (!kip)
>  		goto out;
>  
> @@ -185,9 +187,11 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
>  		goto out;
>  	}
>  	INIT_LIST_HEAD(&kip->list);
> -	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
> -	kip->slot_used[0] = SLOT_USED;
> +	/* nused must be set before accessing slot_used */
> +	kip->nused = num_slots;
> +	memset(kip->slot_used, SLOT_CLEAN, num_slots);
>  	kip->nused = 1;
> +	kip->slot_used[0] = SLOT_USED;
>  	kip->ngarbage = 0;
>  	kip->cache = c;
>  	list_add_rcu(&kip->list, &c->pages);
> 
> -- 
> 2.47.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
