Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3053032275C;
	Wed, 20 Aug 2025 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706852; cv=none; b=PkzqrKIOOoP7/ZcdgILfgM878lfgv/klkqcCdFbDXtDYoAvXMYblANMZm0ZzTgiNG7ZgrwnwZyQSBAS+fgxy6mKHSKw5SDFeepkXSfP9uweNBun1Y8nPYXNgFVl568/UIw7wsWGe6vvET6WDSDxpoqDJa08mOZCGgpeg+P9nYbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706852; c=relaxed/simple;
	bh=KuHQlhLloiL8qIhruC+SjKavcvsQQojmdPAzwfSpvyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCwtv4wwb1JWARixOaqnSCFQ0/SMLZDuhkusfT1IfnJSOg/DJpotY83FbXZe8WWufuaB8+4PBXkWQwkcHHoVMOOu2M1fwz7Qlnoz4HS2V2eDOX5N7P252dY0NfY4t9Dn6Kyc4yCcM/m8RxVuW1ERXrC5TSTmEMvF0/I4fNn43iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fyIu/H5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fyIu/H5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970EBC4CEE7;
	Wed, 20 Aug 2025 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755706852;
	bh=KuHQlhLloiL8qIhruC+SjKavcvsQQojmdPAzwfSpvyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fyIu/H5lPoivJ0GpsC1AJXOXeBc5ZNxmaljT7ateChUzqYChxTxsKShz8KfHRwQRf
	 Pr1O+nyJWvhgbpQjH2eF1goyuLJef40u9aVHzS2I0PX9EyBYDQwJchu8Is1mXnDWTG
	 Ze1D04DVSpcHYQwTCZQv47IfbSNErIL+i6Kw6Kio0bKA7+7mt1gi+OcVlv/7xMW7jl
	 mRTGXyyeNtXidaXNOxCMPUep48ujVX1r6WsrFY6JKuGFGH3KdW3q+limHUd60x43IC
	 ATn3GVRAIgLqmFnsgrh9FqLHw+se7fNGTYPFz/UsInmjDBqhthAopD5rhDG1LdFJlg
	 ngrjppmPesKNw==
Date: Wed, 20 Aug 2025 09:20:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: =?iso-8859-1?Q?Beno=EEt?= Monin <benoit.monin@bootlin.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] mmc: sdhci-cadence: Fix -Wuninitialized in
 sdhci_cdns_tune_blkgap()
Message-ID: <20250820162048.GC3805667@ax162>
References: <20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-v1-1-94aa2d0c438a@kernel.org>
 <2560300.XAFRqVoOGU@benoit.monin>
 <aKWmvWTtQ_QZYgEm@stanley.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKWmvWTtQ_QZYgEm@stanley.mountain>

On Wed, Aug 20, 2025 at 01:43:09PM +0300, Dan Carpenter wrote:
> On Wed, Aug 20, 2025 at 10:07:35AM +0200, Benoît Monin wrote:
> > > --- a/drivers/mmc/host/sdhci-cadence.c
> > > +++ b/drivers/mmc/host/sdhci-cadence.c
> > > @@ -288,13 +288,12 @@ static int sdhci_cdns_tune_blkgap(struct mmc_host *mmc)
> > >  	void __iomem *hrs38_reg = priv->hrs_addr + SDHCI_CDNS_HRS38;
> > >  	int ret;
> > >  	u32 gap;
> > > -	u32 hrs37_mode;
> > >  
> > >  	/* Currently only needed in HS200 mode */
> > >  	if (host->timing != MMC_TIMING_MMC_HS200)
> > >  		return 0;
> > >  
> > > -	writel(hrs37_mode, hrs37_reg);
> > > +	writel(SDHCI_CDNS_HRS37_MODE_MMC_HS200, hrs37_reg);
> > >  
> > >  	for (gap = 0; gap <= SDHCI_CDNS_HRS38_BLKGAP_MAX; gap++) {
> > >  		writel(gap, hrs38_reg);
> > > 
> > Thanks for the catch!
> > 
> > I don't get how gcc does not raise a warning here, only clang does. I
> > did build with gcc-11 and gcc-15 and they don't complain about this
> > uninitialized variable.
> > 
> 
> We disabled uninitialized variable checking on GCC.  It was too crazy
> and especially if we want to use -Werror.
> 
> Smatch also detects this bug.

Technically, -Wuninitialized is on for GCC as well but as soon as there
is control flow between the declaration of the variable and its usage,
it gets changed into -Wmaybe-uninitialized :/

In file included from arch/arm64/include/asm/io.h:288,
                 from include/linux/io.h:12,
                 from include/linux/iopoll.h:14,
                 from drivers/mmc/host/sdhci-cadence.c:9:
In function 'writel',
    inlined from 'sdhci_cdns_tune_blkgap' at drivers/mmc/host/sdhci-cadence.c:297:2,
    inlined from 'sdhci_cdns_execute_tuning' at drivers/mmc/host/sdhci-cadence.c:352:9:
include/asm-generic/io.h:276:9: error: 'hrs37_mode' may be used uninitialized [-Werror=maybe-uninitialized]
  276 |         log_write_mmio(value, 32, addr, _THIS_IP_, _RET_IP_);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/mmc/host/sdhci-cadence.c: In function 'sdhci_cdns_execute_tuning':
drivers/mmc/host/sdhci-cadence.c:291:13: note: 'hrs37_mode' was declared here
  291 |         u32 hrs37_mode;
      |             ^~~~~~~~~~

vs

diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index a2a4a5b0ab96..b968c0fb925d 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -290,12 +290,12 @@ static int sdhci_cdns_tune_blkgap(struct mmc_host *mmc)
        u32 gap;
        u32 hrs37_mode;

+       writel(hrs37_mode, hrs37_reg);
+
        /* Currently only needed in HS200 mode */
        if (host->timing != MMC_TIMING_MMC_HS200)
                return 0;

-       writel(hrs37_mode, hrs37_reg);
-
        for (gap = 0; gap <= SDHCI_CDNS_HRS38_BLKGAP_MAX; gap++) {
                writel(gap, hrs38_reg);
                ret = mmc_read_tuning(mmc, 512, 32);

In file included from arch/arm64/include/asm/io.h:288,
                 from include/linux/io.h:12,
                 from include/linux/iopoll.h:14,
                 from drivers/mmc/host/sdhci-cadence.c:9:
drivers/mmc/host/sdhci-cadence.c: In function 'sdhci_cdns_tune_blkgap':
include/asm-generic/io.h:273:16: error: 'hrs37_mode' is used uninitialized [-Werror=uninitialized]
  273 | #define writel writel
drivers/mmc/host/sdhci-cadence.c:293:9: note: in expansion of macro 'writel'
  293 |         writel(hrs37_mode, hrs37_reg);
      |         ^~~~~~
drivers/mmc/host/sdhci-cadence.c:291:13: note: 'hrs37_mode' was declared here
  291 |         u32 hrs37_mode;
      |             ^~~~~~~~~~

It would be nice if GCC could adopt clang's semantics of "uninitialized
when used _here_" for -Wuninitalized versus the current scheme of
converting it to a "may be used uninitialized" warning.

Cheers,
Nathan
