Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46A3D7D8B;
	Thu,  2 Apr 2026 11:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775130740; cv=none; b=ZvUoaWoUI7+0C8q/1eFMdWqpg9QNfBVmlxoo9swpF6ilBjGh3H0+KnAk4htcHNqwsPq12oPS2qUR414uIRul3vNIlDkF8pmRC5qpzhpB//SOefRnA0iWUKCbmVHijflDPCbjOLIHrR5f0LVWZnBhreisRYalOjTlHrrT2Y9dmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775130740; c=relaxed/simple;
	bh=xaeIkr+z0mwe6OeTa2PSsK416pM7frPW8JcDkPdoa4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4HioK2X4Ojq2MF8QF5QN0LoX/2RuzMPwOuH4JtDY9neyUx6zOefF9sUQ6LUkblwnhZPs1JbSuxSXjmLxb3toUM7gzCCNJRAWQDnPipMZbK7RHXnX/GSqW8/XL6/ZCqydaFB5iWy38Y30RZtqF52HQ8ECklIiR5rRueX/s7dM0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+GuDHqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+GuDHqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE0FC116C6;
	Thu,  2 Apr 2026 11:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775130738;
	bh=xaeIkr+z0mwe6OeTa2PSsK416pM7frPW8JcDkPdoa4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j+GuDHqrpsWL7ds76kWdY6uikQW5y4cHRJfbKmPQ+X0glGm0N2ijiIpaaR0pfaC75
	 9XEaEwweqoMatx0djfYkfIs+xyk+ORANt872yM2V2f5tuCnrpQdtq2opwTJoiJQfko
	 TAdP9+oEIV+sqBV4vNH9avi64mRHLOazQ1H4IB4Y=
Date: Thu, 2 Apr 2026 13:52:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, Benno Lossin <lossin@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
Message-ID: <2026040247-stimuli-surreal-edf1@gregkh>
References: <20260331161729.779738837@linuxfoundation.org>
 <20260402112712.110869-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402112712.110869-1-ojeda@kernel.org>

On Thu, Apr 02, 2026 at 01:27:12PM +0200, Miguel Ojeda wrote:
> On Tue, 31 Mar 2026 18:19:44 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.131 release.
> > There are 175 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> > Anything received after that time might be too late.
> 
> The pin-init change does not build:
> 
>     error[E0425]: cannot find value `__refcount_guard` in this scope
>         --> rust/kernel/init/macros.rs:1320:25
>          |
>     1320 |                   @guards([< __ $field _guard >], $($guards,)*),
>          |                           ^^^^^^^^^^^^^^^^^^^^^^ not found in this scope
>          |
>         ::: rust/kernel/sync/arc.rs:529:49
>          |
>     529  |           let inner = Box::try_init::<AllocError>(try_init!(ArcInner {
>          |  _________________________________________________-
>     530  | |             // SAFETY: There are no safety requirements for this FFI call.
>     531  | |             refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
>     532  | |             data <- init::uninit::<T, AllocError>(),
>     533  | |         }? AllocError))?;
>          | |______________________- in this macro invocation
>          |
>          = note: this error originates in the macro `$crate::__init_internal` which comes from the expansion of the macro `try_init` (in Nightly builds, run with -Z macro-backtrace for more info)
> 
> (among other errors)
> 
> I would suggest dropping these for now:
> 
>     0565326613fa ("rust: pin-init: internal: init: document load-bearing fact of field accessors")
>     66655aacfa42 ("rust: pin-init: add references to previously initialized fields")
> 
> Cc: Benno Lossin <lossin@kernel.org>
> Cc: Gary Guo <gary@garyguo.net>

Crap, I just did a realease.  Let me go revert these and do a new
release with that fixed, sorry about that, I guess my builds weren't
testing rust on older kernels, my fault :(

greg k-h
