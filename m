Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ECEEAC7;
	Fri, 12 Jul 2024 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720791160; cv=none; b=rLm1cbFf6GrBJi414sKt0gJ161/HSH6uhMgMz+ARC9ZSX/W+SGM15peahtUgoItmnz4FLRrvzJIJjOWzl0ZhOH+2dEbftTfss3QkOlXyb/YNs0iJAU8ENLWAp9XpBQ7C2fv1eb6+4g7m45bR7E9dwjH6XrBsYEfWtoZ8uSt0baE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720791160; c=relaxed/simple;
	bh=IKBrzGC73MnXcUEDdfFMiJvHDd3uSvUh+ioavB0SEP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJnAvHbPK0SVTM+OUY1p/JhzgedwKmShfn+xv7HJb8yJz87cd0lflMDpqvo3aw7iaphbnujLRH/AY9dOdND6LR0Gh3gTeXxG/1R9LhvIr5XQ244C8ErGUDyl5Te4AeMcirC1++4ffJgwfeMKbAILP8AgcoKNtMNw3x1orDkYYSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ttl//4lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ttl//4lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB1CC32782;
	Fri, 12 Jul 2024 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720791160;
	bh=IKBrzGC73MnXcUEDdfFMiJvHDd3uSvUh+ioavB0SEP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ttl//4lgujTwp0lvVga4ytCW7tFrduw+bW1vdP3BsNLSCcTP6qvKLWO/ZMeRITwCk
	 X/pgPU0R/jG42oqMv3OXzGxKzxM5V++2GaMnJJdvl29XyVIHvmOPuEA5r0kZHLWKWM
	 pr94S4M1RtK6BmmRWs6ax/t5SKD1BZZxXNOYk1Y8=
Date: Fri, 12 Jul 2024 15:32:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, allen.lkml@gmail.com,
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	=?utf-8?B?VG9tw6HFoQ==?= Glozar <tglozar@gmail.com>
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
Message-ID: <2024071237-hypnotize-lethargic-98f2@gregkh>
References: <20240704094505.095988824@linuxfoundation.org>
 <76458f11-0ca4-4d3b-a9bc-916399f76b54@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76458f11-0ca4-4d3b-a9bc-916399f76b54@web.de>

On Thu, Jul 11, 2024 at 12:56:44PM +0200, Frank Scheiner wrote:
> Dear Greg, dear Sasha,
> 
> I noticed a build failure for linux-5.10.y for ia64 ([1]) (sorry,
> actually since 5.10.221-rc1, but I didn't notice that build failure
> before yesterday :-/ and as the review window for 5.10.222-rc1 is not
> yet open, I thought I send it now as response to the last review window
> announcement for 5.10.221-rc2):
> 
> https://github.com/linux-ia64/linux-stable-rc/actions/runs/9771252437/job/26974019958#step:8:3524:
> ```
> [...]
> CC [M]  drivers/pps/pps.o
> drivers/firmware/efi/memmap.c:16:10: fatal error: asm/efi.h: No such
> file or directory
>    16 | #include <asm/efi.h>
>       |          ^~~~~~~~~~~
> compilation terminated.
> [...]
> ```
> 
> [1]:
> https://github.com/linux-ia64/linux-stable-rc/actions/runs/9771252437#summary-26974019958
> 
> This is related to the recent addition of this change set:
> 
> efi: memmap: Move manipulation routines into x86 arch tree
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.10.y&id=31e0721aeabde29371f624f56ce2f403508527a5
> 
> ...to linux-5.10.y. For ia64 this change set on its own seems incomplete
> as it requires a header not available for ia64 w/o additional changes.
> 
> Adding:
> 
> efi: ia64: move IA64-only declarations to new asm/efi.h header
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8ff059b8531f3b98e14f0461859fc7cdd95823e4
> 
> ...or from here (according to GitHub this is in linux-stable(-rc)
> starting with linux-5.12.y):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=8ff059b8531f3b98e14f0461859fc7cdd95823e4
> 
> fixes it for me with 5.10.222-rc1, see for example [2].
> 
> [2]:
> https://github.com/linux-ia64/linux-stable-rc/actions/runs/9871144965#summary-27258970494

I'm confused, which commit should we add, or should we just revert what
we have now?

And I thought that ia64 was dead?

thanks,

greg k-h
