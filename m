Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD23FFB;
	Wed, 30 Aug 2023 15:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90976C433C9;
	Wed, 30 Aug 2023 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693409809;
	bh=QjDdkcbpkYs5rXMPPX++/gHZ2/NTUOumpBgRZxH8cr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dX6Ck60wTNeElXbArCB7gm4NgWC4aQC5CwHxpcSuvecKp6AW7PlSOTxstnJGh9vos
	 zYTbdcY2gza+vmd88baqiXl4MCh5EzPFUnmD8VIf4bR5RKiWbmV+qccRc/kICGJzNM
	 AWdhLqd+eUaac3uax7ilwVSxxFF/yLzEe2JI5gA2B37aRtVI7uz4uugpzsExv1sYM9
	 yz/xQFoXpk+gg2xvJmb0nECIpQ6/9312+bAHLijVQAwCK82b/hgGSuCa2AOb2nHJCn
	 lE0MN6XyMUvEkW1EhQwIP3lrMp1tUMKja8zE9eVMmpUT6JjnLfAVigz1GrYz7tpa9H
	 zT2tk60RxN5bQ==
Date: Wed, 30 Aug 2023 08:36:46 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: keescook@chromium.org, akpm@linux-foundation.org,
	Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
	Conor Dooley <conor@kernel.org>, ndesaulniers@google.com,
	trix@redhat.com, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, patches@lists.linux.dev, lkp@intel.com
Subject: Re: [PATCH] lib/Kconfig.debug: Restrict DEBUG_INFO_SPLIT for RISC-V
Message-ID: <20230830153646.GA954264@dev-arch.thelio-3990X>
References: <20230816-riscv-debug_info_split-v1-1-d1019d6ccc11@kernel.org>
 <mhng-747958b0-514c-4fc8-ac37-0769562ba385@palmer-ri-x1c9>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-747958b0-514c-4fc8-ac37-0769562ba385@palmer-ri-x1c9>

On Wed, Aug 30, 2023 at 06:22:45AM -0700, Palmer Dabbelt wrote:
> On Wed, 16 Aug 2023 10:35:43 PDT (-0700), nathan@kernel.org wrote:
> > When building for ARCH=riscv using LLVM < 14, there is an error with
> > CONFIG_DEBUG_INFO_SPLIT=y:
> > 
> >   error: A dwo section may not contain relocations
> > 
> > This was worked around in LLVM 15 by disallowing '-gsplit-dwarf' with
> > '-mrelax' (the default), so CONFIG_DEBUG_INFO_SPLIT is not selectable
> > with newer versions of LLVM:
> > 
> >   $ clang --target=riscv64-linux-gnu -gsplit-dwarf -c -o /dev/null -x c /dev/null
> >   clang: error: -gsplit-dwarf is unsupported with RISC-V linker relaxation (-mrelax)
> > 
> > GCC silently had a similar issue that was resolved with GCC 12.x.
> > Restrict CONFIG_DEBUG_INFO_SPLIT for RISC-V when using LLVM or GCC <
> > 12.x to avoid these known issues.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1914
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/all/202308090204.9yZffBWo-lkp@intel.com/
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > Since this only impacts RISC-V, it seems reasonable that this would go
> > in via their tree but I have added Andrew in case he wants to take it.
> > ---
> >  lib/Kconfig.debug | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index d6798513a8c2..bd51274f4771 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -355,6 +355,11 @@ endchoice # "Compressed Debug information"
> >  config DEBUG_INFO_SPLIT
> >  	bool "Produce split debuginfo in .dwo files"
> >  	depends on $(cc-option,-gsplit-dwarf)
> > +	# RISC-V linker relaxation + -gsplit-dwarf has issues with LLVM and GCC
> > +	# prior to 12.x:
> > +	# https://github.com/llvm/llvm-project/issues/56642
> > +	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99090
> > +	depends on !RISCV || GCC_VERSION >= 120000
> >  	help
> >  	  Generate debug info into separate .dwo files. This significantly
> >  	  reduces the build directory size for builds with DEBUG_INFO,
> 
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> 
> Not sure who's taking stuff for lib/Kconfig.debug, I can take it via the
> RISC-V tree if folks are OK with it.  Kees and Andrew were the last to touch
> it.

I don't think lib/Kconfig.debug has a formal maintainer. Given that and
the fact that this change only affects RISC-V, I think it is entirely
reasonable for you to take it.

Cheers,
Nathan
