Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860E94219F6;
	Thu,  5 Feb 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770305210; cv=none; b=q/g7MwOVT8iU/hGs5iHjsToZ1g/wBK18/00SrjKOISppETz5jsa7QH/qios39nkWgKjPQyGwvw3kh0j4FnZVT08BXgHY+nBln8f1wSygBVuChtt4EiLqhvGzJn2Q5hmIyyRvjeS0XKhj+69p5z+CpKiBH9ZVmfOSyrCETWelTaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770305210; c=relaxed/simple;
	bh=NN8cm3i/8r9uydLEdgRyQiZH4e6mbGa5fOJ1unslUgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sRNlL8UGyryyVxFJBVWYNem0GIP6Xt8xKbMvx6nL8LURTYvBZrGrdMyGmpbLBo8K8DxoZQgyTFH4s7+Wzsqm/ZbvbmOtgO7FwXgtw91qo6+yL5ENQ64qjVdEtO9H6Yp/yH8sCZ2Hr3DlYlqAeCv10tJz57W8lSb6e+4hY72f17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2N0nkU3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N0nkU3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EAFC116D0;
	Thu,  5 Feb 2026 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770305210;
	bh=NN8cm3i/8r9uydLEdgRyQiZH4e6mbGa5fOJ1unslUgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2N0nkU3ujo7UObqAag0os8v+OsDb4PxINU7i2u5OD+jR2G8qkGLQCSZ/qm2VkVfyg
	 76iOUOhvgppcQyOGdLvHzK/Ix1I+89MyQrtTHMY5EOqNegx4k1awiXF1N2tX9ZDjZp
	 cr6scHXt2ODxoUCMr/Ha4vjQaizTyYd9aH0pB8aE=
Date: Thu, 5 Feb 2026 16:26:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>, Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.10 037/161] dmaengine: at_hdmac: fix device leak on
 of_dma_xlate()
Message-ID: <2026020537-salary-cloning-2358@gregkh>
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143853.096025132@linuxfoundation.org>
 <24fb4c47ea6f4c8025f6b0592088c1a9d10741a4.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fb4c47ea6f4c8025f6b0592088c1a9d10741a4.camel@decadent.org.uk>

On Thu, Feb 05, 2026 at 03:57:08PM +0100, Ben Hutchings wrote:
> On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit b9074b2d7a230b6e28caa23165e9d8bc0677d333 upstream.
> > 
> > Make sure to drop the reference taken when looking up the DMA platform
> > device during of_dma_xlate() when releasing channel resources.
> > 
> > Note that commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing
> > put_device() call in at_dma_xlate()") fixed the leak in a couple of
> > error paths but the reference is still leaking on successful allocation.
> > 
> > Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
> > Fixes: 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()")
> > Cc: stable@vger.kernel.org	# 3.10: 3832b78b3ec2
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://patch.msgid.link/20251117161258.10679-2-johan@kernel.org
> > Signed-off-by: Vinod Koul <vkoul@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/dma/at_hdmac.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > --- a/drivers/dma/at_hdmac.c
> > +++ b/drivers/dma/at_hdmac.c
> > @@ -1320,6 +1320,7 @@ static int atc_config(struct dma_chan *c
> >  		      struct dma_slave_config *sconfig)
> >  {
> >  	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
> > +	struct at_dma_slave	*atslave;
> >  
> >  	dev_vdbg(chan2dev(chan), "%s\n", __func__);
> >  
> 
> This hunk is being applied to the wrong function.  It should also be
> applied to atc_free_chan_resources() (but doesn't apply cleanly).

Already fixed in -rc2.

thanks,

greg k-h
