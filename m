Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F575804;
	Thu, 18 Jul 2024 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721289585; cv=none; b=sPGV+zP16b9dzVxNvxjaL8Wo2ynjhkUbIK0uuSkFaqbWKNeU+Ys9AcnifE9s7GDF9voNllI93GcCr1/khj8nGXU0cCk3ckKz5gyLqg8O7A9cI1g+ucrwYnKgBCXOaEwRvxsogH5gkorNfvQ+4SHbGmirryC4zxEF6YeiHGSl/y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721289585; c=relaxed/simple;
	bh=fYYt3PBZKlFRih1qucZWWe+HIkyIRGkcq0i3FDNnBo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOc/6ZEYfHZyVcWBY6tpOnlWsKDr8rNRl9u76OXDsFEYjXmG19mriIYKLej+3kgaMzhWPllO/L0Z2Z/jiVVR8DlguuiIRlM98lBApBK+ouozcRNAxkByku2UrValvr98Eri3jny2vYZzKearA3iysujMCd7xDeiyCqtG8vpttQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFSMBzvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFSMBzvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EA8C116B1;
	Thu, 18 Jul 2024 07:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721289584;
	bh=fYYt3PBZKlFRih1qucZWWe+HIkyIRGkcq0i3FDNnBo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bFSMBzvgKuCkdcx0I0cwJ5g00NGJ0jXQsYJM0wiyDxmerZ7Qqy7Sj7DT6bsnocvyG
	 N3qWDOgwzOi66XdpxXVr7OCL93Alf5Yv2eH4FB4Brox+5zcnrkv9Psk2FvOpMv+Nkv
	 wHKOd7AAB8JSNfDPLZUo6ZqW2i058yD35Yt7t4mw=
Date: Thu, 18 Jul 2024 09:59:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 015/143] dsa: lan9303: Fix mapping between DSA port
 number and PHY address
Message-ID: <2024071814-constant-passably-0f63@gregkh>
References: <20240716152755.980289992@linuxfoundation.org>
 <20240716152756.575531368@linuxfoundation.org>
 <20240717131800.s3xygkvilgiwopfe@skbuf>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717131800.s3xygkvilgiwopfe@skbuf>

On Wed, Jul 17, 2024 at 04:18:00PM +0300, Vladimir Oltean wrote:
> Hi Greg,
> 
> On Tue, Jul 16, 2024 at 05:30:11PM +0200, Greg Kroah-Hartman wrote:
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> 
> This patch has a trivial conflict, in the context:
> 
> > diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> > index 666b4d766c005..1f7000f90bb78 100644
> > --- a/drivers/net/dsa/lan9303-core.c
> > +++ b/drivers/net/dsa/lan9303-core.c
> >  	chip->ds->priv = chip;
> >  	chip->ds->ops = &lan9303_switch_ops;
> >  	chip->ds->phylink_mac_ops = &lan9303_phylink_mac_ops;
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         here - this line is simply not present in stable kernels
> 
> > -	base = chip->phy_addr_base;
> > -	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1 + base, base);
> > +	chip->ds->phys_mii_mask = GENMASK(LAN9303_NUM_PORTS - 1, 0);
> >  
> >  	return dsa_register_switch(chip->ds);
> >  }
> 
> But I don't advise backporting commits dd0c9855b413 ("net: dsa:
> introduce dsa_phylink_to_port()") and cae425cb43fe ("net: dsa: allow DSA
> switch drivers to provide their own phylink mac ops") in order to get
> that one line into this patch's context - because that line is just noise
> as far as this patch is concerned.
> 
> I'm confused of what happened here.
> 
> It looks like who generated these patches _knew_ that already, because
> when the patch was backported for 6.6, that conflict was properly
> resolved (notice how the chip->ds->phylink_mac_ops is not present in the
> context here: https://lore.kernel.org/stable/20240716152751.831607687@linuxfoundation.org/).
> 
> But following that approach all the way to the end, "[PATCH 6.6 012/121]
> net: dsa: introduce dsa_phylink_to_port()" (https://lore.kernel.org/stable/20240716152751.792628497@linuxfoundation.org/)
> has no reason to exist! It is marked as a Stable-dep-of: the bug fix,
> but said bug fix was not backported in its original form anyway.
> Please drop it, it serves no purpose.
> 
> I would advise dropping the following Stable-dep-of: patches for 6.9:
> https://lore.kernel.org/stable/20240716152756.461086951@linuxfoundation.org/
> https://lore.kernel.org/stable/20240716152756.498971328@linuxfoundation.org/
> 
> and do the same for 6.9 as was done for 6.6: respin the patch without
> the "chip->ds->phylink_mac_ops" line in the context.

You're right, I've now dropped these "dep-of" patches for 6.9.y and the
one for 6.6.y as it wasn't needed their either.

thanks for the review!

greg k-h
