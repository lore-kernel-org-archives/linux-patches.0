Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC07134B6;
	Wed,  1 Nov 2023 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0c3YMyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8A5C433C7;
	Wed,  1 Nov 2023 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698868519;
	bh=jrvY9YCcJjZ5OxVqeMAKfX9PtWUoR1UgPEEa+G6kyz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j0c3YMyAlGvQBp0NpzOfyBKS2rNIV+2PtzQnaNTGP3GDbYBGmSSJflAjif+wWNsn5
	 lE4keyXL7t9c6aMwXE69jeI988VPvahDhobSH69kK/yQH6zz8VTKsM3zFLC2u1EzvE
	 uv3wtU/qvzMazKf33b5gJj/vhcUew+Lk1RmLeZMvzxDHLM5f6wjQFQp/C0/4mDs1TJ
	 UvQDjZPRJrpWjurdD6PbW87fMpc8cnnWKWykgicrhCiDxoWZMsiAc5cKkhoAuf70W4
	 SuCEPscIpqrroNmWhpZ5j+O9BuB3+/+EjPtaxu3ynULvSaK8fNv0od1xTB4R1Y/gzK
	 WPc4qKi9/8hVQ==
Date: Wed, 1 Nov 2023 12:55:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: chenhuacai@kernel.org, kernel@xen0n.name
Cc: ndesaulniers@google.com, trix@redhat.com, jiaxun.yang@flygoat.com,
	loongarch@lists.linux.dev, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] LoongArch: Mark __percpu functions as always inline
Message-ID: <20231101195517.GA1221384@dev-arch.thelio-3990X>
References: <20231101-loongarch-always-inline-percpu-ops-v1-1-b8f2e9a71729@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101-loongarch-always-inline-percpu-ops-v1-1-b8f2e9a71729@kernel.org>

On Wed, Nov 01, 2023 at 12:43:29PM -0700, Nathan Chancellor wrote:
> A recent change to the optimization pipeline in LLVM reveals some
> fragility around the inlining of LoongArch's __percpu functions, which
> manifests as a BUILD_BUG() failure:
> 
>   In file included from kernel/sched/build_policy.c:17:
>   In file included from include/linux/sched/cputime.h:5:
>   In file included from include/linux/sched/signal.h:5:
>   In file included from include/linux/rculist.h:11:
>   In file included from include/linux/rcupdate.h:26:
>   In file included from include/linux/irqflags.h:18:
>   arch/loongarch/include/asm/percpu.h:97:3: error: call to '__compiletime_assert_51' declared with 'error' attribute: BUILD_BUG failed
>      97 |                 BUILD_BUG();
>         |                 ^
>   include/linux/build_bug.h:59:21: note: expanded from macro 'BUILD_BUG'
>      59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>         |                     ^
>   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
>      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>         |                                     ^
>   include/linux/compiler_types.h:425:2: note: expanded from macro 'compiletime_assert'
>     425 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>         |         ^
>   include/linux/compiler_types.h:413:2: note: expanded from macro '_compiletime_assert'
>     413 |         __compiletime_assert(condition, msg, prefix, suffix)
>         |         ^
>   include/linux/compiler_types.h:406:4: note: expanded from macro '__compiletime_assert'
>     406 |                         prefix ## suffix();                             \
>         |                         ^
>   <scratch space>:86:1: note: expanded from here
>      86 | __compiletime_assert_51
>         | ^
>   1 error generated.
> 
> If these functions are not inlined, the BUILD_BUG() in the default case
> cannot be eliminated since the compiler cannot prove it is never used,
> resulting in a build failure due to the error attribute.
> 
> Mark these functions as __always_inline so that the BUILD_BUG() only
> triggers when the default case genuinely cannot be eliminated due to an
> unexpected size.
> 
> Cc:  <stable@vger.kernel.org>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1955
> Fixes: 46859ac8af52 ("LoongArch: Add multi-processor (SMP) support")
> Link: https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c607313a566eebb16e

This should have also had:

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>

I can pick it up if I have to send a v2.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/loongarch/include/asm/percpu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/percpu.h b/arch/loongarch/include/asm/percpu.h
> index b9f567e66016..8fb857ae962b 100644
> --- a/arch/loongarch/include/asm/percpu.h
> +++ b/arch/loongarch/include/asm/percpu.h
> @@ -32,7 +32,7 @@ static inline void set_my_cpu_offset(unsigned long off)
>  #define __my_cpu_offset __my_cpu_offset
>  
>  #define PERCPU_OP(op, asm_op, c_op)					\
> -static inline unsigned long __percpu_##op(void *ptr,			\
> +static __always_inline unsigned long __percpu_##op(void *ptr,			\
>  			unsigned long val, int size)			\
>  {									\
>  	unsigned long ret;						\
> @@ -63,7 +63,7 @@ PERCPU_OP(and, and, &)
>  PERCPU_OP(or, or, |)
>  #undef PERCPU_OP
>  
> -static inline unsigned long __percpu_read(void *ptr, int size)
> +static __always_inline unsigned long __percpu_read(void *ptr, int size)
>  {
>  	unsigned long ret;
>  
> 
> ---
> base-commit: 278be83601dd1725d4732241f066d528e160a39d
> change-id: 20231101-loongarch-always-inline-percpu-ops-cf77c161871f
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
