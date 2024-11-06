Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9511F9ABA;
	Wed,  6 Nov 2024 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730900351; cv=none; b=dnISs7Xlv0E6cW/xINZ5lU2SUdOSAIxjRTJ0LJQxt4JVUF6Pk1370RftC4/z6lbCVtQJOeb7khqYaY8ewsuzrlAcZ3AG60t8yPZSasA37b2aCf9410Gkf282QwG9Bg3ysQ127gV12sR1t0eiv24uscgN/MbyZQFJ+K8qUKENepg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730900351; c=relaxed/simple;
	bh=A4gbR+RkOu9mDrb8WX7Cq6hfSKoxr2wHINr+gQIjYCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Mime-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0/Iw67G9hDrK0QLVSVdwV/FBUuHgIvThC/TrmTH+Q9JOsLwS1Y0u496WsvOn+rg53tDwanYMwxKkVI75QcwU+3EoHMlTCVcwEDePVSrF40dDhSqVXJmKXioN83kGT07RQ3x2QCiyykYX73uXxxu95p96BmkG9XH/JyyQ5u7xvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 4A6DbrZA029304;
	Wed, 6 Nov 2024 07:37:53 -0600
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 4A6Dbqdj029302;
	Wed, 6 Nov 2024 07:37:52 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Wed, 6 Nov 2024 07:37:52 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
Message-ID: <20241106133752.GG29862@gate.crashing.org>
References: <20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org> <884cf694-09c7-4082-a6b1-6de987025bf8@csgroup.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <884cf694-09c7-4082-a6b1-6de987025bf8@csgroup.eu>
User-Agent: Mutt/1.4.2.3i

Hi!

On Wed, Nov 06, 2024 at 09:55:58AM +0100, Christophe Leroy wrote:
> Le 30/10/2024 à 19:41, Nathan Chancellor a écrit :
> >Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
> >end up in the 32-bit vDSO flags, resulting in build failures due to the
> >structure of clang's argument parsing of the stack protector options,
> >which validates the arguments of the stack protector guard flags
> >unconditionally in the frontend, choking on the 64-bit values when
> >targeting 32-bit:
> >
> >   clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', 
> >   expected one of: r2
> >   clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', 
> >   expected one of: r2
> >   make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: 
> >   arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
> >   make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: 
> >   arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1
> >
> >Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
> >already handles situations similar to this. Additionally, reformat and
> >align a comment better for the expanding CONFIG_CC_IS_CLANG block.
> 
> Is the problem really exclusively for 32-bit VDSO on 64-bit kernel ?
> In any case, it is just wrong to have anything related to stack 
> protection in VDSO, for this reason we have the following in Makefile:
> 
> ccflags-y += $(call cc-option, -fno-stack-protector)
> 
> If it is not enough, should we have more complete ?

The -mstack-protector-guard-reg= doesn't do anything if you aren't
doing stack protection.  It allows any base register (so, r1..r31).
Setting it to any valid reg should be fine and not do anything harmful,
unless perhaps you *do* enable stack protector, then it better be the
expected stuff ;-)

Apparently clang does not implement it correctly?  This is just a clang
bug, please report it with them?

(r2 is the default for -m32, r13 is the default for -m64, it appears
that clang does not implement this option at all, it simply checks if
you set the default, and explodes if not).


Segher
