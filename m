Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3471549F
	for <patches@lists.linux.dev>; Wed, 17 May 2023 08:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF939C433D2;
	Wed, 17 May 2023 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684311916;
	bh=D4xYj/ffWaf6yFGrSCStz7pFKHZB3TOO0GJfC1pppgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LqrWgC9VxAQC35NdfAAssqVV+TJ+7Jt2cSmTvmKGx0TDMOr/k05l765D5/26HGP79
	 Aa/lQOUjwerywVg66ukujU87tqdO4Ppp4s5py0opqWqPzt36Lg4R9TQySz1RtPaleH
	 LFcc1sDSn1O9ExvSq8juLoDwpWRZlsxEgrEAzV8M=
Date: Wed, 17 May 2023 10:25:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/282] 5.4.243-rc1 review
Message-ID: <2023051738-bullfrog-dreamily-79a4@gregkh>
References: <20230515161722.146344674@linuxfoundation.org>
 <739bd109-b32d-46f1-b382-e55f34efc11a@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <739bd109-b32d-46f1-b382-e55f34efc11a@roeck-us.net>

On Tue, May 16, 2023 at 08:52:13PM -0700, Guenter Roeck wrote:
> On Mon, May 15, 2023 at 06:26:18PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.243 release.
> > There are 282 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 455 pass: 454 fail: 1
> Failed tests:
> 	arm:sabrelite:multi_v7_defconfig:mtd2:mem256:net,default:imx6dl-sabrelite:rootfs
> 
> As far as I can see, the second SPI interface fails to instantiate.
> 
> [   21.491528] spi_imx 2008000.spi: bitbang start failed with -22
> 
> There are also various new warnings in clock code.
> 
> [   21.492631] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:986 clk_core_disable+0x124/0x2e4
> [   21.497524] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:845 clk_core_unprepare+0x268/0x388
> 
> The warnings in clock code are gone after reverting all changes introducing
> PM support for imx spi code. The boot failure is gone after reverting the
> gpio conversion. In total, I reverted the following patches to fix the
> boot and warning problems.
> 
> d6fcaa127cc6 Revert "spi: imx/fsl-lpspi: Convert to GPIO descriptors"
> 9783b21b591d Revert "spi: imx: enable runtime pm support"
> 4a8bdbf7462b Revert "spi: spi-imx: using pm_runtime_resume_and_get instead of pm_runtime_get_sync"
> e6c5f497ff35 Revert "spi: imx: Don't skip cleanup in remove's error path"
> d6ea758df74f Revert "spi: imx: fix runtime pm support for !CONFIG_PM"
> b9dbd028c970 Revert "spi: imx: fix reference leak in two imx operations"
> 
> Is this really 5.4 material ?

You are right, this isn't 5.4 material (and really not 5.10 either for
some of these changes.)  I'll go drop them all from 5.4.y and 5.10.y and
push out -rc2 releases soon.

Thanks for the testing and review.

greg k-h
