Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8416ED0;
	Mon, 16 May 2022 22:37:20 +0000 (UTC)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <heiko@sntech.de>)
	id 1nqigu-0006Sd-3x; Mon, 16 May 2022 23:55:48 +0200
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] riscv: Move alternative length validation into subsection
Date: Mon, 16 May 2022 23:55:47 +0200
Message-ID: <2827138.e9J7NaK4W3@diego>
In-Reply-To: <20220516214520.3252074-1-nathan@kernel.org>
References: <20220516214520.3252074-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

Am Montag, 16. Mai 2022, 23:45:21 CEST schrieb Nathan Chancellor:
> After commit 49b290e430d3 ("riscv: prevent compressed instructions in
> alternatives"), builds with LLVM's integrated assembler fail:

the commit in question didn't change anything there, so I guess
the issue itself was present before that already and the
commit only triggered the different buildbots?


>   In file included from arch/riscv/mm/init.c:10:
>   In file included from ./include/linux/mm.h:29:
>   In file included from ./include/linux/pgtable.h:6:
>   In file included from ./arch/riscv/include/asm/pgtable.h:108:
>   ./arch/riscv/include/asm/tlbflush.h:23:2: error: expected assembly-time absolute expression
>           ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
>           ^
>   ./arch/riscv/include/asm/errata_list.h:33:5: note: expanded from macro 'ALT_FLUSH_TLB_PAGE'
>   asm(ALTERNATIVE("sfence.vma %0", "sfence.vma", SIFIVE_VENDOR_ID,        \
>       ^
>   ./arch/riscv/include/asm/alternative-macros.h:187:2: note: expanded from macro 'ALTERNATIVE'
>           _ALTERNATIVE_CFG(old_content, new_content, vendor_id, errata_id, CONFIG_k)
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:113:2: note: expanded from macro '_ALTERNATIVE_CFG'
>           __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, IS_ENABLED(CONFIG_k))
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:110:2: note: expanded from macro '__ALTERNATIVE_CFG'
>           ALT_NEW_CONTENT(vendor_id, errata_id, enable, new_c)
>           ^
>   ./arch/riscv/include/asm/alternative-macros.h:99:3: note: expanded from macro 'ALT_NEW_CONTENT'
>           ".org   . - (889b - 888b) + (887b - 886b)\n"                    \
>            ^
>   <inline asm>:26:6: note: instantiated into assembly here
>   .org    . - (889b - 888b) + (887b - 886b)
>           ^
> 
> This error happens because LLVM's integrated assembler has a one-pass
> design, which means it cannot figure out the instruction lengths when
> the .org directive is outside of the subsection that contains the
> instructions, which was changed by the .option directives added by the
> above change.
> 
> Move the .org directives before the .previous directive so that these
> directives are always within the same subsection, which resolves the
> failures and does not introduce any new issues with GNU as. This was
> done for arm64 in commit 966a0acce2fc ("arm64/alternatives: move length
> validation inside the subsection") and commit 22315a2296f4 ("arm64:
> alternatives: Move length validation in alternative_{insn, endif}").
> 
> While there is no error from the assembly versions of the macro, they
> appear to have the same problem so just make the same change there as
> well so that there are no problems in the future.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1640
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

In any case, on my svpbmt testcases (qemu + d1-nezha):
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Thanks for looking into that
Heiko


> ---
>  arch/riscv/include/asm/alternative-macros.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
> index e13b1f6bb400..ec2f3f1b836f 100644
> --- a/arch/riscv/include/asm/alternative-macros.h
> +++ b/arch/riscv/include/asm/alternative-macros.h
> @@ -27,9 +27,9 @@
>  	\new_c
>  	.option pop
>  889 :
> -	.previous
>  	.org    . - (889b - 888b) + (887b - 886b)
>  	.org    . - (887b - 886b) + (889b - 888b)
> +	.previous
>  	.endif
>  .endm
>  
> @@ -94,9 +94,9 @@
>  	new_c "\n"							\
>  	".option pop\n"							\
>  	"889 :\n"							\
> -	".previous\n"							\
>  	".org	. - (887b - 886b) + (889b - 888b)\n"			\
>  	".org	. - (889b - 888b) + (887b - 886b)\n"			\
> +	".previous\n"							\
>  	".endif\n"
>  
>  #define __ALTERNATIVE_CFG(old_c, new_c, vendor_id, errata_id, enable)	\
> 
> base-commit: 93c0651617a62a69717299f1464dda798af8bebb
> 




