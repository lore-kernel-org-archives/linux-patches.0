Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6D320EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE21C433D2;
	Thu, 16 Mar 2023 07:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678952930;
	bh=JEFMADeuG1V7EMneRFqDNSU+blM7hztH3hwVKntKQ9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wsaEETrRw0LarIQEKJMxHQ7ZS2nzUH2kOtB8J1ue0B0dV0FyhHIU23tLVGroThKdF
	 T/jQb4AByctuf6B9oSIIt2wwrWWjzDeerSQT6jBBDxpg3qIYUUckiuJLJviU/39zJ/
	 h2TT+SRfUZi9ucZT1SxnrDbFWNUlu4LorHH1cNwM=
Date: Thu, 16 Mar 2023 08:48:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Paterson <Chris.Paterson2@renesas.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"pavel@denx.de" <pavel@denx.de>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Message-ID: <ZBLJ3/qc2EfvF6vc@kroah.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <TYCPR01MB105881FA616DC8A6623140062B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB105881FA616DC8A6623140062B7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>

On Wed, Mar 15, 2023 at 02:12:46PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 15 March 2023 12:12
> > 
> > This is the start of the stable review cycle for the 4.19.278 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> 
> Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
> CI Pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/807195668
> 
> We (CIP) are seeing some build issues with Linux 4.19.278-rc1 (7cfb8ee7c98e).
> 
> 
> 1)
> In various arm, arm64 and x86 configurations we see:
> kernel/cgroup/cgroup.c: In function 'cgroup_attach_lock':
> kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus'; did you mean 'get_online_mems'? [-Werror=implicit-function-declaration]
>   get_online_cpus();
>   ^~~~~~~~~~~~~~~
>   get_online_mems
> kernel/cgroup/cgroup.c: In function 'cgroup_attach_unlock':
> kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus'; did you mean 'num_online_cpus'? [-Werror=implicit-function-declaration]
>   put_online_cpus();
>   ^~~~~~~~~~~~~~~
>   num_online_cpus
> 
> For example: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3938632173#L1274
> 
> Presumably this issue is caused by "cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock", but I haven't had a chance to revert and re-test.
> 
> 
> 2)
> For arm_multiconfig_v7 builds we're seeing a some errors when building the exynos5422 device trees:
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidhc1.dtb] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   DTC     arch/arm/boot/dts/hi3519-demb.dtb
>   DTC     arch/arm/boot/dts/hisi-x5hd2-dkb.dtb
> arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu3.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu4.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidxu4.dtb] Error 2
> make: *** [arch/arm/Makefile:348: dtbs] Error 2
> 
> Log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3938632189#L8634
> 
> Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re-test.
> 
> 

Thanks, these should all be fixed in the next -rc2.

greg k-h
