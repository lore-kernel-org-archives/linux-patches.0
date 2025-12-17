Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E9930AAD8;
	Wed, 17 Dec 2025 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765953036; cv=none; b=iUoK2ma4Nfqvq/Bqj9fGhoq3fgHlFVvM5qWlceqvykjs5ZqWaMuRdg7sZqs6yaSpyVQenjIBQzNA7gPakOExSn0KHqGph7PJwyuViC7DvmrvKeI44aSQ2IzJKSueYguve7VfXDQ7p/m5xyj6XsLmTmBVrBMdPgOXtAE+y4V//V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765953036; c=relaxed/simple;
	bh=enmhooH99Y3PgVtp5N6Fp2tyZL6K7np1XXwGZiSj86Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfVheuD7/JKTECoQtsynfLOeVN8UtpM83CZgt79V9VgCXYVTYMGvbMmKdEmLzAfNDT4pB1AIpCKt0iosp8kiLR9WqjTCsVxTns1HCkdGBC/hwPkMKDKSQIyBK8v02T2lP/VL3gTKMGKAW+A18EJ/l78xf8CjSBi/snu40vmGmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQzR2oZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQzR2oZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A98C4CEF5;
	Wed, 17 Dec 2025 06:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765953035;
	bh=enmhooH99Y3PgVtp5N6Fp2tyZL6K7np1XXwGZiSj86Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BQzR2oZxhwjSj3UgsWKjaJaF+zR11F+m70hL6LiNs8WsdhuGSN+AyXcxLIeI6RuS6
	 uT76ivQxQpkT1ZhSK3juynoZ+5NK/3dNJxIIcWJU+oUBvYshF5nc3Mw8k3cjlHUjon
	 Mjc1OafnkFhVr6spCRdjGuppki+6xV1xpdHOBGPA=
Date: Wed, 17 Dec 2025 07:30:32 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, dan.carpenter@linaro.org,
	nathan@kernel.org, llvm@lists.linux.dev, perex@perex.cz,
	lgirdwood@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <2025121719-degrading-drainpipe-fb2e@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216195255.172999-1-naresh.kamboju@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216195255.172999-1-naresh.kamboju@linaro.org>

On Wed, Dec 17, 2025 at 01:22:55AM +0530, Naresh Kamboju wrote:
> I'm seeing the following allmodconfig and allyesconfig build
> failures on arm, arm64, riscv and x86_64.
> 
> ## Build error
> sound/soc/codecs/nau8325.c:430:13: error: variable 'n2_max' is uninitialized when used here [-Werror,-Wuninitialized]
>   430 |                 *n2_sel = n2_max;
>       |                           ^~~~~~
> sound/soc/codecs/nau8325.c:389:52: note: initialize the variable 'n2_max' to silence this warning
>   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
>       |                                                           ^
>       |                                                            = 0
> sound/soc/codecs/nau8325.c:431:11: error: variable 'ratio_sel' is uninitialized when used here [-Werror,-Wuninitialized]
>   431 |                 ratio = ratio_sel;
>       |                         ^~~~~~~~~
> sound/soc/codecs/nau8325.c:389:44: note: initialize the variable 'ratio_sel' to silence this warning
>   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
>       |                                                   ^
>       |                                                    = 0
> 2 errors generated.
> make[6]: *** [scripts/Makefile.build:287: sound/soc/codecs/nau8325.o] Error 1
> 
> First seen on 6.18.2-rc1
> Good: 6.18.1-rc1
> Bad:  6.18.2-rc1
> 
> And these build regressions also seen on 6.17.13-rc2.

Thanks, I'll go queue up the fix for this.

greg k-h
