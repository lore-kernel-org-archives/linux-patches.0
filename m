Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B12E2567;
	Mon,  9 May 2022 21:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2E3C385BF;
	Mon,  9 May 2022 21:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652132844;
	bh=KlcvigsRTNV5P70dU74lEqrxf7NBgU2ZPTJjuLcFb5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=psR6RAt80+lz2pgEplkAneSK3a5vs6LJ8VG6dv8KuYsV/sD5mgt+9Ez4w9J2vjzZd
	 ehY1pUDZdVBQCFU6lW2hqfc3p6IoR5ZB79gKcQ3Hlmx9XhfKOO5G5XG/cp7MeARHV2
	 EKACEpvjr7NJ4gmspeb6ZkkpVMQp+xfTWgdKWcut+9ReLvmnn8xXlJlWbXhEdDnUEL
	 suYhpfpFnjrW2BJsfI3iq74Wi/v0JUeyQyrmkhiL24aA9sXBtY3Rmxa//E5QiX7Zmt
	 xoB5TScbb3E5uNlpHx8oVl8cArWmGuIyVDMrA5at/oiHyZkund01PqlXVe9soNgHMM
	 n5MBqgdRqyiAg==
Date: Mon, 9 May 2022 14:47:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexey Kardashevskiy <aik@ozlabs.ru>, Tom Rix <trix@redhat.com>,
	linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH 2/2] powerpc/vdso: Link with ld.lld when requested
Message-ID: <YnmL6a8eObtstNjZ@dev-arch.thelio-3990X>
References: <20220509204635.2539549-1-nathan@kernel.org>
 <20220509204635.2539549-3-nathan@kernel.org>
 <CAKwvOdkvF8AJudCcu=CVmU42eyVMJwUjQFnX+rpVF45bTR86Mg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkvF8AJudCcu=CVmU42eyVMJwUjQFnX+rpVF45bTR86Mg@mail.gmail.com>

On Mon, May 09, 2022 at 02:24:40PM -0700, Nick Desaulniers wrote:
> On Mon, May 9, 2022 at 1:47 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > The PowerPC vDSO is linked with $(CC) instead of $(LD), which means the
> > default linker of the compiler is used instead of the linker requested
> > by the builder.
> >
> >   $ make ARCH=powerpc LLVM=1 mrproper defconfig arch/powerpc/kernel/vdso/
> >   ...
> >
> >   $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> >
> >   File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> >   String dump of section '.comment':
> >   [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> >
> >   File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> >   String dump of section '.comment':
> >   [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> >
> > The compiler option '-fuse-ld' tells the compiler which linker to use
> > when it is invoked as both the compiler and linker. Use '-fuse-ld=lld'
> > when LD=ld.lld has been specified (CONFIG_LD_IS_LLD) so that the vDSO is
> > linked with the same linker as the rest of the kernel.
> >
> >   $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> >
> >   File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> >   String dump of section '.comment':
> >   [     0] Linker: LLD 14.0.0
> >   [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> >
> >   File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> >   String dump of section '.comment':
> >   [     0] Linker: LLD 14.0.0
> >   [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> >
> > LD can be a full path to ld.lld, which will not be handled properly by
> > '-fuse-ld=lld' if the full path to ld.lld is outside of the compiler's
> > search path. '-fuse-ld' can take a path to the linker but it is
> > deprecated in clang 12.0.0; '--ld-path' is preferred for this scenario.
> >
> > Use '--ld-path' if it is supported, as it will handle a full path or
> > just 'ld.lld' properly. See the LLVM commit below for the full details
> > of '--ld-path'.
> 
> Perhaps worth adding some additional background from the cover letter
> to the commit message that will actually go into the kernel,
> particularly:
> 1. Kbuild mostly invokes the compiler and linker distinctly; the ppc
> vdso code uses the compiler as the linker driver though.
> 2. When doing so, depending on how the compiler was configured, the
> implicit default linker the compiler invokes might not match $LD.

Sure, I think I can clear up these two points with something like:

"The PowerPC vDSO uses $(CC) to link, which differs from the rest of the
kernel, which uses $(LD) directly. As a result, the default linker of
the compiler is used, which may differ from the linker requested by the
builder. For example:

<example above>

LLVM=1 sets LD=ld.lld but ld.lld is not used to link the vDSO; GNU ld is
because "ld" is the default linker for clang on most Linux platforms."

Thoughts?

> 3. This is a problem for LTO since clang may try to invoke ld.gold,
> which is not supported as of
> commit 75959d44f9dc ("kbuild: Fail if gold linker is detected")

Technically, it seemed like ld.bfd was being invoked but the LLVMgold
plugin did not exist. Regardless, moving to ld.lld will resolve that,
since the LLVMgold plugin won't be needed.

> 4. Using the linker as the driver can cause ld.bfd 2.26 to crash.
> https://lore.kernel.org/all/b2066ccd-2b81-6032-08e3-41105b400f75@csgroup.eu/
> (Though, I wonder if that's because I was trying to add
> --orphan-handling=warn, which we're not yet doing for the ppc vdso
> AFAICT).

I can add this if necessary but it seemed like there might have been
other problems reported? I could just add a blanket "linker driver had
issues, we'll try again later" or something of that effect?

> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thank you for the review as always!

> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/774
> > Link: https://github.com/llvm/llvm-project/commit/1bc5c84710a8c73ef21295e63c19d10a8c71f2f5
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  arch/powerpc/kernel/vdso/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
> > index 954974287ee7..096b0bf1335f 100644
> > --- a/arch/powerpc/kernel/vdso/Makefile
> > +++ b/arch/powerpc/kernel/vdso/Makefile
> > @@ -48,6 +48,7 @@ UBSAN_SANITIZE := n
> >  KASAN_SANITIZE := n
> >
> >  ccflags-y := -shared -fno-common -fno-builtin -nostdlib -Wl,--hash-style=both
> > +ccflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
> >
> >  CC32FLAGS := -Wl,-soname=linux-vdso32.so.1 -m32
> >  AS32FLAGS := -D__VDSO32__ -s
> > --
> > 2.36.1
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
