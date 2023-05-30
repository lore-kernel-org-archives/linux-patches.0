Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054B134C8
	for <patches@lists.linux.dev>; Tue, 30 May 2023 13:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB83CC433D2;
	Tue, 30 May 2023 13:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685451769;
	bh=0myB7ZzSiv1sBgjsqVcWKInjtO7tdteVEhxKRPjquP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oEL5MKNjqqVrvQrmgobFmv6aoC7S9tQ67O+m+bzsynRDDvyM63ymC07ZEqk8TK//h
	 9YUZEydkcLOSsic0XNyKQIW06BcQDITRRFujIqR/7gMT20DrO7zq25ptOiJ820KphU
	 flJ3fZHeArjGMZjQSK7uStnbVqjGlzcedlOJfd6w=
Date: Tue, 30 May 2023 14:02:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	l.sanfilippo@kunbus.com, jarkko@kernel.org
Subject: Re: Wrong/strange TPM patches was Re: [PATCH 6.1 000/119] 6.1.31-rc1
 review
Message-ID: <2023053014-sanctuary-attractor-13ed@gregkh>
References: <20230528190835.386670951@linuxfoundation.org>
 <ZHXUGdFMIcB5HL8s@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHXUGdFMIcB5HL8s@duo.ucw.cz>

On Tue, May 30, 2023 at 12:46:49PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.1.31 release.
> > There are 119 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> > Lino Sanfilippo <l.sanfilippo@kunbus.com>
> >     tpm, tpm_tis: Avoid cache incoherency in test for interrupts
> 
> Description on this one is wrong/confused. There's no cache problem in
> the code. Plus test_bit and friend already use bit number, so
> 
> -       bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
> +       bool itpm = test_bit(TPM_TIS_ITPM_WORKAROUND, &priv->flags);
> 
> @@ -87,6 +87,7 @@ enum tpm_tis_flags {
>         TPM_TIS_ITPM_WORKAROUND         = BIT(0),
>         TPM_TIS_INVALID_STATUS          = BIT(1),
>         TPM_TIS_DEFAULT_CANCELLATION    = BIT(2),
> +       TPM_TIS_IRQ_TESTED              = BIT(3),
>  };
> 
> this enum needs to go from BIT() to raw numbers.
> 
> You can just do return tpm_pm_resume();
> 
> > Jarkko Sakkinen <jarkko@kernel.org>
> >     tpm: Prevent hwrng from activating during resume
> 
> @@ -429,6 +431,14 @@ int tpm_pm_resume(struct device *dev)
>         if (chip == NULL)
>                 return -ENODEV;
>  
> +       chip->flags &= ~TPM_CHIP_FLAG_SUSPENDED;
> +
> +       /*
> +        * Guarantee that SUSPENDED is written last, so that hwrng does not
> +        * activate before the chip has been fully resumed.
> +        */
> +       wmb();
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
> 
> This code is confused. First, either you don't need memory barriers
> here, or you need real locking. Second, if you want to guarantee flags
> are written last, you need to put the barrier before the
> assignment. (But ... get rid of that confusion, first).

Care to submit patches to resolve this?  It's this way in Linus's tree
now from what I can tell, and these changes were needed for another
stable-marked change, so I'll leave them in for now.

thanks,

greg k-h
