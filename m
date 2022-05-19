Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC497A;
	Thu, 19 May 2022 07:22:02 +0000 (UTC)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <heiko@sntech.de>)
	id 1nraTh-0004Vm-9x; Thu, 19 May 2022 09:21:45 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, Jessica Clarke <jrtc27@jrtc27.com>
Subject: Re: [PATCH] riscv: Fix ALT_THEAD_PMA's asm parameters
Date: Thu, 19 May 2022 09:21:44 +0200
Message-ID: <3667011.kQq0lBPeGt@diego>
In-Reply-To: <20220518184529.454008-1-nathan@kernel.org>
References: <20220518184529.454008-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch, 18. Mai 2022, 20:45:29 CEST schrieb Nathan Chancellor:
> After commit a35707c3d850 ("riscv: add memory-type errata for T-Head"),
> builds with LLVM's integrated assembler fail like:
> 
>   In file included from arch/riscv/kernel/asm-offsets.c:10:
>   In file included from ./include/linux/mm.h:29:
>   In file included from ./include/linux/pgtable.h:6:
>   In file included from ./arch/riscv/include/asm/pgtable.h:114:
>   ./arch/riscv/include/asm/pgtable-64.h:210:2: error: invalid input constraint '0' in asm
>           ALT_THEAD_PMA(prot_val);
>           ^
>   ./arch/riscv/include/asm/errata_list.h:88:4: note: expanded from macro 'ALT_THEAD_PMA'
>           : "0"(_val),                                                    \
>             ^
> 
> This was reported upstream to LLVM where Jessica pointed out a couple of
> issues with the existing implementation of ALT_THEAD_PMA:
> 
> * t3 is modified but not listed in the clobbers list.
> 
> * "+r"(_val) marks _val as both an input and output of the asm but then
>   "0"(_val) marks _val as an input matching constraint, which does not
>   make much sense in this situation, as %1 is not actually used in the
>   asm and matching constraints are designed to be used for different
>   inputs that need to use the same register.
> 
> Drop the matching contraint and shift all the operands by one, as %1 is
> unused, and mark t3 as clobbered. This resolves the build error and goes
> not cause any problems with GNU as.
> 
> Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1641
> Link: https://github.com/llvm/llvm-project/issues/55514
> Link: https://gcc.gnu.org/onlinedocs/gcc/Simple-Constraints.html
> Suggested-by: Jessica Clarke <jrtc27@jrtc27.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

I'm not sure anymore why it ended up the original way, but with this change
it definitly looks better

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

On an actual D1-Nezha board also

Tested-by: Heiko Stuebner <heiko@sntech.de>


Thanks for doing that improvement
Heiko

> ---
>  arch/riscv/include/asm/errata_list.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
> index 9e2888dbb5b1..416ead0f9a65 100644
> --- a/arch/riscv/include/asm/errata_list.h
> +++ b/arch/riscv/include/asm/errata_list.h
> @@ -75,20 +75,20 @@ asm volatile(ALTERNATIVE(						\
>  	"nop\n\t"							\
>  	"nop\n\t"							\
>  	"nop",								\
> -	"li      t3, %2\n\t"						\
> -	"slli    t3, t3, %4\n\t"					\
> +	"li      t3, %1\n\t"						\
> +	"slli    t3, t3, %3\n\t"					\
>  	"and     t3, %0, t3\n\t"					\
>  	"bne     t3, zero, 2f\n\t"					\
> -	"li      t3, %3\n\t"						\
> -	"slli    t3, t3, %4\n\t"					\
> +	"li      t3, %2\n\t"						\
> +	"slli    t3, t3, %3\n\t"					\
>  	"or      %0, %0, t3\n\t"					\
>  	"2:",  THEAD_VENDOR_ID,						\
>  		ERRATA_THEAD_PBMT, CONFIG_ERRATA_THEAD_PBMT)		\
>  	: "+r"(_val)							\
> -	: "0"(_val),							\
> -	  "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_PBMT_SHIFT),		\
> +	: "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_PBMT_SHIFT),		\
>  	  "I"(_PAGE_PMA_THEAD >> ALT_THEAD_PBMT_SHIFT),			\
> -	  "I"(ALT_THEAD_PBMT_SHIFT))
> +	  "I"(ALT_THEAD_PBMT_SHIFT)					\
> +	: "t3")
>  #else
>  #define ALT_THEAD_PMA(_val)
>  #endif
> 
> base-commit: 93c0651617a62a69717299f1464dda798af8bebb
> 




