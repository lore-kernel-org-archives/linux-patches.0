Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25ACDDC3;
	Mon, 21 Oct 2024 09:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503913; cv=none; b=tLaI9orikb1cY2WXcHp/dPHptk27qF51p2GOXiGIEVNbFp3hIN36fnN4PB7f4JVACrbRoeh6KY8/HG12M+VWtre8rP6oP1K1FWvKmczWVwVxUOSxNN8oUEBfktrdUzzs6W+Zlcn3opPx33KPNHXaGFCcW69zg/O64TPgHHXR5Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503913; c=relaxed/simple;
	bh=Ep7s8Iir+aUXjgcsL5rbrQeIFsWtZOkKEyPeOzyaxJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao5/hF420xdXp+LHmq8YRxGYC7a3IMp7KoKs7VtRKo5M9pdSijadvqk0cb75J7KhNXVjVmTa0sIAkwcdMDqPR9wHTfxfF7nK8EB881pi0JzFR116hY6ZGGOls1cpGA4egeXFCpX4MKGr3uZg+J/a306wIMBk9egREDLemqJ80ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn/H+gUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn/H+gUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B9CC4CEC3;
	Mon, 21 Oct 2024 09:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729503913;
	bh=Ep7s8Iir+aUXjgcsL5rbrQeIFsWtZOkKEyPeOzyaxJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rn/H+gUzViYvlRUWUmxrfOnEEPA4+mbaxQPi058+OxzGQ01sTW0+3RolZjmBwmQm6
	 ko6MRU0clb2bpyfQBPqOZFzJo/rn9slJlUrAHUrPo4C5zrgeW7vsvPTyeQsAiZL5Wn
	 gdxowahc6CXp9u6RYairi7vQKDjYbM8e4iOvHAYk=
Date: Mon, 21 Oct 2024 11:45:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
Message-ID: <2024102100-robust-shaking-8655@gregkh>
References: <20241015112501.498328041@linuxfoundation.org>
 <f035e6ef-32e1-45a2-962e-dc27fa54271b@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f035e6ef-32e1-45a2-962e-dc27fa54271b@roeck-us.net>

On Sat, Oct 19, 2024 at 08:17:31AM -0700, Guenter Roeck wrote:
> On 10/15/24 04:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.113 release.
> > There are 791 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> > Anything received after that time might be too late.
> > 
> ...
> 
> > Nicholas Piggin <npiggin@gmail.com>
> >      powerpc/64: Option to build big-endian with ELFv2 ABI
> > 
> 
> With this patch in the tree, trying to build ppc:allmodconfig
> with gcc version 13.3 and binutils version 2.42 results in:
> 
> Error log:
> /tmp/cccUl45i.s: Assembler messages:
> /tmp/cccUl45i.s: Error: .size expression for gcm_init_p8 does not evaluate to a constant
> 
> and many other similar messages. The problem affects various drivers in
> drivers/crypto/vmx/. The problem afects all configurations with CRYPTO_DEV_VMX_ENCRYPT
> enabled.
> 
> Reverting the patch doesn't work because this patch is part of a larger series. However,
> I found that applying upstream commit 505ea33089dc ("powerpc/64: Add big-endian ELFv2
> flavour to crypto VMX asm generation") fixes the problem.

Now queued up, thanks.

greg k-h
