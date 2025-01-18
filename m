Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481043398B;
	Sat, 18 Jan 2025 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737214502; cv=none; b=spWBOyj5HbckUcdn1jbUZ3NTqo7vjh4MG/HlxfJJmhkjxEegHF7mPKBKBNLIFDtdYNuP/RQn/QUNt43An+kn3oFzDX5hHwAOj8nEgpBxeFC9VGTO+0iywhDuddSu4WDmyWXLHEpO/1OChes9I+Rzvt3s5G8Cdlh67qiQpsJ2dic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737214502; c=relaxed/simple;
	bh=XW4OcCwNWg88RcHD2uw1zfbeFHtca7sRb2qMJ6rgDLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUWEwRMZqvarGsGhciuqB/jPpGuSgd4LMBhIbW4OHwuxXq+jdWlFFv+yNxMSl7zy//IIFUCaZ2Wp5zrQxh9YRCK9Y1t34mf7qDLd6ThXSZu3tQ8cBvnu0pFtB7Gyw6hOwLQFVyqOV6/h8hB4DfGgenvUoQ7Xl0PBwkV9NemAorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViC6XXWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViC6XXWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22844C4CED1;
	Sat, 18 Jan 2025 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737214501;
	bh=XW4OcCwNWg88RcHD2uw1zfbeFHtca7sRb2qMJ6rgDLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ViC6XXWcMEbfPtCEGR6lcQ/ctVEVXUOkVRRGleduYeoMh0sZGyaUdVJUhfevW3j/g
	 8vfeEfiUhK2hAEv4a8rz6nRXQmHhYFXtlmWwPoXYNbLpdeMkk97T9Ob0J9tizP1+yJ
	 Z02uC9bsMXdsVRDjL5qU81lT2B/SyT2bsKu30q5o=
Date: Sat, 18 Jan 2025 16:34:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
Message-ID: <2025011840-flattop-reconcile-68ae@gregkh>
References: <20250115103547.522503305@linuxfoundation.org>
 <d0919169-ee06-4bdd-b2e3-2f776db90971@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0919169-ee06-4bdd-b2e3-2f776db90971@roeck-us.net>

On Sat, Jan 18, 2025 at 07:05:37AM -0800, Guenter Roeck wrote:
> On 1/15/25 02:36, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.125 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Various allmodconfig builds fail. Example:
> 
> Building csky:allmodconfig ... failed
> --------------
> Error log:
> ERROR: modpost: "xhci_suspend" [drivers/usb/host/xhci-pci.ko] undefined!
> ERROR: modpost: "xhci_resume" [drivers/usb/host/xhci-pci.ko] undefined!
> make[2]: [scripts/Makefile.modpost:127: Module.symvers] Error 1 (ignored)
> 
> This is because the backport of commit 9734fd7a2777 ("xhci: use pm_ptr()
> instead of #ifdef for CONFIG_PM conditionals") is wrong.
> 
> 9734fd7a2777:
> 
> -#ifdef CONFIG_PM
>         xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
>         xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
>         xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
> -#endif
> 
> 130eac4170859 (upstream version of 9734fd7a2777):
> 
> -#ifdef CONFIG_PM
> -       xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
> -       xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
> -       xhci_pci_hc_driver.pci_poweroff_late = xhci_pci_poweroff_late;
> -       xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
> -#endif
> +       xhci_pci_hc_driver.pci_suspend = pm_ptr(xhci_pci_suspend);
> +       xhci_pci_hc_driver.pci_resume = pm_ptr(xhci_pci_resume);
> +       xhci_pci_hc_driver.pci_poweroff_late = pm_ptr(xhci_pci_poweroff_late);
> +       xhci_pci_hc_driver.shutdown = pm_ptr(xhci_pci_shutdown);

Ron sent a fix for this:
	https://lore.kernel.org/r/20250118122409.4052121-1-re@w6rz.net

I'll get a new release out with this fix in it soon.

thanks,

greg k-h
