Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1C9157A72
	for <patches@lists.linux.dev>; Mon, 28 Apr 2025 02:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745807698; cv=none; b=hce7l24Rm9BBBKm/sJuZgsu+zwSXnNWIOJmFIkJ8f4DbOucgnC9ElukD+x6kCxk7JRBmiZ2zWF+00sJ3ryqxhM5OBJv+Azg/hmCD7n7rTC8qHmR3+5nQ06OBmVCExEDnZdVX7KK8BiAkhYKGlQO1gMC5Ullr5othJ5htnyO9d68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745807698; c=relaxed/simple;
	bh=sQWVX5XMLGKXftxZqCjUh6JsyiNKX1MaQ1gWHUo5Y3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uplsO7qlPK8QOVTHYSjGJrr5aOz8oBURjIQ2kyI5NVGKq6QDJzZv6jEs3W55POAEm2jUPA7oRzyTQqtHeTjvyXb507lUVkZAtesosd5CvYOwXacKzMsK6CC5qYeSKnI2q8O+ap8qMiBFaJg8VwmWfj1vXVx+8tCanHSxHB4CHzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qBZkFltv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBZkFltv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D499C4CEE9;
	Mon, 28 Apr 2025 02:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745807696;
	bh=sQWVX5XMLGKXftxZqCjUh6JsyiNKX1MaQ1gWHUo5Y3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qBZkFltv3i3ud6XIjFwKOA3jy3M8Koh240Uh+2HdAj5AT2krq0VxJrAvfWi0hNFA6
	 kZPMi8iQ8w6BayT04f0j+DwYG0nSM+6GRs2e65OxVOrMLMTIYpel9s8lQkJRo4shKF
	 jaAWRPr0rt+nJVsZBu6MisCFx6AHAuOVZf9/gt4yYe7vMYG3D7OCVph/ZJxd4Jvy34
	 PIcdMkawABQ5t75pofIVthbW3JDF+UfFs4i5VlxVW3pDsy0m6fvI3LiV1KDrH1jj0F
	 RB9Gec0riE8RirWPYPWEiQMmDabdzT02Vd0DlwnYx1awJHFbbC9FGoIOqGPyefRFKB
	 25FolS69iaCvg==
Message-ID: <499792a6-f907-47aa-ae30-4b9d6fcee669@kernel.org>
Date: Sun, 27 Apr 2025 19:34:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ARC: atomics: Implement arch_atomic64_cmpxchg using
 _relaxed
To: Jason Gunthorpe <jgg@nvidia.com>, Boqun Feng <boqun.feng@gmail.com>,
 linux-snps-arc@lists.infradead.org, Peter Zijlstra <peterz@infradead.org>,
 Vineet Gupta <vgupta@kernel.org>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
References: <0-v1-2a485c0aa33a+505-arc_atomic_jgg@nvidia.com>
From: Vineet Gupta <vgupta@kernel.org>
Content-Language: en-US
In-Reply-To: <0-v1-2a485c0aa33a+505-arc_atomic_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/8/25 10:22, Jason Gunthorpe wrote:
> The core atomic code has a number of macros where it elaborates
> architecture primitives into more functions. ARC uses
> arch_atomic64_cmpxchg() as it's architecture primitive which disable alot
> of the additional functions.
>
> Instead provide arch_cmpxchg64_relaxed() as the primitive and rely on the
> core macros to create arch_cmpxchg64().
>
> The macros will also provide other functions, for instance,
> try_cmpxchg64_release(), giving a more complete implementation.
>
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Link: https://lore.kernel.org/r/Z0747n5bSep4_1VX@J2N7QTR9R3
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: Vineet Gupta <vgupta@kernel.org>

> ---
>  arch/arc/include/asm/atomic64-arcv2.h | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arc/include/asm/atomic64-arcv2.h b/arch/arc/include/asm/atomic64-arcv2.h
> index 9b5791b8547133..73080a664369b4 100644
> --- a/arch/arc/include/asm/atomic64-arcv2.h
> +++ b/arch/arc/include/asm/atomic64-arcv2.h
> @@ -137,12 +137,9 @@ ATOMIC64_OPS(xor, xor, xor)
>  #undef ATOMIC64_OP_RETURN
>  #undef ATOMIC64_OP
>  
> -static inline s64
> -arch_atomic64_cmpxchg(atomic64_t *ptr, s64 expected, s64 new)
> +static inline u64 __arch_cmpxchg64_relaxed(volatile void *ptr, u64 old, u64 new)
>  {
> -	s64 prev;
> -
> -	smp_mb();
> +	u64 prev;
>  
>  	__asm__ __volatile__(
>  	"1:	llockd  %0, [%1]	\n"
> @@ -152,14 +149,12 @@ arch_atomic64_cmpxchg(atomic64_t *ptr, s64 expected, s64 new)
>  	"	bnz     1b		\n"
>  	"2:				\n"
>  	: "=&r"(prev)
> -	: "r"(ptr), "ir"(expected), "r"(new)
> -	: "cc");	/* memory clobber comes from smp_mb() */
> -
> -	smp_mb();
> +	: "r"(ptr), "ir"(old), "r"(new)
> +	: "memory", "cc");
>  
>  	return prev;
>  }
> -#define arch_atomic64_cmpxchg arch_atomic64_cmpxchg
> +#define arch_cmpxchg64_relaxed __arch_cmpxchg64_relaxed
>  
>  static inline s64 arch_atomic64_xchg(atomic64_t *ptr, s64 new)
>  {
>
> base-commit: ea8f6ee2111cd78b32d0363ea630ba9b08ada22d

Thx for this.

FWIW I missed the cmpxchg API when the rest of atomics were relaxed in commit
301014cf6d728 ("ARC: atomic_cmpxchg/atomic_xchg: implement relaxed variants")

Added to ARC for-curr (for next)

Thx,
-Vineet
