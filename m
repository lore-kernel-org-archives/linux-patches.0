Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9CE5DF1F;
	Tue, 12 Dec 2023 11:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEkZ70v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08B9C433C7;
	Tue, 12 Dec 2023 11:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702382123;
	bh=ELkMM3xL8H6CR/+VuM2URI6u+FZWIT3tz2dGjfDVmtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yEkZ70v4HQPvJ4mjAZ2LGFeiDgGbm/hcMWhps260aLGNJzoQJmGybkqfTvclnskK2
	 w8yV9r7Ng4eJ4odjOqFyv1lOIcDeWcB/V8X0TfTh43OT/BFPEM+p5kUgdRB/aYP0Sw
	 HW/atx8BAYSue1yklfCTmGE6eRGENF2vB3itO1No=
Date: Tue, 12 Dec 2023 12:55:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, arnd@arndb.de
Subject: Re: [PATCH 5.15 000/141] 5.15.143-rc1 review
Message-ID: <2023121254-reoccur-shorty-cfb2@gregkh>
References: <20231211182026.503492284@linuxfoundation.org>
 <a2fbbaa2-51d2-4a8c-b032-5331e72cd116@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2fbbaa2-51d2-4a8c-b032-5331e72cd116@linaro.org>

On Mon, Dec 11, 2023 at 09:38:39PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 11/12/23 12:20 p. m., Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.143 release.
> > There are 141 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.143-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We're seeing new warnings with GCC-8 and failures with GCC-12 on x86/i386:
> 
> -----8<-----
>   In file included from /builds/linux/drivers/gpu/drm/i915/gem/i915_gem_context.c:2291:
>   /builds/linux/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c: In function '__igt_ctx_sseu':
>   /builds/linux/drivers/gpu/drm/i915/gem/selftests/i915_gem_context.c:1284:9: error: left shift of negative value [-Werror=shift-negative-value]
>       ~(~0 << (hweight32(engine->sseu.subslice_mask) / 2));
>            ^~
>   cc1: all warnings being treated as errors
>   make[5]: *** [/builds/linux/scripts/Makefile.build:289: drivers/gpu/drm/i915/gem/i915_gem_context.o] Error 1
>   /builds/linux/drivers/gpu/drm/i915/i915_perf.c: In function 'get_default_sseu_config':
>   /builds/linux/drivers/gpu/drm/i915/i915_perf.c:2817:9: error: left shift of negative value [-Werror=shift-negative-value]
>       ~(~0 << (hweight8(out_sseu->subslice_mask) / 2));
>            ^~
>   cc1: all warnings being treated as errors
>   make[5]: *** [/builds/linux/scripts/Makefile.build:289: drivers/gpu/drm/i915/i915_perf.o] Error 1
> ----->8-----
> 
> Bisection points to:
> 
>   commit 09ebdc1b3dfacc275d5eec3f1dcf632f18bbf5a8
>   Author: Arnd Bergmann <arnd@arndb.de>
>   Date:   Tue Mar 8 22:56:14 2022 +0100
> 
>       Kbuild: move to -std=gnu11
>       [ Upstream commit e8c07082a810fbb9db303a2b66b66b8d7e588b53 ]
> 
> 
> For GCC-12 it's allmodconfig failing, for GCC-8 it's defconfig (i386_defconfig, x86_64_defconfig) just reporting new warnings.
> 
> Some reproducers:
> 
>   tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-8 --kconfig x86_64_defconfig
> 
>   tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-12 --kconfig allmodconfig
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Ok, let me go drop this change and fix up the original commit that
required this language change to happen as we aren't quite ready for it
yet...

thanks,

greg k-h
