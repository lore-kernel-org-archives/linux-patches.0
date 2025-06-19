Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA7278F4C;
	Thu, 19 Jun 2025 04:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750306632; cv=none; b=YOHA6qs6kSB3G2xR7pjHfu/SK5rSipdIWUgg7XH6u5Qn8cMbYPXivo90CeAOOc2u61yUDbvWOS2+kVDT0c60rH1k2JEkY+SiQ8sE0qeKmGGSZAXuEF7zMKRIXzDoqM2tfQZnxKroD+qOCY6tbU6HLg9/Q/Bup9lTccFJsSn/COw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750306632; c=relaxed/simple;
	bh=VPKaoyzxrux1zV8zzzKWYGkZSbtqoWK89RAQveuq4KI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYaE+asYYSx+OBOJFp/RiLtO+t0WhocAQQm4KYRCOiXyzJi80sSelVJ8XNVDj4boyBbM8H+u9clb12ynZoQ20czIhUyLh+PXEr7CtDHWOgO9URipPOxFbpEnfELPcTmWwzUlAVYl61Xaa7z2dnafM/fnfE0OY/wjvhCirWUK47w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF47xPRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF47xPRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D5BC4CEEA;
	Thu, 19 Jun 2025 04:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750306631;
	bh=VPKaoyzxrux1zV8zzzKWYGkZSbtqoWK89RAQveuq4KI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pF47xPRxxODA2Y/wjrk7wxkNL2X0ngP5cstysOVwDzOpWUyBIU5iWqZ3jfzmEaic/
	 9eDN4ltJqFS7TC0mJXngclD+H3ZNH07nEuAhYroXkx/0YOr0RBLBTQc0Z2gg70nvl0
	 9lzOt8lyT++g8WopAYEE4co5e6h6wtt3G6Cism3c=
Date: Thu, 19 Jun 2025 06:17:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pascal Ernster <git@hardfalcon.net>
Cc: Ronald Warsow <rwarsow@gmx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com,
	broonie@kernel.org, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061930-jumbo-bobsled-521a@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <f2b87714-0ef6-4210-9b30-86b4c79d1ed8@gmx.de>
 <2025061848-clinic-revered-e216@gregkh>
 <c8e4e868-aafb-4df1-8d07-62126bfe2982@hardfalcon.net>
 <097ef8cc-5304-4a7d-abc0-fd011d1235d5@hardfalcon.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <097ef8cc-5304-4a7d-abc0-fd011d1235d5@hardfalcon.net>

On Wed, Jun 18, 2025 at 10:31:43PM +0200, Pascal Ernster wrote:
> Hello again,
> 
> 
> I've sent this email a few minutes ago but mixed up one of the In-Reply-To
> message IDs, so I'm resending it now with (hopefully) the correct
> In-Reply-To message IDs.
> 
> 
> I've bisected this and found that the issue is caused by commit
> f46262bbc05af38565c560fd960b86a0e195fd4b:
> 
> 'Revert "mm/execmem: Unify early execmem_cache behaviour"'
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f46262bbc05af38565c560fd960b86a0e195fd4b
> 
> https://lore.kernel.org/stable/20250617152521.879529420@linuxfoundation.org/
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.15/revert-mm-execmem-unify-early-execmem_cache-behaviour.patch?id=344d39fc8d8b7515b45a3bf568c115da12517b22

Thank you for digging into this.  Looks like I took the last patch in a
patch series and not the previous ones, which caused this problem.  I've
dropped this one now and will add it back next week after I also add all
the other ones in the series.

thanks,

greg k-h
