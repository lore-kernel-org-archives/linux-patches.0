Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E201D682;
	Wed,  6 Dec 2023 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCCJATZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E35C433C8;
	Wed,  6 Dec 2023 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701881575;
	bh=YL7LrE2gx5RrBMHsOk++cN+Fw8sVVDbEcm8TuSIc1ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hCCJATZCCv6MKDLvYS/EZE+5WksxgPxBvPJVWTzeI+bbfq5d5vxt+tY4P+tG0+UKs
	 yYy5qga6SoB0o42a9dUC2Tst2WRBAGTBiQs+QpxpU4Vq9wLPfhoYbTnpulGnLS5E4b
	 LVd7XE1EWVTZiPImZLZh453xGZJ4JzHDB2d25TNwcOixmTurzLABvgdGu+rH/gN537
	 q5XfZ8PBDqwPZABlX36ICCMaiOZbVRBNmFABb3AZz7niXogaVd9nwSvWWmTqtd84Rq
	 T89SYLMFDSTl7uclPSlu66ElYZ/o9dIGK2cI6VM6B1nQ9JAJtTJ82ZdNi71gX6R5su
	 b78S0twPMgyNA==
Date: Wed, 6 Dec 2023 09:52:53 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: richard@nod.at, johannes@sipsolutions.net, ndesaulniers@google.com,
	trix@redhat.com, linux-um@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] um: net: Fix return type of uml_net_start_xmit()
Message-ID: <20231206165253.GA819558@dev-arch.thelio-3990X>
References: <20231003-um-net-wifpts-v1-1-02888c634ee7@kernel.org>
 <20231205175302.GA536347@dev-arch.thelio-3990X>
 <62f83e94-27fc-1422-3999-1936e6b28625@cambridgegreys.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62f83e94-27fc-1422-3999-1936e6b28625@cambridgegreys.com>

On Wed, Dec 06, 2023 at 07:19:35AM +0000, Anton Ivanov wrote:
> 
> 
> On 05/12/2023 17:53, Nathan Chancellor wrote:
> > Ping? I would like to turn this warning on for W=1 and the kbuild test
> > robot flagged this instance. If the UML folks don't want to carry it,
> > could I get an ack so that it could go with the warning enablement in
> > the kbuild tree?
> > 
> > https://lore.kernel.org/20231002-enable-wincompatible-function-pointer-types-strict-w-1-v1-1-808ab955d42d@kernel.org/
> > 
> > On Tue, Oct 03, 2023 at 11:35:53AM -0700, Nathan Chancellor wrote:
> > > With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> > > indirect call targets are validated against the expected function
> > > pointer prototype to make sure the call target is valid to help mitigate
> > > ROP attacks. If they are not identical, there is a failure at run time,
> > > which manifests as either a kernel panic or thread getting killed. A
> > > warning in clang aims to catch these at compile time, which reveals:
> > > 
> > >    arch/um/drivers/net_kern.c:353:21: warning: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Wincompatible-function-pointer-types-strict]
> > >      353 |         .ndo_start_xmit         = uml_net_start_xmit,
> > >          |                                   ^~~~~~~~~~~~~~~~~~
> > >    1 warning generated.
> > > 
> > > ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> > > 'netdev_tx_t', not 'int'. Adjust the return type of uml_net_start_xmit()
> > > to match the prototype's to resolve the warning. While UML does not
> > > currently implement support for kCFI, it could in the future, which
> > > means this warning becomes a fatal CFI failure at run time.
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202310031340.v1vPh207-lkp@intel.com/
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >   arch/um/drivers/net_kern.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> > > index 3d7836c46507..cabcc501b448 100644
> > > --- a/arch/um/drivers/net_kern.c
> > > +++ b/arch/um/drivers/net_kern.c
> > > @@ -204,7 +204,7 @@ static int uml_net_close(struct net_device *dev)
> > >   	return 0;
> > >   }
> > > -static int uml_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > +static netdev_tx_t uml_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > >   {
> > >   	struct uml_net_private *lp = netdev_priv(dev);
> > >   	unsigned long flags;
> > > 
> > > ---
> > > base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
> > > change-id: 20231003-um-net-wifpts-14a7429c7524
> > > 
> > > Best regards,
> > > -- 
> > > Nathan Chancellor <nathan@kernel.org>
> > > 
> > 
> > 
> 
> Looks ok to me.
> Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Thanks a lot, I have included this change in v2 of the series to turn
this warning on for W=1, so Masahiro should be able to carry it:

https://lore.kernel.org/20231206-enable-wincompatible-function-pointer-types-strict-w-1-v2-1-91311b4c37b0@kernel.org

Cheers,
Nathan
