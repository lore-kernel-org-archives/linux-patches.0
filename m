Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D69EEC3
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 02:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724986355; cv=none; b=LXaeTRaRi4RKg9TLFhSC56ZbtRFuH7SoKwt4dyVJ3FHQ7uuwYSM1LbMmgmjmvcgQxx2aeLnhHAAkoq3dOo9uYjOWVjMa3BVFt8JfBbqcNfROvYLS8bb/D0a6tvjQqqE9Iq3+FkUCbRqVo1fLOkwux0v9Wd6B3Soeb9eG4r+9Ttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724986355; c=relaxed/simple;
	bh=gO0VkDPWz2eQLi/X3OVCfH44YmaB7V70WpyF004Ayas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5+sJ8am4snQo/t5tKXPiWHIFRYVlkFziZjg/OZ9BzhlUutrzf9f3eAcmtIqCVRr6jzzj8Ml9gfuPOeud4jhOqaVE206ZwUb0Ck2WZMhd0ImVRNYR9dR5G4CV0Q1R2svkl/Ikd9qV8YlI50pMGHx6xY7anL5F7TC00plGX1ddug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 0956072C8CC;
	Fri, 30 Aug 2024 05:52:31 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id EC86236D0184;
	Fri, 30 Aug 2024 05:52:30 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id B63A4360BF6F; Fri, 30 Aug 2024 05:52:30 +0300 (MSK)
Date: Fri, 30 Aug 2024 05:52:30 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Julia Lawall <julia.lawall@inria.fr>, Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>, 
	Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 6.1 202/321] fbdev: offb: replace of_node_put with
 __free(device_node)
Message-ID: <ycpomlflgfhwph5jebyx3atvgzwirx4lawbkia5qtulzwjibck@a6ohf5qvnjdx>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143845.922698611@linuxfoundation.org>
 <ppqadq365psk4abmtn7kpfvfxbps4qzhn3fz25ysqtzj72opob@jfzmajuq6dyw>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ppqadq365psk4abmtn7kpfvfxbps4qzhn3fz25ysqtzj72opob@jfzmajuq6dyw>

Greg,

On Fri, Aug 30, 2024 at 12:11:53AM GMT, Vitaly Chikunov wrote:
> Greg, Sasha,
> 
> On Tue, Aug 27, 2024 at 04:38:30PM GMT, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> We got v6.1.107 build error on ppc64le due to this commit, with:
> 
>     CC      drivers/video/fbdev/offb.o
>   drivers/video/fbdev/offb.c: In function 'offb_init_palette_hacks':
>   drivers/video/fbdev/offb.c:358:24: error: cleanup argument not a function
>     358 |                 struct device_node *pciparent __free(device_node) = of_get_parent(dp);
>         |                        ^~~~~~~~~~~
>   make[4]: *** [scripts/Makefile.build:250: drivers/video/fbdev/offb.o] Error 1
> 
> Where CONFIG_FB_OF is enabled. Perhaps, due to this commit not being picked:
> 
>   9448e55d032d ("of: Add cleanup.h based auto release via __free(device_node) markings")

I just tested, and cherry-picking this commit over 6.1.107 fixes the
build on ppc64le with CONFIG_FB_OF=y.

Thanks,


> 
> Thanks,
> 
> > 
> > ------------------
> > 
> > From: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
> > 
> > [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]
> > 
> > Replaced instance of of_node_put with __free(device_node)
> > to simplify code and protect against any memory leaks
> > due to future changes in the control flow.
> > 
> > Suggested-by: Julia Lawall <julia.lawall@inria.fr>
> > Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/video/fbdev/offb.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
> > index 91001990e351c..6f0a9851b0924 100644
> > --- a/drivers/video/fbdev/offb.c
> > +++ b/drivers/video/fbdev/offb.c
> > @@ -355,7 +355,7 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
> >  			par->cmap_type = cmap_gxt2000;
> >  	} else if (of_node_name_prefix(dp, "vga,Display-")) {
> >  		/* Look for AVIVO initialized by SLOF */
> > -		struct device_node *pciparent = of_get_parent(dp);
> > +		struct device_node *pciparent __free(device_node) = of_get_parent(dp);
> >  		const u32 *vid, *did;
> >  		vid = of_get_property(pciparent, "vendor-id", NULL);
> >  		did = of_get_property(pciparent, "device-id", NULL);
> > @@ -367,7 +367,6 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
> >  			if (par->cmap_adr)
> >  				par->cmap_type = cmap_avivo;
> >  		}
> > -		of_node_put(pciparent);
> >  	} else if (dp && of_device_is_compatible(dp, "qemu,std-vga")) {
> >  #ifdef __BIG_ENDIAN
> >  		const __be32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
> > -- 
> > 2.43.0
> > 
> > 
> > 
