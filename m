Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5B28C05;
	Mon,  1 May 2023 21:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E3C433EF;
	Mon,  1 May 2023 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682977036;
	bh=TbwlViufFEIhz3VjcV/zsYukgrEOYlIWPd8kMF7ZOAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UFNAAZ9nrBeaF3tgZeYaqqEQpYgwoyjHjmvnIMcFG0grdmMeprfiFu0p6c2L0g7vX
	 hyqiLsPFowrvFMUdnvb75U0RKCgh1mc+zdCTPIFyz8L1H7bMJFOCUG/Rdkuqq5CcZu
	 mpbz5vYQlOD1iVAkc3J4uHXAKbE8o3s7zOdNy83eOX/bAFPR8TrjqgcuCeJkwxpQIc
	 RiPu4PaLycuFYNkduFMc0ZWhqG03fgxrUdsV2Xu6X4NcxaS+F3DFs/PBlx2AUuLWaL
	 nHQJ9AUgQ9vHv1VEKC0gFMa0/TzLRESDZOWn3xnWwD8m30+P/GXm7zKdRKxPFlDWrs
	 wgxATUjy2UYxw==
Date: Mon, 1 May 2023 14:37:14 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: qinjian@cqplus1.com, mturquette@baylibre.com, sboyd@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] clk: sp7021: Adjust width of _m in HWM_FIELD_PREP()
Message-ID: <20230501213714.GA1007102@dev-arch.thelio-3990X>
References: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org>

On Mon, May 01, 2023 at 02:34:47PM -0700, Nathan Chancellor wrote:
> When building with clang + W=1, there is a warning around an internal
> comparison check within the FIELD_PREP() macro, due to a 32-bit variable
> comparison against ~0ull:
> 
>   drivers/clk/clk-sp7021.c:316:8: error: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((_m), ...' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>           r0 |= HWM_FIELD_PREP(MASK_SEL_FRA, clk->p[SEL_FRA]);
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/clk/clk-sp7021.c:45:15: note: expanded from macro 'HWM_FIELD_PREP'
>           (_m << 16) | FIELD_PREP(_m, value);     \
>                        ^~~~~~~~~~~~~~~~~~~~~
>   include/linux/bitfield.h:114:3: note: expanded from macro 'FIELD_PREP'
>                   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
>                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/bitfield.h:71:53: note: expanded from macro '__BF_FIELD_CHECK'
>                   BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >     \
>                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
>   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
>   include/linux/compiler_types.h:397:22: note: expanded from macro 'compiletime_assert'
>           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/compiler_types.h:385:23: note: expanded from macro '_compiletime_assert'
>           __compiletime_assert(condition, msg, prefix, suffix)
>           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   include/linux/compiler_types.h:377:9: note: expanded from macro '__compiletime_assert'
>                   if (!(condition))                                       \
>                         ^~~~~~~~~
> 
> This is expected given the tyoes of the input. Increase the size of the
> temporary variable in HWM_FIELD_PREP() to eliminate the warning, which
> follows the logic of commit cfd6fb45cfaf ("crypto: ccree - avoid
> out-of-range warnings from clang") for the same reasons.

Gah, I forgot:

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/202303221947.pXP2v4xJ-lkp@intel.com/

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/clk/clk-sp7021.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-sp7021.c b/drivers/clk/clk-sp7021.c
> index 8fec14120105..11d22043ddd7 100644
> --- a/drivers/clk/clk-sp7021.c
> +++ b/drivers/clk/clk-sp7021.c
> @@ -41,7 +41,7 @@ enum {
>  /* HIWORD_MASK FIELD_PREP */
>  #define HWM_FIELD_PREP(mask, value)		\
>  ({						\
> -	u32 _m = mask;				\
> +	u64 _m = mask;				\
>  	(_m << 16) | FIELD_PREP(_m, value);	\
>  })
>  
> 
> ---
> base-commit: d54c1fd4a51e8fbc7f9da86b0cd338a4f7cd2bb2
> change-id: 20230501-sp7021-field_prep-warning-223f17aeea8e
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
