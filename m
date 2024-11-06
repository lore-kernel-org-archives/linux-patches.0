Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6CD1E0480;
	Wed,  6 Nov 2024 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906477; cv=none; b=U9UgnFsePw5nMvYhdfPQzoANKAwhf9chhE9s7T5oyQd8dhjx8InTbUY/E5DHk4TU8KkZSIz/gEtJVTqqJwMK+QLpTg3+dvMIcmilAX7tmmm2tw5jxYgv25vIcFPI1vzzeX2HrEyWHugVvj5gxOTBUSRArY40N2aaQukRnAW4PJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906477; c=relaxed/simple;
	bh=iJSFfu/7mDUN+APdZbNmZkyP0R97PoistfqOwZ9X8hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jczxUPV5Vmfc9eqFcgTX4Ay8sFmSgfjJ1MT84wAhxVxqrM1oX6fMU+MCDp/4dgl6rh0dTq8yHo8nLMYXqpJ6mdl8uaqsg2yAAT8jT2Qw27I95zsVsv3cH08b0sbLkM/pvtYhojRNCDIK3Dr/aYihV1/8JpbhRHXKCxCMmMgpb2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBSgmgGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBSgmgGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33989C4CEC6;
	Wed,  6 Nov 2024 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730906476;
	bh=iJSFfu/7mDUN+APdZbNmZkyP0R97PoistfqOwZ9X8hM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tBSgmgGhYQarahcJvidaF3o/1pYi+Kgfn0Zv/soCRYug5MYHEenUi6bVchu0qLzTc
	 uX7EJ7SWXY34Olg4+mT9C1PjBOpHwPOWZOS0CHxtKQCsK9dpbXJ5LpeYNYwUEYiTHT
	 9m2gHC5kXmbpjZn2VVp9MED+lzhDCjVV3DACDfwVjb98N+s/uhXcIAFqTZiJFgcQga
	 huRhD1YemOxB1PMmKtjCU+9AOak0gnl8sc7+2ZDZ6CjVbMKZtewBB/Xqulhorp3D6T
	 f5P4hAZQQyICro5VeJnLtWFRT9uesccfxFEZuS4+FNs++th3E7DNlQ9BSX4xFSF7em
	 Rc3MiqibMaT7A==
Date: Wed, 6 Nov 2024 08:21:14 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Segher Boessenkool <segher@kernel.crashing.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in
 32-bit files with clang
Message-ID: <20241106152114.GA2738371@thelio-3990X>
References: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org>
 <884cf694-09c7-4082-a6b1-6de987025bf8@csgroup.eu>
 <20241106133752.GG29862@gate.crashing.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241106133752.GG29862@gate.crashing.org>

Hi Christophe and Segher,

On Wed, Nov 06, 2024 at 07:37:52AM -0600, Segher Boessenkool wrote:
> On Wed, Nov 06, 2024 at 09:55:58AM +0100, Christophe Leroy wrote:
> > Le 30/10/2024 à 19:41, Nathan Chancellor a écrit :
> > >Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
> > >end up in the 32-bit vDSO flags, resulting in build failures due to the
> > >structure of clang's argument parsing of the stack protector options,
> > >which validates the arguments of the stack protector guard flags
> > >unconditionally in the frontend, choking on the 64-bit values when
> > >targeting 32-bit:
> > >
> > >   clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', 
> > >   expected one of: r2
> > >   clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', 
> > >   expected one of: r2
> > >   make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: 
> > >   arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
> > >   make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: 
> > >   arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1
> > >
> > >Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
> > >already handles situations similar to this. Additionally, reformat and
> > >align a comment better for the expanding CONFIG_CC_IS_CLANG block.
> > 
> > Is the problem really exclusively for 32-bit VDSO on 64-bit kernel ?

As far as I can tell, yes, as I do not think there are any other places
where flags for targeting one word size were being used when targeting
the other word size.

> > In any case, it is just wrong to have anything related to stack 
> > protection in VDSO, for this reason we have the following in Makefile:
> > 
> > ccflags-y += $(call cc-option, -fno-stack-protector)
> > 
> > If it is not enough, should we have more complete ?

That should be enough to disable the stack protector from my
understanding. It is just that clang's argument validation happens even
with -fno-stack-protector, so the flags need to contain valid values for
the target. This is true for GCC as well, it just supports any base
register like Segher mentions below so it does not hit any issue here:

  $ powerpc64-linux-gcc -fno-stack-protector -mstack-protector-guard=tls -mstack-protector-guard-reg=r50 -c -o /dev/null -x c /dev/null
  cc1: error: 'r50' is not a valid base register in '-mstack-protector-guard-reg='
  cc1: error: '-mstack-protector-guard=tls' needs a valid base register

> The -mstack-protector-guard-reg= doesn't do anything if you aren't
> doing stack protection.  It allows any base register (so, r1..r31).
> Setting it to any valid reg should be fine and not do anything harmful,
> unless perhaps you *do* enable stack protector, then it better be the
> expected stuff ;-)
> 
> Apparently clang does not implement it correctly?  This is just a clang
> bug, please report it with them?
> 
> (r2 is the default for -m32, r13 is the default for -m64, it appears
> that clang does not implement this option at all, it simply checks if
> you set the default, and explodes if not).

Not sure that I would say it has not been implemented correctly, more
that it has not been implemented in the same manner as GCC. Keith chose
not to open up support for arbitrary registers to keep the
implementation of this option in LLVM simple:

https://lore.kernel.org/linuxppc-dev/87o73uvaq5.fsf@keithp.com/

Cheers,
Nathan
