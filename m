Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4464928E9;
	Tue, 10 May 2022 16:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564A4C385C9;
	Tue, 10 May 2022 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652199914;
	bh=4jM0r0zoZBcVnJqqYXnqXbhhEZvMsRPe7cKSulujADI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5sAgp6jJRWvsBnHixThGrIiKTFbylm7I7kf2GL5LZEGuZcq1haM8ELNFkYUjhWiS
	 vTA6QaHeKGigINN03bRQEv7LhOsH96bfKevDgkUMS6R+OmD1hlc7JxaWZvGJn1fOO6
	 dClvuFr5+NTR29ku5OPS86yzqy5apddZn3M0YBv5QTGNh5+mX+LKBH6Wmn7HasOZ20
	 WgzhwqX2p1mI61tnV0G7UbWBExKZ84nUD5wZ1LavCIipzjn2semBNB2KtkUq8GDVrW
	 Ht3deFqQCOSXq+ouLc5taRnLiozbd1hBGLU4YmAoSj3+aSkdSczJmSyJQJFL8SjOoB
	 +q21HgrGb45cQ==
Date: Tue, 10 May 2022 09:25:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] powerpc/vdso: Link with ld.lld when requested
Message-ID: <YnqR5/RSMIwqcUx9@dev-arch.thelio-3990X>
References: <20220509204635.2539549-1-nathan@kernel.org>
 <20220509204635.2539549-3-nathan@kernel.org>
 <ddd263c7-f27b-9543-55a3-d4efd899afac@ozlabs.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddd263c7-f27b-9543-55a3-d4efd899afac@ozlabs.ru>

On Tue, May 10, 2022 at 04:22:12PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 5/10/22 06:46, Nathan Chancellor wrote:
> > The PowerPC vDSO is linked with $(CC) instead of $(LD), which means the
> > default linker of the compiler is used instead of the linker requested
> > by the builder.
> > 
> >    $ make ARCH=powerpc LLVM=1 mrproper defconfig arch/powerpc/kernel/vdso/
> >    ...
> > 
> >    $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> > 
> >    File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> >    String dump of section '.comment':
> >    [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > 
> >    File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> >    String dump of section '.comment':
> >    [     0] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > 
> > The compiler option '-fuse-ld' tells the compiler which linker to use
> > when it is invoked as both the compiler and linker. Use '-fuse-ld=lld'
> > when LD=ld.lld has been specified (CONFIG_LD_IS_LLD) so that the vDSO is
> > linked with the same linker as the rest of the kernel.
> > 
> >    $ llvm-readelf -p .comment arch/powerpc/kernel/vdso/vdso{32,64}.so.dbg
> > 
> >    File: arch/powerpc/kernel/vdso/vdso32.so.dbg
> >    String dump of section '.comment':
> >    [     0] Linker: LLD 14.0.0
> >    [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > 
> >    File: arch/powerpc/kernel/vdso/vdso64.so.dbg
> >    String dump of section '.comment':
> >    [     0] Linker: LLD 14.0.0
> >    [    14] clang version 14.0.0 (Fedora 14.0.0-1.fc37)
> > 
> > LD can be a full path to ld.lld, which will not be handled properly by
> > '-fuse-ld=lld' if the full path to ld.lld is outside of the compiler's
> > search path. '-fuse-ld' can take a path to the linker but it is
> > deprecated in clang 12.0.0; '--ld-path' is preferred for this scenario.
> > 
> > Use '--ld-path' if it is supported, as it will handle a full path or
> > just 'ld.lld' properly. See the LLVM commit below for the full details
> > of '--ld-path'.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/774
> > Link: https://github.com/llvm/llvm-project/commit/1bc5c84710a8c73ef21295e63c19d10a8c71f2f5
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   arch/powerpc/kernel/vdso/Makefile | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
> > index 954974287ee7..096b0bf1335f 100644
> > --- a/arch/powerpc/kernel/vdso/Makefile
> > +++ b/arch/powerpc/kernel/vdso/Makefile
> > @@ -48,6 +48,7 @@ UBSAN_SANITIZE := n
> >   KASAN_SANITIZE := n
> >   ccflags-y := -shared -fno-common -fno-builtin -nostdlib -Wl,--hash-style=both
> > +ccflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
> 
> 
> Out of curiosity - how does this work exactly? I can see --ld-path= in the
> output so it works but there is no -fuse-ld=lld, is the second argument of
> cc-option only picked when the first one is not supported?

Correct. See Documentation/kbuild/makefiles.rst for more information
about those macros if you are curious.

> Anyway,
> 
> Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Thanks a lot!

Cheers,
Nathan
