Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0727D59B40;
	Fri,  1 Dec 2023 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yh2Wmz+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EFC433C7;
	Fri,  1 Dec 2023 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701467423;
	bh=hgErs2+9xOlVRFEfSS/n+GlJFVfTFeYoDoNHhlzozhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yh2Wmz+gpth1ZQrAI0doYusBzWe95tdpg796Ky8XrsvmWIYI7KXNGBgDUKdW4UFiX
	 1Mx585IDy/UpO7h6uc1gIVEZNXBXYUXm1m6QiEcKpNL0JeTcwOufXIhAZRgukKlFTQ
	 SJd98FwYZ2dLmZ5bX+p6C2QBhLFjIGU4+nlMZ63s3D0kC68pvXNKZyb0ytAcS61uU7
	 HFJ0nc+G871ltG+rL7chOiaC2nNi74gVGUffiXiGlT6iTfG75XswO0TmRPG560fP22
	 N2wo838PhF86ugFhzb2HME3z/6Y+N+STRQ+KtsgbPwOATC2vwoqLAcwn4lzVkOhrqz
	 V8zAcn0BI5JYw==
Date: Fri, 1 Dec 2023 14:50:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Fangrui Song <maskray@google.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	conor@kernel.org, ndesaulniers@google.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/2] riscv: Restrict DWARF5 when building with LLVM to
 known working versions
Message-ID: <20231201215021.GA2579712@dev-arch.thelio-3990X>
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
 <20231129-riscv-restrict-dwarf5-llvm-v1-2-ec0d368fb538@kernel.org>
 <CAFP8O3JscgacLPX-_pc2J0uhqk=ehtxSNStzo7PwewPSuXkxiw@mail.gmail.com>
 <20231201194858.GA290910@dev-arch.thelio-3990X>
 <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFP8O3+uta+GQO7dpeNLe0OMFnX-tdEyvHREEu1ThjA3nFtTkQ@mail.gmail.com>

On Fri, Dec 01, 2023 at 12:12:26PM -0800, Fangrui Song wrote:
> On Fri, Dec 1, 2023 at 11:49 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Thu, Nov 30, 2023 at 08:16:41AM -0800, Fangrui Song wrote:
> > > On Wed, Nov 29, 2023 at 3:30 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > > >
> > > > LLVM prior to 18.0.0 would generate incorrect debug info for DWARF5 due
> > > > to linker relaxation, which was worked around in clang by defaulting
> > > > RISC-V to DWARF4 [1]. Unfortunately, this workaround does not work for
> > > > the kernel because the DWARF version can be independently changed from
> > > > the default in Kconfig.
> > > >
> > > > Do not allow DWARF5 to be selected for RISC-V when using linker
> > > > relaxation (ld.lld >= 15.0.0) and a version of LLVM that does not have
> > > > the fixes (the integrated assembler [2] and ld.lld [3] < 18.0.0)
> > > > necessary to generate the correct debug info.
> > > >
> > > > Link: https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6 [1]
> > > > Link: https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a [2]
> > > > Link: https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77 [3]
> > > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > > ---
> > > >  arch/riscv/Kconfig | 9 +++++++++
> > > >  lib/Kconfig.debug  | 1 +
> > > >  2 files changed, 10 insertions(+)
> > > >
> > > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > > index 72be1d8122a3..81b473cb47b0 100644
> > > > --- a/arch/riscv/Kconfig
> > > > +++ b/arch/riscv/Kconfig
> > > > @@ -186,6 +186,15 @@ config RISCV_USE_LINKER_RELAXATION
> > > >         # https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
> > > >         depends on !LD_IS_LLD || LLD_VERSION >= 150000
> > > >
> > > > +# https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd18e5b0918f6
> > > > +config ARCH_HAS_BROKEN_DWARF5
> > > > +       def_bool y
> > > > +       depends on RISCV_USE_LINKER_RELAXATION
> > > > +       # https://github.com/llvm/llvm-project/commit/1df5ea29b43690b6622db2cad7b745607ca4de6a
> > > > +       depends on AS_IS_LLVM && AS_VERSION < 180000
> > > > +       # https://github.com/llvm/llvm-project/commit/7ffabb61a5569444b5ac9322e22e5471cc5e4a77
> > > > +       depends on LD_IS_LLD && LLD_VERSION < 180000
> > > > +
> > > >  config ARCH_MMAP_RND_BITS_MIN
> > > >         default 18 if 64BIT
> > > >         default 8
> > > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > > index cc7d53d9dc01..a0ebce05a368 100644
> > > > --- a/lib/Kconfig.debug
> > > > +++ b/lib/Kconfig.debug
> > > > @@ -282,6 +282,7 @@ config DEBUG_INFO_DWARF4
> > > >  config DEBUG_INFO_DWARF5
> > > >         bool "Generate DWARF Version 5 debuginfo"
> > > >         select DEBUG_INFO
> > > > +       depends on !ARCH_HAS_BROKEN_DWARF5
> > > >         depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > > >         help
> > > >           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
> > > >
> > > > --
> > > > 2.43.0
> > > >
> > >
> > > A comment and "depends on" condition introduced by commit
> > > 0a6de78cff600cb991f2a1b7ed376935871796a0 "lib/Kconfig.debug: Add check
> > > for non-constant .{s,u}leb128 support to DWARF5"
> > > can now be refined.
> > >
> > > > ib/Kconfig.debug
> > > > (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > >
> > > AS_VERSION can now be 24100.
> >
> > That will impact all architectures that use GNU as, even though the
> > issue was really only seen on RISC-V. It probably doesn't matter since
> > most architectures work with the integrated assembler and that is what
> > we tell people to use but I think the current check will continue to
> > work.
> 
> Agreed.
> 
>     depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION
> >= 23502 && AS_HAS_NON_CONST_LEB128)
> 
> is enabled for GCC. The long condition chain is for Clang. Given
> Clang's behavior, we can simplify this to
> 
>     depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU &&
> AS_HAS_NON_CONST_LEB128)

I think we still need the version check due to
https://sourceware.org/bugzilla/show_bug.cgi?id=25611, which was added
in commit 98cd6f521f10 ("Kconfig: allow explicit opt in to DWARF v5").

> This will still work even after R_LARCH_{ADD,SUB}_ULEB128 support is
> added to llvm-project.
> This condition matches HAVE_AS_LEB128 in GCC in spirit.
> 
> > Alternatively, I could do something like this but it is quite ugly and
> > verbose :/
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index a0ebce05a368..aea0ef5a5d1f 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -231,11 +231,6 @@ config DEBUG_INFO
> >           in the "Debug information" choice below, indicating that debug
> >           information will be generated for build targets.
> >
> > -# Clang is known to generate .{s,u}leb128 with symbol deltas with DWARF5, which
> > -# some targets may not support: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
> > -config AS_HAS_NON_CONST_LEB128
> > -       def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)
> > -
> 
> Consider keeping this config, but just reword the comment.

Do you have a suggestion for how it should be reworded? I am struggling
to come up with something that conveys additional information in a
succinct manner.

> >  choice
> >         prompt "Debug information"
> >         depends on DEBUG_KERNEL
> > @@ -258,7 +253,7 @@ config DEBUG_INFO_NONE
> >  config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
> >         bool "Rely on the toolchain's implicit default DWARF version"
> >         select DEBUG_INFO
> > -       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > +       depends on !CC_IS_CLANG || AS_IS_LLVM || CLANG_VERSION < 140000 || (AS_IS_GNU && ((!RISCV && AS_VERSION >= 23502) || (RISCV && AS_VERSION >= 24100)))
> 
> The RISCV condition would cause additional churn when LoongArch
> ULEB128 support is added.

Ah, I did not realize that LoongArch would have the same issue. This is
definitely not the right way to go for that then.

> >         help
> >           The implicit default version of DWARF debug info produced by a
> >           toolchain changes over time.
> > @@ -283,7 +278,7 @@ config DEBUG_INFO_DWARF5
> >         bool "Generate DWARF Version 5 debuginfo"
> >         select DEBUG_INFO
> >         depends on !ARCH_HAS_BROKEN_DWARF5
> > -       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
> > +       depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && ((!RISCV && AS_VERSION >= 23502) || (RISCV && AS_VERSION >= 24100)))
> >         help
> >           Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
> >           5.0+ accepts the -gdwarf-5 flag but only had partial support for some

Cheers,
Nathan
